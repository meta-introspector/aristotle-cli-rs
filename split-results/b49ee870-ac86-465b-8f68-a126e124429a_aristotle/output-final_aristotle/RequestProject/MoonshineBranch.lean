import Mathlib

open scoped BigOperators

set_option maxHeartbeats 8000000

/-!
# Spatial Non-Overlap Guard for the MoonshineBranch Animation

This file formalizes the geometric bounding-box layout guard used to guarantee
that the diamond confluence nodes of the animated SMIL movie never overlap.

The blueprint states the geometry over the real numbers (`BoundingBox` with
`ℝ`-valued fields).  Because comparisons on `ℝ` are *not* decidable / computable,
`native_decide` cannot be used to discharge the disjointness theorem over the
reals.  We therefore keep the faithful `ℝ`-valued definitions exactly as
specified and prove the non-overlap theorem with a genuine, kernel-checked
argument instead.

The layout places node `nodeId` at horizontal position `180 · nodeId` with a box
width of `100 < 180`, so distinct nodes are always strictly separated along the
`x`-axis; the per-frame vertical offset `80 · frame` keeps frames stacked but
does not affect intra-frame disjointness.
-/

namespace RequestProject.Compute.Viz

/-- Exact 2D envelope of an SVG node or text identifier. -/
structure BoundingBox where
  x : ℝ
  y : ℝ
  w : ℝ
  h : ℝ

/-- The core strict disjointness condition for two shapes: one box lies
strictly to the left/right of, or strictly above/below, the other. -/
def DisjointBoxes (A B : BoundingBox) : Prop :=
  A.x + A.w < B.x ∨ B.x + B.w < A.x ∨
  A.y + A.h < B.y ∨ B.y + B.h < A.y

/-- The verified node-separation constant (in SVG units).  Shifting the node
spacing from its colliding default to `180` units guarantees clearance, since
the box width (`100`) is strictly smaller. -/
def sepConst : ℝ := 180

/-- The (fixed) width of every diamond/text node box. -/
def nodeWidth : ℝ := 100

/-- The (fixed) height of every diamond/text node box. -/
def nodeHeight : ℝ := 50

/-- Maps a node to its 2D coordinate box, scaling horizontal spread by the
verified safety/separation factor `sepConst = 180`.  The vertical position is
offset per animation frame so successive frames are stacked. -/
def nodeToBoxFrame (nodeId : ℕ) (frame : ℕ) : BoundingBox where
  x := sepConst * (nodeId : ℝ)
  y := 80 * (frame : ℝ)
  w := nodeWidth
  h := nodeHeight

/-- Global spatial verification predicate across the 14 confluence diamond
nodes: every pair of distinct nodes has strictly disjoint bounding boxes. -/
def ConfluenceLayoutClean (f : ℕ) : Prop :=
  ∀ u v : ℕ, u < 14 → v < 14 → u ≠ v →
    DisjointBoxes (nodeToBoxFrame u f) (nodeToBoxFrame v f)

/-- Any two distinct nodes in the same frame are horizontally separated: their
bounding boxes are strictly disjoint.  This is the core clearance lemma — it
holds for *all* node indices, independent of the `< 14` bound and of the frame. -/
theorem nodeToBoxFrame_disjoint (u v f : ℕ) (huv : u ≠ v) :
    DisjointBoxes (nodeToBoxFrame u f) (nodeToBoxFrame v f) := by
  rcases Nat.lt_or_ge u v with h | h
  · -- u < v : box `u` lies strictly to the left of box `v`.
    left
    simp only [nodeToBoxFrame, sepConst, nodeWidth]
    have hv : (u : ℝ) + 1 ≤ (v : ℝ) := by exact_mod_cast h
    nlinarith [hv]
  · -- v < u : box `v` lies strictly to the left of box `u`.
    have h' : v < u := lt_of_le_of_ne h (by simpa [eq_comm] using huv)
    right; left
    simp only [nodeToBoxFrame, sepConst, nodeWidth]
    have hu : (v : ℝ) + 1 ≤ (u : ℝ) := by exact_mod_cast h'
    nlinarith [hu]

/-- **Structural theorem.**  All 13 animation frames are entirely free of
overlaps: across every frame `f < 13`, the layout of the 14 confluence diamond
nodes is collision-free.

(The blueprint suggested `native_decide`, but the bounding boxes are real-valued
and real comparisons are not computable, so a genuine kernel-checked proof is
used instead.) -/
theorem branchGraph_layout_clean : ∀ f < 13, ConfluenceLayoutClean f := by
  intro f _ u v _ _ huv
  exact nodeToBoxFrame_disjoint u v f huv

end RequestProject.Compute.Viz
