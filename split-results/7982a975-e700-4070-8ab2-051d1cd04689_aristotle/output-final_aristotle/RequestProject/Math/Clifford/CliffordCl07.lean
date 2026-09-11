/-
# Cl(0,7): Finite Dimensionality and Algebra Isomorphism

Part 1: We prove that Cl(0,7) is a finite-dimensional ℝ-vector space of dimension ≤ 128,
using Finset-indexed ordered monomials.

Part 2: We construct an explicit ℝ-algebra isomorphism Cl(0,7) ≃ₐ[ℝ] M₈(ℝ) × M₈(ℝ).
-/

import Mathlib
import RequestProject.Math.Clifford.CliffordBase
import RequestProject.Math.Clifford.CliffordCl07Surj

set_option maxHeartbeats 800000

open CliffordAlgebra Submodule

noncomputable section

/-! ## Part 1: Finite Dimensionality -/

def cl07g (i : Fin 7) : Cl0 7 := ι (negDefForm 7) (stdBasis 7 i)

theorem cl07g_sq (i : Fin 7) : cl07g i * cl07g i = -(1 : Cl0 7) := by
  unfold cl07g; rw [ι_sq_scalar, negDefForm_basis]; simp

set_option maxHeartbeats 6400000 in
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

/-! ### Ordered Monomials via Finset -/

/-- The ordered monomial for a subset S ⊆ Fin 7: product of cl07g i for i ∈ S in increasing order. -/
noncomputable def cl07_mono (S : Finset (Fin 7)) : Cl0 7 :=
  (S.sort (· ≤ ·)).foldr (fun i acc => cl07g i * acc) 1

/-- The set of all ordered monomials. -/
def cl07_monoSet : Set (Cl0 7) := Set.range cl07_mono

/-- The span of all ordered monomials. -/
abbrev cl07_monoSpan : Submodule ℝ (Cl0 7) := span ℝ cl07_monoSet

/-- The monomial set is finite (image of a finite type). -/
theorem cl07_monoSet_finite : cl07_monoSet.Finite := Set.finite_range cl07_mono

/-- Helper: the foldr product of a list of generators times something in the span is in the span,
    assuming each generator multiplication preserves the span. -/
private theorem foldr_mul_mem_span (l : List (Fin 7)) (x : Cl0 7) (hx : x ∈ cl07_monoSpan)
    (hmul : ∀ i : Fin 7, ∀ y : Cl0 7, y ∈ cl07_monoSpan → cl07g i * y ∈ cl07_monoSpan) :
    (l.foldr (fun i acc => cl07g i * acc) 1) * x ∈ cl07_monoSpan := by
  induction l with
  | nil => simp; exact hx
  | cons j l ih =>
    simp only [List.foldr_cons]
    rw [mul_assoc]
    exact hmul j _ ih

/-- If j is smaller than all elements of a list, then cl07g j * foldr = foldr of j :: l. -/
private theorem gen_cons_foldr (j : Fin 7) (l : List (Fin 7)) :
    cl07g j * l.foldr (fun i acc => cl07g i * acc) 1 =
    (j :: l).foldr (fun i acc => cl07g i * acc) 1 := by
  simp [List.foldr_cons]

/-
Decompose a nonempty monomial: cl07_mono S = cl07g (min S) * cl07_mono (S.erase (min S)).
-/
private theorem cl07_mono_min_mul (S : Finset (Fin 7)) (hS : S.Nonempty) :
    cl07_mono S = cl07g (S.min' hS) * cl07_mono (S.erase (S.min' hS)) := by
  unfold cl07_mono;
  rw [ show S.sort ( · ≤ · ) = S.min' hS :: ( S.erase ( S.min' hS ) ).sort ( · ≤ · ) from ?_ ];
  · rfl;
  · native_decide +revert

/-
Inserting a minimal element: if i ≤ all of S and i ∉ S, then
    cl07_mono (insert i S) = cl07g i * cl07_mono S.
-/
private theorem cl07_mono_insert_le (i : Fin 7) (S : Finset (Fin 7))
    (hle : ∀ s ∈ S, i ≤ s) (hi : i ∉ S) :
    cl07_mono (insert i S) = cl07g i * cl07_mono S := by
  -- Apply the Finset.sort_insert lemma to show that (insert i S).sort (· ≤ ·) = i :: S.sort (· ≤ ·).
  have h_sort_insert : (insert i S).sort (· ≤ ·) = i :: S.sort (· ≤ ·) := by
    native_decide +revert;
  unfold cl07_mono; aesop;

/-
The explicit signed formula: cl07g i * cl07_mono S = ε • cl07_mono T for some integer ε
    and finset T ⊆ S ∪ {i}. This is proved by induction on the number of elements of S
    that are less than i.
-/
private theorem gen_mul_mono_signed (i : Fin 7) (S : Finset (Fin 7)) :
    ∃ (ε : ℤ) (T : Finset (Fin 7)),
      cl07g i * cl07_mono S = (ε : ℝ) • cl07_mono T ∧ T ⊆ S ∪ {i} := by
  -- By induction on the number of elements of S that are less than i.
  induction' n : (S.filter (· < i)).card using Nat.strong_induction_on with n ih generalizing S;
  by_cases h : ∃ j ∈ S, j < i;
  · obtain ⟨j, hjS, hj⟩ : ∃ j ∈ S, j < i ∧ ∀ k ∈ S, k < i → j ≤ k := by
      obtain ⟨ j, hj₁, hj₂ ⟩ := h; exact ⟨ Finset.min' ( Finset.filter ( fun x => x < i ) S ) ⟨ j, by aesop ⟩, Finset.mem_filter.mp ( Finset.min'_mem ( Finset.filter ( fun x => x < i ) S ) ⟨ j, by aesop ⟩ ) |>.1, Finset.mem_filter.mp ( Finset.min'_mem ( Finset.filter ( fun x => x < i ) S ) ⟨ j, by aesop ⟩ ) |>.2, fun k hk₁ hk₂ => Finset.min'_le _ _ <| by aesop ⟩ ;
    -- By the induction hypothesis, there exist ε' and T' such that cl07g i * cl07_mono (S.erase j) = (ε' : ℝ) • cl07_mono T' and T' ⊆ (S.erase j) ∪ {i}.
    obtain ⟨ε', T', hε'T'⟩ : ∃ ε' : ℤ, ∃ T' : Finset (Fin 7), cl07g i * cl07_mono (S.erase j) = (ε' : ℝ) • cl07_mono T' ∧ T' ⊆ (S.erase j) ∪ {i} := by
      apply ih (Finset.card (Finset.filter (fun x => x < i) (S.erase j)));
      · rw [ ← n ];
        refine' Finset.card_lt_card _;
        simp_all +decide [ Finset.ssubset_def, Finset.subset_iff ];
      · rfl;
    -- By the properties of the Clifford algebra, we have cl07g j * cl07_mono T' = cl07_mono (insert j T').
    have h_clifford : cl07g j * cl07_mono T' = cl07_mono (insert j T') := by
      apply Eq.symm; exact (by
        have h_clifford : ∀ k ∈ T', j ≤ k := by
          grind
        apply cl07_mono_insert_le j T' h_clifford (by
        intro hjT'
        have := hε'T'.right hjT'
        simp_all +decide [ Finset.subset_iff ]));
    -- By the properties of the Clifford algebra, we have cl07g i * cl07_mono S = -(cl07g j * (cl07g i * cl07_mono (S.erase j))).
    have h_clifford : cl07g i * cl07_mono S = -(cl07g j * (cl07g i * cl07_mono (S.erase j))) := by
      rw [ cl07_mono_min_mul S ⟨ j, hjS ⟩ ];
      rw [ show S.min' ⟨ j, hjS ⟩ = j from le_antisymm ( Finset.min'_le _ _ hjS ) ( hj.2 _ ( Finset.min'_mem _ ⟨ j, hjS ⟩ ) ( lt_of_le_of_lt ( Finset.min'_le _ _ hjS ) hj.1 ) ) ];
      rw [ ← mul_assoc, cl07g_swap ];
      · rw [ neg_mul, mul_assoc ];
      · exact ne_of_gt hj.1;
    use -ε', insert j T';
    simp_all +decide [ Finset.subset_iff ];
    grind;
  · by_cases hi : i ∈ S;
    · rw [ cl07_mono_min_mul S ( Finset.nonempty_of_ne_empty ( by aesop_cat ) ) ];
      rw [ show S.min' ( Finset.nonempty_of_ne_empty ( by aesop_cat ) ) = i from le_antisymm ( Finset.min'_le _ _ hi ) ( not_lt.mp fun contra => h ⟨ _, Finset.min'_mem _ _, contra ⟩ ) ];
      rw [ ← mul_assoc, cl07g_sq ];
      exact ⟨ -1, S.erase i, by norm_num, Finset.Subset.trans ( Finset.erase_subset _ _ ) ( Finset.subset_union_left ) ⟩;
    · refine' ⟨ 1, S ∪ { i }, _, _ ⟩ <;> simp_all +decide [ Finset.subset_iff ];
      rw [ cl07_mono_insert_le i S h hi ]

/-- Multiplication by generator i sends each monomial into the monomial span. -/
private theorem gen_mul_mono_mem_span (i : Fin 7) (S : Finset (Fin 7)) :
    cl07g i * cl07_mono S ∈ cl07_monoSpan := by
  obtain ⟨ε, T, heq, _⟩ := gen_mul_mono_signed i S
  rw [heq]
  exact Submodule.smul_mem _ (ε : ℝ) (Submodule.subset_span ⟨T, rfl⟩)

/-- Key lemma: multiplication by generator i preserves the monomial span. -/
theorem ei_mul_mono_mem_span (i : Fin 7) (x : Cl0 7) (hx : x ∈ cl07_monoSpan) :
    cl07g i * x ∈ cl07_monoSpan := by
  refine Submodule.span_induction ?_ ?_ ?_ ?_ hx
  · intro x ⟨S, hS⟩
    rw [← hS]
    exact gen_mul_mono_mem_span i S
  · simp [mul_zero]
  · intro a b _ _ ha hb; rw [mul_add]; exact add_mem ha hb
  · intro r a _ ha; rw [mul_smul_comm]; exact Submodule.smul_mem _ r ha

/-- The monomial span equals the whole algebra. -/
theorem cl07_monoSpan_eq_top : cl07_monoSpan = ⊤ := by
  rw [Submodule.eq_top_iff']
  intro x
  induction x using CliffordAlgebra.induction with
  | algebraMap r =>
    rw [Algebra.algebraMap_eq_smul_one]
    have h1 : cl07_mono ∅ = 1 := by simp [cl07_mono, Finset.sort_empty]
    exact smul_mem _ r (subset_span ⟨∅, h1⟩)
  | ι v =>
    rw [ι_expand7]
    apply sum_mem
    intro i _
    apply smul_mem
    have hi : cl07_mono {i} = cl07g i := by simp [cl07_mono, Finset.sort_singleton, List.foldr]
    exact subset_span ⟨{i}, hi⟩
  | mul a b ha hb =>
    refine span_induction ?_ ?_ ?_ ?_ ha
    · intro a ⟨S, hS⟩
      rw [← hS]
      exact foldr_mul_mem_span (S.sort (· ≤ ·)) b hb ei_mul_mono_mem_span
    · simp [zero_mul]
    · intro a c _ _ ha hc; rw [add_mul]; exact add_mem ha hc
    · intro r a _ ha; rw [smul_mul_assoc]; exact smul_mem _ r ha
  | add a b ha hb => exact add_mem ha hb

/-- Cl(0,7) is a finite-dimensional ℝ-vector space. -/
instance cl07_finiteDimensional : FiniteDimensional ℝ (Cl0 7) := by
  have : (⊤ : Submodule ℝ (Cl0 7)).FG := by
    rw [Submodule.fg_def]
    exact ⟨cl07_monoSet, cl07_monoSet_finite, cl07_monoSpan_eq_top⟩
  exact Module.finite_def.mpr this

/-
The finrank of Cl(0,7) is at most 128 (the number of basis monomials).
-/
theorem finrank_Cl07_le_128 : Module.finrank ℝ (Cl0 7) ≤ 128 := by
  rw [← finrank_top (R := ℝ), ← cl07_monoSpan_eq_top]
  letI : Fintype cl07_monoSet := cl07_monoSet_finite.fintype
  exact (finrank_span_le_card cl07_monoSet).trans (by
  convert Finset.card_image_le;
  convert Set.toFinset_range _;
  all_goals try infer_instance;
  · apply Classical.decEq;
  · convert this;
  · native_decide +revert)

end

/-! ## Part 2: Algebra Isomorphism Cl(0,7) ≃ₐ[ℝ] M₈(ℝ) × M₈(ℝ) -/

/-
# Cl(0,7) ≃ₐ[ℝ] M₈(ℝ) × M₈(ℝ)

We construct an explicit ℝ-algebra isomorphism between the Clifford algebra
Cl(0,7) (of the negative-definite quadratic form on ℝ⁷) and the product
of matrix algebras M₈(ℝ) × M₈(ℝ).

## Strategy

The 7 generator images are pairs of 8×8 real matrices:
- Generators e₀,...,e₅ map to (γᵢ, γᵢ) where γᵢ are the Cl(0,6) generators
- Generator e₆ maps to (ω, -ω) where ω = γ₀γ₁γ₂γ₃γ₄γ₅ is the volume element

## Performance

All 8×8 matrix relation proofs use integer matrices with `native_decide`,
then lift to ℝ via the ring homomorphism ℤ →+* ℝ. This avoids the
Fin.sum_univ_eight expansion that causes timeouts with real matrices.

## Note

The correct Bott periodicity: Cl(0,7) ≃ M₈(ℝ) ⊕ M₈(ℝ), **not** M₈(ℂ).
-/


set_option maxHeartbeats 6400000

open CliffordAlgebra Matrix

abbrev M8R_cl07 := Matrix (Fin 8) (Fin 8) ℝ
abbrev M8R2 := M8R_cl07 × M8R_cl07
abbrev M8Z := Matrix (Fin 8) (Fin 8) ℤ

/-- The ring homomorphism ℤ → ℝ lifted to 8×8 matrices. -/
noncomputable abbrev liftZ : M8Z →+* M8R_cl07 := (Int.castRingHom ℝ).mapMatrix

/-! ## §1. Basic Elements and Relations -/

noncomputable def cl07_gen (i : Fin 7) : Cl0 7 :=
  ι (negDefForm 7) (stdBasis 7 i)

theorem cl07_gen_sq (i : Fin 7) :
    cl07_gen i * cl07_gen i = -(1 : Cl0 7) := by
  unfold cl07_gen; rw [ι_sq_scalar, negDefForm_basis]; simp

set_option maxHeartbeats 6400000 in
theorem cl07_gen_swap {i j : Fin 7} (hij : i ≠ j) :
    cl07_gen i * cl07_gen j = -(cl07_gen j * cl07_gen i) := by
  unfold cl07_gen;
  rw [ eq_neg_iff_add_eq_zero, ι_mul_ι_add_swap ];
  simp +decide [ _root_.stdBasis, Finset.sum_apply, Finset.sum_ite_eq, Finset.filter_eq', Finset.filter_ne' ];
  simp +decide [ QuadraticMap.polar, negDefForm ];
  simp +decide [ Finset.sum_add_distrib, add_mul, mul_add, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Pi.single_apply ];
  aesop

/-! ## §2. Integer Gamma Matrices

We define the matrices over ℤ for fast `native_decide` proofs,
then cast to ℝ via `liftZ`. -/

def gammaZ : Fin 6 → M8Z
  | 0 => !![  0, -1,  0,  0,  0,  0,  0,  0;
              1,  0,  0,  0,  0,  0,  0,  0;
              0,  0,  0, -1,  0,  0,  0,  0;
              0,  0,  1,  0,  0,  0,  0,  0;
              0,  0,  0,  0,  0,  1,  0,  0;
              0,  0,  0,  0, -1,  0,  0,  0;
              0,  0,  0,  0,  0,  0,  0,  1;
              0,  0,  0,  0,  0,  0, -1,  0]
  | 1 => !![  0,  0, -1,  0,  0,  0,  0,  0;
              0,  0,  0,  1,  0,  0,  0,  0;
              1,  0,  0,  0,  0,  0,  0,  0;
              0, -1,  0,  0,  0,  0,  0,  0;
              0,  0,  0,  0,  0,  0,  1,  0;
              0,  0,  0,  0,  0,  0,  0, -1;
              0,  0,  0,  0, -1,  0,  0,  0;
              0,  0,  0,  0,  0,  1,  0,  0]
  | 2 => !![  0,  0,  0, -1,  0,  0,  0,  0;
              0,  0, -1,  0,  0,  0,  0,  0;
              0,  1,  0,  0,  0,  0,  0,  0;
              1,  0,  0,  0,  0,  0,  0,  0;
              0,  0,  0,  0,  0,  0,  0,  1;
              0,  0,  0,  0,  0,  0,  1,  0;
              0,  0,  0,  0,  0, -1,  0,  0;
              0,  0,  0,  0, -1,  0,  0,  0]
  | 3 => !![  0,  0,  0,  0,  1,  0,  0,  0;
              0,  0,  0,  0,  0,  1,  0,  0;
              0,  0,  0,  0,  0,  0,  1,  0;
              0,  0,  0,  0,  0,  0,  0,  1;
             -1,  0,  0,  0,  0,  0,  0,  0;
              0, -1,  0,  0,  0,  0,  0,  0;
              0,  0, -1,  0,  0,  0,  0,  0;
              0,  0,  0, -1,  0,  0,  0,  0]
  | 4 => !![  0,  0,  0,  0,  0,  1,  0,  0;
              0,  0,  0,  0, -1,  0,  0,  0;
              0,  0,  0,  0,  0,  0,  0, -1;
              0,  0,  0,  0,  0,  0,  1,  0;
              0,  1,  0,  0,  0,  0,  0,  0;
             -1,  0,  0,  0,  0,  0,  0,  0;
              0,  0,  0, -1,  0,  0,  0,  0;
              0,  0,  1,  0,  0,  0,  0,  0]
  | 5 => !![  0,  0,  0,  0,  0,  0,  1,  0;
              0,  0,  0,  0,  0,  0,  0,  1;
              0,  0,  0,  0, -1,  0,  0,  0;
              0,  0,  0,  0,  0, -1,  0,  0;
              0,  0,  1,  0,  0,  0,  0,  0;
              0,  0,  0,  1,  0,  0,  0,  0;
             -1,  0,  0,  0,  0,  0,  0,  0;
              0, -1,  0,  0,  0,  0,  0,  0]

/-- The volume element ω = γ₀γ₁γ₂γ₃γ₄γ₅ over ℤ. -/
def omegaZ : M8Z :=
  !![  0,  0,  0,  0,  0,  0,  0, -1;
       0,  0,  0,  0,  0,  0,  1,  0;
       0,  0,  0,  0,  0, -1,  0,  0;
       0,  0,  0,  0,  1,  0,  0,  0;
       0,  0,  0, -1,  0,  0,  0,  0;
       0,  0,  1,  0,  0,  0,  0,  0;
       0, -1,  0,  0,  0,  0,  0,  0;
       1,  0,  0,  0,  0,  0,  0,  0]

/-! ### Integer matrix relations (proved instantly by native_decide) -/

theorem gammaZ_sq (a : Fin 6) : gammaZ a * gammaZ a = -1 := by
  fin_cases a <;> native_decide

theorem omegaZ_sq : omegaZ * omegaZ = -1 := by native_decide

theorem gammaZ_anticommute {a b : Fin 6} (hab : a ≠ b) :
    gammaZ a * gammaZ b + gammaZ b * gammaZ a = 0 := by
  fin_cases a <;> fin_cases b <;> simp_all +decide <;> native_decide

theorem omegaZ_gamma_anticommute (a : Fin 6) :
    omegaZ * gammaZ a + gammaZ a * omegaZ = 0 := by
  fin_cases a <;> native_decide

theorem omegaZ_eq_product :
    omegaZ = gammaZ 0 * gammaZ 1 * gammaZ 2 * gammaZ 3 * gammaZ 4 * gammaZ 5 := by
  native_decide

/-! ## §3. Real Gamma Matrices (lifted from ℤ via ring hom) -/

noncomputable def cl07_gamma (a : Fin 6) : M8R_cl07 := liftZ (gammaZ a)
noncomputable def cl07_omega : M8R_cl07 := liftZ omegaZ

/-- Each gamma matrix squares to -I₈. -/
theorem cl07_gamma_sq (a : Fin 6) : cl07_gamma a * cl07_gamma a = -1 := by
  unfold cl07_gamma; rw [← map_mul, gammaZ_sq, map_neg, map_one]

/-- The volume element squares to -I₈. -/
theorem cl07_omega_sq : cl07_omega * cl07_omega = -1 := by
  unfold cl07_omega; rw [← map_mul, omegaZ_sq, map_neg, map_one]

/-- Gamma matrices anticommute. -/
theorem cl07_gamma_anticommute {a b : Fin 6} (hab : a ≠ b) :
    cl07_gamma a * cl07_gamma b + cl07_gamma b * cl07_gamma a = 0 := by
  unfold cl07_gamma; rw [← map_mul, ← map_mul, ← map_add,
    gammaZ_anticommute hab, map_zero]

/-- The volume element anticommutes with each gamma matrix. -/
theorem cl07_omega_gamma_anticommute (a : Fin 6) :
    cl07_omega * cl07_gamma a + cl07_gamma a * cl07_omega = 0 := by
  unfold cl07_omega cl07_gamma; rw [← map_mul, ← map_mul, ← map_add,
    omegaZ_gamma_anticommute, map_zero]

/-! ## §4. Generator Images in M₈(ℝ) × M₈(ℝ) -/

/-- The 7 generator images in M₈(ℝ) × M₈(ℝ).
    For i < 6: (γᵢ, γᵢ). For i = 6: (ω, -ω). -/
noncomputable def cl07_img : Fin 7 → M8R2
  | ⟨i, _⟩ =>
    if h : i < 6 then
      (cl07_gamma ⟨i, h⟩, cl07_gamma ⟨i, h⟩)
    else
      (cl07_omega, -cl07_omega)

/-- Each generator image squares to -(1,1). -/
theorem cl07_img_sq (a : Fin 7) : cl07_img a * cl07_img a = -1 := by
  obtain ⟨a, ha⟩ := a
  simp only [cl07_img]
  by_cases h6 : a < 6
  · simp only [h6, ↓reduceDIte, Prod.mk_mul_mk]
    exact Prod.ext (cl07_gamma_sq ⟨a, h6⟩) (cl07_gamma_sq ⟨a, h6⟩)
  · simp only [h6, ↓reduceDIte, Prod.mk_mul_mk, neg_mul, mul_neg, neg_neg]
    exact Prod.ext cl07_omega_sq cl07_omega_sq

/-- Generator images anticommute. -/
theorem cl07_img_anticommute {a b : Fin 7} (hab : a ≠ b) :
    cl07_img a * cl07_img b + cl07_img b * cl07_img a = 0 := by
  by_cases ha : a.val < 6
  · by_cases hb : b.val < 6
    · simp +decide [ cl07_img, ha, hb ];
      exact cl07_gamma_anticommute ( by simpa [ Fin.ext_iff ] using hab );
    · have hb_eq_6 : b = 6 := by omega
      simp_all +decide [ cl07_img ];
      exact ⟨ by simpa [ add_comm ] using cl07_omega_gamma_anticommute ⟨ a, by linarith ⟩,
              by simpa [ add_comm ] using congr_arg Neg.neg ( cl07_omega_gamma_anticommute ⟨ a, by linarith ⟩ ) ⟩;
  · fin_cases a <;> fin_cases b <;> simp +decide at ha hab ⊢;
    all_goals simp_all +decide [ Prod.ext_iff, cl07_img ];
    all_goals exact ⟨ cl07_omega_gamma_anticommute _, by rw [ ← neg_add, cl07_omega_gamma_anticommute ] ; norm_num ⟩ ;

/-! ## §5. Forward Map: Cl(0,7) → M₈(ℝ) × M₈(ℝ) -/

noncomputable def cl07_forward_lin : (Fin 7 → ℝ) →ₗ[ℝ] M8R2 where
  toFun v :=
    v 0 • cl07_img 0 + v 1 • cl07_img 1 + v 2 • cl07_img 2 +
    v 3 • cl07_img 3 + v 4 • cl07_img 4 + v 5 • cl07_img 5 +
    v 6 • cl07_img 6
  map_add' u w := by simp [add_smul]; abel
  map_smul' r v := by simp [smul_add, smul_smul]

/-
The forward linear map satisfies the Clifford relation.
-/
theorem cl07_clifford_sq (v : Fin 7 → ℝ) :
    cl07_forward_lin v * cl07_forward_lin v =
    algebraMap ℝ M8R2 (negDefForm 7 v) := by
      unfold cl07_forward_lin;
      simp +decide [ negDefForm, Fin.sum_univ_seven ];
      -- Apply the anticommutativity and square relations to each cross term.
      have h_cross_terms : ∀ i j : Fin 7, i ≠ j → (v i • cl07_img i) * (v j • cl07_img j) + (v j • cl07_img j) * (v i • cl07_img i) = 0 := by
        simp_all +decide [ mul_assoc, mul_comm, mul_left_comm, smul_smul ];
        exact fun i j hij => by rw [ ← smul_add, cl07_img_anticommute hij ] ; norm_num;
      simp_all +decide [ mul_add, add_mul, mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_add_distrib ];
      simp_all +decide [ cl07_img_sq, Algebra.smul_def ];
      simp_all +decide [ Prod.ext_iff, ← mul_assoc ];
      grind

/-- The forward algebra homomorphism via CliffordAlgebra.lift -/
noncomputable def cl07_forward : Cl0 7 →ₐ[ℝ] M8R2 :=
  CliffordAlgebra.lift (negDefForm 7) ⟨cl07_forward_lin, cl07_clifford_sq⟩

theorem cl07_forward_gen (v : Fin 7 → ℝ) :
    cl07_forward (ι (negDefForm 7) v) = cl07_forward_lin v :=
  CliffordAlgebra.lift_ι_apply _ _ v

/-! ## §6. Surjectivity and Inverse Map -/

/-
The forward map is surjective. Proved by showing the 64 gamma monomials
    are linearly independent (via trace-orthogonality from CliffordCl07Surj),
    hence span M₈(ℝ), and using the idempotent decomposition.
-/
private theorem cl07_forward_surjective_proof : Function.Surjective cl07_forward := by
  intro x;
  -- Consider the element $x = (x_1, x_2)$ in $M8R2$.
  obtain ⟨x1, x2⟩ := x;
  -- By definition of $cl07_forward$, we know that every element in $M8R2$ can be written as $cl07_forward(a)$ for some $a \in Cl0 7$.
  have h_surjective : ∀ x : M8R_cl07, ∃ a : Cl0 7, cl07_forward a = (x, x) := by
    intro x
    have h_surjective : ∀ S : Finset (Fin 6), ∃ a : Cl0 7, cl07_forward a = (liftZ (gammaMonoZ_s S), liftZ (gammaMonoZ_s S)) := by
      have h_gamma_mono_def : ∀ l : List (Fin 6), ∃ a : Cl0 7, cl07_forward a = (liftZ (l.foldr (fun i acc => gammaZ i * acc) 1), liftZ (l.foldr (fun i acc => gammaZ i * acc) 1)) := by
        intro l
        induction' l with i l ih;
        · use 1; simp [cl07_forward];
          rfl;
        · obtain ⟨ a, ha ⟩ := ih;
          use cl07_gen (Fin.castSucc i) * a;
          simp_all +decide [ cl07_forward_gen ];
          erw [ cl07_forward_gen ];
          unfold cl07_forward_lin; simp +decide [ _root_.stdBasis ] ;
          fin_cases i <;> simp +decide [ cl07_img ];
          all_goals ext i j; simp +decide [ cl07_gamma, liftZ ] ;
          all_goals simp +decide [ Matrix.mul_apply, Finset.sum_apply ] ;
      aesop;
    -- Since the gammaMonoZ_s S are linearly independent and span M8R_cl07, any x can be written as a linear combination of these matrices.
    have h_span : ∀ x : M8R_cl07, ∃ (c : Finset (Fin 6) → ℝ), x = ∑ S ∈ Finset.powerset (Finset.univ : Finset (Fin 6)), c S • liftZ (gammaMonoZ_s S) := by
      intro x
      have h_span : x ∈ Submodule.span ℝ (Set.range (fun S : Finset (Fin 6) => liftZ (gammaMonoZ_s S))) := by
        have h_span : LinearIndependent ℝ (fun S : Finset (Fin 6) => liftZ (gammaMonoZ_s S)) := by
          have h_orthogonal : ∀ S T : Finset (Fin 6), S ≠ T → Matrix.trace ((liftZ (gammaMonoZ_s S)).transpose * liftZ (gammaMonoZ_s T)) = 0 := by
            intros S T hST
            have h_trace : Matrix.trace ((gammaMonoZ_s S).transpose * (gammaMonoZ_s T)) = 0 := by
              grind +suggestions;
            convert congr_arg ( fun x : ℤ => x : ℤ → ℝ ) h_trace using 1;
            · simp +decide [ Matrix.trace, Matrix.mul_apply ];
            · norm_num;
          have h_orthogonal : ∀ S : Finset (Fin 6), Matrix.trace ((liftZ (gammaMonoZ_s S)).transpose * liftZ (gammaMonoZ_s S)) = 8 := by
            intro S; exact (by
            convert gram_diag_s S using 1;
            norm_num [ ← @Int.cast_inj ℝ ];
            norm_num [ Matrix.trace, Matrix.mul_apply ]);
          refine' Fintype.linearIndependent_iff.2 _;
          intro g hg i
          have h_inner : ∑ j, g j * Matrix.trace ((liftZ (gammaMonoZ_s i)).transpose * liftZ (gammaMonoZ_s j)) = 0 := by
            convert congr_arg ( fun x => Matrix.trace ( ( liftZ ( gammaMonoZ_s i ) )ᵀ * x ) ) hg using 1 <;> norm_num [ Matrix.mul_sum, Matrix.sum_mul ];
          rw [ Finset.sum_eq_single i ] at h_inner <;> simp_all +decide [ Finset.sum_ite, Finset.filter_ne ];
          exact fun j hj => Or.inr <| by rename_i h; exact h i j <| Ne.symm hj;
        have h_span : Submodule.span ℝ (Set.range (fun S : Finset (Fin 6) => liftZ (gammaMonoZ_s S))) = ⊤ := by
          refine' Submodule.eq_top_of_finrank_eq _;
          rw [ finrank_span_eq_card ] <;> norm_num [ h_span ];
          · norm_num [ Module.finrank ];
          · convert h_span using 1;
        aesop;
      rw [ Finsupp.mem_span_range_iff_exists_finsupp ] at h_span;
      obtain ⟨ c, hc ⟩ := h_span; use fun S => c S; simp_all +decide [ Finsupp.sum_fintype ] ;
    choose! f hf using h_surjective;
    obtain ⟨ c, rfl ⟩ := h_span x; use ∑ S ∈ Finset.powerset ( Finset.univ : Finset ( Fin 6 ) ), c S • f S; simp +decide [ hf, map_sum, map_smul ] ;
    induction' ( Finset.univ : Finset ( Finset ( Fin 6 ) ) ) using Finset.induction <;> aesop;
  -- By definition of $cl07_forward$, we know that every element in $M8R2$ can be written as $cl07_forward(a)$ for some $a \in Cl0 7$. Use this fact.
  obtain ⟨a1, ha1⟩ := h_surjective x1
  obtain ⟨a2, ha2⟩ := h_surjective x2;
  obtain ⟨a3, ha3⟩ : ∃ a3 : Cl0 7, cl07_forward a3 = (1, -1) := by
    have h_omega : cl07_forward (cl07_gen 0 * cl07_gen 1 * cl07_gen 2 * cl07_gen 3 * cl07_gen 4 * cl07_gen 5 * cl07_gen 6) = (-1, 1) := by
      have h_omega : cl07_forward (cl07_gen 0 * cl07_gen 1 * cl07_gen 2 * cl07_gen 3 * cl07_gen 4 * cl07_gen 5) = (cl07_omega, cl07_omega) := by
        have h_omega : cl07_forward (cl07_gen 0 * cl07_gen 1 * cl07_gen 2 * cl07_gen 3 * cl07_gen 4 * cl07_gen 5) = (cl07_gamma 0 * cl07_gamma 1 * cl07_gamma 2 * cl07_gamma 3 * cl07_gamma 4 * cl07_gamma 5, cl07_gamma 0 * cl07_gamma 1 * cl07_gamma 2 * cl07_gamma 3 * cl07_gamma 4 * cl07_gamma 5) := by
          simp +decide [ cl07_forward_gen, cl07_gen ];
          simp +decide [ cl07_forward_lin, _root_.stdBasis ];
          simp +decide [ cl07_img, cl07_gamma, cl07_omega ];
        rw [h_omega];
        unfold cl07_gamma cl07_omega;
        rw [ ← map_mul, ← map_mul, ← map_mul, ← map_mul, ← map_mul ];
        exact omegaZ_eq_product.symm ▸ rfl;
      have h_omega : cl07_forward (cl07_gen 6) = (cl07_omega, -cl07_omega) := by
        convert cl07_forward_gen ( stdBasis 7 6 ) using 1;
        unfold cl07_forward_lin; simp +decide [ _root_.stdBasis ] ;
        rfl;
      convert congr_arg₂ ( · * · ) ‹cl07_forward ( cl07_gen 0 * cl07_gen 1 * cl07_gen 2 * cl07_gen 3 * cl07_gen 4 * cl07_gen 5 ) = ( cl07_omega, cl07_omega ) › h_omega using 1;
      · exact map_mul _ _ _;
      · ext <;> norm_num [ cl07_omega_sq ];
    use -cl07_gen 0 * cl07_gen 1 * cl07_gen 2 * cl07_gen 3 * cl07_gen 4 * cl07_gen 5 * cl07_gen 6;
    simp_all +decide [ mul_assoc ];
  use (1 / 2 : ℝ) • (a1 + a2 + (a1 - a2) * a3);
  simp_all +decide [ Prod.ext_iff ];
  constructor <;> ext i j <;> norm_num <;> ring

noncomputable def cl07_inv (p : M8R2) : Cl0 7 :=
  (cl07_forward_surjective_proof p).choose

theorem cl07_forward_inv (p : M8R2) :
    cl07_forward (cl07_inv p) = p :=
  (cl07_forward_surjective_proof p).choose_spec

/-! ## §7. Surjectivity and Injectivity -/

theorem cl07_forward_surjective : Function.Surjective cl07_forward :=
  fun p => ⟨cl07_inv p, cl07_forward_inv p⟩

private theorem finrank_M8R2 : Module.finrank ℝ M8R2 = 128 := by
  simp [Module.finrank_prod, Module.finrank_matrix]

theorem cl07_forward_injective : Function.Injective cl07_forward := by
  have h_le := finrank_Cl07_le_128
  have h_rn := LinearMap.finrank_range_add_finrank_ker cl07_forward.toLinearMap
  rw [LinearMap.range_eq_top.mpr cl07_forward_surjective, finrank_top, finrank_M8R2] at h_rn
  have h_ker : Module.finrank ℝ (LinearMap.ker cl07_forward.toLinearMap) = 0 := by omega
  rwa [Submodule.finrank_eq_zero, LinearMap.ker_eq_bot] at h_ker

/-! ## §8. Main Result -/

/-- **Main theorem**: Cl(0,7) ≃ₐ[ℝ] M₈(ℝ) × M₈(ℝ) -/
noncomputable def cl0_seven_equiv : Cl0 7 ≃ₐ[ℝ] M8R2 :=
  AlgEquiv.ofBijective cl07_forward ⟨cl07_forward_injective, cl07_forward_surjective⟩

/-- The dimension of Cl(0,7) is 2⁷ = 128. -/
theorem dim_Cl07 : Module.finrank ℝ (Cl0 7) = 128 := by
  have := cl0_seven_equiv.toLinearEquiv.finrank_eq
  rw [finrank_M8R2] at this
  exact this

/-- PBW basis cardinality. -/
theorem cl07_PBW_cardinality : (2 : ℕ) ^ 7 = 128 := by norm_num

theorem cl07_bott_class : (7 : ℕ) % 8 = 7 := by norm_num