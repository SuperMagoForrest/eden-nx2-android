# Current state

**Aggiornato:** 2026-11-26 (sessione M0/M1)

## Git

- Branch: `sx2a/dev` @ `b68d3f5325e6dab81e345ad84acd039ee1cc93c5` (brain/skills; parent baseline `59bb148`)
- Baseline protetta: `baseline/59bb148`, tag `baseline-m0-59bb148`
- origin: SuperMagoForrest/eden-nx2-android
- upstream: JaviiDeveloper/eden-nx2-android (nx2-android)

## Completato

- Workspace `F:\DEV\EDEN_SX2A\`
- Fork + remotes + baseline
- NDK 28.2 + CMake 3.31.5/3.31.6 + cmdline-tools
- Audit iniziale (memory 20GiB intent, HostMemory/NCE, 6 cores, Android package, flow)
- Project brain (31 doc) + 14 skill + guardrail rule
- Script Win build/ADB/Thor battery
- CI NDK allineato a 28.2
- Commit `b68d3f5` + push fork (se riuscito)

## In corso

- `gradlew assembleMainlineRelWithDebInfo` — CMake/CPM configure (cubeb e oltre); log `logs/baseline-build.log`

## Bloccato / serve utente

- Thor Pro + dump legittimi solo quando APK baseline pronto

## Non fatto

- APK verificato
- Runtime test Thor
- Deep audit nx2_gsv / shader completeness
