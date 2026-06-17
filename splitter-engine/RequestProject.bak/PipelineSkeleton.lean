/-
PipelineSkeleton.lean — map out the minimal Lean 4 parser/processor skeleton.

This applies the exact-dependency extraction of `SplitDecls` to the **Lean source code
itself**.  Instead of splitting an arbitrary module, it seeds a dependency BFS from the
*pipeline entry points* of the Lean frontend — the declarations that carry source text
through parse → header → elaborate → process — and computes the minimal closure of core
`Lean.*` declarations on which that pipeline depends.

The result is a skeleton of the Lean processor: the set of declarations you would need to
extract a from-scratch, minimal version of the pipeline.  `RequestProject/MinimalPipeline.lean`
is exactly such an extraction (the four entry points wired into one `run`).

Pipeline entry points (the seeds), and the stage each represents:

  | stage          | seed declaration                | role                          |
  |----------------|---------------------------------|-------------------------------|
  | 1 input        | `Lean.Parser.mkInputContext`    | source text → input context   |
  | 2 parse        | `Lean.Parser.parseHeader`       | input → header syntax         |
  | 2 parse        | `Lean.Parser.parseCommand`      | input → command syntax        |
  | 3 elaborate    | `Lean.Elab.processHeader`       | header → base environment      |
  | 3 elaborate    | `Lean.Elab.Command.elabCommand` | command syntax → env update    |
  | 4 frontend     | `Lean.Elab.IO.processCommands`  | drive all commands            |
  | 4 frontend     | `Lean.Elab.process`             | text → environment (driver)   |
  | 4 frontend     | `Lean.Elab.runFrontend`         | top-level entry               |

For each declaration in the closure the tool records its exact dependencies (read from the
type + value, not by regex) and the *defining module*, which it folds into a pipeline
stage:

  * `parse`    — defined in `Lean.Parser.*`
  * `frontend` — defined in `Lean.Elab.Frontend` / `Lean.Frontend.*`
  * `elab`     — defined in `Lean.Elab.*`
  * `core`     — everything else in `Lean.*` (`Environment`, `Expr`, `Syntax`, `Data`, …)

Outputs (to the configured output dir, default `./pipeline-out`):
  * `pipeline.md`   — human-readable skeleton: seed signatures, per-stage counts, the
                      key declarations of each stage.
  * `pipeline.json` — machine-readable stage histogram + seed list + closure size.
  * `dag.json`      — the dependency DAG of the whole closure (decl → in-closure deps).
  * `skeleton/Split/*.lean` — one stub file per closure declaration (imports = its deps,
                      signature in a comment), mirroring `SplitDecls`' lattice.

Usage:
  lake exe pipelineskeleton                 -- reads pipeline-config.json, else defaults
  lake exe pipelineskeleton <outputDir>
-/
import Lean

open Lean System

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

/-- Filter a dependency set down to only names in our target universe. -/
def filterDeps (deps : NameSet) (targets : NameSet) : Array Name := Id.run do
  let mut result : Array Name := #[]
  for n in deps.toList do
    if targets.contains n then result := result.push n
  return result

/-- Sanitize a Lean name into a flat module name suitable for `import`. -/
def nameToSimpleMod (n : Name) : String :=
  "Split." ++ n.toString.replace "." "_"

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

/-- The module in which a declaration is defined, if known. -/
def declModule (env : Environment) (n : Name) : Option Name :=
  match env.getModuleIdxFor? n with
  | some idx => env.header.moduleNames[idx.toNat]?
  | none => none

/-- Fold a defining module into a pipeline stage label. -/
def stageOf (mod : Option Name) : String :=
  match mod with
  | none => "core"
  | some m =>
    let s := m.toString
    if s == "Lean.Elab.Frontend" || s.startsWith "Lean.Elab.Frontend." || s.startsWith "Lean.Frontend" then
      "frontend"
    else if s == "Lean.Parser" || s.startsWith "Lean.Parser." then
      "parse"
    else if s == "Lean.Elab" || s.startsWith "Lean.Elab." then
      "elab"
    else
      "core"

/-- The four pipeline stages, in pipeline order. -/
def stageOrder : List String := ["parse", "elab", "frontend", "core"]

/-- Escape a string for embedding in JSON. -/
def jsonEsc (s : String) : String :=
  s.replace "\\" "\\\\" |>.replace "\"" "\\\""

/-- Emit a single `.lean` stub for one declaration (its imports + signature comment). -/
def emitDeclFile (env : Environment) (n : Name) (deps : Array Name) (outDir : System.FilePath) : IO Unit := do
  let relPath := (nameToSimpleMod n).replace "." "/" ++ ".lean"
  let path := outDir / relPath
  let parent := path.parent.getD outDir
  IO.FS.createDirAll parent
  let mut lines : Array String := #[]
  for d in deps do
    lines := lines.push s!"import {nameToSimpleMod d}"
  if deps.size > 0 then lines := lines.push ""
  lines := lines.push s!"-- {n} (stage: {stageOf (declModule env n)})"
  match env.find? n with
  | some (.defnInfo v) => lines := lines.push s!"-- def {n} : {v.type}"
  | some (.thmInfo v) => lines := lines.push s!"-- theorem {n} : {v.type}"
  | some (.axiomInfo v) => lines := lines.push s!"-- axiom {n} : {v.type}"
  | some (.opaqueInfo v) => lines := lines.push s!"-- opaque {n} : {v.type}"
  | some (.inductInfo v) => lines := lines.push s!"-- inductive {n} : {v.type}"
  | some (.ctorInfo v) => lines := lines.push s!"-- constructor {n} : {v.type}"
  | some (.recInfo v) => lines := lines.push s!"-- recursor {n} : {v.type}"
  | some (.quotInfo _) => lines := lines.push s!"-- quot {n}"
  | none => lines := lines.push s!"-- (not found)"
  lines := lines.push s!"-- Stub: declaration `{n}` of the Lean parser/processor skeleton."
  IO.FS.writeFile path (String.intercalate "\n" (lines.toList ++ [""]))

/-- Generate the dependency DAG as JSON: each declaration → its in-closure deps. -/
def emitDag (env : Environment) (names : Array Name) (universeSet : NameSet) (outDir : System.FilePath) : IO Unit := do
  let mut lines : Array String := #["{"]
  let mut idx := 0
  for n in names.toList do
    let deps := filterDeps (constDeps env n) universeSet
    let depsStr := deps.map (fun d => s!"\"{jsonEsc d.toString}\"") |>.toList
    let comma := if idx + 1 < names.size then "," else ""
    lines := lines.push s!"  \"{jsonEsc n.toString}\": [{String.intercalate ", " depsStr}]{comma}"
    idx := idx + 1
  lines := lines.push "}"
  IO.FS.writeFile (outDir / "dag.json") (String.intercalate "\n" lines.toList ++ "\n")

/-- The pipeline seeds: the entry points of the Lean frontend, in pipeline order. -/
def pipelineSeeds : List Name :=
  [ `Lean.Parser.mkInputContext
  , `Lean.Parser.parseHeader
  , `Lean.Parser.parseCommand
  , `Lean.Elab.processHeader
  , `Lean.Elab.Command.elabCommand
  , `Lean.Elab.IO.processCommands
  , `Lean.Elab.process
  , `Lean.Elab.runFrontend ]

/-- Parse `pipeline-config.json`: only an optional `"outputDir"` is read. -/
def parseConfig (s : String) : String :=
  match Json.parse s with
  | .error _ => "./pipeline-out"
  | .ok j => (j.getObjValAs? String "outputDir").toOption.getD "./pipeline-out"

/-- Read the output dir from CLI args, or `pipeline-config.json`, else the default. -/
def readOutDir (args : List String) : IO String := do
  match args with
  | out :: _ => return out
  | [] =>
    let configPath := System.FilePath.mk "pipeline-config.json"
    if ← configPath.pathExists then
      let content ← IO.FS.readFile configPath
      return parseConfig content
    else
      return "./pipeline-out"

/-- Render the human-readable skeleton map. -/
def renderMarkdown (env : Environment) (seeds : Array Name)
    (closureArr : Array Name) (stageCounts : Std.HashMap String Nat)
    (perStageExamples : Std.HashMap String (Array Name)) : String := Id.run do
  let mut md : Array String := #[]
  md := md.push "# Minimal Lean 4 parser/processor skeleton"
  md := md.push ""
  md := md.push s!"The dependency closure of the Lean frontend pipeline, seeded from {seeds.size} entry points,"
  md := md.push s!"contains **{closureArr.size}** core `Lean.*` declarations."
  md := md.push ""
  md := md.push "## Pipeline entry points (seeds)"
  md := md.push ""
  for n in seeds do
    match env.find? n with
    | some ci => md := md.push s!"- `{n}`  \n  : `{ci.type}`"
    | none => md := md.push s!"- `{n}`  (not found)"
  md := md.push ""
  md := md.push "## Closure size by pipeline stage"
  md := md.push ""
  md := md.push "| stage | declarations |"
  md := md.push "|-------|--------------|"
  for st in stageOrder do
    md := md.push s!"| {st} | {stageCounts.getD st 0} |"
  md := md.push s!"| **total** | **{closureArr.size}** |"
  md := md.push ""
  md := md.push "## Key declarations per stage (sample)"
  md := md.push ""
  for st in stageOrder do
    md := md.push s!"### {st}"
    let ex := perStageExamples.getD st #[]
    for n in ex do
      md := md.push s!"- `{n}`"
    md := md.push ""
  return String.intercalate "\n" md.toList ++ "\n"

/-- Main: map out and emit the minimal parser/processor skeleton. -/
def main (args : List String) : IO UInt32 := do
  let outDirStr ← readOutDir args
  let outPath : System.FilePath := System.FilePath.mk outDirStr
  IO.println s!"PipelineSkeleton: out={outDirStr}"
  initSearchPath (← findSysroot)
  let env ← importModules #[{module := `Lean}] {}
  -- The universe: every (non-internal) declaration defined in a `Lean.*` module.
  let mut univ : NameSet := {}
  for (n, _) in env.constants.map₁.toList do
    if n.isInternal || n.toString.startsWith "_" then continue
    match declModule env n with
    | some m => if m.toString == "Lean" || m.toString.startsWith "Lean." then univ := univ.insert n
    | none => pure ()
  IO.println s!"  {univ.toList.length} Lean.* declarations in universe"
  -- Keep only seeds that actually exist.
  let seeds := (pipelineSeeds.filter (fun n => (env.find? n).isSome)).toArray
  IO.println s!"  {seeds.size} pipeline seed declarations found"
  let closure := bfsClosure env seeds univ
  let closureArr := closure.toList.toArray
  IO.println s!"  {closureArr.size} declarations in pipeline closure"
  -- Stage counts + per-stage examples (prefer the seeds, then alphabetical).
  let mut stageCounts : Std.HashMap String Nat := {}
  let mut perStage : Std.HashMap String (Array Name) := {}
  let seedSet : NameSet := seeds.foldl (fun s n => s.insert n) {}
  for n in closureArr do
    let st := stageOf (declModule env n)
    stageCounts := stageCounts.insert st (stageCounts.getD st 0 + 1)
    if seedSet.contains n then
      perStage := perStage.insert st ((perStage.getD st #[]).push n)
  -- top up each stage's examples to ~10 entries
  for n in closureArr do
    let st := stageOf (declModule env n)
    let cur := perStage.getD st #[]
    if cur.size < 10 && !cur.contains n then
      perStage := perStage.insert st (cur.push n)
  IO.FS.createDirAll outPath
  -- pipeline.md
  let md := renderMarkdown env seeds closureArr stageCounts perStage
  IO.FS.writeFile (outPath / "pipeline.md") md
  -- pipeline.json
  let mut j : Array String := #["{"]
  j := j.push s!"  \"closureSize\": {closureArr.size},"
  j := j.push s!"  \"seeds\": [{String.intercalate ", " (seeds.toList.map (fun n => s!"\"{jsonEsc n.toString}\""))}],"
  j := j.push "  \"stageCounts\": {"
  let scLines := stageOrder.map (fun st => s!"    \"{st}\": {stageCounts.getD st 0}")
  j := j.push (String.intercalate ",\n" scLines)
  j := j.push "  }"
  j := j.push "}"
  IO.FS.writeFile (outPath / "pipeline.json") (String.intercalate "\n" j.toList ++ "\n")
  -- dag.json
  emitDag env closureArr closure outPath
  -- skeleton stubs
  let skelDir := outPath / "skeleton"
  IO.FS.createDirAll skelDir
  let mut count := 0
  for n in closureArr do
    let deps := filterDeps (constDeps env n) closure
    emitDeclFile env n deps skelDir
    count := count + 1
    if count % 500 == 0 then IO.println s!"  ... {count}/{closureArr.size} stubs emitted"
  IO.println s!"  pipeline.md / pipeline.json / dag.json written to {outDirStr}"
  IO.println s!"  {count} skeleton stubs written to {skelDir}"
  return 0
