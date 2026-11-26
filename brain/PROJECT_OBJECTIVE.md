# Obiettivi del progetto

## Missione

Trasformare Eden SX2A in un emulatore Nintendo Switch 2 per Android più maturo, stabile, efficiente e compatibile rispetto alla baseline `59bb148`, con target primari AYN Thor Pro (12 GB) e Thor Base (8 GB).

## Priorità (ordine fisso)

1. Correttezza dell'emulazione
2. Estensione compatibilità catalogo Switch 2
3. Risoluzione bug strutturali
4. Eliminazione crash/freeze/black screen/rendering errato
5. Prestazioni CPU/GPU
6. Riduzione memoria
7. Fluidità / frame pacing
8. Consumi / temperature
9. Stabilità sessioni lunghe
10. Semplicità UX

## Target memoria (ingegneristici, da validare)

| Profilo | RAM host | Budget emulatore (target iniziale) | Stato |
|---|---|---|---|
| Thor Base | 8 GB | 4.5–5 GB attributabili all'app | `NOT_STARTED` |
| Thor Pro | 12 GB | 6–7 GB attributabili all'app | `NOT_STARTED` |

**Nota critica (`VERIFIED` dal codice):** il layout guest 12 GB alloca `12_GiB + Nx2GraphicsServerMemorySize (8_GiB)` = **20 GiB** di DRAM guest intenzionale (`k_system_control.h` / `k_system_control.cpp`). Questo non è RSS host 1:1, ma spiega perché 8 GB host sono strutturalmente a rischio senza lazy/sparse allocation.

## Criteri di completamento release

- Build APK riproducibile
- Batteria regressione superata
- Matrice compatibilità aggiornata con evidenze
- Metriche memoria/FPS/termiche misurate su Thor
- Distinzione esplicita verificato vs non verificato
- Rollback path documentato
- Licenze rispettate (GPLv3+)

## Non dichiarare mai

- Compatibilità totale senza evidenze di gameplay
- Prestazioni “risolte” senza confronto baseline
- Supporto Thor Base solo perché il menu permette un layout minore
