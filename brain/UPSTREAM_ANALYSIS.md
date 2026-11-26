# Upstream analysis

## Genealogia (`VERIFIED` da README / NX2_ANDROID.md)

```
Eden (eden-emu)
  → Eglantine
    → PokeDinner-a-Eglantine-Fork (base v0.3+)
      → eden-nx2-android / Eden SX2A (JaviiDeveloper)
        → fork SuperMagoForrest (questo workspace)

Branche precedenti SX2A:
  v0.2.1/v0.2.2 ← Eden-NS2
  older ← Takoroka eden-nx2
```

## Strategia integrazione

- **Merge, never rebase** onto PokeDinner (`NX2_ANDROID.md`).
- README: sezione fork in cima; sotto il divider testo PokeDinner.
- Conflict hotspot:
  - `src/core/hle/service/nx2_gsv.h`
  - `src/shader_recompiler/frontend/ampere/lower_to_maxwell.h` (HSETP2 `0x234`)
  - `deconstructed_rom_directory.cpp`
  - `src/core/arm/nce/visitor_base.h` ↔ dynarmic `a64.inc`
- Preferire warning flag in `src/CMakeLists.txt` piuttosto che editare file PokeDinner per `-Werror` Android.

## Remote consigliati

| Remote | URL |
|---|---|
| origin | `https://github.com/SuperMagoForrest/eden-nx2-android.git` |
| upstream | `https://github.com/JaviiDeveloper/eden-nx2-android.git` |
| pokedinner | `https://git.eden-emu.dev/Franseven/PokeDinner-a-Eglantine-Fork.git` (da aggiungere quando serve sync) |

## Tags baseline

- `nx2-android-v0.3.1`, `v0.3.2`, `v0.3.3`
- HEAD baseline = post-merge `304a014` + fix HSETP2 `59bb148`

## Policy AI upstream

`docs/policies/AI.md` + `AGENTS.md`: no PR/push per conto utente verso upstream; disclosure AI; no Signed-off-by da agent. Per **il nostro fork** i commit locali di engineering sono autorizzati dal brief di progetto; **nessuna PR verso JaviiDeveloper/PokeDinner/Eden senza richiesta esplicita**.
