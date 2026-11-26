# GPU architecture

## Pipeline (alto livello)

1. Titolo parla a **NVN2 / Ampere** via `nx2:nvsrv` / `nx2:gpu` / `nx2:gsv` / `nx2:vi2` / syncpt.
2. Command buffers → DmaPusher / engines Maxwell con classi Ampere mappate.
3. **MME64 / Turing macro JIT** (backend oaknut arm64 su Android).
4. Shader SASS SM86 → `shader_recompiler/frontend/ampere/lower_to_maxwell.*` → IR Maxwell → host (Vulkan SPIR-V).
5. Texture/buffer cache → `renderer_vulkan` → present via vi2 229 (crop, pacing).

## Moduli chiave

| Area | Path | Note |
|---|---|---|
| Ampere lowering | `src/shader_recompiler/frontend/ampere/` | HSETP2 `0x234`, conflict merge |
| Vulkan renderer | `src/video_core/renderer_vulkan/` | Adreno query workaround |
| Vulkan device | `src/video_core/vulkan_common/` | Turnip detection |
| Macro / engines | `src/video_core/engines/` | Kepler compute QMD, Maxwell 3D |
| GSV / VI2 | `src/core/hle/service/nx2_gsv.h` | Present crop, sync |
| ASTC | host shaders / texture decode | GOB swizzle NS2 |
| Driver Android | assets `gpu_drivers`, `DriverResolver.kt` | Mr Purple Turnip T30 |

## Workarounds Adreno documentati (`NX2_ANDROID.md`, `VERIFIED` come intent)

- No host occlusion queries per programmi Switch 2 (`vkCmdBeginQuery` crash)
- Storage buffer cap = plain limit su Qualcomm/ARM
- Storage CAS write helper sempre definito se usato
- Texel views unmapped → formato forzato (Pokopia)
- RT non creabili → unbound
- Large sparse images / unbacked over 2^28 texels (storia NX2_NOTES)

## Problemi aperti noti (upstream docs)

- Texture nere (Mario Kart World)
- Prestazioni basse (DK Bananza ~10 FPS sul telefono di test 16 GB)
- Shader compile stalls / first-boot lento
- Task/mesh shaders non supportati (alcuni titoli)
- Video playback lento

## Driver strategy

Non assumere “Turnip più nuovo = meglio”. Confrontare stock Adreno 740 vs Turnip bundled con evidenze per titolo.
