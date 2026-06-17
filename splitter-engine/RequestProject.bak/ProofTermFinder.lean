/-
ProofTermFinder.lean — *proof-term expansion* of the 7D act-space embedding.

This is the executable companion to `RequestProject/ProofGeometry.lean`.  It is the
"Option 3 / Proof-Term Expansion" of `SevenDFinder`: instead of reading the term-relation
graph only from **statement types**, it *also* reads relations from the **raw proof terms**
(declaration values), and compares the two graphs on one fixed 7D geometry.

The vertices and their coordinates are unchanged: every declaration sits at the 7D coordinate
of its **type**-shape's size word (`coord7`, matching `SevenD.coord`).  What changes is the
*edge provenance*:

  * **statement graph** — an arrow `d → n` whenever `n`'s **type** references `d`
    (`ci.type.getUsedConstants`), exactly as in `SevenDFinder`;
  * **proof graph** — an arrow `d → n` whenever `n`'s **proof term / value** references `d`
    (`ci.value?.getUsedConstants`).

Because the embedding space is identical, every edge `d → n` carries the *same* 7D displacement
`coord n − coord d` in both graphs (this is `ProofGeometry.flow_eq_head_sub_tail`: the geometry
of a graph depends only on its endpoints, not on how the edge was discovered).  So comparing
*proof geometry* to *statement geometry* is comparing **which edges exist** and the resulting
**flows**, on a single fixed lattice.

For each graph the tool computes: number of arrows, the mean displacement (flow) per act, the
per-axis sign histogram (neg/zero/pos), and the most common displacement vectors.  It also
computes, per declaration, the overlap between its statement-deps and its proof-deps, totalling
the **shared**, **proof-only**, and **statement-only** relations, and reports the per-axis
**flow difference** proof − statement (`ProofGeometry.flowDiff`).

Outputs (default dir `./proofgeom-out`):
  * `proofgeom.txt`   — human-readable side-by-side comparison.
  * `stmt-edges.json` — statement-graph arrow stats (flow, signs, top displacements).
  * `proof-edges.json`— proof-graph arrow stats.
  * `compare.json`    — overlap (shared / proof-only / stmt-only) + per-axis flow difference.

Usage:
  lake exe prooftermfinder <Module> <outputDir>
  lake exe prooftermfinder                       -- reads proofterm-config.json, else defaults
-/
import Lean

open Lean System

/-- The size word of an expression, computed in `O(#nodes)` (pre-order list of subtree sizes,
the head of each node being its total leaf count). Same construction as `SevenDFinder`. -/
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

/-- The **7D coordinate** of a size word `w` (executable realisation of `SevenD.coord`). -/
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

/-- The constants referenced in a declaration's **type** (its statement). -/
def stmtDepNames (ci : ConstantInfo) : Array Name :=
  ci.type.getUsedConstants

/-- The constants referenced in a declaration's **value / proof term** (empty if it has none,
e.g. axioms, inductives, constructors). -/
def proofDepNames (ci : ConstantInfo) : Array Name :=
  match ci.value? with
  | some v => v.getUsedConstants
  | none => #[]

/-- Parse the shared config format (`modules`/`module` + `outputDir`). -/
def parseConfig (s : String) : List String × String :=
  match Json.parse s with
  | .error _ => ([], "./proofgeom-out")
  | .ok j =>
    let out := (j.getObjValAs? String "outputDir").toOption.getD "./proofgeom-out"
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

/-- Read configuration from CLI args, or `proofterm-config.json`, else defaults. -/
def readConfig (args : List String) : IO (List String × String) := do
  let dflt : List String := ["Mathlib.Algebra.Vertex.HVertexOperator"]
  match args with
  | [] =>
    let configPath := System.FilePath.mk "proofterm-config.json"
    if ← configPath.pathExists then
      let content ← IO.FS.readFile configPath
      let (mods, out) := parseConfig content
      return (if mods.isEmpty then dflt else mods, out)
    else
      return (dflt, "./proofgeom-out")
  | [m] => return ([m], "./proofgeom-out")
  | m :: out :: _ => return ([m], out)

/-- Escape a string for embedding in JSON. -/
def jsonEsc (s : String) : String :=
  s.replace "\\" "\\\\" |>.replace "\"" "\\\""

/-- Render an array of nats as `[a, b, c]`. -/
def renderVec (w : Array Nat) : String :=
  "[" ++ String.intercalate ", " (w.toList.map toString) ++ "]"

/-- Render an array of ints as `[a, b, c]`. -/
def renderVecI (w : Array Int) : String :=
  "[" ++ String.intercalate ", " (w.toList.map toString) ++ "]"

/-- Pad a string on the left to width `w`. -/
def padL (s : String) (w : Nat) : String :=
  if s.length >= w then s else String.ofList (List.replicate (w - s.length) ' ') ++ s

/-- Pad a string on the right to width `w`. -/
def padR (s : String) (w : Nat) : String :=
  if s.length >= w then s else s ++ String.ofList (List.replicate (w - s.length) ' ')

/-- Linear top-`k` selection over a `HashMap` by a count projection on the value. -/
def topKMap {κ ν : Type} [BEq κ] [Hashable κ] [Inhabited κ] [Inhabited ν]
    (m : Std.HashMap κ ν) (cnt : ν → Nat) (k : Nat) : Array (κ × ν) :=
  m.fold (init := #[]) fun buf key val =>
    if buf.size < k then
      (buf.push (key, val)).qsort (fun a b => cnt a.2 > cnt b.2)
    else if cnt val > cnt buf[buf.size - 1]!.2 then
      ((buf.pop).push (key, val)).qsort (fun a b => cnt a.2 > cnt b.2)
    else buf

/-- Per-graph arrow statistics, accumulated as we stream edges. -/
structure GraphStats where
  edgeTotal : Nat := 0
  flowSum   : Array Int := Array.replicate 7 0
  signNeg   : Array Nat := Array.replicate 7 0
  signZero  : Array Nat := Array.replicate 7 0
  signPos   : Array Nat := Array.replicate 7 0
  dispCount : Std.HashMap UInt64 (Nat × Array Int × Name × Name) := {}
  sample    : Array (Name × Name × Array Int) := #[]

/-- Fold one edge `d → n` (with coordinates `cFrom`, `cTo`) into a `GraphStats`. -/
def GraphStats.addEdge (g : GraphStats) (d n : Name) (cFrom cTo : Array Nat) : GraphStats := Id.run do
  let mut disp : Array Int := Array.replicate 7 0
  let mut h : UInt64 := 1469598103934665603
  let mut flowSum := g.flowSum
  let mut signNeg := g.signNeg
  let mut signZero := g.signZero
  let mut signPos := g.signPos
  for i in [0:7] do
    let dv : Int := (cTo[i]! : Int) - (cFrom[i]! : Int)
    disp := disp.set! i dv
    flowSum := flowSum.set! i (flowSum[i]! + dv)
    if dv < 0 then signNeg := signNeg.set! i (signNeg[i]! + 1)
    else if dv == 0 then signZero := signZero.set! i (signZero[i]! + 1)
    else signPos := signPos.set! i (signPos[i]! + 1)
    h := (h ^^^ (UInt64.ofNat dv.toNat + UInt64.ofNat (i + 1) * 2654435761)) * 1099511628211
  let mut dispCount := g.dispCount
  match dispCount.get? h with
  | some (cc, dv0, a, b) => dispCount := dispCount.insert h (cc + 1, dv0, a, b)
  | none => if dispCount.size < 500000 then dispCount := dispCount.insert h (1, disp, d, n)
  let mut sample := g.sample
  if sample.size < 12 then sample := sample.push (d, n, disp)
  return { edgeTotal := g.edgeTotal + 1, flowSum, signNeg, signZero, signPos, dispCount, sample }

/-- Render a `GraphStats` as a JSON object body (without the surrounding braces / name). -/
def GraphStats.toJson (g : GraphStats) : String := Id.run do
  let topDisp := topKMap g.dispCount (fun v => v.1) 30
  let mut lines : Array String := #[]
  lines := lines.push s!"  \"totalArrows\": {g.edgeTotal},"
  lines := lines.push s!"  \"flowSum\": {renderVecI g.flowSum},"
  lines := lines.push s!"  \"signNeg\": {renderVec g.signNeg},"
  lines := lines.push s!"  \"signZero\": {renderVec g.signZero},"
  lines := lines.push s!"  \"signPos\": {renderVec g.signPos},"
  lines := lines.push s!"  \"distinctDisplacements\": {g.dispCount.size},"
  lines := lines.push "  \"topDisplacements\": ["
  let mut eEntries : Array String := #[]
  for (_, (cc, dv0, a, b)) in topDisp.toList do
    eEntries := eEntries.push ("    {\"disp\": " ++ renderVecI dv0 ++ ", \"count\": " ++ toString cc
      ++ ", \"from\": \"" ++ jsonEsc a.toString ++ "\", \"to\": \"" ++ jsonEsc b.toString ++ "\"}")
  lines := lines.push (String.intercalate ",\n" eEntries.toList)
  lines := lines.push "  ]"
  return String.intercalate "\n" lines.toList

/-- Append a human-readable block for a `GraphStats` to `txt`. -/
def GraphStats.appendTxt (g : GraphStats) (title : String) (txt : Array String) : Array String := Id.run do
  let topDisp := topKMap g.dispCount (fun v => v.1) 15
  let mut txt := txt
  txt := txt.push s!"## {title}: {g.edgeTotal} arrows"
  txt := txt.push "   act : mean Δ (×1000) : neg/zero/pos"
  for i in [0:7] do
    let m := g.flowSum[i]!
    let scaled := (m * 1000) / (max (g.edgeTotal : Int) 1)
    txt := txt.push s!"   a{i+1} : {scaled} : {g.signNeg[i]!}/{g.signZero[i]!}/{g.signPos[i]!}"
  txt := txt.push "   most common displacements  Δ : count : example (dep → decl)"
  for (_, (cc, dv0, a, b)) in topDisp.toList do
    txt := txt.push s!"     {renderVecI dv0} : {cc} : {a} → {b}"
  txt := txt.push ""
  return txt

/-- Main: embed every declaration in 7D, build the statement graph and the proof graph, and
compare the two geometries. -/
def main (args : List String) : IO UInt32 := do
  let (rootMods, outDirStr) ← readConfig args
  let outPath : System.FilePath := System.FilePath.mk outDirStr
  IO.println s!"ProofTermFinder: roots={rootMods} out={outDirStr}"
  initSearchPath (← findSysroot)
  let imports := (rootMods.map (fun m => ({module := m.toName} : Import))).toArray
  let env ← importModules imports {}
  -- pass 1: 7D coordinate of every non-internal declaration (from its TYPE)
  let mut coordOf : Std.HashMap Name (Array Nat) := {}
  for (n, ci) in env.constants.map₁.toList do
    if n.isInternal || n.toString.startsWith "_" then
      continue
    coordOf := coordOf.insert n (coord7 (exprSizeWord ci.type))
  let total := coordOf.size
  IO.println s!"  {total} declarations embedded in 7D (coords from statement types)"
  (← IO.getStdout).flush
  IO.FS.createDirAll outPath
  -- pass 2: build the statement graph and the proof graph; tally overlap per declaration
  let mut stmtG : GraphStats := {}
  let mut proofG : GraphStats := {}
  let mut declsWithValue := 0
  let mut declsNoValue := 0
  -- overlap totals (only over deps that are vertices in coordOf)
  let mut sharedTotal := 0      -- relations in BOTH graphs
  let mut proofOnlyTotal := 0   -- relations only in the proof graph
  let mut stmtOnlyTotal := 0    -- relations only in the statement graph
  for (n, ci) in env.constants.map₁.toList do
    if n.isInternal || n.toString.startsWith "_" then
      continue
    let some cTo := coordOf.get? n | continue
    -- statement deps (restricted to known vertices), collected into a set for overlap
    let mut stmtSet : Std.HashSet Name := {}
    for d in stmtDepNames ci do
      if let some cFrom := coordOf.get? d then
        stmtG := stmtG.addEdge d n cFrom cTo
        stmtSet := stmtSet.insert d
    -- proof deps
    if (ci.value?).isSome then declsWithValue := declsWithValue + 1
    else declsNoValue := declsNoValue + 1
    let mut proofSet : Std.HashSet Name := {}
    for d in proofDepNames ci do
      if let some cFrom := coordOf.get? d then
        if !proofSet.contains d then
          proofG := proofG.addEdge d n cFrom cTo
          proofSet := proofSet.insert d
    -- overlap (deduplicated dependency sets)
    for d in proofSet do
      if stmtSet.contains d then sharedTotal := sharedTotal + 1
      else proofOnlyTotal := proofOnlyTotal + 1
    for d in stmtSet do
      if !proofSet.contains d then stmtOnlyTotal := stmtOnlyTotal + 1
  IO.println s!"  statement arrows: {stmtG.edgeTotal}   proof arrows: {proofG.edgeTotal}"
  IO.println s!"  decls with proof value: {declsWithValue}   without: {declsNoValue}"
  (← IO.getStdout).flush
  -- per-axis flow difference (proof − statement), ProofGeometry.flowDiff
  let mut flowDiff : Array Int := Array.replicate 7 0
  for i in [0:7] do
    flowDiff := flowDiff.set! i (proofG.flowSum[i]! - stmtG.flowSum[i]!)
  -- ===== proofgeom.txt =====
  let mut txt : Array String := #[]
  txt := txt.push s!"# Proof geometry vs statement geometry over {total} terms"
  txt := txt.push "# Same vertices / same 7D coordinates (from TYPES); two edge provenances."
  txt := txt.push "# (per ProofGeometry.flow_eq_head_sub_tail, an edge d→n has the SAME 7D"
  txt := txt.push "#  displacement in both graphs; only WHICH edges exist differs.)"
  txt := txt.push ""
  txt := txt.push s!"declarations with a proof value : {declsWithValue}"
  txt := txt.push s!"declarations without a value     : {declsNoValue}"
  txt := txt.push ""
  txt := txt.push "## Relation overlap (deduplicated deps, restricted to known vertices)"
  txt := txt.push s!"   shared (statement AND proof) : {sharedTotal}"
  txt := txt.push s!"   proof-only                   : {proofOnlyTotal}"
  txt := txt.push s!"   statement-only               : {stmtOnlyTotal}"
  txt := txt.push ""
  txt := stmtG.appendTxt "Statement graph" txt
  txt := proofG.appendTxt "Proof graph" txt
  txt := txt.push "## Flow difference proof − statement (ProofGeometry.flowDiff), per act"
  for i in [0:7] do
    txt := txt.push s!"   a{i+1} : {flowDiff[i]!}"
  IO.FS.writeFile (outPath / "proofgeom.txt") (String.intercalate "\n" txt.toList ++ "\n")
  -- ===== stmt-edges.json / proof-edges.json =====
  IO.FS.writeFile (outPath / "stmt-edges.json") ("{\n" ++ stmtG.toJson ++ "\n}\n")
  IO.FS.writeFile (outPath / "proof-edges.json") ("{\n" ++ proofG.toJson ++ "\n}\n")
  -- ===== compare.json =====
  let mut cj : Array String := #["{"]
  cj := cj.push s!"  \"totalTerms\": {total},"
  cj := cj.push s!"  \"declsWithValue\": {declsWithValue},"
  cj := cj.push s!"  \"declsNoValue\": {declsNoValue},"
  cj := cj.push s!"  \"statementArrows\": {stmtG.edgeTotal},"
  cj := cj.push s!"  \"proofArrows\": {proofG.edgeTotal},"
  cj := cj.push s!"  \"sharedRelations\": {sharedTotal},"
  cj := cj.push s!"  \"proofOnlyRelations\": {proofOnlyTotal},"
  cj := cj.push s!"  \"statementOnlyRelations\": {stmtOnlyTotal},"
  cj := cj.push s!"  \"statementFlow\": {renderVecI stmtG.flowSum},"
  cj := cj.push s!"  \"proofFlow\": {renderVecI proofG.flowSum},"
  cj := cj.push s!"  \"flowDiff\": {renderVecI flowDiff}"
  cj := cj.push "}"
  IO.FS.writeFile (outPath / "compare.json") (String.intercalate "\n" cj.toList ++ "\n")
  IO.println s!"  proofgeom.txt / stmt-edges.json / proof-edges.json / compare.json written to {outDirStr}"
  return 0
