import RequestProject.Gvcs.Sneakernet.Export

/-!
# The sneakernet game extractor

`lake exe sneaker [dir]` writes the multiplayer game out of the Lean
development:

* `index.html` — the playable page: two players seal moves under the referee's
  key, a courier carries them hop by hop along bang paths, a relay checks the
  rule book on the ciphertexts and the referee decrypts one verdict bit;
* `mail/ada.batch`, `mail/bob.batch` — the two demo letters as UUCP batches:
  what actually travels on the tape;
* `params.json` — the key, the opening board and the rule book as a circuit;
* `letters.json` — the demo letters with the verdict ciphertexts Lean computes;
* `README.md` — what the files are and which theorem says so.

The rule book the page runs is the circuit of `Patch.game`, the one
`Patch.circuit_spec` checks against the rules and `SealedGame.verdict_correct`
proves can be evaluated under encryption.

The default directory is `sneaker`.
-/

open LifeTrac Sneakernet Sneakernet.Export Sneakernet.Session

/-- Write the game out. -/
def main (args : List String) : IO Unit := do
  let dir := args.headD "sneaker"
  IO.FS.createDirAll dir
  IO.FS.createDirAll (dir ++ "/mail")
  IO.FS.writeFile (dir ++ "/index.html") page
  IO.println s!"wrote {dir}/index.html"
  IO.FS.writeFile (dir ++ "/params.json") (paramsJson ++ "\n")
  IO.println s!"wrote {dir}/params.json"
  IO.FS.writeFile (dir ++ "/letters.json") (lettersJson ++ "\n")
  IO.println s!"wrote {dir}/letters.json"
  IO.FS.writeFile (dir ++ "/mail/ada.batch")
    (batchOf "ada0001" "ada" ["decvax", "ihnp4", "farm"] (ctMove adaMove))
  IO.println s!"wrote {dir}/mail/ada.batch"
  IO.FS.writeFile (dir ++ "/mail/bob.batch")
    (batchOf "bob0001" "bob" ["ihnp4", "farm"] (ctMove bobMove))
  IO.println s!"wrote {dir}/mail/bob.batch"
  IO.FS.writeFile (dir ++ "/README.md") readme
  IO.println s!"wrote {dir}/README.md"
