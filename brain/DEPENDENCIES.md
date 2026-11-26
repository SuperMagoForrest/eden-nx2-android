# Dependencies

## Android / Gradle

- Gestite da `src/android` (Google Maven, Maven Central). Dettaglio versioni plugin in `build.gradle.kts` / version catalogs se presenti.
- NDK side-by-side `28.2.13676358` (gradle) — CI workflow cita ancora NDK 27 → drift.

## Native via CPM / CMake

- Flag: `-DYUZU_USE_CPM=ON -DCPMUTIL_FORCE_BUNDLED=ON -DYUZU_USE_BUNDLED_FFMPEG=ON`
- `cpmfile.json` + `externals/` forniscono librerie (ffmpeg, glad, stb, libusb, FidelityFX-FSR, demangle, bc_decoder, renderdoc, tz, …).
- Dynarmic è in-tree (`src/dynarmic`), non solo external.

## Submodule

- `.gitmodules` assente nel clone analizzato — dipendenze principalmente CPM/vendored copy, non submodule git classici. Stato: `VERIFIED` (nessun file `.gitmodules`).

## Toolchain host (dev PC)

- Android SDK + NDK 28.2 + CMake 3.31.5/3.31.6
- JDK 21 (build) / 17 (bytecode target)
- WSL ThorLinux opzionale per tool Unix

Aggiornare questo file quando si aggiunge una dipendenza (motivazione in `DECISIONS.md`).
