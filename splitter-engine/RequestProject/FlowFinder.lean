/-
FlowFinder.lean — find reusable *flows* in the Lean source and the libraries.

This is the executable companion to `RequestProject/SelfModelFlow.lean`.  That file models
the project's own pipeline

      Text  ──parse──▶  Lean  ──reflect──▶  Reflection  ──model──▶  Math

as a first-class object (`SelfModelFlow.Pipeline`) — a chain of three composable arrows —
and proves flows form a category in which one flow can be *reused* inside another.

This tool realises the request literally: it scans a real Lean 4 corelib + Mathlib
environment for **declarations that already have the shape of a flow**, so the system can
*self-improve by consuming related code*.

A declaration of type `A₀ → A₁ → ⋯ → Aₖ` (top-level, non-dependent arrows) is a **flow of
length `k`**: it carries data through `k` composable stages, just like `Pipeline.parse`,
`Pipeline.reflect`, `Pipeline.model` compose into `Pipeline.run`.  The tool:

  * counts every declaration's flow length (the number of top-level `→`);
  * builds a histogram of flow lengths over the whole environment;
  * isolates the **pipeline-shaped** declarations — flows of length `≥ 3`, the arity of the
    project's `Text → Lean → Reflection → Math` flow — as concrete reuse candidates;
  * highlights flows that *thread text/syntax/environment* (their stage types mention
    `String`, `Syntax`, `Expr`, `Name`, `Environment`, …) — these are Lean's own
    `Text → Lean → Reflection → …` flows, the closest matches to reuse.

Outputs (to the configured output dir, default `./flow-out`):
  * `flows.json` — flow-length histogram, totals, and example pipeline-shaped declarations.
  * `flows.txt`  — a human-readable rendering of the same data.

Usage:
  lake exe flowfinder <Module> <outputDir>
  lake exe flowfinder                       -- reads flow-config.json, else defaults
-/
import Lean

open Lean System

/-- The flow stages of a type: the list of top-level *non-dependent* domain types of the
curried `A₀ → A₁ → ⋯ → Aₖ`, followed by the final codomain.  The number of arrows is one
less than the length of this list. -/
partial def flowStages : Expr → List Expr
  | .forallE _ t b _ =>
    -- only count non-dependent arrows (`b` does not use the bound variable)
    if b.hasLooseBVars then [.forallE `_ t b .default]  -- dependent: stop, treat as a single stage
    else t :: flowStages b
  | e => [e]

/-- The flow length of a type: the number of top-level composable (non-dependent) arrows. -/
def flowLength (e : Expr) : Nat := (flowStages e).length - 1

/-- The head constant names appearing anywhere in an expression (used to recognise the
text/syntax/reflection vocabulary of Lean's own flows). -/
def headConsts (e : Expr) : Array Name := e.getUsedConstants

/-- Vocabulary marking a stage as part of Lean's `Text → Lean → Reflection → …` flow. -/
def reflectionVocab : Array String :=
  #["String", "Substring", "Syntax", "Lean.Syntax", "Expr", "Lean.Expr",
    "Name", "Lean.Name", "Environment", "Lean.Environment", "Format", "MessageData",
    "ConstantInfo", "Declaration", "TSyntax"]

/-- Does a type's vocabulary intersect the reflection vocabulary? -/
def threadsReflection (e : Expr) : Bool := Id.run do
  let cs := headConsts e
  for c in cs do
    let s := c.toString
    for v in reflectionVocab do
      if s == v || (s.splitOn "." |>.getLast!) == v then
        return true
  return false

/-- Parse the shared config format (`modules`/`module` + `outputDir`). -/
def parseConfig (s : String) : List String × String :=
  match Json.parse s with
  | .error _ => ([], "./flow-out")
  | .ok j =>
    let out := (j.getObjValAs? String "outputDir").toOption.getD "./flow-out"
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

/-- Read configuration from CLI args, or `flow-config.json`, else defaults. -/
def readFlowConfig (args : List String) : IO (List String × String) := do
  let dflt : List String := ["Mathlib"]
  match args with
  | [] =>
    let configPath := System.FilePath.mk "flow-config.json"
    if ← configPath.pathExists then
      let content ← IO.FS.readFile configPath
      let (mods, out) := parseConfig content
      return (if mods.isEmpty then dflt else mods, out)
    else
      return (dflt, "./flow-out")
  | [m] => return ([m], "./flow-out")
  | m :: out :: _ => return ([m], out)

/-- Escape a string for embedding in JSON. -/
def jsonEsc (s : String) : String :=
  s.replace "\\" "\\\\" |>.replace "\"" "\\\""

/-- Main: scan declarations and catalog reusable flows. -/
def main (args : List String) : IO UInt32 := do
  let (rootMods, outDirStr) ← readFlowConfig args
  let outPath : System.FilePath := System.FilePath.mk outDirStr
  IO.println s!"FlowFinder: roots={rootMods} out={outDirStr}"
  initSearchPath (← findSysroot)
  let imports := (rootMods.map (fun m => ({module := m.toName} : Import))).toArray
  let env ← importModules imports {}
  -- histogram of flow lengths (capped bucket 0..12, with 12 meaning ≥ 12)
  let cap := 12
  let mut hist : Array Nat := Array.replicate (cap + 1) 0
  let mut total : Nat := 0
  let mut pipelineCount : Nat := 0     -- flows of length ≥ 3
  let mut reflectionFlowCount : Nat := 0
  -- example pipeline-shaped (length ≥ 3) declarations that thread reflection vocab
  let mut examples : Array (Name × Nat) := #[]
  for (n, ci) in env.constants.map₁.toList do
    if n.isInternal || n.toString.startsWith "_" then
      continue
    total := total + 1
    let len := flowLength ci.type
    let bucket := if len > cap then cap else len
    hist := hist.set! bucket (hist[bucket]! + 1)
    if len ≥ 3 then
      pipelineCount := pipelineCount + 1
      if threadsReflection ci.type then
        reflectionFlowCount := reflectionFlowCount + 1
        if examples.size < 40 then
          examples := examples.push (n, len)
  IO.println s!"  {total} declarations scanned"
  IO.println s!"  {pipelineCount} pipeline-shaped flows (length ≥ 3)"
  IO.println s!"  {reflectionFlowCount} of those thread Text/Lean/Reflection vocabulary"
  IO.FS.createDirAll outPath
  -- ===== flows.txt =====
  let mut txt : Array String := #[]
  txt := txt.push "# Reusable flows found in the Lean source + libraries"
  txt := txt.push s!"# {total} declarations scanned."
  txt := txt.push s!"# A flow of length k is a type A0 -> A1 -> ... -> Ak (k composable arrows)."
  txt := txt.push s!"# Pipeline-shaped flows (length >= 3, the arity of Text -> Lean -> Reflection -> Math): {pipelineCount}"
  txt := txt.push s!"# ... of which thread Text/Syntax/Expr/Name/Environment vocabulary: {reflectionFlowCount}"
  txt := txt.push ""
  txt := txt.push "## Flow-length histogram (length : count)"
  for k in List.range (cap + 1) do
    let label := if k == cap then s!">={cap}" else toString k
    txt := txt.push s!"   {label} : {hist[k]!}"
  txt := txt.push ""
  txt := txt.push "## Example reflection-threading pipeline-shaped flows (reuse candidates)"
  for (n, len) in examples do
    txt := txt.push s!"  - (len {len}) {n}"
  IO.FS.writeFile (outPath / "flows.txt") (String.intercalate "\n" txt.toList ++ "\n")
  -- ===== flows.json =====
  let mut j : Array String := #["{"]
  j := j.push s!"  \"totalDeclarations\": {total},"
  j := j.push s!"  \"pipelineShapedFlows\": {pipelineCount},"
  j := j.push s!"  \"reflectionThreadingFlows\": {reflectionFlowCount},"
  j := j.push s!"  \"flowLengthHistogram\": [{String.intercalate ", " ((List.range (cap+1)).map (fun k => toString hist[k]!))}],"
  j := j.push "  \"examples\": ["
  let exLines := examples.toList.map (fun (n, len) =>
    s!"    [\"{jsonEsc n.toString}\", {len}]")
  j := j.push (String.intercalate ",\n" exLines)
  j := j.push "  ]"
  j := j.push "}"
  IO.FS.writeFile (outPath / "flows.json") (String.intercalate "\n" j.toList ++ "\n")
  IO.println s!"  flows.txt / flows.json written to {outDirStr}"
  return 0
