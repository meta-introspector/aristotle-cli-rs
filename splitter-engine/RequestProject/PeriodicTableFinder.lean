/-
PeriodicTableFinder.lean — build the periodic table of Lean 4 corelib + Mathlib.

This is the analysis companion to `RequestProject/PeriodicTable.lean`.  It loads a Lean
environment (Lean 4 core + Mathlib, via `import Mathlib`) and feeds the collected size
data into the **crystal mapping system** — the Altland–Zirnbauer "tenfold way" periodic
table of `RequestProject/AZ/` — to produce the periodic table of Lean.

For every declaration it:
  1. computes the **size signature** `N` of its type (leaf count of the `Expr`, exactly
     `SizeFinder`'s `exprSize` / `SizeSignature.size`);
  2. reads `N` on the real Bott clock `ℤ₈`: residue `r = N mod 8`;
  3. assigns it the Altland–Zirnbauer **real symmetry class** sitting at residue `r`
     (the *crystal cell*), in Bott-clock order
     `AI, BDI, D, DIII, AII, CII, C, CI`;
  4. (shadow) reads `N` on the complex clock `ℤ₂`: residue `N mod 2` ↦ `A`/`AIII`.

It then groups all declarations by their crystal cell, and prints the genuine periodic
table grid: for each of the ten classes and each spatial dimension `d = 0,…,7`, the
classifying K-group `classify c d ∈ {0, ℤ, ℤ₂, 2ℤ}`.  The numeric logic here mirrors,
by construction, the machine-checked `AZ.classify` / `ShapeBott.realClassOfResidue` /
`PeriodicTable.crystalCell` (see `PeriodicTable.crystalCell_table`,
`PeriodicTable.crystalCell_realIndex`, `AZ.periodic_table`).

Outputs (to the configured output dir, default `./periodic-out`):
  * `periodic-table.txt`  — human-readable: the full class×dimension K-group grid, the
                            population of each crystal cell, and samples of declarations.
  * `periodic-table.json` — per-class populations, the K-group grid, and samples.

Usage:
  lake exe periodictable <Module> <outputDir>
  lake exe periodictable                       -- reads periodic-config.json, else defaults
-/
import Lean

open Lean System

/-- The size signature of an expression: number of leaf sub-terms of the type viewed as a
tree.  Identical to `SizeFinder.exprSize` and the `Expr` realisation of
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

/-! ## The crystal mapping system (computable mirror of `AZ` / `PeriodicTable`).

These functions reproduce, on plain `Nat` residues, the machine-checked maps of
`RequestProject/PeriodicTable.lean`:
* `realCartan` ↔ `ShapeBott.realClassOfResidue` / `PeriodicTable.crystalCell`;
* `realKGroup` ↔ `AZ.realPattern`;
* `classifyReal` ↔ `AZ.classify` on the real classes. -/

/-- Cartan labels of the eight real Altland–Zirnbauer classes, in Bott-clock order
(`realIndex = 0,…,7`). -/
def realCartanLabels : Array String :=
  #["AI", "BDI", "D", "DIII", "AII", "CII", "C", "CI"]

/-- The crystal cell (real Cartan label) of a size signature `N`: residue `N mod 8`. -/
def realCartan (N : Nat) : String :=
  realCartanLabels[N % 8]!

/-- Complex Cartan label of a size signature `N` on the period-2 clock. -/
def complexCartan (N : Nat) : String :=
  if N % 2 == 0 then "A" else "AIII"

/-- The period-8 real K-group pattern `AZ.realPattern`, as a string. -/
def realKGroup (n : Nat) : String :=
  let m := n % 8
  if m == 0 then "Z"
  else if m == 1 then "Z2"
  else if m == 2 then "Z2"
  else if m == 4 then "2Z"
  else "0"

/-- The period-2 complex K-group pattern `AZ.complexPattern`, as a string. -/
def complexKGroup (n : Nat) : String :=
  if n % 2 == 0 then "Z" else "0"

/-- `classify` for a real class at clock residue `r` in spatial dimension `d`:
`realPattern (r - d mod 8)`.  Mirrors `AZ.classify` on the real classes. -/
def classifyReal (r d : Nat) : String :=
  realKGroup ((r + 8 - (d % 8)) % 8)

/-- `classify` for a complex class at clock residue `r` in dimension `d`. -/
def classifyComplex (r d : Nat) : String :=
  complexKGroup ((r + 2 - (d % 2)) % 2)

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

/-- Read configuration from CLI args, or `periodic-config.json`, else defaults. -/
def readPTConfig (args : List String) : IO (List String × String) := do
  let dflt : List String := ["Mathlib"]
  match args with
  | [] =>
    let configPath := System.FilePath.mk "periodic-config.json"
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

/-- Main: classify every declaration into its crystal cell and emit the periodic table. -/
def main (args : List String) : IO UInt32 := do
  let (rootMods, outDirStr) ← readPTConfig args
  let outPath : System.FilePath := System.FilePath.mk outDirStr
  IO.println s!"PeriodicTableFinder: roots={rootMods} out={outDirStr}"
  initSearchPath (← findSysroot)
  let imports := (rootMods.map (fun m => ({module := m.toName} : Import))).toArray
  let env ← importModules imports {}
  -- classify each declaration by its crystal cell (residue of its size mod 8)
  let mut byCell : Std.HashMap String (Array Name) := {}
  -- track sizes contributing to each cell for diagnostics
  let mut total : Nat := 0
  for (n, ci) in env.constants.map₁.toList do
    if n.isInternal || n.toString.startsWith "_" then
      continue
    let sz := exprSize ci.type
    let cell := realCartan sz
    byCell := byCell.insert cell ((byCell.getD cell #[]).push n)
    total := total + 1
  IO.println s!"  {total} declarations classified into crystal cells"
  IO.FS.createDirAll outPath
  -- the ten classes, in periodic-table order (eight real + two complex), with their
  -- clock residue used to compute classify.
  let realClasses : Array (String × Nat) :=
    #[("AI", 0), ("BDI", 1), ("D", 2), ("DIII", 3),
      ("AII", 4), ("CII", 5), ("C", 6), ("CI", 7)]
  let complexClasses : Array (String × Nat) := #[("A", 0), ("AIII", 1)]
  -- population of each crystal cell
  let cellCount (c : String) : Nat := (byCell.getD c #[]).size
  -- ===== periodic-table.txt =====
  let mut txt : Array String := #[]
  txt := txt.push s!"# Periodic table of Lean 4 corelib + Mathlib"
  txt := txt.push s!"# {total} declarations, each mapped by its size signature to an"
  txt := txt.push s!"# Altland-Zirnbauer symmetry class via the real Bott clock (ZMod 8)."
  txt := txt.push ""
  txt := txt.push "## The crystal map (size residue mod 8 -> real Cartan class)"
  txt := txt.push "   r=0 AI | r=1 BDI | r=2 D | r=3 DIII | r=4 AII | r=5 CII | r=6 C | r=7 CI"
  txt := txt.push ""
  txt := txt.push "## Population of each crystal cell (declarations whose size hits that class)"
  txt := txt.push "   class   residue   count"
  let mut realTotal : Nat := 0
  for (lab, r) in realClasses do
    let c := cellCount lab
    realTotal := realTotal + c
    txt := txt.push s!"   {padR lab 7} {padR (toString r) 9} {c}"
  txt := txt.push s!"   (real total: {realTotal})"
  txt := txt.push ""
  txt := txt.push "## Complex shadow (size residue mod 2 -> A/AIII)"
  let mut aCount : Nat := 0
  let mut aiiiCount : Nat := 0
  for (lab, r) in realClasses do
    if r % 2 == 0 then aCount := aCount + cellCount lab
    else aiiiCount := aiiiCount + cellCount lab
  txt := txt.push s!"   A    (even size): {aCount}"
  txt := txt.push s!"   AIII (odd size) : {aiiiCount}"
  txt := txt.push ""
  -- the periodic table grid: rows = classes, cols = spatial dimension 0..7
  txt := txt.push "## The periodic table grid: classifying K-group `classify c d`"
  txt := txt.push ("   " ++ padR "class" 7 ++ (String.intercalate " " ((List.range 8).map (fun d => padR s!"d={d}" 5))))
  for (lab, r) in realClasses do
    let row := (List.range 8).map (fun d => padR (classifyReal r d) 5)
    txt := txt.push ("   " ++ padR lab 7 ++ String.intercalate " " row)
  for (lab, r) in complexClasses do
    let row := (List.range 8).map (fun d => padR (classifyComplex r d) 5)
    txt := txt.push ("   " ++ padR lab 7 ++ String.intercalate " " row)
  txt := txt.push ""
  txt := txt.push "   (In every spatial dimension exactly five of the ten classes are"
  txt := txt.push "    topologically nontrivial; cf. AZ.five_nontrivial_per_dimension.)"
  txt := txt.push ""
  -- samples per cell
  txt := txt.push "## Sample declarations in each crystal cell"
  for (lab, r) in realClasses do
    let arr := byCell.getD lab #[]
    let sample := arr.extract 0 (min 10 arr.size)
    txt := txt.push s!"### {lab} (residue {r}) — {arr.size} declarations"
    for nm in sample do
      txt := txt.push s!"  - {nm}"
    txt := txt.push ""
  IO.FS.writeFile (outPath / "periodic-table.txt") (String.intercalate "\n" txt.toList ++ "\n")
  -- ===== periodic-table.json =====
  let mut j : Array String := #["{"]
  j := j.push s!"  \"totalDeclarations\": {total},"
  -- populations
  j := j.push "  \"cellPopulations\": {"
  let popEntries := realClasses.toList.map (fun (lab, _) => s!"    \"{lab}\": {cellCount lab}")
  j := j.push (String.intercalate ",\n" popEntries)
  j := j.push "  },"
  j := j.push ("  \"complexShadow\": { \"A\": " ++ toString aCount ++ ", \"AIII\": " ++ toString aiiiCount ++ " },")
  -- grid
  j := j.push "  \"periodicTable\": {"
  let gridEntries := (realClasses ++ complexClasses).toList.map (fun (lab, r) =>
    let isReal := realClasses.any (fun (l, _) => l == lab)
    let row := (List.range 8).map (fun d =>
      "\"" ++ (if isReal then classifyReal r d else classifyComplex r d) ++ "\"")
    s!"    \"{lab}\": [{String.intercalate ", " row}]")
  j := j.push (String.intercalate ",\n" gridEntries)
  j := j.push "  },"
  -- samples
  j := j.push "  \"samples\": {"
  let sampleEntries := realClasses.toList.map (fun (lab, _) =>
    let arr := byCell.getD lab #[]
    let sample := arr.extract 0 (min 8 arr.size)
    let names := String.intercalate ", " (sample.toList.map (fun n => "\"" ++ jsonEsc n.toString ++ "\""))
    s!"    \"{lab}\": [{names}]")
  j := j.push (String.intercalate ",\n" sampleEntries)
  j := j.push "  }"
  j := j.push "}"
  IO.FS.writeFile (outPath / "periodic-table.json") (String.intercalate "\n" j.toList ++ "\n")
  IO.println s!"  periodic-table.txt / periodic-table.json written to {outDirStr}"
  return 0
