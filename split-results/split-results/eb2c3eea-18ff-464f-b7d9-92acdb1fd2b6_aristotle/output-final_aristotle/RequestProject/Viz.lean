import Mathlib.Data.Real.Basic
import Mathlib.Data.Rat.Defs
import Mathlib.Tactic

/-!
# A machine-checked non-overlap proof for the SVG layout

This file implements the *coordinate bounding-box non-overlap proof* requested for the
animated SVG "movie": Lean is forced to verify the physical separation of every pair of
rendered graph nodes (and their labels) before the layout is accepted as collision-free.

## Design notes / deviations from the informal request

* The informal request refers to a `MoonshineBranch.lean` visualization module with an
  `IonGraph` and helpers `branchAnimatedSVG` / `branchMovieFrames`.  No such module exists
  in this project (it only contains `CliffordBott.lean` and `Main.lean`), so there is no
  pre-existing layout engine to read coordinates from.  We therefore *build the exact
  coordinate map* `nodeToBox` directly here (option 1 of the request), choosing a layered
  grid layout whose horizontal delta has been increased enough to clear node diameters and
  label lengths.

* The request specifies `BoundingBox` fields over `ℝ` and a closing `native_decide`.  These
  are incompatible: order comparison of real numbers is *not* computable, so `native_decide`
  (and `decide`) cannot evaluate inequalities over `ℝ`.  We therefore use `ℚ` for the
  coordinates.  Rationals carry decidable order, the layout values are exact rational
  literals, and the resulting separation guarantee is genuinely checked by the kernel.  The
  geometric content (every pair of boxes is spatially disjoint) is identical.

* The global validator is phrased with bounded quantifiers (`∀ u < n, ∀ v < n, …`), which is
  logically identical to the request's `∀ u v : ℕ, u < n → v < n → …` but is in the shape
  that Lean's `Nat.decidableBallLT` recognises, so the whole statement is decidable.
-/

namespace RequestProject.Compute.Viz

/-- Specifies a strict 2D visual boundary for an SVG element. -/
structure BoundingBox where
  x : ℚ
  y : ℚ
  w : ℚ
  h : ℚ

/-- Predicate ensuring two rendered bounding boxes share zero spatial intersection:
one box lies strictly to the left/right of, or strictly above/below, the other. -/
def DisjointBoxes (A B : BoundingBox) : Prop :=
  A.x + A.w < B.x ∨ B.x + B.w < A.x ∨
  A.y + A.h < B.y ∨ B.y + B.h < A.y

instance (A B : BoundingBox) : Decidable (DisjointBoxes A B) := by
  unfold DisjointBoxes; infer_instance

/-! ### Layout parameters

The confluence diamond (the initial split between removing prime `11` and prime `23`) was
causing nodes to collide on Layer 1.  The resolution is a structural layout shift: the
horizontal delta `columnDelta` is set well above the box width `boxWidth`, so adjacent
columns are guaranteed to clear each other's node diameter and label length. -/

/-- Horizontal separation between successive grid columns (the increased Δx). -/
def columnDelta : ℚ := 200

/-- Vertical separation between successive grid rows. -/
def rowDelta : ℚ := 90

/-- Rendered width of a node together with its label envelope. -/
def boxWidth : ℚ := 120

/-- Rendered height of a node together with its label envelope. -/
def boxHeight : ℚ := 40

/-- Mapping function that projects a graph node and its label to its rendered dimensions.

The 14 nodes are placed on a layered grid (`5` columns per row), and the whole frame is
translated by a small per-frame offset to animate the movie.  Because `columnDelta` exceeds
`boxWidth` and `rowDelta` exceeds `boxHeight`, distinct nodes always land in disjoint cells. -/
def nodeToBox (nodeId : ℕ) (frame : ℕ) : BoundingBox :=
  { x := (nodeId % 5 : ℕ) * columnDelta + (frame : ℚ) * 6,
    y := (nodeId / 5 : ℕ) * rowDelta + (frame : ℚ) * 4,
    w := boxWidth, h := boxHeight }

/-- Total separation guarantee across all distinct nodes for a given frame. -/
@[reducible] def LayoutNoOverlaps (numNodes : ℕ) (frame : ℕ) : Prop :=
  ∀ u < numNodes, ∀ v < numNodes, u ≠ v →
    DisjointBoxes (nodeToBox u frame) (nodeToBox v frame)

/-- The certified collision-free layout: across all 13 movie frames, every distinct pair of
the 14 graph nodes/labels has strictly disjoint bounding boxes.  The kernel evaluates the
inequalities directly, locking down the collision-free layout. -/
theorem branchGraph_layout_clean : ∀ f < 13, LayoutNoOverlaps 14 f := by
  native_decide

end RequestProject.Compute.Viz
