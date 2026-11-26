# Current state

**Aggiornato:** 2026-11-26 (sessione M0/M1)

## Git

- Branch: `sx2a/dev` @ `59bb14838877260f820d4b0dcf63114ac4612310`
- Working tree: clean + untracked `brain/` `.cursor/` (pending commit)
- origin: SuperMagoForrest/eden-nx2-android
- upstream: JaviiDeveloper/eden-nx2-android (nx2-android)

## Completato

- Workspace `F:\DEV\EDEN_SX2A\`
- Fork creato
- Clone + remotes + baseline branch/tag
- NDK 28.2 + CMake 3.31.5/3.31.6 + cmdline-tools
- `local.properties`
- Audit iniziale codice/docs (memory 20GiB intent, 6 cores, Android package, flow)
- Project brain (documenti principali)
- Build baseline avviata

## In corso

- `gradlew assembleMainlineRelWithDebInfo` → log `logs/baseline-build.log`
- Subagent audit architettura / dipendenze

## Bloccato / serve utente

- Collegare Thor Pro quando batteria test sarà pronta (non ora)
- Giochi legittimi per compat (non ora)

## Non fatto

- APK prodotto e verificato
- Skill file completi (in scrittura)
- Push su origin (dopo commit brain)
- Runtime test
