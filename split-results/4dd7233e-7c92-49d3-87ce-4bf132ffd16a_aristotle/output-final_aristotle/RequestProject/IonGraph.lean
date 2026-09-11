import Mathlib
import RequestProject.MoonshineWalk

/-!
# IonGraph: the SpiderMonkey hierarchical graph-layout algorithm, lifted into Lean

This file *lifts Graphviz into Lean*.  Instead of shelling out to `dot`/Graphviz (or
Mermaid) to draw the moonshine descent walk, we implement Mozilla SpiderMonkey's
**iongraph** layout algorithm directly in Lean as executable, total functions, prove its
structural invariants, and render the result to SVG — all inside the proof assistant.

The iongraph algorithm (Ben Visness, *"Who needs Graphviz when you can build it yourself?"*,
2025) is a deliberately simplified Sugiyama-style hierarchical layout specialised to
**reducible control-flow graphs**.  Its pipeline is:

1. **Layering** — assign each block to a horizontal layer by its depth in the DAG, ignoring
   labelled back-edges (loops).  We implement this as a longest-path relaxation
   (`layerFun`), iterated `|V|` times.
2. **Dummy nodes / grouping** — group blocks by layer (`blocksByLayer`); long edges are
   routed (here, by the railroad edge renderer rather than explicit dummies, since our
   target graph has only unit-span edges).
3. **Straighten edges** — pull children under their parents (`straighten`).
4. **Verticalise** — assign `y` from the layer index (`place`).
5. **Render** — emit SVG with railroad-style (axis-aligned) edges (`render`).

The two structural invariants emphasised in the write-up are formalised as the predicates
`LayerMonotone` (every non-back-edge points strictly downward in layer) and `UniqueIDs`
(node identifiers are distinct), bundled into `LayoutState.valid`.

We then build the graph of the verified `MoonshineWalk.moonshineWalk` *from its own
machine-checked data* (`MoonshineWalk.valueView` / `gradeView`), run the layout, prove the
layout is valid and is a clean 13-layer staircase, and produce its SVG (`moonshineSVG`).
Generic example graphs (`chain`, `diamond`, `loopExample`) exercise branching and back-edges.
-/

namespace IonGraph

/-! ## Core data types -/

/-- Block identifier. -/
abbrev BlockID := Nat

/-- A basic block of a control-flow graph, with its successor edges.  A successor edge
flagged via `backedge := true` on the *source* block is a loop back-edge and is ignored by
layering (this is iongraph's "cycle breaking" step, trivial for reducible CFGs). -/
structure Block where
  id : BlockID
  succs : List BlockID
  backedge : Bool := false
  label : String := ""
  w : Nat := 150
  h : Nat := 44
deriving Repr, Inhabited, DecidableEq

/-- A control-flow graph: a list of blocks. -/
structure Graph where
  blocks : List Block
deriving Repr, Inhabited

/-! ## Step 1 — layering (longest path, ignoring back-edges) -/

/-- The non-back-edge predecessors of `v`. -/
def predsOf (g : Graph) (v : BlockID) : List BlockID :=
  (g.blocks.filter (fun b => v ∈ b.succs && !b.backedge)).map (·.id)

/-- One relaxation step of longest-path layering:
`layer v = max over preds u of (layer u + 1)`, or `0` if `v` has no predecessors. -/
def relax (g : Graph) (f : BlockID → Nat) : BlockID → Nat :=
  fun v => (predsOf g v).foldl (fun acc u => max acc (f u + 1)) 0

/-- Longest-path layer assignment: iterate `relax` `|V|` times from the all-zero map.
For a DAG this reaches the fixed point (the longest path length to each node). -/
def layerFun (g : Graph) : BlockID → Nat :=
  (fun f => relax g f)^[g.blocks.length] (fun _ => 0)

/-- The layer assigned to block `v`. -/
def Graph.layerOf (g : Graph) (v : BlockID) : Nat := layerFun g v

/-- The number of layers in the laid-out graph. -/
def numLayers (g : Graph) : Nat :=
  (g.blocks.map (fun b => g.layerOf b.id + 1)).foldl max 0

/-! ## Step 2 — group blocks by layer -/

/-- Blocks grouped by layer: entry `L` is the (source-ordered) list of blocks on layer `L`.
The list has length `numLayers g`. -/
def blocksByLayer (g : Graph) : List (List Block) :=
  (List.range (numLayers g)).map (fun L => g.blocks.filter (fun b => g.layerOf b.id == L))

@[simp] theorem blocksByLayer_length (g : Graph) :
    (blocksByLayer g).length = numLayers g := by
  simp [blocksByLayer]

/-! ## Steps 3–4 — positioned layout nodes -/

/-- A positioned node of the layout: a block placed at integer coordinates `(x, y)`. -/
structure PNode where
  id : BlockID
  layer : Nat
  col : Nat
  x : Int
  y : Int
  w : Nat
  h : Nat
  label : String
deriving Repr, Inhabited

/-- Horizontal gap between columns.  Chosen strictly larger than the widest node box
(`320`) so that two blocks sharing a layer never overlap horizontally; this is what makes
the machine-checked non-overlap proof `MoonshineBranch.branchGraph_layout_clean` go
through. -/
def xgap : Int := 360
/-- Vertical gap between layers. -/
def ygap : Int := 96
/-- Outer margin. -/
def margin : Int := 40

/-- Assign grid positions: column = index within the block's layer, `y` from the layer.
This is iongraph's "verticalise" step combined with a simple per-layer column placement. -/
def place (g : Graph) : List PNode :=
  (blocksByLayer g).flatMap (fun lb =>
    lb.mapIdx (fun i b =>
      { id := b.id, layer := g.layerOf b.id, col := i,
        x := margin + Int.ofNat i * xgap,
        y := margin + Int.ofNat (g.layerOf b.id) * ygap,
        w := b.w, h := b.h, label := b.label }))

/-- Look up a positioned node by id. -/
def findP (ps : List PNode) (v : BlockID) : Option PNode := ps.find? (fun m => m.id == v)

/-- Step 3 (edge straightening): pull each node horizontally to line up under its first
non-back-edge predecessor (never moving it left), exactly as in iongraph's
`straightenChildren`. -/
def straighten (g : Graph) (ps : List PNode) : List PNode :=
  ps.map (fun n =>
    match predsOf g n.id with
    | [] => n
    | u :: _ =>
      match findP ps u with
      | some p => { n with x := max n.x p.x }
      | none => n)

/-! ## Step 5 — render to SVG (railroad-style edges) -/

/-- One SVG rounded rectangle + centred label for a node. -/
def renderNode (n : PNode) : String :=
  let cx := n.x + Int.ofNat (n.w / 2)
  s!"<rect x=\"{n.x}\" y=\"{n.y}\" width=\"{n.w}\" height=\"{n.h}\" rx=\"8\" "
    ++ s!"fill=\"#2d3748\" stroke=\"#4a5568\" stroke-width=\"1.5\"/>\n"
    ++ s!"<text x=\"{cx}\" y=\"{n.y + Int.ofNat (n.h/2) + 4}\" text-anchor=\"middle\" "
    ++ s!"fill=\"white\" font-family=\"Helvetica\" font-size=\"11\">{n.label}</text>\n"

/-- A railroad (axis-aligned: vertical–horizontal–vertical) edge from `u` to `v`.
Back-edges are drawn in amber, forward edges in dark. -/
def renderEdge (ps : List PNode) (u v : BlockID) (back : Bool) : String :=
  match findP ps u, findP ps v with
  | some a, some b =>
    let ax := a.x + Int.ofNat (a.w / 2)
    let ay := a.y + Int.ofNat a.h
    let bx := b.x + Int.ofNat (b.w / 2)
    let by_ := b.y
    let col := if back then "#d69e2e" else "#1a202c"
    let mid := (ay + by_) / 2
    s!"<polyline points=\"{ax},{ay} {ax},{mid} {bx},{mid} {bx},{by_}\" fill=\"none\" "
      ++ s!"stroke=\"{col}\" stroke-width=\"2\"/>\n"
  | _, _ => ""

/-- Render the whole graph to a standalone SVG document. -/
def render (g : Graph) : String :=
  let ps := straighten g (place g)
  let W := (ps.map (fun n => n.x + Int.ofNat n.w)).foldl max 0 + margin
  let H := (ps.map (fun n => n.y + Int.ofNat n.h)).foldl max 0 + margin
  let nodes := String.join (ps.map renderNode)
  let edges := String.join (g.blocks.flatMap (fun b =>
    b.succs.map (fun s => renderEdge ps b.id s b.backedge)))
  s!"<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"{W}\" height=\"{H}\">\n"
    ++ s!"<rect width=\"{W}\" height=\"{H}\" fill=\"white\"/>\n"
    ++ edges ++ nodes ++ "</svg>\n"

/-! ## The layout specification and its invariants -/

/-- The result of the layout pipeline: the graph together with its layered nodes and
dimensions. -/
structure LayoutState where
  graph : Graph
  nodes : List PNode
  numLayers : Nat
deriving Repr

/-- Run the full layout pipeline. -/
def layout (g : Graph) : LayoutState :=
  { graph := g, nodes := straighten g (place g), numLayers := numLayers g }

/-- **Layer monotonicity** (iongraph's key invariant): every non-back-edge points strictly
downward, i.e. from a lower layer to a higher one. -/
def LayerMonotone (g : Graph) : Prop :=
  ∀ b ∈ g.blocks, ∀ v ∈ b.succs, b.backedge = true ∨ g.layerOf b.id < g.layerOf v

instance (g : Graph) : Decidable (LayerMonotone g) := by
  unfold LayerMonotone; infer_instance

/-- **Unique identifiers**: the placed nodes have pairwise-distinct ids. -/
def UniqueIDs (s : LayoutState) : Prop :=
  (s.nodes.map (·.id)).Nodup

instance (s : LayoutState) : Decidable (UniqueIDs s) := by
  unfold UniqueIDs; infer_instance

/-- A layout is *valid* when its layering is monotone and its node ids are unique. -/
def LayoutState.valid (s : LayoutState) : Prop :=
  LayerMonotone s.graph ∧ UniqueIDs s

instance (s : LayoutState) : Decidable s.valid := by
  unfold LayoutState.valid; infer_instance

/-! ## Generic example graphs -/

/-- A straight chain `A → B → C`. -/
def chain : Graph := { blocks := [
  {id := 0, succs := [1], label := "A"},
  {id := 1, succs := [2], label := "B"},
  {id := 2, succs := [],  label := "C"} ] }

/-- A diamond `root → {L, R} → join`. -/
def diamond : Graph := { blocks := [
  {id := 0, succs := [1, 2], label := "root"},
  {id := 1, succs := [3],    label := "L"},
  {id := 2, succs := [3],    label := "R"},
  {id := 3, succs := [],     label := "join"} ] }

/-- A loop: `0 → 1 → 2`, with `2 → 1` a back-edge (handled by cycle breaking). -/
def loopExample : Graph := { blocks := [
  {id := 0, succs := [1], label := "entry"},
  {id := 1, succs := [2], label := "header"},
  {id := 2, succs := [1], backedge := true, label := "body"} ] }

theorem chain_valid : (layout chain).valid := by native_decide
theorem diamond_valid : (layout diamond).valid := by native_decide
theorem loopExample_valid : (layout loopExample).valid := by native_decide

/-- Layering ignores back-edges: the loop body sits *below* the header even though it has an
edge back up to it. -/
theorem loopExample_layers :
    loopExample.layerOf 0 = 0 ∧ loopExample.layerOf 1 = 1 ∧ loopExample.layerOf 2 = 2 := by
  native_decide

/-! ## The moonshine walk graph, built from its own verified data -/

/-- Per-step labels for the moonshine backbone, derived directly from the machine-checked
`MoonshineWalk` projections (`gradeView`, `valueView`). -/
def moonshineLabels : List String :=
  let grades := MoonshineWalk.gradeView MoonshineWalk.moonshineWalk
  let vals := MoonshineWalk.valueView MoonshineWalk.moonshineWalk
  (List.range 13).map (fun i =>
    s!"step {i}  |  grade {grades.getD i 0}  |  {vals.getD i 0}")

/-- The graph of the verified moonshine descent walk: a 13-node backbone, each step a single
prime-removal, built from the verified data so the picture is exactly what is proved. -/
def moonshineGraph : Graph :=
  { blocks := (List.range 13).map (fun i =>
      { id := i, succs := if i < 12 then [i + 1] else [],
        w := 360, label := (moonshineLabels.getD i "") }) }

/-- The moonshine layout has exactly 13 layers (= walk length). -/
theorem moonshineGraph_numLayers : numLayers moonshineGraph = 13 := by native_decide

/-- The backbone is a clean staircase: step `i` lands on layer `i`. -/
theorem moonshineGraph_staircase : ∀ i ∈ List.range 13, moonshineGraph.layerOf i = i := by
  native_decide

/-- **The moonshine layout is valid**: monotone layering and unique node ids. -/
theorem moonshineGraph_valid : (layout moonshineGraph).valid := by native_decide

/-- The layout produces exactly 13 positioned nodes. -/
theorem moonshineGraph_node_count : (layout moonshineGraph).nodes.length = 13 := by
  native_decide

/-- The number of layers equals the length of the verified walk. -/
theorem layout_matches_walk_length :
    numLayers moonshineGraph = MoonshineWalk.moonshineWalk.length := by
  native_decide

/-- The rendered SVG of the moonshine descent walk — Graphviz, lifted into Lean. -/
def moonshineSVG : String := render moonshineGraph

end IonGraph
