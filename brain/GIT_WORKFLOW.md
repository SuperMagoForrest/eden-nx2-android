# Git workflow — Eden SX2A (fork SuperMagoForrest)

## Conferma operativa (`VERIFIED`)

| Regola | Stato |
|---|---|
| Pubblicare **solo** sul nostro fork | **Sì** — `origin` = `SuperMagoForrest/eden-nx2-android` |
| Branch di sviluppo autorizzato | **`sx2a/dev`** (topic branch ammessi se derivano da esso) |
| Push verso la repository originale | **Vietato** |
| Pull request verso upstream | **Vietate** salvo richiesta esplicita del proprietario |
| Alterare il branch originale di riferimento | **Vietato** |

## Remotes

| Remote | URL | Uso consentito |
|---|---|---|
| `origin` | `https://github.com/SuperMagoForrest/eden-nx2-android.git` | `fetch` + `push` su branch autorizzati |
| `upstream` | `https://github.com/JaviiDeveloper/eden-nx2-android.git` | **solo `fetch`** (lettura / sync analisi) |
| `pokedinner` (opzionale) | git.eden-emu.dev … | solo fetch/merge locale quando serve; no push |

Non aggiungere `push` URL verso upstream. Non usare `git push upstream`.

## Branch protetti (baseline)

| Ref | Ruolo |
|---|---|
| `nx2-android` @ `59bb148…` | Specchio del default upstream al momento del fork |
| `baseline/59bb148` | Baseline immutabile locale |
| tag `baseline-m0-59bb148` | Marker M0 |

Su questi ref: **nessun commit, nessun rebase, nessun force-push**.

## Branch di lavoro

1. Lavorare su `sx2a/dev` oppure `sx2a/<topic>` creato da `sx2a/dev`.
2. Commit atomici, messaggi chiari; disclosure AI se applicabile alle policy del fork.
3. `git push -u origin HEAD` **solo** verso `origin` e branch `sx2a/*`.
4. **No** `git push --force` su branch condivisi.
5. **No** `gh pr create` verso `JaviiDeveloper/eden-nx2-android`, Eden, PokeDinner, Eglantine, Takoroka, Eden-NS2.

## Sync da upstream (quando serve)

```text
git fetch upstream
git checkout sx2a/dev
git merge upstream/nx2-android   # preferire merge; non rebase della nostra history pubblica se evitabile
```

Mai: `git push upstream`, mai PR automatiche verso l’originale.

## Fork pubblico — cosa non finisce in git

Vedi `STORAGE_POLICY.md`. In sintesi: niente credenziali, dump di gioco, firmware/keys, log con PII, `local.properties`, APK di build, path macchina non necessari.
