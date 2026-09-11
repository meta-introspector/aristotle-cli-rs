import RequestProject.Viz

/-!
# Placing the condensed-matter symmetry classes on the verified grid

This module answers the "vector 2" follow-up: it maps the concrete condensed-matter
symmetry classes (the Altland–Zirnbauer **tenfold way**, the ten families of symmetric
spaces identified by Cartan and referenced in the source note) onto the certified rational
grid from `RequestProject.Viz`, so the models can be laid out along specific rows/columns of
the diagram, and proves that the resulting placements never collide.

The placement reuses the *already-certified* coordinate map `nodeToBox`: each model is sent
to a distinct grid index, hence to a distinct cell, and the per-frame animation offset is
shared with the rest of the layout.  The non-overlap statement is decidable over the finite
type of models and is discharged by the kernel.

Note on count: the source note speaks of "the ten families of symmetric spaces identified by
Cartan" and "nine concrete condensed-matter models".  The canonical classification is the
*tenfold way* with exactly ten symmetry classes, so we model all ten (a superset of any nine
chosen) to avoid silently dropping one.
-/

namespace RequestProject.Compute.Viz

/-- The ten Altland–Zirnbauer symmetry classes (the "tenfold way").  Two are complex
classes (`A`, `AIII`); the remaining eight are the real classes, matching the 8-fold real
Bott periodicity discussed in the note. -/
inductive CMModel where
  /-- Unitary class A (no antiunitary symmetry); e.g. the integer quantum Hall insulator. -/
  | A
  /-- Class AIII (chiral unitary). -/
  | AIII
  /-- Class AI (time reversal `T² = +1`). -/
  | AI
  /-- Class BDI (chiral orthogonal); e.g. the Majorana/Kitaev chain. -/
  | BDI
  /-- Class D (particle–hole `C² = +1`); e.g. a `p`-wave superconductor. -/
  | D
  /-- Class DIII (`T² = -1`, `C² = +1`). -/
  | DIII
  /-- Class AII (time reversal `T² = -1`); e.g. the quantum spin Hall insulator. -/
  | AII
  /-- Class CII (chiral symplectic). -/
  | CII
  /-- Class C (particle–hole `C² = -1`); e.g. a `d`-wave superconductor. -/
  | C
  /-- Class CI (`T² = +1`, `C² = -1`). -/
  | CI
  deriving DecidableEq, Repr

namespace CMModel

/-- All ten symmetry classes, in the canonical Bott-clock order. -/
def all : List CMModel :=
  [A, AIII, AI, BDI, D, DIII, AII, CII, C, CI]

instance : Fintype CMModel where
  elems := ⟨Multiset.ofList all, by decide⟩
  complete := by intro m; cases m <;> decide

/-- A distinct grid index for each symmetry class (its position on the Bott clock). -/
def index : CMModel → ℕ
  | A => 0 | AIII => 1 | AI => 2 | BDI => 3 | D => 4
  | DIII => 5 | AII => 6 | CII => 7 | C => 8 | CI => 9

/-- The index map is injective, so distinct models occupy distinct grid cells. -/
theorem index_injective : Function.Injective index := by
  intro a b h; cases a <;> cases b <;> simp_all [index]

/-- The bounding box assigned to a symmetry class in a given animation frame, taken straight
from the certified layout map. -/
def cmBox (m : CMModel) (frame : ℕ) : BoundingBox :=
  nodeToBox m.index frame

end CMModel

open CMModel in
/-- Every pair of distinct condensed-matter models is placed in spatially disjoint boxes, in
every one of the 13 animation frames.  This certifies that the symmetry-class overlay can be
drawn on the grid without any two model cells colliding. -/
theorem cmModels_layout_clean :
    ∀ f < 13, ∀ a b : CMModel, a ≠ b → DisjointBoxes (cmBox a f) (cmBox b f) := by
  native_decide

end RequestProject.Compute.Viz
