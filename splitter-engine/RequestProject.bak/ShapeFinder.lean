/-
ShapeFinder.lean — group declarations by their *shape arrows* (n-grams of sizes), from
1-grams up to 71-grams, and by a Clifford-algebra blade signature.

This is the analysis companion to `RequestProject/ShapeAlgebra.lean`. It loads a Lean
environment and, entirely in memory, turns every declaration's type into a structural
**shape** (the type's `Expr` viewed as a tree), reads off its **size word** (the pre-order
list of subtree sizes — the `sizeWord` of `ShapeAlgebra`), and then groups declarations that
share the same *shape arrows*.

Concretely, for every window length `n = 1 … 71` (`ShapeAlgebra.gramProfile` sweeps the same
range) it computes each declaration's **bag of n-grams** (`ShapeAlgebra.bagNgrams`) and groups
together all declarations carrying the same bag:

  * `n = 1`  — the multiset of sizes (total-size information; cf. `SizeFinder`).
  * `n = 2`  — the **arrows** `[size₁, size₂]`, the parent→child edges.
  * `n = 3`  — the `3`-grams `[size₁, size₂, size₃]`.
  * `…`      — up to `n = 71`, longer structural chains.

It also computes, for each declaration, the **Clifford blade** of its shape: the set of sizes
occurring an odd number of times in the size word. In the Clifford algebra of shapes
(`ShapeAlgebra.shapeCliff`, generators with `eₙ * eₙ = n²` scalar), pairs of equal generators
collapse to scalars, so the surviving top-grade blade is exactly this odd-occurrence set — a
genuine, computable Clifford invariant. Declarations are grouped by equal blade too.

Outputs (to the configured output dir, default `./shape-out`):
  * `shapes.txt`  — human-readable: per-`n` table (decls carrying an n-gram, number of
                    similarity classes, largest class + sample), top arrows, blade summary.
  * `ngrams.json` — per-`n` statistics as JSON.
  * `arrows.txt`  — the most common arrows `[a,b]` across all declarations, with counts.
  * `blades.json` — histogram of Clifford blade signatures.

Usage:
  lake exe shapefinder <Module> <outputDir>
  lake exe shapefinder                       -- reads shape-config.json, else uses defaults
-/
import Lean

open Lean System

/-- The size signature of an expression: the number of leaf sub-terms when the expression is
viewed as a tree (the `Expr` realisation of `SizeSignature.size`). -/
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

/-- The **size word** of an expression: the pre-order list of subtree sizes, where each
subtree's size is its leaf count (`exprSize`). This is the `Expr` realisation of
`ShapeAlgebra.sizeWord`: the head is the total size, then the children's words in order.

Implemented in `O(#nodes)`: we append a placeholder for each node's own (head) size, recurse
into the children — which append their words right after — and then patch the placeholder with
the computed subtree size. This avoids the quadratic blow-up of repeated array concatenation
on Mathlib's long application spines. -/
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

/-- The size word of an expression (see `sizeWordAux`). -/
def exprSizeWord (e : Expr) : Nat × Array Nat :=
  let (s, w) := sizeWordAux e #[]
  (s, w)

/-- The largest gram length we sweep ("from 1 arrow up to 71-grams"). -/
def maxGram : Nat := 71

/-- The mixing seed used when summing window hashes. -/
def hashSeed : UInt64 := 0x9e3779b97f4a7c15

/-- The polynomial base for window hashing. -/
def hashBase : UInt64 := 1099511628211

/-- For a word `w`, compute a multiset hash of its **bag of n-grams** for every
`n = 1 … maxGram` at once. Returns an array of length `maxGram`; index `n-1` holds the bag
hash for window length `n` (only meaningful when `w.size ≥ n`).

The bag (multiset) hash is *order independent*: we sum the per-window hashes (wrapping
`UInt64` addition preserves multiplicity), so it depends only on which windows occur and how
often, not on their order — exactly `ShapeAlgebra.bagNgrams`. Each window hash is a rolling
polynomial hash, so all windows of a given `n` are computed in `O(w.size)`. -/
def bagHashes (w : Array Nat) : Array UInt64 := Id.run do
  let L := w.size
  let B := hashBase
  let mut res : Array UInt64 := Array.replicate maxGram 0
  for n in [1:maxGram+1] do
    let m := L + 1 - n
    if m == 0 then
      continue
    -- B^(n-1)
    let mut Bn1 : UInt64 := 1
    for _ in [0:n-1] do
      Bn1 := Bn1 * B
    -- first window's polynomial hash
    let mut h : UInt64 := 0
    for k in [0:n] do
      h := h * B + UInt64.ofNat (w[k]!)
    let mut acc : UInt64 := mixHash hashSeed h
    -- roll over the remaining windows in O(1) each
    for i in [1:m] do
      h := (h - UInt64.ofNat (w[i-1]!) * Bn1) * B + UInt64.ofNat (w[i + n - 1]!)
      acc := acc + mixHash hashSeed h
    res := res.set! (n-1) acc
  return res

/-- The **Clifford blade** of a size word: the sorted set of sizes occurring an odd number of
times. In the Clifford algebra of shapes (`eₙ * eₙ` = scalar), even repetitions collapse to
scalars, so this odd-occurrence set is the surviving top-grade blade. -/
def cliffordBlade (w : Array Nat) : Array Nat := Id.run do
  let mut parity : Std.HashMap Nat Bool := {}
  for x in w do
    parity := parity.insert x (!(parity.getD x false))
  let mut odd : Array Nat := #[]
  for (k, v) in parity.toList do
    if v then odd := odd.push k
  return odd.qsort (fun a b => a < b)

/-- Parse the shared config format (`modules`/`module` + `outputDir`). -/
def parseConfig (s : String) : List String × String :=
  match Json.parse s with
  | .error _ => ([], "./shape-out")
  | .ok j =>
    let out := (j.getObjValAs? String "outputDir").toOption.getD "./shape-out"
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

/-- Read configuration from CLI args, or `shape-config.json`, else defaults. -/
def readShapeConfig (args : List String) : IO (List String × String) := do
  let dflt : List String := ["Mathlib.Algebra.Vertex.HVertexOperator"]
  match args with
  | [] =>
    let configPath := System.FilePath.mk "shape-config.json"
    if ← configPath.pathExists then
      let content ← IO.FS.readFile configPath
      let (mods, out) := parseConfig content
      return (if mods.isEmpty then dflt else mods, out)
    else
      return (dflt, "./shape-out")
  | [m] => return ([m], "./shape-out")
  | m :: out :: _ => return ([m], out)

/-- Escape a string for embedding in JSON. -/
def jsonEsc (s : String) : String :=
  s.replace "\\" "\\\\" |>.replace "\"" "\\\""

/-- Render a small array of sizes as `[a, b, c]`. -/
def renderWord (w : Array Nat) : String :=
  "[" ++ String.intercalate ", " (w.toList.map toString) ++ "]"

/-- Main: turn every declaration's type into a shape, then group by shared n-grams (1…71)
and by Clifford blade. -/
def main (args : List String) : IO UInt32 := do
  let (rootMods, outDirStr) ← readShapeConfig args
  let outPath : System.FilePath := System.FilePath.mk outDirStr
  IO.println s!"ShapeFinder: roots={rootMods} out={outDirStr}"
  initSearchPath (← findSysroot)
  let imports := (rootMods.map (fun m => ({module := m.toName} : Import))).toArray
  let env ← importModules imports {}
  -- size word + per-n bag hashes of every non-internal declaration (hashes computed once)
  let mut words : Array (Name × Array Nat × Array UInt64) := #[]
  for (n, ci) in env.constants.map₁.toList do
    if n.isInternal || n.toString.startsWith "_" then
      continue
    let (_, w) := exprSizeWord ci.type
    let hs := bagHashes w
    words := words.push (n, w, hs)
  let total := words.size
  IO.println s!"  {total} declarations turned into shapes"
  IO.FS.createDirAll outPath
  -- arrows (2-grams) frequency across all declarations
  let mut arrowCount : Std.HashMap (Nat × Nat) Nat := {}
  for (_, w, _) in words do
    for i in [0:(w.size + 1 - 2)] do
      let key := (w[i]!, w[i+1]!)
      arrowCount := arrowCount.insert key ((arrowCount.getD key 0) + 1)
  let topArrows := (arrowCount.toList.toArray.qsort (fun a b => a.2 > b.2)).extract 0 40
  -- per-n similarity statistics (n = 1 … maxGram); each pass uses a uniquely-owned local map
  -- and the precomputed `hs[n-1]` bag hash (no recomputation).
  let mut ngramStats : Array (Nat × Nat × Nat × Nat × Name) := #[]  -- n, declsWithGram, classes, largest, sample
  -- keep example similarity groups (member lists) only for n = 2 and n = 3
  let mut groups2 : Std.HashMap UInt64 (Array Name) := {}
  let mut groups3 : Std.HashMap UInt64 (Array Name) := {}
  for n in [1:maxGram+1] do
    let mut classes : Std.HashMap UInt64 (Nat × Name) := {}
    let mut declsWithGram := 0
    for (nm, w, hs) in words do
      if w.size < n then
        continue
      declsWithGram := declsWithGram + 1
      let h := hs[n-1]!
      let (c, samp) := classes.getD h (0, nm)
      classes := classes.insert h (c + 1, samp)
      if n == 2 then
        let g := groups2.getD h #[]
        if g.size < 6 then groups2 := groups2.insert h (g.push nm)
      if n == 3 then
        let g := groups3.getD h #[]
        if g.size < 6 then groups3 := groups3.insert h (g.push nm)
    let numClasses := classes.size
    let mut largest := 0
    let mut sample : Name := Name.anonymous
    for (_, (c, samp)) in classes.toList do
      if c > largest then
        largest := c
        sample := samp
    ngramStats := ngramStats.push (n, declsWithGram, numClasses, largest, sample)
  -- Clifford blade histogram
  let mut bladeCount : Std.HashMap String (Nat × Name) := {}
  for (nm, w, _) in words do
    let b := cliffordBlade w
    let key := renderWord b
    let (c, samp) := bladeCount.getD key (0, nm)
    bladeCount := bladeCount.insert key (c + 1, samp)
  let topBlades := (bladeCount.toList.toArray.qsort (fun a b => a.2.1 > b.2.1)).extract 0 30
  -- ngrams.json
  let mut jLines : Array String := #["{"]
  jLines := jLines.push s!"  \"totalDeclarations\": {total},"
  jLines := jLines.push s!"  \"maxGram\": {maxGram},"
  jLines := jLines.push "  \"perN\": ["
  let mut jEntries : Array String := #[]
  for (n, dwg, classes, largest, sample) in ngramStats do
    jEntries := jEntries.push ("    {\"n\": " ++ toString n ++ ", \"declsWithGram\": " ++ toString dwg ++ ", \"classes\": " ++ toString classes ++ ", \"largestClass\": " ++ toString largest ++ ", \"sample\": \"" ++ jsonEsc sample.toString ++ "\"}")
  jLines := jLines.push (String.intercalate ",\n" jEntries.toList)
  jLines := jLines.push "  ]"
  jLines := jLines.push "}"
  IO.FS.writeFile (outPath / "ngrams.json") (String.intercalate "\n" jLines.toList ++ "\n")
  -- arrows.txt
  let mut aTxt : Array String := #[]
  aTxt := aTxt.push s!"# Most common arrows [size1, size2] across {total} declarations (arrow : count)"
  aTxt := aTxt.push ""
  for ((a, b), c) in topArrows.toList do
    aTxt := aTxt.push s!"  [{a}, {b}] : {c}"
  IO.FS.writeFile (outPath / "arrows.txt") (String.intercalate "\n" aTxt.toList ++ "\n")
  -- blades.json
  let mut bLines : Array String := #["{"]
  bLines := bLines.push s!"  \"totalDeclarations\": {total},"
  bLines := bLines.push s!"  \"distinctBlades\": {bladeCount.size},"
  bLines := bLines.push "  \"topBlades\": ["
  let mut bEntries : Array String := #[]
  for (key, (c, samp)) in topBlades.toList do
    bEntries := bEntries.push ("    {\"blade\": \"" ++ jsonEsc key ++ "\", \"count\": " ++ toString c ++ ", \"sample\": \"" ++ jsonEsc samp.toString ++ "\"}")
  bLines := bLines.push (String.intercalate ",\n" bEntries.toList)
  bLines := bLines.push "  ]"
  bLines := bLines.push "}"
  IO.FS.writeFile (outPath / "blades.json") (String.intercalate "\n" bLines.toList ++ "\n")
  -- shapes.txt: human-readable summary
  let mut txt : Array String := #[]
  txt := txt.push s!"# Shape arrows of {total} declarations"
  txt := txt.push "# shape = the declaration's type viewed as a tree; size word = pre-order subtree sizes."
  txt := txt.push "# Two declarations are n-similar when they share the same bag of n-grams of their size word."
  txt := txt.push ""
  txt := txt.push "## n-gram similarity classes (n : decls-with-n-gram : #classes : largest-class : sample)"
  for (n, dwg, classes, largest, sample) in ngramStats do
    txt := txt.push s!"  {n} : {dwg} : {classes} : {largest} : {sample}"
  txt := txt.push ""
  txt := txt.push "## Most common arrows [size1, size2] (arrow : count)"
  for ((a, b), c) in (topArrows.extract 0 20).toList do
    txt := txt.push s!"  [{a}, {b}] : {c}"
  txt := txt.push ""
  -- example similarity groups for arrows (n=2) and 3-grams (n=3)
  let topGroups (gm : Std.HashMap UInt64 (Array Name)) (label : String) : Array String := Id.run do
    let arr := (gm.toList.toArray.qsort (fun a b => a.2.size > b.2.size)).extract 0 5
    let mut ls : Array String := #[]
    ls := ls.push s!"## Example {label} similarity groups (declarations sharing the same bag):"
    for (_, names) in arr.toList do
      ls := ls.push s!"  - {String.intercalate ", " (names.toList.map (·.toString))}"
    ls := ls.push ""
    return ls
  txt := txt ++ topGroups groups2 "arrow (2-gram)"
  txt := txt ++ topGroups groups3 "3-gram"
  txt := txt.push "## Clifford blade signatures (odd-occurrence size set) — most common (blade : count : sample)"
  for (key, (c, samp)) in topBlades.toList do
    txt := txt.push s!"  {key} : {c} : {samp}"
  IO.FS.writeFile (outPath / "shapes.txt") (String.intercalate "\n" txt.toList ++ "\n")
  IO.println s!"  shapes.txt / ngrams.json / arrows.txt / blades.json written to {outDirStr}"
  return 0
