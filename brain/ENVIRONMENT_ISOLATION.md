# Environment isolation

## Obiettivo

Separare (1) codice versionato del fork, (2) toolchain/artefatti locali, (3) dati di test sensibili, (4) altri progetti sotto `F:\DEV`, senza contaminazioni.

## Layout workspace

```text
F:\DEV\EDEN_SX2A\          ← workspace dedicato SX2A
  repo\                    ← clone git (unico tree da pushare su origin)
  builds\                  ← artefatti build (FUORI git)
  cache\                   ← cache compilazione (FUORI git)
  toolchains\              ← glslang, env.ps1, zip SDK tools (FUORI git salvo script in repo)
  benchmarks\              ← misure (FUORI git se grezze/PII)
  tests\                   ← materiale test autorizzato (FUORI git se dump)
  logs\                    ← log diagnostici (FUORI git)
  releases\                ← APK verificati (FUORI git)
  references\              ← note tecniche locali
  reports\                 ← report consolidati (possono restare fuori repo o essere copiati in brain senza PII)
```

Non modificare/cancellare altri progetti in `F:\DEV\` non correlati.

## Isolamento Git

- Lavoro solo in `repo/` sul branch `sx2a/dev`.
- Upstream = fetch-only.
- Baseline branches non riscritte.
- Artifact di Gradle/CMake sotto `repo/src/android/app/build`, `repo/.cache`, `repo/.cxx` → non committare (già coperti da `.gitignore` / convenzioni).

## Isolamento device / dati utente

- Package diagnostico: `dev.eden.nx2.relWithDebInfo` (side-by-side rispetto a installazioni release).
- Non estrarre/salvare su git i contenuti di `/sdcard/Android/data/...` oltre a metriche anonimizzate.
- Bug report / readiness: redarre PII prima di qualsiasi condivisione pubblica.

## Isolamento toolchain

- SDK/NDK di sistema in `%LOCALAPPDATA%\Android\Sdk`.
- Helper PATH: `F:\DEV\EDEN_SX2A\toolchains\bin` (glslangValidator).
- WSL `ThorLinux` usabile per tool Unix senza mescolare file sensibili nel mount del repo se evitabile.

## Variabili d’ambiente

Usare env vars per path macchina (`ANDROID_HOME`, `JAVA_HOME`). Non hardcodare password. Debug `nx2_env.txt` solo su build non-release e mai con secret.
