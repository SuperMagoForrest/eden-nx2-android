# Storage policy — fork pubblico

Il fork `SuperMagoForrest/eden-nx2-android` è **pubblico**. Tutto ciò che viene pushato è leggibile da terzi.

## Vietato pubblicare su git (origin)

- Credenziali, token, API key, password, keystore di release con segreti reali
- File `.env`, secret CI in chiaro, Android signing passwords
- Dump di giochi, ExeFS/RomFS, NUP/NSP/XCI, aggiornamenti, DLC
- Keys / firmware Nintendo
- Logcat/bugreport con account, ID dispositivo, path home utente, token
- Salvataggi utente, screenshot di gameplay di titoli protetti
- Configurazioni locali macchina (`local.properties`, path assoluti Windows personali non necessari)
- APK/AAB di build e artefatti binari grossi (restano fuori repo)

## Consentito nel repo (con giudizio)

- Codice sorgente e patch del fork
- `brain/` documentazione tecnica senza PII
- Script di build/test che usano path relativi o variabili d’ambiente
- Hash/SHA di APK (non l’APK stesso) nei report
- Metriche aggregate anonimizzate (FPS, RSS) senza identificatori personali

## Dove tenere i dati locali (fuori git)

| Contenuto | Percorso tipico |
|---|---|
| APK verificati | `F:\DEV\EDEN_SX2A\releases\` |
| Build intermediates | `F:\DEV\EDEN_SX2A\builds\`, `repo/src/android/app/build/` |
| Log grezzi | `F:\DEV\EDEN_SX2A\logs\` |
| Cache compilazione | `F:\DEV\EDEN_SX2A\cache\`, `repo/.cache/` |
| Dump di test (legittimi) | **mai** sotto `repo/`; cartella privata fuori dal tree git |
| Toolchain locali | `F:\DEV\EDEN_SX2A\toolchains\` |

## Prima di ogni push

1. `git status` / `git diff --cached` — niente secret o binari sensibili.
2. Nessun path utente non necessario nei file versionati.
3. Push solo `origin` + branch `sx2a/*` (`GIT_WORKFLOW.md`).
