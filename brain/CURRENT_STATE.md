# Current state

**Aggiornato:** 2026-11-27 sessione M2–M9 implementativa (in corso)

## Git

- Branch: `sx2a/dev`
- Baseline emu protetta: `59bb148`
- Working tree: modifiche frame pacing + memory reclaim + Android Thor profile/thermal (pre-commit fino a build OK)

## Device

- Thor Pro ADB: **ONLINE** (AYN Thor / kalama / Android 13 SDK 33)
- APK installato = baseline SHA256 **match** `33E5B875…7BE08325`
- Pokopia: **OWNER_REPORTED_IN_GAME** (lag/stutter/heat; non strumentato)

## Completato questa sessione

- Diagnostica `thor_diagnostics.ps1` + snapshot `logs/diag-*`
- Frame pacing Android ripristinato; default 30 FPS; PaceToVblank rispetta cap
- `ReleaseBackingRegion` + `release_host_backing` su Close
- Profili Thor + ThermalController (workers)
- Storage build → `F:\DEV\EDEN_SX2A\cache\gradle|cpm|tmp`

## In corso

- Build candidate RelWithDebInfo (`logs/build-20261127-112435.log`)

## Prossimo

1. Completare build, archiviare APK in `releases/` con SHA256
2. Install diagnostico + campione meminfo a caldo (watchdog 70 °C)
3. Shader stutter (async/cache) dopo explore
4. Commit atomici + push origin
