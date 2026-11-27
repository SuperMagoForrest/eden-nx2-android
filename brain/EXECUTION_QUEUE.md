# Execution queue — SX2A M2–M11

Aggiornato: 2026-11-27 sessione implementativa.

| ID | Pri | Stato | Task |
|---|---|---|---|
| EQ-001 | P0 | VERIFIED | Repo/ADB/APK SHA match baseline; Thor Pro online |
| EQ-002 | P0 | VERIFIED | Storage isolation build script → F:\DEV\EDEN_SX2A\cache |
| EQ-003 | P0 | VERIFIED | `thor_diagnostics.ps1` + snapshot idle |
| EQ-004 | P0 | VERIFIED | Frame pacing Android 30 default + NX2 PaceToVblank cap |
| EQ-005 | P0 | VERIFIED | `ReleaseBackingRegion` + `release_host_backing` on Close |
| EQ-006 | P0 | RUNNING | Build candidate RelWithDebInfo |
| EQ-007 | P0 | READY | Install candidate (diag package path) + measure vs baseline |
| EQ-008 | P1 | READY | Thermal policy engine (status → worker/resolution hints) |
| EQ-009 | P1 | READY | Hardware profiles Thor Base/Pro (budget, workers) |
| EQ-010 | P1 | READY | Shader async / pipeline cache stutter (dopo explore) |
| EQ-011 | P1 | NEEDS_OWNER | Gameplay strumentato Pokopia (no overwrite save) |
| EQ-012 | P2 | READY | Compatibility matrix updates + upstream scan |
| EQ-013 | P3 | READY | Release Alpha 0.1 packaging when gates pass |

Stati: READY | RUNNING | VERIFIED | BLOCKED | DEFERRED | NEEDS_DEVICE | NEEDS_OWNER | REGRESSION
