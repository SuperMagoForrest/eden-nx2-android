# Consolidated Thor Pro evidence battery (no games required for steps 1-4)
param([switch]$InstallApk,[string]$ApkPath="")
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\env.win.ps1"
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$run = Join-Path $OUT "thor-$stamp"
New-Item -ItemType Directory -Force -Path $run | Out-Null
Write-Host "Run dir: $run"
Get-EdenDevices | Tee-Object -FilePath (Join-Path $run "devices.txt")
Get-EdenProps | Tee-Object -FilePath (Join-Path $run "props.txt")
& $ADB shell dumpsys thermalservice 2>$null | Tee-Object (Join-Path $run "thermal.txt") | Out-Null
& $ADB shell cat /proc/meminfo | Tee-Object (Join-Path $run "meminfo_host.txt") | Out-Null
if ($InstallApk) {
  if (-not $ApkPath) { throw "Provide -ApkPath" }
  & $ADB install --user 0 -r $ApkPath | Tee-Object (Join-Path $run "install.txt")
}
Get-EdenMeminfo 2>$null | Tee-Object (Join-Path $run "meminfo_app.txt") | Out-Null
Write-Host "Battery scaffolding done. Add game launches when dumps are available."
