# Device lab — Thor Pro

## Dispositivo autorizzato

- Serial: `905d41b5`
- Model: AYN Thor (kalama)
- Package test: `dev.eden.nx2.relWithDebInfo`

## Watchdog

Script: `tools/nx2/android/thor_diagnostics.ps1`

- Abort battery temp default 70 °C (proxy, non SoC)
- Abort SoC temp default 70 °C (thermal zones se leggibili)
- Thermal Status ≥ 3 → abort
- Stop verificato (HOME/BACK poi force-stop package solo se necessario)
- Classificazione crash da ApplicationExitInfo
- Parser PSS/RSS/SWAP sulla riga TOTAL App Summary

## Sicurezza dati

- Mai `pm clear` sui dati owner
- Non pubblicare log con path personali/salvataggi
