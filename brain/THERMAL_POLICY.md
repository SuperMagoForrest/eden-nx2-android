# Thermal policy — laboratorio Thor

## Fonti affidabili (no root)

| Fonte | Stato su Thor Pro | Uso |
|---|---|---|
| `dumpsys battery` temperature (/10 °C) | VERIFIED | Watchdog abort ≥ 70 °C |
| `dumpsys thermalservice` Thermal Status | VERIFIED (status code) | Abort se ≥ 3 (SEVERE) |
| HAL temperatures list | Spesso `HAL Ready: false` | Non affidabile |
| Overlay temp Thor | OWNER_REPORTED | Confrontare, non unica verità |

## Policy test

- Target sostenuto indicato: 60–65 °C (sensore confrontabile).
- Abort workload test a 70 °C batteria o thermal status severe.
- Non stress test continui senza watchdog (`thor_diagnostics.ps1 -DurationSec …`).

## Azioni software (progressive)

NORMAL → WARM → PRESSURE → THERMAL_CONSTRAINED → RECOVERY

Azioni candidate: limitare pipeline workers, rafforzare frame pacing, ridurre lavoro background, budget cache. Mai ridurre silenziosamente emulation speed %; mai root/sysfs.
