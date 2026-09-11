/-
# Finite Dimensionality of Cl(0,4)

We prove that Cl(0,4) is a finite-dimensional ℝ-vector space.
The 16 ordered monomials of distinct generators span the algebra.
-/

import Mathlib
import RequestProject.CliffordBase

set_option maxHeartbeats 3200000

open CliffordAlgebra Submodule

noncomputable section

def cl04g (i : Fin 4) : Cl0 4 := ι (negDefForm 4) (stdBasis 4 i)

theorem cl04g_sq (i : Fin 4) : cl04g i * cl04g i = -(1 : Cl0 4) := by
  unfold cl04g; rw [ι_sq_scalar, negDefForm_basis]; simp

theorem cl04g_swap {i j : Fin 4} (hij : i ≠ j) :
    cl04g i * cl04g j = -(cl04g j * cl04g i) := by
  apply eq_neg_of_add_eq_zero_left
  unfold cl04g
  fin_cases i <;> fin_cases j <;> simp_all +decide
  all_goals simp +decide [ι_mul_ι_add_swap, negDefForm, _root_.stdBasis]
  all_goals simp +decide [Fin.sum_univ_four, QuadraticMap.polar]

theorem ι_expand (v : Fin 4 → ℝ) : ι (negDefForm 4) v = ∑ i : Fin 4, v i • cl04g i := by
  simp only [cl04g]
  have : v = ∑ i : Fin 4, v i • stdBasis 4 i := by
    ext j; simp [stdBasis, Pi.single, Function.update]
  conv_lhs => rw [this]
  simp [map_sum, map_smul]

def cl04_monoSet : Set (Cl0 4) := {(1 : Cl0 4),
    cl04g 0, cl04g 1, cl04g 2, cl04g 3,
    cl04g 0 * cl04g 1, cl04g 0 * cl04g 2, cl04g 0 * cl04g 3,
    cl04g 1 * cl04g 2, cl04g 1 * cl04g 3, cl04g 2 * cl04g 3,
    cl04g 0 * cl04g 1 * cl04g 2, cl04g 0 * cl04g 1 * cl04g 3,
    cl04g 0 * cl04g 2 * cl04g 3, cl04g 1 * cl04g 2 * cl04g 3,
    cl04g 0 * cl04g 1 * cl04g 2 * cl04g 3}

abbrev cl04_monoSpan : Submodule ℝ (Cl0 4) := span ℝ cl04_monoSet

private theorem ms (x : Cl0 4) (hx : x ∈ cl04_monoSet) : x ∈ cl04_monoSpan :=
  subset_span hx

private theorem nms (x : Cl0 4) (hx : x ∈ cl04_monoSet) : -x ∈ cl04_monoSpan :=
  neg_mem (subset_span hx)

/-
Left multiplication by e₀ preserves the monomial span
-/
theorem e0_mul_mem_span (x : Cl0 4) (hx : x ∈ cl04_monoSpan) :
    cl04g 0 * x ∈ cl04_monoSpan := by
  refine' Submodule.span_induction _ _ _ _ hx;
  · intro x hx; rcases hx with ( rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl ) <;> norm_num [ ms, nms ] ;
    all_goals norm_num [ ← mul_assoc, cl04g_sq ];
    all_goals exact ms _ ( by tauto ) ;
  · simp +decide [ Submodule.zero_mem ];
  · exact fun x y hx hy hx' hy' => by simpa only [ mul_add ] using Submodule.add_mem _ hx' hy';
  · exact fun a x hx hx' => by simpa [ mul_smul_comm ] using Submodule.smul_mem _ a hx';

/-
Left multiplication by e₁ preserves the monomial span
-/
theorem e1_mul_mem_span (x : Cl0 4) (hx : x ∈ cl04_monoSpan) :
    cl04g 1 * x ∈ cl04_monoSpan := by
  refine' Submodule.span_induction _ _ _ _ hx <;> norm_num [ Submodule.mem_span ] at *;
  · intro x hx p hp;
    rcases hx with ( rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl ) <;> norm_num [ hp ];
    all_goals simp_all +decide only [cl04_monoSet, Set.insert_subset_iff, Set.singleton_subset_iff];
    any_goals tauto;
    exact p.smul_mem ( -1 ) hp.2.2.2.2.2.1 |> fun h => by simpa [ cl04g_swap ( show 0 ≠ 1 by decide ) ] using h;
    exact p.smul_mem ( -1 ) hp.1 |> fun h => by simpa [ cl04g_sq ] using h;
    have h_swap : cl04g 1 * cl04g 0 = -(cl04g 0 * cl04g 1) := by
      exact cl04g_swap ( by decide )
    generalize_proofs at *; (
    rw [ ← mul_assoc, h_swap ] ; norm_num [ hp ] ;
    rw [ mul_assoc, cl04g_sq ] ; norm_num [ hp ] ;
    exact hp.2.1);
    exact p.smul_mem ( -1 ) hp.2.2.2.2.2.2.2.2.2.2.2.1 |> fun h => by simpa [ cl04g_swap ( show 0 ≠ 1 by decide ), mul_assoc ] using h;
    exact p.smul_mem ( -1 ) hp.2.2.2.2.2.2.2.2.2.2.2.2.1 |> fun h => by simpa [ cl04g_swap ( show 0 ≠ 1 by decide ), mul_assoc ] using h;
    have h_swap : cl04g 1 * cl04g 1 = -(1 : Cl0 4) := by
      exact cl04g_sq 1
    generalize_proofs at *; (
    simp_all +decide [ ← mul_assoc ]);
    have h_swap : cl04g 1 * cl04g 1 = -(1 : Cl0 4) := by
      exact cl04g_sq 1
    generalize_proofs at *; (
    rw [ ← mul_assoc, h_swap ] ; norm_num [ hp ];
    exact hp.2.2.2.2.1);
    exact hp.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1 |> fun h => by simpa [ mul_assoc ] using h;
    · have h_swap : cl04g 1 * (cl04g 0 * cl04g 1 * cl04g 2) = -(cl04g 0 * cl04g 1 * cl04g 1 * cl04g 2) := by
        simp +decide [ mul_assoc, cl04g_swap ( show 0 ≠ 1 by decide ) ]
      generalize_proofs at *; (
      simp_all +decide [ mul_assoc, cl04g_sq ]);
    · have h_swap : cl04g 1 * cl04g 0 = -(cl04g 0 * cl04g 1) := by
        exact cl04g_swap ( by decide )
      generalize_proofs at *; (
      simp_all +decide [ ← mul_assoc ];
      have h_swap : cl04g 1 * cl04g 1 = -(1 : Cl0 4) := by
        exact cl04g_sq 1
      generalize_proofs at *; (
      simp_all +decide [ mul_assoc ]));
    · have h_swap : cl04g 1 * cl04g 0 = -(cl04g 0 * cl04g 1) := by
        exact cl04g_swap ( by decide )
      generalize_proofs at *; (
      simp_all +decide [ ← mul_assoc ]);
    · have h_swap : cl04g 1 * cl04g 1 = -(1 : Cl0 4) := by
        exact cl04g_sq 1
      generalize_proofs at *; (
      simp_all +decide [ ← mul_assoc ]);
    · have h_swap : cl04g 1 * (cl04g 0 * cl04g 1 * cl04g 2 * cl04g 3) = -(cl04g 0 * cl04g 1 * cl04g 1 * cl04g 2 * cl04g 3) := by
        simp +decide [ mul_assoc, cl04g_swap ( show 0 ≠ 1 by decide ) ]
      generalize_proofs at *; (
      simp_all +decide [ mul_assoc, cl04g_sq ]);
  · exact fun x y hx hy hx' hy' p hp => by simpa only [ mul_add ] using p.add_mem ( hx' p hp ) ( hy' p hp ) ;
  · exact fun a x hx₁ hx₂ p hp => p.smul_mem a ( hx₂ p hp )

/-
Left multiplication by e₂ preserves the monomial span
-/
theorem e2_mul_mem_span (x : Cl0 4) (hx : x ∈ cl04_monoSpan) :
    cl04g 2 * x ∈ cl04_monoSpan := by
  refine' Submodule.span_induction _ _ _ _ hx <;> norm_num +zetaDelta at *;
  · intro x hx
    simp [cl04_monoSet] at hx;
    rcases hx with ( rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl ) <;> simp +decide [ cl04_monoSpan, Submodule.mem_span ];
    all_goals intro p hp; simp_all +decide only [cl04_monoSet];
    all_goals simp_all +decide only [Set.insert_subset_iff, Set.singleton_subset_iff];
    all_goals simp_all +decide [ ← mul_assoc, ← eq_sub_iff_add_eq' ];
    all_goals simp_all +decide [ mul_assoc, cl04g_swap ( show 2 ≠ 0 by decide ), cl04g_swap ( show 2 ≠ 1 by decide ), cl04g_swap ( show 2 ≠ 3 by decide ), cl04g_sq ];
  · exact fun x y hx hy hx' hy' => by simpa only [ mul_add ] using AddMemClass.add_mem hx' hy';
  · exact fun a x hx hx' => Submodule.smul_mem _ _ hx'

/-
Left multiplication by e₃ preserves the monomial span
-/
theorem e3_mul_mem_span (x : Cl0 4) (hx : x ∈ cl04_monoSpan) :
    cl04g 3 * x ∈ cl04_monoSpan := by
  revert hx;
  refine' Submodule.span_induction _ _ _ _;
  · rintro x ( rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl ) <;> simp +decide [ *, mul_assoc, Submodule.mem_span ];
    all_goals intro p hp; simp_all +decide only [cl04_monoSet, Set.insert_subset_iff, Set.singleton_subset_iff];
    all_goals simp_all +decide [ mul_assoc, mul_left_comm, mul_comm ];
    all_goals simp_all +decide only [← mul_assoc];
    all_goals have := cl04g_swap ( show 3 ≠ 0 by decide ) ; have := cl04g_swap ( show 3 ≠ 1 by decide ) ; have := cl04g_swap ( show 3 ≠ 2 by decide ) ; simp_all +decide [ mul_assoc, sub_eq_iff_eq_add ] ;
    all_goals rw [ cl04g_sq ] ; simp +decide [ hp ] ;
  · norm_num;
  · exact fun x y hx hy hx' hy' => by simpa only [ mul_add ] using Submodule.add_mem _ hx' hy';
  · exact fun a x hx hx' => by simpa [ mul_smul_comm ] using Submodule.smul_mem _ a hx';

-- The monomial span equals the whole algebra
theorem cl04_monoSpan_eq_top : cl04_monoSpan = ⊤ := by
  rw [Submodule.eq_top_iff']
  intro x
  induction x using CliffordAlgebra.induction with
  | algebraMap r =>
    rw [Algebra.algebraMap_eq_smul_one]
    exact smul_mem _ r (ms _ (by simp [cl04_monoSet]))
  | ι v =>
    rw [ι_expand]
    apply sum_mem
    intro i _
    apply smul_mem
    exact ms _ (by fin_cases i <;> simp [cl04_monoSet])
  | mul a b ha hb =>
    refine span_induction ?_ ?_ ?_ ?_ ha
    · intro a ha
      simp only [cl04_monoSet, Set.mem_insert_iff, Set.mem_singleton_iff] at ha
      rcases ha with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
        rfl | rfl | rfl | rfl | rfl | rfl | rfl
      · rwa [one_mul]
      · exact e0_mul_mem_span b hb
      · exact e1_mul_mem_span b hb
      · exact e2_mul_mem_span b hb
      · exact e3_mul_mem_span b hb
      · rw [mul_assoc]; exact e0_mul_mem_span _ (e1_mul_mem_span b hb)
      · rw [mul_assoc]; exact e0_mul_mem_span _ (e2_mul_mem_span b hb)
      · rw [mul_assoc]; exact e0_mul_mem_span _ (e3_mul_mem_span b hb)
      · rw [mul_assoc]; exact e1_mul_mem_span _ (e2_mul_mem_span b hb)
      · rw [mul_assoc]; exact e1_mul_mem_span _ (e3_mul_mem_span b hb)
      · rw [mul_assoc]; exact e2_mul_mem_span _ (e3_mul_mem_span b hb)
      · rw [mul_assoc, mul_assoc]
        exact e0_mul_mem_span _ (e1_mul_mem_span _ (e2_mul_mem_span b hb))
      · rw [mul_assoc, mul_assoc]
        exact e0_mul_mem_span _ (e1_mul_mem_span _ (e3_mul_mem_span b hb))
      · rw [mul_assoc, mul_assoc]
        exact e0_mul_mem_span _ (e2_mul_mem_span _ (e3_mul_mem_span b hb))
      · rw [mul_assoc, mul_assoc]
        exact e1_mul_mem_span _ (e2_mul_mem_span _ (e3_mul_mem_span b hb))
      · rw [mul_assoc, mul_assoc, mul_assoc]
        exact e0_mul_mem_span _ (e1_mul_mem_span _ (e2_mul_mem_span _ (e3_mul_mem_span b hb)))
    · simp [zero_mul]
    · intro a c _ _ ha hc; rw [add_mul]; exact add_mem ha hc
    · intro r a _ ha; rw [smul_mul_assoc]; exact smul_mem _ r ha
  | add a b ha hb => exact add_mem ha hb

-- Cl(0,4) is a finite-dimensional ℝ-vector space
instance cl04_finiteDimensional : FiniteDimensional ℝ (Cl0 4) := by
  have : (⊤ : Submodule ℝ (Cl0 4)).FG := by
    rw [Submodule.fg_def]
    exact ⟨cl04_monoSet, by
      unfold cl04_monoSet
      apply Set.Finite.insert; apply Set.Finite.insert; apply Set.Finite.insert
      apply Set.Finite.insert; apply Set.Finite.insert; apply Set.Finite.insert
      apply Set.Finite.insert; apply Set.Finite.insert; apply Set.Finite.insert
      apply Set.Finite.insert; apply Set.Finite.insert; apply Set.Finite.insert
      apply Set.Finite.insert; apply Set.Finite.insert; apply Set.Finite.insert
      exact Set.finite_singleton _, cl04_monoSpan_eq_top⟩
  exact Module.finite_def.mpr this

end