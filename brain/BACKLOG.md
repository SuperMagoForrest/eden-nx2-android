# Backlog (priorità)

## P0 — subito dopo M1/M2

1. Completare e validare build baseline RelWithDebInfo APK (`assembleMainlineRelWithDebInfo`).
2. Allineare script Windows/ADB (`tools/nx2/android/env.sh` paths) senza rompere macOS.
3. Instrumentare raccolta meminfo/logcat/readiness su Thor Pro (batteria consolidata).
4. Analisi strutturale backing DRAM 12GB+8GB: dove avviene commit host reale vs reserve.

## P1

5. Profilo hardware adattivo (Thor Base / Pro / generic) — design + flag settings.
6. Shader cache warm / reduce first-boot black screen.
7. Investigare texture nere Mario Kart (format/view/swizzle).
8. Revisione occlusion-query / Adreno crash paths già bypassati — regressione test.
9. Fix CI NDK 27 vs 28.2.
10. Lifecycle: cleanup tra titoli per evitare kill/reopen obbligatorio.

## P2

11. Video decode path performance.
12. Task/mesh shader strategy (VK_EXT_mesh_shader vs compute emulation).
13. Thermal-aware frame cap opzionale.
14. Sync PokeDinner (merge only) dopo stabilizzazione locale.

## P3

15. Docs UX semplificata per Thor.
16. Automazione soak test templates.

Ogni item deve produrre: patch atomica, test/evidenza, update `KNOWN_ISSUES` + `CHECKPOINT`.
