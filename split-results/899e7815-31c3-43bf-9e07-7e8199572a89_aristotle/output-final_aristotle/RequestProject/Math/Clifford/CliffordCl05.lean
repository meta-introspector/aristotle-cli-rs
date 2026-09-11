/-
# Finite Dimensionality of Cl(0,5)

We prove that Cl(0,5) is a finite-dimensional ℝ-vector space.
The 32 ordered monomials of distinct generators span the algebra.
-/

import Mathlib
import RequestProject.Math.Clifford.CliffordBase

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



/-! ## Merged from CliffordCl05.lean (semantic dedup: Cl(0,5)) -/

/-
# Cl(0,5) ≃ₐ[ℝ] M₄(ℂ)

We construct an explicit ℝ-algebra isomorphism between the Clifford algebra
Cl(0,5) (of the negative-definite quadratic form on ℝ⁵) and the matrix
algebra M₄(ℂ) = Matrix (Fin 4) (Fin 4) ℂ.

## Strategy (non-circular)

1. Define the forward algebra homomorphism cl05_forward via CliffordAlgebra.lift.
2. Define an explicit inverse linear map cl05_inv : M₄(ℂ) → Cl(0,5).
3. Prove the right inverse: cl05_forward (cl05_inv M) = M → surjectivity.
4. Prove finite-dimensionality via the 32-monomial spanning set (CliffordCl05Finite).
5. Derive injectivity from surjectivity + equal finite dimensions.
6. Build AlgEquiv.ofBijective.

No step depends on the equivalence being proved — the dependency graph is acyclic.
-/


set_option maxHeartbeats 6400000

open CliffordAlgebra Matrix Complex

abbrev M4C := Matrix (Fin 4) (Fin 4) ℂ

/-! ## §1. Basic Elements and Relations -/

noncomputable def cl05_gen (i : Fin 5) : Cl0 5 :=
  ι (negDefForm 5) (stdBasis 5 i)

theorem cl05_gen_sq (i : Fin 5) :
    cl05_gen i * cl05_gen i = -(1 : Cl0 5) := by
  unfold cl05_gen; rw [ι_sq_scalar, negDefForm_basis]; simp

theorem cl05_anticommute {i j : Fin 5} (hij : i ≠ j) :
    cl05_gen i * cl05_gen j + cl05_gen j * cl05_gen i = 0 := by
  fin_cases i <;> fin_cases j <;> simp_all +decide only [cl05_gen]
  all_goals simp +decide [ι_mul_ι_add_swap, negDefForm, _root_.stdBasis]
  all_goals simp +decide [Fin.sum_univ_five, QuadraticMap.polar]

theorem cl05_gen_swap {i j : Fin 5} (hij : i ≠ j) :
    cl05_gen i * cl05_gen j = -(cl05_gen j * cl05_gen i) :=
  eq_neg_of_add_eq_zero_left (cl05_anticommute hij)

/-! ## §2. Generator Images in M₄(ℂ) -/

/-- The 5 generator images in M₄(ℂ), using i times standard gamma matrices. -/
noncomputable def cl05_img : Fin 5 → M4C
  | 0 => !![0, 0, 0, I; 0, 0, I, 0; 0, I, 0, 0; I, 0, 0, 0]
  | 1 => !![0, 0, 0, 1; 0, 0, -1, 0; 0, 1, 0, 0; -1, 0, 0, 0]
  | 2 => !![0, 0, I, 0; 0, 0, 0, -I; I, 0, 0, 0; 0, -I, 0, 0]
  | 3 => !![0, 0, 1, 0; 0, 0, 0, 1; -1, 0, 0, 0; 0, -1, 0, 0]
  | 4 => !![I, 0, 0, 0; 0, I, 0, 0; 0, 0, -I, 0; 0, 0, 0, -I]

/-- Each generator image squares to -I₄. -/
theorem cl05_img_sq (a : Fin 5) : cl05_img a * cl05_img a = -1 := by
  fin_cases a <;> (ext i j; fin_cases i <;> fin_cases j <;>
    simp [cl05_img, mul_apply, Fin.sum_univ_four])

/-- Generator images anticommute. -/
theorem cl05_img_anticommute {a b : Fin 5} (hab : a ≠ b) :
    cl05_img a * cl05_img b + cl05_img b * cl05_img a = 0 := by
  fin_cases a <;> fin_cases b <;> simp_all +decide <;>
    (ext i j; fin_cases i <;> fin_cases j <;>
      simp [cl05_img, mul_apply, Fin.sum_univ_four] <;> ring)

/-! ## §3. Forward Map: Cl(0,5) → M₄(ℂ) -/

/-- The forward linear map on ℝ⁵ → M₄(ℂ). -/
noncomputable def cl05_forward_lin : (Fin 5 → ℝ) →ₗ[ℝ] M4C where
  toFun v :=
    v 0 • cl05_img 0 + v 1 • cl05_img 1 + v 2 • cl05_img 2 +
    v 3 • cl05_img 3 + v 4 • cl05_img 4
  map_add' u w := by simp [add_smul]; abel
  map_smul' r v := by simp [smul_add, smul_smul]

/-- The forward linear map satisfies the Clifford relation. -/
theorem cl05_clifford_sq (v : Fin 5 → ℝ) :
    cl05_forward_lin v * cl05_forward_lin v =
    algebraMap ℝ M4C (negDefForm 5 v) := by
  simp +decide [cl05_forward_lin, negDefForm]
  simp +decide [Fin.sum_univ_five, mul_add, add_mul, mul_assoc, mul_left_comm,
    Finset.sum_add_distrib, Algebra.algebraMap_eq_smul_one]
  simp +decide [← Matrix.ext_iff, Fin.forall_fin_succ]
  simp +decide [cl05_img] at *
  ring_nf at *; aesop (simp_config := { decide := true })

/-- The forward algebra homomorphism via CliffordAlgebra.lift -/
noncomputable def cl05_forward : Cl0 5 →ₐ[ℝ] M4C :=
  CliffordAlgebra.lift (negDefForm 5) ⟨cl05_forward_lin, cl05_clifford_sq⟩

theorem cl05_forward_gen (v : Fin 5 → ℝ) :
    cl05_forward (ι (negDefForm 5) v) = cl05_forward_lin v :=
  CliffordAlgebra.lift_ι_apply _ _ v

/-! ## §4. Explicit Inverse Map: M₄(ℂ) → Cl(0,5)

The inverse extracts 32 real coefficients from the matrix and maps them
to the corresponding Clifford basis monomials. All coefficients are ±1/4,
verified by inverting the 32×32 basis-image matrix. -/

noncomputable def cl05_inv (M : M4C) : Cl0 5 :=
  (((M 0 0).re + (M 1 1).re + (M 2 2).re + (M 3 3).re) / 4 : ℝ) • (1 : Cl0 5)
  + (((M 0 3).im + (M 1 2).im + (M 2 1).im + (M 3 0).im) / 4 : ℝ) • cl05_gen 0
  + (((M 0 3).re - (M 1 2).re + (M 2 1).re - (M 3 0).re) / 4 : ℝ) • cl05_gen 1
  + (((M 0 2).im - (M 1 3).im + (M 2 0).im - (M 3 1).im) / 4 : ℝ) • cl05_gen 2
  + (((M 0 2).re + (M 1 3).re - (M 2 0).re - (M 3 1).re) / 4 : ℝ) • cl05_gen 3
  + (((M 0 0).im + (M 1 1).im - (M 2 2).im - (M 3 3).im) / 4 : ℝ) • cl05_gen 4
  + ((-(M 0 0).im + (M 1 1).im - (M 2 2).im + (M 3 3).im) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 1)
  + (((M 0 1).re - (M 1 0).re + (M 2 3).re - (M 3 2).re) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 2)
  + ((-(M 0 1).im - (M 1 0).im + (M 2 3).im + (M 3 2).im) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 3)
  + (((M 0 3).re + (M 1 2).re - (M 2 1).re - (M 3 0).re) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 4)
  + ((-(M 0 1).im - (M 1 0).im - (M 2 3).im - (M 3 2).im) / 4 : ℝ) • (cl05_gen 1 * cl05_gen 2)
  + ((-(M 0 1).re + (M 1 0).re + (M 2 3).re - (M 3 2).re) / 4 : ℝ) • (cl05_gen 1 * cl05_gen 3)
  + ((-(M 0 3).im + (M 1 2).im + (M 2 1).im - (M 3 0).im) / 4 : ℝ) • (cl05_gen 1 * cl05_gen 4)
  + ((-(M 0 0).im + (M 1 1).im + (M 2 2).im - (M 3 3).im) / 4 : ℝ) • (cl05_gen 2 * cl05_gen 3)
  + (((M 0 2).re - (M 1 3).re - (M 2 0).re + (M 3 1).re) / 4 : ℝ) • (cl05_gen 2 * cl05_gen 4)
  + ((-(M 0 2).im - (M 1 3).im - (M 2 0).im - (M 3 1).im) / 4 : ℝ) • (cl05_gen 3 * cl05_gen 4)
  + (((M 0 2).re + (M 1 3).re + (M 2 0).re + (M 3 1).re) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 1 * cl05_gen 2)
  + ((-(M 0 2).im + (M 1 3).im + (M 2 0).im - (M 3 1).im) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 1 * cl05_gen 3)
  + (((M 0 0).re - (M 1 1).re - (M 2 2).re + (M 3 3).re) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 1 * cl05_gen 4)
  + (((M 0 3).re - (M 1 2).re - (M 2 1).re + (M 3 0).re) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 2 * cl05_gen 3)
  + (((M 0 1).im - (M 1 0).im - (M 2 3).im + (M 3 2).im) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 2 * cl05_gen 4)
  + (((M 0 1).re + (M 1 0).re + (M 2 3).re + (M 3 2).re) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 3 * cl05_gen 4)
  + ((-(M 0 3).im - (M 1 2).im + (M 2 1).im + (M 3 0).im) / 4 : ℝ) • (cl05_gen 1 * cl05_gen 2 * cl05_gen 3)
  + (((M 0 1).re + (M 1 0).re - (M 2 3).re - (M 3 2).re) / 4 : ℝ) • (cl05_gen 1 * cl05_gen 2 * cl05_gen 4)
  + ((-(M 0 1).im + (M 1 0).im - (M 2 3).im + (M 3 2).im) / 4 : ℝ) • (cl05_gen 1 * cl05_gen 3 * cl05_gen 4)
  + (((M 0 0).re - (M 1 1).re + (M 2 2).re - (M 3 3).re) / 4 : ℝ) • (cl05_gen 2 * cl05_gen 3 * cl05_gen 4)
  + ((-(M 0 0).re - (M 1 1).re + (M 2 2).re + (M 3 3).re) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 1 * cl05_gen 2 * cl05_gen 3)
  + ((-(M 0 2).im - (M 1 3).im + (M 2 0).im + (M 3 1).im) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 1 * cl05_gen 2 * cl05_gen 4)
  + ((-(M 0 2).re + (M 1 3).re - (M 2 0).re + (M 3 1).re) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 1 * cl05_gen 3 * cl05_gen 4)
  + ((-(M 0 3).im + (M 1 2).im - (M 2 1).im + (M 3 0).im) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 2 * cl05_gen 3 * cl05_gen 4)
  + ((-(M 0 3).re - (M 1 2).re - (M 2 1).re - (M 3 0).re) / 4 : ℝ) • (cl05_gen 1 * cl05_gen 2 * cl05_gen 3 * cl05_gen 4)
  + ((-(M 0 0).im - (M 1 1).im - (M 2 2).im - (M 3 3).im) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 1 * cl05_gen 2 * cl05_gen 3 * cl05_gen 4)

/-! ## §5. Right Inverse: cl05_forward ∘ cl05_inv = id -/

/-
The forward map applied to the inverse gives the identity on M₄(ℂ).
-/
theorem cl05_forward_inv (M : M4C) :
    cl05_forward (cl05_inv M) = M := by
  revert M;
  intro M
  unfold cl05_inv cl05_forward
  simp [cl05_forward_gen, cl05_gen] at *;
  simp +decide [ cl05_forward_lin, _root_.stdBasis ];
  simp +decide [ cl05_img ];
  simp +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ ] at *;
  simp +decide [ Complex.ext_iff ] at *;
  grind

/-! ## §6. Surjectivity (from the right inverse) -/

theorem cl05_forward_surjective : Function.Surjective cl05_forward :=
  fun M => ⟨cl05_inv M, cl05_forward_inv M⟩

/-! ## §7. Injectivity (from surjectivity + equal finite dimensions) -/

private theorem finrank_M4C : Module.finrank ℝ M4C = 32 := by
  simp [Module.finrank_matrix, Complex.finrank_real_complex]

/-
The forward map is injective.
    Since Cl(0,5) is finite-dimensional (CliffordCl05Finite) with finrank ≤ 32,
    and cl05_forward is surjective onto the 32-dimensional M₄(ℂ),
    the finranks must be equal, so surjective → injective.
-/
theorem cl05_forward_injective : Function.Injective cl05_forward := by
  have h_le := finrank_Cl05_le_32
  have h_rn := LinearMap.finrank_range_add_finrank_ker cl05_forward.toLinearMap
  rw [LinearMap.range_eq_top.mpr cl05_forward_surjective, finrank_top, finrank_M4C] at h_rn
  have h_ker : Module.finrank ℝ (LinearMap.ker cl05_forward.toLinearMap) = 0 := by omega
  rwa [Submodule.finrank_eq_zero, LinearMap.ker_eq_bot] at h_ker

/-! ## §8. Main Result -/

/-- **Main theorem**: Cl(0,5) ≃ₐ[ℝ] M₄(ℂ) -/
noncomputable def cl0_five_equiv : Cl0 5 ≃ₐ[ℝ] M4C :=
  AlgEquiv.ofBijective cl05_forward ⟨cl05_forward_injective, cl05_forward_surjective⟩
