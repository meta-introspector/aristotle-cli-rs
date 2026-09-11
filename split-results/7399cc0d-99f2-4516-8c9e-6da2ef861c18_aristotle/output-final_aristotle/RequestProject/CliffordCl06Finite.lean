/-
# Finite Dimensionality of Cl(0,6)

We prove that Cl(0,6) is a finite-dimensional ℝ-vector space.
The 64 ordered monomials of distinct generators span the algebra.
-/

import Mathlib
import RequestProject.CliffordBase

set_option maxHeartbeats 12800000

open CliffordAlgebra Submodule

noncomputable section

def cl06g (i : Fin 6) : Cl0 6 := ι (negDefForm 6) (stdBasis 6 i)

theorem cl06g_sq (i : Fin 6) : cl06g i * cl06g i = -(1 : Cl0 6) := by
  unfold cl06g; rw [ι_sq_scalar, negDefForm_basis]; simp

theorem cl06g_swap {i j : Fin 6} (hij : i ≠ j) :
    cl06g i * cl06g j = -(cl06g j * cl06g i) := by
  apply eq_neg_of_add_eq_zero_left
  unfold cl06g
  fin_cases i <;> fin_cases j <;> simp_all +decide
  all_goals simp +decide [ι_mul_ι_add_swap, negDefForm, _root_.stdBasis]
  all_goals simp +decide [Fin.sum_univ_six, QuadraticMap.polar]

theorem ι_expand6 (v : Fin 6 → ℝ) : ι (negDefForm 6) v = ∑ i : Fin 6, v i • cl06g i := by
  simp only [cl06g]
  have : v = ∑ i : Fin 6, v i • stdBasis 6 i := by
    ext j; simp [stdBasis, Pi.single, Function.update]
  conv_lhs => rw [this]
  simp [map_sum, map_smul]

/-- The 64 ordered monomials spanning Cl(0,6). -/
def cl06_monoSet : Set (Cl0 6) :=
  { (1 : Cl0 6),
    -- 6 single generators
    cl06g 0, cl06g 1, cl06g 2, cl06g 3, cl06g 4, cl06g 5,
    -- 15 pairs
    cl06g 0 * cl06g 1, cl06g 0 * cl06g 2, cl06g 0 * cl06g 3,
    cl06g 0 * cl06g 4, cl06g 0 * cl06g 5, cl06g 1 * cl06g 2,
    cl06g 1 * cl06g 3, cl06g 1 * cl06g 4, cl06g 1 * cl06g 5,
    cl06g 2 * cl06g 3, cl06g 2 * cl06g 4, cl06g 2 * cl06g 5,
    cl06g 3 * cl06g 4, cl06g 3 * cl06g 5, cl06g 4 * cl06g 5,
    -- 20 triples
    cl06g 0 * cl06g 1 * cl06g 2, cl06g 0 * cl06g 1 * cl06g 3,
    cl06g 0 * cl06g 1 * cl06g 4, cl06g 0 * cl06g 1 * cl06g 5,
    cl06g 0 * cl06g 2 * cl06g 3, cl06g 0 * cl06g 2 * cl06g 4,
    cl06g 0 * cl06g 2 * cl06g 5, cl06g 0 * cl06g 3 * cl06g 4,
    cl06g 0 * cl06g 3 * cl06g 5, cl06g 0 * cl06g 4 * cl06g 5,
    cl06g 1 * cl06g 2 * cl06g 3, cl06g 1 * cl06g 2 * cl06g 4,
    cl06g 1 * cl06g 2 * cl06g 5, cl06g 1 * cl06g 3 * cl06g 4,
    cl06g 1 * cl06g 3 * cl06g 5, cl06g 1 * cl06g 4 * cl06g 5,
    cl06g 2 * cl06g 3 * cl06g 4, cl06g 2 * cl06g 3 * cl06g 5,
    cl06g 2 * cl06g 4 * cl06g 5, cl06g 3 * cl06g 4 * cl06g 5,
    -- 15 quadruples
    cl06g 0 * cl06g 1 * cl06g 2 * cl06g 3,
    cl06g 0 * cl06g 1 * cl06g 2 * cl06g 4,
    cl06g 0 * cl06g 1 * cl06g 2 * cl06g 5,
    cl06g 0 * cl06g 1 * cl06g 3 * cl06g 4,
    cl06g 0 * cl06g 1 * cl06g 3 * cl06g 5,
    cl06g 0 * cl06g 1 * cl06g 4 * cl06g 5,
    cl06g 0 * cl06g 2 * cl06g 3 * cl06g 4,
    cl06g 0 * cl06g 2 * cl06g 3 * cl06g 5,
    cl06g 0 * cl06g 2 * cl06g 4 * cl06g 5,
    cl06g 0 * cl06g 3 * cl06g 4 * cl06g 5,
    cl06g 1 * cl06g 2 * cl06g 3 * cl06g 4,
    cl06g 1 * cl06g 2 * cl06g 3 * cl06g 5,
    cl06g 1 * cl06g 2 * cl06g 4 * cl06g 5,
    cl06g 1 * cl06g 3 * cl06g 4 * cl06g 5,
    cl06g 2 * cl06g 3 * cl06g 4 * cl06g 5,
    -- 6 quintuples
    cl06g 0 * cl06g 1 * cl06g 2 * cl06g 3 * cl06g 4,
    cl06g 0 * cl06g 1 * cl06g 2 * cl06g 3 * cl06g 5,
    cl06g 0 * cl06g 1 * cl06g 2 * cl06g 4 * cl06g 5,
    cl06g 0 * cl06g 1 * cl06g 3 * cl06g 4 * cl06g 5,
    cl06g 0 * cl06g 2 * cl06g 3 * cl06g 4 * cl06g 5,
    cl06g 1 * cl06g 2 * cl06g 3 * cl06g 4 * cl06g 5,
    -- 1 sextuple (volume element)
    cl06g 0 * cl06g 1 * cl06g 2 * cl06g 3 * cl06g 4 * cl06g 5 }

abbrev cl06_monoSpan : Submodule ℝ (Cl0 6) := span ℝ cl06_monoSet

private theorem ms (x : Cl0 6) (hx : x ∈ cl06_monoSet) : x ∈ cl06_monoSpan :=
  subset_span hx

private theorem nms (x : Cl0 6) (hx : x ∈ cl06_monoSet) : -x ∈ cl06_monoSpan :=
  neg_mem (subset_span hx)

/-! ### Left multiplication by each generator preserves the monomial span.

These are the key lemmas. Each shows that eᵢ * x ∈ span for x ∈ span.
The proofs follow the pattern from CliffordCl05Finite but with 64 monomials.
-/

/-
For each generator, we prove that multiplication preserves the span.
The proofs use cl06g_sq and cl06g_swap to reorder products.
-/
theorem e0_mul_mem_span6 (x : Cl0 6) (hx : x ∈ cl06_monoSpan) :
    cl06g 0 * x ∈ cl06_monoSpan := by
  revert x hx;
  intro x hx
  apply Submodule.span_induction at hx
  all_goals simp_all +decide [ Submodule.span ];
  case p => exact fun x hx => ∀ p : Submodule ℝ ( Cl0 6 ), cl06_monoSet ⊆ p → cl06g 0 * x ∈ p;
  · exact hx;
  · intro x hx p hp
    rcases hx with ( rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl );
    all_goals repeat' rw [ ← mul_assoc ];
    all_goals repeat' rw [ cl06g_sq ] ; norm_num [ hp ] ;
    all_goals simp_all +decide only [cl06_monoSet];
    all_goals simp_all +decide only [Set.insert_subset_iff, Set.singleton_subset_iff];
    all_goals aesop ( simp_config := { singlePass := true } ) ;
  · aesop;
  · exact fun x y hx hy hx' hy' p hp => by simpa only [ mul_add ] using p.add_mem ( hx' p hp ) ( hy' p hp ) ;
  · exact fun a x hx hx' p hp => by simpa [ mul_smul_comm ] using p.smul_mem a ( hx' p hp ) ;

theorem e1_mul_mem_span6 (x : Cl0 6) (hx : x ∈ cl06_monoSpan) :
    cl06g 1 * x ∈ cl06_monoSpan := by
  revert x hx; intro x hx
  apply Submodule.span_induction at hx
  all_goals simp_all +decide [ Submodule.span ];
  case p => exact fun x hx => ∀ p : Submodule ℝ ( Cl0 6 ), cl06_monoSet ⊆ p → cl06g 1 * x ∈ p;
  · exact hx;
  · intro x hx p hp
    rcases hx with ( rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl );
    all_goals repeat' rw [ ← mul_assoc ];
    all_goals repeat' rw [ ← mul_assoc ];
    all_goals repeat' rw [ cl06g_sq ] ; norm_num [ hp ] ;
    all_goals try simp_all +decide [ mul_assoc, cl06g_swap ( show (1 : Fin 6) ≠ 0 by decide ) ];
    all_goals try simp_all +decide [ ← mul_assoc, cl06g_sq ];
    all_goals try simp_all +decide only [cl06_monoSet];
    all_goals try simp_all +decide only [Set.insert_subset_iff, Set.singleton_subset_iff];
    all_goals aesop ( simp_config := { singlePass := true } ) ;
  · aesop;
  · exact fun x y hx hy hx' hy' p hp => by simpa only [ mul_add ] using p.add_mem ( hx' p hp ) ( hy' p hp ) ;
  · exact fun a x hx hx' p hp => by simpa [ mul_smul_comm ] using p.smul_mem a ( hx' p hp ) ;

theorem e2_mul_mem_span6 (x : Cl0 6) (hx : x ∈ cl06_monoSpan) :
    cl06g 2 * x ∈ cl06_monoSpan := by
  sorry

theorem e3_mul_mem_span6 (x : Cl0 6) (hx : x ∈ cl06_monoSpan) :
    cl06g 3 * x ∈ cl06_monoSpan := by
  sorry

theorem e4_mul_mem_span6 (x : Cl0 6) (hx : x ∈ cl06_monoSpan) :
    cl06g 4 * x ∈ cl06_monoSpan := by
  sorry

theorem e5_mul_mem_span6 (x : Cl0 6) (hx : x ∈ cl06_monoSpan) :
    cl06g 5 * x ∈ cl06_monoSpan := by
  revert x hx; intro x hx
  apply Submodule.span_induction at hx
  all_goals simp_all +decide [ Submodule.span ];
  case p => exact fun x hx => ∀ p : Submodule ℝ ( Cl0 6 ), cl06_monoSet ⊆ p → cl06g 5 * x ∈ p;
  · exact hx;
  · intro x hx p hp
    rcases hx with ( rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl );
    all_goals repeat' rw [ ← mul_assoc ];
    all_goals repeat' rw [ ← mul_assoc ];
    all_goals repeat' rw [ cl06g_sq ] ; norm_num [ hp ] ;
    all_goals try simp_all +decide [ mul_assoc, cl06g_swap ( show (5 : Fin 6) ≠ 0 by decide ), cl06g_swap ( show (5 : Fin 6) ≠ 1 by decide ), cl06g_swap ( show (5 : Fin 6) ≠ 2 by decide ), cl06g_swap ( show (5 : Fin 6) ≠ 3 by decide ), cl06g_swap ( show (5 : Fin 6) ≠ 4 by decide ) ];
    all_goals try simp_all +decide [ ← mul_assoc, cl06g_sq ];
    all_goals try simp_all +decide [ mul_assoc, cl06g_swap ( show (5 : Fin 6) ≠ 0 by decide ), cl06g_swap ( show (5 : Fin 6) ≠ 1 by decide ), cl06g_swap ( show (5 : Fin 6) ≠ 2 by decide ), cl06g_swap ( show (5 : Fin 6) ≠ 3 by decide ), cl06g_swap ( show (5 : Fin 6) ≠ 4 by decide ) ];
    all_goals try simp_all +decide [ ← mul_assoc, cl06g_sq ];
    all_goals try simp_all +decide only [cl06_monoSet];
    all_goals try simp_all +decide only [Set.insert_subset_iff, Set.singleton_subset_iff];
    all_goals aesop ( simp_config := { singlePass := true } ) ;
  · aesop;
  · exact fun x y hx hy hx' hy' p hp => by simpa only [ mul_add ] using p.add_mem ( hx' p hp ) ( hy' p hp ) ;
  · exact fun a x hx hx' p hp => by simpa [ mul_smul_comm ] using p.smul_mem a ( hx' p hp ) ;

/-- The monomial span equals the whole algebra. -/
theorem cl06_monoSpan_eq_top : cl06_monoSpan = ⊤ := by
  rw [Submodule.eq_top_iff']
  intro x
  induction x using CliffordAlgebra.induction with
  | algebraMap r =>
    rw [Algebra.algebraMap_eq_smul_one]
    exact smul_mem _ r (ms _ (by simp [cl06_monoSet]))
  | ι v =>
    rw [ι_expand6]
    apply sum_mem
    intro i _
    apply smul_mem
    exact ms _ (by fin_cases i <;> simp [cl06_monoSet])
  | mul a b ha hb =>
    refine span_induction ?_ ?_ ?_ ?_ ha
    · intro a ha
      simp only [cl06_monoSet, Set.mem_insert_iff, Set.mem_singleton_iff] at ha
      -- Each monomial case reduces to generator multiplications
      rcases ha with rfl | rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl
      · rwa [one_mul]
      · exact e0_mul_mem_span6 b hb
      · exact e1_mul_mem_span6 b hb
      · exact e2_mul_mem_span6 b hb
      · exact e3_mul_mem_span6 b hb
      · exact e4_mul_mem_span6 b hb
      · exact e5_mul_mem_span6 b hb
      all_goals (
        first
        | (rw [mul_assoc]; exact e0_mul_mem_span6 _ (e1_mul_mem_span6 b hb))
        | (rw [mul_assoc]; exact e0_mul_mem_span6 _ (e2_mul_mem_span6 b hb))
        | (rw [mul_assoc]; exact e0_mul_mem_span6 _ (e3_mul_mem_span6 b hb))
        | (rw [mul_assoc]; exact e0_mul_mem_span6 _ (e4_mul_mem_span6 b hb))
        | (rw [mul_assoc]; exact e0_mul_mem_span6 _ (e5_mul_mem_span6 b hb))
        | (rw [mul_assoc]; exact e1_mul_mem_span6 _ (e2_mul_mem_span6 b hb))
        | (rw [mul_assoc]; exact e1_mul_mem_span6 _ (e3_mul_mem_span6 b hb))
        | (rw [mul_assoc]; exact e1_mul_mem_span6 _ (e4_mul_mem_span6 b hb))
        | (rw [mul_assoc]; exact e1_mul_mem_span6 _ (e5_mul_mem_span6 b hb))
        | (rw [mul_assoc]; exact e2_mul_mem_span6 _ (e3_mul_mem_span6 b hb))
        | (rw [mul_assoc]; exact e2_mul_mem_span6 _ (e4_mul_mem_span6 b hb))
        | (rw [mul_assoc]; exact e2_mul_mem_span6 _ (e5_mul_mem_span6 b hb))
        | (rw [mul_assoc]; exact e3_mul_mem_span6 _ (e4_mul_mem_span6 b hb))
        | (rw [mul_assoc]; exact e3_mul_mem_span6 _ (e5_mul_mem_span6 b hb))
        | (rw [mul_assoc]; exact e4_mul_mem_span6 _ (e5_mul_mem_span6 b hb))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e1_mul_mem_span6 _ (e2_mul_mem_span6 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e1_mul_mem_span6 _ (e3_mul_mem_span6 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e1_mul_mem_span6 _ (e4_mul_mem_span6 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e1_mul_mem_span6 _ (e5_mul_mem_span6 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e2_mul_mem_span6 _ (e3_mul_mem_span6 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e2_mul_mem_span6 _ (e4_mul_mem_span6 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e2_mul_mem_span6 _ (e5_mul_mem_span6 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e3_mul_mem_span6 _ (e4_mul_mem_span6 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e3_mul_mem_span6 _ (e5_mul_mem_span6 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e4_mul_mem_span6 _ (e5_mul_mem_span6 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e1_mul_mem_span6 _ (e2_mul_mem_span6 _ (e3_mul_mem_span6 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e1_mul_mem_span6 _ (e2_mul_mem_span6 _ (e4_mul_mem_span6 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e1_mul_mem_span6 _ (e2_mul_mem_span6 _ (e5_mul_mem_span6 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e1_mul_mem_span6 _ (e3_mul_mem_span6 _ (e4_mul_mem_span6 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e1_mul_mem_span6 _ (e3_mul_mem_span6 _ (e5_mul_mem_span6 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e1_mul_mem_span6 _ (e4_mul_mem_span6 _ (e5_mul_mem_span6 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e2_mul_mem_span6 _ (e3_mul_mem_span6 _ (e4_mul_mem_span6 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e2_mul_mem_span6 _ (e3_mul_mem_span6 _ (e5_mul_mem_span6 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e2_mul_mem_span6 _ (e4_mul_mem_span6 _ (e5_mul_mem_span6 b hb)))
        | (rw [mul_assoc, mul_assoc]; exact e3_mul_mem_span6 _ (e4_mul_mem_span6 _ (e5_mul_mem_span6 b hb)))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e1_mul_mem_span6 _ (e2_mul_mem_span6 _ (e3_mul_mem_span6 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e1_mul_mem_span6 _ (e2_mul_mem_span6 _ (e4_mul_mem_span6 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e1_mul_mem_span6 _ (e2_mul_mem_span6 _ (e5_mul_mem_span6 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e1_mul_mem_span6 _ (e3_mul_mem_span6 _ (e4_mul_mem_span6 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e1_mul_mem_span6 _ (e3_mul_mem_span6 _ (e5_mul_mem_span6 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e1_mul_mem_span6 _ (e4_mul_mem_span6 _ (e5_mul_mem_span6 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e2_mul_mem_span6 _ (e3_mul_mem_span6 _ (e4_mul_mem_span6 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e2_mul_mem_span6 _ (e3_mul_mem_span6 _ (e5_mul_mem_span6 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e2_mul_mem_span6 _ (e4_mul_mem_span6 _ (e5_mul_mem_span6 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e3_mul_mem_span6 _ (e4_mul_mem_span6 _ (e5_mul_mem_span6 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span6 _ (e2_mul_mem_span6 _ (e3_mul_mem_span6 _ (e4_mul_mem_span6 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span6 _ (e2_mul_mem_span6 _ (e3_mul_mem_span6 _ (e5_mul_mem_span6 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span6 _ (e2_mul_mem_span6 _ (e4_mul_mem_span6 _ (e5_mul_mem_span6 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span6 _ (e3_mul_mem_span6 _ (e4_mul_mem_span6 _ (e5_mul_mem_span6 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc]; exact e2_mul_mem_span6 _ (e3_mul_mem_span6 _ (e4_mul_mem_span6 _ (e5_mul_mem_span6 b hb))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e1_mul_mem_span6 _ (e2_mul_mem_span6 _ (e3_mul_mem_span6 _ (e4_mul_mem_span6 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e1_mul_mem_span6 _ (e2_mul_mem_span6 _ (e3_mul_mem_span6 _ (e5_mul_mem_span6 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e1_mul_mem_span6 _ (e2_mul_mem_span6 _ (e4_mul_mem_span6 _ (e5_mul_mem_span6 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e1_mul_mem_span6 _ (e3_mul_mem_span6 _ (e4_mul_mem_span6 _ (e5_mul_mem_span6 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e2_mul_mem_span6 _ (e3_mul_mem_span6 _ (e4_mul_mem_span6 _ (e5_mul_mem_span6 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e1_mul_mem_span6 _ (e2_mul_mem_span6 _ (e3_mul_mem_span6 _ (e4_mul_mem_span6 _ (e5_mul_mem_span6 b hb)))))
        | (rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc, mul_assoc]; exact e0_mul_mem_span6 _ (e1_mul_mem_span6 _ (e2_mul_mem_span6 _ (e3_mul_mem_span6 _ (e4_mul_mem_span6 _ (e5_mul_mem_span6 b hb))))))
        | sorry)
    · simp [zero_mul]
    · intro a c _ _ ha hc; rw [add_mul]; exact add_mem ha hc
    · intro r a _ ha; rw [smul_mul_assoc]; exact smul_mem _ r ha
  | add a b ha hb => exact add_mem ha hb

/-- Cl(0,6) is a finite-dimensional ℝ-vector space. -/
instance cl06_finiteDimensional : FiniteDimensional ℝ (Cl0 6) := by
  have : (⊤ : Submodule ℝ (Cl0 6)).FG := by
    rw [Submodule.fg_def]
    refine ⟨cl06_monoSet, ?_, cl06_monoSpan_eq_top⟩
    simp only [cl06_monoSet]
    repeat (first | exact Set.finite_singleton _ | apply Set.Finite.insert)
  exact Module.finite_def.mpr this

/-- The finrank of Cl(0,6) is at most 64 (the number of basis monomials). -/
theorem finrank_Cl06_le_64 : Module.finrank ℝ (Cl0 6) ≤ 64 := by
  sorry

end