# Current state

**Aggiornato:** 2026-11-27 — Alpha 0.1c installata

## Git

- Branch: `sx2a/dev` @ `c64b94c46a` (pushed origin)
- Baseline protetta: `59bb148`

## Device

- Thor Pro ONLINE; candidate **0.1c** SHA match
- Smoke MainActivity: OK (~85 MB PSS idle)
- Pokopia candidate: **NEEDS_OWNER** per run strumentata

## Delivered questa sessione

- M2 diagnostica + watchdog script
- M3 frame pacing 30 FPS reale (fix bypass Android)
- M4 reclaim backing + onTrimMemory → buffer GC
- M5 worker clamp ≥1 per thermal
- M8/M9 profili Thor + ThermalController
- APK Alpha 0.1c in `releases/`

## Blocco attuale

Misura G4–G6 richiede gameplay Pokopia sulla candidate (senza clear dati). Con titolo in esecuzione e USB collegato, riprendere con `thor_diagnostics.ps1 -DurationSec 300`.
