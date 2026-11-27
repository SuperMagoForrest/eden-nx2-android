# Device lab — AYN Thor Pro

## Identità sessione 2026-11-27

| Campo | Valore | Evidenza |
|---|---|---|
| ADB serial | (locale, non pubblicare) | `adb devices` |
| Model | AYN Thor | getprop |
| Board | kalama | getprop |
| Android | 13 / SDK 33 | getprop |
| MemTotal | 11535400 kB (~11.0 GiB) | /proc/meminfo |
| Package installato | `dev.eden.nx2.relWithDebInfo` | dumpsys |
| versionName | `nx2-android-v0.3.3-2-relWithDebInfo` | dumpsys |
| APK SHA256 device | `33E5B875…7BE08325` | sha256sum |
| APK SHA256 locale | uguale | Get-FileHash |
| Match baseline | VERIFIED | |

Overlay owner `a480cb8259` = prefisso `NativeLibrary.getBuildVersion()` (non confondere con commit `59bb148`).

## Script

- `tools/nx2/android/thor_diagnostics.ps1` — identity + samples + watchdog temp
- `tools/nx2/android/thor_battery.ps1` — scaffolding legacy
- `tools/nx2/android/env.win.ps1` — ADB/PKG

## Safety

Non: `pm clear` dati reali, factory reset, overwrite save, stress senza monitor.
