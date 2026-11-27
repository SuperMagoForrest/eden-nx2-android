# Memory reclaim validation

## Contratto

`HostMemory::ReleaseBackingRegion` restituisce `BackingReleaseResult`:

| Risultato | Flag granule | ClearBackingRegion(0) |
|---|---|---|
| ZeroGuaranteed | cleared (unused+clean) | può saltare memset |
| RssHintOnly / Failed / Unsupported | MarkDirty | deve azzerare |
| NotEligible (parziale) | MarkDirty | deve azzerare |

## Call site

Solo `KMemoryManager::OnPagesFreed` dopo refcount → 0.

## Test

- `HostMemory: ReleaseBackingRegion clears full granules`
- `HostMemory: ReleaseBackingRegion partial granule stays dirty`
- `HostMemory: reallocate after release reads zeros`

Host Windows: ZeroGuaranteed non atteso (MEM_RESET = RssHintOnly).  
POSIX/Android: punch hole → ZeroGuaranteed.

## Stato

- Implementato: sì  
- Test host Win: da eseguire se harness disponibile  
- Test Android memfd: da validare su Thor con Alpha 0.2  
- Default `release_host_backing`: true su Android (con contratto corretto)
