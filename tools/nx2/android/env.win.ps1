# Shared Windows env for Eden SX2A phone scripts (mirrors tools/nx2/android/env.sh)
$ErrorActionPreference = "Continue"
$Sdk = if ($env:ANDROID_HOME) { $env:ANDROID_HOME } else { Join-Path $env:LOCALAPPDATA "Android\Sdk" }
$script:ADB = Join-Path $Sdk "platform-tools\adb.exe"
$script:NDK = Join-Path $Sdk "ndk\28.2.13676358"
$script:PKG = "dev.eden.nx2.relWithDebInfo"
$script:FILES = "/sdcard/Android/data/$PKG/files"
$script:REPO = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
$script:OUT = if ($env:OUT) { $env:OUT } else { Join-Path $REPO "nx2-runs" }
New-Item -ItemType Directory -Force -Path $OUT | Out-Null
function Get-EdenDevices { & $ADB devices -l }
function Get-EdenFocus {
  (& $ADB shell dumpsys window) -match "mCurrentFocus|mFocusedApp" | Out-String
}
function Test-EdenInFront { (Get-EdenFocus) -match [regex]::Escape($PKG) }
function Save-EdenScreenshot($Path) {
  if (Test-EdenInFront) { & $ADB exec-out screencap -p > $Path }
}
function Get-EdenMeminfo {
  & $ADB shell dumpsys meminfo $PKG
}
function Get-EdenProps {
  & $ADB shell getprop ro.product.model
  & $ADB shell getprop ro.hardware
  & $ADB shell getprop ro.build.version.release
}
Write-Host "ADB=$ADB PKG=$PKG OUT=$OUT"
