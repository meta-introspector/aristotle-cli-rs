/-
# `emitwasm` — extract the deployment kernel to a `.wasm` binary

    lake exe emitwasm [outdir]

writes

* `<outdir>/cf_deploy_kernel.wasm` — the WebAssembly binary produced by
  the verified encoder of `RequestProject.Wasm.Encode`, and
* `<outdir>/kernel-vectors.json` — golden vectors obtained by running the
  Lean *semantics* of the same module on a fixed set of arguments.

`web/wasm-test.mjs` instantiates the binary in a real WebAssembly engine
and checks it against those vectors, so the chain Lean definition →
verified compiler → binary → engine is validated end to end.
-/
import RequestProject.Edge.Cf.WasmKernel

open Kant.Wasm
open CfDeploy.WasmKernel

/-- Arguments each exported function is exercised with. -/
def testArgs : List (String × List (List Nat)) :=
  [ ("fnv_offset", [[]]),
    ("fnv1a_step", [[14695981039346656037, 0], [14695981039346656037, 104], [0, 255]]),
    ("hex_hi", [[0], [15], [171], [255]]),
    ("hex_lo", [[0], [15], [171], [255]]),
    ("kv_chunks", [[0], [1], [25 * 1024 * 1024], [25 * 1024 * 1024 + 1]]),
    ("fits_kv", [[0], [25 * 1024 * 1024], [25 * 1024 * 1024 + 1]]),
    ("upload_batches", [[0], [1], [1000], [1001], [2500]]),
    ("token_expired", [[100, 0, 50], [100, 60, 60], [100, 90, 20]]),
    ("ttl_seconds", [[0], [15], [60]]) ]

/-- Value of an exported function under the Lean semantics of the emitted
module (`none` if it would trap). -/
def runKernel (fname : String) (args : List Nat) : Option UInt64 :=
  match deployKernel.funcs.find? (fun f => f.name == fname) with
  | none => none
  | some f => Expr.eval (args.map UInt64.ofNat) f.body

/-- The golden vectors as JSON. -/
def vectorsJson : String :=
  let entries := testArgs.flatMap fun (fname, argss) =>
    argss.map fun args =>
      let val := (runKernel fname args).getD 0
      "    {\"f\": \"" ++ fname ++ "\", \"args\": [" ++
        String.intercalate ", " (args.map fun a => "\"" ++ toString a ++ "\"") ++
        "], \"expected\": \"" ++ toString val.toNat ++ "\"}"
  "{\n  \"vectors\": [\n" ++ String.intercalate ",\n" entries ++ "\n  ]\n}\n"

def main (args : List String) : IO UInt32 := do
  let dir : System.FilePath := args.headD "dist"
  IO.FS.createDirAll dir
  let wasmPath := dir / "cf_deploy_kernel.wasm"
  let jsonPath := dir / "kernel-vectors.json"
  IO.FS.writeBinFile wasmPath kernelBytes
  IO.FS.writeFile jsonPath vectorsJson
  IO.println s!"wrote {wasmPath} ({kernelBytes.size} bytes)"
  IO.println s!"wrote {jsonPath} ({deployKernel.funcs.length} exported functions)"
  return 0
