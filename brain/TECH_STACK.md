# Tech stack

| Layer | Tecnologia | Evidenza |
|---|---|---|
| Linguaggi | C++ (core), Kotlin/Java (Android), ASM (NCE), Python (tools) | tree `src/` |
| Build native | CMake + Ninja + NDK clang | `externalNativeBuild` |
| Build Android | Gradle 8.13, AGP, JDK 17 target / CI JDK 21 | wrapper + CI |
| CPU emu | Dynarmic JIT; NCE opzionale | `src/dynarmic`, `arm/nce` |
| GPU emu | Tegra Maxwell/Ampere HLE + Vulkan | `video_core` |
| Shader | Custom recompiler Ampere→Maxwell→SPIR-V | `shader_recompiler` |
| Macro JIT | Oaknut ARM64 backend | `NX2_ANDROID.md` |
| Grafica host | Vulkan, Adreno stock / Turnip | renderer_vulkan |
| Audio | audio_core + nx2 aud:u bridge | services |
| Dipendenze | CPM (`YUZU_USE_CPM=ON`), bundled FFmpeg | gradle cmake args |
| CI | GitHub Actions `build-release.yml` | `.github/workflows` |
| License | GPL-3.0-or-later (progetto) | LICENSE / REUSE |
