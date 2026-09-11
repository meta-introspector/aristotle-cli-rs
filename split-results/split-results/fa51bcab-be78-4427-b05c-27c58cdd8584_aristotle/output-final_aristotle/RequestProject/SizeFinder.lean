/-
SizeFinder.lean — group declarations by their numeric "size signature".

This is the analysis companion to `RequestProject/SizeSignature.lean`. It loads a Lean
environment and, entirely in memory, assigns every declaration a numeric **size signature**
and then groups together all declarations that *share the same size*.

The size signature is the number of **leaf elements** of a declaration's type, viewing the
type as a tree (its `Expr`): atomic sub-terms (`bvar`, `fvar`, `const`, `sort`, `lit`, …)
are leaves, and the application / binder nodes split into sub-trees. This is exactly the
`size` function of `SizeSignature.Shape`, read off a real `Expr`: a "structure with two
elements, each a structure with two elements" has size `4 = 2 ^ 2`, and we group every
object by that leaf count.

Outputs (to the configured output dir, default `./size-out`):
  * `sizes.txt`     — human-readable: histogram of size signatures, the most common sizes,
                      and a sample of the objects in selected classes (incl. size `4 = 2^2`).
  * `sizes.json`    — histogram (size → count) as JSON.
  * `classes.json`  — for each size, a sample of declarations with that size signature.

Usage:
  lake exe sizefinder <Module> <outputDir>
  lake exe sizefinder                       -- reads size-config.json, else uses defaults
-/
import Lean

open Lean System

/-- The size signature of an expression: the number of leaf sub-terms when the expression
is viewed as a tree (application and binder nodes branch; atoms are leaves). This is the
`Expr` realisation of `SizeSignature.size`. -/
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

/-- Parse the shared config format (`modules`/`module` + `outputDir`). -/
def parseConfig (s : String) : List String × String :=
  match Json.parse s with
  | .error _ => ([], "./size-out")
  | .ok j =>
    let out := (j.getObjValAs? String "outputDir").toOption.getD "./size-out"
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

/-- Read configuration from CLI args, or `size-config.json`, else defaults. -/
def readSizeConfig (args : List String) : IO (List String × String) := do
  let default : List String := ["Mathlib.Algebra.Vertex.HVertexOperator"]
  match args with
  | [] =>
    let configPath := System.FilePath.mk "size-config.json"
    if ← configPath.pathExists then
      let content ← IO.FS.readFile configPath
      let (mods, out) := parseConfig content
      return (if mods.isEmpty then default else mods, if out == "./size-out" then "./size-out" else out)
    else
      return (default, "./size-out")
  | [m] => return ([m], "./size-out")
  | m :: out :: _ => return ([m], out)

/-- Escape a string for embedding in JSON. -/
def jsonEsc (s : String) : String :=
  s.replace "\\" "\\\\" |>.replace "\"" "\\\""

/-- Main: compute every declaration's size signature and group by equal size. -/
def main (args : List String) : IO UInt32 := do
  let (rootMods, outDirStr) ← readSizeConfig args
  let outPath : System.FilePath := System.FilePath.mk outDirStr
  IO.println s!"SizeFinder: roots={rootMods} out={outDirStr}"
  initSearchPath (← findSysroot)
  let imports := (rootMods.map (fun m => ({module := m.toName} : Import))).toArray
  let env ← importModules imports {}
  -- size signature of every non-internal declaration, grouped by its size
  let mut byNum : Std.HashMap Nat (Array Name) := {}
  let mut total : Nat := 0
  for (n, ci) in env.constants.map₁.toList do
    if n.isInternal || n.toString.startsWith "_" then
      continue
    let sz := exprSize ci.type
    byNum := byNum.insert sz ((byNum.getD sz #[]).push n)
    total := total + 1
  IO.println s!"  {total} declarations scanned"
  let maxSize := byNum.toList.foldl (fun acc (s, _) => Nat.max acc s) 0
  -- histogram, sorted by size ascending
  IO.FS.createDirAll outPath
  -- sizes.json
  let mut jLines : Array String := #["{"]
  jLines := jLines.push s!"  \"totalDeclarations\": {total},"
  jLines := jLines.push s!"  \"maxSize\": {maxSize},"
  jLines := jLines.push "  \"histogram\": {"
  let mut entries : Array String := #[]
  for s in [1:maxSize+1] do
    let c := (byNum.getD s #[]).size
    if c > 0 then entries := entries.push s!"    \"{s}\": {c}"
  jLines := jLines.push (String.intercalate ",\n" entries.toList)
  jLines := jLines.push "  }"
  jLines := jLines.push "}"
  IO.FS.writeFile (outPath / "sizes.json") (String.intercalate "\n" jLines.toList ++ "\n")
  -- classes.json: for each size, a sample (up to 8) of declarations with that size
  let mut cLines : Array String := #["{"]
  let mut cEntries : Array String := #[]
  for s in [1:maxSize+1] do
    let arr := byNum.getD s #[]
    if arr.size > 0 then
      let sample := arr.extract 0 (min 8 arr.size)
      let names := String.intercalate ", " (sample.toList.map (fun n => "\"" ++ jsonEsc n.toString ++ "\""))
      cEntries := cEntries.push s!"  \"{s}\": [{names}]"
  cLines := cLines.push (String.intercalate ",\n" cEntries.toList)
  cLines := cLines.push "}"
  IO.FS.writeFile (outPath / "classes.json") (String.intercalate "\n" cLines.toList ++ "\n")
  -- sizes.txt: human-readable summary
  let mut txt : Array String := #[]
  txt := txt.push s!"# Size signatures of {total} declarations (size = #leaf elements of the type)"
  txt := txt.push ""
  -- most common sizes
  let sortedByCount := (byNum.toList.map (fun (s, a) => (s, a.size))).toArray.qsort (fun a b => a.2 > b.2)
  txt := txt.push "## Most common size signatures (size : count)"
  for (s, c) in (sortedByCount.extract 0 (min 12 sortedByCount.size)).toList do
    txt := txt.push s!"  {s} : {c}"
  txt := txt.push ""
  txt := txt.push "## Full histogram (size : count)"
  for s in [1:maxSize+1] do
    let c := (byNum.getD s #[]).size
    if c > 0 then txt := txt.push s!"  {s} : {c}"
  txt := txt.push ""
  -- highlight the motivating size 4 = 2^2 and the common small primes 2,3,5
  let showClass (s : Nat) (label : String) : Array String := Id.run do
    let arr := byNum.getD s #[]
    let sample := arr.extract 0 (min 12 arr.size)
    let mut ls : Array String := #[]
    ls := ls.push s!"## Objects of size {s} {label} — {arr.size} total, sample:"
    for n in sample do
      ls := ls.push s!"  - {n}"
    ls := ls.push ""
    return ls
  txt := txt ++ showClass 2 "(prime)"
  txt := txt ++ showClass 3 "(prime)"
  txt := txt ++ showClass 4 "(= 2^2, the motivating nested structure)"
  txt := txt ++ showClass 5 "(prime)"
  IO.FS.writeFile (outPath / "sizes.txt") (String.intercalate "\n" txt.toList ++ "\n")
  IO.println s!"  sizes.txt / sizes.json / classes.json written to {outDirStr}"
  return 0
