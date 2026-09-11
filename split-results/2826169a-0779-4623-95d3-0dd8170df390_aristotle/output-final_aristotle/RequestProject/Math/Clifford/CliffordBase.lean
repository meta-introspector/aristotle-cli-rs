/-
# CliffordBase — Core Definitions for Clifford Algebras Cl(0,n)

This file provides the foundational definitions used by all Clifford algebra files:
- `negDefForm n`: the standard negative-definite quadratic form Q(v) = -∑ᵢ vᵢ² on ℝⁿ
- `Cl0 n`: the canonical real Clifford algebra Cl(0,n)
- `stdBasis n i`: the standard basis vector eᵢ in ℝⁿ
- `negDefForm_basis`: Q(eᵢ) = -1
- `cl0_generator_sq`: ι(eᵢ)² = -1 in Cl(0,n)

It also provides the low-dimensional isomorphisms:
- `cl0_zero_equiv_real : Cl0 0 ≃ₐ[ℝ] ℝ`
- `cl0_one_equiv_complex : Cl0 1 ≃ₐ[ℝ] ℂ`
- `cl0_two_equiv_quaternion : Cl0 2 ≃ₐ[ℝ] Quaternion ℝ`

This file has NO dependencies on BottPeriodicity or any higher Clifford files,
ensuring an acyclic dependency graph.
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

/-! ## §2. Cl(0,0) ≃ₐ[ℝ] ℝ -/

/-- negDefForm 0 is the zero form (empty sum) -/
theorem negDefForm_zero_eq : negDefForm 0 = 0 := by
  ext v
  simp [negDefForm]

/-- The zero module (Fin 0 → ℝ) is isomorphic to Unit as a quadratic module -/
noncomputable def fin0_unit_isometry :
    (negDefForm 0).IsometryEquiv (0 : QuadraticForm ℝ Unit) where
  toLinearEquiv := {
    toFun := fun _ => ()
    map_add' := fun _ _ => rfl
    map_smul' := fun _ _ => rfl
    invFun := fun _ => (0 : Fin 0 → ℝ)
    left_inv := fun x => by ext i; exact i.elim0
    right_inv := fun x => by ext
  }
  map_app' := by
    intro v
    simp [negDefForm_zero_eq]

/-- Cl(0,0) ≃ₐ[ℝ] ℝ -/
noncomputable def cl0_zero_equiv_real : Cl0 0 ≃ₐ[ℝ] ℝ :=
  (CliffordAlgebra.equivOfIsometry fin0_unit_isometry).trans CliffordAlgebraRing.equiv

/-! ## §3. Cl(0,1) ≃ₐ[ℝ] ℂ -/

noncomputable def fin1_complex_isometry_base :
    (negDefForm 1).IsometryEquiv CliffordAlgebraComplex.Q where
  toLinearEquiv := {
    toFun := fun v => v 0
    map_add' := fun _ _ => rfl
    map_smul' := fun _ _ => rfl
    invFun := fun r => fun _ => r
    left_inv := fun v => by ext i; fin_cases i; rfl
    right_inv := fun _ => rfl
  }
  map_app' := by
    intro v
    simp [negDefForm, CliffordAlgebraComplex.Q, QuadraticMap.sq]

/-- Cl(0,1) ≃ₐ[ℝ] ℂ -/
noncomputable def cl0_one_equiv_complex : Cl0 1 ≃ₐ[ℝ] ℂ :=
  (CliffordAlgebra.equivOfIsometry fin1_complex_isometry_base).trans CliffordAlgebraComplex.equiv

/-! ## §4. Cl(0,2) ≃ₐ[ℝ] ℍ -/

noncomputable def fin2_quaternion_isometry :
    (negDefForm 2).IsometryEquiv (CliffordAlgebraQuaternion.Q (-1 : ℝ) (-1 : ℝ)) where
  toLinearEquiv := {
    toFun := fun v => (v 0, v 1)
    map_add' := fun _ _ => by simp [Prod.mk_add_mk]
    map_smul' := fun _ _ => by simp [Prod.smul_mk]
    invFun := fun p => ![p.1, p.2]
    left_inv := fun v => by ext i; fin_cases i <;> simp [Matrix.cons_val_zero, Matrix.cons_val_one]
    right_inv := fun ⟨a, b⟩ => by simp [Matrix.cons_val_zero, Matrix.cons_val_one]
  }
  map_app' := by
    intro v
    simp [negDefForm, CliffordAlgebraQuaternion.Q, QuadraticMap.sq, Fin.sum_univ_two]
    ring

/-- Cl(0,2) ≃ₐ[ℝ] ℍ -/
noncomputable def cl0_two_equiv_quaternion : Cl0 2 ≃ₐ[ℝ] Quaternion ℝ :=
  (CliffordAlgebra.equivOfIsometry fin2_quaternion_isometry).trans
    (CliffordAlgebraQuaternion.equiv (c₁ := (-1 : ℝ)) (c₂ := (-1 : ℝ)))
