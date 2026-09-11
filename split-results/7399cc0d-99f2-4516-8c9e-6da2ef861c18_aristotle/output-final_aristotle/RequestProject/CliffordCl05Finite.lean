/-
# Finite Dimensionality of Cl(0,5)

We prove that Cl(0,5) is a finite-dimensional ℝ-vector space.
The 32 ordered monomials of distinct generators span the algebra.
-/

import Mathlib
import RequestProject.CliffordBase

set_option maxHeartbeats 6400000

open CliffordAlgebra Submodule

noncomputable section

def cl05g (i : Fin 5) : Cl0 5 := ι (negDefForm 5) (stdBasis 5 i)

theorem cl05g_sq (i : Fin 5) : cl05g i * cl05g i = -(1 : Cl0 5) := by
  unfold cl05g; rw [ι_sq_scalar, negDefForm_basis]; simp

theorem cl05g_swap {i j : Fin 5} (hij : i ≠ j) :
    cl05g i * cl05g j = -(cl05g j * cl05g i) := by
  apply eq_neg_of_add_eq_zero_left
  unfold cl05g
  fin_cases i <;> fin_cases j <;> simp_all +decide
  all_goals simp +decide [ι_mul_ι_add_swap, negDefForm, _root_.stdBasis]
  all_goals simp +decide [Fin.sum_univ_five, QuadraticMap.polar]

theorem ι_expand5 (v : Fin 5 → ℝ) : ι (negDefForm 5) v = ∑ i : Fin 5, v i • cl05g i := by
  simp only [cl05g]
  have : v = ∑ i : Fin 5, v i • stdBasis 5 i := by
    ext j; simp [stdBasis, Pi.single, Function.update]
  conv_lhs => rw [this]
  simp [map_sum, map_smul]

/-- The 32 ordered monomials spanning Cl(0,5). -/
def cl05_monoSet : Set (Cl0 5) :=
  {(1 : Cl0 5),
    cl05g 0, cl05g 1, cl05g 2, cl05g 3, cl05g 4,
    cl05g 0 * cl05g 1, cl05g 0 * cl05g 2, cl05g 0 * cl05g 3,
    cl05g 0 * cl05g 4, cl05g 1 * cl05g 2, cl05g 1 * cl05g 3,
    cl05g 1 * cl05g 4, cl05g 2 * cl05g 3, cl05g 2 * cl05g 4,
    cl05g 3 * cl05g 4,
    cl05g 0 * cl05g 1 * cl05g 2, cl05g 0 * cl05g 1 * cl05g 3,
    cl05g 0 * cl05g 1 * cl05g 4, cl05g 0 * cl05g 2 * cl05g 3,
    cl05g 0 * cl05g 2 * cl05g 4, cl05g 0 * cl05g 3 * cl05g 4,
    cl05g 1 * cl05g 2 * cl05g 3, cl05g 1 * cl05g 2 * cl05g 4,
    cl05g 1 * cl05g 3 * cl05g 4, cl05g 2 * cl05g 3 * cl05g 4,
    cl05g 0 * cl05g 1 * cl05g 2 * cl05g 3,
    cl05g 0 * cl05g 1 * cl05g 2 * cl05g 4,
    cl05g 0 * cl05g 1 * cl05g 3 * cl05g 4,
    cl05g 0 * cl05g 2 * cl05g 3 * cl05g 4,
    cl05g 1 * cl05g 2 * cl05g 3 * cl05g 4,
    cl05g 0 * cl05g 1 * cl05g 2 * cl05g 3 * cl05g 4}

abbrev cl05_monoSpan : Submodule ℝ (Cl0 5) := span ℝ cl05_monoSet

private theorem ms (x : Cl0 5) (hx : x ∈ cl05_monoSet) : x ∈ cl05_monoSpan :=
  subset_span hx

private theorem nms (x : Cl0 5) (hx : x ∈ cl05_monoSet) : -x ∈ cl05_monoSpan :=
  neg_mem (subset_span hx)

/-
Left multiplication by e₀ preserves the monomial span.
-/
theorem e0_mul_mem_span5 (x : Cl0 5) (hx : x ∈ cl05_monoSpan) :
    cl05g 0 * x ∈ cl05_monoSpan := by
  refine' Submodule.span_induction _ _ _ _ hx <;> norm_num [ Submodule.span ];
  · intro x hx p hp;
    rcases hx with ( rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl );
    all_goals simp_all +decide only [cl05_monoSet];
    all_goals simp_all +decide only [Set.insert_subset_iff, Set.singleton_subset_iff];
    all_goals simp_all +decide [ ← mul_assoc, cl05g_sq ];
  · exact fun x y hx hy hx' hy' p hp => by simpa only [ mul_add ] using p.add_mem ( hx' p hp ) ( hy' p hp ) ;
  · exact fun a x hx₁ hx₂ p hp => p.smul_mem a ( hx₂ p hp )

/-
Left multiplication by e₁ preserves the monomial span.
-/
theorem e1_mul_mem_span5 (x : Cl0 5) (hx : x ∈ cl05_monoSpan) :
    cl05g 1 * x ∈ cl05_monoSpan := by
  induction hx using Submodule.span_induction;
  · rename_i x hx; rcases hx with ( rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl ) <;> simp +decide [ *, Submodule.mem_span ] ;
    all_goals intro p hp; simp_all +decide only [cl05_monoSet, Set.insert_subset_iff, Set.singleton_subset_iff] ;
    all_goals simp_all +decide [ ← mul_assoc, Submodule.smul_mem ];
    all_goals simp_all +decide [ mul_assoc, cl05g_swap ( show 1 ≠ 0 by decide ) ];
    all_goals simp_all +decide [ ← mul_assoc, cl05g_sq ];
  · norm_num;
  · simpa only [ mul_add ] using Submodule.add_mem _ ‹_› ‹_›;
  · rw [ mul_smul_comm ] ; exact Submodule.smul_mem _ _ ‹_›

/-
Left multiplication by e₂ preserves the monomial span.
-/
theorem e2_mul_mem_span5 (x : Cl0 5) (hx : x ∈ cl05_monoSpan) :
    cl05g 2 * x ∈ cl05_monoSpan := by
  refine' Submodule.span_induction _ _ _ _ hx;
  · rintro x ( rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl ) <;> simp +decide [ *, Submodule.mem_span ];
    all_goals intro p hp; simp_all +decide only [cl05_monoSet, Set.insert_subset_iff, Set.singleton_subset_iff] ;
    all_goals simp_all +decide [ mul_assoc, Submodule.smul_mem_iff ] ;
    all_goals simp_all +decide only [← mul_assoc];
    all_goals simp_all +decide [ mul_assoc, cl05g_swap ( show 2 ≠ 0 by decide ), cl05g_swap ( show 2 ≠ 1 by decide ), cl05g_swap ( show 2 ≠ 3 by decide ), cl05g_swap ( show 2 ≠ 4 by decide ) ] ;
    all_goals simp_all +decide [ ← mul_assoc, cl05g_sq ] ;
    all_goals simp_all +decide [ mul_assoc, cl05g_swap ( show 2 ≠ 3 by decide ), cl05g_swap ( show 2 ≠ 4 by decide ) ] ;
    all_goals simp_all +decide [ mul_assoc, cl05g_sq ] ;
  · norm_num;
  · exact fun x y hx hy hx' hy' => by simpa only [ mul_add ] using Submodule.add_mem _ hx' hy';
  · exact fun a x hx hx' => by simpa [ mul_smul_comm ] using Submodule.smul_mem _ a hx';

/-
Left multiplication by e₃ preserves the monomial span.
-/
theorem e3_mul_mem_span5 (x : Cl0 5) (hx : x ∈ cl05_monoSpan) :
    cl05g 3 * x ∈ cl05_monoSpan := by
  apply Submodule.span_induction at hx;
  case p => exact fun x hx => cl05g 3 * x ∈ span ℝ cl05_monoSet
  generalize_proofs at *;
  · exact hx;
  · intro x hx
    rcases hx with (hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx | hx);
    all_goals subst hx; norm_num [ span ];
    all_goals intro p hp; simp_all +decide only [cl05_monoSet, Set.insert_subset_iff, Set.singleton_subset_iff] ;
    all_goals simp_all +decide [ mul_assoc, Submodule.smul_mem_iff ] ;
    all_goals simp_all +decide only [← mul_assoc] ;
    all_goals simp_all +decide [ mul_assoc, cl05g_swap ( show 3 ≠ 0 by decide ), cl05g_swap ( show 3 ≠ 1 by decide ), cl05g_swap ( show 3 ≠ 2 by decide ), cl05g_swap ( show 3 ≠ 4 by decide ) ] ;
    all_goals simp_all +decide [ ← mul_assoc, cl05g_sq ] ;
    all_goals simp_all +decide [ mul_assoc, cl05g_swap ( show 3 ≠ 4 by decide ) ] ;
    all_goals simp_all +decide [ ← mul_assoc, cl05g_sq ] ;
  · simp +decide [ mul_zero ];
  · exact fun x y hx hy hx' hy' => by simpa only [ mul_add ] using Submodule.add_mem _ hx' hy';
  · exact fun a x hx hx' => by rw [ mul_smul_comm ] ; exact Submodule.smul_mem _ _ hx';

/-
Left multiplication by e₄ preserves the monomial span.
-/
theorem e4_mul_mem_span5 (x : Cl0 5) (hx : x ∈ cl05_monoSpan) :
    cl05g 4 * x ∈ cl05_monoSpan := by
  refine' Submodule.span_induction _ _ _ _ hx <;> norm_num [ Submodule.span, Set.mem_union, Set.mem_singleton_iff ];
  · intro x hx p hp;
    rcases hx with ( rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl );
    all_goals simp_all +decide only [cl05_monoSet, Set.insert_subset_iff, Set.singleton_subset_iff];
    all_goals simp_all +decide [ ← mul_assoc, ← eq_sub_iff_add_eq' ];
    all_goals simp_all +decide [ mul_assoc, cl05g_swap ( show 4 ≠ 0 by decide ), cl05g_swap ( show 4 ≠ 1 by decide ), cl05g_swap ( show 4 ≠ 2 by decide ), cl05g_swap ( show 4 ≠ 3 by decide ) ];
    all_goals simp_all +decide [ ← mul_assoc, cl05g_sq ];
  · exact fun x y hx hy hx' hy' p hp => by simpa only [ mul_add ] using Submodule.add_mem _ ( hx' p hp ) ( hy' p hp ) ;
  · exact fun a x hx₁ hx₂ p hp => p.smul_mem a ( hx₂ p hp )

/-- The monomial span equals the whole algebra. -/
theorem cl05_monoSpan_eq_top : cl05_monoSpan = ⊤ := by
  rw [Submodule.eq_top_iff']
  intro x
  induction x using CliffordAlgebra.induction with
  | algebraMap r =>
    rw [Algebra.algebraMap_eq_smul_one]
    exact smul_mem _ r (ms _ (by simp [cl05_monoSet]))
  | ι v =>
    rw [ι_expand5]
    apply sum_mem
    intro i _
    apply smul_mem
    exact ms _ (by fin_cases i <;> simp [cl05_monoSet])
  | mul a b ha hb =>
    refine span_induction ?_ ?_ ?_ ?_ ha
    · intro a ha
      simp only [cl05_monoSet, Set.mem_insert_iff, Set.mem_singleton_iff] at ha
      rcases ha with rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl | rfl | rfl
      · rwa [one_mul]
      · exact e0_mul_mem_span5 b hb
      · exact e1_mul_mem_span5 b hb
      · exact e2_mul_mem_span5 b hb
      · exact e3_mul_mem_span5 b hb
      · exact e4_mul_mem_span5 b hb
      · rw [mul_assoc]; exact e0_mul_mem_span5 _ (e1_mul_mem_span5 b hb)
      · rw [mul_assoc]; exact e0_mul_mem_span5 _ (e2_mul_mem_span5 b hb)
      · rw [mul_assoc]; exact e0_mul_mem_span5 _ (e3_mul_mem_span5 b hb)
      · rw [mul_assoc]; exact e0_mul_mem_span5 _ (e4_mul_mem_span5 b hb)
      · rw [mul_assoc]; exact e1_mul_mem_span5 _ (e2_mul_mem_span5 b hb)
      · rw [mul_assoc]; exact e1_mul_mem_span5 _ (e3_mul_mem_span5 b hb)
      · rw [mul_assoc]; exact e1_mul_mem_span5 _ (e4_mul_mem_span5 b hb)
      · rw [mul_assoc]; exact e2_mul_mem_span5 _ (e3_mul_mem_span5 b hb)
      · rw [mul_assoc]; exact e2_mul_mem_span5 _ (e4_mul_mem_span5 b hb)
      · rw [mul_assoc]; exact e3_mul_mem_span5 _ (e4_mul_mem_span5 b hb)
      · rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span5 _ (e1_mul_mem_span5 _ (e2_mul_mem_span5 b hb))
      · rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span5 _ (e1_mul_mem_span5 _ (e3_mul_mem_span5 b hb))
      · rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span5 _ (e1_mul_mem_span5 _ (e4_mul_mem_span5 b hb))
      · rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span5 _ (e2_mul_mem_span5 _ (e3_mul_mem_span5 b hb))
      · rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span5 _ (e2_mul_mem_span5 _ (e4_mul_mem_span5 b hb))
      · rw [mul_assoc, mul_assoc]; exact e0_mul_mem_span5 _ (e3_mul_mem_span5 _ (e4_mul_mem_span5 b hb))
      · rw [mul_assoc, mul_assoc]; exact e1_mul_mem_span5 _ (e2_mul_mem_span5 _ (e3_mul_mem_span5 b hb))
      · rw [mul_assoc, mul_assoc]; exact e1_mul_mem_span5 _ (e2_mul_mem_span5 _ (e4_mul_mem_span5 b hb))
      · rw [mul_assoc, mul_assoc]; exact e1_mul_mem_span5 _ (e3_mul_mem_span5 _ (e4_mul_mem_span5 b hb))
      · rw [mul_assoc, mul_assoc]; exact e2_mul_mem_span5 _ (e3_mul_mem_span5 _ (e4_mul_mem_span5 b hb))
      · rw [mul_assoc, mul_assoc, mul_assoc]
        exact e0_mul_mem_span5 _ (e1_mul_mem_span5 _ (e2_mul_mem_span5 _ (e3_mul_mem_span5 b hb)))
      · rw [mul_assoc, mul_assoc, mul_assoc]
        exact e0_mul_mem_span5 _ (e1_mul_mem_span5 _ (e2_mul_mem_span5 _ (e4_mul_mem_span5 b hb)))
      · rw [mul_assoc, mul_assoc, mul_assoc]
        exact e0_mul_mem_span5 _ (e1_mul_mem_span5 _ (e3_mul_mem_span5 _ (e4_mul_mem_span5 b hb)))
      · rw [mul_assoc, mul_assoc, mul_assoc]
        exact e0_mul_mem_span5 _ (e2_mul_mem_span5 _ (e3_mul_mem_span5 _ (e4_mul_mem_span5 b hb)))
      · rw [mul_assoc, mul_assoc, mul_assoc]
        exact e1_mul_mem_span5 _ (e2_mul_mem_span5 _ (e3_mul_mem_span5 _ (e4_mul_mem_span5 b hb)))
      · rw [mul_assoc, mul_assoc, mul_assoc, mul_assoc]
        exact e0_mul_mem_span5 _ (e1_mul_mem_span5 _ (e2_mul_mem_span5 _ (e3_mul_mem_span5 _ (e4_mul_mem_span5 b hb))))
    · simp [zero_mul]
    · intro a c _ _ ha hc; rw [add_mul]; exact add_mem ha hc
    · intro r a _ ha; rw [smul_mul_assoc]; exact smul_mem _ r ha
  | add a b ha hb => exact add_mem ha hb

/-- Cl(0,5) is a finite-dimensional ℝ-vector space. -/
instance cl05_finiteDimensional : FiniteDimensional ℝ (Cl0 5) := by
  have : (⊤ : Submodule ℝ (Cl0 5)).FG := by
    rw [Submodule.fg_def]
    refine ⟨cl05_monoSet, ?_, cl05_monoSpan_eq_top⟩
    simp only [cl05_monoSet]
    repeat (first | exact Set.finite_singleton _ | apply Set.Finite.insert)
  exact Module.finite_def.mpr this

/-
The finrank of Cl(0,5) is at most 32 (the number of basis monomials).
-/
theorem finrank_Cl05_le_32 : Module.finrank ℝ (Cl0 5) ≤ 32 := by
  have h_span : Submodule.span ℝ (cl05_monoSet) = ⊤ := cl05_monoSpan_eq_top
  have h_card : Set.ncard cl05_monoSet ≤ 32 := by
    refine le_trans (Set.ncard_insert_le _ _) ?_
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    refine Nat.succ_le_succ (le_trans (Set.ncard_insert_le _ _) ?_)
    exact Nat.succ_le_succ (by
      have : Set.ncard ({cl05g 0 * cl05g 1 * cl05g 2 * cl05g 3 * cl05g 4} : Set (Cl0 5)) ≤ 1 :=
        Set.ncard_singleton _ ▸ le_refl _
      linarith [Set.ncard_insert_le (cl05g 1 * cl05g 2 * cl05g 3 * cl05g 4)
        ({cl05g 0 * cl05g 1 * cl05g 2 * cl05g 3 * cl05g 4} : Set (Cl0 5))])
  have h_finite : Set.Finite cl05_monoSet := by
    simp only [cl05_monoSet]
    repeat (first | exact Set.finite_singleton _ | apply Set.Finite.insert)
  have h_ft := h_finite.fintype
  have h_finrank_le : Module.finrank ℝ (Submodule.span ℝ cl05_monoSet) ≤ Set.ncard cl05_monoSet := by
    have h2 := @finrank_span_le_card ℝ (Cl0 5) _ _ _ _ cl05_monoSet h_ft
    have h3 : cl05_monoSet.toFinset.card = cl05_monoSet.ncard := by
      rw [Set.ncard_eq_toFinset_card']
    linarith
  rw [h_span, finrank_top] at h_finrank_le
  linarith

end


