# Memory architecture

## Distinzioni obbligatorie

| Concetto | Significato | Non confondere con |
|---|---|---|
| Guest virtual address space | Spazio indirizzi processo Switch (39-bit per titoli NS2) | RSS Android |
| Guest DRAM layout | Taglia DRAM emulata (4/6/8/10/12 GB + extra) | Memoria fisica host |
| Committed / mapped | Pagine host associate | Solo riservate |
| RSS/PSS/USS | Occupazione processo Android | Layout guest |
| GPU allocations | Image/buffer Vulkan + driver | Heap CPU |

## Layout guest (`VERIFIED`)

Impostazione: `Settings::values.memory_layout_mode` (`Memory_4Gb` … `Memory_12Gb`).

Implementazione: `src/core/hle/kernel/board/nintendo/nx/k_system_control.cpp`.

| Layout UI | GetIntendedMemorySize | Application pool |
|---|---|---|
| 4 GB | 4 GiB | 3285 MiB |
| 6 GB | 6 GiB | 4916 MiB |
| 8 GB | 8 GiB | 6547 MiB |
| 10 GB | 10 GiB | 8178 MiB |
| 12 GB | **12 GiB + 8 GiB** (`Nx2GraphicsServerMemorySize`) | 9809 MiB |

`Nx2GraphicsServerMemorySize = 8_GiB` in `k_system_control.h` — memoria extra per regioni GPU-only `nx2:gpu` 214 nel non-secure system pool.

### Auto-switch Switch 2

`Core::System::Load` (`core.cpp`): se `IsSwitch2Program`, forza layout `Memory_12Gb` come per-game setting. Stato: `VERIFIED`.

## Implicazione Thor

- Thor Pro 12 GB host non può residentare 20 GiB guest: la correttezza dipende da **lazy commit**, sparse mapping, e dal fatto che gran parte della DRAM guest resti non toccata.
- Thor Base 8 GB è ancora più critico: readiness check upstream fallisce sotto 12 GB host.
- **Obiettivo M5:** ridurre costo fisico host senza alterare le aspettative guest (GetInfo total memory, heap sizing dei titoli).

## Host backing (`VERIFIED`)

`DeviceMemory::DeviceMemory()` costruisce `Common::HostMemory` con:
- `backing_size = GetIntendedMemorySize()` → fino a **20 GiB** sul layout 12 GB
- `virtual_size = VirtualReserveSize`: `1<<38` se `HAS_NCE`, altrimenti `1<<39` (`device_memory.cpp`) — riserva VA host enorme con `MAP_NORESERVE`

Su **Android/POSIX** (`host_memory.cpp`):
- `memfd_create` + `ftruncate(fd, backing_size)` + `mmap` SHARED dell'intero backing
- Lo spazio virtuale guest usa `MAP_NORESERVE` (non committa RSS finché non toccato)
- Il backing memfd da 20 GiB **non** è automaticamente 20 GiB RSS, ma ogni clear/touch pagina materializza memoria (`ClearBackingRegion` documenta che clearare forza pagine reali)

Su **Windows desktop**: `CreateFileMapping2(..., SEC_COMMIT, backing_size)` — rischio commit aggressivo (path non Thor).

Implicazione M5: ridurre RSS = evitare touch/clear inutili, sparse GPU, eviction cache, possibilmente strategy di backing lazy più aggressiva senza mentire a GetInfo.

## Aree codice correlate

- `src/common/host_memory.{h,cpp}` — allocate/map/protect/clear granules
- `src/core/device_memory.{h,cpp}` — DRAM guest buffer
- `src/core/memory.cpp` / `device_memory_manager*` — mapping guest↔host
- `src/core/hle/kernel/k_page_table*` — page tables
- `src/core/hle/service/nx2_gsv.h` — GSV / sparse GPU regions
- `src/video_core/memory_manager.*` — GMMU
- Dynarmic per-block vectors / fiber stacks non inizializzati (nota `NX2_ANDROID.md`)
- Android: `BugReport.kt` + `ApplicationExitInfo.REASON_LOW_MEMORY`, readiness check

## Metriche da raccogliere (non ancora acquisite)

RSS, PSS, anon, GPU, JIT cache, shader/pipeline cache, peak, LMKD kills — su Thor Pro con dumpsys/heapprofd (`tools/nx2/android/heapprofd*`).

Stato misurazioni: `NOT_STARTED`.
