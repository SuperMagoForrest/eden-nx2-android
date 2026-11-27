# Thor Base 8 GB readiness

**Stato:** `THOR_BASE_READY_FOR_PHYSICAL_VALIDATION` — **non** `THOR_BASE_VERIFIED`

## Rilevamento

`ThorHardwareProfile.detect`:
- Thor + totalMem 7000–9500 MB → BASE
- Thor + totalMem ≥ 9500 MB → PRO

Android riporta spesso meno della capacità nominale: le fasce lo contemplano.

## Budget progettuali (da verificare)

| Metrica | Base | Pro |
|---|---|---|
| PSS emulatore | 4,5–5 GB | 5,5–6 GB |
| RAM sistema | ≤ 6,5 GB | ≤ 8 GB |
| FPS default | 30 | 30 |
| Guest speed | 100% | 100% |
| Temp desiderata | 50–55 °C | 50–55 °C |

## Misure preventive Alpha 0.2

- Reclaim corretto (solo Free, ZeroGuaranteed)
- GC buffer solo su pressure Low+
- Pipeline workers Base = 1
- Profile pref `sx2a_thor_profile_applied_v2`

## Non fare

- Non saturare Thor Pro per simulare Base
- Non rimuovere warning RAM senza budget verificati
- Non dichiarare VERIFIED senza device 8 GB fisico
