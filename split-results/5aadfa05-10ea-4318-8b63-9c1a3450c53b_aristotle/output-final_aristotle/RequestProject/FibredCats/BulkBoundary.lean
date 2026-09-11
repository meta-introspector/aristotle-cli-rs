import Mathlib
import RequestProject.AZ.TenfoldWay
import RequestProject.AZ.BladeClassify
import RequestProject.AZ.SpectralReduction
import RequestProject.FibredCats.Grothendieck

/-!
# The bulk–boundary correspondence for Altland–Zirnbauer phases

This file wires the **domain-wall theorems** of `RequestProject.AZ.SpectralReduction`
(the `activateNeg` gap-closing / Bott-clock advancing event) to the **bulk phase
objects** of the fibred category `PhaseCat` built in
`RequestProject.FibredCats.Grothendieck`.

## The dimensional hierarchy

In the periodic table `classify c d = realPattern (realIndex c - d)` (resp. the
period-`2` complex pattern), the classifying group depends on the class and the
dimension only through the **Bott index** `realIndex c - d`.  Cells with a constant
Bott index lie on a *diagonal*: the cell `(c, d + 1)` and the cell
`(boundaryClass c, d)` carry the *same* topological invariant, where
`boundaryClass c` is the AZ class sitting one step *back* on the Bott clock.

Physically this is the **bulk–boundary correspondence**: the boundary (surface) of a
`(d+1)`-dimensional bulk in symmetry class `c` is a `d`-dimensional anomalous system
whose classification is that of `boundaryClass c` in dimension `d`, and it is
non-trivial exactly when the bulk is non-trivial.

## Wiring the domain wall

The inverse move along the diagonal — going from the boundary cell back up to the
bulk cell — is exactly a **domain wall**: `Blade.activateNeg` turns a massless
direction into a massive `-1` generator, advancing the Bott clock by one
(`activateNeg_realIndex_succ`).  We prove
`activateNeg_selfBlade_boundaryClass`: activating a domain wall on the Clifford
self-blade of the *boundary* class recovers the *bulk* class.  Lifted to phase
objects this is `boundary_blade_activateNeg`: the domain wall on a boundary phase's
Clifford blade reproduces the bulk phase's symmetry class.

## What is proved

* `boundaryClass`, `boundaryClass_isComplex`, `boundaryClass_realIndex`,
  `boundaryClass_complexIndex`: the boundary class and its Bott-clock position.
* `classify_boundary`: the diagonal invariant identity
  `classify (boundaryClass c) d = classify c (d + 1)`.
* `PhaseCat.boundary`: the boundary phase object (one dimension lower, in the
  boundary class).
* `boundary_kInvariant`: **bulk–boundary correspondence** — the boundary phase and
  the bulk phase have equal topological invariants.
* `boundary_nontrivial_iff`: the boundary is (anomalously) non-trivial iff the bulk
  is non-trivial.
* `activateNeg_selfBlade_boundaryClass` / `boundary_blade_activateNeg`: the
  domain-wall (`activateNeg`) recovery of the bulk class from the boundary blade.
* Worked examples: the 2D Chern insulator (`A`) and its 1D chiral edge (`AIII`),
  and the 3D `AII` topological insulator and its 2D `DIII` anomalous surface.
-/

open CategoryTheory

namespace AZ

open Class

/-! ## The boundary symmetry class -/

/-- The **boundary class** of an AZ class `c`: the class sitting one step *back* on
the Bott clock (`ℤ₈` for real classes, `ℤ₂` for complex classes).  The boundary of a
`(d+1)`-dimensional class-`c` bulk is a `d`-dimensional system of this class. -/
def boundaryClass (c : Class) : Class :=
  if c.isComplex then fromIndex2 (c.complexIndex - 1) else fromIndex8 (c.realIndex - 1)

/-- The boundary class lives over the same ground field as the bulk class. -/
@[simp] theorem boundaryClass_isComplex (c : Class) :
    (boundaryClass c).isComplex = c.isComplex := by
  cases hc : c.isComplex <;> simp [boundaryClass, hc]

/-- The boundary of a real class sits one step back on the `ℤ₈` Bott clock. -/
theorem boundaryClass_realIndex (c : Class) (hc : c.isComplex = false) :
    (boundaryClass c).realIndex = c.realIndex - 1 := by
  rw [boundaryClass, if_neg (by simp [hc]), realIndex_fromIndex8]

/-- The boundary of a complex class sits one step back on the `ℤ₂` Bott clock. -/
theorem boundaryClass_complexIndex (c : Class) (hc : c.isComplex = true) :
    (boundaryClass c).complexIndex = c.complexIndex - 1 := by
  rw [boundaryClass, if_pos hc, complexIndex_fromIndex2]

/-! ## The diagonal invariant identity -/

/-- **The dimensional hierarchy / diagonal identity.**  The boundary cell
`(boundaryClass c, d)` and the bulk cell `(c, d + 1)` carry the same classifying
group: shifting the dimension up by one and the Bott clock back by one cancel. -/
theorem classify_boundary (c : Class) (d : ℕ) :
    classify (boundaryClass c) d = classify c (d + 1) := by
  rcases hc : c.isComplex with _ | _
  · have hb : (boundaryClass c).isComplex = false := by rw [boundaryClass_isComplex, hc]
    rw [classify, classify, if_neg (by simp [hb]), if_neg (by simp [hc]),
        boundaryClass_realIndex c hc]
    congr 1
    push_cast; ring
  · have hb : (boundaryClass c).isComplex = true := by rw [boundaryClass_isComplex, hc]
    rw [classify, classify, if_pos (by simp [hb]), if_pos (by simp [hc]),
        boundaryClass_complexIndex c hc]
    congr 1
    push_cast; ring

/-! ## Boundary phase objects in the fibred category -/

/-- The **boundary phase** of a bulk phase `X`: one spatial dimension lower, in the
boundary symmetry class.  (`X.base - 1` uses truncated subtraction; the intended
inputs are bulks of positive dimension `d + 1`.) -/
def PhaseCat.boundary (X : PhaseCat) : PhaseCat :=
  phase (boundaryClass X.fiber.as) (X.base - 1)

@[simp] theorem boundary_base_succ (c : Class) (d : ℕ) :
    ((phase c (d + 1)).boundary).base = d := rfl

@[simp] theorem boundary_fiber_succ (c : Class) (d : ℕ) :
    ((phase c (d + 1)).boundary).fiber.as = boundaryClass c := rfl

/-- The boundary phase sits one spatial dimension below the bulk. -/
theorem forget_boundary_succ (c : Class) (d : ℕ) :
    (Grothendieck.forget phaseFunctor).obj ((phase c (d + 1)).boundary) = d := rfl

/-- **Bulk–boundary correspondence.**  The topological invariant of the boundary
phase equals the topological invariant of the bulk phase. -/
theorem boundary_kInvariant (c : Class) (d : ℕ) :
    ((phase c (d + 1)).boundary).kInvariant = (phase c (d + 1)).kInvariant :=
  classify_boundary c d

/-- **The boundary is anomalously non-trivial iff the bulk is non-trivial.** -/
theorem boundary_nontrivial_iff (c : Class) (d : ℕ) :
    ((phase c (d + 1)).boundary).kInvariant ≠ KGroup.null ↔
      (phase c (d + 1)).kInvariant ≠ KGroup.null := by
  rw [boundary_kInvariant]

/-! ## Wiring the domain wall to the bulk class -/

/-- **Domain-wall recovery (real classes).**  Activating a domain wall
(`Blade.activateNeg`, advancing the Bott clock by one) on the Clifford self-blade of
the *boundary* class recovers the *bulk* class. -/
theorem activateNeg_selfBlade_boundaryClass (c : Class) (hc : c.isComplex = false) :
    (selfBlade (boundaryClass c)).activateNeg.nearestClass = c := by
  revert hc; cases c <;> decide

/-- **Domain-wall recovery (complex classes).** -/
theorem activateNeg_selfBlade_boundaryClass_complex (c : Class) (hc : c.isComplex = true) :
    (selfBlade (boundaryClass c)).activateNeg.nearestClass = c := by
  revert hc; cases c <;> decide

/-- **Bulk–boundary domain wall on phase objects.**  Starting from the boundary
phase's Clifford blade and creating a domain wall recovers the bulk phase's symmetry
class.  This wires the `activateNeg` domain-wall theorem directly to the bulk phase
objects of the fibred category. -/
theorem boundary_blade_activateNeg (c : Class) (hc : c.isComplex = false) (d : ℕ) :
    ((phase c (d + 1)).boundary).blade.activateNeg.nearestClass = c :=
  activateNeg_selfBlade_boundaryClass c hc

/-! ## Worked examples

The boundary class swaps `A ↔ AIII` (period `2`) and steps the real clock back by one,
e.g. `AII ↦ DIII`. -/

/-- The boundary class of the complex unitary class `A` is `AIII`. -/
example : boundaryClass Class.A = Class.AIII := by decide

/-- The boundary class of the symplectic class `AII` is `DIII`. -/
example : boundaryClass Class.AII = Class.DIII := by decide

/-- **2D Chern insulator → 1D chiral edge.**  The boundary of a 2D class-`A`
(integer quantum Hall / Chern) insulator with its `ℤ` invariant is a 1D class-`AIII`
chiral mode, also carrying a `ℤ` invariant. -/
example : ((phase Class.A 2).boundary).kInvariant = KGroup.Z := by decide

example : ((phase Class.A 2).boundary).kInvariant = (phase Class.A 2).kInvariant := by
  decide

/-- **3D AII topological insulator → 2D anomalous surface.**  The boundary of the 3D
class-`AII` strong topological insulator (a `ℤ₂` invariant) is a 2D class-`DIII`
anomalous surface, also `ℤ₂`. -/
example : ((phase Class.AII 3).boundary).kInvariant = KGroup.Z2 := by decide

example : ((phase Class.AII 3).boundary).kInvariant = (phase Class.AII 3).kInvariant := by
  decide

end AZ
