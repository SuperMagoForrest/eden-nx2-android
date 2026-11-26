# Libraries

| Libreria / componente | Dove | Responsabilità | Versione nota |
|---|---|---|---|
| Dynarmic | `src/dynarmic` | JIT A64 guest | in-tree |
| Oaknut | CPM | Emit ARM64 per MME macro JIT | v2.0.3 |
| Vulkan headers/utils | CPM | Backend GPU host | v1.4.345 |
| VMA / Sirit / SPIR-V | CPM | Alloc Vulkan / IR shader host | cache build |
| FFmpeg | externals + CPM bundled | Decode media / AV1 path | c7b5f1537d |
| cubeb | CPM | Audio output host | fa02160712 |
| Opus | CPM | Codec audio | cache |
| FidelityFX-FSR | externals | Upscale | tree |
| Glad | externals | GL loader (non path Android primario) | tree |
| STB | externals | Image utils | tree |
| libusb | externals | USB desktop | tree |
| libadrenotools | CPM | Load Turnip/custom drivers | cache |
| Boost | CPM | asio/filesystem/fiber/… | 1.92.0 |
| fmt / lz4 / zstd / zlib | CPM | logging/compress | cache |
| SDL3 | CPM | Input/window paths condivisi | 3.4.x |
| OpenSSL | CPM | crypto/web | 4.0.1-… |
| Kotlin AndroidX / Nav | gradle | UI | build.gradle.kts |
| Mr Purple Turnip | `assets/gpu_drivers` | Driver Adreno alternativo | bundled APK |

Classificazione grezza: **fork SX2A** (Android readiness, nx2 services, ampere lowering patch) vs **upstream Eden/PokeDinner** vs **third-party** (tabella sopra).
