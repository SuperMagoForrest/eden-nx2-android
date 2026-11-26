# Hardware target

## Primario — AYN Thor Pro

| Campo | Valore | Stato |
|---|---|---|
| SoC | Snapdragon 8 Gen 2 | `VERIFIED` (requisito progetto) |
| CPU | ARM64 | `VERIFIED` |
| GPU | Adreno 740 | `VERIFIED` |
| RAM | 12 GB | `VERIFIED` |
| OS | Android | `VERIFIED` |
| Dev options / ADB | Attivi | `VERIFIED` (dichiarato proprietario) |
| Disponibilità fisica | Sì | `VERIFIED` (dichiarato) |

## Secondario — AYN Thor Base

| Campo | Valore | Stato |
|---|---|---|
| SoC | Snapdragon 8 Gen 2 | `VERIFIED` |
| GPU | Adreno 740 | `VERIFIED` |
| RAM | 8 GB | `VERIFIED` |
| Validazione fisica | Non ancora | `NOT_STARTED` |
| Approccio intermedio | Budget simulati / pressure test | `HYPOTHESIS` |

## Implicazioni architetturali

1. ABI build: **solo `arm64-v8a`** per flavor `mainline` (`build.gradle.kts`).
2. Driver: Adreno stock + Turnip Mr. Purple T30 bundled (`DriverResolver.kt`, assets `gpu_drivers`).
3. README upstream richiede idealmente 16 GB; Thor Base 8 GB è fuori dalla comfort zone documentata → obiettivo strutturale del fork.
4. Readiness check segnala Fail sotto 12 GB host (`strings.xml`: `readiness_ram_too_low`).

## Sessioni device

Quando il Thor Pro è collegato: batteria consolidata (ADB id, termiche, meminfo, install diagnostica, titoli legittimi, soak 30/60 min). Non micro-test isolati che richiedono intervento continuo.
