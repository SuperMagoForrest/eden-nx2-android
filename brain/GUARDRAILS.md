# Guardrails

## Codice

- Standard e stile upstream; no rewrite speculative.
- No fake implementation presentata come completa.
- No rimozione assert/test per far passare la build.
- No nuove dipendenze senza motivazione in `DECISIONS.md`.
- Commenti minimi; niente rumore.

## Stabilità

- Ogni cambio funzionale: build + test pertinenti.
- Ogni ottimizzazione: confronto baseline.
- Proteggere save/config utente; package diagnostico separato (`relWithDebInfo`).

## Git (fork pubblico)

- **Push esclusivamente** su `origin` (fork SuperMagoForrest) e branch `sx2a/*`.
- **Mai** push verso `upstream` / repository originale.
- **Mai** creare PR verso upstream salvo richiesta esplicita del proprietario.
- Branch `nx2-android` / `baseline/59bb148` / tag baseline **intatti**.
- No force push.
- No commit di secrets, giochi, firmware, log sensibili, PII, `local.properties`, APK (vedi `STORAGE_POLICY.md`, `GIT_WORKFLOW.md`).
- Rispettare `docs/policies/AI.md` se un giorno il proprietario autorizzasse contribuzioni upstream.

## Evidenze

Usare solo: `VERIFIED` | `PARTIALLY_VERIFIED` | `IMPLEMENTED_NOT_TESTED` | `HYPOTHESIS` | `BLOCKED` | `NOT_STARTED`.

## Device

- No disable thermal protections, no root/overclock per “passare” i test.
- Interrompere soak se temperature/sicurezza a rischio; registrare evidenza.

## Legale

- Solo titoli legittimamente posseduti per test.
- Non pubblicare keys/firmware/dump.
- Licenza GPLv3+ / attribuzioni REUSE.
