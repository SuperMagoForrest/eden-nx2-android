# Risks

| ID | Rischio | Impatto | Prob. | Mitigazione |
|---|---|---|---|---|
| R1 | 20 GiB guest DRAM intent su host 8–12 GB | Kill/LMKD | Alta | M5 lazy/sparse/budgets |
| R2 | Build Android ore-long + CPM download fail | Ritardo M2 | Media | Log, cache gradle, retry |
| R3 | NDK CI≠locale | Regressioni silenti | Media | Allineare workflow |
| R4 | Merge PokeDinner conflict su hotspot | Break Android -Werror | Media | Merge disciplinato + build Android |
| R5 | Title-specific hacks accumulati | Debito | Media | Preferire fix sottosistema |
| R6 | Thermal soak danneggia device | Hardware | Bassa | Soglie + stop |
| R7 | Contesto LLM perso | Rework | Alta | Brain/checkpoint obbligatori |
| R8 | Mancanza dump legittimi | Blocco M4/M8 | Media | Chiedere titoli solo quando batteria pronta |
| R9 | Antivirus Windows blocca script | Build/clone hiccup | Media | Comandi semplici, path corti |
