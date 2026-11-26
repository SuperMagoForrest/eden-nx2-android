# Optimization strategy

Ordine vincolato dalla correttezza.

## Fase A — Misura (M2/M8)

1. Baseline APK invariata funzionalmente.
2. Su Thor Pro: boot titolo seed, meminfo, perfetto/simpleperf sample, termiche, FPS overlay.
3. Registrare in `PERFORMANCE_BASELINE.md`.

## Fase B — Memoria strutturale (M5)

1. Mappare commit vs reserve per DRAM guest e Vulkan.
2. Ridurre resident set senza cambiare GetInfo a caso.
3. Budget dinamici Thor Base/Pro.
4. Cache eviction shader/texture sotto pressione.

## Fase C — GPU correctness (M4)

1. Black textures / unbound RT / sparse.
2. Lowering gap (task/mesh separato).
3. Driver A/B Adreno vs Turnip.

## Fase D — CPU/GPU performance (M6)

1. Hot path JIT/macro/HLE locks.
2. Frame pacing già presente: non rompere per “FPS peak”.
3. Parallelismo shader compile con limiti termici.

## Fase E — Thermal (M7)

1. Frame cap / adaptive res espliciti e configurabili.
2. Nessun bypass protezioni.

## Divieti

- Disabilitare sync per alzare FPS.
- Fake frames.
- Title hack se esiste fix sottosistema.
- Overcommit intenzionale che aumenta kill rate.
