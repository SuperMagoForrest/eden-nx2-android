# Android architecture

## Identità app

| Flavor | applicationId | minSdk | Note |
|---|---|---|---|
| mainline (SX2A) | `dev.eden.nx2` (+ suffix build type) | 33 | Default |
| mainline + relWithDebInfo | `dev.eden.nx2.relWithDebInfo` | 33 | Build diagnostica |
| genshinSpoof | `com.miHoYo.Yuanshen` | 35 | Spoof |
| legacy | `dev.legacy.eden_emulator` | 29 | |
| chromeOS | default + x86_64 | | Non target Thor |

Namespace Java: `org.yuzu.yuzu_emu` (eredità yuzu).

## Flusso avvio (sintesi)

1. UI (`ui/main`, fragments) → selezione gioco / ExeFS / NUP
2. `GameHelper` risolve `exefs/main`, updates, DLC `dlc/<tid>/<ver>/romfs`
3. Native via JNI (`app/src/main/jni`) → `Core::System::Load`
4. Surface / Vulkan present; swipe-from-recents termina processo (`NX2_ANDROID.md`)
5. Debug: `files/nx2_env.txt` → env vars (solo non-release)

## Componenti fork-specifici Android

- Switch 2 readiness check: `fragments/Switch2ReadinessFragment.kt`
- Bug report + `ApplicationExitInfo`: `utils/BugReport.kt`
- Driver resolve Turnip: `utils/DriverResolver.kt`
- Loose ExeFS launch + intent `exefs_path`
- Memory layout 10/12 GB in settings strings/UI
- Bundled GPU drivers under `assets/gpu_drivers`

## JNI / native

- Native build via CMake path `project(":Eden")` → root `CMakeLists.txt`
- Packaging: `jniLibs.useLegacyPackaging = true` per adrenotools custom drivers
- Unstripped lib helper in `tools/nx2/android/env.sh`: `libyuzu-android.so`

## Lifecycle rischi

- Present dopo surface distrutta → drop frame
- Necessità riavvio app tra giochi diversi (documentato upstream)
- LMKD / battery restrictions → readiness checks
