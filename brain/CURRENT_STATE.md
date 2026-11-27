# Current state

**Aggiornato:** 2026-11-27 — Alpha 0.2 recovery in corso

## Git

- Branch: `sx2a/dev`
- HEAD all’inizio sessione: `d14fcd4ba6` (Alpha 0.1c)
- Baseline protetta: `59bb148`
- Working tree: fix reclaim/pacing/pressure/diagnostics (non ancora commit)

## Causa regressione 0.1c (dimostrata)

- **LMKD LOW_MEMORY** su Pokopia load (ApplicationExitInfo pid 18650/19764)
- Reclaim unsafe (prima del Free) + dirty tracking errato
- Doppio pacing NX2+Vulkan
- GC su trim moderato

Vedi `ROOT_CAUSE_ANALYSIS.md`.

## Device

- Thor Pro ONLINE (`905d41b5`)
- Package: `dev.eden.nx2.relWithDebInfo` ancora su Alpha 0.1c finché non si installa 0.2

## Prossimo passo

1. Completare fix + build RelWithDebInfo  
2. Installare candidate Alpha 0.2  
3. Validare Pokopia boot senza LOW_MEMORY  
4. Misura pacing/thermal/memoria
