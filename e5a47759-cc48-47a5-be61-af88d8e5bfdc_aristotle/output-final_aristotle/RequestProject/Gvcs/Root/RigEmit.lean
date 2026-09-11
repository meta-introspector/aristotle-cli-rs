import RequestProject.Gvcs.Rig.Page

/-!
# The Rig Rally extractor

`lake exe rigs [dir]` writes the game out of the Lean development:

* `rigs.html` — the whole game as a single self-contained page: the workshop,
  the course, the touch and keyboard controls, the tables generated from the
  Lean definitions, and the WebAssembly module of `RequestProject/Rig/Wasm.lean`
  masked and carried as base64 inside the page itself;
* `rigs.wasm` — the same module as a loose file, so that a test can compare it
  byte for byte with what the page carries;
* `rigs-vectors.json` — what Lean says about the game: the stock machines,
  their share codes and their figures, and a scripted run of the course tick by
  tick, for `rigs-test.mjs` to check the page's module and JavaScript against.

The default directory is `web`.
-/

open LifeTrac LifeTrac.Rig LifeTrac.Wasm

/-- A stretch of a run: how many ticks, and what is held down. -/
structure Seg where
  /-- How many ticks the stretch lasts. -/
  n : Nat
  /-- The throttle axis. -/
  th : Int
  /-- The steering axis. -/
  st : Int
  /-- Is the scoop down? -/
  sc : Bool
  /-- Is the brake on? -/
  br : Bool

/-- The scripted run the test replays: away from the line, into the pickup
zone with the scoop down, then hard round to the line and over it. -/
def script : List Seg :=
  [⟨40, 1000, 0, false, false⟩,
   ⟨30, 1000, 600, false, false⟩,
   ⟨40, 400, -600, false, false⟩,
   ⟨60, 300, 0, true, false⟩,
   ⟨20, 0, 0, true, true⟩,
   ⟨120, 1000, 0, false, false⟩,
   ⟨50, 1000, -400, true, false⟩,
   ⟨60, 1000, 0, false, false⟩]

/-- The script as one input per tick. -/
def inputs : List Input :=
  script.flatMap (fun s => List.replicate s.n ⟨s.th, s.st, s.sc, s.br⟩)

/-- A drive state as a JSON array, in the order the module's `get` numbers
them. -/
def driveJson (s : Drive) : String :=
  "[" ++ String.intercalate "," ([s.pos, s.lane, s.vel, s.fuel, s.load, s.score, s.ticks].map toString) ++ "]"

/-- Every state of the run, from the start. -/
def states (m : Machine) : List Input → Drive → List Drive
  | [], s => [s]
  | u :: us, s => s :: states m us (tick m u s)

/-- One stock machine, as JSON. -/
def stockJson (name : String) (d : Design) : String :=
  "{\"name\":" ++ jsStr name ++
  ",\"cells\":" ++ jsNats (cellsOf d) ++
  ",\"code\":" ++ jsStr (encodeDesign d) ++
  ",\"stats\":" ++ jsInts ((List.range 9).map (statAt d)) ++
  ",\"valid\":" ++ (if decide (Valid d) then "true" else "false") ++ "}"

/-- The whole vector file. -/
def vectorsJson : String :=
  let m := rigOf hauler
  let sts := states m inputs (startDrive m)
  "{\n \"grid\": {\"w\":" ++ toString gridW ++ ",\"h\":" ++ toString gridH ++
    ",\"d\":" ++ toString gridD ++ ",\"n\":" ++ toString gridN ++ "},\n" ++
  " \"budget\": " ++ toString budget ++ ",\n" ++
  " \"tables\": [" ++ String.intercalate ","
    ((List.range 9).map (fun j => jsInts ((List.range 7).map (tables.getD j massTbl)))) ++ "],\n" ++
  " \"stock\": [\n  " ++ String.intercalate ",\n  "
    (stockDesigns.map (fun p => stockJson p.1 p.2)) ++ "\n ],\n" ++
  " \"script\": [" ++ String.intercalate ","
    (script.map (fun s => "[" ++ toString s.n ++ "," ++ toString s.th ++ "," ++ toString s.st ++
      "," ++ (if s.sc then "1" else "0") ++ "," ++ (if s.br then "1" else "0") ++ "]")) ++ "],\n" ++
  " \"trace\": [\n  " ++ String.intercalate ",\n  " (sts.map driveJson) ++ "\n ],\n" ++
  " \"final\": " ++ driveJson (run m inputs (startDrive m)) ++ ",\n" ++
  " \"key\": " ++ toString rigKey ++ ",\n" ++
  " \"bytes\": " ++ toString (encodeMod rigMod).length ++ "\n}\n"

/-- Write the page, the module and the vectors. -/
def main (args : List String) : IO Unit := do
  let dir := args[0]? |>.getD "web"
  IO.FS.createDirAll dir
  IO.FS.writeFile (dir ++ "/rigs.html") rigPage
  IO.FS.writeBinFile (dir ++ "/rigs.wasm") (encodeModBytes rigMod)
  IO.FS.writeFile (dir ++ "/rigs-vectors.json") vectorsJson
  IO.println s!"wrote {dir}/rigs.html ({rigPage.length} characters), \
{dir}/rigs.wasm ({(encodeMod rigMod).length} bytes) and {dir}/rigs-vectors.json"
