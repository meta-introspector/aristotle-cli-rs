/-
SemanticDupFinder.lean — find *near*-duplicate declarations (not just exact ones) and
measure whether Mathlib's declaration space is *coherent* or *random* — now with a
**modulus sweep** that tests *which* arithmetic lens (which modulus `m`) and *which*
similarity component resonate best.

This is the "second pass" companion to `RequestProject/DupFinder.lean`.  Where `DupFinder`
finds **exact** duplicates (α-equal statements, identical type+body), this tool finds
**semantic near-duplicates**: declarations that are not identical but are structurally and
semantically *close*, using two cheap, robust similarity metrics, with the crystal cell
(`size mod m`) acting as the organising lens.

For every theorem / definition we read off:
  * its **size signature** `exprSize type` (identical to `SizeFinder` / `ArrowFinder` /
    `WordCloudFinder`).  The crystal **cell** is the residue `size mod m`; historically
    `m = 8` (the Altland–Zirnbauer / Bott clock), but this tool now sweeps a *family* of
    moduli;
  * its **symbol bag** — the components of its own name plus the final components of the
    constants referenced in its *type* (identical to `WordCloudFinder.declSymbols`);
  * its **dependency cover** — the set of in-universe constants its type/value reference
    (identical to `DupFinder.constDeps`, the cover used by `Coverage`).

Two declarations are compared with:
  * **symbol Jaccard**  = |sym(A) ∩ sym(B)| / |sym(A) ∪ sym(B)|   (semantic proximity), and
  * **cover  Jaccard**  = |cov(A) ∩ cov(B)| / |cov(A) ∪ cov(B)|   (structural proximity).

To avoid the O(n²) blow-up we generate candidate pairs from an inverted index on symbols
(only declarations that *share* a symbol are ever compared), skipping ultra-common symbols
and capping the candidate budget.

### The coherence question, swept over moduli (8 = 2³ → 24 = 2³·3, odd primes, …)

The project's central question — *is there coherence, or is Mathlib random?* — is answered
empirically.  If the library were random, a near-duplicate pair would land in the **same**
crystal cell only by chance, at the baseline rate `Σ_c p_c²` (p_c = fraction of decls in
cell c, which depends on the modulus `m`).  If the residue lens is *meaningful*,
near-duplicate pairs land in the same cell **far above** that baseline; the ratio is the
**coherence lift**.

We now compute that lift for a **sweep of moduli** `m ∈ {3,5,7,8,11,13,16,17,19,23,24,29}`
(the original `8 = 2³`, the composite `24 = 2³·3`, and the odd primes / `±2` buffers the
theory predicts may resonate) and, *independently*, for three **component pipelines**:

  * **A — symbol** : pairs near in symbol Jaccard only      (pure semantic proximity);
  * **B — cover**  : pairs near in cover  Jaccard only      (pure structural proximity);
  * **C — hybrid** : pairs near in *both* metrics            (the joint lens).

The resulting **resonance matrix** (lift per modulus per component) tells us which lens the
library's *semantic* structure resonates with versus its *structural* structure.

Outputs (to the configured output dir, default `./semanticdup-out`):
  * `semanticdup.txt`  — human-readable: the coherence verdict, the resonance matrix, and the
    top near-duplicate pairs.
  * `semanticdup.json` — structured: stats, the full resonance sweep, and the near-dup list.

Usage:
  lake exe semanticdup <Module> <outputDir>
  lake exe semanticdup                       -- reads semanticdup-config.json, else defaults

The swept moduli may be overridden with a `"moduli": [..]` array in `semanticdup-config.json`.
-/
import Lean

open Lean System

/-! ## Shape / cell helpers (shared with the other finders) -/

/-- The size signature of an expression: number of leaf sub-terms of the type viewed as a
tree.  Identical to `ArrowFinder.exprSize` and the `Expr` realisation of `SizeSignature.size`. -/
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

/-- Cartan labels of the eight real Altland–Zirnbauer classes, in Bott-clock order.  Only
meaningful for the historical `m = 8` lens. -/
def realCartanLabels : Array String :=
  #["AI", "BDI", "D", "DIII", "AII", "CII", "C", "CI"]

/-- The crystal cell index of a size signature `N` under modulus `m` (`getCell N m = N % m`).
Generalises the historical `cellIndex N = N % 8`. -/
def getCell (N : Nat) (m : Nat) : Nat := if m == 0 then 0 else N % m

/-- The default sweep of moduli: the historical `8 = 2³` Bott clock, the composite
`24 = 2³·3`, the small odd primes, and the `2^k` / `±2` buffers the theory probes. -/
def defaultModuli : Array Nat := #[3, 5, 7, 8, 11, 13, 16, 17, 19, 23, 24, 29]

/-! ## Baseline / coherence helpers (parameterised by an arbitrary modulus) -/

/-- The random baseline same-cell rate ×1000 for an arbitrary modulus, given the per-cell
declaration counts `cellCounts` (length = `m`) and the total `total`:
`Σ_c p_c²` with `p_c = cellCounts[c] / total`, scaled to permille.  This is the probability
that two *independently* chosen declarations land in the same cell. -/
def baselineSameCell1000 (cellCounts : Array Nat) (total : Nat) : Nat :=
  if total == 0 then 0 else
    cellCounts.foldl (fun acc c => acc + (c * c * 1000) / (total * total)) 0

/-- Coherence lift ×1000: how many times above the random baseline the observed same-cell
rate sits.  `1000` means "exactly chance"; `> 1000` means the lens carries real structure. -/
def coherenceLift1000 (observed1000 baseline1000 : Nat) : Nat :=
  if baseline1000 == 0 then 0 else (observed1000 * 1000) / baseline1000

/-- **Detrended resonance index** ×1000.  The raw `coherenceLift` is confounded by the
modulus: a finer lens (larger `m`) has a smaller random baseline, so its lift inflates with
`m` even with no genuine structure.  This index removes that trend by measuring how far the
observed same-cell rate sits on the segment from *pure chance* (`baseline`) to *perfect
size-equality* (`1000‰`):

    R = (observed − baseline) / (1000 − baseline)   (clamped to `[0,1]`, ×1000).

`R` is **scale-invariant**: under the null of "near-dups have independent sizes" it is `0`
for every modulus, and under "near-dups always have equal size" it is `1000` for every
modulus.  A modulus genuinely *resonates* with a component iff its `R` rises **above** the
smooth trend of its neighbours (a local peak), not merely because `m` is large. -/
def resonanceIndex1000 (observed1000 baseline1000 : Nat) : Nat :=
  if observed1000 ≤ baseline1000 then 0
  else if baseline1000 ≥ 1000 then 0
  else ((observed1000 - baseline1000) * 1000) / (1000 - baseline1000)

/-! ## Dependency / symbol helpers (shared with `DupFinder` and `WordCloudFinder`) -/

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

/-- Is a string component a usable "symbol"?  Drop empties, single chars, pure numbers and
anonymous parts. -/
def keepToken (s : String) : Bool :=
  s.length ≥ 2 && !(s.all Char.isDigit) && !(s.startsWith "_")

/-- The string components of a `Name` (skipping numeric / anonymous parts). -/
def nameStrTokens (n : Name) : List String :=
  n.components.filterMap fun c =>
    match c with
    | .str _ s => if keepToken s then some s else none
    | _ => none

/-- The "symbol" tokens of one declaration: the components of its own name together with the
final components of the constants referenced in its *type*.  Identical to
`WordCloudFinder.declSymbols`. -/
def declSymbols (n : Name) (ci : ConstantInfo) : Array String := Id.run do
  let mut seen : Std.HashSet String := {}
  let mut out : Array String := #[]
  for t in nameStrTokens n do
    if !seen.contains t then seen := seen.insert t; out := out.push t
  for d in ci.type.getUsedConstants do
    match d with
    | .str _ s => if keepToken s && !seen.contains s then seen := seen.insert s; out := out.push s
    | _ => pure ()
  return out

/-! ## Config (shared format with the other finders) -/

/-- Parse the shared config format (`modules`/`module` + `outputDir`, plus optional
`moduli` sweep override). -/
def parseConfig (s : String) : List String × String × Option (Array Nat) :=
  match Json.parse s with
  | .error _ => ([], "./semanticdup-out", none)
  | .ok j =>
    let out := (j.getObjValAs? String "outputDir").toOption.getD "./semanticdup-out"
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
    let moduli : Option (Array Nat) :=
      match j.getObjVal? "moduli" with
      | .ok arrJ =>
        match arrJ.getArr? with
        | .ok arr =>
          let ms := arr.toList.filterMap (fun x => (x.getNat?).toOption)
          if ms.isEmpty then none else some ms.toArray
        | .error _ => none
      | .error _ => none
    (mods, out, moduli)

/-- Read configuration from CLI args, or `semanticdup-config.json`, else defaults. -/
def readSemConfig (args : List String) : IO (List String × String × Array Nat) := do
  let dflt : List String := ["Mathlib.Algebra.Vertex.HVertexOperator"]
  match args with
  | [] =>
    let configPath := System.FilePath.mk "semanticdup-config.json"
    if ← configPath.pathExists then
      let content ← IO.FS.readFile configPath
      let (mods, out, moduli) := parseConfig content
      return (if mods.isEmpty then dflt else mods, out, moduli.getD defaultModuli)
    else
      return (dflt, "./semanticdup-out", defaultModuli)
  | [m] => return ([m], "./semanticdup-out", defaultModuli)
  | m :: out :: _ => return ([m], out, defaultModuli)

/-- Escape a string for embedding in JSON. -/
def jsonEsc (s : String) : String :=
  s.replace "\\" "\\\\" |>.replace "\"" "\\\""

/-! ## Similarity -/

/-- Jaccard similarity ×1000 (integer) between two *deduplicated* collections, given as an
array (for size + iteration) and a `HashSet` (for membership). -/
def jaccard1000 {α : Type} [BEq α] [Hashable α]
    (aArr : Array α) (aSet : Std.HashSet α) (bArr : Array α) (bSet : Std.HashSet α) : Nat :=
  let (smallArr, bigSet) := if aArr.size ≤ bArr.size then (aArr, bSet) else (bArr, aSet)
  let inter := smallArr.foldl (fun acc x => if bigSet.contains x then acc + 1 else acc) 0
  let union := aArr.size + bArr.size - inter
  if union == 0 then 0 else (inter * 1000) / union

/-- One scanned declaration with everything we need to compare it to others.  We store the
raw `size` (so cells can be computed for *any* modulus on the fly) rather than a fixed cell. -/
structure SemItem where
  name : Name
  isThm : Bool
  size : Nat
  symArr : Array String
  symSet : Std.HashSet String
  covArr : Array Name
  covSet : Std.HashSet Name
deriving Inhabited

/-- The three component pipelines we evaluate independently. -/
inductive Pipeline where
  | symbol | cover | hybrid
deriving Inhabited, BEq

def pipelineLabel : Pipeline → String
  | .symbol => "A symbol"
  | .cover  => "B cover "
  | .hybrid => "C hybrid"

/-- A clean, space-free pipeline name (for JSON). -/
def pipelineName : Pipeline → String
  | .symbol => "symbol"
  | .cover  => "cover"
  | .hybrid => "hybrid"

/-- Right-justify `s` to width `w` with spaces. -/
def padLeft (s : String) (w : Nat) : String :=
  String.ofList (List.replicate (max 0 (w - s.length)) ' ') ++ s

def allPipelines : Array Pipeline := #[Pipeline.symbol, Pipeline.cover, Pipeline.hybrid]

/-! ## Main -/

def main (args : List String) : IO UInt32 := do
  let (rootMods, outDirStr, moduli) ← readSemConfig args
  let outPath : System.FilePath := System.FilePath.mk outDirStr
  IO.println s!"SemanticDupFinder: roots={rootMods} out={outDirStr} moduli={moduli.toList}"
  initSearchPath (← findSysroot)
  let imports := (rootMods.map (fun m => ({module := m.toName} : Import))).toArray
  let env ← importModules imports {}
  -- universe = all non-internal declarations
  let mut univSet : NameSet := {}
  for (n, _) in env.constants.map₁.toList do
    if !n.isInternal && !n.toString.startsWith "_" then
      univSet := univSet.insert n
  IO.println s!"  {univSet.toList.length} declarations in environment (universe)"
  -- tunables
  let maxPostings  : Nat := 400        -- skip symbols shared by more than this many decls
  let maxCandidates : Nat := 4000000   -- cap on candidate pairs
  let nearThr : Nat := 600             -- Jaccard ×1000 threshold for "near-duplicate"
  let reportTopN : Nat := 300          -- how many near-dup pairs to write out
  let nMod := moduli.size
  -- build the item table (theorems + defs only)
  let mut items : Array SemItem := #[]
  for (n, ci) in env.constants.map₁.toList do
    if n.isInternal || n.toString.startsWith "_" then continue
    match ci with
    | .thmInfo _ | .defnInfo _ =>
      let isThm := match ci with | .thmInfo _ => true | _ => false
      let size := exprSize ci.type
      let symArr := declSymbols n ci
      -- need at least 2 symbols for a meaningful comparison
      if symArr.size < 2 then continue
      let symSet : Std.HashSet String := symArr.foldl (fun s x => s.insert x) {}
      -- dependency cover, restricted to the universe
      let depsNS := constDeps env n
      let mut covArr : Array Name := #[]
      let mut covSet : Std.HashSet Name := {}
      for d in depsNS.toList do
        if univSet.contains d && !covSet.contains d then
          covSet := covSet.insert d
          covArr := covArr.push d
      items := items.push ⟨n, isThm, size, symArr, symSet, covArr, covSet⟩
    | _ => pure ()
  let nItems := items.size
  let totalDecls := nItems
  IO.println s!"  {nItems} theorems + defs eligible for comparison"
  -- per-modulus cell counts (for baselines) — one pass over items
  let mut cellCountsPerMod : Array (Array Nat) := moduli.map (fun m => Array.replicate m 0)
  for it in items do
    for mi in [0:nMod] do
      let m := moduli[mi]!
      let c := getCell it.size m
      let cur := cellCountsPerMod[mi]!
      cellCountsPerMod := cellCountsPerMod.set! mi (cur.set! c (cur[c]! + 1))
  -- baselines per modulus (×1000)
  let baselinePerMod : Array Nat := (List.range nMod).toArray.map (fun mi =>
    baselineSameCell1000 cellCountsPerMod[mi]! totalDecls)
  -- inverted index: symbol → list of item indices
  let mut postings : Std.HashMap String (Array Nat) := {}
  for i in [0:nItems] do
    for t in items[i]!.symArr do
      postings := postings.insert t ((postings.getD t #[]).push i)
  -- candidate pair generation (only pairs that share a not-too-common symbol).
  -- To avoid the *selection bias* of greedily filling a budget symbol-by-symbol (which
  -- would over-sample whichever symbol neighbourhoods happen to be visited first in the
  -- hash-map iteration order), we instead take an UNBIASED, uniform stride sample over the
  -- entire candidate space: first count the total number of (symbol-shared) pairs, then
  -- keep every `step`-th pair so the retained ≈ `maxCandidates` are spread evenly across
  -- *all* symbol neighbourhoods regardless of their position in the iteration order.
  let eligible : Array (Array Nat) :=
    (postings.toList.filterMap (fun (_, lst) =>
      if lst.size ≥ 2 && lst.size ≤ maxPostings then some lst else none)).toArray
  let totalPairs : Nat := eligible.foldl (fun acc lst => acc + lst.size * (lst.size - 1) / 2) 0
  let step : Nat := if totalPairs ≤ maxCandidates then 1 else totalPairs / maxCandidates
  IO.println s!"  {totalPairs} total symbol-shared pairs; stride sampling every {step} (target ≤ {maxCandidates})"
  let mut candidates : Std.HashSet UInt64 := {}
  let mut gidx : Nat := 0
  for lst in eligible do
    for a in [0:lst.size] do
      for b in [a+1:lst.size] do
        if gidx % step == 0 then
          let i := lst[a]!
          let j := lst[b]!
          let (lo, hi) := if i ≤ j then (i, j) else (j, i)
          let key : UInt64 := (UInt64.ofNat lo <<< 32) ||| UInt64.ofNat hi
          candidates := candidates.insert key
        gidx := gidx + 1
  let budgetHit := step != 1
  IO.println s!"  {candidates.size} candidate pairs sampled (uniform stride; subsampled: {budgetHit})"
  -- resonance accumulators:
  --   pipelineNear[p]            = number of near-dup pairs in pipeline p (modulus-independent)
  --   pipelineSame[p][mi]        = how many of those land in the same cell under moduli[mi]
  let mut pipelineNear : Array Nat := Array.replicate allPipelines.size 0
  let mut pipelineSame : Array (Array Nat) :=
    Array.replicate allPipelines.size (Array.replicate nMod 0)
  -- detailed near-dup pairs for the report (using the historical symbol pipeline)
  let mut nearPairs : Array (Nat × Nat × Nat × Nat) := #[]  -- (i, j, symJ, covJ)
  let mut candCount : Nat := 0
  for key in candidates.toList do
    let i := (key >>> 32).toNat
    let j := (key &&& 0xffffffff).toNat
    let A := items[i]!
    let B := items[j]!
    let symJ := jaccard1000 A.symArr A.symSet B.symArr B.symSet
    let covJ := jaccard1000 A.covArr A.covSet B.covArr B.covSet
    candCount := candCount + 1
    let nearSym := symJ ≥ nearThr
    let nearCov := covJ ≥ nearThr
    let nearHyb := nearSym && nearCov
    if nearSym then
      nearPairs := nearPairs.push (i, j, symJ, covJ)
    -- only do the (modulus × pipeline) work for pairs that are near in *some* pipeline
    if nearSym || nearCov then
      -- which pipelines does this pair belong to?
      let inPipe : Pipeline → Bool := fun
        | .symbol => nearSym
        | .cover  => nearCov
        | .hybrid => nearHyb
      for pi in [0:allPipelines.size] do
        let p := allPipelines[pi]!
        if inPipe p then
          pipelineNear := pipelineNear.set! pi (pipelineNear[pi]! + 1)
          for mi in [0:nMod] do
            let m := moduli[mi]!
            if getCell A.size m == getCell B.size m then
              let row := pipelineSame[pi]!
              pipelineSame := pipelineSame.set! pi (row.set! mi (row[mi]! + 1))
  IO.println s!"  candidates evaluated: {candCount}"
  -- ===== resonance matrices: raw lift and detrended index per (pipeline, modulus) =====
  -- observed same-cell rate ‰ of pipeline `pi` under modulus index `mi`
  let obsAt : Nat → Nat → Nat := fun pi mi =>
    let near := pipelineNear[pi]!
    let same := (pipelineSame[pi]!)[mi]!
    if near == 0 then 0 else (same * 1000) / near
  -- raw coherence lift ×1000 (confounded by modulus size)
  let liftAt : Nat → Nat → Nat := fun pi mi =>
    coherenceLift1000 (obsAt pi mi) baselinePerMod[mi]!
  -- detrended, scale-invariant resonance index ×1000
  let resAt : Nat → Nat → Nat := fun pi mi =>
    resonanceIndex1000 (obsAt pi mi) baselinePerMod[mi]!
  -- find, per pipeline, the best-resonating modulus by the *detrended* index
  let bestModFor : Nat → (Nat × Nat) := fun pi => Id.run do
    let mut bestMi := 0
    let mut bestRes := 0
    for mi in [0:nMod] do
      let r := resAt pi mi
      if r > bestRes then bestRes := r; bestMi := mi
    return (bestMi, bestRes)
  -- console preview
  for pi in [0:allPipelines.size] do
    let (bmi, bres) := bestModFor pi
    IO.println s!"  [{pipelineLabel allPipelines[pi]!}] near={pipelineNear[pi]!}  best modulus (detrended) m={moduli[bmi]!} R={bres}/1000"
  -- sort near pairs by symbol Jaccard descending for the detailed report
  let sortedNear := nearPairs.qsort (fun a b => a.2.2.1 > b.2.2.1)
  let shown := sortedNear.extract 0 (min reportTopN sortedNear.size)
  -- index of m=8 in the sweep (for the historical headline numbers), if present
  let idx8 := (moduli.findIdx? (· == 8)).getD 0
  IO.FS.createDirAll outPath
  -- ===== semanticdup.txt =====
  let mut txt : Array String := #[]
  txt := txt.push "# Semantic near-duplicate scan of a Lean environment — modulus resonance sweep"
  txt := txt.push s!"# universe: {totalDecls} comparable theorems+defs"
  txt := txt.push s!"# candidate pairs evaluated: {candCount}   (near threshold: {nearThr}‰ Jaccard)"
  txt := txt.push s!"# swept moduli: {moduli.toList}"
  txt := txt.push ""
  txt := txt.push "## Coherence verdict at the historical m=8 (2³, Bott clock), symbol pipeline"
  let near8 := pipelineNear[0]!
  let same8 := (pipelineSame[0]!)[idx8]!
  let obs8 := if near8 == 0 then 0 else (same8 * 1000) / near8
  txt := txt.push s!"  near-duplicate pairs (sym J≥{nearThr}‰) : {near8}"
  txt := txt.push s!"  baseline same-cell rate (Σ p_c²)     : {baselinePerMod[idx8]!}‰"
  txt := txt.push s!"  observed near-dup same-cell rate     : {obs8}‰"
  txt := txt.push s!"  COHERENCE LIFT (near/baseline)       : ×{coherenceLift1000 obs8 baselinePerMod[idx8]!}/1000"
  txt := txt.push ""
  txt := txt.push "  Reading: a lift well above 1000/1000 means near-duplicates land in the same cell"
  txt := txt.push "  far more often than chance — the residue lens carries real semantic information."
  txt := txt.push ""
  let header := "  pipeline   |" ++ String.intercalate "" (moduli.toList.map (fun m =>
    padLeft (toString m) 6))
  let rule := "  " ++ String.ofList (List.replicate 70 '-')
  txt := txt.push "## RAW COHERENCE LIFT ×1000 per component pipeline per modulus"
  txt := txt.push "  (CONFOUNDED by modulus size: a finer lens has a smaller baseline, so lift inflates"
  txt := txt.push "   with m even with no genuine structure — read the detrended matrix below instead)"
  txt := txt.push header
  txt := txt.push rule
  for pi in [0:allPipelines.size] do
    let cells := (List.range nMod).map (fun mi => padLeft (toString (liftAt pi mi)) 6)
    txt := txt.push ("  " ++ pipelineLabel allPipelines[pi]! ++ " |" ++ String.intercalate "" cells)
  txt := txt.push ""
  txt := txt.push "## DETRENDED RESONANCE INDEX ×1000  R = (observed − baseline)/(1000 − baseline)"
  txt := txt.push "  (scale-invariant: 0 = pure chance for every m, 1000 = near-dups always equal size."
  txt := txt.push "   A genuine resonance is a LOCAL PEAK above the trend of neighbouring moduli.)"
  txt := txt.push header
  txt := txt.push rule
  for pi in [0:allPipelines.size] do
    let cells := (List.range nMod).map (fun mi => padLeft (toString (resAt pi mi)) 6)
    txt := txt.push ("  " ++ pipelineLabel allPipelines[pi]! ++ " |" ++ String.intercalate "" cells)
  txt := txt.push ""
  txt := txt.push "## OBSERVED same-cell rate ‰ per component pipeline per modulus"
  txt := txt.push header
  txt := txt.push rule
  for pi in [0:allPipelines.size] do
    let cells := (List.range nMod).map (fun mi => padLeft (toString (obsAt pi mi)) 6)
    txt := txt.push ("  " ++ pipelineLabel allPipelines[pi]! ++ " |" ++ String.intercalate "" cells)
  txt := txt.push ""
  txt := txt.push "## Per-pipeline best-resonating modulus (by the detrended index R)"
  for pi in [0:allPipelines.size] do
    let (bmi, bres) := bestModFor pi
    txt := txt.push s!"  [{pipelineLabel allPipelines[pi]!}]  near-pairs={pipelineNear[pi]!}  →  best m={moduli[bmi]!}  (R ×{bres}/1000)"
  txt := txt.push ""
  -- ===== interpretation: the *discovered* symmetries = strict local peaks of R =====
  -- An interior modulus is a discovered resonance iff its detrended index strictly exceeds
  -- BOTH neighbours in the sweep (so it is a genuine peak, not just a large-m artefact).
  let localPeaks : Nat → Array Nat := fun pi => Id.run do
    let mut peaks : Array Nat := #[]
    for mi in [1:nMod-1] do
      let r := resAt pi mi
      if r > resAt pi (mi-1) && r > resAt pi (mi+1) then
        peaks := peaks.push mi
    return peaks
  txt := txt.push "## DISCOVERED SYMMETRIES — strict local peaks of the detrended index R"
  txt := txt.push "  (a modulus that beats BOTH of its sweep neighbours: a genuine resonance of the"
  txt := txt.push "   data, not an artefact of large m. These are the natural periodicities the"
  txt := txt.push "   size distribution actually carries, per component.)"
  for pi in [0:allPipelines.size] do
    let peaks := localPeaks pi
    let peakStr := if peaks.isEmpty then "(none — monotone, no interior resonance)"
      else String.intercalate ", " (peaks.toList.map (fun mi => s!"m={moduli[mi]!} (R {resAt pi mi})"))
    txt := txt.push s!"  [{pipelineLabel allPipelines[pi]!}]  peaks: {peakStr}"
  txt := txt.push ""
  txt := txt.push "## Baselines and near-pair populations per modulus"
  for mi in [0:nMod] do
    txt := txt.push s!"  m={moduli[mi]!} : baseline {baselinePerMod[mi]!}‰"
  txt := txt.push ""
  txt := txt.push s!"## Top {shown.size} near-duplicate pairs (symbol Jaccard ‰, cover Jaccard ‰)"
  for (i, j, symJ, covJ) in shown do
    let A := items[i]!
    let B := items[j]!
    txt := txt.push s!"  [sym {symJ}‰ | cov {covJ}‰ | size {A.size}↔{B.size}]"
    txt := txt.push s!"      {A.name}"
    txt := txt.push s!"      {B.name}"
  IO.FS.writeFile (outPath / "semanticdup.txt") (String.intercalate "\n" txt.toList ++ "\n")
  -- ===== semanticdup.json =====
  let mut j : Array String := #["{"]
  j := j.push s!"  \"universe\": {totalDecls},"
  j := j.push s!"  \"comparableItems\": {nItems},"
  j := j.push s!"  \"nearThreshold\": {nearThr},"
  j := j.push s!"  \"candidatePairs\": {candCount},"
  j := j.push s!"  \"moduli\": [{String.intercalate ", " (moduli.toList.map toString)}],"
  -- baselines
  j := j.push "  \"baselines\": ["
  let baseEntries := (List.range nMod).map (fun mi =>
    "    {\"modulus\": " ++ toString moduli[mi]! ++ ", \"baselineSameCellRate\": " ++
      toString baselinePerMod[mi]! ++ "}")
  j := j.push (String.intercalate ",\n" baseEntries)
  j := j.push "  ],"
  -- resonance matrix
  j := j.push "  \"resonance\": ["
  let resEntries := (List.range allPipelines.size).map (fun pi =>
    let (bmi, bres) := bestModFor pi
    let peakStr := String.intercalate ", " ((localPeaks pi).toList.map (fun mi => toString moduli[mi]!))
    let perMod := (List.range nMod).map (fun mi =>
      let near := pipelineNear[pi]!
      let same := (pipelineSame[pi]!)[mi]!
      let obs := if near == 0 then 0 else (same * 1000) / near
      "        {\"modulus\": " ++ toString moduli[mi]! ++ ", \"sameCellRate\": " ++ toString obs ++
        ", \"lift\": " ++ toString (liftAt pi mi) ++ ", \"resonanceIndex\": " ++
        toString (resAt pi mi) ++ "}")
    String.intercalate "\n"
      [ "    {",
        s!"      \"pipeline\": \"{pipelineName allPipelines[pi]!}\",",
        s!"      \"nearPairs\": {pipelineNear[pi]!},",
        s!"      \"bestModulus\": {moduli[bmi]!},",
        s!"      \"bestResonanceIndex\": {bres},",
        s!"      \"discoveredSymmetries\": [{peakStr}],",
        "      \"perModulus\": [",
        String.intercalate ",\n" perMod,
        "      ]",
        "    }" ])
  j := j.push (String.intercalate ",\n" resEntries)
  j := j.push "  ],"
  -- near-dup pairs
  j := j.push "  \"nearDuplicates\": ["
  let pairEntries := shown.toList.map (fun (i, j', symJ, covJ) =>
    let A := items[i]!
    let B := items[j']!
    String.intercalate "\n"
      [ "    {",
        s!"      \"a\": \"{jsonEsc A.name.toString}\",",
        s!"      \"b\": \"{jsonEsc B.name.toString}\",",
        s!"      \"symbolJaccard\": {symJ},",
        s!"      \"coverJaccard\": {covJ},",
        s!"      \"sizeA\": {A.size},",
        s!"      \"sizeB\": {B.size}",
        "    }" ])
  j := j.push (String.intercalate ",\n" pairEntries)
  j := j.push "  ]"
  j := j.push "}"
  IO.FS.writeFile (outPath / "semanticdup.json") (String.intercalate "\n" j.toList ++ "\n")
  IO.println s!"  semanticdup.txt / semanticdup.json written to {outDirStr}"
  return 0
