# Minimal regression matrix runner for SX2A (install + config notes + diagnostics).
# Does not automate gameplay taps. Owner launches the title when prompted.
param(
  [ValidateSet("alpha02","alpha01c","baseline","custom")]
  [string]$Build = "alpha02",
  [string]$CustomApk = "",
  [int]$DurationSec = 300,
  [string]$Serial = "905d41b5"
)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\env.win.ps1"

$apks = @{
  alpha02 = "F:\DEV\EDEN_SX2A\releases\eden-sx2a-thor-opt-alpha02-relWithDebInfo.apk"
  alpha01c = "F:\DEV\EDEN_SX2A\releases\eden-sx2a-thor-opt-alpha01c-relWithDebInfo.apk"
  baseline = "F:\DEV\EDEN_SX2A\releases\eden-sx2a-baseline-59bb148-relWithDebInfo.apk"
  custom = $CustomApk
}
$apk = $apks[$Build]
if (-not $apk -or -not (Test-Path $apk)) { throw "APK missing for build=$Build path=$apk" }

Write-Host "=== SX2A regression matrix cell: $Build ==="
Write-Host "APK: $apk"
& "$PSScriptRoot\install_candidate.ps1" -ApkPath $apk -Serial $Serial

Write-Host @"

Manual config checklist (no pm clear):
  1. Frame pacing = 30 FPS
  2. For reclaim-off cell: disable 'Release host backing'
  3. Launch Pokopia to language/intro
  4. Leave USB connected

Starting diagnostics for $DurationSec s ...
"@

& "$PSScriptRoot\thor_diagnostics.ps1" -DurationSec $DurationSec -IntervalSec 5 -Serial $Serial -AbortSocTempC 70 -AbortBatteryTempC 75
Write-Host "Cell $Build complete. Review latest diag-* under F:\DEV\EDEN_SX2A\logs"
