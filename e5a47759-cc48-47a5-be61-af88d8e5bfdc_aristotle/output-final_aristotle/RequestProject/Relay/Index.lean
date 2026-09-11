import RequestProject.Relay.Manifest

/-!
# `lake exe relay-index`

Writes the machine-readable index of this repository:

```
lake exe relay-index          # writes www/manifest.json and www/kernel-vectors.json
lake exe relay-index somedir  # writes them somewhere else
```

Both files are generated from the Lean sources every time, and every page under
`www/` reads them rather than keeping its own copy.  `tools/build_index.py`
runs this and then merges in the *measured* facts — timings, toolchain
presence, cargo capacity — which are not theorems and are tagged as such.
-/

namespace RequestProject.Relay.Manifest

/-- Write the index into `dir`. -/
def writeIndex (dir : String) : IO Unit := do
  IO.FS.createDirAll dir
  IO.FS.writeFile (dir ++ "/manifest.json") manifestJson
  IO.FS.writeFile (dir ++ "/kernel-vectors.json") RequestProject.Kernel.vectorsJson
  IO.FS.writeBinFile (dir ++ "/kernel-commitment.wasm") RequestProject.Kernel.Wasm.kernelBytes
  IO.println s!"wrote {entries.length} theorems, {stages.size} stages and \
{RequestProject.Kernel.vectors.length} engine vectors to {dir}/manifest.json"
  IO.println s!"wrote {RequestProject.Kernel.vectors.length} conformance vectors to \
{dir}/kernel-vectors.json"
  IO.println s!"wrote the WebAssembly commitment kernel \
({RequestProject.Kernel.Wasm.kernelBytes.size} bytes) to {dir}/kernel-commitment.wasm"

end RequestProject.Relay.Manifest

/-- `lake exe relay-index [dir]` -/
def main (args : List String) : IO Unit :=
  RequestProject.Relay.Manifest.writeIndex (args.headD "www")
