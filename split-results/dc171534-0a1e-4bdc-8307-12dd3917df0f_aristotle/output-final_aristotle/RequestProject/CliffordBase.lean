/-
# CliffordBase — Core Definitions for Clifford Algebras Cl(0,n)

Provides foundational definitions used by all Clifford algebra files:
- `negDefForm n`: the standard negative-definite quadratic form Q(v) = -∑ᵢ vᵢ² on ℝⁿ
- `Cl0 n`: the canonical real Clifford algebra Cl(0,n)
- `stdBasis n i`: the standard basis vector eᵢ in ℝⁿ
- `negDefForm_basis`: Q(eᵢ) = -1
- `cl0_generator_sq`: ι(eᵢ)² = -1 in Cl(0,n)

Salvaged from meta-introspector/meta-meme discussion #23 (Aug 2023).
-/
import Mathlib

set_option maxHeartbeats 800000

open CliffordAlgebra

/-! ## §1. The Standard Negative-Definite Quadratic Form -/

/-- The standard negative-definite quadratic form on ℝⁿ: Q(v) = -∑ᵢ vᵢ² -/
noncomputable def negDefForm (n : ℕ) : QuadraticForm ℝ (Fin n → ℝ) :=
  -∑ i : Fin n, QuadraticMap.sq.comp (LinearMap.proj i)

/-- The canonical real Clifford algebra Cl(0,n) -/
noncomputable abbrev Cl0 (n : ℕ) := CliffordAlgebra (negDefForm n)

/-- The standard basis vector eᵢ in ℝⁿ -/
def stdBasis (n : ℕ) (i : Fin n) : Fin n → ℝ := Pi.single i 1

/-- The quadratic form on a basis vector gives -1: Q(eᵢ) = -1 -/
theorem negDefForm_basis (n : ℕ) (i : Fin n) :
    negDefForm n (stdBasis n i) = -1 := by
  simp only [negDefForm, stdBasis, QuadraticMap.sq, QuadraticMap.neg_apply, QuadraticMap.sum_apply,
    QuadraticMap.comp_apply, LinearMap.proj_apply]
  simp [Pi.single_apply, Finset.sum_ite_eq', Finset.mem_univ]

/-- The Clifford generator ι(eᵢ) squares to -1 in Cl(0,n) -/
theorem cl0_generator_sq (n : ℕ) (i : Fin n) :
    ι (negDefForm n) (stdBasis n i) * ι (negDefForm n) (stdBasis n i) =
    algebraMap ℝ (Cl0 n) (-1) := by
  rw [ι_sq_scalar]
  congr 1
  exact negDefForm_basis n i
