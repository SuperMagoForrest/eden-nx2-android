# Next actions (eseguibili)

1. **Monitorare / completare build baseline** — `F:\DEV\EDEN_SX2A\logs\baseline-build.log`.
2. **Se successo:** archiviare APK in `F:\DEV\EDEN_SX2A\builds\baseline-59bb148\` + checksum.
3. **Se fallimento:** fix toolchain (cmake 3.31.5 exact, licenze SDK, CPM network) e rilanciare.
4. **Completare skill** in `.cursor/skills/` (14 specializzazioni) + rule alwaysApply.
5. **Aggiungere remote `pokedinner`** quando serve sync (non urgente).
6. **Porting `env.sh` Windows** in `tools/nx2/android/env.win.ps1` (nuovo file, non rompere bash).
7. **Allineare CI NDK** a 28.2.13676358.
8. **Deep-dive** `nx2_gsv.h` + memory commit paths (M5 prep) mentre si aspetta device.
9. **Non chiedere Thor** finché APK baseline + script collect non sono pronti.
