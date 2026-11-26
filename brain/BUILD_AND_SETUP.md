# Build and setup

## Baseline

| Campo | Valore |
|---|---|
| Commit | `59bb14838877260f820d4b0dcf63114ac4612310` |
| Messaggio | `shader: drop duplicate HSETP2 case 0x234 left by merge` |
| Branch protetto locale | `baseline/59bb148`, tag `baseline-m0-59bb148` |
| Branch lavoro | `sx2a/dev` |
| origin | `https://github.com/SuperMagoForrest/eden-nx2-android.git` |
| upstream | `https://github.com/JaviiDeveloper/eden-nx2-android.git` |
| Default upstream branch | `nx2-android` (`VERIFIED`) |

## Ambiente Windows (host di sviluppo)

| Componente | Percorso / versione | Stato |
|---|---|---|
| Android SDK | `C:\Users\Mattia\AppData\Local\Android\Sdk` | `VERIFIED` |
| NDK | `28.2.13676358` (richiesto da `app/build.gradle.kts`) | `VERIFIED` installato |
| CMake SDK | `3.31.5` (+ `3.31.6`) | `VERIFIED` |
| JDK | 21.0.11 (anche 17 presente); progetto target JVM 17 | `VERIFIED` |
| Gradle wrapper | 8.13 | `PARTIALLY_VERIFIED` (download in corso nella build baseline) |
| platform-tools / adb | presente | `VERIFIED` |
| WSL | `ThorLinux` (WSL2) con cmake/ninja/clang++ | `VERIFIED` |
| glslang | da verificare su Windows | `NOT_STARTED` |

## Flavor target di riferimento

- Product flavor: `mainline`
- Build type baseline: `relWithDebInfo`
- applicationId risultante: `dev.eden.nx2.relWithDebInfo`
- Task Gradle: `assembleMainlineRelWithDebInfo`
- Script upstream macOS: `tools/nx2/android/build_install.sh` → `.ci/android/build.sh`

## Comando Windows (baseline)

```powershell
$sdk = "C:\Users\Mattia\AppData\Local\Android\Sdk"
$env:ANDROID_HOME = $sdk
$env:ANDROID_SDK_ROOT = $sdk
$env:ANDROID_NDK_HOME = "$sdk\ndk\28.2.13676358"
$env:JAVA_HOME = "C:\Program Files\Java\jdk-21.0.11"
cd F:\DEV\EDEN_SX2A\repo\src\android
.\gradlew.bat assembleMainlineRelWithDebInfo --no-daemon --stacktrace
```

Log: `F:\DEV\EDEN_SX2A\logs\baseline-build.log`

`local.properties` (non versionare se contiene path macchina): `sdk.dir=C:/Users/Mattia/AppData/Local/Android/Sdk`

## CMake args Android rilevanti

Da `build.gradle.kts`: `-DENABLE_QT=0`, `-DYUZU_USE_CPM=ON`, `-DCPMUTIL_FORCE_BUNDLED=ON`, `-DYUZU_USE_BUNDLED_FFMPEG=ON`, `-DBUILD_TESTING=OFF`, `-DYUZU_TESTS=OFF`, `-DDYNARMIC_TESTS=OFF`. Release aggiunge `-DEDEN_NX2_NO_ENV_FILE=ON`.

## Nota CI

`.github/workflows/build-release.yml` usa NDK `27.0.12077973` e `assembleMainlineRelease` su Ubuntu — divergenza rispetto a `ndkVersion = "28.2.13676358"` nel Gradle locale. Da allineare in M2.
