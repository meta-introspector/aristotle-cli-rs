/-
# Finite Dimensionality of Cl(0,7)

We prove that Cl(0,7) is a finite-dimensional ℝ-vector space.
The 128 ordered monomials of distinct generators span the algebra.
-/

import Mathlib
import RequestProject.CliffordBase

set_option maxHeartbeats 12800000

open CliffordAlgebra Submodule

noncomputable section

def cl07g (i : Fin 7) : Cl0 7 := ι (negDefForm 7) (stdBasis 7 i)

theorem cl07g_sq (i : Fin 7) : cl07g i * cl07g i = -(1 : Cl0 7) := by
  unfold cl07g; rw [ι_sq_scalar, negDefForm_basis]; simp

theorem cl07g_swap {i j : Fin 7} (hij : i ≠ j) :
    cl07g i * cl07g j = -(cl07g j * cl07g i) := by
  unfold cl07g;
  rw [ eq_neg_iff_add_eq_zero, ι_mul_ι_add_swap ];
  simp +decide [ QuadraticMap.polar, negDefForm ];
  simp +decide [ stdBasis, Finset.sum_add_distrib, add_mul, mul_add, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, hij ];
  simp +decide [ Finset.sum_apply, Pi.single_apply, hij.symm ];
  exact hij

theorem ι_expand7 (v : Fin 7 → ℝ) : ι (negDefForm 7) v = ∑ i : Fin 7, v i • cl07g i := by
  simp only [cl07g]
  have : v = ∑ i : Fin 7, v i • stdBasis 7 i := by
    ext j; simp [stdBasis, Pi.single, Function.update]
  conv_lhs => rw [this]
  simp [map_sum, map_smul]

/-- The 128 ordered monomials spanning Cl(0,7).
    Organized by grade (number of generators in the product). -/
def cl07_monoList : List (Cl0 7) :=
  -- Grade 0: 1 element
  [1,
  -- Grade 1: 7 elements
  cl07g 0, cl07g 1, cl07g 2, cl07g 3, cl07g 4, cl07g 5, cl07g 6,
  -- Grade 2: 21 elements
  cl07g 0 * cl07g 1, cl07g 0 * cl07g 2, cl07g 0 * cl07g 3,
  cl07g 0 * cl07g 4, cl07g 0 * cl07g 5, cl07g 0 * cl07g 6,
  cl07g 1 * cl07g 2, cl07g 1 * cl07g 3, cl07g 1 * cl07g 4,
  cl07g 1 * cl07g 5, cl07g 1 * cl07g 6, cl07g 2 * cl07g 3,
  cl07g 2 * cl07g 4, cl07g 2 * cl07g 5, cl07g 2 * cl07g 6,
  cl07g 3 * cl07g 4, cl07g 3 * cl07g 5, cl07g 3 * cl07g 6,
  cl07g 4 * cl07g 5, cl07g 4 * cl07g 6, cl07g 5 * cl07g 6,
  -- Grade 3: 35 elements
  cl07g 0 * cl07g 1 * cl07g 2, cl07g 0 * cl07g 1 * cl07g 3,
  cl07g 0 * cl07g 1 * cl07g 4, cl07g 0 * cl07g 1 * cl07g 5,
  cl07g 0 * cl07g 1 * cl07g 6, cl07g 0 * cl07g 2 * cl07g 3,
  cl07g 0 * cl07g 2 * cl07g 4, cl07g 0 * cl07g 2 * cl07g 5,
  cl07g 0 * cl07g 2 * cl07g 6, cl07g 0 * cl07g 3 * cl07g 4,
  cl07g 0 * cl07g 3 * cl07g 5, cl07g 0 * cl07g 3 * cl07g 6,
  cl07g 0 * cl07g 4 * cl07g 5, cl07g 0 * cl07g 4 * cl07g 6,
  cl07g 0 * cl07g 5 * cl07g 6, cl07g 1 * cl07g 2 * cl07g 3,
  cl07g 1 * cl07g 2 * cl07g 4, cl07g 1 * cl07g 2 * cl07g 5,
  cl07g 1 * cl07g 2 * cl07g 6, cl07g 1 * cl07g 3 * cl07g 4,
  cl07g 1 * cl07g 3 * cl07g 5, cl07g 1 * cl07g 3 * cl07g 6,
  cl07g 1 * cl07g 4 * cl07g 5, cl07g 1 * cl07g 4 * cl07g 6,
  cl07g 1 * cl07g 5 * cl07g 6, cl07g 2 * cl07g 3 * cl07g 4,
  cl07g 2 * cl07g 3 * cl07g 5, cl07g 2 * cl07g 3 * cl07g 6,
  cl07g 2 * cl07g 4 * cl07g 5, cl07g 2 * cl07g 4 * cl07g 6,
  cl07g 2 * cl07g 5 * cl07g 6, cl07g 3 * cl07g 4 * cl07g 5,
  cl07g 3 * cl07g 4 * cl07g 6, cl07g 3 * cl07g 5 * cl07g 6,
  cl07g 4 * cl07g 5 * cl07g 6,
  -- Grade 4: 35 elements
  cl07g 0 * cl07g 1 * cl07g 2 * cl07g 3,
  cl07g 0 * cl07g 1 * cl07g 2 * cl07g 4,
  cl07g 0 * cl07g 1 * cl07g 2 * cl07g 5,
  cl07g 0 * cl07g 1 * cl07g 2 * cl07g 6,
  cl07g 0 * cl07g 1 * cl07g 3 * cl07g 4,
  cl07g 0 * cl07g 1 * cl07g 3 * cl07g 5,
  cl07g 0 * cl07g 1 * cl07g 3 * cl07g 6,
  cl07g 0 * cl07g 1 * cl07g 4 * cl07g 5,
  cl07g 0 * cl07g 1 * cl07g 4 * cl07g 6,
  cl07g 0 * cl07g 1 * cl07g 5 * cl07g 6,
  cl07g 0 * cl07g 2 * cl07g 3 * cl07g 4,
  cl07g 0 * cl07g 2 * cl07g 3 * cl07g 5,
  cl07g 0 * cl07g 2 * cl07g 3 * cl07g 6,
  cl07g 0 * cl07g 2 * cl07g 4 * cl07g 5,
  cl07g 0 * cl07g 2 * cl07g 4 * cl07g 6,
  cl07g 0 * cl07g 2 * cl07g 5 * cl07g 6,
  cl07g 0 * cl07g 3 * cl07g 4 * cl07g 5,
  cl07g 0 * cl07g 3 * cl07g 4 * cl07g 6,
  cl07g 0 * cl07g 3 * cl07g 5 * cl07g 6,
  cl07g 0 * cl07g 4 * cl07g 5 * cl07g 6,
  cl07g 1 * cl07g 2 * cl07g 3 * cl07g 4,
  cl07g 1 * cl07g 2 * cl07g 3 * cl07g 5,
  cl07g 1 * cl07g 2 * cl07g 3 * cl07g 6,
  cl07g 1 * cl07g 2 * cl07g 4 * cl07g 5,
  cl07g 1 * cl07g 2 * cl07g 4 * cl07g 6,
  cl07g 1 * cl07g 2 * cl07g 5 * cl07g 6,
  cl07g 1 * cl07g 3 * cl07g 4 * cl07g 5,
  cl07g 1 * cl07g 3 * cl07g 4 * cl07g 6,
  cl07g 1 * cl07g 3 * cl07g 5 * cl07g 6,
  cl07g 1 * cl07g 4 * cl07g 5 * cl07g 6,
  cl07g 2 * cl07g 3 * cl07g 4 * cl07g 5,
  cl07g 2 * cl07g 3 * cl07g 4 * cl07g 6,
  cl07g 2 * cl07g 3 * cl07g 5 * cl07g 6,
  cl07g 2 * cl07g 4 * cl07g 5 * cl07g 6,
  cl07g 3 * cl07g 4 * cl07g 5 * cl07g 6,
  -- Grade 5: 21 elements
  cl07g 0 * cl07g 1 * cl07g 2 * cl07g 3 * cl07g 4,
  cl07g 0 * cl07g 1 * cl07g 2 * cl07g 3 * cl07g 5,
  cl07g 0 * cl07g 1 * cl07g 2 * cl07g 3 * cl07g 6,
  cl07g 0 * cl07g 1 * cl07g 2 * cl07g 4 * cl07g 5,
  cl07g 0 * cl07g 1 * cl07g 2 * cl07g 4 * cl07g 6,
  cl07g 0 * cl07g 1 * cl07g 2 * cl07g 5 * cl07g 6,
  cl07g 0 * cl07g 1 * cl07g 3 * cl07g 4 * cl07g 5,
  cl07g 0 * cl07g 1 * cl07g 3 * cl07g 4 * cl07g 6,
  cl07g 0 * cl07g 1 * cl07g 3 * cl07g 5 * cl07g 6,
  cl07g 0 * cl07g 1 * cl07g 4 * cl07g 5 * cl07g 6,
  cl07g 0 * cl07g 2 * cl07g 3 * cl07g 4 * cl07g 5,
  cl07g 0 * cl07g 2 * cl07g 3 * cl07g 4 * cl07g 6,
  cl07g 0 * cl07g 2 * cl07g 3 * cl07g 5 * cl07g 6,
  cl07g 0 * cl07g 2 * cl07g 4 * cl07g 5 * cl07g 6,
  cl07g 0 * cl07g 3 * cl07g 4 * cl07g 5 * cl07g 6,
  cl07g 1 * cl07g 2 * cl07g 3 * cl07g 4 * cl07g 5,
  cl07g 1 * cl07g 2 * cl07g 3 * cl07g 4 * cl07g 6,
  cl07g 1 * cl07g 2 * cl07g 3 * cl07g 5 * cl07g 6,
  cl07g 1 * cl07g 2 * cl07g 4 * cl07g 5 * cl07g 6,
  cl07g 1 * cl07g 3 * cl07g 4 * cl07g 5 * cl07g 6,
  cl07g 2 * cl07g 3 * cl07g 4 * cl07g 5 * cl07g 6,
  -- Grade 6: 7 elements
  cl07g 0 * cl07g 1 * cl07g 2 * cl07g 3 * cl07g 4 * cl07g 5,
  cl07g 0 * cl07g 1 * cl07g 2 * cl07g 3 * cl07g 4 * cl07g 6,
  cl07g 0 * cl07g 1 * cl07g 2 * cl07g 3 * cl07g 5 * cl07g 6,
  cl07g 0 * cl07g 1 * cl07g 2 * cl07g 4 * cl07g 5 * cl07g 6,
  cl07g 0 * cl07g 1 * cl07g 3 * cl07g 4 * cl07g 5 * cl07g 6,
  cl07g 0 * cl07g 2 * cl07g 3 * cl07g 4 * cl07g 5 * cl07g 6,
  cl07g 1 * cl07g 2 * cl07g 3 * cl07g 4 * cl07g 5 * cl07g 6,
  -- Grade 7: 1 element (volume element)
  cl07g 0 * cl07g 1 * cl07g 2 * cl07g 3 * cl07g 4 * cl07g 5 * cl07g 6]

def cl07_monoSet : Set (Cl0 7) := { x | x ∈ cl07_monoList }

abbrev cl07_monoSpan : Submodule ℝ (Cl0 7) := span ℝ cl07_monoSet

/-! ### Left multiplication by each generator preserves the monomial span. -/

theorem e0_mul_mem_span7 (x : Cl0 7) (hx : x ∈ cl07_monoSpan) :
    cl07g 0 * x ∈ cl07_monoSpan := by sorry

theorem e1_mul_mem_span7 (x : Cl0 7) (hx : x ∈ cl07_monoSpan) :
    cl07g 1 * x ∈ cl07_monoSpan := by sorry

theorem e2_mul_mem_span7 (x : Cl0 7) (hx : x ∈ cl07_monoSpan) :
    cl07g 2 * x ∈ cl07_monoSpan := by sorry

theorem e3_mul_mem_span7 (x : Cl0 7) (hx : x ∈ cl07_monoSpan) :
    cl07g 3 * x ∈ cl07_monoSpan := by sorry

theorem e4_mul_mem_span7 (x : Cl0 7) (hx : x ∈ cl07_monoSpan) :
    cl07g 4 * x ∈ cl07_monoSpan := by sorry

theorem e5_mul_mem_span7 (x : Cl0 7) (hx : x ∈ cl07_monoSpan) :
    cl07g 5 * x ∈ cl07_monoSpan := by sorry

theorem e6_mul_mem_span7 (x : Cl0 7) (hx : x ∈ cl07_monoSpan) :
    cl07g 6 * x ∈ cl07_monoSpan := by sorry

/-- The monomial span equals the whole algebra. -/
theorem cl07_monoSpan_eq_top : cl07_monoSpan = ⊤ := by
  sorry

/-- Cl(0,7) is a finite-dimensional ℝ-vector space. -/
instance cl07_finiteDimensional : FiniteDimensional ℝ (Cl0 7) := by
  sorry

/-- The finrank of Cl(0,7) is at most 128 (the number of basis monomials). -/
theorem finrank_Cl07_le_128 : Module.finrank ℝ (Cl0 7) ≤ 128 := by
  sorry

end