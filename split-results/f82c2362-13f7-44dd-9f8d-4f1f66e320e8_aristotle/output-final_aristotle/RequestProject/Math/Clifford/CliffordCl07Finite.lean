/-
# Finite Dimensionality of Cl(0,7)

We prove that Cl(0,7) is a finite-dimensional ℝ-vector space.
The 128 ordered monomials of distinct generators span the algebra.
-/

import Mathlib
import RequestProject.Math.Clifford.CliffordBase

set_option maxHeartbeats 200000000

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
    cl07g 0 * x ∈ cl07_monoSpan := by
  revert x hx; intro x hx
  apply Submodule.span_induction at hx
  all_goals simp_all +decide [ Submodule.span ];
  case p => exact fun x hx => ∀ p : Submodule ℝ ( Cl0 7 ), cl07_monoSet ⊆ p → cl07g 0 * x ∈ p;
  · exact hx;
  · intro x hx p hp
    rcases hx with ( rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl );
    all_goals repeat' rw [ ← mul_assoc ];
    all_goals repeat' rw [ ← mul_assoc ];
    all_goals repeat' rw [ cl07g_sq ] ; norm_num [ hp ] ;
    all_goals try simp_all +decide [ mul_assoc, cl07g_swap ( show (0 : Fin 7) ≠ 1 by decide ), cl07g_swap ( show (0 : Fin 7) ≠ 2 by decide ), cl07g_swap ( show (0 : Fin 7) ≠ 3 by decide ), cl07g_swap ( show (0 : Fin 7) ≠ 4 by decide ), cl07g_swap ( show (0 : Fin 7) ≠ 5 by decide ), cl07g_swap ( show (0 : Fin 7) ≠ 6 by decide ) ];
    all_goals try simp_all +decide [ ← mul_assoc, cl07g_sq ];
    all_goals try simp_all +decide [ mul_assoc, cl07g_swap ( show (0 : Fin 7) ≠ 1 by decide ), cl07g_swap ( show (0 : Fin 7) ≠ 2 by decide ), cl07g_swap ( show (0 : Fin 7) ≠ 3 by decide ), cl07g_swap ( show (0 : Fin 7) ≠ 4 by decide ), cl07g_swap ( show (0 : Fin 7) ≠ 5 by decide ), cl07g_swap ( show (0 : Fin 7) ≠ 6 by decide ) ];
    all_goals try simp_all +decide [ ← mul_assoc, cl07g_sq ];
    all_goals try simp_all +decide only [cl07_monoSet];
    all_goals try simp_all +decide only [Set.insert_subset_iff, Set.singleton_subset_iff];
    all_goals aesop ( simp_config := { singlePass := true } ) ;
  · aesop;
  · exact fun x y hx hy hx' hy' p hp => by simpa only [ mul_add ] using p.add_mem ( hx' p hp ) ( hy' p hp ) ;
  · exact fun a x hx hx' p hp => by simpa [ mul_smul_comm ] using p.smul_mem a ( hx' p hp ) ;


theorem e1_mul_mem_span7 (x : Cl0 7) (hx : x ∈ cl07_monoSpan) :
    cl07g 1 * x ∈ cl07_monoSpan := by
  revert x hx; intro x hx
  apply Submodule.span_induction at hx
  all_goals simp_all +decide [ Submodule.span ];
  case p => exact fun x hx => ∀ p : Submodule ℝ ( Cl0 7 ), cl07_monoSet ⊆ p → cl07g 1 * x ∈ p;
  · exact hx;
  · intro x hx p hp
    rcases hx with ( rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl );
    all_goals repeat' rw [ ← mul_assoc ];
    all_goals repeat' rw [ ← mul_assoc ];
    all_goals repeat' rw [ cl07g_sq ] ; norm_num [ hp ] ;
    all_goals try simp_all +decide [ mul_assoc, cl07g_swap ( show (1 : Fin 7) ≠ 0 by decide ), cl07g_swap ( show (1 : Fin 7) ≠ 2 by decide ), cl07g_swap ( show (1 : Fin 7) ≠ 3 by decide ), cl07g_swap ( show (1 : Fin 7) ≠ 4 by decide ), cl07g_swap ( show (1 : Fin 7) ≠ 5 by decide ), cl07g_swap ( show (1 : Fin 7) ≠ 6 by decide ) ];
    all_goals try simp_all +decide [ ← mul_assoc, cl07g_sq ];
    all_goals try simp_all +decide [ mul_assoc, cl07g_swap ( show (1 : Fin 7) ≠ 0 by decide ), cl07g_swap ( show (1 : Fin 7) ≠ 2 by decide ), cl07g_swap ( show (1 : Fin 7) ≠ 3 by decide ), cl07g_swap ( show (1 : Fin 7) ≠ 4 by decide ), cl07g_swap ( show (1 : Fin 7) ≠ 5 by decide ), cl07g_swap ( show (1 : Fin 7) ≠ 6 by decide ) ];
    all_goals try simp_all +decide [ ← mul_assoc, cl07g_sq ];
    all_goals try simp_all +decide only [cl07_monoSet];
    all_goals try simp_all +decide only [Set.insert_subset_iff, Set.singleton_subset_iff];
    all_goals aesop ( simp_config := { singlePass := true } ) ;
  · aesop;
  · exact fun x y hx hy hx' hy' p hp => by simpa only [ mul_add ] using p.add_mem ( hx' p hp ) ( hy' p hp ) ;
  · exact fun a x hx hx' p hp => by simpa [ mul_smul_comm ] using p.smul_mem a ( hx' p hp ) ;


theorem e2_mul_mem_span7 (x : Cl0 7) (hx : x ∈ cl07_monoSpan) :
    cl07g 2 * x ∈ cl07_monoSpan := by
  revert x hx; intro x hx
  apply Submodule.span_induction at hx
  all_goals simp_all +decide [ Submodule.span ];
  case p => exact fun x hx => ∀ p : Submodule ℝ ( Cl0 7 ), cl07_monoSet ⊆ p → cl07g 2 * x ∈ p;
  · exact hx;
  · intro x hx p hp
    rcases hx with ( rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl );
    all_goals repeat' rw [ ← mul_assoc ];
    all_goals repeat' rw [ ← mul_assoc ];
    all_goals repeat' rw [ cl07g_sq ] ; norm_num [ hp ] ;
    all_goals try simp_all +decide [ mul_assoc, cl07g_swap ( show (2 : Fin 7) ≠ 0 by decide ), cl07g_swap ( show (2 : Fin 7) ≠ 1 by decide ), cl07g_swap ( show (2 : Fin 7) ≠ 3 by decide ), cl07g_swap ( show (2 : Fin 7) ≠ 4 by decide ), cl07g_swap ( show (2 : Fin 7) ≠ 5 by decide ), cl07g_swap ( show (2 : Fin 7) ≠ 6 by decide ) ];
    all_goals try simp_all +decide [ ← mul_assoc, cl07g_sq ];
    all_goals try simp_all +decide [ mul_assoc, cl07g_swap ( show (2 : Fin 7) ≠ 0 by decide ), cl07g_swap ( show (2 : Fin 7) ≠ 1 by decide ), cl07g_swap ( show (2 : Fin 7) ≠ 3 by decide ), cl07g_swap ( show (2 : Fin 7) ≠ 4 by decide ), cl07g_swap ( show (2 : Fin 7) ≠ 5 by decide ), cl07g_swap ( show (2 : Fin 7) ≠ 6 by decide ) ];
    all_goals try simp_all +decide [ ← mul_assoc, cl07g_sq ];
    all_goals try simp_all +decide only [cl07_monoSet];
    all_goals try simp_all +decide only [Set.insert_subset_iff, Set.singleton_subset_iff];
    all_goals aesop ( simp_config := { singlePass := true } ) ;
  · aesop;
  · exact fun x y hx hy hx' hy' p hp => by simpa only [ mul_add ] using p.add_mem ( hx' p hp ) ( hy' p hp ) ;
  · exact fun a x hx hx' p hp => by simpa [ mul_smul_comm ] using p.smul_mem a ( hx' p hp ) ;


theorem e3_mul_mem_span7 (x : Cl0 7) (hx : x ∈ cl07_monoSpan) :
    cl07g 3 * x ∈ cl07_monoSpan := by
  revert x hx; intro x hx
  apply Submodule.span_induction at hx
  all_goals simp_all +decide [ Submodule.span ];
  case p => exact fun x hx => ∀ p : Submodule ℝ ( Cl0 7 ), cl07_monoSet ⊆ p → cl07g 3 * x ∈ p;
  · exact hx;
  · intro x hx p hp
    rcases hx with ( rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl );
    all_goals repeat' rw [ ← mul_assoc ];
    all_goals repeat' rw [ ← mul_assoc ];
    all_goals repeat' rw [ cl07g_sq ] ; norm_num [ hp ] ;
    all_goals try simp_all +decide [ mul_assoc, cl07g_swap ( show (3 : Fin 7) ≠ 0 by decide ), cl07g_swap ( show (3 : Fin 7) ≠ 1 by decide ), cl07g_swap ( show (3 : Fin 7) ≠ 2 by decide ), cl07g_swap ( show (3 : Fin 7) ≠ 4 by decide ), cl07g_swap ( show (3 : Fin 7) ≠ 5 by decide ), cl07g_swap ( show (3 : Fin 7) ≠ 6 by decide ) ];
    all_goals try simp_all +decide [ ← mul_assoc, cl07g_sq ];
    all_goals try simp_all +decide [ mul_assoc, cl07g_swap ( show (3 : Fin 7) ≠ 0 by decide ), cl07g_swap ( show (3 : Fin 7) ≠ 1 by decide ), cl07g_swap ( show (3 : Fin 7) ≠ 2 by decide ), cl07g_swap ( show (3 : Fin 7) ≠ 4 by decide ), cl07g_swap ( show (3 : Fin 7) ≠ 5 by decide ), cl07g_swap ( show (3 : Fin 7) ≠ 6 by decide ) ];
    all_goals try simp_all +decide [ ← mul_assoc, cl07g_sq ];
    all_goals try simp_all +decide only [cl07_monoSet];
    all_goals try simp_all +decide only [Set.insert_subset_iff, Set.singleton_subset_iff];
    all_goals aesop ( simp_config := { singlePass := true } ) ;
  · aesop;
  · exact fun x y hx hy hx' hy' p hp => by simpa only [ mul_add ] using p.add_mem ( hx' p hp ) ( hy' p hp ) ;
  · exact fun a x hx hx' p hp => by simpa [ mul_smul_comm ] using p.smul_mem a ( hx' p hp ) ;


theorem e4_mul_mem_span7 (x : Cl0 7) (hx : x ∈ cl07_monoSpan) :
    cl07g 4 * x ∈ cl07_monoSpan := by
  revert x hx; intro x hx
  apply Submodule.span_induction at hx
  all_goals simp_all +decide [ Submodule.span ];
  case p => exact fun x hx => ∀ p : Submodule ℝ ( Cl0 7 ), cl07_monoSet ⊆ p → cl07g 4 * x ∈ p;
  · exact hx;
  · intro x hx p hp
    rcases hx with ( rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl );
    all_goals repeat' rw [ ← mul_assoc ];
    all_goals repeat' rw [ ← mul_assoc ];
    all_goals repeat' rw [ cl07g_sq ] ; norm_num [ hp ] ;
    all_goals try simp_all +decide [ mul_assoc, cl07g_swap ( show (4 : Fin 7) ≠ 0 by decide ), cl07g_swap ( show (4 : Fin 7) ≠ 1 by decide ), cl07g_swap ( show (4 : Fin 7) ≠ 2 by decide ), cl07g_swap ( show (4 : Fin 7) ≠ 3 by decide ), cl07g_swap ( show (4 : Fin 7) ≠ 5 by decide ), cl07g_swap ( show (4 : Fin 7) ≠ 6 by decide ) ];
    all_goals try simp_all +decide [ ← mul_assoc, cl07g_sq ];
    all_goals try simp_all +decide [ mul_assoc, cl07g_swap ( show (4 : Fin 7) ≠ 0 by decide ), cl07g_swap ( show (4 : Fin 7) ≠ 1 by decide ), cl07g_swap ( show (4 : Fin 7) ≠ 2 by decide ), cl07g_swap ( show (4 : Fin 7) ≠ 3 by decide ), cl07g_swap ( show (4 : Fin 7) ≠ 5 by decide ), cl07g_swap ( show (4 : Fin 7) ≠ 6 by decide ) ];
    all_goals try simp_all +decide [ ← mul_assoc, cl07g_sq ];
    all_goals try simp_all +decide only [cl07_monoSet];
    all_goals try simp_all +decide only [Set.insert_subset_iff, Set.singleton_subset_iff];
    all_goals aesop ( simp_config := { singlePass := true } ) ;
  · aesop;
  · exact fun x y hx hy hx' hy' p hp => by simpa only [ mul_add ] using p.add_mem ( hx' p hp ) ( hy' p hp ) ;
  · exact fun a x hx hx' p hp => by simpa [ mul_smul_comm ] using p.smul_mem a ( hx' p hp ) ;


theorem e5_mul_mem_span7 (x : Cl0 7) (hx : x ∈ cl07_monoSpan) :
    cl07g 5 * x ∈ cl07_monoSpan := by
  revert x hx; intro x hx
  apply Submodule.span_induction at hx
  all_goals simp_all +decide [ Submodule.span ];
  case p => exact fun x hx => ∀ p : Submodule ℝ ( Cl0 7 ), cl07_monoSet ⊆ p → cl07g 5 * x ∈ p;
  · exact hx;
  · intro x hx p hp
    rcases hx with ( rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl );
    all_goals repeat' rw [ ← mul_assoc ];
    all_goals repeat' rw [ ← mul_assoc ];
    all_goals repeat' rw [ cl07g_sq ] ; norm_num [ hp ] ;
    all_goals try simp_all +decide [ mul_assoc, cl07g_swap ( show (5 : Fin 7) ≠ 0 by decide ), cl07g_swap ( show (5 : Fin 7) ≠ 1 by decide ), cl07g_swap ( show (5 : Fin 7) ≠ 2 by decide ), cl07g_swap ( show (5 : Fin 7) ≠ 3 by decide ), cl07g_swap ( show (5 : Fin 7) ≠ 4 by decide ), cl07g_swap ( show (5 : Fin 7) ≠ 6 by decide ) ];
    all_goals try simp_all +decide [ ← mul_assoc, cl07g_sq ];
    all_goals try simp_all +decide [ mul_assoc, cl07g_swap ( show (5 : Fin 7) ≠ 0 by decide ), cl07g_swap ( show (5 : Fin 7) ≠ 1 by decide ), cl07g_swap ( show (5 : Fin 7) ≠ 2 by decide ), cl07g_swap ( show (5 : Fin 7) ≠ 3 by decide ), cl07g_swap ( show (5 : Fin 7) ≠ 4 by decide ), cl07g_swap ( show (5 : Fin 7) ≠ 6 by decide ) ];
    all_goals try simp_all +decide [ ← mul_assoc, cl07g_sq ];
    all_goals try simp_all +decide only [cl07_monoSet];
    all_goals try simp_all +decide only [Set.insert_subset_iff, Set.singleton_subset_iff];
    all_goals aesop ( simp_config := { singlePass := true } ) ;
  · aesop;
  · exact fun x y hx hy hx' hy' p hp => by simpa only [ mul_add ] using p.add_mem ( hx' p hp ) ( hy' p hp ) ;
  · exact fun a x hx hx' p hp => by simpa [ mul_smul_comm ] using p.smul_mem a ( hx' p hp ) ;


theorem e6_mul_mem_span7 (x : Cl0 7) (hx : x ∈ cl07_monoSpan) :
    cl07g 6 * x ∈ cl07_monoSpan := by
  revert x hx; intro x hx
  apply Submodule.span_induction at hx
  all_goals simp_all +decide [ Submodule.span ];
  case p => exact fun x hx => ∀ p : Submodule ℝ ( Cl0 7 ), cl07_monoSet ⊆ p → cl07g 6 * x ∈ p;
  · exact hx;
  · intro x hx p hp
    rcases hx with ( rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl );
    all_goals repeat' rw [ ← mul_assoc ];
    all_goals repeat' rw [ ← mul_assoc ];
    all_goals repeat' rw [ cl07g_sq ] ; norm_num [ hp ] ;
    all_goals try simp_all +decide [ mul_assoc, cl07g_swap ( show (6 : Fin 7) ≠ 0 by decide ), cl07g_swap ( show (6 : Fin 7) ≠ 1 by decide ), cl07g_swap ( show (6 : Fin 7) ≠ 2 by decide ), cl07g_swap ( show (6 : Fin 7) ≠ 3 by decide ), cl07g_swap ( show (6 : Fin 7) ≠ 4 by decide ), cl07g_swap ( show (6 : Fin 7) ≠ 5 by decide ) ];
    all_goals try simp_all +decide [ ← mul_assoc, cl07g_sq ];
    all_goals try simp_all +decide [ mul_assoc, cl07g_swap ( show (6 : Fin 7) ≠ 0 by decide ), cl07g_swap ( show (6 : Fin 7) ≠ 1 by decide ), cl07g_swap ( show (6 : Fin 7) ≠ 2 by decide ), cl07g_swap ( show (6 : Fin 7) ≠ 3 by decide ), cl07g_swap ( show (6 : Fin 7) ≠ 4 by decide ), cl07g_swap ( show (6 : Fin 7) ≠ 5 by decide ) ];
    all_goals try simp_all +decide [ ← mul_assoc, cl07g_sq ];
    all_goals try simp_all +decide only [cl07_monoSet];
    all_goals try simp_all +decide only [Set.insert_subset_iff, Set.singleton_subset_iff];
    all_goals aesop ( simp_config := { singlePass := true } ) ;
  · aesop;
  · exact fun x y hx hy hx' hy' p hp => by simpa only [ mul_add ] using p.add_mem ( hx' p hp ) ( hy' p hp ) ;
  · exact fun a x hx hx' p hp => by simpa [ mul_smul_comm ] using p.smul_mem a ( hx' p hp ) ;


/-- The monomial span equals the whole algebra. -/
theorem cl07_monoSpan_eq_top : cl07_monoSpan = ⊤ := by
  rw [Submodule.eq_top_iff']
  intro x
  induction x using CliffordAlgebra.induction with
  | algebraMap r =>
    rw [Algebra.algebraMap_eq_smul_one]
    exact smul_mem _ r (subset_span (by simp [cl07_monoSet, cl07_monoList]))
  | ι v =>
    rw [ι_expand7]
    apply sum_mem
    intro i _
    apply smul_mem
    exact subset_span (by fin_cases i <;> simp [cl07_monoSet, cl07_monoList])
  | mul a b ha hb =>
    refine span_induction ?_ ?_ ?_ ?_ ha
    · intro a ha
      simp only [cl07_monoSet, Set.mem_setOf_eq, cl07_monoList, List.mem_cons,
                 List.mem_singleton] at ha
      -- For each monomial a, left-multiply into the span using ei_mul_mem_span7
      rcases ha with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
      · rwa [one_mul]
      · exact e0_mul_mem_span7 b hb
      · exact e1_mul_mem_span7 b hb
      · exact e2_mul_mem_span7 b hb
      · exact e3_mul_mem_span7 b hb
      · exact e4_mul_mem_span7 b hb
      · exact e5_mul_mem_span7 b hb
      · exact e6_mul_mem_span7 b hb
      all_goals (
        first
        | (rw [mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 b hb))
        | (rw [mul_assoc]; exact e0_mul_mem_span7 _ (e2_mul_mem_span7 b hb))
        | (rw [mul_assoc]; exact e0_mul_mem_span7 _ (e3_mul_mem_span7 b hb))
        | (rw [mul_assoc]; exact e0_mul_mem_span7 _ (e4_mul_mem_span7 b hb))
        | (rw [mul_assoc]; exact e0_mul_mem_span7 _ (e5_mul_mem_span7 b hb))
        | (rw [mul_assoc]; exact e0_mul_mem_span7 _ (e6_mul_mem_span7 b hb))
        | (rw [mul_assoc]; exact e1_mul_mem_span7 _ (e2_mul_mem_span7 b hb))
        | (rw [mul_assoc]; exact e1_mul_mem_span7 _ (e3_mul_mem_span7 b hb))
        | (rw [mul_assoc]; exact e1_mul_mem_span7 _ (e4_mul_mem_span7 b hb))
        | (rw [mul_assoc]; exact e1_mul_mem_span7 _ (e5_mul_mem_span7 b hb))
        | (rw [mul_assoc]; exact e1_mul_mem_span7 _ (e6_mul_mem_span7 b hb))
        | (rw [mul_assoc]; exact e2_mul_mem_span7 _ (e3_mul_mem_span7 b hb))
        | (rw [mul_assoc]; exact e2_mul_mem_span7 _ (e4_mul_mem_span7 b hb))
        | (rw [mul_assoc]; exact e2_mul_mem_span7 _ (e5_mul_mem_span7 b hb))
        | (rw [mul_assoc]; exact e2_mul_mem_span7 _ (e6_mul_mem_span7 b hb))
        | (rw [mul_assoc]; exact e3_mul_mem_span7 _ (e4_mul_mem_span7 b hb))
        | (rw [mul_assoc]; exact e3_mul_mem_span7 _ (e5_mul_mem_span7 b hb))
        | (rw [mul_assoc]; exact e3_mul_mem_span7 _ (e6_mul_mem_span7 b hb))
        | (rw [mul_assoc]; exact e4_mul_mem_span7 _ (e5_mul_mem_span7 b hb))
        | (rw [mul_assoc]; exact e4_mul_mem_span7 _ (e6_mul_mem_span7 b hb))
        | (rw [mul_assoc]; exact e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e2_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e3_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e4_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e5_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e2_mul_mem_span7 _ (e4_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e2_mul_mem_span7 _ (e5_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e2_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e3_mul_mem_span7 _ (e5_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e3_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e4_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e4_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e5_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e3_mul_mem_span7 _ (e5_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e3_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e4_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e5_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e2_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e2_mul_mem_span7 _ (e4_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e2_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e3_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e4_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e4_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e5_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e3_mul_mem_span7 _ (e5_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e3_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e4_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e5_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e2_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e2_mul_mem_span7 _ (e4_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e2_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e3_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e5_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e4_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e3_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e2_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e5_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e4_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e3_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e2_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 b hb))))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span7 _ (e1_mul_mem_span7 _ (e2_mul_mem_span7 _ (e3_mul_mem_span7 _ (e4_mul_mem_span7 _ (e5_mul_mem_span7 _ (e6_mul_mem_span7 b hb))))))))
      )
    · simp [zero_mul]
    · intro a c _ _ ha hc; rw [add_mul]; exact add_mem ha hc
    · intro r a _ ha; rw [smul_mul_assoc]; exact smul_mem _ r ha
  | add a b ha hb => exact add_mem ha hb

/-- Cl(0,7) is a finite-dimensional ℝ-vector space. -/
instance cl07_finiteDimensional : FiniteDimensional ℝ (Cl0 7) := by
  have : (⊤ : Submodule ℝ (Cl0 7)).FG := by
    rw [Submodule.fg_def]
    refine ⟨cl07_monoSet, ?_, cl07_monoSpan_eq_top⟩
    simp only [cl07_monoSet, cl07_monoList]
    repeat (first | exact Set.finite_singleton _ | apply Set.Finite.insert)
  exact Module.finite_def.mpr this

/-- The finrank of Cl(0,7) is at most 128 (the number of basis monomials). -/
theorem finrank_Cl07_le_128 : Module.finrank ℝ (Cl0 7) ≤ 128 := by
  have hspan := cl07_monoSpan_eq_top
  rw [← finrank_top (R := ℝ), ← hspan]
  exact (finrank_span_le_card cl07_monoSet).trans (by simp [cl07_monoSet, cl07_monoList]; decide)

end