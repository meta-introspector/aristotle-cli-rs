import RequestProject.MCP.Codegen

/-!
# Code-generation entry point

A thin `IO` driver that emits the verified native templates to disk. The pure,
proven-faithful strings come from `RequestProject/MCP/Codegen.lean`; this file
only serialises them.

Usage (from the project root):

```
lake exe aristotle-codegen            # writes into ./generated
lake exe aristotle-codegen out/dir    # writes into out/dir
```

Each run produces `aristotle_client.{rs,hpp,py,js}`, all derived from the single
verified `AristotleClient` model.
-/

open AristotleClient.Codegen

/-- Entry point: write all default targets into the directory given as the first
CLI argument (default `generated`). -/
def main (args : List String) : IO Unit := do
  let dir := args.headD "generated"
  IO.FS.createDirAll dir
  writeAll dir
  IO.println s!"Generated {defaultConfigs.length} native modules in {dir}/"
