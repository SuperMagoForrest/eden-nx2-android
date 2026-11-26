# Roadmap

## Milestone

| ID | Nome | Ingresso | Uscita | Stato |
|---|---|---|---|---|
| M0 | Repo, ambiente, baseline | — | Fork, remotes, baseline tag, env, APK | **DONE** |
| M1 | Audit, brain, skill, guardrail | M0 acquisizione | Brain completo, skill, backlog, report | **DONE** |
| M2 | Build riproducibile + diagnostica | M0/M1 | Script Win OK; CI NDK TBD; device diagnostics | **IN_PROGRESS** |
| M3 | Stabilizzazione core | M2 | Crash P0 ridotti, lifecycle fix | PENDING |
| M4 | Correttezza CPU/GPU + compat | M3 | Titoli seed a MENU/IN_GAME con evidenze | PENDING |
| M5 | Ottimizzazione memoria strutturale | M3/M4 | Budget Thor Pro misurati; piano Base | PENDING |
| M6 | Performance | M5 | FPS/frametime vs baseline | PENDING |
| M7 | Thermal/power | M6 | Soak 30/60 min senza throttle catastrofici | PENDING |
| M8 | Validazione Thor Pro | M4–M7 | Matrice aggiornata Pro | PENDING |
| M9 | Ottimizzazione/validazione Thor Base | M5+M8 | Profilo 8GB + test fisici o espliciti limiti | PENDING |
| M10 | Estensione compatibilità | M4+ | Catalogo ampliato | PENDING |
| M11 | Consolidamento release | M8–M10 | APK release + rollback | PENDING |

## Critical path

`M0 → M1 → M2 → (M3 ∥ memory audit) → M5 ↔ M4 → M6 → M7 → M8 → M9 → M10 → M11`

Attività parallelizzabili: documentazione/skills (fatto), audit moduli, preparazione script ADB, analisi CI NDK mentre build nativa gira.
