# Root cause analysis

Solo cause con evidenza codice/documentazione. Ipotesi etichettate.

## RCA-001 — Pressione memoria su device ≤12 GB host

- **Sintomo:** LMKD / app kill / readiness fail; upstream chiede 16 GB ideali.
- **Meccanismo (`VERIFIED`):** Switch 2 forza layout 12 GB; `GetIntendedMemorySize` ritorna `12_GiB + 8_GiB` per graphics server pool. Titoli dimensionano heap da GetInfo total memory.
- **Perché host soffre (`HYPOTHESIS`):** anche con lazy mapping, picchi (shader cache, texture, JIT, sparse backing touch) avvicinano LMKD su 8–12 GB.
- **Direzione fix:** sparse/lazy commit, eviction, budget adattivi, non mentire sul total memory guest senza studio per-titolo.

## RCA-002 — First frame lento

- **Sintomo:** minuti di black screen al primo avvio.
- **Meccanismo (`PARTIALLY_VERIFIED` docs):** compilazione shader massiva + cold pipeline cache; present wait fino a 4 s per fence durante compile (NX2_NOTES).
- **Direzione:** cache persistente, parallelismo controllato, prewarm, non saltare sync.

## RCA-003 — Texture nere MK World

- **Sintomo:** in-game con texture nere.
- **Causa:** `NOT_STARTED` (da isolare: format view, ASTC GOB, unbound RT, sparse unbacked).

## RCA-004 — FPS bassi DK Bananza

- **Sintomo:** ~10 FPS su telefono 16 GB test upstream.
- **Ipotesi multiple:** shader cost, upscaler stand-in DLSS, CPU sync, driver. Serve profiling Thor.

## RCA-005 — CI non riproduce NDK locale

- Workflow `build-release.yml` NDK 27 vs gradle `28.2.13676358`.
- Rischio: “verde in CI, rotto in locale” o viceversa.
