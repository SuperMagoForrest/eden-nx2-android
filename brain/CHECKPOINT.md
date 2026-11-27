# Checkpoint — Alpha 0.2b candidate

**Aggiornato:** 2026-11-27

## Git

- Branch: `sx2a/dev`
- HEAD: `1176e9f092` (boot present grace + progressive GC)
- Reclaim/pacing fix base: `efd4e3447a`

## APK

### Alpha 0.2 (prima candidate)
- `eden-sx2a-thor-opt-alpha02-relWithDebInfo.apk`
- SHA256 `DDD9C30C577C475F1D3FA8BF74F612CD44642D3E868B73F0DEE2C6631D78E48D`
- **Ancora LMKD** in loading (pid 2685)

### Alpha 0.2b (corrente)
- `eden-sx2a-thor-opt-alpha02b-relWithDebInfo.apk`
- SHA256 `86A996798422C11125D109F57AFCFC50E6B79B4C4B8300A2D23A4145EF8B6C8C`
- versionName `nx2-android-v0.3.3-20-relWithDebInfo` (34418286)
- Novità: grace ~900 present senza cap host; GC Moderate/Low progressivo
- Config: frame_pacing_mode=1 (30), reclaim ON

## Validazione

- PENDING: avvio Pokopia su 0.2b
