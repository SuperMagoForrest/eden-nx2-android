# Architecture Decision Record

## ADR-001 — Workspace dedicato fuori da altri progetti

- **Decisione:** `F:\DEV\EDEN_SX2A\` con `repo/ builds/ cache/ …`
- **Stato:** Accepted
- **Motivazione:** non contaminare altri tree sotto `F:\DEV`

## ADR-002 — Fork GitHub SuperMagoForrest + upstream remote

- **Decisione:** origin=fork, upstream=JaviiDeveloper
- **Stato:** Accepted (`VERIFIED`)

## ADR-003 — Baseline immutabile + branch `sx2a/dev`

- **Decisione:** tag `baseline-m0-59bb148`, branch `baseline/59bb148`, lavoro su `sx2a/dev`
- **Stato:** Accepted

## ADR-004 — Project brain in-repo sotto `brain/`

- **Decisione:** documentazione operativa versionata nel fork
- **Stato:** Accepted

## ADR-005 — Build di riferimento RelWithDebInfo mainline

- **Decisione:** APK diagnostico `dev.eden.nx2.relWithDebInfo` come baseline QA (side-by-side rispetto a release)
- **Stato:** Accepted; build in corso

## ADR-006 — Merge-only verso PokeDinner

- **Decisione:** ereditare policy upstream (no rebase)
- **Stato:** Accepted

## ADR-007 — Nessuna PR upstream senza richiesta

- **Decisione:** push solo sul fork; no PR a Eden/PokeDinner/Javii senza OK esplicito
- **Stato:** Accepted

## ADR-008 — Policy pubblicazione fork pubblico

- **Decisione:** documentare e applicare `STORAGE_POLICY`, `STORAGE_AUDIT`, `ENVIRONMENT_ISOLATION`, `GIT_WORKFLOW`; artefatti/APK/log fuori git; push solo `origin`/`sx2a/*`
- **Stato:** Accepted
