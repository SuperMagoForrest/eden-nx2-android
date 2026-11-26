# Emulation flow (end-to-end)

Stato: ricostruzione basata su codice + `NX2_NOTES.md` / `NX2_ANDROID.md`. Evidenza: `PARTIALLY_VERIFIED` (codice letto; runtime Thor non ancora eseguito in questa sessione).

## 1. Avvio Android

1. Utente apre Eden SX2A (`dev.eden.nx2[.suffix]`).
2. Al primo avvio su Adreno senza driver scelto → seleziona Turnip Mr Purple T30.
3. Readiness check opzionale (`Switch2ReadinessFragment`).
4. Game folder / Launch ExeFS / NUP → path a `exefs/main`.

## 2. Load

1. JNI passa path a `Core::System::Load`.
2. `IsSwitch2Program` → forza `Memory_12Gb`, set CNTFRQ Switch 2.
3. `InitializeKernel` deriva memory layout da SMC size/arrangement.
4. Loader loose ExeFS: NPDM ACID 0x300, RomFS sibling, fs registration.

## 3. Boot guest

1. Process 64-bit, AS 39-bit, cores 0..5.
2. SVC path: GetInfo (regioni, granule, remote memory stubs), SetHeapSize oltre 8 GiB.
3. AM/OE proxy Switch 2 (cmds alias/stub dove necessario).
4. `nx2:gsv` session → syncpt / gpu / vi2 / audio user client.

## 4. GPU bring-up

1. NvRm characteristics chip Ampere `0x17E`.
2. Address space AllocAsEx; device space ampio (64 GiB era).
3. Channel/TSG setup; macro MME64 caricate.
4. Identity-map GPU memory registry; sparse 214/215/216.

## 5. Frame loop

1. Command buffers con SEMAPHORED acquire → channel suspend/resume.
2. Macros 3D/compute + QMD 3.0.
3. Shader lower Ampere→Maxwell; cache negativa per fail.
4. Draw → texture/buffer cache → Vulkan.
5. vi2 229 composite + crop + pace → surface Android.

## 6. Teardown

- Swipe recents: process kill.
- Tra titoli: riavvio app raccomandato upstream.
- RestoreGlobalState ripristina memory layout globale.
