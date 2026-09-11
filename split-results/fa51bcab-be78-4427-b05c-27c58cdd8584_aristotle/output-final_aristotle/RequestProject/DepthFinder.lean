/-
DepthFinder.lean — the "why 7?" investigation.

The modulus-resonance sweep (`SemanticDupFinder`) found, on the full `import Mathlib`
closure with an unbiased sample, that the library's cross-axis size periodicity is the
**prime ℤ₇**, not the Bott clock ℤ₈ and not the local ℤ₁₃ of the vertex-operator module.
That left a genuine open question: *why 7?*

This tool tests the most concrete of the proposed explanations empirically, by looking at
the actual structure of every declaration's type expression rather than at residues:

  * **Hypothesis D — "7 is the typical nesting depth."**  Most complex types bottom out
    at ~7 nested constructors.  We measure the **tree depth** of each declaration's type
    `Expr` (the longest chain of `app`/binder/`proj`/`let` nodes from the root to a leaf).

  * **Hypothesis A — "7 is the typical arity."**  Most declarations are 7-ary.  We measure
    the **pi-arity** of each type (the length of its leading `∀`/`→` telescope), i.e. how
    many explicit-or-implicit arguments the declaration takes.

For each metric we emit the full histogram together with the location statistics that decide
the question: the **mode** (most common value), the **median**, and the **mean**.  If 7 (or
the band 6–8 around it) is where the distribution concentrates, hypotheses D/A are supported;
if the mass sits elsewhere, "why 7" is *not* explained by raw depth/arity and the resonance
is an arithmetic (residue) phenomenon, not a structural one.

This reuses the suite's environment-loading and config conventions (`SizeFinder` etc.).

Outputs (to the configured output dir, default `./depth-out`):
  * `depth.txt`  — human-readable: both histograms with mode / median / mean and a verdict.
  * `depth.json` — both histograms and the summary statistics as JSON.

Usage:
  lake exe depthfinder <Module> <outputDir>
  lake exe depthfinder                       -- reads depth-config.json, else uses defaults
-/
import Lean

open Lean System

/-- Tree **depth** of an expression: the longest root-to-leaf chain, counting `app`,
binder, `let` and `proj` nodes as one level each and atoms as depth `0`.  `mdata` is
transparent. -/
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
  | .letE _ t v b _  => 1 + Nat.max (exprDepth t) (Nat.max (exprDepth v) (exprDepth b))
  | .mdata _ e   => exprDepth e
  | .proj _ _ e  => 1 + exprDepth e

/-- **Pi-arity** of a type: the length of its leading `∀`/`→` telescope, i.e. how many
arguments the declaration takes.  `mdata` is transparent. -/
partial def piArity : Expr → Nat
  | .forallE _ _ b _ => 1 + piArity b
  | .mdata _ e       => piArity e
  | _                => 0

/-- Parse the shared config format (`modules`/`module` + `outputDir`). -/
def parseConfig (s : String) : List String × String :=
  match Json.parse s with
  | .error _ => ([], "./depth-out")
  | .ok j =>
    let out := (j.getObjValAs? String "outputDir").toOption.getD "./depth-out"
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

/-- Read configuration from CLI args, or `depth-config.json`, else defaults. -/
def readDepthConfig (args : List String) : IO (List String × String) := do
  let dflt : List String := ["Mathlib.Algebra.Vertex.HVertexOperator"]
  match args with
  | [] =>
    let configPath := System.FilePath.mk "depth-config.json"
    if ← configPath.pathExists then
      let content ← IO.FS.readFile configPath
      let (mods, out) := parseConfig content
      return (if mods.isEmpty then dflt else mods, out)
    else
      return (dflt, "./depth-out")
  | [m] => return ([m], "./depth-out")
  | m :: out :: _ => return ([m], out)

/-- The mode (value with the largest count) of a histogram given as `value → count`. -/
def histMode (hist : Std.HashMap Nat Nat) : Nat × Nat :=
  hist.toList.foldl (fun (best : Nat × Nat) (v, c) =>
    if c > best.2 then (v, c) else best) (0, 0)

/-- The median value of a histogram (lower median of the multiset it represents). -/
def histMedian (hist : Std.HashMap Nat Nat) (total : Nat) : Nat := Id.run do
  if total == 0 then return 0
  let sorted := (hist.toList.toArray).qsort (fun a b => a.1 < b.1)
  let half := (total + 1) / 2
  let mut acc := 0
  for (v, c) in sorted do
    acc := acc + c
    if acc ≥ half then return v
  return 0

/-- The mean of a histogram, returned as a permille (×1000) integer to avoid floats. -/
def histMeanPermille (hist : Std.HashMap Nat Nat) (total : Nat) : Nat :=
  if total == 0 then 0
  else
    let weighted := hist.toList.foldl (fun acc (v, c) => acc + v * c) 0
    (weighted * 1000) / total

/-- Render a histogram (sorted ascending by value) as JSON object entries. -/
def histJson (hist : Std.HashMap Nat Nat) : String :=
  let sorted := (hist.toList.toArray).qsort (fun a b => a.1 < b.1)
  String.intercalate ",\n" (sorted.toList.map (fun (v, c) => s!"    \"{v}\": {c}"))

/-- Render a histogram as aligned `value : count (pct‰)` text lines. -/
def histText (hist : Std.HashMap Nat Nat) (total : Nat) : List String :=
  let sorted := (hist.toList.toArray).qsort (fun a b => a.1 < b.1)
  sorted.toList.map (fun (v, c) =>
    let permille := if total == 0 then 0 else (c * 1000) / total
    s!"  {v} : {c}  ({permille}‰)")

/-- Main: compute the depth and arity distribution of every declaration's type. -/
def main (args : List String) : IO UInt32 := do
  let (rootMods, outDirStr) ← readDepthConfig args
  let outPath : System.FilePath := System.FilePath.mk outDirStr
  IO.println s!"DepthFinder: roots={rootMods} out={outDirStr}"
  initSearchPath (← findSysroot)
  let imports := (rootMods.map (fun m => ({module := m.toName} : Import))).toArray
  let env ← importModules imports {}
  let mut depthHist : Std.HashMap Nat Nat := {}
  let mut arityHist : Std.HashMap Nat Nat := {}
  let mut total : Nat := 0
  for (n, ci) in env.constants.map₁.toList do
    if n.isInternal || n.toString.startsWith "_" then
      continue
    let d := exprDepth ci.type
    let a := piArity ci.type
    depthHist := depthHist.insert d ((depthHist.getD d 0) + 1)
    arityHist := arityHist.insert a ((arityHist.getD a 0) + 1)
    total := total + 1
  IO.println s!"  {total} declarations scanned"
  let (depthMode, depthModeCnt) := histMode depthHist
  let depthMed := histMedian depthHist total
  let depthMean := histMeanPermille depthHist total
  let (arityMode, arityModeCnt) := histMode arityHist
  let arityMed := histMedian arityHist total
  let arityMean := histMeanPermille arityHist total
  IO.FS.createDirAll outPath
  -- JSON
  let mut j : Array String := #["{"]
  j := j.push s!"  \"totalDeclarations\": {total},"
  j := j.push ("  \"depth\": { \"mode\": " ++ toString depthMode ++ ", \"modeCount\": " ++ toString depthModeCnt ++ ", \"median\": " ++ toString depthMed ++ ", \"meanPermille\": " ++ toString depthMean ++ " },")
  j := j.push ("  \"arity\": { \"mode\": " ++ toString arityMode ++ ", \"modeCount\": " ++ toString arityModeCnt ++ ", \"median\": " ++ toString arityMed ++ ", \"meanPermille\": " ++ toString arityMean ++ " },")
  j := j.push "  \"depthHistogram\": {"
  j := j.push (histJson depthHist)
  j := j.push "  },"
  j := j.push "  \"arityHistogram\": {"
  j := j.push (histJson arityHist)
  j := j.push "  }"
  j := j.push "}"
  IO.FS.writeFile (outPath / "depth.json") (String.intercalate "\n" j.toList ++ "\n")
  -- Text
  let inBand7 (mode med : Nat) : String :=
    if (6 ≤ mode && mode ≤ 8) || (6 ≤ med && med ≤ 8) then
      "→ concentrates in the 6–8 band: consistent with a structural origin of ℤ₇."
    else
      "→ does NOT concentrate near 7: this metric does not explain the ℤ₇ resonance."
  let mut t : Array String := #[]
  t := t.push s!"# The \"why 7?\" investigation — type-expression depth and arity of {total} declarations"
  t := t.push ""
  t := t.push s!"roots = {rootMods}"
  t := t.push ""
  t := t.push "## Hypothesis D — tree depth of the type Expr (nested constructors)"
  t := t.push s!"  mode   = {depthMode}  (count {depthModeCnt})"
  t := t.push s!"  median = {depthMed}"
  t := t.push s!"  mean   = {depthMean}‰  (i.e. {depthMean / 1000}.{depthMean % 1000})"
  t := t.push s!"  {inBand7 depthMode depthMed}"
  t := t.push ""
  t := t.push "  depth : count (share)"
  t := t ++ (histText depthHist total).toArray
  t := t.push ""
  t := t.push "## Hypothesis A — pi-arity of the type (length of the ∀/→ telescope)"
  t := t.push s!"  mode   = {arityMode}  (count {arityModeCnt})"
  t := t.push s!"  median = {arityMed}"
  t := t.push s!"  mean   = {arityMean}‰  (i.e. {arityMean / 1000}.{arityMean % 1000})"
  t := t.push s!"  {inBand7 arityMode arityMed}"
  t := t.push ""
  t := t.push "  arity : count (share)"
  t := t ++ (histText arityHist total).toArray
  t := t.push ""
  IO.FS.writeFile (outPath / "depth.txt") (String.intercalate "\n" t.toList ++ "\n")
  IO.println s!"  depth.txt / depth.json written to {outDirStr}"
  IO.println s!"  depth: mode={depthMode} median={depthMed} mean={depthMean}‰"
  IO.println s!"  arity: mode={arityMode} median={arityMed} mean={arityMean}‰"
  return 0
