# Thermal policy 2.0 (laboratorio)

## Sensori

| Sorgente | Uso |
|---|---|
| AYN dashboard (foto owner) | Confronto qualitativo owner |
| `/sys/class/thermal/thermal_zone*` | Best-effort SoC-comparable senza root |
| `dumpsys battery` temperature | **Non** usare come soglia operativa SoC |
| `dumpsys thermalservice` Thermal Status | Abort se ≥ SEVERE (3+) |

## Soglie laboratorio (sensore SoC-comparable)

| Fascia | Azione |
|---|---|
| 50–55 °C | Target desiderato gameplay |
| >55 °C | Osserva trend |
| ~60 °C | Riduci lavoro non essenziale (workers / job non urgenti) |
| ~65 °C | Modalità conservativa |
| ≥70 °C SoC | Abort benchmark/watchdog |
| Thermal Status SEVERE+ | Abort workload |

Non sono specifiche ufficiali AYN.

## Limiti noti Alpha 0.1c

`android_pipeline_workers` letto a creazione pipeline cache → cambio live inefficace.  
Alpha 0.2: documentato; dynamic work budget da estendere dopo boot recovery.
