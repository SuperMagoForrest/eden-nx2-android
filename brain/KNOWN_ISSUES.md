# Known issues

Classificazione: P0 bloccante / P1 alto / P2 medio / P3 basso.
Stato evidenza: se non misurato su Thor in questa sessione → da README/NX2_NOTES = `PARTIALLY_VERIFIED` (upstream-reported).

| ID | Priorità | Issue | Sottosistema | Titoli | Causa | Stato |
|---|---|---|---|---|---|---|
| KI-001 | P0 | RAM elevata / LMKD kill | Memory | Tutti | Layout 12GB+8GB graphics + cache | Open |
| KI-002 | P0 | Thor Base 8 GB non supportato in pratica | Memory/Android | Tutti | Readiness fail <12GB; nessun profilo adattivo | Open |
| KI-003 | P1 | First boot lentissimo (minuti black screen) | Shader/GPU | Pokopia, DK | Shader compile + cold caches | Open |
| KI-004 | P1 | Prestazioni insufficienti | CPU/GPU | DK ~10 FPS, Pokopia 20-30 | Macro/JIT/shader/driver | Open |
| KI-005 | P1 | Texture nere | GPU/Texture | Mario Kart World | TBD | Open |
| KI-006 | P1 | Instabilità driver Adreno | Vulkan | Vari | Query/OOM/sparse | Open |
| KI-007 | P1 | Temperature / drain elevati | Thermal | Sessioni lunghe | Workload continuo | Open |
| KI-008 | P2 | Video playback lento | Host1x/VIC/decoder | Cutscene | AV1/decode path | Open |
| KI-009 | P2 | Riavvio app obbligatorio tra giochi | Android lifecycle | Tutti | State leak sospetto | Open |
| KI-010 | P1 | Task/mesh shaders mancanti | Shader | Alcuni titoli | No VK mesh path | Open |
| KI-011 | P2 | CI NDK mismatch (27 vs 28.2) | Build | — | Workflow vs gradle | Open |
| KI-012 | P3 | Script `tools/nx2/android/*` hardcodati macOS paths | Build/QA | — | `$HOME/Library/Android/sdk` | Mitigato (script `.ps1` Win) |
| KI-013 | P1 | Build Win: `glslangValidator` assente nel PATH | Build | — | host_shaders CMake FATAL | Mitigato (toolchains/bin) |

## Upstream compatibility table (README, telefono 16 GB SM8850)

| Titolo | Stato upstream | Nostro stato Thor |
|---|---|---|
| Pokémon Pokopia (upd 327680) | PLAYABLE 20-30 FPS | `OWNER_REPORTED_IN_GAME` (lag/heat; non strumentato) |
| Donkey Kong Bananza (upd 458752) | IN_GAME lento ~10 FPS | `NOT_TESTED` |
| Mario Kart World 1.0.0 | IN_GAME black textures | `NOT_TESTED` |
| Welcome Tour | Non testato | `NOT_TESTED` |
