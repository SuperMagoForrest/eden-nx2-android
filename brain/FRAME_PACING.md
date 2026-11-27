# Frame pacing — SX2A

## Problema

Su Android API ≥ 30 il path Vulkan ignorava `frame_pacing_mode` e chiamava sempre `scheduler.Wait(..., 0.0)` → nessun cap FPS host. Su Thor Pro (SDK 33) il setting era quindi inerte.

Il `SpeedLimiter` classic (sleep su wall clock) è disabilitato con `use_multi_core`.

Per NX2, `PaceToVblank` in `nx2_gsv.h` è il pacing reale sui present guest.

## Fix SX2A (implementato)

1. `vk_swapchain.cpp`: applica `Settings::FramePacingTargetFps()` su tutte le piattaforme.
2. `vk_scheduler.h`: il wait di pacing non dipende più da `use_speed_limit`.
3. `PaceToVblank`: con cap FPS (default Android = 30) usa `max(guest_interval, cap_interval)`.
4. Default Android: `FramePacingMode::Target_30`.
5. UI Android: scelta Auto/30/40/60/90/120 + descrizione.
6. Enum: `Target_40` aggiunto in coda (ordinali salvati preservati).

## Semantiche

| Mode | Present cap | Emulation speed |
|---|---|---|
| Auto | Nessun cap host | 100% se speed limit off / come impostato |
| 30/40/60/… | Cap present | Resta 100% (non dimezza lo speed_limit %) |

Per titoli vsync-locked a 60 Hz, un cap a 30 riduce i present (e tipicamente il lavoro GPU) mantenendo timing relativo coerente a 30 FPS. Non è un “half-speed” del `speed_limit`.

## Validazione richiesta

Confrontare baseline vs candidate su stessa scena Pokopia: FPS presentati, PSS, temp batteria, audio sync, input.
