# Next actions

1. **Commit/push** aggiornamenti brain post-APK (CHECKPOINT, PERFORMANCE_BASELINE, CURRENT_STATE).
2. Quando Thor collegato:  
   `powershell -File F:\DEV\EDEN_SX2A\repo\tools\nx2\android\thor_battery.ps1 -InstallApk -ApkPath F:\DEV\EDEN_SX2A\releases\eden-sx2a-baseline-59bb148-relWithDebInfo.apk`
3. Deep-dive M5: percorsi `MarkUsed`/`ClearBackingRegion` + sparse GPU 214 sotto pressione 8 GB.
4. Valutare profilo hardware adattivo (design ADR) senza cambiare GetInfo guest alla cieca.
5. CI: verificare che runner abbia NDK 28.2 dopo workflow update.
