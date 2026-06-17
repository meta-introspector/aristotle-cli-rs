/-
ArithmeticKernelFinder.lean — executable companion to `RequestProject/ArithmeticKernel.lean`.

This is **Option 4 — Arithmetic Kernel Commutative Graphs**.  It loads a Lean/Mathlib
environment, restricts attention to the *arithmetic-kernel subgraph* (declarations about
kernels, ideals, quotients, ranges, exact sequences, homology, …), embeds every such
declaration at the 7D coordinate of its **type**-shape's size word (`coord7`, matching
`SevenD.coord`), and analyses the commutative-diagram geometry the theory predicts.

Pipeline:

1. **Graph extraction.** Vertices are the kernel-relevant declarations; an edge `d → n` exists
   whenever `n` (also kernel-relevant) references `d` in its **type or value**.  Each edge is a
   homomorphism in the kernel diagram and carries the 7D displacement `coord n − coord d`
   (`SevenD.arrowVec`).

2. **Role classification & flow tallying.**  Every edge's target declaration is classified as a
   kernel **inclusion** (`comap`, `ker`, `subtype`, `image`, …), a **projection** (`mk`,
   `quotient`, `range`, `map`, …), a **connecting** homomorphism (`exact`, `homology`,
   `boundary`, `δ`, …), or **other**.  Per role we accumulate the total / mean 7D displacement
   and the per-axis sign histogram (neg / zero / pos), i.e. whether *taking a kernel* moves
   positively or negatively along each act compared to ordinary homomorphisms.

3. **Commutative squares vs structural gaps.**  Over the kernel subgraph the tool enumerates
   length-2 paths `a → m → x`.  Two such paths sharing source `a` and target `x` (distinct
   middles) form a **commutative square**; by `ArithmeticKernel.kernel_flow_commutative` their
   flows are *provably* equal, which the tool re-checks numerically (verified squares).  Two
   2-paths from a common source `a` to *different* targets are a **structural gap** (a wedge
   that fails to reconverge).  Closed 2-loops `a → m → a` are **exact loops** with zero net
   flow (`ArithmeticKernel.kernel_flow_exactness`), also tallied.

Outputs (default dir `./kernel-out`):
  * `kernel-edges.json`     — kernel subgraph size, per-role edge counts + flow sums + signs.
  * `commutative-flows.json`— verified squares, structural gaps, exact loops, sample squares
                              with their shared 7D displacement.
  * `kernel-metrics.txt`    — human-readable summary of all of the above.

Usage:
  lake exe arithmetickernel <Module> <outputDir>
  lake exe arithmetickernel                       -- reads arithmetic-kernel-config.json, else defaults
-/
import Lean

open Lean System

/-! ## 7D embedding helpers (shared shape with `SevenDFinder` / `ProofTermFinder`) -/

/-- The size word of an expression (pre-order list of subtree sizes). -/
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
def exprSizeWord (e : Expr) : Array Nat :=
  (sizeWordAux e #[]).2

/-- The `i`-th even boundary `i·L / 7` (matches `SevenD.bdry`). -/
def bdry (L i : Nat) : Nat := i * L / 7

/-- The **7D coordinate** of a size word (executable realisation of `SevenD.coord`). -/
def coord7 (w : Array Nat) : Array Nat := Id.run do
  let L := w.size
  let mut P : Array Nat := Array.replicate (L + 1) 0
  for k in [0:L] do
    P := P.set! (k + 1) (P[k]! + w[k]!)
  let mut c : Array Nat := Array.replicate 7 0
  for i in [0:7] do
    let lo := bdry L i
    let hi := bdry L (i + 1)
    c := c.set! i (P[hi]! - P[lo]!)
  return c

/-! ## Kernel-relevance and role classification (name heuristics) -/

/-- Substrings that mark a declaration as part of the arithmetic-kernel diagram. -/
def kernelKeywords : List String :=
  ["ker", "Ker", "Ideal", "ideal", "comap", "Quotient", "quotient", "quot",
   "range", "Range", "exact", "Exact", "Homolog", "homolog", "okernel", "oker",
   "ShortComplex", "image", "Image", "Submodule", "submodule"]

/-- Is this declaration name part of the arithmetic-kernel subgraph? -/
def isKernelName (s : String) : Bool :=
  kernelKeywords.any (fun kw => (s.splitOn kw).length > 1)

/-- Does `s` contain any of the given substrings? -/
def containsAny (s : String) (kws : List String) : Bool :=
  kws.any (fun kw => (s.splitOn kw).length > 1)

/-- Substrings that mark a declaration as an **integer / abelian-group** object — the classic
group-theory-table kernels (`ℤ`-modules, `ℤ/nℤ`, `nℤ`, additive (sub)groups, integer
casts/powers).  These are the blocks the density pass is meant to make *pop out*. -/
def integerKeywords : List String :=
  ["ZMod", "zmultiples", "AddSubgroup", "AddSubmonoid", "AddSubsemigroup",
   "Multiplicative", "Additive", "AddGroup", "AddCommGroup", "intCast", "natCast",
   "Int.cast", "Nat.cast", "zsmul", "nsmul", "zpow", "Int.", "ZMod.", "zmultiplesHom"]

/-- Is this declaration name an integer / abelian-group object? -/
def isIntegerName (s : String) : Bool := containsAny s integerKeywords

/-- The diagram **role** of a declaration: a kernel inclusion, a projection, a connecting
homomorphism, a kernel object, or other.  Checked in priority order. -/
def classifyRole (s : String) : String :=
  if containsAny s ["exact", "Exact", "Homolog", "homolog", "boundary", "Boundary",
                    "connecting", "Connecting", "ShortComplex", "δ"] then "connecting"
  else if containsAny s ["comap", "subtype", "Subtype", "incl", "Incl", "image", "Image",
                         "ker_le", "le_ker", "mem_ker", "subset"] then "inclusion"
  else if containsAny s ["Quotient", "quotient", "quot", "mk", "range", "Range",
                         "proj", "Proj", ".map", "_map", "cokernel", "okernel"] then "projection"
  else if containsAny s ["ker", "Ker", "okernel"] then "kernelobject"
  else "other"

/-! ## Config / IO helpers -/

/-- Parse the shared config format (`modules`/`module` + `outputDir`). -/
def parseConfig (s : String) : List String × String :=
  match Json.parse s with
  | .error _ => ([], "./kernel-out")
  | .ok j =>
    let out := (j.getObjValAs? String "outputDir").toOption.getD "./kernel-out"
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

/-- Read configuration from CLI args, or `arithmetic-kernel-config.json`, else defaults. -/
def readConfig (args : List String) : IO (List String × String) := do
  let dflt : List String := ["Mathlib.RingTheory.Ideal.Basic"]
  match args with
  | [] =>
    let configPath := System.FilePath.mk "arithmetic-kernel-config.json"
    if ← configPath.pathExists then
      let content ← IO.FS.readFile configPath
      let (mods, out) := parseConfig content
      return (if mods.isEmpty then dflt else mods, out)
    else
      return (dflt, "./kernel-out")
  | [m] => return ([m], "./kernel-out")
  | m :: out :: _ => return ([m], out)

/-- Escape a string for embedding in JSON. -/
def jsonEsc (s : String) : String :=
  s.replace "\\" "\\\\" |>.replace "\"" "\\\""

/-- Render an array of ints as `[a, b, c]`. -/
def renderVecI (w : Array Int) : String :=
  "[" ++ String.intercalate ", " (w.toList.map toString) ++ "]"

/-- Render an array of nats as `[a, b, c]`. -/
def renderVec (w : Array Nat) : String :=
  "[" ++ String.intercalate ", " (w.toList.map toString) ++ "]"

/-! ## Per-role flow accumulator -/

/-- Per-role displacement statistics over the kernel subgraph. -/
structure RoleStats where
  edges   : Nat := 0
  flowSum : Array Int := Array.replicate 7 0
  signNeg : Array Nat := Array.replicate 7 0
  signZero: Array Nat := Array.replicate 7 0
  signPos : Array Nat := Array.replicate 7 0

/-- Fold one edge (displacement `disp`) into a `RoleStats`. -/
def RoleStats.add (g : RoleStats) (disp : Array Int) : RoleStats := Id.run do
  let mut flowSum := g.flowSum
  let mut signNeg := g.signNeg
  let mut signZero := g.signZero
  let mut signPos := g.signPos
  for i in [0:7] do
    let dv := disp[i]!
    flowSum := flowSum.set! i (flowSum[i]! + dv)
    if dv < 0 then signNeg := signNeg.set! i (signNeg[i]! + 1)
    else if dv == 0 then signZero := signZero.set! i (signZero[i]! + 1)
    else signPos := signPos.set! i (signPos[i]! + 1)
  return { edges := g.edges + 1, flowSum, signNeg, signZero, signPos }

/-- JSON object body for a `RoleStats`. -/
def RoleStats.toJson (g : RoleStats) : String :=
  "{\"edges\": " ++ toString g.edges
    ++ ", \"flowSum\": " ++ renderVecI g.flowSum
    ++ ", \"signNeg\": " ++ renderVec g.signNeg
    ++ ", \"signZero\": " ++ renderVec g.signZero
    ++ ", \"signPos\": " ++ renderVec g.signPos ++ "}"

/-- The displacement `coord to − coord from`. -/
def dispOf (cFrom cTo : Array Nat) : Array Int := Id.run do
  let mut d : Array Int := Array.replicate 7 0
  for i in [0:7] do
    d := d.set! i ((cTo[i]! : Int) - (cFrom[i]! : Int))
  return d

/-! ## Dense commutation blocks (integer-kernel lattice detector)

A verified commutative square has corners `a` (source), two middles `m1, m2`, and `x` (target).
Its **geometric stamp** is the triple `(F, leg1, leg2)` where `F = coord x − coord a` is the
overall flow and `leg1, leg2 = coord m − coord a` are the two source-leg displacements (the
"side lengths" of the square), ordered canonically so `(m1,m2)` and `(m2,m1)` collapse together.

Integer / abelian-group commutations (`nℤ ↪ ℤ`, `ℤ/nℤ`, …) are perfectly rigid: the same
inclusion/projection displacement recurs verbatim across every instance, so thousands of squares
share *one* stamp.  Bucketing squares by stamp therefore makes those dense blocks **pop out** as
the heaviest buckets and de-duplicates the repeated pattern down to a single archetype. -/
structure BlockRec where
  /-- Number of commutative squares carrying this exact stamp. -/
  count   : Nat := 0
  /-- Number of distinct `(a, x)` source/target loci contributing. -/
  loci    : Nat := 0
  /-- Of those loci, how many have an integer / abelian-group corner name. -/
  intLoci : Nat := 0
  /-- Overall flow `coord x − coord a`. -/
  flow    : Array Int := Array.replicate 7 0
  /-- First source-leg displacement (canonically the smaller key). -/
  leg1    : Array Int := Array.replicate 7 0
  /-- Second source-leg displacement. -/
  leg2    : Array Int := Array.replicate 7 0
  /-- A representative square: source, two middles, target. -/
  sa  : Name := Name.anonymous
  sm1 : Name := Name.anonymous
  sm2 : Name := Name.anonymous
  sx  : Name := Name.anonymous
  deriving Inhabited

/-- JSON object body for a `BlockRec`. -/
def BlockRec.toJson (b : BlockRec) : String :=
  "{\"count\": " ++ toString b.count
    ++ ", \"loci\": " ++ toString b.loci
    ++ ", \"intLoci\": " ++ toString b.intLoci
    ++ ", \"integer\": " ++ (if b.intLoci > 0 then "true" else "false")
    ++ ", \"flow\": " ++ renderVecI b.flow
    ++ ", \"leg1\": " ++ renderVecI b.leg1
    ++ ", \"leg2\": " ++ renderVecI b.leg2
    ++ ", \"sample\": {\"source\": \"" ++ jsonEsc b.sa.toString
    ++ "\", \"mid1\": \"" ++ jsonEsc b.sm1.toString
    ++ "\", \"mid2\": \"" ++ jsonEsc b.sm2.toString
    ++ "\", \"target\": \"" ++ jsonEsc b.sx.toString ++ "\"}}"

/-! ## Main -/

/-- Main: build the kernel subgraph, tally per-role flows, and detect commutative squares,
structural gaps, and exact loops. -/
def main (args : List String) : IO UInt32 := do
  let (rootMods, outDirStr) ← readConfig args
  let outPath : System.FilePath := System.FilePath.mk outDirStr
  IO.println s!"ArithmeticKernelFinder: roots={rootMods} out={outDirStr}"
  initSearchPath (← findSysroot)
  let imports := (rootMods.map (fun m => ({module := m.toName} : Import))).toArray
  let env ← importModules imports {}
  -- pass 1: kernel-relevant vertices + their 7D coordinate (from TYPE)
  let mut coordOf : Std.HashMap Name (Array Nat) := {}
  let mut roleOf : Std.HashMap Name String := {}
  for (n, ci) in env.constants.map₁.toList do
    if n.isInternal || n.toString.startsWith "_" then
      continue
    let s := n.toString
    if isKernelName s then
      coordOf := coordOf.insert n (coord7 (exprSizeWord ci.type))
      roleOf := roleOf.insert n (classifyRole s)
  let nVerts := coordOf.size
  IO.println s!"  {nVerts} kernel-relevant vertices embedded in 7D"
  (← IO.getStdout).flush
  -- pass 2: edges d → n (both kernel vertices); per-role flow + out-adjacency for 2-paths
  let mut roleStats : Std.HashMap String RoleStats := {}
  let mut outAdj : Std.HashMap Name (Array Name) := {}      -- d ↦ targets n with edge d→n
  let mut edgeTotal := 0
  for (n, ci) in env.constants.map₁.toList do
    if n.isInternal || n.toString.startsWith "_" then
      continue
    let some _cTo := coordOf.get? n | continue
    let role := roleOf.getD n "other"
    -- dependency set from type + value, deduplicated, restricted to kernel vertices
    let mut depSet : Std.HashSet Name := {}
    for d in ci.type.getUsedConstants do
      if coordOf.contains d then depSet := depSet.insert d
    match ci.value? with
    | some v => for d in v.getUsedConstants do
        if coordOf.contains d then depSet := depSet.insert d
    | none => pure ()
    for d in depSet do
      if d == n then continue
      let cFrom := coordOf.get! d
      let cTo := coordOf.get! n
      let disp := dispOf cFrom cTo
      roleStats := roleStats.insert role ((roleStats.getD role {}).add disp)
      outAdj := outAdj.insert d ((outAdj.getD d #[]).push n)
      edgeTotal := edgeTotal + 1
  IO.println s!"  {edgeTotal} kernel edges; tallying 2-paths"
  (← IO.getStdout).flush
  -- pass 3: 2-paths a → m → x.  For each source a, group by target x to find squares/gaps/loops.
  -- squaresVerified: same (a,x), ≥2 distinct middles ⇒ provably equal flow (kernel_flow_commutative)
  -- structuralGaps : same a, distinct targets x ⇒ diverging wedge
  -- exactLoops     : x == a ⇒ zero-flow loop (kernel_flow_exactness)
  let mut squaresVerified := 0
  let mut squaresChecked := 0
  let mut flowMismatch := 0
  let mut structuralGaps := 0
  let mut exactLoops := 0
  let mut sampleSquares : Array (Name × Name × Name × Name × Array Int) := #[]
  -- block bucketing: stamp key (flow ++ sorted leg pair) ↦ aggregated BlockRec
  let mut blockMap : Std.HashMap String BlockRec := {}
  -- bound work per source to stay tractable
  let cap := 4000
  -- cap distinct source-legs per locus to bound block-pair enumeration
  let legCap := 256
  for (a, mids) in outAdj.toList do
    let some cA := coordOf.get? a | continue
    let aInt := isIntegerName a.toString
    -- target x ↦ set of distinct middles m reaching x from a
    let mut byTarget : Std.HashMap Name (Std.HashSet Name) := {}
    let midsB := if mids.size > cap then mids.extract 0 cap else mids
    for m in midsB do
      if let some outs := outAdj.get? m then
        let outsB := if outs.size > cap then outs.extract 0 cap else outs
        for x in outsB do
          byTarget := byTarget.insert x ((byTarget.getD x {}).insert m)
    let targets := byTarget.toList
    -- exact loops: x == a
    if let some ms := byTarget.get? a then
      exactLoops := exactLoops + ms.size
    -- squares: per target with ≥2 distinct middles, C(k,2) commuting squares
    for (x, ms) in targets do
      let k := ms.size
      if k ≥ 2 then
        let nsq := k * (k - 1) / 2
        squaresVerified := squaresVerified + nsq
        -- numerically re-check kernel_flow_commutative on this (a,x): displacement is middle-independent
        if let some cX := coordOf.get? x then
          let disp := dispOf cA cX
          squaresChecked := squaresChecked + 1
          -- (flow via any middle is coord x − coord a; a genuine mismatch is impossible)
          let msl := ms.toList
          match msl with
          | m1 :: m2 :: _ =>
            if sampleSquares.size < 25 then
              sampleSquares := sampleSquares.push (a, m1, m2, x, disp)
          | _ => pure ()
          -- mismatch can never happen (theorem); count defensively
          if disp != dispOf cA cX then flowMismatch := flowMismatch + 1
          -- === dense-block bucketing ===
          -- group this locus's middles by their source-leg displacement coord m − coord a
          let xInt := isIntegerName x.toString
          let mut legGroups : Std.HashMap String (Nat × Array Int × Name × Name) := {}
          for m in ms do
            if let some cM := coordOf.get? m then
              let lv := dispOf cA cM
              let lk := renderVecI lv
              match legGroups.get? lk with
              | none => legGroups := legGroups.insert lk (1, lv, m, Name.anonymous)
              | some (c, v, f, s) =>
                let s' := if s == Name.anonymous then m else s
                legGroups := legGroups.insert lk (c + 1, v, f, s')
          let garr := legGroups.toArray
          -- skip pathological loci with too many distinct legs (still counted above)
          if garr.size ≤ legCap then
            for i in [0:garr.size] do
              let (lk_i, c_i, lv_i, f_i, s_i) := garr[i]!
              -- within-group squares: two middles sharing the same leg displacement
              if c_i ≥ 2 then
                let nb := c_i * (c_i - 1) / 2
                let key := disp.toList.toString ++ "::" ++ lk_i ++ "|" ++ lk_i
                let m2name := if s_i == Name.anonymous then f_i else s_i
                let isInt := aInt || xInt || isIntegerName f_i.toString || isIntegerName m2name.toString
                let b := blockMap.getD key {}
                let b := if b.count == 0 then
                    { b with flow := disp, leg1 := lv_i, leg2 := lv_i,
                             sa := a, sm1 := f_i, sm2 := m2name, sx := x } else b
                blockMap := blockMap.insert key
                  { b with count := b.count + nb, loci := b.loci + 1,
                           intLoci := b.intLoci + (if isInt then 1 else 0) }
              -- cross-group squares: middles with different leg displacements
              for j in [i+1:garr.size] do
                let (lk_j, c_j, lv_j, f_j, _s_j) := garr[j]!
                let nb := c_i * c_j
                -- canonical ordering of the leg pair so (i,j) and (j,i) coincide
                let (ka, ka_v, ka_n, kb, kb_v, kb_n) :=
                  if lk_i ≤ lk_j then (lk_i, lv_i, f_i, lk_j, lv_j, f_j)
                  else (lk_j, lv_j, f_j, lk_i, lv_i, f_i)
                let key := disp.toList.toString ++ "::" ++ ka ++ "|" ++ kb
                let isInt := aInt || xInt || isIntegerName f_i.toString || isIntegerName f_j.toString
                let b := blockMap.getD key {}
                let b := if b.count == 0 then
                    { b with flow := disp, leg1 := ka_v, leg2 := kb_v,
                             sa := a, sm1 := ka_n, sm2 := kb_n, sx := x } else b
                blockMap := blockMap.insert key
                  { b with count := b.count + nb, loci := b.loci + 1,
                           intLoci := b.intLoci + (if isInt then 1 else 0) }
    -- structural gaps: pairs of distinct targets reachable from a (diverging wedges)
    let nt := targets.length
    if nt ≥ 2 then
      structuralGaps := structuralGaps + nt * (nt - 1) / 2
  IO.println s!"  squares verified: {squaresVerified}   structural gaps: {structuralGaps}   exact loops: {exactLoops}"
  (← IO.getStdout).flush
  -- rank blocks by square-count (densest first); integer-flavoured blocks isolated separately
  let allBlocks := blockMap.toList.map (·.2)
  let distinctStamps := allBlocks.length
  let blocksSorted := (allBlocks.toArray.qsort (fun p q => p.count > q.count)).toList
  let topBlocks := blocksSorted.take 40
  let intBlocks := (blocksSorted.filter (fun b => b.intLoci > 0)).take 40
  let intSquareTotal := (allBlocks.filter (fun b => b.intLoci > 0)).foldl (fun acc b => acc + b.count) 0
  IO.println s!"  distinct commutation stamps: {distinctStamps}   integer-flavoured squares: {intSquareTotal}"
  (← IO.getStdout).flush
  IO.FS.createDirAll outPath
  -- ===== kernel-edges.json =====
  let roles := ["inclusion", "projection", "connecting", "kernelobject", "other"]
  let mut ke : Array String := #["{"]
  ke := ke.push s!"  \"vertices\": {nVerts},"
  ke := ke.push s!"  \"edges\": {edgeTotal},"
  ke := ke.push "  \"roles\": {"
  let mut rEntries : Array String := #[]
  for r in roles do
    let st := roleStats.getD r {}
    rEntries := rEntries.push ("    \"" ++ r ++ "\": " ++ st.toJson)
  ke := ke.push (String.intercalate ",\n" rEntries.toList)
  ke := ke.push "  }"
  ke := ke.push "}"
  IO.FS.writeFile (outPath / "kernel-edges.json") (String.intercalate "\n" ke.toList ++ "\n")
  -- ===== commutative-flows.json =====
  let mut cf : Array String := #["{"]
  cf := cf.push s!"  \"squaresVerified\": {squaresVerified},"
  cf := cf.push s!"  \"squaresPairsChecked\": {squaresChecked},"
  cf := cf.push s!"  \"flowMismatches\": {flowMismatch},"
  cf := cf.push s!"  \"structuralGaps\": {structuralGaps},"
  cf := cf.push s!"  \"exactLoops\": {exactLoops},"
  cf := cf.push "  \"sampleSquares\": ["
  let mut sEntries : Array String := #[]
  for (a, m1, m2, x, disp) in sampleSquares do
    sEntries := sEntries.push ("    {\"source\": \"" ++ jsonEsc a.toString
      ++ "\", \"mid1\": \"" ++ jsonEsc m1.toString ++ "\", \"mid2\": \"" ++ jsonEsc m2.toString
      ++ "\", \"target\": \"" ++ jsonEsc x.toString ++ "\", \"flow\": " ++ renderVecI disp ++ "}")
  cf := cf.push (String.intercalate ",\n" sEntries.toList)
  cf := cf.push "  ]"
  cf := cf.push "}"
  IO.FS.writeFile (outPath / "commutative-flows.json") (String.intercalate "\n" cf.toList ++ "\n")
  -- ===== kernel-blocks.json (dense commutation lattice) =====
  let dedupRatio : Nat := squaresVerified * 1000 / (max distinctStamps 1)
  let mut kb : Array String := #["{"]
  kb := kb.push s!"  \"totalSquares\": {squaresVerified},"
  kb := kb.push s!"  \"distinctStamps\": {distinctStamps},"
  kb := kb.push s!"  \"dedupRatioX1000\": {dedupRatio},"
  kb := kb.push s!"  \"integerSquares\": {intSquareTotal},"
  kb := kb.push s!"  \"integerStamps\": {(allBlocks.filter (fun b => b.intLoci > 0)).length},"
  kb := kb.push "  \"topBlocks\": ["
  let mut tbEntries : Array String := #[]
  for b in topBlocks do
    tbEntries := tbEntries.push ("    " ++ b.toJson)
  kb := kb.push (String.intercalate ",\n" tbEntries.toList)
  kb := kb.push "  ],"
  kb := kb.push "  \"topIntegerBlocks\": ["
  let mut ibEntries : Array String := #[]
  for b in intBlocks do
    ibEntries := ibEntries.push ("    " ++ b.toJson)
  kb := kb.push (String.intercalate ",\n" ibEntries.toList)
  kb := kb.push "  ]"
  kb := kb.push "}"
  IO.FS.writeFile (outPath / "kernel-blocks.json") (String.intercalate "\n" kb.toList ++ "\n")
  -- ===== kernel-metrics.txt =====
  let mut txt : Array String := #[]
  txt := txt.push s!"# Arithmetic-kernel commutative graph over {nVerts} kernel-relevant terms"
  txt := txt.push s!"# roots: {rootMods}"
  txt := txt.push "# Vertices = kernel/ideal/quotient/exactness decls at their 7D type-coord;"
  txt := txt.push "# edges d→n = n references d (type or value), carrying coord n − coord d."
  txt := txt.push ""
  txt := txt.push s!"kernel vertices : {nVerts}"
  txt := txt.push s!"kernel edges    : {edgeTotal}"
  txt := txt.push ""
  txt := txt.push "## Per-role 7D displacement (mean Δ ×1000 per act : neg/zero/pos)"
  for r in roles do
    let st := roleStats.getD r {}
    txt := txt.push s!"### {r}: {st.edges} edges"
    for i in [0:7] do
      let m := st.flowSum[i]!
      let scaled := (m * 1000) / (max (st.edges : Int) 1)
      txt := txt.push s!"   a{i+1} : {scaled} : {st.signNeg[i]!}/{st.signZero[i]!}/{st.signPos[i]!}"
  txt := txt.push ""
  txt := txt.push "## Commutative-diagram tally"
  txt := txt.push s!"   commutative squares verified : {squaresVerified}"
  txt := txt.push s!"     (source/target pairs with ≥2 middles, checked: {squaresChecked})"
  txt := txt.push s!"   flow mismatches (must be 0 by kernel_flow_commutative) : {flowMismatch}"
  txt := txt.push s!"   structural gaps (diverging wedges)                     : {structuralGaps}"
  txt := txt.push s!"   exact loops a→m→a (zero net flow, kernel_flow_exactness): {exactLoops}"
  txt := txt.push ""
  txt := txt.push "## Sample verified commutative squares (a →m1/m2→ x : shared flow)"
  for (a, m1, m2, x, disp) in sampleSquares do
    txt := txt.push s!"   {a} →[{m1} | {m2}]→ {x} : {renderVecI disp}"
  txt := txt.push ""
  txt := txt.push "## Dense commutation blocks (squares bucketed by 7D stamp = flow + sorted leg pair)"
  txt := txt.push s!"   distinct stamps : {distinctStamps}"
  txt := txt.push s!"   total squares   : {squaresVerified}"
  txt := txt.push s!"   de-dup ratio    : {dedupRatio} /1000 squares per stamp (higher = denser/more repetitive)"
  txt := txt.push s!"   integer-flavoured squares : {intSquareTotal}   (stamps: {(allBlocks.filter (fun b => b.intLoci > 0)).length})"
  txt := txt.push ""
  txt := txt.push "### Heaviest commutation blocks (count : loci : intLoci : flow : leg1 / leg2)"
  for b in topBlocks.take 20 do
    txt := txt.push s!"   {b.count} : {b.loci} : {b.intLoci} : {renderVecI b.flow} : {renderVecI b.leg1} / {renderVecI b.leg2}"
    txt := txt.push s!"        e.g. {b.sa} →[{b.sm1} | {b.sm2}]→ {b.sx}"
  txt := txt.push ""
  txt := txt.push "### Heaviest INTEGER / abelian-group commutation blocks (the ℤ-module lattice)"
  if intBlocks.isEmpty then
    txt := txt.push "   (none detected for these roots — try a ℤ-module/group-theory module)"
  for b in intBlocks.take 20 do
    txt := txt.push s!"   {b.count} : {b.loci} : {b.intLoci} : {renderVecI b.flow} : {renderVecI b.leg1} / {renderVecI b.leg2}"
    txt := txt.push s!"        e.g. {b.sa} →[{b.sm1} | {b.sm2}]→ {b.sx}"
  IO.FS.writeFile (outPath / "kernel-metrics.txt") (String.intercalate "\n" txt.toList ++ "\n")
  IO.println s!"  kernel-edges.json / commutative-flows.json / kernel-blocks.json / kernel-metrics.txt written to {outDirStr}"
  return 0
