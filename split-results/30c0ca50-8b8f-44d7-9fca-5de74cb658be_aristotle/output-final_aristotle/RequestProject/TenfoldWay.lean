import Mathlib
import RequestProject.BottPeriodicity

/-!
# The tenfold way: connecting the `ZMod 8` Bott grade to a condensed-matter model

This module answers the **condensed-matter** direction: connect the `ZMod 8` Bott
clock of `RequestProject/BottPeriodicity.lean` to a concrete free-fermion
topological-classification model — the **Altland–Zirnbauer tenfold way** and the
**periodic table of topological insulators and superconductors**.

The real Bott periodicity `ZMod 8` is exactly the spine of the tenfold way: the
eight *real* Altland–Zirnbauer symmetry classes sit around the Bott clock, and the
dimension-`0` topological invariant of each class is read off from the eightfold
**KO-theory** sequence

```
  KO_n(pt) :  ℤ , ℤ/2 , ℤ/2 , 0 , ℤ , 0 , 0 , 0      (n = 0,…,7 mod 8)
```

## What is formalized

* `AZClass` — the eight real Altland–Zirnbauer symmetry classes
  (`AI, BDI, D, DIII, AII, CII, C, CI`), each carrying time-reversal /
  particle-hole / chiral symmetry data (`AZClass.symmetry`).
* `azBott : AZClass → ZMod 8` and `bottAZ : ZMod 8 → AZClass` — the placement of
  the symmetry classes around the Bott clock, proved to be mutually inverse
  bijections (`azBott_bottAZ`, `bottAZ_azBott`, `azBott_bijective`).
* `koGroup : ZMod 8 → Type` — the **KO periodic table**: the topological-invariant
  group attached to each Bott grade (`ℤ`, `ZMod 2`, or the trivial group `PUnit`).
* `koGroup_periodic` / `azInvariant_period_eight` — the classification is
  **8-periodic**: it is invariant under `cartPow 8`, one full Bott cycle.
* `azStep` — advancing the engine by one cart steps to the next symmetry class
  around the tenfold-way clock, with `azStep_eight` closing the cycle.

Everything compiles and every `theorem` is fully proved (no `sorry`).
-/

open CategoryTheory CategoryTheory.MonoidalCategory

namespace Aristotle.Extension

/-! ## Symmetry data of a free-fermion Hamiltonian -/

/-- An antiunitary-symmetry sign: absent (`0`), or present squaring to `±1`. -/
inductive SymSign
  | absent
  | plus
  | minus
deriving DecidableEq, Repr

/-- The Altland–Zirnbauer symmetry data of a free-fermion Hamiltonian: the sign of
time-reversal symmetry `T`, the sign of particle-hole symmetry `C`, and whether the
chiral (sublattice) symmetry `S = T·C` is present. -/
structure AZSymmetry where
  /-- time-reversal sign `T² = ±1` (or absent) -/
  trs : SymSign
  /-- particle-hole sign `C² = ±1` (or absent) -/
  phs : SymSign
  /-- chiral symmetry `S` present? -/
  chiral : Bool
deriving DecidableEq, Repr

/-! ## The eight real Altland–Zirnbauer classes -/

/-- The eight **real** Altland–Zirnbauer symmetry classes — the part of the tenfold
way controlled by real Bott periodicity `ZMod 8`. -/
inductive AZClass
  | AI | BDI | D | DIII | AII | CII | C | CI
deriving DecidableEq, Repr

namespace AZClass

/-- The symmetry data defining each real Altland–Zirnbauer class. -/
def symmetry : AZClass → AZSymmetry
  | AI   => ⟨SymSign.plus,  SymSign.absent, false⟩
  | BDI  => ⟨SymSign.plus,  SymSign.plus,   true⟩
  | D    => ⟨SymSign.absent, SymSign.plus,  false⟩
  | DIII => ⟨SymSign.minus, SymSign.plus,   true⟩
  | AII  => ⟨SymSign.minus, SymSign.absent, false⟩
  | CII  => ⟨SymSign.minus, SymSign.minus,  true⟩
  | C    => ⟨SymSign.absent, SymSign.minus, false⟩
  | CI   => ⟨SymSign.plus,  SymSign.minus,  true⟩

end AZClass

/-! ## Placement around the Bott clock -/

/-- The placement of each real Altland–Zirnbauer class around the Bott clock
`ZMod 8`. -/
def azBott : AZClass → ZMod 8
  | AZClass.AI   => 0
  | AZClass.BDI  => 1
  | AZClass.D    => 2
  | AZClass.DIII => 3
  | AZClass.AII  => 4
  | AZClass.CII  => 5
  | AZClass.C    => 6
  | AZClass.CI   => 7

/-- The inverse placement: which symmetry class sits at a given Bott grade. -/
def bottAZ (n : ZMod 8) : AZClass :=
  match n.val with
  | 0 => AZClass.AI
  | 1 => AZClass.BDI
  | 2 => AZClass.D
  | 3 => AZClass.DIII
  | 4 => AZClass.AII
  | 5 => AZClass.CII
  | 6 => AZClass.C
  | _ => AZClass.CI

@[simp] theorem bottAZ_azBott (c : AZClass) : bottAZ (azBott c) = c := by
  cases c <;> rfl

@[simp] theorem azBott_bottAZ (n : ZMod 8) : azBott (bottAZ n) = n := by
  revert n; decide

/-- **The real Altland–Zirnbauer classes are exactly the Bott clock.**  The
placement `azBott` is a bijection between the eight real symmetry classes and
`ZMod 8`: the tenfold way (real part) *is* the eightfold Bott cycle. -/
theorem azBott_bijective : Function.Bijective azBott :=
  Function.bijective_iff_has_inverse.2 ⟨bottAZ, bottAZ_azBott, azBott_bottAZ⟩

/-! ## The KO periodic table of topological invariants -/

/-- **The KO periodic table.**  The topological-invariant group attached to a Bott
grade, following the eightfold KO-theory sequence
`ℤ, ℤ/2, ℤ/2, 0, ℤ, 0, 0, 0`.  The trivial group is modelled by `PUnit`. -/
def koGroup (n : ZMod 8) : Type :=
  match n.val with
  | 0 => ℤ
  | 1 => ZMod 2
  | 2 => ZMod 2
  | 4 => ℤ
  | _ => PUnit

/-- The topological invariant attached to a real Altland–Zirnbauer symmetry class. -/
def azInvariant (c : AZClass) : Type := koGroup (azBott c)

/-- A Bott grade is **topologically trivial** when its KO invariant is the trivial
group. -/
def koTrivial (n : ZMod 8) : Prop := koGroup n = PUnit

theorem koGroup_AI   : koGroup (azBott AZClass.AI)   = ℤ      := rfl
theorem koGroup_BDI  : koGroup (azBott AZClass.BDI)  = ZMod 2 := rfl
theorem koGroup_D    : koGroup (azBott AZClass.D)    = ZMod 2 := rfl
theorem koGroup_DIII : koGroup (azBott AZClass.DIII) = PUnit  := rfl
theorem koGroup_AII  : koGroup (azBott AZClass.AII)  = ℤ      := rfl
theorem koGroup_CII  : koGroup (azBott AZClass.CII)  = PUnit  := rfl
theorem koGroup_C    : koGroup (azBott AZClass.C)    = PUnit  := rfl
theorem koGroup_CI   : koGroup (azBott AZClass.CI)   = PUnit  := rfl

/-! ## Bott periodicity of the classification -/

/-- **8-periodicity of the KO table along the Bott grade of the engine.**  Reading
the invariant at the Bott grade of stage `m + 8` gives the same group as at stage
`m`: the topological classification is invariant under one full Bott cycle. -/
theorem koGroup_periodic (m : ℕ) :
    koGroup (bottGrade (m + 8)) = koGroup (bottGrade m) := by
  rw [bottGrade_periodic]

/-- **One full Bott cycle preserves the topological invariant.**  Running eight
parallel carts (`cartPow 8`) returns the KO classification to its starting group:
the periodic table of topological phases has period exactly the Bott period `8`. -/
theorem azInvariant_period_eight (k : ℕ) :
    koGroup (bottGrade ((cartPow 8).obj k)) = koGroup (bottGrade k) := by
  rw [cartPow_eight_bottGrade]

/-! ## Stepping the engine through the symmetry classes -/

/-- **One cart step moves to the next symmetry class.**  Advancing the engine by a
single cart rotates the tenfold-way clock by one, sending each real
Altland–Zirnbauer class to its successor around the cycle. -/
def azStep (c : AZClass) : AZClass := bottAZ (azBott c + 1)

/-- The cart step is recorded faithfully on the Bott clock: stepping a class
advances its Bott grade by one. -/
theorem azBott_azStep (c : AZClass) : azBott (azStep c) = azBott c + 1 := by
  rw [azStep, azBott_bottAZ]

/-- **Eight cart steps close the tenfold-way cycle.**  Applying the symmetry-class
step eight times returns to the original class — Bott periodicity realized on the
Altland–Zirnbauer classes themselves. -/
theorem azStep_eight (c : AZClass) : azStep^[8] c = c := by
  cases c <;> decide

end Aristotle.Extension
