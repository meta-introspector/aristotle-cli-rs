/-
DaslSplit/Core.lean — Shared Kernel Dependency Extraction Core

The 10 functions present in BOTH Lean4Introspector.lean AND SplitDecls.lean
(30.3% Jaccard). This is the proven reusable kernel of Lean4 declaration splitting.

Dependencies: import Lean only. No Mathlib.
-/
import Lean
open Lean

namespace DaslSplit

/-! ## Dependency extraction (exact, from the kernel — not regex) -/

/-- Collect all constant names referenced in an expression. -/
def collectRefs (e : Expr) : NameSet :=
  e.foldConsts {} fun n s => s.insert n

/-- Constants referenced in a declaration's **type**. -/
def typeRefs (env : Environment) (n : Name) : NameSet :=
  match env.find? n with
  | some ci => collectRefs ci.type
  | none => {}

/-- Constants referenced in a declaration's **value / proof term**. -/
def valueRefs (env : Environment) (n : Name) : NameSet :=
  match env.find? n with
  | some (.defnInfo v) => collectRefs v.value
  | some (.thmInfo v)  => collectRefs v.value
  | some (.opaqueInfo v) => collectRefs v.value
  | _ => {}

/-- All dependencies of a constant (type + value). -/
def constDeps (env : Environment) (n : Name) : NameSet :=
  (typeRefs env n).union (valueRefs env n)

/-- Filter a dependency set to only names in our universe, as a sorted array. -/
def filterDeps (deps : NameSet) (targets : NameSet) : Array Name := Id.run do
  let mut result : Array Name := #[]
  for n in deps.toList do
    if targets.contains n then result := result.push n
  return result.qsort (fun a b => a.toString < b.toString)

/-- BFS dependency closure from a set of roots, staying inside `universeSet`. -/
def bfsClosure (env : Environment) (roots : Array Name) (universeSet : NameSet) : NameSet := Id.run do
  let mut visited : NameSet := {}
  let mut queue : Array Name := roots
  let mut head := 0
  while head < queue.size do
    let n := queue[head]!
    head := head + 1
    if visited.contains n then continue
    if !universeSet.contains n then continue
    visited := visited.insert n
    for d in (constDeps env n).toList do
      if universeSet.contains d && !visited.contains d then
        queue := queue.push d
  return visited

/-- Convert a Lean Name to a flat module name suitable for `import`. -/
def nameToSimpleMod (n : Name) : String :=
  "Split." ++ n.toString.replace "." "_"

/-! ## Emit functions -/

/-- Emit one annotated stub `.lean` file for a declaration. -/
def emitDeclFile (env : Environment) (name : Name) (deps : Array Name) (outDir : System.FilePath) : IO Unit := do
  let relPath := (nameToSimpleMod name).replace "." "/" ++ ".lean"
  let path := outDir / relPath
  let parent := path.parent.getD outDir
  IO.FS.createDirAll parent
  let mut lines : Array String := #[]
  for dep in deps do
    lines := lines.push s!"import {nameToSimpleMod dep}"
  if deps.size > 0 then lines := lines.push ""
  lines := lines.push s!"-- {name}"
  lines := lines.push s!"-- Stub: declaration `{name}` of the introspected split lattice."
  match env.find? name with
  | some ci => lines := lines.push s!"-- {name} : {ci.type}"
  | none    => pure ()
  lines := lines.push ""
  IO.FS.writeFile path (String.intercalate "\n" lines.toList ++ "\n")

/-- Emit the dependency DAG as JSON. -/
def emitDag (deps : Std.HashMap Name (Array Name)) (outDir : System.FilePath) : IO Unit := do
  let mut lines : Array String := #["{"]
  let entries := deps.toList.toArray
  for i in [:entries.size] do
    let (n, ds) := entries[i]!
    let depsStr := ds.toList.map (fun x => s!"\"{x.toString}\"")
    let comma := if i + 1 < entries.size then "," else ""
    lines := lines.push s!"  \"{n.toString}\": [{String.intercalate ", " depsStr}]{comma}"
  lines := lines.push "}"
  IO.FS.writeFile (outDir / "dag.json") (String.intercalate "\n" lines.toList ++ "\n")

end DaslSplit
