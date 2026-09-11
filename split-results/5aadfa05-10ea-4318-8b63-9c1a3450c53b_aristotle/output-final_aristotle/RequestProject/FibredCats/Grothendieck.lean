import Mathlib
import RequestProject.AZ.TenfoldWay
import RequestProject.AZ.BladeClassify
import RequestProject.AZ.SpectralReduction
import RequestProject.AZ.Examples

/-!
# A fibred category of Altland–Zirnbauer phases (the Grothendieck construction)

This file builds the **fibred-category bridge** requested as a follow-up to the
Altland–Zirnbauer (AZ) tenfold-way development: it organises the AZ topological
phases into a genuine *fibred category* over a base "parameter" category of
spatial dimensions, via Mathlib's **Grothendieck construction**
(`CategoryTheory.Grothendieck`).

## The picture

* The **base category** is the spatial dimension axis `ℕ`, regarded as a thin
  (preorder) category: there is a unique morphism `d ⟶ d'` exactly when `d ≤ d'`.
  A morphism is a *dimensional trajectory* increasing the spatial dimension.
* The **fibre** over every dimension is the discrete category `Discrete Class` on
  the ten AZ symmetry classes — at every dimension all ten classes are available,
  and there are no morphisms between distinct classes.
* The **total category** `PhaseCat := Grothendieck phaseFunctor` (often written
  `∫ F`) has, as objects, *phases* `(d, c)` — an AZ class `c` realised in spatial
  dimension `d` — and, as morphisms, the dimensional trajectories that keep the
  class fixed.

The projection `Grothendieck.forget : PhaseCat ⥤ ℕ` is the *fibration projection*
sending each phase to its spatial dimension; this exhibits the AZ phases as a
fibred category over the dimension base.

## What is proved

* `forget_obj_phase`: the projection reads off the dimension of a phase.
* `PhaseCat.kInvariant`: the topological invariant group of a phase, read off the
  periodic table `classify`; `phase_kInvariant` identifies it.
* `traj`, `bottTrajectory`: dimensional trajectories as morphisms in `PhaseCat`,
  including the canonical Bott period-`8` trajectory.
* `kInvariant_bott8` / `kInvariant_bott2_complex`: **Bott periodicity along a
  trajectory** — the invariant is unchanged after an `8`-step (real) or, for the
  complex classes, a `2`-step trajectory.
* `PhaseCat.blade`, `blade_kGroupN_eq_kInvariant`: each phase carries a Clifford
  self-blade whose integer-indexed higher K-theory reproduces the phase invariant,
  realising "families of `Blade` trajectories over the base parameter space".
* `CMModel.toPhase`, `toPhase_kInvariant`: every named condensed-matter model of
  `RequestProject.AZ.Examples` is a phase object of this fibred category, with the
  expected invariant.
* `instance : IsFibered (Grothendieck.forget phaseFunctor)`: the projection is a
  **fibered category** in the sense of `CategoryTheory.Functor.IsFibered`.
-/

open CategoryTheory

namespace AZ

/-! ## The base, fibre and total category -/

/-- The base "parameter" category of the fibred construction: the spatial
dimension axis `ℕ`, regarded as a thin (preorder) category. -/
abbrev DimBase := ℕ

/-- The fibre functor of the construction: constantly the discrete category on the
ten Altland–Zirnbauer symmetry classes.  Every dimension carries the same fibre
(all ten classes), and the (unique) base morphisms act trivially. -/
def phaseFunctor : DimBase ⥤ Cat :=
  (Functor.const DimBase).obj (Cat.of (Discrete Class))

/-- The **fibred category of Altland–Zirnbauer phases**: the Grothendieck
construction `∫ phaseFunctor` of the dimension-indexed family of symmetry
classes.  Objects are phases `(d, c)`; morphisms are dimensional trajectories. -/
abbrev PhaseCat := Grothendieck phaseFunctor

/-- The phase object `(d, c)`: the symmetry class `c` realised in spatial
dimension `d`. -/
def phase (c : Class) (d : ℕ) : PhaseCat := ⟨d, Discrete.mk c⟩

@[simp] theorem phase_base (c : Class) (d : ℕ) : (phase c d).base = d := rfl

@[simp] theorem phase_fiber_as (c : Class) (d : ℕ) : (phase c d).fiber.as = c := rfl

/-! ## The fibration projection -/

/-- The fibration projection `PhaseCat ⥤ ℕ` reads off the spatial dimension of a
phase. -/
theorem forget_obj_phase (c : Class) (d : ℕ) :
    (Grothendieck.forget phaseFunctor).obj (phase c d) = d := rfl

/-! ## Topological invariant of a phase -/

/-- The topological-invariant group of a phase, read off the periodic table
`classify` at the phase's class and dimension. -/
def PhaseCat.kInvariant (X : PhaseCat) : KGroup := classify X.fiber.as X.base

@[simp] theorem phase_kInvariant (c : Class) (d : ℕ) :
    (phase c d).kInvariant = classify c d := rfl

/-! ## Trajectories: morphisms in the fibred category

A *dimensional trajectory* keeps the symmetry class fixed and increases the
spatial dimension.  Because the fibre is discrete, a morphism of `PhaseCat`
between two phases of the *same* class is exactly such a trajectory. -/

/-- A dimensional trajectory `phase c d ⟶ phase c d'` for `d ≤ d'`: it keeps the
symmetry class `c` fixed while moving the spatial dimension up from `d` to `d'`. -/
def traj (c : Class) {d d' : ℕ} (h : d ≤ d') : phase c d ⟶ phase c d' where
  base := homOfLE h
  fiber := 𝟙 _

/-- The canonical **Bott trajectory**: an `8`-step dimensional trajectory, the
real Bott period. -/
def bottTrajectory (c : Class) (d : ℕ) : phase c d ⟶ phase c (d + 8) :=
  traj c (Nat.le_add_right d 8)

/-- **Bott periodicity along a trajectory (period 8).** The topological invariant
is unchanged after the `8`-step Bott trajectory. -/
theorem kInvariant_bott8 (c : Class) (d : ℕ) :
    (phase c (d + 8)).kInvariant = (phase c d).kInvariant := by
  simp [classify_periodic8]

/-- **Bott periodicity along a trajectory (period 2), complex classes.** For the
two complex classes the invariant is already unchanged after a `2`-step
trajectory. -/
theorem kInvariant_bott2_complex (c : Class) (hc : c.isComplex = true) (d : ℕ) :
    (phase c (d + 2)).kInvariant = (phase c d).kInvariant := by
  simp [classify_periodic2_complex c hc]

/-! ## Families of Clifford blades over the base

Each phase carries a Clifford self-blade; its integer-indexed higher K-theory
reproduces the phase invariant.  This realises the AZ "blade trajectories" as a
family living over the dimension base. -/

/-- The Clifford self-blade attached to a phase: the self-blade of its symmetry
class. -/
def PhaseCat.blade (X : PhaseCat) : Blade := selfBlade X.fiber.as

/-- The integer-indexed higher K-theory of a phase's Clifford blade reproduces the
phase's topological invariant. -/
theorem blade_kGroupN_eq_kInvariant (c : Class) (d : ℕ) :
    (phase c d).blade.kGroupN (d : ℤ) = (phase c d).kInvariant := by
  rw [phase_kInvariant]
  exact selfBlade_kGroupN c d

/-! ## Condensed-matter models as phase objects

Every named model of `RequestProject.AZ.Examples` is an object of the fibred
category, sitting over its spatial dimension with the expected invariant. -/

/-- A named condensed-matter model, viewed as a phase object of the fibred
category. -/
def CMModel.toPhase (M : CMModel) : PhaseCat := phase M.cls M.dim

@[simp] theorem CMModel.toPhase_kInvariant (M : CMModel) :
    M.toPhase.kInvariant = M.kGroup := rfl

/-- Each model sits over its declared spatial dimension. -/
theorem CMModel.forget_toPhase (M : CMModel) :
    (Grothendieck.forget phaseFunctor).obj M.toPhase = M.dim := rfl

/-- The quantum spin Hall model lands on the `ℤ₂` invariant as a phase object. -/
example : quantumSpinHall.toPhase.kInvariant = KGroup.Z2 := by decide

/-! ## The Grothendieck construction is a fibered category

Finally, we record that the projection `Grothendieck.forget phaseFunctor` is a
fibered category in the sense of `CategoryTheory.Functor.IsFibered`: every
morphism of the base lifts to a (strongly) Cartesian dimensional trajectory.

Since the fibre functor is constant (its action on morphisms is the identity
functor), the covariant Grothendieck construction is here both fibered and
opfibered, and the explicit Cartesian lift of `f : R ⟶ S` to the target phase
`⟨S, x⟩` is the morphism with base `f` and identity fibre component. -/

/-- The explicit Cartesian lift of a base morphism `f : R ⟶ S` with target the
phase `⟨S, x⟩`: it has base `f` and identity fibre component (possible because the
fibre functor is constant). -/
def cartLift {R S : ℕ} (x : Discrete Class) (f : R ⟶ S) :
    (⟨R, x⟩ : PhaseCat) ⟶ ⟨S, x⟩ where
  base := f
  fiber := 𝟙 _

/-- The explicit lift `cartLift x f` is strongly Cartesian for the fibration
projection. -/
theorem isStronglyCartesian_cartLift {R S : ℕ} (x : Discrete Class) (f : R ⟶ S) :
    (Grothendieck.forget phaseFunctor).IsStronglyCartesian f (cartLift x f) where
  toIsHomLift := .map (cartLift x f)
  universal_property' := by
    intro a' g φ' hφ'
    have hbase : φ'.base = g ≫ f := by
      have := CategoryTheory.IsHomLift.fac (Grothendieck.forget phaseFunctor) (g ≫ f) φ'
      simpa using this.symm
    haveI hss : Subsingleton (a'.fiber ⟶ x) :=
      CategoryTheory.Discrete.instSubsingletonDiscreteHom _ _
    let χ : a' ⟶ (⟨R, x⟩ : PhaseCat) := ⟨g, φ'.fiber⟩
    refine ⟨χ, ⟨.map χ, ?_⟩, ?_⟩
    · refine Grothendieck.ext _ _ ?_ ?_
      · simp only [Grothendieck.comp_base]
        exact hbase.symm
      · exact @Subsingleton.elim (a'.fiber ⟶ x) hss _ _
    · intro χ' hχ'
      haveI := hχ'.1
      refine Grothendieck.ext _ _ ?_ ?_
      · have := CategoryTheory.IsHomLift.fac (Grothendieck.forget phaseFunctor) g χ'
        simpa using this.symm
      · exact @Subsingleton.elim (a'.fiber ⟶ x) hss _ _

instance : (Grothendieck.forget phaseFunctor).IsFibered :=
  Functor.IsFibered.of_exists_isStronglyCartesian (fun a R f =>
    ⟨⟨R, a.fiber⟩, cartLift a.fiber f, isStronglyCartesian_cartLift a.fiber f⟩)

end AZ
