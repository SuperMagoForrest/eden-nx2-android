# Libraries

| Libreria / componente | Dove | Responsabilità | Note |
|---|---|---|---|
| Dynarmic | `src/dynarmic` | JIT A64 guest | Estensioni NS2 decoder |
| Oaknut | (via macro JIT) | Emit ARM64 host per MME | Documentato NX2_ANDROID |
| Vulkan headers / loader | video_core / Android | Backend GPU host | |
| FFmpeg (bundled) | externals/CPM | Decode media | AV1 path NS2 |
| FidelityFX-FSR | externals | Upscale | |
| Glad | externals | GL loader (path non Android primario) | |
| STB | externals | Image utils | |
| libusb | externals | USB host (desktop) | |
| adrenotools / Turnip zip | android assets | Custom GPU driver load | Mr Purple |
| Kotlin AndroidX / Navigation | gradle | UI | |
| ktlint / play publisher | gradle plugins | Qualità / publish | |

Versioni esatte: consultare lock CPM / gradle resolution output della build baseline quando disponibile.
