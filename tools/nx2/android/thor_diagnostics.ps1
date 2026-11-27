# Eden SX2A — consolidated Thor runtime diagnostics (no root).
# Output under F:\DEV\EDEN_SX2A\logs\diag-<stamp>\ (machine JSON + readable summaries).
param(
  [int]$DurationSec = 0,
  [int]$IntervalSec = 5,
  [switch]$LaunchPackage,
  [double]$AbortTempC = 70.0,
  [string]$OutRoot = "F:\DEV\EDEN_SX2A\logs"
)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\env.win.ps1"

function Get-TempCFromBattery {
  $raw = & $ADB shell dumpsys battery 2>$null | Select-String "temperature:"
  if (-not $raw) { return $null }
  $t = [int](($raw -split ":")[1].Trim())
  return [math]::Round($t / 10.0, 1)
}

function Get-ThermalStatus {
  $line = & $ADB shell dumpsys thermalservice 2>$null | Select-String "Thermal Status:"
  if (-not $line) { return $null }
  return (($line -split ":")[1].Trim())
}

function Get-MemSnapshot {
  $mi = & $ADB shell dumpsys meminfo $PKG 2>$null
  if ($mi -match "No process found") {
    return @{ running = $false }
  }
  $pss = ($mi | Select-String "TOTAL PSS:") 
  $rss = ($mi | Select-String "TOTAL RSS:")
  $swap = ($mi | Select-String "TOTAL SWAP PSS:")
  function Parse-Kb($m) {
    if (-not $m) { return $null }
    if ($m.Line -match "([\d,]+)") { return [int64]($Matches[1] -replace ",","") }
    return $null
  }
  $hostAvail = (& $ADB shell cat /proc/meminfo) | Select-String "MemAvailable:"
  $availKb = $null
  if ($hostAvail -match "(\d+)") { $availKb = [int64]$Matches[1] }
  return @{
    running = $true
    total_pss_kb = (Parse-Kb $pss)
    total_rss_kb = (Parse-Kb $rss)
    total_swap_pss_kb = (Parse-Kb $swap)
    mem_available_kb = $availKb
  }
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$run = Join-Path $OutRoot "diag-$stamp"
New-Item -ItemType Directory -Force -Path $run | Out-Null
Write-Host "Diagnostics dir: $run"

# --- Identity ---
$devices = & $ADB devices -l | Out-String
$props = @{
  model = (& $ADB shell getprop ro.product.model).Trim()
  device = (& $ADB shell getprop ro.product.device).Trim()
  manufacturer = (& $ADB shell getprop ro.product.manufacturer).Trim()
  android_release = (& $ADB shell getprop ro.build.version.release).Trim()
  sdk = (& $ADB shell getprop ro.build.version.sdk).Trim()
  hardware = (& $ADB shell getprop ro.hardware).Trim()
  vulkan = (& $ADB shell getprop ro.hardware.vulkan).Trim()
  fingerprint = (& $ADB shell getprop ro.build.fingerprint).Trim()
}
$pkgDump = & $ADB shell dumpsys package $PKG 2>$null | Out-String
$versionName = if ($pkgDump -match "versionName=([^\s]+)") { $Matches[1] } else { $null }
$versionCode = if ($pkgDump -match "versionCode=(\d+)") { $Matches[1] } else { $null }
$apkPath = ((& $ADB shell pm path $PKG) | Select-Object -First 1) -replace "package:",""
$apkSha = $null
if ($apkPath) {
  $apkSha = ((& $ADB shell "sha256sum '$apkPath'") | Out-String).Trim()
}
$meminfoHost = & $ADB shell cat /proc/meminfo | Out-String
$battery = & $ADB shell dumpsys battery | Out-String
$thermal = & $ADB shell dumpsys thermalservice 2>$null | Out-String

$identity = [ordered]@{
  captured_at = (Get-Date).ToString("o")
  adb_devices = $devices.Trim()
  props = $props
  package = $PKG
  versionName = $versionName
  versionCode = $versionCode
  apk_path = $apkPath
  apk_sha256_device = $apkSha
  battery_temp_c = Get-TempCFromBattery
  thermal_status = Get-ThermalStatus
  notes = @(
    "FPS overlay on Thor is NOT treated as guest-produced frames.",
    "System RAM includes other apps; use dumpsys meminfo PSS for emulator attribution.",
    "Thermal HAL may report HAL Ready:false — battery temperature used as safety proxy."
  )
}
$identity | ConvertTo-Json -Depth 6 | Set-Content (Join-Path $run "identity.json") -Encoding UTF8
$devices | Set-Content (Join-Path $run "devices.txt")
$props.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" } | Set-Content (Join-Path $run "props.txt")
$pkgDump | Set-Content (Join-Path $run "package.txt")
$meminfoHost | Set-Content (Join-Path $run "meminfo_host.txt")
$battery | Set-Content (Join-Path $run "battery.txt")
$thermal | Set-Content (Join-Path $run "thermal.txt")
if ($apkSha) { $apkSha | Set-Content (Join-Path $run "apk_sha256.txt") }

if ($LaunchPackage) {
  & $ADB shell monkey -p $PKG -c android.intent.category.LAUNCHER 1 | Out-Null
  Start-Sleep -Seconds 3
}

$samples = @()
$csv = Join-Path $run "samples.csv"
"timestamp,battery_temp_c,thermal_status,running,total_pss_kb,total_rss_kb,total_swap_pss_kb,mem_available_kb,abort" |
  Set-Content $csv -Encoding UTF8

$deadline = if ($DurationSec -gt 0) { (Get-Date).AddSeconds($DurationSec) } else { $null }
$iter = 0
do {
  $iter++
  $temp = Get-TempCFromBattery
  $th = Get-ThermalStatus
  $mem = Get-MemSnapshot
  $abort = $false
  if ($null -ne $temp -and $temp -ge $AbortTempC) { $abort = $true }
  if ($th -match "^[3-9]$") { $abort = $true }  # THERMAL_STATUS_SEVERE≈3+

  $row = [ordered]@{
    timestamp = (Get-Date).ToString("o")
    battery_temp_c = $temp
    thermal_status = $th
    running = [bool]$mem.running
    total_pss_kb = $mem.total_pss_kb
    total_rss_kb = $mem.total_rss_kb
    total_swap_pss_kb = $mem.total_swap_pss_kb
    mem_available_kb = $mem.mem_available_kb
    abort = $abort
  }
  $samples += $row
  "$($row.timestamp),$($row.battery_temp_c),$($row.thermal_status),$($row.running),$($row.total_pss_kb),$($row.total_rss_kb),$($row.total_swap_pss_kb),$($row.mem_available_kb),$($row.abort)" |
    Add-Content $csv

  if ($mem.running) {
    & $ADB shell dumpsys meminfo $PKG 2>$null | Set-Content (Join-Path $run ("meminfo_app_{0:D3}.txt" -f $iter))
  }

  if ($abort) {
    Write-Warning "Watchdog abort: temp=$temp C thermal=$th — forcing app to background"
    & $ADB shell input keyevent KEYCODE_HOME 2>$null | Out-Null
    @{ aborted = $true; reason = "thermal_or_temp"; temp_c = $temp; thermal_status = $th } |
      ConvertTo-Json | Set-Content (Join-Path $run "watchdog_abort.json")
    break
  }

  if ($null -eq $deadline) { break }
  if ((Get-Date) -ge $deadline) { break }
  Start-Sleep -Seconds $IntervalSec
} while ($true)

@{ sample_count = $samples.Count; samples = $samples } | ConvertTo-Json -Depth 6 |
  Set-Content (Join-Path $run "samples.json") -Encoding UTF8

$summary = @"
# Thor diagnostics summary

- Dir: $run
- Device: $($props.manufacturer) $($props.model) ($($props.device))
- Android: $($props.android_release) / SDK $($props.sdk)
- Package: $PKG $versionName ($versionCode)
- APK SHA256: $apkSha
- Samples: $($samples.Count)
- AbortTempC: $AbortTempC

Unmeasurable without root / instrumentation: GPU clock exact, guest frame authenticity vs overlay FPS, precise GPU memory breakdown, LMKD kill attribution until event occurs.
"@
$summary | Set-Content (Join-Path $run "SUMMARY.md") -Encoding UTF8
Write-Host $summary
Write-Host "Done: $run"
