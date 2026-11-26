# Test strategy

## Livelli

| Livello | Cosa | Dove | Stato |
|---|---|---|---|
| Unit native | `src/tests`, dynarmic tests | Desktop CI preferibile | Android build li spegne |
| Tool fuzz | `tools/nx2/jit_fuzz`, a64_coverage | Host | Disponibile |
| Build smoke | assembleMainlineRelWithDebInfo | Questo PC | IN_PROGRESS |
| Android instrumentation | readiness, launch | Thor | NOT_STARTED |
| Compat titolo | matrice | Thor + dump legittimi | NOT_STARTED |
| Soak 30/60 min | stability/thermal | Thor | NOT_STARTED |
| Mem pressure | budget sim Base | Host/device | NOT_STARTED |

## Titoli seed (solo legittimi)

1. Pokémon Pokopia (upd documentata)
2. Donkey Kong Bananza
3. Mario Kart World
4. Homebrew/synthetic se disponibili per isolare CPU/GPU

## Device battery (singola sessione)

1. `adb devices` + props (model, ram, gpu)
2. Baseline termica
3. Install `dev.eden.nx2.relWithDebInfo` side-by-side
4. Readiness check + share report
5. Per titolo: boot→first frame→menu→gameplay sample + meminfo + logcat
6. Un soak sul titolo più stabile
7. Collect via `tools/nx2/android/collect.sh` (adattare path Windows)

## Criteri “PLAYABLE”

Gameplay reale sostenuto, non solo menu. Stati in `COMPATIBILITY_MATRIX.md`.
