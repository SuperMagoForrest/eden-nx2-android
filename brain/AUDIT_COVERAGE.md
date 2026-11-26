# Audit coverage

Legenda: **Deep** | **Interface** | **Tested** | **Todo** | **N/A**

| Area | Copertura | Note |
|---|---|---|
| Workspace/git/remotes/baseline | Deep | M0 |
| README / NX2_ANDROID / NX2_NOTES | Deep | Genealogia + 90+ blocker history |
| Android Gradle / flavors / package id | Deep | |
| Memory layout 10/12GB + 8GiB graphics | Deep | k_system_control.* |
| hardware_properties 6 cores | Deep | |
| Switch2 Load auto-layout / CNTFRQ | Deep | core.cpp |
| Android readiness / BugReport / drivers | Interface | file path verified |
| GameHelper loose ExeFS | Interface | |
| NCE tree file list | Interface | visitor stubs claim from docs |
| Dynarmic internals NS2 | Todo | |
| nx2_gsv.h full protocol | Todo | large header |
| Shader Ampere lowering completeness | Todo | |
| Vulkan Adreno paths | Todo | |
| Macro JIT oaknut | Todo | |
| Audio nx2 path | Todo | |
| Host1x / VIC / AV1 | Todo | |
| Unit tests `src/tests` | Todo | BUILD_TESTING off su Android |
| Runtime Thor Pro | Todo | device non ancora in sessione build |
| Thor Base fisico | Todo | |
| Performance counters | Todo | |
| Externals version audit | Interface | agent in corso |
| CI workflows | Interface | NDK drift noted |

Aggiornare dopo ogni deep-dive; non dichiarare audit “completo” finché le aree Todo critiche restano aperte.
