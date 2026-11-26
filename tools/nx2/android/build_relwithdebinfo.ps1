# Eden SX2A Windows build helper (RelWithDebInfo mainline)
$ErrorActionPreference = "Stop"
$Repo = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
$Sdk = if ($env:ANDROID_HOME) { $env:ANDROID_HOME } else { "$env:LOCALAPPDATA\Android\Sdk" }
$Ndk = Join-Path $Sdk "ndk\28.2.13676358"
$Java = if (Test-Path "C:\Program Files\Java\jdk-21.0.11") { "C:\Program Files\Java\jdk-21.0.11" } elseif (Test-Path "C:\Program Files\Java\jdk-17") { "C:\Program Files\Java\jdk-17" } else { $env:JAVA_HOME }
$env:ANDROID_HOME = $Sdk
$env:ANDROID_SDK_ROOT = $Sdk
$env:ANDROID_NDK_HOME = $Ndk
$env:JAVA_HOME = $Java
$ToolchainBin = "F:\DEV\EDEN_SX2A\toolchains\bin"
$env:Path = "$ToolchainBin;$Java\bin;$Sdk\cmake\3.31.5\bin;$Sdk\platform-tools;$env:Path"
if (-not (Get-Command glslangValidator -ErrorAction SilentlyContinue)) {
  throw "glslangValidator not on PATH. Place it in $ToolchainBin (see brain/BUILD_AND_SETUP.md)."
}
$LogDir = "F:\DEV\EDEN_SX2A\logs"
New-Item -ItemType Directory -Force -Path $LogDir, "F:\DEV\EDEN_SX2A\builds" | Out-Null
$Log = Join-Path $LogDir ("build-" + (Get-Date -Format "yyyyMMdd-HHmmss") + ".log")
Set-Location (Join-Path $Repo "src\android")
if (-not (Test-Path "local.properties")) {
  "sdk.dir=$($Sdk -replace '\\','/')" | Set-Content local.properties -Encoding ASCII
}
Write-Host "Building assembleMainlineRelWithDebInfo ..."
Write-Host "Log: $Log"
.\gradlew.bat assembleMainlineRelWithDebInfo --no-daemon --stacktrace 2>&1 | Tee-Object -FilePath $Log
$apk = Join-Path $Repo "src\android\app\build\outputs\apk\mainline\relWithDebInfo\app-mainline-relWithDebInfo.apk"
if (Test-Path $apk) {
  $dest = "F:\DEV\EDEN_SX2A\builds\$(Split-Path $apk -Leaf)"
  Copy-Item $apk $dest -Force
  Write-Host "APK copied to $dest"
} else {
  Write-Host "APK not found; see log"
  exit 1
}
