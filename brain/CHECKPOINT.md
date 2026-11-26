# Checkpoint

## Ripresa immediata

1. Leggere questo file + `NEXT_ACTIONS.md` + `CURRENT_STATE.md`.
2. Controllare `F:\DEV\EDEN_SX2A\logs\baseline-build.log` (esito build).
3. Se build OK → copiare APK in `builds/` e aggiornare `PERFORMANCE_BASELINE.md`.
4. Se build FAIL → diagnosticare da log, fix env/code, non cambiare baseline commit.
5. Continuare skill/rules se incompleti; poi M2 script Windows + diagnostica.

## Snapshot

| Campo | Valore |
|---|---|
| Data | 2026-11-26 |
| Branch | `sx2a/dev` |
| Commit | `59bb14838877260f820d4b0dcf63114ac4612310` |
| Baseline tag | `baseline-m0-59bb148` |
| Build | IN_PROGRESS RelWithDebInfo mainline |
| Device | Non collegato in questa fase |
| Prossimo comando | Controllare log build; se fallisce per cmake version, assicurare SDK cmake 3.31.5 |

## Tentativi / note

- Clone con `--recurse-submodules` bloccato da AV → clone semplice OK (no submodule file).
- NDK 27 installato per errore poi 28.2 richiesto da gradle.
- Script upstream Android path macOS-only.
