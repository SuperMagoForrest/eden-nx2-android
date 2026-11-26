# Dependencies

Aggiornato dopo fallimento subagent audit (usage limit): inventario locale `VERIFIED` su `cpmfile.json`, `externals/`, `.cache/cpm` post-build.

## Android / Gradle

- Repo: Google Maven, Maven Central (`settings.gradle.kts`).
- NDK: `28.2.13676358` (`app/build.gradle.kts`) — CI allineata nello stesso fork (`build-release.yml`).
- CMake Android: `3.31.5` (gradle `externalNativeBuild`).

## Native via CPM (`YUZU_USE_CPM=ON`, `CPMUTIL_FORCE_BUNDLED=ON`)

Versioni da `cpmfile.json` / cache build (estratto rilevante):

| Pacchetto | Versione / ref | Note |
|---|---|---|
| Boost | 1.92.0 | bundled components |
| fmt | 12.1.0 | |
| lz4 | ebb370ca83 / 1.10.0 | |
| zstd / zlib | in cache | |
| oaknut | v2.0.3 | macro JIT ARM64 |
| VulkanHeaders / UtilityLibraries | v1.4.345 | |
| vulkan-validation-layers | vulkan-sdk-1.4.341.0 | |
| VMA / spirv-headers / sirit | in cache | |
| cubeb | fa02160712 | audio host; AAudio/OpenSLES su Android |
| SDL3 | 3.4.14-… | bundled |
| OpenSSL | 4.0.1-… | |
| enet | v1.3.18 | |
| httplib | v0.46.0 | patched |
| opus | in cache | |
| ffmpeg | c7b5f1537d (+ bundled Android) | `YUZU_USE_BUNDLED_FFMPEG=ON` |
| nlohmann_json / cpp-jwt / SimpleIni / frozen | in cache | |
| libadrenotools / linkernsbypass | in cache | custom GPU drivers Android |
| Catch2 | v3.13.0 | test desktop |
| biscuit | v0.19.0 | |
| gamemode | ce6fe122f3 | desktop Linux |

## `externals/` (vendored tree, non submodule)

`bc_decoder`, `cmake-modules`, `demangle`, `ffmpeg`, `FidelityFX-FSR`, `getopt`, `glad`, `libusb`, `nx_tzdb`, `renderdoc`, `stb`, `tz`, (+ `generated`).

## In-tree (non solo CPM)

- `src/dynarmic` — JIT CPU
- Nessun `.gitmodules` — `VERIFIED`

## Toolchain host

- SDK + NDK 28.2 + CMake 3.31.5 + `toolchains/bin/glslangValidator`
- JDK 21 build / target bytecode 17
- WSL ThorLinux: cmake/ninja/clang++ / glslang

Aggiornare questo file quando si aggiunge una dipendenza (ADR in `DECISIONS.md`).
