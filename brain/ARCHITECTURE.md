# Architecture

## Stack logico

```
Android UI (Kotlin)
  → JNI (native_*.cpp / emu window)
    → Core::System (core.cpp)
      → Loader (ExeFS/NUP/NCA)
      → Kernel HLE (KProcess, page tables, SVC)
      → CPU (Dynarmic JIT / NCE) × 6 cores
      → Services HLE (AM, FS, HID, audio, nx2:gsv/gpu/vi2/syncpt/nvsrv)
      → Tegra GPU emu (DmaPusher, engines, macro JIT)
      → Shader recompiler (Ampere→Maxwell→Vulkan)
      → Vulkan backend + Adreno/Turnip
      → Present / audio / input
```

## Moduli `src/` (`VERIFIED` inventory)

| Directory | Ruolo |
|---|---|
| `android/` | App Gradle/Kotlin/JNI |
| `core/` | Sistema, kernel HLE, memoria, loader, ARM |
| `video_core/` | GPU Tegra, Vulkan, texture/buffer cache |
| `shader_recompiler/` | Frontend SASS + IR + backend host |
| `dynarmic/` | JIT CPU guest |
| `audio_core/` | Audio HLE |
| `hid_core/` / `input_common/` | Input |
| `common/` / `frontend_common/` | Utility condivise |
| `tests/` | Unit test native |
| `yuzu*` / `qt_common/` | Frontend desktop (non path Android primario) |

## Contratti critici

1. **Switch 2 detection** → layout 12 GB + CNTFRQ 31.25 MHz.
2. **GPU VA ≈ CPU VA** per memory registrata via nx2:gpu (identity map registry).
3. **Present pacing** vi2 229 + vblank ~60 Hz.
4. **Merge PokeDinner**: merge not rebase; hotspot file list in `NX2_ANDROID.md`.

## Sincronizzazione

- CPU guest ↔ GPU: semaphores, syncpoints, QMD releases, channel suspend on unmet acquire.
- Host: Vulkan fences/barriers; Adreno-sensitive query path disabled for NS2.

## Ownership memoria

- Application pool / applet pool / non-secure system pool (kernel board NX).
- GPU-only sparse regions backed from system pool (post-fix 5cff620 era).
- Host Vulkan images/buffers separate accounting (`ImageMemoryBytes`).
