import Mathlib
import RequestProject.Moonshine
import RequestProject.MoonshineWalk
import RequestProject.IonGraph

/-!
# A *branching* moonshine descent and an animated SVG "movie", all in Lean

The earlier `MoonshineWalk` / `IonGraph` development drew the descent from the Oggorial
pseudoscalar down to the `{47,59,71}` PTE face as a single **straight line** (a 13-layer
staircase).  This file answers the follow-up request — *"it's only a straight line, didn't
you want to have a branch"* — by building the genuine **branch** that the moonshine
discussion is actually about, and then turning the picture into a self-contained **animated
SVG movie** emitted directly from Lean.

## The branch: the confluence diamond

The mathematical content of the branch is the **confluence** proved in
`Moonshine.removeStep_comm`: starting from the Oggorial you may remove prime `11` *or*
prime `23` first, and the two routes **reconverge** at the irrep-161 hub
(`Moonshine.irrep161Support = Oggorial \ {11,23}`).  This is a diamond

```
            Oggorial (grade 15)
             /            \
   remove 11               remove 23
   (grade 14)              (grade 14)
             \            /
        irrep-161 hub (grade 13)
                 |
           …linear descent…
                 |
         {47,59,71} face → 196883
```

so the layout is no longer a line: layer `1` carries **two** blocks side by side, the root
has two successors, and the hub has two predecessors — all machine-checked.

## The movie

Two complementary "movie" outputs are produced, both as total Lean functions:

* `branchAnimatedSVG` — a single **animated SVG** (SMIL): every node/edge fades in at a time
  proportional to its layer, so the descent literally *draws itself* step by step and loops.
* `branchMovieFrames` — an explicit **list of SVG frames** (one per layer); appending /
  flipping through them is the "many frames → whole movie" construction asked for.

Everything proved here is finite combinatorics, checked by `decide` / `native_decide`.
-/

namespace MoonshineBranch

open Moonshine
open MoonshineWalk (walkTrace pteFace)

/-! ## The branching descent data -/

/-- The blades visited by the branching descent, indexed by node id:

* `0` Oggorial; `1` Oggorial∖{11}; `2` Oggorial∖{23};
* `3` the irrep-161 hub (Oggorial∖{11,23}); `4 … 13` the linear tail down to the face. -/
def branchBlades : List Blade :=
  [oggorial, oggorial.erase 4, oggorial.erase 8]
    ++ walkTrace irrep161Support [0, 1, 2, 3, 5, 6, 7, 9, 10, 11]

theorem branchBlades_length : branchBlades.length = 14 := by decide

/-- The successor structure of the branching graph: the root forks to `1` and `2`, both join
at `3`, and from there it is a single chain down to node `13`. -/
def branchSuccs : Nat → List Nat
  | 0 => [1, 2]
  | 1 => [3]
  | 2 => [3]
  | 13 => []
  | i => [i + 1]

/-- The branching descent as an `IonGraph` graph, with node labels (grade and squarefree
FRACTRAN value) read off the verified `branchBlades` data. -/
def branchGraph : IonGraph.Graph :=
  { blocks := (List.range 14).map (fun i =>
      let b := branchBlades.getD i ∅
      { id := i, succs := branchSuccs i, w := 320,
        label := s!"grade {grade b}  |  {bladeToNat b}" }) }

/-! ## The branch is a real branch (machine-checked) -/

/-- **Confluence (the diamond closes).**  Removing `11` then `23` and removing `23` then `11`
both land on the irrep-161 hub. -/
theorem branch_confluence :
    (oggorial.erase 4).erase 8 = irrep161Support ∧
    (oggorial.erase 8).erase 4 = irrep161Support := by
  refine ⟨?_, ?_⟩ <;> decide

/-- The root has **two** successors — this is the fork that makes the picture branch. -/
theorem branchGraph_root_forks :
    ((branchGraph.blocks.find? (fun b => b.id == 0)).map IonGraph.Block.succs)
      = some [1, 2] := by native_decide

/-- The hub has **two** predecessors — this is where the two branches reconverge. -/
theorem branchGraph_join : IonGraph.predsOf branchGraph 3 = [1, 2] := by native_decide

/-- The two branch nodes sit on the **same layer** (`1`), and the hub is one layer below
both: the diamond is laid out as an actual diamond. -/
theorem branch_layers :
    branchGraph.layerOf 0 = 0 ∧
    branchGraph.layerOf 1 = 1 ∧
    branchGraph.layerOf 2 = 1 ∧
    branchGraph.layerOf 3 = 2 := by native_decide

/-- The branching layout still has exactly 13 layers and ends on the PTE face. -/
theorem branchGraph_numLayers : IonGraph.numLayers branchGraph = 13 := by native_decide

theorem branch_end : branchBlades.getLast? = some pteFace := by native_decide

/-- **The branching layout is valid**: monotone layering and unique node ids. -/
theorem branchGraph_valid : (IonGraph.layout branchGraph).valid := by native_decide

/-- The layout produces exactly 14 positioned nodes (one more than the linear walk: the
diamond has two nodes on its middle layer). -/
theorem branchGraph_node_count : (IonGraph.layout branchGraph).nodes.length = 14 := by
  native_decide

/-! ## Animated SVG rendering (a movie, in Lean) -/

/-- Zero-pad a number `< 1000` to three digits. -/
def pad3 (n : Nat) : String :=
  if n < 10 then "00" ++ toString n
  else if n < 100 then "0" ++ toString n
  else toString n

/-- Render `num/den ∈ [0,1]` as an SVG `keyTimes` decimal string. -/
def fracStr (num den : Nat) : String :=
  if den = 0 then "0"
  else
    let m := num * 1000 / den
    if 1000 ≤ m then "1" else "0." ++ pad3 m

/-- Wrap SVG `inner` in a group that fades from invisible to visible at the (looping)
timeline fraction `f`, giving the "draw it step by step" movie effect. -/
def wrapReveal (f : String) (dur : Nat) (inner : String) : String :=
  s!"<g opacity=\"0\"><animate attributeName=\"opacity\" values=\"0;0;1;1\" " ++
  s!"keyTimes=\"0;{f};{f};1\" dur=\"{dur}s\" repeatCount=\"indefinite\"/>\n" ++
  inner ++ "</g>\n"

/-- A node that fades in at the timeline fraction set by its layer. -/
def animNode (total dur : Nat) (n : IonGraph.PNode) : String :=
  let cx := n.x + Int.ofNat (n.w / 2)
  let f := fracStr (n.layer + 1) (total + 1)
  let inner :=
    s!"<rect x=\"{n.x}\" y=\"{n.y}\" width=\"{n.w}\" height=\"{n.h}\" rx=\"8\" " ++
    s!"fill=\"#2d3748\" stroke=\"#4a5568\" stroke-width=\"1.5\"/>\n" ++
    s!"<text x=\"{cx}\" y=\"{n.y + Int.ofNat (n.h / 2) + 4}\" text-anchor=\"middle\" " ++
    s!"fill=\"white\" font-family=\"Helvetica\" font-size=\"11\">{n.label}</text>\n"
  wrapReveal f dur inner

/-- An edge that fades in at the timeline fraction set by its target node's layer. -/
def animEdge (total dur : Nat) (ps : List IonGraph.PNode) (u v : Nat) (back : Bool) :
    String :=
  match IonGraph.findP ps u, IonGraph.findP ps v with
  | some a, some b =>
    let ax := a.x + Int.ofNat (a.w / 2)
    let ay := a.y + Int.ofNat a.h
    let bx := b.x + Int.ofNat (b.w / 2)
    let by_ := b.y
    let col := if back then "#d69e2e" else "#1a202c"
    let mid := (ay + by_) / 2
    let f := fracStr (b.layer + 1) (total + 1)
    wrapReveal f dur
      (s!"<polyline points=\"{ax},{ay} {ax},{mid} {bx},{mid} {bx},{by_}\" fill=\"none\" " ++
       s!"stroke=\"{col}\" stroke-width=\"2\"/>\n")
  | _, _ => ""

/-- Render a graph to a single **animated** SVG that reveals itself layer by layer and loops
(`dur` = total cycle length in seconds). -/
def renderAnimated (g : IonGraph.Graph) (dur : Nat) : String :=
  let ps := IonGraph.straighten g (IonGraph.place g)
  let total := IonGraph.numLayers g
  let W := (ps.map (fun n => n.x + Int.ofNat n.w)).foldl max 0 + IonGraph.margin
  let H := (ps.map (fun n => n.y + Int.ofNat n.h)).foldl max 0 + IonGraph.margin
  let nodes := String.join (ps.map (animNode total dur))
  let edges := String.join (g.blocks.flatMap (fun bk =>
    bk.succs.map (fun s => animEdge total dur ps bk.id s bk.backedge)))
  s!"<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"{W}\" height=\"{H}\">\n" ++
  s!"<rect width=\"{W}\" height=\"{H}\" fill=\"white\"/>\n" ++
  "<title>Moonshine branching descent (animated)</title>\n" ++
  edges ++ nodes ++ "</svg>\n"

/-- The animated SVG of the branching moonshine descent (13-second loop). -/
def branchAnimatedSVG : String := renderAnimated branchGraph 13

/-! ## Explicit frames: "many frames → whole movie" -/

/-- Render only the part of the layout with layer `≤ k` (one frame of the movie), keeping the
canvas size fixed so the frames line up. -/
def renderUpto (g : IonGraph.Graph) (k : Nat) : String :=
  let ps0 := IonGraph.straighten g (IonGraph.place g)
  let ps := ps0.filter (fun n => n.layer ≤ k)
  let W := (ps0.map (fun n => n.x + Int.ofNat n.w)).foldl max 0 + IonGraph.margin
  let H := (ps0.map (fun n => n.y + Int.ofNat n.h)).foldl max 0 + IonGraph.margin
  let nodes := String.join (ps.map IonGraph.renderNode)
  let edges := String.join (g.blocks.flatMap (fun bk =>
    bk.succs.filterMap (fun s =>
      match IonGraph.findP ps0 s with
      | some t => if t.layer ≤ k then some (IonGraph.renderEdge ps0 bk.id s bk.backedge)
                  else none
      | none => none)))
  s!"<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"{W}\" height=\"{H}\">\n" ++
  s!"<rect width=\"{W}\" height=\"{H}\" fill=\"white\"/>\n" ++
  edges ++ nodes ++ "</svg>\n"

/-- The movie as an explicit list of SVG frames, one per layer. -/
def branchMovieFrames : List String :=
  (List.range (IonGraph.numLayers branchGraph)).map (renderUpto branchGraph)

/-- The movie has exactly 13 frames (one per layer of the descent). -/
theorem branchMovieFrames_length : branchMovieFrames.length = 13 := by native_decide

/-! ## Spatial verification: a machine-checked non-overlap proof of the layout

The rendered SVG places each node as an axis-aligned rectangle.  To *prove* that the
picture is free of visual clutter — no two node boxes (and the text centred inside them)
ever collide — we give the boxes an explicit geometry in Lean and verify pairwise
disjointness with the kernel.  All coordinates are exact integers (the same ones the SVG
emitter uses), so the separation inequalities reduce decidably. -/

/-- The visual envelope of a rendered object: an axis-aligned box with integer corner
`(x, y)`, width `w` and height `h` (the exact coordinate system used by the SVG emitter;
integers so the separation inequalities are decidable). -/
structure BoundingBox where
  x : Int
  y : Int
  w : Int
  h : Int
deriving Repr, DecidableEq

/-- Layout mapping: the bounding box of a positioned node is exactly its rendered rectangle.
The node's text label is drawn centred inside this rectangle (`text-anchor="middle"` with
the node width chosen wide enough to contain the label), so the rectangle is a faithful
envelope of both the shape and its text. -/
def nodeToBox (n : IonGraph.PNode) : BoundingBox :=
  { x := n.x, y := n.y, w := Int.ofNat n.w, h := Int.ofNat n.h }

/-- Two bounding boxes are **disjoint** when they are completely separated along the X-axis
or along the Y-axis. -/
def DisjointBoxes (A B : BoundingBox) : Prop :=
  A.x + A.w < B.x ∨ B.x + B.w < A.x ∨
  A.y + A.h < B.y ∨ B.y + B.h < A.y

instance (A B : BoundingBox) : Decidable (DisjointBoxes A B) := by
  unfold DisjointBoxes; infer_instance

/-- The positioned nodes of a graph after the full layout pipeline (place + straighten) —
exactly the coordinates fed to the SVG emitter. -/
def placedNodes (g : IonGraph.Graph) : List IonGraph.PNode :=
  IonGraph.straighten g (IonGraph.place g)

/-- **Global non-overlap specification.**  Every pair of distinct positioned nodes of `g`
has disjoint bounding boxes. -/
def LayoutNoOverlaps (g : IonGraph.Graph) : Prop :=
  ∀ a ∈ placedNodes g, ∀ b ∈ placedNodes g,
    a.id ≠ b.id → DisjointBoxes (nodeToBox a) (nodeToBox b)

instance (g : IonGraph.Graph) : Decidable (LayoutNoOverlaps g) := by
  unfold LayoutNoOverlaps; infer_instance

/-- **The confluence-diamond layout is collision-free.**  Every pair of the 14 distinct
nodes — including the two branch blocks `1` and `2` that share layer `1` — has disjoint
bounding boxes, so the rendered picture has no overlapping shapes or text.  Since every
animation frame (`branchMovieFrames`) and the looping `branchAnimatedSVG` reuse exactly
these coordinates, all 13 frames are guaranteed clean as well. -/
theorem branchGraph_layout_clean : LayoutNoOverlaps branchGraph := by native_decide

/-- The two same-layer branch blocks (`1` = remove-11, `2` = remove-23) — the pair most at
risk of colliding — are in particular separated. -/
theorem branch_forks_disjoint :
    ∀ a ∈ placedNodes branchGraph, ∀ b ∈ placedNodes branchGraph,
      a.id = 1 → b.id = 2 → DisjointBoxes (nodeToBox a) (nodeToBox b) := by
  native_decide

/-! ## Capstone -/

/-- **The branching moonshine descent, all at once.**  It really branches (root forks to two
nodes that reconverge at the hub one layer below), the layout is valid with 13 layers and 14
nodes, it ends on the `{47,59,71}` PTE face, and it is rendered as a 13-frame animated SVG
movie — every claim machine-checked. -/
theorem branch_panorama :
    ((branchGraph.blocks.find? (fun b => b.id == 0)).map IonGraph.Block.succs) = some [1, 2] ∧
    IonGraph.predsOf branchGraph 3 = [1, 2] ∧
    branchGraph.layerOf 1 = 1 ∧ branchGraph.layerOf 2 = 1 ∧ branchGraph.layerOf 3 = 2 ∧
    IonGraph.numLayers branchGraph = 13 ∧
    (IonGraph.layout branchGraph).valid ∧
    (IonGraph.layout branchGraph).nodes.length = 14 ∧
    branchBlades.getLast? = some pteFace ∧
    branchMovieFrames.length = 13 ∧
    LayoutNoOverlaps branchGraph :=
  ⟨branchGraph_root_forks, branchGraph_join, (branch_layers.2.1),
   (branch_layers.2.2.1), (branch_layers.2.2.2), branchGraph_numLayers, branchGraph_valid,
   branchGraph_node_count, branch_end, branchMovieFrames_length, branchGraph_layout_clean⟩

end MoonshineBranch
