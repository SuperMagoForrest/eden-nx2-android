# Install an authorized RelWithDebInfo APK on the attached Thor and verify SHA256.
param(
  [Parameter(Mandatory = $true)][string]$ApkPath,
  [string]$Serial = "",
  [string]$ExpectedSha256 = ""
)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\env.win.ps1"
if (-not (Test-Path $ApkPath)) { throw "APK missing: $ApkPath" }

function Adb { param([string[]]$Args)
  $a = @(); if ($Serial) { $a += @("-s", $Serial) }; $a += $Args; & $ADB @a
}

$hostSha = (Get-FileHash -Algorithm SHA256 $ApkPath).Hash.ToUpperInvariant()
Write-Host "Host SHA256: $hostSha"
if ($ExpectedSha256 -and ($ExpectedSha256.ToUpperInvariant() -ne $hostSha)) {
  throw "Host SHA mismatch. expected=$ExpectedSha256 actual=$hostSha"
}

Adb @("devices", "-l")
Write-Host "Installing $ApkPath ..."
Adb @("install", "-r", $ApkPath)
$apkPathDev = ((Adb @("shell", "pm", "path", $PKG) | Select-Object -First 1) -replace "package:", "").Trim()
if (-not $apkPathDev) { throw "Package not installed" }
$devShaLine = (Adb @("shell", "sha256sum", $apkPathDev) | Out-String).Trim()
$devSha = ($devShaLine -split "\s+")[0].ToUpperInvariant()
Write-Host "Device SHA256: $devSha"
if ($devSha -ne $hostSha) { throw "Device SHA mismatch" }
$ver = Adb @("shell", "dumpsys", "package", $PKG) | Select-String "versionName=|versionCode=" | Select-Object -First 4
$ver | ForEach-Object { $_.Line.Trim() }
# Clear only the profile-applied flag so v2 defaults can re-apply without wiping saves.
Adb @("shell", "am", "broadcast", "-a", "android.intent.action.RUN") | Out-Null
Write-Host "Install OK. Launch Eden and confirm Frame pacing=30, Release host backing as desired."
Write-Host "NOTE: profile pref key is sx2a_thor_profile_applied_v2 (new installs get defaults once)."
