/-
Emit `rig.html`: the whole game — the rules as an embedded WebAssembly module, the
tracks, the block palette, the sample rigs and their share codes — in one page.

Run from the project root with

    lake env lean --run scripts/emit_rig.lean

Everything the page is told is computed here by the Lean development:
`RequestProject/RigKernel.lean` assembles the WebAssembly module and this script
base-64s it; the block constants, the track profiles, the share codes of the sample
rigs and the test vectors the headless check uses all come from
`RequestProject/RigDesign.lean` and `RequestProject/RigSim.lean`.
-/
import RequestProject.RigKernel

open Rig RigKernel RigWasm

/-! ## JSON helpers -/

private def jsonEsc (s : String) : String :=
  String.join (s.toList.map fun c =>
    match c with
    | '"'  => "\\\""
    | '\\' => "\\\\"
    | '\n' => "\\n"
    | '\r' => "\\r"
    | '\t' => "\\t"
    | c    => if c.toNat < 32 then "" else String.singleton c)

private def jstr (s : String) : String := "\"" ++ jsonEsc s ++ "\""
private def jarr (xs : List String) : String := "[" ++ String.intercalate "," xs ++ "]"
private def jnums (xs : List Nat) : String := jarr (xs.map toString)
private def jobj (kvs : List (String × String)) : String :=
  "{" ++ String.intercalate "," (kvs.map (fun kv => jstr kv.1 ++ ":" ++ kv.2)) ++ "}"

/-! ## The sample rigs -/

/-- A little runabout: two wheels, an engine and a crate. -/
def rigRunabout : Design :=
  [⟨2,1,.wheel⟩, ⟨3,1,.wheel⟩, ⟨2,2,.frame⟩, ⟨3,2,.engine⟩, ⟨4,2,.cargo⟩,
   ⟨2,3,.balloon⟩, ⟨3,3,.balloon⟩]

/-- The hopper: light, four balloons, clears the walls. -/
def rigHopper : Design :=
  [⟨2,1,.wheel⟩, ⟨3,1,.wheel⟩, ⟨1,2,.frame⟩, ⟨2,2,.frame⟩, ⟨3,2,.engine⟩,
   ⟨1,3,.balloon⟩, ⟨2,3,.balloon⟩, ⟨3,3,.balloon⟩, ⟨4,3,.balloon⟩]

/-- The freighter: heavy, three crates, needs a long flat run. -/
def rigFreighter : Design :=
  [⟨2,1,.wheel⟩, ⟨3,1,.wheel⟩, ⟨4,1,.wheel⟩, ⟨2,2,.frame⟩, ⟨3,2,.engine⟩,
   ⟨4,2,.frame⟩, ⟨2,3,.cargo⟩, ⟨3,3,.cargo⟩, ⟨4,3,.cargo⟩,
   ⟨2,4,.balloon⟩, ⟨3,4,.balloon⟩, ⟨4,4,.balloon⟩]

/-- The anchor: a rig that will not move an inch, to show what mass costs. -/
def rigAnchor : Design :=
  [⟨2,1,.wheel⟩, ⟨3,1,.ballast⟩, ⟨2,2,.frame⟩, ⟨3,2,.engine⟩, ⟨4,1,.ballast⟩]

/-- The page always writes a rig's blocks out in cell order; sorting a design that
way changes neither the rig nor its legality, only the order the code lists it in. -/
def canon (d : Design) : Design := d.mergeSort (fun a b => a.pos ≤ b.pos)

def samples : List (String × Design) :=
  [("runabout", canon rigRunabout), ("hopper", canon rigHopper),
   ("freighter", canon rigFreighter), ("anchor", canon rigAnchor)]

/-! ## Test vectors for the headless check -/

/-- A joystick programme that visits every combination of the three bits. -/
def testInputs (n : Nat) : List Nat := (List.range n).map (fun i => (i * 7 + 3) % 8)

/-- Everything the check needs for one rig on one track. -/
def vectorJson (rigName : String) (d : Design) (ti : Nat) (t : Track) : String :=
  let p := Params.of d
  let inputs := testInputs 150
  let s := run t p inputs (Sim.start t p)
  jobj [ ("rig", jstr rigName), ("track", toString ti), ("inputs", jnums inputs)
       , ("params", jnums [p.mass, p.thrust, p.lift, p.fuel, p.payload])
       , ("state", jnums [s.x, s.y, s.vx, s.vy, s.fuel, s.dist, s.tick, s.crashed])
       , ("score", toString (score t p s)) ]

/-- The grid bytes of a design, as the kernel wants them. -/
def gridBytes (d : Design) : List Nat :=
  (List.range 256).map (fun c =>
    match d.find? (fun b => b.pos == c) with
    | some b => b.kind.code
    | none => 0)

/-! ## The data block -/

def kindJson (k : Kind) : String :=
  jobj [ ("code", toString k.code), ("name", jstr k.name), ("hex", jstr k.hex)
       , ("mass", toString k.mass), ("thrust", toString k.thrust), ("lift", toString k.lift)
       , ("fuel", toString k.fuelUnits), ("payload", toString k.payload)
       , ("price", toString k.price) ]

def trackJson (t : Track) : String :=
  jobj [ ("name", jstr t.name), ("heights", jnums t.heights), ("finish", toString t.finish) ]

def dataJson : String :=
  jobj
    [ ("wasm", jstr kernelBase64)
    , ("bytes", toString kernelModule.length)
    , ("alphabet", jstr alphabet)
    , ("codeNote", jstr
        ("A code is one letter for the number of blocks, then two letters for each block " ++
         "— the cell it sits in and what kind it is — and one letter of checksum. " ++
         "The same code always spells out the same rig, and a rig that is not one " ++
         "connected piece has no code at all."))
    , ("consts", jobj
        [ ("gridW", toString gridW), ("maxBlocks", toString maxBlocks)
        , ("unit", toString unit), ("vBias", toString vBias), ("vCap", toString vCap)
        , ("maxX", toString maxX), ("maxY", toString maxY), ("gravity", toString gravity)
        , ("smashSpeed", toString smashSpeed), ("crashPenalty", toString crashPenalty)
        , ("tickMs", "50"), ("maxTicks", "900") ])
    , ("addr", jobj
        [ ("grid", toString gridAddr), ("track", toString trackAddr)
        , ("sX", toString sX), ("sY", toString sY), ("sVX", toString sVX), ("sVY", toString sVY)
        , ("sFuel", toString sFuel), ("sDist", toString sDist), ("sTick", toString sTick)
        , ("sCrash", toString sCrash), ("pMass", toString pMass), ("pThrust", toString pThrust)
        , ("pLift", toString pLift), ("pFuel", toString pFuel), ("pPayload", toString pPayload)
        , ("pFinish", toString pFinish) ])
    , ("kinds", jarr (Kind.all.map kindJson))
    , ("tracks", jarr (tracks.map trackJson))
    , ("samples", jarr (samples.map (fun s =>
        jobj [ ("name", jstr s.1), ("code", jstr (encode s.2))
             , ("grid", jnums (gridBytes s.2)) ])))
    , ("tests", jarr (samples.flatMap (fun s =>
        (tracks.zipIdx).map (fun ti => vectorJson s.1 s.2 ti.2 ti.1))))
    ]

/-! ## Write the page -/

def main : IO Unit := do
  let template ← IO.FS.readFile "scripts/rig_template.html"
  let out := template.replace "/*RIGDATA*/" dataJson
  IO.FS.writeFile "rig.html" out
  IO.println s!"rig.html written: {out.length} characters"
  IO.println s!"  kernel: {kernelModule.length} bytes of WebAssembly, {kernelBase64.length} of base 64"
  for (n, d) in samples do
    IO.println s!"  {n}: {d.length} blocks, code {encode d}, legal {Design.wfCheck d}"
