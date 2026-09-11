import Lean

namespace AristotleWeaver.Core

/-!
# Standalone Aristotle Weaver Core - AST Integrated

This module integrates the `SimpleExpr` size invariants to dynamically
scale visual bounding envelopes, sealing the compile-time non-overlap proof.

The AST size of `sampleConfluenceNodeExpr` is used to compute the horizontal
spacing (`dx`) of the layout, so the verified structural size invariant
directly governs the geometry of the rendered graph nodes. Because that spacing
is large enough, the bounding boxes of all 14 graph objects are pairwise
disjoint across every animation frame.

## Notes on the provided source

Two minimal, faithful corrections were made to the originally-supplied snippet so
that it elaborates and the proofs go through:

* `Lean`/`Mathlib` core provides no `NatCast Float` instance, so the numeric
  coercions written as `(n : Float)` are realised explicitly via `Float.ofNat`.
* `Float` is an opaque, externally-implemented type whose comparisons do **not**
  reduce inside the kernel, so the layout theorem is discharged with
  `native_decide` (compiled evaluation) rather than `decide` (kernel reduction).
  This uses the standard `Lean.ofReduceBool` axiom.
-/

/-- Simplified miniature of the Lean AST expression constructors. -/
inductive SimpleExpr
  | bvar    : Nat → SimpleExpr
  | const   : String → List Nat → SimpleExpr
  | app     : SimpleExpr → SimpleExpr → SimpleExpr
  | lam     : String → SimpleExpr → SimpleExpr → SimpleExpr
  | forallE : String → SimpleExpr → SimpleExpr → SimpleExpr

/-- Computes the exact structural size (node count) of an expression. -/
def SimpleExpr.size : SimpleExpr → Nat
  | bvar _        => 1
  | const _ _     => 1
  | app f x       => f.size + x.size + 1
  | lam _ t b     => t.size + b.size + 1
  | forallE _ t b => t.size + b.size + 1

/-- Simulates an algebraic sample term representing the Prime-11 / Prime-23 confluence nodes. -/
def sampleConfluenceNodeExpr : SimpleExpr :=
  SimpleExpr.app (SimpleExpr.const "OggorialHub" []) (SimpleExpr.bvar 0)

/-- THEOREM: Structural Size Invariant
    Guarantees that the expression size evaluates stably to a positive non-zero value. -/
theorem sample_size_pos : sampleConfluenceNodeExpr.size = 3 := by rfl

/-- 2D bounding envelope for rendered nodes and labels in the SMIL animation. -/
structure BoundingBox where
  x : Float
  y : Float
  w : Float
  h : Float

/-- Strict coordinate-based spatial disjointness predicate. -/
def disjointBoxes (A B : BoundingBox) : Bool :=
  A.x + A.w < B.x ∨ B.x + B.w < A.x ∨
  A.y + A.h < B.y ∨ B.y + B.h < A.y

/-- Generates absolute 2D coordinate layouts for the Confluence Diamond nodes.
    The layout horizontal spacing scales dynamically based on the verified AST size invariant. -/
def nodeToBox (nodeId : Nat) (_frame : Nat) : BoundingBox :=
  let exprSizeMultiplier : Float := Float.ofNat sampleConfluenceNodeExpr.size * 60.0 -- Resolves to 180.0
  let dx : Float := exprSizeMultiplier
  let dy : Float := 80.0
  match nodeId with
  | 0 => ⟨400.0, 50.0, 60.0, 30.0⟩
  | 1 => ⟨400.0 - dx, 130.0, 60.0, 30.0⟩
  | 2 => ⟨400.0 + dx, 130.0, 60.0, 30.0⟩
  | 3 => ⟨400.0, 210.0, 70.0, 30.0⟩
  | n => ⟨400.0, 210.0 + (Float.ofNat n - 3.0) * dy, 60.0, 30.0⟩

/-- Predicate checking spatial separation across all 14 graph objects. -/
def layoutClean (frame : Nat) : Bool :=
  let nodes := List.range 14
  nodes.all fun u =>
    nodes.all fun v =>
      if u == v then true
      else disjointBoxes (nodeToBox u frame) (nodeToBox v frame)

/-- The layout is independent of the animation `frame`: every node's bounding box
    is determined purely by its `nodeId`, so the cleanliness of frame `f` is
    definitionally the cleanliness of frame `0`. -/
theorem layoutClean_const (f : Nat) : layoutClean f = layoutClean 0 := rfl

/-- THEOREM: Hard Compile-Time Non-Overlap Guard
    The 13 frames of the movie are all collision-free. The proof closes because the
    AST size invariant enforces an absolute horizontal split (`dx = 180`), keeping
    every pair of bounding boxes disjoint. -/
theorem branchGraph_layout_clean : ∀ f < 13, layoutClean f = true := by
  intro f _
  rw [layoutClean_const]
  native_decide

end AristotleWeaver.Core
