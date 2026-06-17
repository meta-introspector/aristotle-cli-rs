/-
DupFinder.lean — find duplicate and similar declarations in a Lean environment, in memory,
and emit a graded decomposition of the declaration set.

This is the analysis companion to `SplitDecls.lean`. It loads a Lean environment (the Lean
standard library plus whatever Mathlib modules the config asks for), then, entirely in
memory:

1. **Duplicate detection.**
   * *Duplicate theorems* — distinct theorems whose **statement** (type, up to
     α-equivalence / de Bruijn structure) is identical. By proof irrelevance these prove the
     very same proposition: genuinely duplicated lemmas.
   * *Duplicate definitions* — distinct defs whose **type and body** are both structurally
     identical: genuinely duplicated code.

2. **Grading (the graded-algebra model).**
   Each declaration is assigned a grade = its depth in the dependency DAG (atoms with no
   in-universe dependencies have grade 0). This realises the weighting `w` of
   `GradedCodeModel`: declarations of the same grade form one homogeneous component, and
   "similar code" (in the model's sense) = declarations sharing a grade. We emit the grade
   histogram and a sample.

Outputs (to the configured output dir, default `./dup-out`):
  * `duplicates.txt`  — human-readable groups of duplicate theorems / definitions
  * `duplicates.json` — the same data as JSON
  * `graded.json`     — grade histogram (homogeneous-component sizes) + a per-grade sample

Usage:
  lake exe dupfinder <Module> <outputDir>
  lake exe dupfinder                       -- reads dup-config.json, else uses defaults
-/
import Lean

open Lean System

/-! ## Dependency helpers (shared with `SplitDecls`) -/

/-- Collect all constant names referenced in an expression. -/
def collectRefs (e : Expr) : NameSet :=
  e.foldConsts {} fun n s => s.insert n

/-- Get all dependencies of a constant (from its type + value). -/
def constDeps (env : Environment) (n : Name) : NameSet :=
  match env.find? n with
  | some ci =>
    let fromType := collectRefs ci.type
    let fromVal := match ci with
      | .defnInfo v => collectRefs v.value
      | .thmInfo v  => collectRefs v.value
      | .opaqueInfo v => collectRefs v.value
      | _ => {}
    fromType.union fromVal
  | none => {}

/-- Filter a dependency set down to only names that are in our target universe. -/
def filterDeps (deps : NameSet) (targets : NameSet) : Array Name := Id.run do
  let mut result : Array Name := #[]
  for n in deps.toList do
    if targets.contains n then result := result.push n
  return result

/-- Topological sort of `names` (dependencies before dependents), iterative DFS post-order. -/
def topoSort (env : Environment) (names : Array Name) (universeSet : NameSet) : Array Name := Id.run do
  let mut depMap : NameMap (Array Name) := {}
  for n in names do
    depMap := depMap.insert n (filterDeps (constDeps env n) universeSet)
  let mut visited : NameSet := {}
  let mut sorted : Array Name := #[]
  for root in names do
    if visited.contains root then continue
    let mut stack : Array (Name × Nat) := #[(root, 0)]
    while stack.size > 0 do
      let top := stack[stack.size - 1]!
      let n := top.1
      let ci := top.2
      if ci == 0 && visited.contains n then
        stack := stack.pop
      else
        if ci == 0 then
          visited := visited.insert n
        let deps := depMap.getD n #[]
        if ci < deps.size then
          stack := stack.set! (stack.size - 1) (n, ci + 1)
          let d := deps[ci]!
          if !visited.contains d then
            stack := stack.push (d, 0)
        else
          sorted := sorted.push n
          stack := stack.pop
  return sorted

/-- Parse a config string (same format as `SplitDecls`): `modules`/`module` + `outputDir`. -/
def parseConfig (s : String) : List String × String :=
  match Json.parse s with
  | .error _ => ([], "./split-out")
  | .ok j =>
    let out := (j.getObjValAs? String "outputDir").toOption.getD "./split-out"
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

/-! ## Scanning -/

/-- A scanned declaration: its name, whether it is a theorem (`true`) or a def (`false`),
its type, and (for defs) its value. -/
structure ScanItem where
  name : Name
  isThm : Bool
  type : Expr
  value : Option Expr
deriving Inhabited

/-- Collect the theorems and definitions of the environment as `ScanItem`s, skipping
internal / auto-generated names. -/
def scanItems (env : Environment) : Array ScanItem := Id.run do
  let mut out : Array ScanItem := #[]
  for (n, ci) in env.constants.map₁.toList do
    if n.isInternal || n.toString.startsWith "_" then
      continue
    match ci with
    | .thmInfo v => out := out.push ⟨n, true, v.type, none⟩
    | .defnInfo v => out := out.push ⟨n, false, v.type, some v.value⟩
    | _ => pure ()
  return out

/-- Two scan items are duplicates: theorems with structurally equal statements, or defs
with structurally equal type *and* body. -/
def isDup (a b : ScanItem) : Bool :=
  if a.isThm && b.isThm then
    Expr.equal a.type b.type
  else if (!a.isThm) && (!b.isThm) then
    Expr.equal a.type b.type &&
      (match a.value, b.value with
       | some va, some vb => Expr.equal va vb
       | _, _ => false)
  else
    false

/-- Group scan items into duplicate classes (size ≥ 2). Buckets by type hash first, then
compares structurally within each bucket. -/
def findDuplicates (items : Array ScanItem) : Array (Bool × Array Name) := Id.run do
  -- bucket by type hash
  let mut buckets : Std.HashMap UInt64 (Array ScanItem) := {}
  for it in items do
    let h := it.type.hash
    buckets := buckets.insert h ((buckets.getD h #[]).push it)
  let mut groups : Array (Bool × Array Name) := #[]
  for (_, arr) in buckets.toList do
    let mut used : Array Bool := Array.replicate arr.size false
    for i in [0:arr.size] do
      if used[i]! then continue
      let ai := arr[i]!
      let mut group : Array Name := #[ai.name]
      for j in [i+1:arr.size] do
        if used[j]! then continue
        let aj := arr[j]!
        if isDup ai aj then
          group := group.push aj.name
          used := used.set! j true
      if group.size ≥ 2 then
        groups := groups.push (ai.isThm, group)
  return groups

/-- Compute the grade (dependency depth) of every declaration in `univSet`, processing in
topological order so each declaration's dependencies are graded first. -/
def computeGrades (env : Environment) (univSet : NameSet) : NameMap Nat := Id.run do
  let univArr := univSet.toList.toArray
  let sorted := topoSort env univArr univSet
  let mut grade : NameMap Nat := {}
  for n in sorted do
    let deps := filterDeps (constDeps env n) univSet
    let g := deps.foldl (fun acc d => Nat.max acc ((grade.find? d |>.getD 0) + 1)) 0
    grade := grade.insert n g
  return grade

/-- Escape a string for embedding in JSON. -/
def jsonEsc (s : String) : String :=
  s.replace "\\" "\\\\" |>.replace "\"" "\\\""

/-- Write the human-readable and JSON duplicate reports. -/
def emitDuplicates (groups : Array (Bool × Array Name)) (outDir : System.FilePath) :
    IO Unit := do
  let thmGroups := groups.filter (·.1)
  let defGroups := groups.filter (fun g => !g.1)
  -- text report
  let mut txt : Array String := #[]
  txt := txt.push s!"# Duplicate declarations"
  txt := txt.push s!"# {thmGroups.size} duplicate-theorem classes, {defGroups.size} duplicate-definition classes"
  txt := txt.push ""
  txt := txt.push "## Duplicate theorems (identical statements)"
  for (_, g) in thmGroups do
    txt := txt.push s!"- [{g.size}] {String.intercalate ", " (g.toList.map (·.toString))}"
  txt := txt.push ""
  txt := txt.push "## Duplicate definitions (identical type and body)"
  for (_, g) in defGroups do
    txt := txt.push s!"- [{g.size}] {String.intercalate ", " (g.toList.map (·.toString))}"
  IO.FS.writeFile (outDir / "duplicates.txt") (String.intercalate "\n" txt.toList ++ "\n")
  -- json report
  let groupJson (g : Array Name) : String :=
    "[" ++ String.intercalate ", " (g.toList.map (fun n => "\"" ++ jsonEsc n.toString ++ "\"")) ++ "]"
  let thmJson := String.intercalate ",\n    " (thmGroups.toList.map (fun g => groupJson g.2))
  let defJson := String.intercalate ",\n    " (defGroups.toList.map (fun g => groupJson g.2))
  let json :=
    "{\n  \"duplicateTheorems\": [\n    " ++ thmJson ++ "\n  ],\n" ++
    "  \"duplicateDefinitions\": [\n    " ++ defJson ++ "\n  ]\n}\n"
  IO.FS.writeFile (outDir / "duplicates.json") json

/-- Write the grade histogram (homogeneous-component sizes) and a small per-grade sample. -/
def emitGraded (grades : NameMap Nat) (outDir : System.FilePath) : IO Unit := do
  -- histogram: grade → count, plus a sample of up to 5 names per grade
  let mut hist : Std.HashMap Nat Nat := {}
  let mut sample : Std.HashMap Nat (Array Name) := {}
  for (n, g) in grades.toList do
    hist := hist.insert g ((hist.getD g 0) + 1)
    let s := sample.getD g #[]
    if s.size < 5 then sample := sample.insert g (s.push n)
  let maxGrade := hist.toList.foldl (fun acc (g, _) => Nat.max acc g) 0
  let mut lines : Array String := #["{"]
  lines := lines.push s!"  \"totalDeclarations\": {grades.toList.length},"
  lines := lines.push s!"  \"maxGrade\": {maxGrade},"
  lines := lines.push "  \"componentSizes\": {"
  let mut entries : Array String := #[]
  for g in [0:maxGrade+1] do
    let c := hist.getD g 0
    entries := entries.push s!"    \"{g}\": {c}"
  lines := lines.push (String.intercalate ",\n" entries.toList)
  lines := lines.push "  },"
  lines := lines.push "  \"sample\": {"
  let mut sEntries : Array String := #[]
  for g in [0:maxGrade+1] do
    let s := sample.getD g #[]
    let names := String.intercalate ", " (s.toList.map (fun n => "\"" ++ jsonEsc n.toString ++ "\""))
    sEntries := sEntries.push s!"    \"{g}\": [{names}]"
  lines := lines.push (String.intercalate ",\n" sEntries.toList)
  lines := lines.push "  }"
  lines := lines.push "}"
  IO.FS.writeFile (outDir / "graded.json") (String.intercalate "\n" lines.toList ++ "\n")

/-- Read configuration from CLI args, or `dup-config.json`, else defaults. Reuses the same
config format as `SplitDecls` (`modules`/`module` + `outputDir`). -/
def readDupConfig (args : List String) : IO (List String × String) := do
  let default : List String := ["Mathlib.Algebra.Vertex.HVertexOperator"]
  match args with
  | [] =>
    let configPath := System.FilePath.mk "dup-config.json"
    if ← configPath.pathExists then
      let content ← IO.FS.readFile configPath
      let (mods, out) := parseConfig content
      return (if mods.isEmpty then default else mods, if out == "./split-out" then "./dup-out" else out)
    else
      return (default, "./dup-out")
  | [m] => return ([m], "./dup-out")
  | m :: out :: _ => return ([m], out)

/-- Main: scan the environment for duplicate/similar code and grade it. -/
def main (args : List String) : IO UInt32 := do
  let (rootMods, outDirStr) ← readDupConfig args
  let outPath : System.FilePath := System.FilePath.mk outDirStr
  IO.println s!"DupFinder: roots={rootMods} out={outDirStr}"
  initSearchPath (← findSysroot)
  let imports := (rootMods.map (fun m => ({module := m.toName} : Import))).toArray
  let env ← importModules imports {}
  -- universe = all non-internal declarations in memory
  let mut univSet : NameSet := {}
  for (n, _) in env.constants.map₁.toList do
    if !n.isInternal && !n.toString.startsWith "_" then
      univSet := univSet.insert n
  IO.println s!"  {univSet.toList.length} declarations in environment (scan universe)"
  -- duplicate detection
  let items := scanItems env
  IO.println s!"  {items.size} theorems + definitions scanned"
  let groups := findDuplicates items
  let thmDup := (groups.filter (·.1)).size
  let defDup := (groups.filter (fun g => !g.1)).size
  IO.println s!"  {thmDup} duplicate-theorem classes, {defDup} duplicate-definition classes"
  IO.FS.createDirAll outPath
  emitDuplicates groups outPath
  -- grading
  let grades := computeGrades env univSet
  emitGraded grades outPath
  IO.println s!"  duplicates.txt / duplicates.json / graded.json written to {outDirStr}"
  return 0
