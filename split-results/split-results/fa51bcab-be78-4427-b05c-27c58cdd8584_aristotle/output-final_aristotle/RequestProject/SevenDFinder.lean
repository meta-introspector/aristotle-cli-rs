/-
SevenDFinder.lean — embed the Lean/Mathlib term-relation graph into the 7D act-space.

This is the executable companion to `RequestProject/SevenDEmbedding.lean`.  It takes the 7D
space as the *primary ontology*: each term (declaration) is mapped to the seven act-sizes of
its type-shape's size word,

  `t ↦ (a₁, a₂, a₃, a₄, a₅, a₆, a₇) ∈ ℕ⁷`   (`SevenD.coord`),

and that vector **is** the term's coordinate — no projection, no CRT, no Bott shadow.

The tool then:

1. **Extracts the size word** of every declaration's type (`exprSizeWord`).
2. **Computes the SevenAct decomposition** = the canonical even 7-split of the word.
3. **Assigns the 7D coordinate** (`coord`, matching `SevenD.coord`).
4. **Places each vertex** at its coordinate.
5. **Draws an arrow** for each dependency relation `d → n` (n references d), with 7D
   displacement `coord n − coord d` (`SevenD.arrowVec`).
6. **Clusters** the terms by 7D proximity (exact-coordinate cells — `SevenD.SameCell`).
7. **Detects flows** = the average per-axis displacement of the arrows (gradient along acts).

It also builds a **map / periodic table**: each term is classified by its *dominant act*
(`argmax` of its seven coordinates — the "group" / column, one of seven) and its *size period*
(`⌊log₂(total+1)⌋` — the "period" / row), giving a 2D periodic table of the library.

Faithfulness (`SevenD.coord_sum`) is re-checked numerically: the seven act-sizes must sum to
the word's total mass for every declaration.

Outputs (to the configured output dir, default `./sevend-out`):
  * `embedding.txt`  — human-readable: totals, faithfulness check, per-axis stats, dominant-act
                       histogram, top 7D cells, flow vector, sample coordinates & arrows, map.
  * `coords.json`    — per-axis statistics, a sample of coordinates, and the cell histogram head.
  * `clusters.json`  — the largest 7D cells (exact coordinate) with sizes and member samples.
  * `edges.json`     — arrow-vector stats: total arrows, mean displacement (flow), per-axis
                       sign histogram, top displacement vectors, sample edges.
  * `map.json`       — the 2D periodic table (size period × dominant act) as a count grid.

Usage:
  lake exe sevendfinder <Module> <outputDir>
  lake exe sevendfinder                       -- reads sevend-config.json, else defaults
-/
import Lean

open Lean System

/-- The size word of an expression, computed in `O(#nodes)` (pre-order list of subtree sizes,
the head of each node being its total leaf count). Same construction as `ShapeFinder`. -/
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

/-- The `i`-th even boundary `i·L / 7` of a length-`L` word (matches `SevenD.bdry`). -/
def bdry (L i : Nat) : Nat := i * L / 7

/-- The **7D coordinate** of a size word `w`: the seven act-sizes, where act `i` carries the
sum of `w` over the slice `[bdry i, bdry (i+1))`.  This is the executable realisation of
`SevenD.coord`. -/
def coord7 (w : Array Nat) : Array Nat := Id.run do
  let L := w.size
  -- prefix sums P[k] = sum of first k entries
  let mut P : Array Nat := Array.replicate (L + 1) 0
  for k in [0:L] do
    P := P.set! (k + 1) (P[k]! + w[k]!)
  let mut c : Array Nat := Array.replicate 7 0
  for i in [0:7] do
    let lo := bdry L i
    let hi := bdry L (i + 1)
    c := c.set! i (P[hi]! - P[lo]!)
  return c

/-- The index (0-based) of the dominant (largest) act of a coordinate; ties go to the earliest
act.  The "group" / column of the periodic table (one of seven). -/
def dominantAct (c : Array Nat) : Nat := Id.run do
  let mut best := 0
  let mut bestVal := c[0]!
  for i in [1:7] do
    if c[i]! > bestVal then
      bestVal := c[i]!
      best := i
  return best

/-- `⌊log₂(n+1)⌋`, the "size period" / row of the periodic table. -/
def sizePeriod (n : Nat) : Nat := Id.run do
  let mut p := 0
  let mut m := n + 1
  while m > 1 do
    m := m / 2
    p := p + 1
  return p

/-- The constants referenced in a declaration's **type** (its statement) — the term-relation
edges of the graph: `d → n` whenever `n`'s type mentions `d`.  We read relations off types
(statements) rather than proof values: this is the clean, scalable "term references term"
graph (proof terms are astronomically large and would not change the geometry of statements). -/
def constDepNames (ci : ConstantInfo) : Array Name :=
  ci.type.getUsedConstants

/-- Parse the shared config format (`modules`/`module` + `outputDir`). -/
def parseConfig (s : String) : List String × String :=
  match Json.parse s with
  | .error _ => ([], "./sevend-out")
  | .ok j =>
    let out := (j.getObjValAs? String "outputDir").toOption.getD "./sevend-out"
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

/-- Read configuration from CLI args, or `sevend-config.json`, else defaults. -/
def readConfig (args : List String) : IO (List String × String) := do
  let dflt : List String := ["Mathlib.Algebra.Vertex.HVertexOperator"]
  match args with
  | [] =>
    let configPath := System.FilePath.mk "sevend-config.json"
    if ← configPath.pathExists then
      let content ← IO.FS.readFile configPath
      let (mods, out) := parseConfig content
      return (if mods.isEmpty then dflt else mods, out)
    else
      return (dflt, "./sevend-out")
  | [m] => return ([m], "./sevend-out")
  | m :: out :: _ => return ([m], out)

/-- Escape a string for embedding in JSON. -/
def jsonEsc (s : String) : String :=
  s.replace "\\" "\\\\" |>.replace "\"" "\\\""

/-- Linear top-`k` selection over a `HashMap` by a count projection on the value, folding
directly over the map (so we never materialise the whole, possibly million-element,
collection as a list/array — important for memory at Mathlib scale). -/
def topKMap {κ ν : Type} [BEq κ] [Hashable κ] [Inhabited κ] [Inhabited ν]
    (m : Std.HashMap κ ν) (cnt : ν → Nat) (k : Nat) : Array (κ × ν) :=
  m.fold (init := #[]) fun buf key val =>
    if buf.size < k then
      (buf.push (key, val)).qsort (fun a b => cnt a.2 > cnt b.2)
    else if cnt val > cnt buf[buf.size - 1]!.2 then
      ((buf.pop).push (key, val)).qsort (fun a b => cnt a.2 > cnt b.2)
    else buf

/-- Render an array of nats as `[a, b, c]`. -/
def renderVec (w : Array Nat) : String :=
  "[" ++ String.intercalate ", " (w.toList.map toString) ++ "]"

/-- Render an array of ints as `[a, b, c]`. -/
def renderVecI (w : Array Int) : String :=
  "[" ++ String.intercalate ", " (w.toList.map toString) ++ "]"

/-- Pad a string on the right to width `w`. -/
def padR (s : String) (w : Nat) : String :=
  if s.length >= w then s else s ++ String.ofList (List.replicate (w - s.length) ' ')

/-- Pad a string on the left to width `w`. -/
def padL (s : String) (w : Nat) : String :=
  if s.length >= w then s else String.ofList (List.replicate (w - s.length) ' ') ++ s

/-- Main: embed every declaration in 7D, embed the dependency graph, cluster, build the map. -/
def main (args : List String) : IO UInt32 := do
  let (rootMods, outDirStr) ← readConfig args
  let outPath : System.FilePath := System.FilePath.mk outDirStr
  IO.println s!"SevenDFinder: roots={rootMods} out={outDirStr}"
  initSearchPath (← findSysroot)
  let imports := (rootMods.map (fun m => ({module := m.toName} : Import))).toArray
  let env ← importModules imports {}
  -- pass 1: 7D coordinate of every non-internal declaration
  let mut coordOf : Std.HashMap Name (Array Nat) := {}
  let mut decls : Array (Name × Array Nat) := #[]
  let mut faithCount := 0
  let mut faithOk := 0
  for (n, ci) in env.constants.map₁.toList do
    if n.isInternal || n.toString.startsWith "_" then
      continue
    let w := exprSizeWord ci.type
    let c := coord7 w
    coordOf := coordOf.insert n c
    decls := decls.push (n, c)
    -- faithfulness check: Σ act-sizes = total mass of the word (SevenD.coord_sum)
    faithCount := faithCount + 1
    let totalActs := c.foldl (· + ·) 0
    let totalWord := w.foldl (· + ·) 0
    if totalActs == totalWord then faithOk := faithOk + 1
  let total := decls.size
  IO.println s!"  {total} declarations embedded in 7D (faithfulness {faithOk}/{faithCount})"
  (← IO.getStdout).flush
  IO.FS.createDirAll outPath
  -- per-axis statistics: min, max, sum (for mean)
  let mut axMin : Array Nat := Array.replicate 7 1000000000
  let mut axMax : Array Nat := Array.replicate 7 0
  let mut axSum : Array Nat := Array.replicate 7 0
  -- dominant-act histogram (the seven "groups")
  let mut domHist : Array Nat := Array.replicate 7 0
  -- exact-coordinate cell clustering
  let mut cellCount : Std.HashMap String (Nat × Name) := {}
  -- periodic-table grid: rows = size period (0..maxPeriod), cols = dominant act (0..6)
  let maxPeriod := 16
  let mut grid : Array Nat := Array.replicate ((maxPeriod + 1) * 7) 0
  for (n, c) in decls do
    for i in [0:7] do
      let v := c[i]!
      if v < axMin[i]! then axMin := axMin.set! i v
      if v > axMax[i]! then axMax := axMax.set! i v
      axSum := axSum.set! i (axSum[i]! + v)
    let d := dominantAct c
    domHist := domHist.set! d (domHist[d]! + 1)
    let key := renderVec c
    let (cc, samp) := cellCount.getD key (0, n)
    cellCount := cellCount.insert key (cc + 1, samp)
    let tot := c.foldl (· + ·) 0
    let per := min (sizePeriod tot) maxPeriod
    let gi := per * 7 + d
    grid := grid.set! gi (grid[gi]! + 1)
  -- pass 2: arrows (dependency edges) as 7D displacement vectors
  let mut edgeTotal : Nat := 0
  -- mean displacement (flow) accumulators, in Int
  let mut flowSum : Array Int := Array.replicate 7 0
  -- per-axis sign histogram: neg, zero, pos
  let mut signNeg : Array Nat := Array.replicate 7 0
  let mut signZero : Array Nat := Array.replicate 7 0
  let mut signPos : Array Nat := Array.replicate 7 0
  -- top displacement vectors, keyed by a cheap numeric hash (representative kept on first sight)
  let mut dispCount : Std.HashMap UInt64 (Nat × Array Int × Name × Name) := {}
  let mut sampleEdges : Array (Name × Name × Array Int) := #[]
  for (n, ci) in env.constants.map₁.toList do
    if n.isInternal || n.toString.startsWith "_" then
      continue
    let some cTo := coordOf.get? n | continue
    for d in constDepNames ci do
      let some cFrom := coordOf.get? d | continue
      let mut disp : Array Int := Array.replicate 7 0
      let mut h : UInt64 := 1469598103934665603
      for i in [0:7] do
        let dv : Int := (cTo[i]! : Int) - (cFrom[i]! : Int)
        disp := disp.set! i dv
        flowSum := flowSum.set! i (flowSum[i]! + dv)
        if dv < 0 then signNeg := signNeg.set! i (signNeg[i]! + 1)
        else if dv == 0 then signZero := signZero.set! i (signZero[i]! + 1)
        else signPos := signPos.set! i (signPos[i]! + 1)
        h := (h ^^^ (UInt64.ofNat dv.toNat + UInt64.ofNat (i + 1) * 2654435761)) * 1099511628211
      edgeTotal := edgeTotal + 1
      match dispCount.get? h with
      | some (cc, dv0, a, b) => dispCount := dispCount.insert h (cc + 1, dv0, a, b)
      | none =>
        -- bound memory: stop tracking new rare displacements past a cap (high-count ones,
        -- the only ones reported, are already present)
        if dispCount.size < 500000 then dispCount := dispCount.insert h (1, disp, d, n)
      if sampleEdges.size < 12 then sampleEdges := sampleEdges.push (d, n, disp)
  IO.println s!"  {edgeTotal} relations embedded as 7D arrows"
  (← IO.getStdout).flush
  -- ===== derived summaries =====
  let meanStr (s : Nat) : String :=
    let scaled := (s * 100) / (max total 1)
    s!"{scaled / 100}.{padL (toString (scaled % 100)) 2}"
  let topCells := topKMap cellCount (fun v => v.1) 30
  let topDisp := topKMap dispCount (fun v => v.1) 30
  -- ===== embedding.txt =====
  let mut txt : Array String := #[]
  txt := txt.push s!"# 7D act-space embedding of {total} terms"
  txt := txt.push "# coordinate t ↦ (a1..a7) = the seven act-sizes of the term's size word (SevenD.coord)."
  txt := txt.push s!"# Faithfulness (SevenD.coord_sum, Σ acts = total size): holds for {faithOk}/{faithCount} terms."
  txt := txt.push ""
  txt := txt.push "## Per-axis statistics (act : min : mean : max)"
  for i in [0:7] do
    txt := txt.push s!"  a{i+1} : {axMin[i]!} : {meanStr axSum[i]!} : {axMax[i]!}"
  txt := txt.push ""
  txt := txt.push "## Dominant-act histogram (which of the seven acts is largest = the term's group)"
  for i in [0:7] do
    txt := txt.push s!"  group a{i+1} : {domHist[i]!}"
  txt := txt.push ""
  txt := txt.push s!"## Flow: mean arrow displacement over {edgeTotal} relations (act : mean Δ : neg/zero/pos)"
  for i in [0:7] do
    let m := flowSum[i]!
    let scaled := (m * 1000) / (max edgeTotal 1)
    txt := txt.push s!"  a{i+1} : {scaled}/1000 : {signNeg[i]!}/{signZero[i]!}/{signPos[i]!}"
  txt := txt.push ""
  txt := txt.push "## Largest 7D cells (exact coordinate clusters)  coord : count : sample"
  for (key, (cc, samp)) in topCells.toList do
    txt := txt.push s!"  {key} : {cc} : {samp}"
  txt := txt.push ""
  txt := txt.push "## Most common arrow displacement vectors  Δ : count : example (dep → decl)"
  for (_, (cc, dv0, a, b)) in topDisp.toList do
    txt := txt.push s!"  {renderVecI dv0} : {cc} : {a} → {b}"
  txt := txt.push ""
  txt := txt.push "## Sample vertices (term : 7D coordinate)"
  for (n, c) in decls.extract 0 20 |>.toList do
    txt := txt.push s!"  {n} : {renderVec c}"
  txt := txt.push ""
  txt := txt.push "## Sample arrows (dep → decl : 7D displacement)"
  for (a, b, disp) in sampleEdges.toList do
    txt := txt.push s!"  {a} → {b} : {renderVecI disp}"
  txt := txt.push ""
  txt := txt.push "## Periodic table: rows = size period ⌊log₂(total+1)⌋, cols = dominant act a1..a7 (count)"
  txt := txt.push ("   " ++ padR "period" 8 ++ String.intercalate " "
    ((List.range 7).map (fun i => padR s!"a{i+1}" 7)))
  for p in [0:maxPeriod+1] do
    let row := (List.range 7).map (fun d => padR (toString grid[p*7+d]!) 7)
    let rowSum := (List.range 7).foldl (fun acc d => acc + grid[p*7+d]!) 0
    if rowSum > 0 then
      txt := txt.push ("   " ++ padR (toString p) 8 ++ String.intercalate " " row)
  IO.FS.writeFile (outPath / "embedding.txt") (String.intercalate "\n" txt.toList ++ "\n")
  -- ===== coords.json =====
  let mut cj : Array String := #["{"]
  cj := cj.push s!"  \"totalTerms\": {total},"
  cj := cj.push s!"  \"faithful\": {faithOk},"
  cj := cj.push s!"  \"faithfulOf\": {faithCount},"
  cj := cj.push s!"  \"axisMin\": {renderVec axMin},"
  cj := cj.push s!"  \"axisMax\": {renderVec axMax},"
  cj := cj.push s!"  \"axisSum\": {renderVec axSum},"
  cj := cj.push s!"  \"dominantActHist\": {renderVec domHist},"
  cj := cj.push "  \"sample\": ["
  let mut cEntries : Array String := #[]
  for (n, c) in decls.extract 0 200 |>.toList do
    cEntries := cEntries.push ("    {\"name\": \"" ++ jsonEsc n.toString ++ "\", \"coord\": " ++ renderVec c ++ "}")
  cj := cj.push (String.intercalate ",\n" cEntries.toList)
  cj := cj.push "  ]"
  cj := cj.push "}"
  IO.FS.writeFile (outPath / "coords.json") (String.intercalate "\n" cj.toList ++ "\n")
  -- ===== clusters.json =====
  let mut lj : Array String := #["{"]
  lj := lj.push s!"  \"totalTerms\": {total},"
  lj := lj.push s!"  \"distinctCells\": {cellCount.size},"
  lj := lj.push "  \"topCells\": ["
  let mut lEntries : Array String := #[]
  for (key, (cc, samp)) in topCells.toList do
    lEntries := lEntries.push ("    {\"coord\": " ++ key ++ ", \"count\": " ++ toString cc ++ ", \"sample\": \"" ++ jsonEsc samp.toString ++ "\"}")
  lj := lj.push (String.intercalate ",\n" lEntries.toList)
  lj := lj.push "  ]"
  lj := lj.push "}"
  IO.FS.writeFile (outPath / "clusters.json") (String.intercalate "\n" lj.toList ++ "\n")
  -- ===== edges.json =====
  let mut ej : Array String := #["{"]
  ej := ej.push s!"  \"totalArrows\": {edgeTotal},"
  ej := ej.push s!"  \"flowSum\": {renderVecI flowSum},"
  ej := ej.push s!"  \"signNeg\": {renderVec signNeg},"
  ej := ej.push s!"  \"signZero\": {renderVec signZero},"
  ej := ej.push s!"  \"signPos\": {renderVec signPos},"
  ej := ej.push s!"  \"distinctDisplacements\": {dispCount.size},"
  ej := ej.push "  \"topDisplacements\": ["
  let mut eEntries : Array String := #[]
  for (_, (cc, dv0, a, b)) in topDisp.toList do
    eEntries := eEntries.push ("    {\"disp\": " ++ renderVecI dv0 ++ ", \"count\": " ++ toString cc ++ ", \"from\": \"" ++ jsonEsc a.toString ++ "\", \"to\": \"" ++ jsonEsc b.toString ++ "\"}")
  ej := ej.push (String.intercalate ",\n" eEntries.toList)
  ej := ej.push "  ]"
  ej := ej.push "}"
  IO.FS.writeFile (outPath / "edges.json") (String.intercalate "\n" ej.toList ++ "\n")
  -- ===== map.json =====
  let mut mj : Array String := #["{"]
  mj := mj.push s!"  \"rows\": \"size period floor(log2(total+1))\","
  mj := mj.push "  \"cols\": [\"a1\", \"a2\", \"a3\", \"a4\", \"a5\", \"a6\", \"a7\"],"
  mj := mj.push "  \"grid\": ["
  let mut mRows : Array String := #[]
  for p in [0:maxPeriod+1] do
    let rowSum := (List.range 7).foldl (fun acc d => acc + grid[p*7+d]!) 0
    if rowSum > 0 then
      let row := (List.range 7).map (fun d => toString grid[p*7+d]!)
      mRows := mRows.push ("    {\"period\": " ++ toString p ++ ", \"counts\": [" ++ String.intercalate ", " row ++ "]}")
  mj := mj.push (String.intercalate ",\n" mRows.toList)
  mj := mj.push "  ]"
  mj := mj.push "}"
  IO.FS.writeFile (outPath / "map.json") (String.intercalate "\n" mj.toList ++ "\n")
  IO.println s!"  embedding.txt / coords.json / clusters.json / edges.json / map.json written to {outDirStr}"
  return 0
