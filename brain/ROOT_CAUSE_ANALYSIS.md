# Root cause analysis — Alpha 0.1c Pokopia boot regression

**Aggiornato:** 2026-11-27  
**HEAD analisi:** `d14fcd4ba6`  
**Evidenze:** `F:\DEV\EDEN_SX2A\logs\diag-20261127-125536` + `logs\crash-forensics-20261127`

## Verdict

La regressione Alpha 0.1c **non** è un crash C++/Vulkan signalizzato.  
Il processo Android è stato terminato da **LMKD** con `ApplicationExitInfo reason=3 (LOW_MEMORY)`.

| PID | Timestamp | Exit reason | PSS / RSS | Importanza |
|---|---|---|---|---|
| 18650 | 12:57:33 | LOW_MEMORY | 4,7 / 5,0 GB | FOREGROUND (100) |
| 19764 | 12:59:12 | LOW_MEMORY | 5,0 / 5,3 GB | FOREGROUND (100) |

Subito prima del primo kill: cascata di morte di processi background (mem-pressure-event).  
Dopo il kill Android riavvia MainActivity → percezione “ritorno alla libreria”.

## Timeline (sessione diag)

1. 12:55:44 — Start proc 18650, EmulationActivity  
2. 12:55–12:57 — PSS sale a ~5,1–5,6 GB; MemAvailable scende ~2,9 GB; Swap app ~2 GB  
3. 12:57:31 — pressione memoria sistema (molti processi muoiono)  
4. 12:57:33 — **18650 LOW_MEMORY kill** → restart 19764  
5. 12:57:36 — nuovo avvio EmulationActivity  
6. 12:59:12 — **19764 LOW_MEMORY kill** → restart 21379 (libreria idle)

Battery dumpsys resta a 23 °C: **non** è il sensore dashboard AYN (58–65 °C foto owner).

## Fattori strutturali nel diff 59bb148…d14fcd4

### P0 — Host reclaim incorrect (correttezza + possibile peggioramento pressione)

`KMemoryManager::Close` chiamava `ReleaseBackingRegion` **prima** del decremento refcount → reclaim su pagine ancora referenziate.

`ReleaseBackingRegion` azzerava i flag granule anche quando solo `MADV_DONTNEED` su memfd **shared** (contenuto non zero-garantito) → `ClearBackingRegion` poteva saltare lo zeroing reale.

### P1 — Doppio frame pacing

Cap FPS in `PaceToVblank` **e** in `vk_swapchain::AcquireNextImage` → attese accumulate; non causa diretta del LOW_MEMORY, ma può allungare il loading sotto pressione.

### P2 — GC aggressivo su trim moderato

`onTrimMemory` mappava BACKGROUND/RUNNING_MODERATE → pressure elevated → buffer GC anticipato → rischio thrash durante load.

## Correzione Alpha 0.2 (in corso)

1. Reclaim solo quando refcount → 0 (`OnPagesFreed`).  
2. `BackingReleaseResult`: clear dirty solo se `ZeroGuaranteed`.  
3. Pacing: sola autorità host in Vulkan; NX2 resta sul guest swap-interval.  
4. Pressure elevated da Low/Critical; UI_HIDDEN non forza GC.  
5. Diagnostica: parse PSS/RSS/SWAP corretto, PID, exit-info, thermal zones, stop verificato.

## Non dimostrato come causa primaria

- Fatal signal / tombstone per `dev.eden.nx2.relWithDebInfo` nella finestra 12:55–12:59  
- Vulkan device lost  
- Guest exception signalizzata  
- Temperatura SoC come trigger del kill
