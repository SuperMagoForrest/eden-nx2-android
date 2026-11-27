# Compatibility matrix

Device colonne: **Upstream phone (SM8850 16GB)** vs **Thor Pro** vs **Thor Base**.

Stati: `NOT_TESTED` | `BOOT_FAILED` | `BOOTING` | `MENU` | `IN_GAME` | `PLAYABLE` | `STABLE_PLAYABLE` | `VERIFIED_COMPLETE`  
Owner-reported: `OWNER_REPORTED_IN_GAME` | `OWNER_REPORTED_BOOT_REGRESSION`

| Titolo | Versione | Upstream | Thor Pro baseline `59bb148` | Thor Pro Alpha 0.1c `d14fcd4` | Thor Pro Alpha 0.2 | Thor Base | Note |
|---|---|---|---|---|---|---|---|
| Pokémon Pokopia | (owner session) | PLAYABLE ~20-30 FPS | **OWNER_REPORTED_IN_GAME** | **OWNER_REPORTED_BOOT_REGRESSION** | PENDING | NOT_TESTED | 0.1c: LMKD LOW_MEMORY durante loading (exit-info). Baseline: lingua/intro/dialoghi. |
| Donkey Kong Bananza | upd 458752 | IN_GAME ~10 FPS | NOT_TESTED | NOT_TESTED | NOT_TESTED | NOT_TESTED | Loading lento |
| Mario Kart World | 1.0.0 | IN_GAME black tex | NOT_TESTED | NOT_TESTED | NOT_TESTED | NOT_TESTED | |
| Welcome Tour | — | NOT_TESTED | NOT_TESTED | NOT_TESTED | NOT_TESTED | NOT_TESTED | |

### Pokopia — Thor Pro owner samples baseline (2026-11-27)

Condizioni: Standard Performance, display 60 FPS, fan Smart, driver `26.3.0-T30-1.4.359`, Adreno 740. APK baseline SHA match.

| Fase | Temp indicata | RAM indicata | FPS overlay |
|---|---:|---:|---:|
| Loading | 57–63 °C | 7.98–8.54 GB | 51–55 |
| Lingua / save warn | 66–70 °C | 9.82–9.88 GB | 43–55 |
| Intro / dialogo | 71–74 °C | 9.93–9.98 GB | 38–55 |

### Pokopia — Thor Pro owner samples Alpha 0.1c (2026-11-27)

| Fase | Temp dashboard | RAM dashboard | FPS overlay |
|---|---:|---:|---:|
| Loading iniziale | 58 °C | 6,61 GB | ~28,9 |
| Schermata nera | 59 °C | ~6,88 GB | 0,0 |
| Animazione caricamento | 60 °C | 6,95 GB | 27,4 |
| Loading successivo | 62 °C | 7,84 GB | 28,1 |
| Ritorno libreria | 65 °C | 2,61 GB | N/A |

Caveat: RAM sistema ≠ PSS; confronto 0.1c vs baseline non a parità di scena (0.1c muore prima). Temp foto ≠ battery dumpsys diagnostica.
