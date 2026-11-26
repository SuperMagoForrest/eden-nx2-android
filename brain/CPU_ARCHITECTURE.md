# CPU architecture

## Overview

| Componente | Percorso | Stato audit |
|---|---|---|
| Dynarmic (JIT A64) | `src/dynarmic`, `src/core/arm/dynarmic` | Interfaccia `PARTIALLY_VERIFIED` |
| NCE (Native Code Execution) | `src/core/arm/nce/*` | Presente; stub decoder NS2 su Android (`NX2_ANDROID.md`) `PARTIALLY_VERIFIED` |
| Hypervisor path | `src/core/arm/hypervisor` | Desktop/Apple-oriented; non path Android primario |
| Exclusive monitor | `exclusive_monitor.*` | Allineato a 6 core |
| Core count | `hardware_properties.h`: `NUM_CPU_CORES = 6` | `VERIFIED` |

## Switch 2 specifics (`VERIFIED` da note + codice)

- Titoli NS2 richiedono core 0..5; Eden emula 6 core fisici (evita due worker sullo stesso core).
- Decoder Dynarmic esteso per LSE, CAS/CASP, LDAPR, PAC/XPAC, MTE (approssimazioni documentate in `NX2_NOTES.md`).
- Contatore guest: Switch 2 usa 31.25 MHz (`Switch2CNTFRQ`) vs 19.2 MHz Switch 1 (`core.cpp`).
- NCE `visitor_base.h` deve restare allineato a `a64.inc` / `impl.h` di Dynarmic (conflict hotspot in merge PokeDinner).

## Hot path da profilare

1. Costo traduzione JIT / code cache size
2. Contesa lock HLE / SVC
3. Context switch tra 6 core emulati su big.LITTLE Adreno host
4. Busy-wait su syncpoint/semaphore (storicamente fonte di spin)

## Tooling

- `tools/nx2/a64_coverage.py` — coverage decoder vs NSO
- `tools/nx2/jit_fuzz` — macro JIT vs interpreter (0 mismatch documentato)
- simpleperf / Perfetto su device

Stato profiling Thor: `NOT_STARTED`.
