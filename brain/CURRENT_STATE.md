# Current state

**Aggiornato:** 2026-11-26 fine sessione M0/M1 + build baseline

## Git

- Branch: `sx2a/dev` (origin tracking)
- Baseline codice: `59bb148`
- Tooling commits su fork: brain/skills/CI/scripts

## Completato (M0/M1)

- Workspace, fork, remotes, baseline protetta
- NDK 28.2, CMake 3.31.5, glslangValidator toolchains
- Brain 31 doc + 14 skill + guardrail
- **APK baseline RelWithDebInfo prodotto e archiviato** (`VERIFIED` build)
- Report `F:\DEV\EDEN_SX2A\reports\M0_M1_REPORT.md`

## Prossimo (M2+)

1. Opzionale: installare APK su Thor con `thor_battery.ps1 -InstallApk`
2. Allineare/deep-dive memoria (20 GiB intent vs RSS)
3. Fix strutturali P0 dopo evidenze device
4. Non dichiarare compat finché non testato

## Serve utente

Collegare Thor Pro + dump legittimi quando pronto per batteria consolidata.
