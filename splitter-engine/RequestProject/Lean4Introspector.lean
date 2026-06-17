/-
Lean4Introspector.lean — a self-contained, minimal Lean 4 *scanner / introspector*.

This is the unification of the project's tool suite into **one** executable.  Where the
suite ships a separate `lake exe …` per concern — `SplitDecls` (split a module into a
one-file-per-declaration lattice), `SizeFinder` (type leaf-count), `ShapeFinder`
(size-word + Clifford blade), `DepthFinder` (tree depth + pi-arity), `FlowFinder`
(arrow/flow shape), `PipelineSkeleton` / `SevenDFinder` / `ProofTermFinder` (exact
dependency graphs) — `lean4-introspector` folds all of those passes into a single
in-memory scan of a Lean `Environment` and emits a unified, tagged, annotated split.

It depends on `import Lean` only: no Mathlib, no other file in this project.  That makes
it a drop-in tool you can point at *any* Lean codebase (corelib, this project, Mathlib)
to quickly process / prepare / compare it.

What it does, in one pass over the environment:

  * **Scan.**     Load the configured module(s) and enumerate every non-internal
                  declaration.  Optionally restrict to the exact dependency *closure* of a
                  set of seed declarations (`seeds` in the config), staying inside the
                  scanned universe — the `SplitDecls` / `PipelineSkeleton` closure.

  * **Tag.**      Each declaration gets a `kind` tag (def / theorem / axiom / inductive /
                  ctor / recursor / opaque / quot), a `stage` tag folded from its defining
                  module (parse / elab / frontend / core / other), its defining module and
                  its top-level namespace, plus boolean tags `isProp` (the statement is a
                  `Prop`) and `isFlow` (the type is a length-≥3 arrow flow, the project's
                  `Text → Lean → Reflection → Math` shape).

  * **Annotate.** Each declaration is annotated with the structural invariants the suite
                  measures: type **size** (leaf count of the type `Expr`, `SizeFinder`),
                  type **depth** (longest root-to-leaf chain, `DepthFinder`), **arity**
                  (length of the leading ∀/→ telescope, `DepthFinder`), size-**word length**
                  and **Clifford blade** (odd-occurrence size set, `ShapeFinder`), **flow
                  length** (top-level non-dependent arrows, `FlowFinder`), and the exact
                  dependency counts read from the **type** and the **value/proof term**
                  (`ProofTermFinder` / `PipelineSkeleton`).

  * **Split.**    Emit a one-file-per-declaration lattice (`SplitDecls`): each stub imports
                  exactly its in-universe dependencies and carries its tags + annotations in
                  a header comment, so changing one declaration rebuilds only its dependents.

Outputs (to the configured output dir, default `./introspect-out`):
  * `introspect.md`     — human-readable report: totals, per-kind / per-stage / per-namespace
                          histograms, size / depth / arity location statistics, top blades,
                          and the most-depended-on declarations.
  * `annotations.jsonl` — one JSON object per declaration with every tag + annotation
                          (newline-delimited JSON, friendly for `jq` / streaming / diffing).
  * `tags.json`         — the tag histograms (kind / stage / namespace) as JSON.
  * `dag.json`          — the exact dependency DAG (declaration → in-universe deps).
  * `split/Split/*.lean`— the per-declaration annotated split lattice.

Usage:
  lake exe introspector                      -- reads introspector-config.json, else defaults
  lake exe introspector <Module> <outputDir>

Config (`introspector-config.json`):
  { "modules": ["Lean"],          -- or single "module": "Lean"
    "outputDir": "./introspect-out",
    "seeds": ["Lean.Elab.runFrontend"],   -- optional: restrict to this closure
    "emitSplit": true }           -- optional: skip the per-declaration files if false
-/
import Lean

open Lean System

/-! ## Dependency extraction (exact, from the kernel — not regex) -/

/-- Collect all constant names referenced in an expression. -/
def collectRefs (e : Expr) : NameSet :=
  e.foldConsts {} fun n s => s.insert n

/-- Constants referenced in a declaration's **type**. -/
def typeRefs (env : Environment) (n : Name) : NameSet :=
  match env.find? n with
  | some ci => collectRefs ci.type
  | none => {}

/-- Constants referenced in a declaration's **value / proof term** (empty for non-definitions). -/
def valueRefs (env : Environment) (n : Name) : NameSet :=
  match env.find? n with
  | some (.defnInfo v) => collectRefs v.value
  | some (.thmInfo v)  => collectRefs v.value
  | some (.opaqueInfo v) => collectRefs v.value
  | _ => {}

/-- All dependencies of a constant (type + value). -/
def constDeps (env : Environment) (n : Name) : NameSet :=
  (typeRefs env n).union (valueRefs env n)

/-- Filter a dependency set down to only names in our universe, as a sorted array. -/
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

/-! ## Structural annotations on type expressions -/

/-- Type **size**: number of leaf sub-terms of the `Expr` viewed as a tree (`SizeFinder`). -/
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

/-- Tree **depth**: longest root-to-leaf chain, counting each branching node as one level
(`DepthFinder`). `mdata` is transparent. -/
partial def exprDepth : Expr → Nat
  | .bvar _      => 0
  | .fvar _      => 0
  | .mvar _      => 0
  | .sort _      => 0
  | .const _ _   => 0
  | .lit _       => 0
  | .app f a     => 1 + Nat.max (exprDepth f) (exprDepth a)
  | .lam _ t b _ => 1 + Nat.max (exprDepth t) (exprDepth b)
  | .forallE _ t b _ => 1 + Nat.max (exprDepth t) (exprDepth b)
  | .letE _ t v b _  => 1 + Nat.max (exprDepth v) (Nat.max (exprDepth t) (exprDepth b))
  | .mdata _ e   => exprDepth e
  | .proj _ _ e  => 1 + exprDepth e

/-- **Arity**: the length of the leading ∀/→ telescope of a type (`DepthFinder`). -/
partial def piArity : Expr → Nat
  | .forallE _ _ b _ => 1 + piArity b
  | .mdata _ e       => piArity e
  | _                => 0

/-- **Flow length**: the number of top-level *non-dependent* arrows of a type — `A → B → C`
has flow length `2` (`FlowFinder`).  A dependent `∀` (whose body mentions the bound var)
ends the flow. -/
partial def flowLength : Expr → Nat
  | .forallE _ _ b _ =>
    if b.hasLooseBVars then 0 else 1 + flowLength b
  | .mdata _ e => flowLength e
  | _          => 0

/-- The pre-order list of subtree leaf-sizes (the **size word**), in `O(#nodes)`
(`ShapeFinder`). -/
partial def sizeWordAux : Expr → Array Nat → Nat × Array Nat
  | .bvar _,    b => (1, b.push 1)
  | .fvar _,    b => (1, b.push 1)
  | .mvar _,    b => (1, b.push 1)
  | .sort _,    b => (1, b.push 1)
  | .const _ _, b => (1, b.push 1)
  | .lit _,     b => (1, b.push 1)
  | .mdata _ e, b => sizeWordAux e b
  | .proj _ _ e, b =>
    let idx := b.size
    let b := b.push 0
    let (s, b) := sizeWordAux e b
    (s, b.set! idx s)
  | .app f a, b =>
    let idx := b.size
    let b := b.push 0
    let (sf, b) := sizeWordAux f b
    let (sa, b) := sizeWordAux a b
    let s := sf + sa
    (s, b.set! idx s)
  | .lam _ t bd _, b =>
    let idx := b.size
    let b := b.push 0
    let (st, b) := sizeWordAux t b
    let (sb, b) := sizeWordAux bd b
    let s := st + sb
    (s, b.set! idx s)
  | .forallE _ t bd _, b =>
    let idx := b.size
    let b := b.push 0
    let (st, b) := sizeWordAux t b
    let (sb, b) := sizeWordAux bd b
    let s := st + sb
    (s, b.set! idx s)
  | .letE _ t v bd _, b =>
    let idx := b.size
    let b := b.push 0
    let (st, b) := sizeWordAux t b
    let (sv, b) := sizeWordAux v b
    let (sb, b) := sizeWordAux bd b
    let s := st + sv + sb
    (s, b.set! idx s)

/-- The size word of an expression. -/
def exprSizeWord (e : Expr) : Array Nat := (sizeWordAux e #[]).2

/-- The **Clifford blade** of a size word: the sorted set of sizes occurring an odd number of
times (the surviving top-grade blade, `ShapeFinder`). -/
def cliffordBlade (w : Array Nat) : Array Nat := Id.run do
  let mut parity : Std.HashMap Nat Bool := {}
  for x in w do
    parity := parity.insert x (!(parity.getD x false))
  let mut odd : Array Nat := #[]
  for (k, v) in parity.toList do
    if v then odd := odd.push k
  return odd.qsort (fun a b => a < b)

/-! ## Tagging -/

/-- The module in which a declaration is defined, if known. -/
def declModule (env : Environment) (n : Name) : Option Name :=
  match env.getModuleIdxFor? n with
  | some idx => env.header.moduleNames[idx.toNat]?
  | none => none

/-- The `kind` tag of a declaration. -/
def kindTag (env : Environment) (n : Name) : String :=
  match env.find? n with
  | some (.defnInfo _)   => "def"
  | some (.thmInfo _)    => "theorem"
  | some (.axiomInfo _)  => "axiom"
  | some (.opaqueInfo _) => "opaque"
  | some (.inductInfo _) => "inductive"
  | some (.ctorInfo _)   => "ctor"
  | some (.recInfo _)    => "recursor"
  | some (.quotInfo _)   => "quot"
  | none                 => "unknown"

/-- Fold a defining module into a coarse pipeline-style `stage` tag (`PipelineSkeleton`),
generalised so that non-`Lean.*` modules report `other`. -/
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
    else if s == "Lean" || s.startsWith "Lean." then
      "core"
    else
      "other"

/-- The top-level namespace component of a name (`Lean.Elab.foo → Lean`). -/
def topNamespace (n : Name) : String :=
  (n.toString.splitOn ".").head?.getD "<root>"

/-! ## Serialisation helpers -/

/-- Escape a string for embedding in JSON. -/
def jsonEsc (s : String) : String :=
  s.replace "\\" "\\\\" |>.replace "\"" "\\\""

/-- Render an array of naturals as a JSON array `[a, b, c]`. -/
def renderNatArr (w : Array Nat) : String :=
  "[" ++ String.intercalate ", " (w.toList.map toString) ++ "]"

/-- Sanitize a Lean name into a flat module name suitable for `import`. -/
def nameToSimpleMod (n : Name) : String :=
  "Split." ++ n.toString.replace "." "_"

/-! ## The per-declaration record -/

/-- Everything `lean4-introspector` computes for a single declaration. -/
structure DeclInfo where
  name       : Name
  kind       : String
  stage      : String
  «module»   : String
  «namespace»: String
  isProp     : Bool
  isFlow     : Bool
  size       : Nat
  depth      : Nat
  arity      : Nat
  wordLen    : Nat
  flow       : Nat
  blade      : Array Nat
  typeDeps   : Nat
  valDeps    : Nat
  deps       : Array Name   -- in-universe dependencies (for the split + DAG)

/-- Compute the full `DeclInfo` for `n` inside `universeSet`. -/
def analyze (env : Environment) (universeSet : NameSet) (n : Name) : DeclInfo := Id.run do
  let ci := env.find? n
  let ty := match ci with | some c => c.type | none => mkConst `Unit
  let word := exprSizeWord ty
  let isProp := match ci with
    | some c => c.type.isProp || (kindTag env n == "theorem")
    | none => false
  let deps := filterDeps (constDeps env n) universeSet
  { name := n
    kind := kindTag env n
    stage := stageOf (declModule env n)
    «module» := (declModule env n).map (·.toString) |>.getD "<none>"
    «namespace» := topNamespace n
    isProp := isProp
    isFlow := flowLength ty ≥ 3
    size := exprSize ty
    depth := exprDepth ty
    arity := piArity ty
    wordLen := word.size
    flow := flowLength ty
    blade := cliffordBlade word
    typeDeps := (typeRefs env n).toList.length
    valDeps := (valueRefs env n).toList.length
    deps := deps }

/-- The JSON object for one declaration (one line of `annotations.jsonl`). -/
def declInfoJson (d : DeclInfo) : String :=
  "{" ++ String.intercalate ", "
    [ s!"\"name\": \"{jsonEsc d.name.toString}\""
    , s!"\"kind\": \"{d.kind}\""
    , s!"\"stage\": \"{d.stage}\""
    , s!"\"module\": \"{jsonEsc d.module}\""
    , s!"\"namespace\": \"{jsonEsc d.namespace}\""
    , s!"\"isProp\": {d.isProp}"
    , s!"\"isFlow\": {d.isFlow}"
    , s!"\"size\": {d.size}"
    , s!"\"depth\": {d.depth}"
    , s!"\"arity\": {d.arity}"
    , s!"\"wordLen\": {d.wordLen}"
    , s!"\"flow\": {d.flow}"
    , s!"\"blade\": {renderNatArr d.blade}"
    , s!"\"typeDeps\": {d.typeDeps}"
    , s!"\"valDeps\": {d.valDeps}"
    , s!"\"deps\": [{String.intercalate ", " (d.deps.toList.map (fun x => s!"\"{jsonEsc x.toString}\""))}]"
    ] ++ "}"

/-! ## Split lattice -/

/-- Emit one annotated stub `.lean` file for declaration `d` (`SplitDecls`). -/
def emitDeclFile (env : Environment) (d : DeclInfo) (outDir : System.FilePath) : IO Unit := do
  let relPath := (nameToSimpleMod d.name).replace "." "/" ++ ".lean"
  let path := outDir / relPath
  let parent := path.parent.getD outDir
  IO.FS.createDirAll parent
  let mut lines : Array String := #[]
  for dep in d.deps do
    lines := lines.push s!"import {nameToSimpleMod dep}"
  if d.deps.size > 0 then lines := lines.push ""
  lines := lines.push s!"-- {d.name}"
  lines := lines.push s!"-- tags: kind={d.kind} stage={d.stage} namespace={d.namespace} isProp={d.isProp} isFlow={d.isFlow}"
  lines := lines.push s!"-- annot: size={d.size} depth={d.depth} arity={d.arity} wordLen={d.wordLen} flow={d.flow} blade={renderNatArr d.blade}"
  lines := lines.push s!"-- deps: type={d.typeDeps} value={d.valDeps} in-universe={d.deps.size}"
  lines := lines.push s!"-- module: {d.module}"
  match env.find? d.name with
  | some ci => lines := lines.push s!"-- {d.kind} {d.name} : {ci.type}"
  | none    => lines := lines.push s!"-- (not found)"
  lines := lines.push s!"-- Stub: declaration `{d.name}` of the introspected split lattice."
  IO.FS.writeFile path (String.intercalate "\n" (lines.toList ++ [""]))

/-- Emit the dependency DAG as JSON. -/
def emitDag (infos : Array DeclInfo) (outDir : System.FilePath) : IO Unit := do
  let mut lines : Array String := #["{"]
  let mut idx := 0
  for d in infos do
    let depsStr := d.deps.toList.map (fun x => s!"\"{jsonEsc x.toString}\"")
    let comma := if idx + 1 < infos.size then "," else ""
    lines := lines.push s!"  \"{jsonEsc d.name.toString}\": [{String.intercalate ", " depsStr}]{comma}"
    idx := idx + 1
  lines := lines.push "}"
  IO.FS.writeFile (outDir / "dag.json") (String.intercalate "\n" lines.toList ++ "\n")

/-! ## Histograms + statistics -/

/-- Increment a string-keyed histogram. -/
def bump (h : Std.HashMap String Nat) (k : String) : Std.HashMap String Nat :=
  h.insert k (h.getD k 0 + 1)

/-- A `Nat`-keyed histogram as a sorted `(value, count)` array. -/
def natHistSorted (h : Std.HashMap Nat Nat) : Array (Nat × Nat) :=
  h.toList.toArray.qsort (fun a b => a.1 < b.1)

/-- Mode / median / mean of a `Nat`-keyed histogram over `total` samples. -/
def locStats (h : Std.HashMap Nat Nat) (total : Nat) : (Nat × Nat × Nat) := Id.run do
  let sorted := natHistSorted h
  -- mode
  let mut mode := 0
  let mut modeCount := 0
  for (v, c) in sorted do
    if c > modeCount then modeCount := c; mode := v
  -- median
  let half := total / 2
  let mut acc := 0
  let mut median := 0
  for (v, c) in sorted do
    if acc ≤ half then median := v
    acc := acc + c
  -- mean (integer)
  let mut sum := 0
  for (v, c) in sorted do
    sum := sum + v * c
  let mean := if total == 0 then 0 else sum / total
  return (mode, median, mean)

/-! ## Config -/

structure Config where
  modules   : List String
  outputDir : String
  seeds     : List String
  emitSplit : Bool

/-- Parse `introspector-config.json` (all keys optional). -/
def parseConfig (s : String) : Config :=
  match Json.parse s with
  | .error _ => { modules := [], outputDir := "./introspect-out", seeds := [], emitSplit := true }
  | .ok j =>
    let out := (j.getObjValAs? String "outputDir").toOption.getD "./introspect-out"
    let strArr (key : String) : List String :=
      match j.getObjVal? key with
      | .ok arrJ =>
        match arrJ.getArr? with
        | .ok arr => arr.toList.filterMap (fun x => (x.getStr?).toOption)
        | .error _ => []
      | .error _ => []
    let modsArr := strArr "modules"
    let mods :=
      if modsArr.isEmpty then
        match (j.getObjValAs? String "module").toOption with
        | some m => [m]
        | none => []
      else modsArr
    let emitSplit := (j.getObjValAs? Bool "emitSplit").toOption.getD true
    { modules := mods, outputDir := out, seeds := strArr "seeds", emitSplit := emitSplit }

/-- Resolve configuration from CLI args, else `introspector-config.json`, else defaults. -/
def readConfig (args : List String) : IO Config := do
  let dfltMods : List String := ["Lean"]
  match args with
  | [] =>
    let configPath := System.FilePath.mk "introspector-config.json"
    if ← configPath.pathExists then
      let content ← IO.FS.readFile configPath
      let c := parseConfig content
      return { c with modules := if c.modules.isEmpty then dfltMods else c.modules }
    else
      return { modules := dfltMods, outputDir := "./introspect-out", seeds := [], emitSplit := true }
  | [m] => return { modules := [m], outputDir := "./introspect-out", seeds := [], emitSplit := true }
  | m :: out :: _ => return { modules := [m], outputDir := out, seeds := [], emitSplit := true }

/-! ## Report rendering -/

/-- Render the human-readable `introspect.md` report. -/
def renderReport (cfg : Config) (infos : Array DeclInfo)
    (kindHist stageHist nsHist : Std.HashMap String Nat)
    (sizeHist depthHist arityHist : Std.HashMap Nat Nat)
    (topBlades : Array (String × Nat × Name))
    (topDepended : Array (Name × Nat)) : String := Id.run do
  let total := infos.size
  let mut md : Array String := #[]
  md := md.push "# lean4-introspector report"
  md := md.push ""
  md := md.push s!"Scanned modules: `{String.intercalate "`, `" cfg.modules}`."
  if !cfg.seeds.isEmpty then
    md := md.push s!"Restricted to the dependency closure of: `{String.intercalate "`, `" cfg.seeds}`."
  md := md.push s!"Total declarations introspected: **{total}**."
  md := md.push ""
  let renderStrHist (title : String) (h : Std.HashMap String Nat) : Array String := Id.run do
    let arr := (h.toList.toArray.qsort (fun a b => a.2 > b.2))
    let mut ls : Array String := #[]
    ls := ls.push s!"## {title}"
    ls := ls.push ""
    ls := ls.push "| key | count |"
    ls := ls.push "|-----|-------|"
    for (k, c) in arr.toList do
      ls := ls.push s!"| `{k}` | {c} |"
    ls := ls.push ""
    return ls
  md := md ++ renderStrHist "By kind" kindHist
  md := md ++ renderStrHist "By stage" stageHist
  md := md ++ renderStrHist "By top namespace" nsHist
  -- location statistics
  let (sMode, sMed, sMean) := locStats sizeHist total
  let (dMode, dMed, dMean) := locStats depthHist total
  let (aMode, aMed, aMean) := locStats arityHist total
  md := md.push "## Structural location statistics (type Expr)"
  md := md.push ""
  md := md.push "| metric | mode | median | mean |"
  md := md.push "|--------|------|--------|------|"
  md := md.push s!"| size (leaf count) | {sMode} | {sMed} | {sMean} |"
  md := md.push s!"| depth | {dMode} | {dMed} | {dMean} |"
  md := md.push s!"| arity (pi telescope) | {aMode} | {aMed} | {aMean} |"
  md := md.push ""
  -- blades
  md := md.push "## Most common Clifford blades (odd-occurrence size set)"
  md := md.push ""
  md := md.push "| blade | count | sample |"
  md := md.push "|-------|-------|--------|"
  for (b, c, s) in topBlades.toList do
    md := md.push s!"| `{b}` | {c} | `{s}` |"
  md := md.push ""
  -- most depended on
  md := md.push "## Most depended-on declarations (in-universe in-degree)"
  md := md.push ""
  md := md.push "| declaration | in-degree |"
  md := md.push "|-------------|-----------|"
  for (n, c) in topDepended.toList do
    md := md.push s!"| `{n}` | {c} |"
  md := md.push ""
  return String.intercalate "\n" md.toList ++ "\n"

/-! ## Main -/

/-- Main: scan, tag, annotate, split. -/
def main (args : List String) : IO UInt32 := do
  let cfg ← readConfig args
  let outPath : System.FilePath := System.FilePath.mk cfg.outputDir
  IO.println s!"lean4-introspector: modules={cfg.modules} out={cfg.outputDir}"
  initSearchPath (← findSysroot)
  let imports := (cfg.modules.map (fun m => ({module := m.toName} : Import))).toArray
  let env ← importModules imports {}
  -- Universe: every non-internal declaration in the scanned environment.
  let mut univ : NameSet := {}
  let mut allArr : Array Name := #[]
  for (n, _) in env.constants.map₁.toList do
    if n.isInternal || n.toString.startsWith "_" then continue
    univ := univ.insert n
    allArr := allArr.push n
  IO.println s!"  {allArr.size} declarations in scanned universe"
  -- Optionally restrict to a seed closure.
  let targets : Array Name ←
    if cfg.seeds.isEmpty then
      pure allArr
    else
      let seeds := (cfg.seeds.map (·.toName)).filter (fun n => (env.find? n).isSome) |>.toArray
      IO.println s!"  {seeds.size} seeds found; computing closure"
      let closure := bfsClosure env seeds univ
      -- narrow the universe to the closure so deps/DAG stay inside it
      pure (closure.toList.toArray)
  let targetSet : NameSet := targets.foldl (fun s n => s.insert n) {}
  IO.println s!"  {targets.size} declarations targeted"
  -- Analyze.
  let mut infos : Array DeclInfo := #[]
  let mut kindHist : Std.HashMap String Nat := {}
  let mut stageHist : Std.HashMap String Nat := {}
  let mut nsHist : Std.HashMap String Nat := {}
  let mut sizeHist : Std.HashMap Nat Nat := {}
  let mut depthHist : Std.HashMap Nat Nat := {}
  let mut arityHist : Std.HashMap Nat Nat := {}
  let mut bladeHist : Std.HashMap String (Nat × Name) := {}
  let mut inDeg : Std.HashMap Name Nat := {}
  let mut count := 0
  for n in targets do
    let d := analyze env targetSet n
    infos := infos.push d
    kindHist := bump kindHist d.kind
    stageHist := bump stageHist d.stage
    nsHist := bump nsHist d.namespace
    sizeHist := sizeHist.insert d.size (sizeHist.getD d.size 0 + 1)
    depthHist := depthHist.insert d.depth (depthHist.getD d.depth 0 + 1)
    arityHist := arityHist.insert d.arity (arityHist.getD d.arity 0 + 1)
    let bk := renderNatArr d.blade
    let (bc, bs) := bladeHist.getD bk (0, d.name)
    bladeHist := bladeHist.insert bk (bc + 1, bs)
    for dep in d.deps do
      inDeg := inDeg.insert dep (inDeg.getD dep 0 + 1)
    count := count + 1
    if count % 2000 == 0 then IO.println s!"  ... analyzed {count}/{targets.size}"
  IO.println s!"  {infos.size} declarations analyzed"
  IO.FS.createDirAll outPath
  -- annotations.jsonl
  let jsonl := String.intercalate "\n" (infos.toList.map declInfoJson)
  IO.FS.writeFile (outPath / "annotations.jsonl") (jsonl ++ "\n")
  -- tags.json
  let strHistJson (h : Std.HashMap String Nat) : String :=
    let arr := h.toList.toArray.qsort (fun a b => a.2 > b.2)
    "{" ++ String.intercalate ", " (arr.toList.map (fun (k, c) => s!"\"{jsonEsc k}\": {c}")) ++ "}"
  let tagsJson := String.intercalate "\n"
    [ "{"
    , s!"  \"total\": {infos.size},"
    , s!"  \"byKind\": {strHistJson kindHist},"
    , s!"  \"byStage\": {strHistJson stageHist},"
    , s!"  \"byNamespace\": {strHistJson nsHist}"
    , "}" ]
  IO.FS.writeFile (outPath / "tags.json") (tagsJson ++ "\n")
  -- dag.json
  emitDag infos outPath
  -- top blades + top depended-on for the report
  let topBlades := ((bladeHist.toList.toArray.qsort (fun a b => a.2.1 > b.2.1)).extract 0 25).map
    (fun (k, c, s) => (k, c, s))
  let topDepended := (inDeg.toList.toArray.qsort (fun a b => a.2 > b.2)).extract 0 30
  let report := renderReport cfg infos kindHist stageHist nsHist sizeHist depthHist arityHist topBlades topDepended
  IO.FS.writeFile (outPath / "introspect.md") report
  IO.println s!"  introspect.md / annotations.jsonl / tags.json / dag.json written to {cfg.outputDir}"
  -- split lattice
  if cfg.emitSplit then
    let splitDir := outPath / "split"
    IO.FS.createDirAll splitDir
    let mut sc := 0
    for d in infos do
      emitDeclFile env d splitDir
      sc := sc + 1
      if sc % 2000 == 0 then IO.println s!"  ... emitted {sc}/{infos.size} split files"
    IO.println s!"  {sc} split files written to {splitDir}"
  else
    IO.println s!"  split emission skipped (emitSplit=false)"
  return 0
