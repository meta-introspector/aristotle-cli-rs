import RequestProject.Gvcs.SalvageGuide

/-!
# The teardown-manual writer

`lake exe salvage [file]` writes the salvage guide, generated from the
teardown tables of `RequestProject/Salvage.lean`, to `file`.  The default is
`docs/salvage-guide.md`.
-/

def main (args : List String) : IO Unit := do
  let path := args.headD "docs/salvage-guide.md"
  IO.FS.writeFile path LifeTrac.Salvage.guideText
  IO.println s!"wrote {path}"
