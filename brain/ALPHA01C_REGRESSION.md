# Alpha 0.1c regression brief

- **Sintomo owner:** Pokopia non completa il loading; ritorno alla libreria.  
- **Meccanismo:** processo ucciso da LMKD (`LOW_MEMORY`), poi Android riporta MainActivity.  
- **Non è:** fatal native signal del package nx2 nella finestra diagnostica.  
- **Fix path:** reclaim corretto + pacing singolo + GC meno aggressivo + reclaim efficace solo su Free.  
- **APK regressivo:** `eden-sx2a-thor-opt-alpha01c-relWithDebInfo.apk` SHA `915F6764…542D10`
