# Frame pacing validation

## Autorità

| Percorso | Ruolo Alpha 0.2 |
|---|---|
| `nx2_gsv.h` `PaceToVblank` | Solo guest swap-interval (con `use_speed_limit`) |
| `vk_swapchain.cpp` `AcquireNextImage` | Cap host FPS da `FramePacingTargetFps()` |

Niente doppio cap. Default Android: Target_30.

## Enum ordinali

`Target_Auto=0, Target_30=1, Target_60=2, Target_90=3, Target_120=4, Target_40=5`  
Max setting = Target_40 (ordinale più alto) per non clampare 60/90/120.

## Da verificare su device

- Auto / 30 / 40 / 60 selezionabili e persistenti  
- Guest speed ~100% a 30 FPS present  
- Loading non bloccato da attese accumulate
