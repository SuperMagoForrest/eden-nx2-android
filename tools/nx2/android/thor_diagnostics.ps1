# Eden SX2A — Thor runtime diagnostics + safety watchdog (no root).
# Output under F:\DEV\EDEN_SX2A\logs\diag-<stamp>\
param(
  [int]$DurationSec = 0,
  [int]$IntervalSec = 5,
  [switch]$LaunchPackage,
  [double]$AbortBatteryTempC = 70.0,
  [double]$AbortSocTempC = 70.0,
  [string]$Serial = "",
  [string]$OutRoot = "F:\DEV\EDEN_SX2A\logs",
  [switch]$CollectExitInfo,
  [int]$CommandTimeoutSec = 20
)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\env.win.ps1"

function Invoke-Adb {
  param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
  $all = @()
  if ($Serial) { $all += @("-s", $Serial) }
  $all += $Args
  & $ADB @all
}

function Invoke-AdbTimed {
  param([string[]]$Args, [int]$TimeoutSec = $CommandTimeoutSec)
  $job = Start-Job -ScriptBlock {
    param($Adb, $Serial, $ArgList)
    $a = @()
    if ($Serial) { $a += @("-s", $Serial) }
    $a += $ArgList
    & $Adb @a 2>&1 | Out-String
  } -ArgumentList $ADB, $Serial, $Args
  if (-not (Wait-Job $job -Timeout $TimeoutSec)) {
    Stop-Job $job -ErrorAction SilentlyContinue
    Remove-Job $job -Force -ErrorAction SilentlyContinue
    return @{ ok = $false; output = ""; timed_out = $true }
  }
  $out = Receive-Job $job
  Remove-Job $job -Force -ErrorAction SilentlyContinue
  return @{ ok = $true; output = [string]$out; timed_out = $false }
}

function Get-TempCFromBattery {
  $raw = Invoke-Adb shell dumpsys battery 2>$null | Select-String "temperature:"
  if (-not $raw) { return $null }
  $t = [int](($raw.ToString() -split ":")[1].Trim())
  return [math]::Round($t / 10.0, 1)
}

function Get-ThermalStatus {
  $line = Invoke-Adb shell dumpsys thermalservice 2>$null | Select-String "Thermal Status:"
  if (-not $line) { return $null }
  return (($line.ToString() -split ":")[1].Trim())
}

function Get-SocTempCandidates {
  # Best-effort without root: thermal zone type+temp when readable.
  $zones = @()
  $list = Invoke-AdbTimed @("shell", "toybox", "ls", "/sys/class/thermal") 
  if (-not $list.ok) { return $zones }
  $names = ($list.output -split "\s+") | Where-Object { $_ -like "thermal_zone*" }
  foreach ($z in $names) {
    $typeOut = Invoke-AdbTimed @("shell", "cat", "/sys/class/thermal/$z/type") -TimeoutSec 5
    $tempOut = Invoke-AdbTimed @("shell", "cat", "/sys/class/thermal/$z/temp") -TimeoutSec 5
    if (-not $typeOut.ok -or -not $tempOut.ok) { continue }
    $type = ($typeOut.output -replace "`r|`n", "").Trim()
    $raw = ($tempOut.output -replace "`r|`n", "").Trim()
    if ($raw -notmatch "^-?\d+$") { continue }
    $milli = [int64]$raw
    # Android thermal zones are usually millidegrees C.
    $c = if ([math]::Abs($milli) -gt 200) { [math]::Round($milli / 1000.0, 1) } else { [double]$milli }
    if ($c -lt 1 -or $c -gt 120) { continue }
    $zones += [ordered]@{ zone = $z; type = $type; temp_c = $c }
  }
  return $zones
}

function Get-PrimarySocTempC($zones) {
  if (-not $zones -or $zones.Count -eq 0) { return $null }
  $prefer = @("cpu", "soc", "skin", "msm", "xo", "quiet")
  foreach ($p in $prefer) {
    $hit = $zones | Where-Object { $_.type -match $p } | Select-Object -First 1
    if ($hit) { return $hit.temp_c }
  }
  return ($zones | Sort-Object temp_c -Descending | Select-Object -First 1).temp_c
}

function Parse-MeminfoApp([string]$mi) {
  if ([string]::IsNullOrWhiteSpace($mi) -or $mi -match "No process found") {
    return @{ running = $false }
  }
  $procPid = $null
  if ($mi -match "\*\* MEMINFO in pid (\d+)") { $procPid = [int]$Matches[1] }
  $activities = $null
  if ($mi -match "Activities:\s+(\d+)") { $activities = [int]$Matches[1] }
  $pss = $null; $rss = $null; $swap = $null
  # App Summary TOTAL line carries PSS/RSS/SWAP on one row — do not take the first digit blindly.
  if ($mi -match "TOTAL PSS:\s+([\d.,]+)\s+TOTAL RSS:\s+([\d.,]+)(?:\s+TOTAL SWAP(?: PSS)?(?: \(KB\))?:\s+([\d.,]+))?") {
    $pss = [int64]($Matches[1] -replace "[^\d]", "")
    $rss = [int64]($Matches[2] -replace "[^\d]", "")
    if ($Matches[3]) { $swap = [int64]($Matches[3] -replace "[^\d]", "") }
  }
  $hostAvail = Invoke-Adb shell cat /proc/meminfo 2>$null | Select-String "MemAvailable:"
  $availKb = $null
  if ($hostAvail -and ($hostAvail.ToString() -match "(\d+)")) { $availKb = [int64]$Matches[1] }
  return @{
    running = $true
    pid = $procPid
    activities = $activities
    emulation_likely = ($activities -ge 2)
    total_pss_kb = $pss
    total_rss_kb = $rss
    total_swap_pss_kb = $swap
    mem_available_kb = $availKb
    raw = $mi
  }
}

function Get-MemSnapshot {
  $res = Invoke-AdbTimed @("shell", "dumpsys", "meminfo", $PKG)
  if (-not $res.ok) {
    return @{ running = $false; telemetry_lost = $true; timed_out = $res.timed_out }
  }
  return Parse-MeminfoApp $res.output
}

function Get-PackageExitInfo {
  $res = Invoke-AdbTimed @("shell", "dumpsys", "activity", "exit-info") -TimeoutSec 45
  if (-not $res.ok) { return $null }
  $lines = $res.output -split "`n"
  $capture = $false
  $buf = New-Object System.Collections.Generic.List[string]
  foreach ($ln in $lines) {
    if ($ln -match "package:\s+$([regex]::Escape($PKG))") { $capture = $true; $buf.Clear(); $buf.Add($ln); continue }
    if ($capture) {
      if ($ln -match "^\s*package:\s+" -and $ln -notmatch [regex]::Escape($PKG)) { break }
      $buf.Add($ln)
      if ($buf.Count -gt 80) { break }
    }
  }
  return ($buf -join "`n")
}

function Stop-WorkloadVerified {
  param([string]$Reason)
  $before = Get-MemSnapshot
  # Prefer graceful: move task back / finish emulation activity without wiping data.
  Invoke-Adb shell am task lock stop 2>$null | Out-Null
  Invoke-Adb shell input keyevent KEYCODE_BACK 2>$null | Out-Null
  Start-Sleep -Seconds 1
  Invoke-Adb shell input keyevent KEYCODE_HOME 2>$null | Out-Null
  Start-Sleep -Seconds 2
  $mid = Get-MemSnapshot
  $stopped = $false
  if (-not $mid.running) { $stopped = $true }
  elseif ($mid.emulation_likely -eq $false -and $mid.total_pss_kb -lt 400000) { $stopped = $true }
  if (-not $stopped -and $mid.running) {
    # Soft stop of emulation activity only — does not pm clear.
    Invoke-Adb shell am force-stop $PKG 2>$null | Out-Null
    Start-Sleep -Seconds 2
    $afterForce = Get-MemSnapshot
    $stopped = -not [bool]$afterForce.running
    $mid = $afterForce
  }
  return [ordered]@{
    reason = $Reason
    stopped = $stopped
    before_pid = $before.pid
    after_pid = $mid.pid
    after_running = [bool]$mid.running
    after_pss_kb = $mid.total_pss_kb
    after_activities = $mid.activities
  }
}

function Classify-Session {
  param($Samples, $ExitInfoText, $AbortInfo)
  $classification = "UNKNOWN"
  $detail = ""
  if ($AbortInfo) {
    $classification = "WATCHDOG_ABORT"
    $detail = $AbortInfo.reason
  } elseif ($ExitInfoText -match "reason=3 \(LOW_MEMORY\)") {
    $classification = "LMKD_LOW_MEMORY"
    $detail = "ApplicationExitInfo LOW_MEMORY"
  } elseif ($ExitInfoText -match "reason=2 \(SIGNALED\)") {
    $classification = "NATIVE_SIGNAL"
    $detail = "ApplicationExitInfo SIGNALED"
  } elseif ($ExitInfoText -match "reason=6 \(CRASH\)") {
    $classification = "JAVA_CRASH"
    $detail = "ApplicationExitInfo CRASH"
  } elseif ($ExitInfoText -match "reason=10 \(USER REQUESTED\)") {
    $classification = "USER_OR_INSTALL_STOP"
    $detail = "force-stop / install"
  } else {
    $pids = @($Samples | Where-Object { $_.pid } | ForEach-Object { $_.pid } | Select-Object -Unique)
    if ($pids.Count -gt 1) {
      $classification = "PROCESS_RESTART"
      $detail = "pid changes: $($pids -join ',')"
    } elseif (($Samples | Where-Object { $_.running }).Count -gt 0) {
      $classification = "ALIVE_OR_CLEAN_EXIT"
      $detail = "process remained or exited without recorded kill"
    }
  }
  return [ordered]@{ classification = $classification; detail = $detail }
}

# --- Self-test fixtures (parser) ---
function Test-MeminfoParser {
  $fixture = @"
** MEMINFO in pid 18650 [dev.eden.nx2.relWithDebInfo] **
           TOTAL PSS:  5144597            TOTAL RSS:  5465248      TOTAL SWAP (KB):  1943940
 Objects
              Activities:        2
"@
  $p = Parse-MeminfoApp $fixture
  if ($p.total_pss_kb -ne 5144597) { throw "PSS parse failed: $($p.total_pss_kb)" }
  if ($p.total_rss_kb -ne 5465248) { throw "RSS parse failed: $($p.total_rss_kb)" }
  if ($p.total_swap_pss_kb -ne 1943940) { throw "SWAP parse failed: $($p.total_swap_pss_kb)" }
  if ($p.pid -ne 18650) { throw "PID parse failed" }
  if ($p.activities -ne 2) { throw "Activities parse failed" }
  Write-Host "Parser fixture OK"
}

Test-MeminfoParser

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$run = Join-Path $OutRoot "diag-$stamp"
New-Item -ItemType Directory -Force -Path $run | Out-Null
Write-Host "Diagnostics dir: $run"

$devCheck = Invoke-Adb devices -l | Out-String
if ($devCheck -notmatch "device ") { throw "No ADB device online. devices=`n$devCheck" }

$props = @{
  model = (Invoke-Adb shell getprop ro.product.model).Trim()
  device = (Invoke-Adb shell getprop ro.product.device).Trim()
  manufacturer = (Invoke-Adb shell getprop ro.product.manufacturer).Trim()
  android_release = (Invoke-Adb shell getprop ro.build.version.release).Trim()
  sdk = (Invoke-Adb shell getprop ro.build.version.sdk).Trim()
  hardware = (Invoke-Adb shell getprop ro.hardware).Trim()
  vulkan = (Invoke-Adb shell getprop ro.hardware.vulkan).Trim()
  fingerprint = (Invoke-Adb shell getprop ro.build.fingerprint).Trim()
}
$pkgDump = Invoke-Adb shell dumpsys package $PKG 2>$null | Out-String
$versionName = if ($pkgDump -match "versionName=([^\s]+)") { $Matches[1] } else { $null }
$versionCode = if ($pkgDump -match "versionCode=(\d+)") { $Matches[1] } else { $null }
$apkPath = ((Invoke-Adb shell pm path $PKG) | Select-Object -First 1) -replace "package:",""
$apkSha = $null
if ($apkPath) { $apkSha = ((Invoke-Adb shell "sha256sum '$apkPath'") | Out-String).Trim() }

$meminfoHost = Invoke-Adb shell cat /proc/meminfo | Out-String
$battery = Invoke-Adb shell dumpsys battery | Out-String
$thermal = Invoke-Adb shell dumpsys thermalservice 2>$null | Out-String
$zones = Get-SocTempCandidates
$zones | ConvertTo-Json -Depth 4 | Set-Content (Join-Path $run "thermal_zones.json") -Encoding UTF8

$identity = [ordered]@{
  captured_at = (Get-Date).ToString("o")
  adb_serial = $Serial
  adb_devices = $devCheck.Trim()
  props = $props
  package = $PKG
  versionName = $versionName
  versionCode = $versionCode
  apk_path = $apkPath
  apk_sha256_device = $apkSha
  battery_temp_c = Get-TempCFromBattery
  thermal_status = Get-ThermalStatus
  soc_temp_c = Get-PrimarySocTempC $zones
  thermal_zones = $zones
  notes = @(
    "Battery temperature is NOT the AYN SoC dashboard sensor.",
    "Prefer thermal_zones.json / soc_temp_c for SoC-comparable values when readable.",
    "FPS overlay on Thor is NOT treated as guest-produced frames.",
    "System RAM includes other apps; use dumpsys meminfo PSS for emulator attribution.",
    "Crash classification uses ApplicationExitInfo when available."
  )
}
$identity | ConvertTo-Json -Depth 8 | Set-Content (Join-Path $run "identity.json") -Encoding UTF8
$devCheck | Set-Content (Join-Path $run "devices.txt")
$props.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" } | Set-Content (Join-Path $run "props.txt")
$pkgDump | Set-Content (Join-Path $run "package.txt")
$meminfoHost | Set-Content (Join-Path $run "meminfo_host.txt")
$battery | Set-Content (Join-Path $run "battery.txt")
$thermal | Set-Content (Join-Path $run "thermal.txt")
if ($apkSha) { $apkSha | Set-Content (Join-Path $run "apk_sha256.txt") }

if ($CollectExitInfo -or $true) {
  $ei = Get-PackageExitInfo
  if ($ei) { $ei | Set-Content (Join-Path $run "exit_info_package.txt") -Encoding UTF8 }
}

if ($LaunchPackage) {
  Invoke-Adb shell monkey -p $PKG -c android.intent.category.LAUNCHER 1 | Out-Null
  Start-Sleep -Seconds 3
}

$samples = @()
$csv = Join-Path $run "samples.csv"
"timestamp,battery_temp_c,soc_temp_c,thermal_status,running,pid,activities,emulation_likely,total_pss_kb,total_rss_kb,total_swap_pss_kb,mem_available_kb,telemetry_lost,abort" |
  Set-Content $csv -Encoding UTF8

$deadline = if ($DurationSec -gt 0) { (Get-Date).AddSeconds($DurationSec) } else { $null }
$iter = 0
$abortInfo = $null
$prevPid = $null
do {
  $iter++
  $batt = Get-TempCFromBattery
  $th = Get-ThermalStatus
  # Thermal zones are expensive over ADB — refresh every ~30s.
  if (($iter -eq 1) -or ($iter % [math]::Max(1, [int](30 / [math]::Max($IntervalSec,1))) -eq 0)) {
    $zonesNow = Get-SocTempCandidates
    $script:lastSoc = Get-PrimarySocTempC $zonesNow
  }
  $soc = $script:lastSoc
  $mem = Get-MemSnapshot
  $abort = $false
  $abortReason = $null
  if ($null -ne $batt -and $batt -ge $AbortBatteryTempC) {
    $abort = $true; $abortReason = "battery_temp"
  }
  if ($null -ne $soc -and $soc -ge $AbortSocTempC) {
    $abort = $true; $abortReason = "soc_temp"
  }
  if ($th -match "^[3-9]$") { $abort = $true; $abortReason = "thermal_status_severe" }
  if ($mem.telemetry_lost) { $abort = $true; $abortReason = "telemetry_lost" }

  if ($prevPid -and $mem.pid -and ($mem.pid -ne $prevPid)) {
    Write-Warning "PID changed $($prevPid) -> $($mem.pid) (possible crash/restart)"
  }
  if ($mem.pid) { $prevPid = $mem.pid }

  $row = [ordered]@{
    timestamp = (Get-Date).ToString("o")
    battery_temp_c = $batt
    soc_temp_c = $soc
    thermal_status = $th
    running = [bool]$mem.running
    pid = $mem.pid
    activities = $mem.activities
    emulation_likely = [bool]$mem.emulation_likely
    total_pss_kb = $mem.total_pss_kb
    total_rss_kb = $mem.total_rss_kb
    total_swap_pss_kb = $mem.total_swap_pss_kb
    mem_available_kb = $mem.mem_available_kb
    telemetry_lost = [bool]$mem.telemetry_lost
    abort = $abort
  }
  $samples += $row
  "$($row.timestamp),$($row.battery_temp_c),$($row.soc_temp_c),$($row.thermal_status),$($row.running),$($row.pid),$($row.activities),$($row.emulation_likely),$($row.total_pss_kb),$($row.total_rss_kb),$($row.total_swap_pss_kb),$($row.mem_available_kb),$($row.telemetry_lost),$($row.abort)" |
    Add-Content $csv

  if ($mem.running -and $mem.raw) {
    $mem.raw | Set-Content (Join-Path $run ("meminfo_app_{0:D3}.txt" -f $iter))
  }

  if ($abort) {
    Write-Warning "Watchdog abort: reason=$abortReason batt=$batt soc=$soc thermal=$th"
    $stop = Stop-WorkloadVerified -Reason $abortReason
    $abortInfo = [ordered]@{
      aborted = $true
      reason = $abortReason
      battery_temp_c = $batt
      soc_temp_c = $soc
      thermal_status = $th
      stop = $stop
    }
    $abortInfo | ConvertTo-Json -Depth 6 | Set-Content (Join-Path $run "watchdog_abort.json")
    break
  }

  if ($null -eq $deadline) { break }
  if ((Get-Date) -ge $deadline) { break }
  Start-Sleep -Seconds $IntervalSec
} while ($true)

$exitAfter = Get-PackageExitInfo
if ($exitAfter) { $exitAfter | Set-Content (Join-Path $run "exit_info_package_after.txt") -Encoding UTF8 }

$classification = Classify-Session -Samples $samples -ExitInfoText $exitAfter -AbortInfo $abortInfo
$classification | ConvertTo-Json | Set-Content (Join-Path $run "crash_classification.json") -Encoding UTF8

@{ sample_count = $samples.Count; samples = $samples; classification = $classification } |
  ConvertTo-Json -Depth 8 | Set-Content (Join-Path $run "samples.json") -Encoding UTF8

# Timeline markdown
$tl = @("# Timeline", "")
foreach ($s in $samples) {
  $tl += ("- {0} pid={1} act={2} emu={3} PSS_MB={4} RSS_MB={5} avail_MB={6} batt={7} soc={8}" -f `
    $s.timestamp, $s.pid, $s.activities, $s.emulation_likely,
    $(if ($s.total_pss_kb) { [math]::Round($s.total_pss_kb/1024,1) } else { "-" }),
    $(if ($s.total_rss_kb) { [math]::Round($s.total_rss_kb/1024,1) } else { "-" }),
    $(if ($s.mem_available_kb) { [math]::Round($s.mem_available_kb/1024,1) } else { "-" }),
    $s.battery_temp_c, $s.soc_temp_c)
}
$tl -join "`n" | Set-Content (Join-Path $run "TIMELINE.md") -Encoding UTF8

$summary = @"
# Thor diagnostics summary

- Dir: $run
- Device: $($props.manufacturer) $($props.model) ($($props.device))
- Android: $($props.android_release) / SDK $($props.sdk)
- Package: $PKG $versionName ($versionCode)
- APK SHA256: $apkSha
- Samples: $($samples.Count)
- AbortBatteryTempC: $AbortBatteryTempC / AbortSocTempC: $AbortSocTempC
- Classification: $($classification.classification) — $($classification.detail)

Sensors: battery dumpsys is NOT the AYN dashboard SoC reading. See thermal_zones.json.
"@
$summary | Set-Content (Join-Path $run "SUMMARY.md") -Encoding UTF8
Write-Host $summary
Write-Host "Done: $run"
