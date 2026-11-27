# Root cause analysis — Thor Pro / Pokopia samples

## Sintomi OWNER_REPORTED

Lag, micro-stutter, scatti, temp 57→74 °C in ~3 min, RAM sistema ~8–10 GB, FPS overlay 38–55, shader compile bursts (41+4).

## Cause strutturali (codice, VERIFIED)

| ID | Causa | Evidenza | Mitigazione SX2A |
|---|---|---|---|
| RC-1 | Frame pacing disabilitato su Android API≥30 | `vk_swapchain.cpp` Wait(…,0) | Ripristinato + default 30 |
| RC-2 | Pace NX2 legato solo a use_speed_limit | `nx2_gsv.h` PaceToVblank | Cap FPS indipendente |
| RC-3 | Close guest → MarkDirty → Clear tocca pagine | `k_memory_manager` + host_memory | ReleaseBackingRegion |
| RC-4 | Layout guest 12+8 GiB potenziale | MEMORY_ARCHITECTURE | Lazy + reclaim; no GetInfo lie |
| RC-5 | Shader compile sync durante scene | OWNER + overlay shader count | Da ottimizzare (M5) |

## Ipotesi (da misurare su candidate)

| ID | Ipotesi | Come verificare |
|---|---|---|
| H-1 | Cap 30 FPS riduce temp/power a parità scena | diag + battery temp + PSS |
| H-2 | Reclaim riduce PSS dopo free guest | meminfo samples warm |
| H-3 | Stutter correlato a pipeline compile | logcat shader + frametime |

## Non cause automatiche

- Tutta la RAM overlay ≠ PSS emulatore
- Temp overlay ≠ solo GPU
- FPS Thor ≠ frame guest autenticati
