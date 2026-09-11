/-
ArrowFinder.lean — log the actual cell-to-cell "arrows" of a Lean environment.

This is the executable companion to `RequestProject/CFTMorphisms.lean`.  Where that file
proves the *fusion / arrow* structure on the crystal table (the Altland–Zirnbauer cells of
`RequestProject/PeriodicTable.lean`), this tool finds the **real arrows** present in a Lean
4 corelib + Mathlib environment.

Each declaration has a crystal cell = the AZ real class at residue `size mod 8`, where
`size` is the leaf count of its type (`exprSize`, identical to `PeriodicTableFinder` /
`SizeSignature.size`).  A **dependency edge** `d → n` (declaration `n` references constant
`d` in its type or value — e.g. a *lemma referencing a def*) is read as an **arrow** from
cell `crystalCell (size d)` to cell `crystalCell (size n)`.  The tool aggregates all such
edges into the 8×8 cell-to-cell transition matrix of the code-CFT, records how the Bott-
clock residue shifts along each edge (`Δ = (r_to − r_from) mod 8`), and keeps a few
concrete example edges per transition.

The residue-shift histogram is the empirical analogue of the verified arrow generators:
`Δ = 1` is the elementary `arrow` (`CFTMorphisms.arrow`, e.g. `AI → BDI`), `Δ = 0` an
intra-cell edge, etc.

Outputs (to the configured output dir, default `./periodic-out`):
  * `arrows.json` — the 8×8 cell transition matrix, the residue-shift (`Δ`) histogram,
                    totals, and example edges per transition.
  * `arrows.txt`  — a human-readable rendering of the same data.

Usage:
  lake exe arrowfinder <Module> <outputDir>
  lake exe arrowfinder                       -- reads arrow-config.json, else defaults
-/
import Lean

open Lean System

/-- The size signature of an expression: number of leaf sub-terms of the type viewed as a
tree.  Identical to `PeriodicTableFinder.exprSize` and the `Expr` realisation of
`SizeSignature.size`. -/
partial def exprSize : Expr → Nat
  | .bvar _      => 1
  | .fvar _      => 1
  | .mvar _      => 1
  | .sort _      => 1
  | .const _ _   => 1
  | .lit _       => 1
  | .app f a     => exprSize f + exprSize a
  | .lam _ t b _ => exprSize t + exprSize b
  | .forallE _ t b _ => exprSize t + exprSize b
  | .letE _ t v b _  => exprSize t + exprSize v + exprSize b
  | .mdata _ e   => exprSize e
  | .proj _ _ e  => exprSize e

/-- Cartan labels of the eight real Altland–Zirnbauer classes, in Bott-clock order. -/
def realCartanLabels : Array String :=
  #["AI", "BDI", "D", "DIII", "AII", "CII", "C", "CI"]

/-- The crystal cell index (residue `N mod 8`) of a size signature `N`. -/
def cellIndex (N : Nat) : Nat := N % 8

/-- The crystal cell (real Cartan label) of a size signature `N`. -/
def realCartan (N : Nat) : String := realCartanLabels[N % 8]!

/-- Parse the shared config format (`modules`/`module` + `outputDir`). -/
def parseConfig (s : String) : List String × String :=
  match Json.parse s with
  | .error _ => ([], "./periodic-out")
  | .ok j =>
    let out := (j.getObjValAs? String "outputDir").toOption.getD "./periodic-out"
    let modsArr : List String :=
      match j.getObjVal? "modules" with
      | .ok arrJ =>
        match arrJ.getArr? with
        | .ok arr => arr.toList.filterMap (fun x => (x.getStr?).toOption)
        | .error _ => []
      | .error _ => []
    let mods :=
      if modsArr.isEmpty then
        match (j.getObjValAs? String "module").toOption with
        | some m => [m]
        | none => []
      else modsArr
    (mods, out)

/-- Read configuration from CLI args, or `arrow-config.json`, else defaults. -/
def readArrowConfig (args : List String) : IO (List String × String) := do
  let dflt : List String := ["Mathlib"]
  match args with
  | [] =>
    let configPath := System.FilePath.mk "arrow-config.json"
    if ← configPath.pathExists then
      let content ← IO.FS.readFile configPath
      let (mods, out) := parseConfig content
      return (if mods.isEmpty then dflt else mods, out)
    else
      return (dflt, "./periodic-out")
  | [m] => return ([m], "./periodic-out")
  | m :: out :: _ => return ([m], out)

/-- Escape a string for embedding in JSON. -/
def jsonEsc (s : String) : String :=
  s.replace "\\" "\\\\" |>.replace "\"" "\\\""

/-- Pad a string on the right to width `w`. -/
def padR (s : String) (w : Nat) : String :=
  if s.length >= w then s else s ++ String.ofList (List.replicate (w - s.length) ' ')

/-- The constants referenced in a `ConstantInfo` (its type and, if present, its value). -/
def constDepNames (ci : ConstantInfo) : Array Name := Id.run do
  let mut seen : Std.HashSet Name := {}
  let mut out : Array Name := #[]
  for d in ci.type.getUsedConstants do
    if !seen.contains d then seen := seen.insert d; out := out.push d
  match ci.value? with
  | some v =>
    for d in v.getUsedConstants do
      if !seen.contains d then seen := seen.insert d; out := out.push d
  | none => pure ()
  return out

/-- Main: scan dependency edges and log cell-to-cell arrows. -/
def main (args : List String) : IO UInt32 := do
  let (rootMods, outDirStr) ← readArrowConfig args
  let outPath : System.FilePath := System.FilePath.mk outDirStr
  IO.println s!"ArrowFinder: roots={rootMods} out={outDirStr}"
  initSearchPath (← findSysroot)
  let imports := (rootMods.map (fun m => ({module := m.toName} : Import))).toArray
  let env ← importModules imports {}
  -- pass 1: size signature (hence cell index) of every non-internal declaration
  let mut sizeOf : Std.HashMap Name Nat := {}
  for (n, ci) in env.constants.map₁.toList do
    if n.isInternal || n.toString.startsWith "_" then
      continue
    sizeOf := sizeOf.insert n (exprSize ci.type)
  IO.println s!"  {sizeOf.size} declarations sized"
  -- pass 2: walk dependency edges and accumulate the 8x8 cell transition matrix
  -- matrix.[fromCell * 8 + toCell] = count; deltaHist.[Δ] = count of edges with shift Δ
  let mut matrix : Array Nat := Array.replicate 64 0
  let mut deltaHist : Array Nat := Array.replicate 8 0
  -- a few example edges per (fromCell,toCell) pair
  let mut examples : Std.HashMap Nat (Array (Name × Name)) := {}
  let mut edgeTotal : Nat := 0
  for (n, ci) in env.constants.map₁.toList do
    if n.isInternal || n.toString.startsWith "_" then
      continue
    let some szTo := sizeOf.get? n | continue
    let toCell := cellIndex szTo
    for d in constDepNames ci do
      let some szFrom := sizeOf.get? d | continue   -- only edges to tracked declarations
      let fromCell := cellIndex szFrom
      let key := fromCell * 8 + toCell
      matrix := matrix.set! key (matrix[key]! + 1)
      let delta := (toCell + 8 - fromCell) % 8
      deltaHist := deltaHist.set! delta (deltaHist[delta]! + 1)
      edgeTotal := edgeTotal + 1
      let cur := examples.getD key #[]
      if cur.size < 3 then
        examples := examples.insert key (cur.push (d, n))
  IO.println s!"  {edgeTotal} dependency arrows logged"
  IO.FS.createDirAll outPath
  -- ===== arrows.txt =====
  let mut txt : Array String := #[]
  txt := txt.push "# Cell-to-cell arrows of the Lean periodic table"
  txt := txt.push s!"# {sizeOf.size} declarations, {edgeTotal} dependency edges (arrows)."
  txt := txt.push "# An edge d -> n (n references d) is an arrow crystalCell(d) -> crystalCell(n)."
  txt := txt.push ""
  txt := txt.push "## Residue-shift histogram  Δ = (r_to − r_from) mod 8"
  txt := txt.push "   (Δ=1 is the elementary arrow, e.g. AI -> BDI; Δ=0 stays in-cell.)"
  for delta in List.range 8 do
    txt := txt.push s!"   Δ={delta}: {deltaHist[delta]!}"
  txt := txt.push ""
  txt := txt.push "## 8×8 cell transition matrix (rows = from-cell, cols = to-cell)"
  txt := txt.push ("   " ++ padR "from\\to" 8 ++ String.intercalate " " (realCartanLabels.toList.map (fun l => padR l 6)))
  for i in List.range 8 do
    let row := (List.range 8).map (fun jc => padR (toString matrix[i*8+jc]!) 6)
    txt := txt.push ("   " ++ padR realCartanLabels[i]! 8 ++ String.intercalate " " row)
  txt := txt.push ""
  txt := txt.push "## Example arrows per transition (dependency -> declaration)"
  for i in List.range 8 do
    for jc in List.range 8 do
      let key := i*8+jc
      let exs := examples.getD key #[]
      if exs.size > 0 then
        txt := txt.push s!"### {realCartanLabels[i]!} -> {realCartanLabels[jc]!}  ({matrix[key]!} edges)"
        for (d, n) in exs do
          txt := txt.push s!"  - {d}  ==>  {n}"
  IO.FS.writeFile (outPath / "arrows.txt") (String.intercalate "\n" txt.toList ++ "\n")
  -- ===== arrows.json =====
  let mut j : Array String := #["{"]
  j := j.push s!"  \"totalDeclarations\": {sizeOf.size},"
  j := j.push s!"  \"totalArrows\": {edgeTotal},"
  j := j.push s!"  \"cells\": [{String.intercalate ", " (realCartanLabels.toList.map (fun l => "\"" ++ l ++ "\""))}],"
  -- residue-shift histogram
  j := j.push s!"  \"deltaHistogram\": [{String.intercalate ", " ((List.range 8).map (fun delta => toString deltaHist[delta]!))}],"
  -- transition matrix
  j := j.push "  \"transitionMatrix\": ["
  let rows := (List.range 8).map (fun i =>
    "    [" ++ String.intercalate ", " ((List.range 8).map (fun jc => toString matrix[i*8+jc]!)) ++ "]")
  j := j.push (String.intercalate ",\n" rows)
  j := j.push "  ],"
  -- example arrows
  j := j.push "  \"examples\": {"
  let mut exEntries : Array String := #[]
  for i in List.range 8 do
    for jc in List.range 8 do
      let key := i*8+jc
      let exs := examples.getD key #[]
      if exs.size > 0 then
        let pairs := String.intercalate ", " (exs.toList.map (fun (d, n) =>
          "[\"" ++ jsonEsc d.toString ++ "\", \"" ++ jsonEsc n.toString ++ "\"]"))
        exEntries := exEntries.push s!"    \"{realCartanLabels[i]!}->{realCartanLabels[jc]!}\": [{pairs}]"
  j := j.push (String.intercalate ",\n" exEntries.toList)
  j := j.push "  }"
  j := j.push "}"
  IO.FS.writeFile (outPath / "arrows.json") (String.intercalate "\n" j.toList ++ "\n")
  IO.println s!"  arrows.txt / arrows.json written to {outDirStr}"
  return 0
