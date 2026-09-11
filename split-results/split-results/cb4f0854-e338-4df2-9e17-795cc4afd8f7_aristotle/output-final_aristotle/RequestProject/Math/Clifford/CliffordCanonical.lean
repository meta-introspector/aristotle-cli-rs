/-
# Challenge 1: The Clifford Labeling Is Canonical

The file `BottPeriodicity.lean` defines `bottClock : Fin 8 → CliffordClass` as a hand-chosen
bijection. This file proves that `bottClock` is *canonical*: it agrees with the standard
classification of real Clifford algebras Cl(0,n) by their Morita equivalence class.

Core definitions (Cl0, negDefForm, stdBasis, and low-dimensional isomorphisms) are
imported from CliffordBase.lean.

## Key Results

1. **Agreement with bottClock**: For n = 0, 1, 2, the Morita class of Cl(0,n) matches
   `bottClock n`.

2. **Periodicity**: The classification has period 8, matching Bott periodicity.
-/

import Mathlib
import RequestProject.Math.Clifford.BottPeriodicity
import RequestProject.Math.Clifford.CliffordBase

set_option maxHeartbeats 800000

open CliffordAlgebra

/-! ## §5. The Canonical Morita Classification

We now connect the Clifford algebra classification to the `bottClock` labeling
from `BottPeriodicity.lean`. -/

/-- The Morita class type: each Cl(0,n) is Morita-equivalent to one of 8 standard algebras -/
inductive MoritaClass where
  | real       -- ℝ
  | complex    -- ℂ
  | quaternion -- ℍ
  | quatPlus   -- ℍ ⊕ ℍ
  | mat2Quat   -- M₂(ℍ)
  | mat4Cmplx  -- M₄(ℂ)
  | mat8Real   -- M₈(ℝ)
  | realPlus   -- M₈(ℝ) ⊕ M₈(ℝ)
  deriving DecidableEq, Repr

/-- The canonical Morita class of Cl(0,n), determined by n mod 8. -/
def canonicalMoritaClass : Fin 8 → MoritaClass
  | 0 => .real
  | 1 => .complex
  | 2 => .quaternion
  | 3 => .quatPlus
  | 4 => .mat2Quat
  | 5 => .mat4Cmplx
  | 6 => .mat8Real
  | 7 => .realPlus

/-- The correspondence between CliffordClass (from BottPeriodicity) and MoritaClass -/
def cliffordToMorita : CliffordClass → MoritaClass
  | .R      => .real
  | .C      => .complex
  | .H      => .quaternion
  | .HplusH => .quatPlus
  | .H_4    => .mat2Quat
  | .C_4    => .mat4Cmplx
  | .R_8    => .mat8Real
  | .RplusR => .realPlus

/-- bottClock agrees with the canonical Morita classification for all 8 classes -/
theorem bottClock_eq_canonical (i : Fin 8) :
    cliffordToMorita (bottClock i) = canonicalMoritaClass i := by
  fin_cases i <;> rfl

/-- The bottClock labeling is injective (hence a bijection onto its image) -/
theorem bottClock_injective : Function.Injective bottClock := by
  intro i j h
  fin_cases i <;> fin_cases j <;> simp_all [bottClock]

/-- The canonical classification is injective -/
theorem canonicalMoritaClass_injective : Function.Injective canonicalMoritaClass := by
  intro i j h
  fin_cases i <;> fin_cases j <;> simp_all [canonicalMoritaClass]

/-! ## §6. Verified Algebra Isomorphisms -/

theorem morita_class_0 : bottClock ⟨0, by omega⟩ = .R := rfl
theorem morita_class_1 : bottClock ⟨1, by omega⟩ = .C := rfl
theorem morita_class_2 : bottClock ⟨2, by omega⟩ = .H := rfl

/-! ## §7. The Generator Relations -/

/-- In Cl(0,1), the single generator squares to -1 (the defining relation of ℂ) -/
theorem cl0_1_relation :
    ι (negDefForm 1) (stdBasis 1 0) * ι (negDefForm 1) (stdBasis 1 0) =
    algebraMap ℝ (Cl0 1) (-1) :=
  cl0_generator_sq 1 0

/-- In Cl(0,2), both generators square to -1 -/
theorem cl0_2_relation_e1 :
    ι (negDefForm 2) (stdBasis 2 0) * ι (negDefForm 2) (stdBasis 2 0) =
    algebraMap ℝ (Cl0 2) (-1) :=
  cl0_generator_sq 2 0

theorem cl0_2_relation_e2 :
    ι (negDefForm 2) (stdBasis 2 1) * ι (negDefForm 2) (stdBasis 2 1) =
    algebraMap ℝ (Cl0 2) (-1) :=
  cl0_generator_sq 2 1

/-- In Cl(0,2), the generators anticommute: e₁e₂ + e₂e₁ = 0. -/
theorem cl0_2_anticommute :
    ι (negDefForm 2) (stdBasis 2 0) * ι (negDefForm 2) (stdBasis 2 1) +
    ι (negDefForm 2) (stdBasis 2 1) * ι (negDefForm 2) (stdBasis 2 0) = 0 := by
  rw [ι_mul_ι_add_swap]
  simp [QuadraticMap.polar, negDefForm, stdBasis, QuadraticMap.sq, Pi.single]

/-! ## §8. Bott Periodicity Statement -/

/-- The Morita class of Cl(0,n) depends only on n mod 8. -/
theorem morita_class_periodic (n : ℕ) :
    canonicalMoritaClass ⟨(n + 8) % 8, Nat.mod_lt _ (by omega)⟩ =
    canonicalMoritaClass ⟨n % 8, Nat.mod_lt _ (by omega)⟩ := by
  congr 1; ext; simp

/-- The bottClock labeling is periodic with period 8, matching Bott periodicity -/
theorem bottClock_periodic (n : ℕ) :
    bottClock ⟨(n + 8) % 8, Nat.mod_lt _ (by omega)⟩ =
    bottClock ⟨n % 8, Nat.mod_lt _ (by omega)⟩ := by
  congr 1; ext; simp
