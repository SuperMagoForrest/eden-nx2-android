# Compatibility matrix

Device colonne: **Upstream phone (SM8850 16GB)** vs **Thor Pro** vs **Thor Base**.

Stati: `NOT_TESTED` | `BOOT_FAILED` | `BOOTING` | `MENU` | `IN_GAME` | `PLAYABLE` | `STABLE_PLAYABLE` | `VERIFIED_COMPLETE`

| Titolo | Versione | Upstream | Thor Pro | Thor Base | Note |
|---|---|---|---|---|---|
| Pokémon Pokopia | (owner session) | PLAYABLE ~20-30 FPS | **OWNER_REPORTED_IN_GAME** | NOT_TESTED | Avvio+intro+dialoghi giocabili; lag/stutter/heat; non strumentato |
| Donkey Kong Bananza | upd 458752 | IN_GAME ~10 FPS | NOT_TESTED | NOT_TESTED | Loading lento |
| Mario Kart World | 1.0.0 | IN_GAME black tex | NOT_TESTED | NOT_TESTED | |
| Welcome Tour | — | NOT_TESTED | NOT_TESTED | NOT_TESTED | |

### Pokopia — Thor Pro owner samples (2026-11-27, non telemetria continua)

Condizioni: Standard Performance, display 60 FPS, fan 28→50%, driver overlay `26.3.0-T30-1.4.359`, Adreno 740 / QCS8550. APK = baseline SHA256 match.

| Fase | Temp indicata | RAM indicata | CPU | GPU | FPS overlay |
|---|---:|---:|---:|---:|---:|
| Loading | 57–63 °C | 7.98–8.54 GB | ~3.19 GHz | 401 MHz | 51–55 |
| Lingua / save warn | 66–70 °C | 9.82–9.88 GB | 2.09–3.19 | 401 | 43–55 |
| Intro / dialogo | 71–74 °C | 9.93–9.98 GB | 1.84–3.19 | 401–475 | 38–55 |
| Shader compile burst | 74 °C | ~9.98 GB | 3.19 | 475 | 44 |

Caveat: RAM di sistema ≠ PSS emulatore; FPS overlay ≠ frame guest autenticati; temp non attribuita automaticamente alla sola GPU.

Per ogni test strumentato aggiungere dettaglio in `F:\DEV\EDEN_SX2A\reports/` con commit, driver, mem PSS, FPS, termiche.
