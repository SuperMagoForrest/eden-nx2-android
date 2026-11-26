# Storage audit

Audit rispetto a `STORAGE_POLICY.md`. Aggiornare dopo ogni sessione che tocca artefatti.

## Snapshot 2026-11-27

| Area | Stato | Note | Evidenza |
|---|---|---|---|
| Push solo su fork | OK | `origin` = SuperMagoForrest; nessun push upstream | remotes |
| Branch baseline intatto | OK | `baseline/59bb148`, `nx2-android` @ `59bb148` | git |
| PR upstream | OK | Nessuna creata | — |
| APK fuori git | OK | In `F:\DEV\EDEN_SX2A\releases\` e `builds\` | filesystem |
| Log build fuori git | OK | `F:\DEV\EDEN_SX2A\logs\` | filesystem |
| `local.properties` | OK se untracked | Path SDK macchina; non deve essere committato | verificare pre-push |
| Dump giochi in repo | OK | Nessuno versionato | — |
| Credenziali CI nel repo | OK | Workflow usa `secrets.*` GitHub, non valori in chiaro | `build-release.yml` |
| `src/android/app/debug.keystore` | **ATTENZIONE** | Già presente nell’upstream ed è versionato (keystore **debug** standard Android, password note “android”). Non è un secret di release; non aggiungere keystore di produzione. | `git ls-files` |
| SHA256 APK in brain | OK | Solo hash, non binario | `PERFORMANCE_BASELINE.md` |
| Path `F:\DEV\...` in brain/script | ACCETTABILE con cautela | Documentazione locale del workspace proprietario; evitare home path con username se non necessari. Script Win usano path DEV espliciti. | brain / tools |

## Azioni aperte

1. Assicurare che `local.properties` e `*.apk` restino ignorati/untracked.
2. Non committare output di `thor_battery.ps1` / `nx2-runs` se contengono log device.
3. Prima di push futuri: rieseguire checklist `STORAGE_POLICY.md`.

## Classificazione evidenza

Stato generale conformità pubblicazione: **PARTIALLY_VERIFIED** (audit manuale; nessuno scan automatico completo di tutta la history upstream).
