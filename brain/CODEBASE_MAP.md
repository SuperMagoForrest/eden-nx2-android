# Codebase map

Inventario grezzo baseline `59bb148`: ~3153 file C/C++ header/source, ~4684 file totali versionati nel clone shallow-ish (full history 29588 commits).

## Top-level

| Path | Ruolo | Classificazione |
|---|---|---|
| `src/` | Codice emulatore + Android | Misto upstream + fork SX2A |
| `externals/` | Terze parti vendored | Third-party |
| `tools/nx2/` | Tooling Switch 2 / Android QA | Fork / experiment |
| `.ci/` | Script CI build Android | Upstream Eden + fork |
| `.github/` | Actions release APK | Fork SX2A |
| `docs/` | Docs + policies + sx2a screenshots | Misto |
| `dist/` | Distribuzione | Upstream |
| `CMakeModules/` | CMake helpers | Upstream |
| `brain/` | Memoria progetto SuperMagoForrest | **Nostro** |
| `.cursor/` | Skills/rules agenti | **Nostro** |

## `src/core` focus NS2

- `hle/service/nx2_gsv.h` — GSV/VI2/GPU/syncpt sessions
- `hle/kernel/board/nintendo/nx/*` — memory sizes 10/12GB
- `arm/nce/*` — NCE + visitor stubs
- `loader/*` — loose ExeFS, NUP
- `memory*` / `device_memory*` — host/guest memory

## `src/video_core` focus

- `renderer_vulkan/*`, `vulkan_common/*`
- `engines/*` (maxwell_3d, kepler_compute, fermi_2d, …)
- `texture_cache/*`, `buffer_cache/*`
- `dma_pusher.*`, `host1x/*`

## `src/android` focus

- `app/build.gradle.kts` — flavors, NDK 28.2, cmake args
- `app/src/main/java/.../fragments/Switch2ReadinessFragment.kt`
- `app/src/main/java/.../utils/{GameHelper,DriverResolver,BugReport}.kt`
- `app/src/main/jni/` — bridge nativo
- `app/src/main/assets/gpu_drivers/` — Turnip bundle

## Generato / non auditare come source

Build intermediates sotto `src/android/app/.cxx`, `build/`, `artifacts/` — restano fuori git.
