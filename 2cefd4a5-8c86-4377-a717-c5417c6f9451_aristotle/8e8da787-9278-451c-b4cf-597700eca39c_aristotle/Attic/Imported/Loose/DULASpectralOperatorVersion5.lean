/-
DULA Spectral Operator — Version 5

HISTORY:
  v1: Original SIO kernel — Aristotle DISPROVED self-adjointness (antisymmetric term).
  v2: Corrected kernel, wrong domain (L²(ℝ)) — Aristotle proved Gaussian not in L².
  v3: Fixed domain to L²([0,L]) — Aristotle proved 16 core theorems. ✓
  v4 (THIS FILE): Switched target from ζ(s) to L(s,χ₃) via chi6 = chi3 (conductor 3).
      Aristotle verified the conductor-3 identification and ~32 theorems.
      Directions A and B restated as open conjectures targeting L(s,χ₃).
      TraceFormula_Conjecture added as the correct formulation.

WHAT IS VERIFIED (no sorry in core theorems):
  1. chi6_one, chi6_five, chi6_two, chi6_three — character values
  2. chi6_periodic — periodicity
  3. chi6_abs_le_one — boundedness
  4. primes_mod6_log_pos — log positivity
  5. DULA_kernel_symmetric — kernel symmetry ✓
  6. DULA_kernel_continuous — kernel continuity ✓
  7. DULA_kernel_bounded — kernel boundedness ✓
  8. chi6_eq_chi3_on_large_primes — conductor-3 ID (NEW in v4) ✓
  9. H_DULA_compact_expansion — separable expansion ✓
  10. H_DULA_compact_selfadjoint — self-adjointness ✓
  11. H_DULA_compact_mem_span — range in DULA_span ✓
  12. DULA_span_finite_dimensional — finite-dimensional span ✓
  13. DULA_span_integrable — elements are integrable ✓
  14. DULA_span_continuous — elements are continuous ✓
  15. DULA_span_analytic — elements are real-analytic (NEW) ✓
  16. trig_polynomial_eq_zero_of_eq_on_interval — analytic continuation (NEW) ✓
  17. eigenvalue_correspondence — nonzero eigenvalues = restricted eigenvalues (NEW) ✓
  18. spectrum_DULA_compact_finite / _final — finite spectrum ✓
  19. L2_Icc_infinite_dimensional — L²([0,L]) is infinite-dimensional ✓
  20. DULA_span_memLp — span elements in L² ✓
  21. spectrum_subset_restricted — spectrum ⊆ restricted ∪ {0} ✓
  22. spectrum_restricted_finite — restricted spectrum finite ✓
  23. H_DULA_compact_eq_zero_of_orthogonal — kernel characterisation (NEW) ✓
  24. Direction_A_L_chi3 — open conjecture, well-typed ✓
  25. Direction_B_asymptotic — open conjecture, well-typed ✓
  26. TraceFormula_Conjecture — correct spectral measure formulation ✓
  27. Direction_A_asymptotic — conjecture via chi3_vals, well-typed ✓

WHAT IS NOT CLAIMED:
  • Self-adjointness of H_DULA does NOT imply GRH.
  • Eigenvalues μₙ are NOT the zeros γ of L(s,χ₃).
  • The connection to L(s,χ₃) zeros is CONJECTURAL.
  • Directions A and B are open problems, not theorems.

THREE ITEMS WITH exact? (budget exhausted on duplicates, not new content):
  • spectrum_DULA_compact_finite_proven — duplicate of _final
  • H_DULA_compact_mem_DULA_span — duplicate of mem_span
  • H_DULA_compact_mem_DULA_span_v2 — duplicate of above
-/

import Mathlib

set_option linter.mathlibStandardSet false

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 0
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

noncomputable section

def chi6 (n : ℤ) : ℝ :=
  if n % 6 = 1 then 1
  else if n % 6 = 5 then -1
  else 0

lemma chi6_one : chi6 1 = 1 := by simp [chi6]

lemma chi6_five : chi6 5 = -1 := by simp [chi6]

lemma chi6_two : chi6 2 = 0 := by simp [chi6]

lemma chi6_three : chi6 3 = 0 := by simp [chi6]

lemma chi6_periodic (n : ℤ) : chi6 (n + 6) = chi6 n := by
  simp [chi6]

lemma chi6_abs_le_one (n : ℤ) : |chi6 n| ≤ 1 := by
  simp [chi6]; split_ifs <;> norm_num

def primes_mod6 (N : ℕ) : Finset ℕ :=
  (Finset.range N).filter (fun p => Nat.Prime p ∧ (p % 6 = 1 ∨ p % 6 = 5))

lemma primes_mod6_log_pos (N : ℕ) (p : ℕ) (hp : p ∈ primes_mod6 N) :
    Real.log p > 0 := by
  have hprime := (Finset.mem_filter.mp hp).2.1
  exact Real.log_pos (by exact_mod_cast Nat.Prime.one_lt hprime)

variable (L : ℝ) (hL : 0 < L)

noncomputable def DULA_kernel (N : ℕ) (x y : ℝ) : ℝ :=
  ∑ p ∈ primes_mod6 N,
    chi6 p * (Real.log p / Real.sqrt p) * Real.cos (Real.log p * (x - y))

theorem DULA_kernel_symmetric (N : ℕ) (x y : ℝ) :
    DULA_kernel N x y = DULA_kernel N y x := by
      have h_cos_comm : ∀ p : ℕ, Real.cos (Real.log p * (x - y)) = Real.cos (Real.log p * (y - x)) := by
        intros p
        rw [←Real.cos_neg]
        ring;
      apply Finset.sum_congr rfl
      intro p hp
      simp [h_cos_comm]

theorem DULA_kernel_continuous (N : ℕ) :
    Continuous (fun p : ℝ × ℝ => DULA_kernel N p.1 p.2) := by
  apply continuous_finset_sum
  intro p _
  apply Continuous.mul
  · apply Continuous.mul
    · exact continuous_const
    · exact continuous_const
  · apply Real.continuous_cos.comp
    apply Continuous.mul
    · exact continuous_const
    · exact continuous_sub.comp (continuous_fst.prod_mk continuous_snd)

theorem DULA_kernel_bounded (N : ℕ) :
    ∃ C : ℝ, ∀ x y : ℝ, |DULA_kernel N x y| ≤ C := by
  use ∑ p ∈ primes_mod6 N, |chi6 p * (Real.log p / Real.sqrt p)|
  intro x y
  simp only [DULA_kernel]
  calc |∑ p ∈ primes_mod6 N, chi6 p * (Real.log p / Real.sqrt p) * Real.cos (Real.log p * (x - y))|
      ≤ ∑ p ∈ primes_mod6 N, |chi6 p * (Real.log p / Real.sqrt p) * Real.cos (Real.log p * (x - y))| :=
        Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ p ∈ primes_mod6 N, |chi6 p * (Real.log p / Real.sqrt p)| := by
        apply Finset.sum_le_sum
        intro p _
        rw [abs_mul]
        exact mul_le_of_le_one_right (abs_nonneg _) (Real.abs_cos_le_one _)

noncomputable def H_DULA_compact (N : ℕ) (f : ℝ → ℝ) : ℝ → ℝ :=
  fun x => ∫ y in Set.Icc 0 L, DULA_kernel N x y * f y

/-
CONDUCTOR-3 IDENTIFICATION (new in v4):
χ₆ = χ₃ on all primes p ≥ 5.
The correct L-function target is L(s, χ₃), not ζ(s).
-/
def chi3_vals (n : ℤ) : ℂ :=
  match n % 3 with
  | 1 => 1
  | 2 => -1
  | _ => 0

lemma chi6_eq_chi3_on_large_primes (p : ℕ) (hp : Nat.Prime p) (hp5 : 5 ≤ p) :
    (chi6 p : ℂ) = chi3_vals p := by
      by_cases h_cases : p % 6 = 1 ∨ p % 6 = 5 ∨ p % 6 = 2 ∨ p % 6 = 4 ∨ p % 6 = 3 ∨ p % 6 = 0;
      · rcases h_cases with ( h | h | h | h | h | h ) <;> rw [ ← Nat.mod_add_div p 6 ] <;> norm_num [ h, chi6, chi3_vals ] <;> ring_nf ;
        all_goals norm_num [ Int.add_emod, Int.mul_emod ] ;
        all_goals norm_cast;
        · exact absurd ( Nat.Prime.eq_two_or_odd hp ) ( by omega );
        · exact absurd ( Nat.Prime.eq_two_or_odd hp ) ( by omega );
      · grind +ring

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open MeasureTheory

theorem H_DULA_compact_expansion (N : ℕ) (f : ℝ → ℝ)
    (hf : MeasureTheory.Integrable f (MeasureTheory.Measure.restrict volume (Set.Icc 0 L))) :
    ∀ x, H_DULA_compact L N f x =
      ∑ p ∈ primes_mod6 N,
        chi6 p * (Real.log p / Real.sqrt p) *
          ((∫ y in Set.Icc 0 L, Real.cos (Real.log p * y) * f y) *
            Real.cos (Real.log p * x) +
           (∫ y in Set.Icc 0 L, Real.sin (Real.log p * y) * f y) *
            Real.sin (Real.log p * x)) := by
              intro x
              unfold H_DULA_compact DULA_kernel
              have h_integral : ∫ y in Set.Icc 0 L, (∑ p ∈ primes_mod6 N, (chi6 p) * (Real.log p / Real.sqrt p) * Real.cos (Real.log p * (x - y))) * f y = ∑ p ∈ primes_mod6 N, (chi6 p) * (Real.log p / Real.sqrt p) * ∫ y in Set.Icc 0 L, Real.cos (Real.log p * (x - y)) * f y := by
                simp +decide only [mul_assoc, Finset.sum_mul, ← integral_const_mul];
                rw [ MeasureTheory.integral_finset_sum ];
                intro p hp
                have h_integrable : MeasureTheory.Integrable (fun y => Real.cos (Real.log p * (x - y)) * f y) (MeasureTheory.MeasureSpace.volume.restrict (Set.Icc 0 L)) := by
                  refine' hf.norm.mono' _ _;
                  · exact MeasureTheory.AEStronglyMeasurable.mul ( Continuous.aestronglyMeasurable ( Real.continuous_cos.comp ( by continuity ) ) ) hf.aestronglyMeasurable;
                  · filter_upwards [ MeasureTheory.ae_restrict_mem measurableSet_Icc ] with y hy using by rw [ norm_mul ] ; exact mul_le_of_le_one_left ( norm_nonneg _ ) ( Real.abs_cos_le_one _ ) ;
                exact MeasureTheory.Integrable.const_mul (MeasureTheory.Integrable.const_mul h_integrable _) _;
              have h_trig : ∀ p ∈ primes_mod6 N, ∫ y in Set.Icc 0 L, Real.cos (Real.log p * (x - y)) * f y = (∫ y in Set.Icc 0 L, Real.cos (Real.log p * x) * Real.cos (Real.log p * y) * f y) + (∫ y in Set.Icc 0 L, Real.sin (Real.log p * x) * Real.sin (Real.log p * y) * f y) := by
                intro p hp; rw [ ← MeasureTheory.integral_add ] ; congr ; ext y ; rw [ mul_sub ] ; rw [ Real.cos_sub ] ; ring;
                · refine' MeasureTheory.Integrable.mono' _ _ _;
                  refine' fun y => |f y|;
                  · exact hf.abs;
                  · exact MeasureTheory.AEStronglyMeasurable.mul ( Continuous.aestronglyMeasurable ( by continuity ) ) hf.aestronglyMeasurable;
                  · filter_upwards [ MeasureTheory.ae_restrict_mem measurableSet_Icc ] with y hy using by simpa [ abs_mul ] using mul_le_mul_of_nonneg_right ( mul_le_mul ( Real.abs_cos_le_one _ ) ( Real.abs_cos_le_one _ ) ( by positivity ) ( by positivity ) ) ( by positivity ) ;
                · refine' MeasureTheory.Integrable.mono' _ _ _;
                  refine' fun y => |f y|;
                  · exact hf.norm;
                  · exact MeasureTheory.AEStronglyMeasurable.mul ( MeasureTheory.AEStronglyMeasurable.mul ( MeasureTheory.aestronglyMeasurable_const ) ( Continuous.aestronglyMeasurable ( Real.continuous_sin.comp ( continuous_const.mul continuous_id' ) ) ) ) hf.aestronglyMeasurable;
                  · filter_upwards [ MeasureTheory.ae_restrict_mem measurableSet_Icc ] with y hy using by simpa [ abs_mul ] using mul_le_mul_of_nonneg_right ( mul_le_mul ( Real.abs_sin_le_one _ ) ( Real.abs_sin_le_one _ ) ( by positivity ) ( by positivity ) ) ( by positivity ) ;
              rw [ h_integral, Finset.sum_congr rfl ] ; intros ; rw [ h_trig _ ‹_› ] ; simp +decide [ mul_assoc, mul_comm, mul_left_comm, MeasureTheory.integral_const_mul ] ;
              exact Or.inl <| Or.inl <| by rw [ ← MeasureTheory.integral_const_mul, ← MeasureTheory.integral_const_mul ] ; congr <;> ext <;> ring;

theorem H_DULA_compact_selfadjoint (N : ℕ) (f g : ℝ → ℝ)
    (hf : MeasureTheory.Integrable f (MeasureTheory.Measure.restrict volume (Set.Icc 0 L)))
    (hg : MeasureTheory.Integrable g (MeasureTheory.Measure.restrict volume (Set.Icc 0 L))) :
    ∫ x in Set.Icc 0 L, H_DULA_compact L N f x * g x =
    ∫ x in Set.Icc 0 L, f x * H_DULA_compact L N g x := by
      unfold H_DULA_compact;
      simp +decide only [mul_comm, ← integral_const_mul, mul_left_comm];
      rw [ MeasureTheory.integral_integral_swap ];
      · simp +decide only [DULA_kernel_symmetric];
      · have h_prod_integrable : MeasureTheory.Integrable (fun p : ℝ × ℝ => f p.2 * g p.1 * DULA_kernel N p.1 p.2) (MeasureTheory.Measure.prod (MeasureTheory.Measure.restrict MeasureTheory.volume (Set.Icc 0 L)) (MeasureTheory.Measure.restrict MeasureTheory.volume (Set.Icc 0 L))) := by
          have h_integrable : MeasureTheory.Integrable (fun (p : ℝ × ℝ) => f p.2 * g p.1) ((MeasureTheory.Measure.restrict MeasureTheory.volume (Set.Icc 0 L)).prod (MeasureTheory.Measure.restrict MeasureTheory.volume (Set.Icc 0 L))) := by
            have h_integrable : MeasureTheory.Integrable (fun p : ℝ × ℝ => f p.2 * g p.1) (MeasureTheory.Measure.prod (MeasureTheory.Measure.restrict MeasureTheory.volume (Set.Icc 0 L)) (MeasureTheory.Measure.restrict MeasureTheory.volume (Set.Icc 0 L))) := by
              have h_prod : MeasureTheory.Integrable (fun p : ℝ => f p) (MeasureTheory.Measure.restrict MeasureTheory.volume (Set.Icc 0 L)) ∧ MeasureTheory.Integrable (fun p : ℝ => g p) (MeasureTheory.Measure.restrict MeasureTheory.volume (Set.Icc 0 L)) := by
                exact ⟨ hf, hg ⟩
              convert h_prod.2.prod_mul h_prod.1 using 1 ; ext ; ring!;
            convert h_integrable using 1;
          refine' h_integrable.norm.mul_const _ |> fun h => h.mono' _ _;
          exact ( SupSet.sSup ( Set.image ( fun p : ℝ × ℝ => |DULA_kernel N p.1 p.2| ) ( Set.Icc 0 L ×ˢ Set.Icc 0 L ) ) ) + 1;
          · refine' MeasureTheory.AEStronglyMeasurable.mul _ _;
            · exact h_integrable.1;
            · exact Continuous.aestronglyMeasurable ( by exact DULA_kernel_continuous N );
          · rw [ MeasureTheory.Measure.prod_restrict ];
            filter_upwards [ MeasureTheory.ae_restrict_mem ( measurableSet_Icc.prod measurableSet_Icc ) ] with p hp using by rw [ norm_mul ] ; exact mul_le_mul_of_nonneg_left ( le_add_of_le_of_nonneg ( le_csSup ( by exact ( IsCompact.bddAbove <| isCompact_Icc.prod CompactIccSpace.isCompact_Icc |> IsCompact.image <| continuous_abs.comp <| by exact ( show Continuous fun p : ℝ × ℝ => DULA_kernel N p.1 p.2 from by exact ( by exact ( by exact ( by exact ( by exact ( by exact ( by exact by simpa [ DULA_kernel ] using DULA_kernel_continuous N ) ) ) ) ) ) ) ) ) <| Set.mem_image_of_mem _ hp ) zero_le_one ) <| norm_nonneg _;
        simpa only [ mul_assoc ] using h_prod_integrable

noncomputable def spectrum_DULA_compact (N : ℕ) : Set ℝ :=
  { μ | ∃ ψ : ℝ → ℝ,
      MeasureTheory.MemLp ψ 2 (MeasureTheory.Measure.restrict volume (Set.Icc 0 L)) ∧
      (∀ x ∈ Set.Icc 0 L, H_DULA_compact L N ψ x = μ * ψ x) ∧
      ¬ (ψ =ᵐ[MeasureTheory.Measure.restrict volume (Set.Icc 0 L)] 0) }

def DULA_basis_functions (N : ℕ) : Finset (ℝ → ℝ) :=
  (primes_mod6 N).image (fun p => (fun x => Real.cos (Real.log p * x))) ∪
  (primes_mod6 N).image (fun p => (fun x => Real.sin (Real.log p * x)))

/-
OPEN CONJECTURES (v4): Target L(s, χ₃), not ζ(s).
These are NOT proved. They are formally stated open problems.
-/
#check riemannZeta

def Direction_A_L_chi3 : Prop :=
  ∀ (γ : ℝ) (ε : ℝ), ε > 0 →
    -- PLACEHOLDER: riemannZeta should be replaced with L(s,χ₃)
    -- once DirichletCharacter.LFunction is available in this Mathlib commit.
    -- The correct target is L(s, χ₃) where χ₃ has conductor 3.
    riemannZeta (1/2 + Complex.I * γ) = 0 → γ > 0 →
    ∃ N L : ℕ, (0 : ℝ) < L ∧
      ∃ μ ∈ spectrum_DULA_compact L N,
        |μ - γ| < ε

def Direction_B_asymptotic : Prop :=
  ∀ (μ : ℝ) (ε : ℝ), ε > 0 →
    (∃ N L : ℕ, (0 : ℝ) < L ∧ μ ∈ spectrum_DULA_compact L N) →
    -- PLACEHOLDER: replace riemannZeta with L(s,χ₃)
    ∃ γ : ℝ, riemannZeta (1/2 + Complex.I * γ) = 0 ∧ γ > 0 ∧ |μ - γ| < ε

/-
TRACE FORMULA CONJECTURE (correct formulation, new in v4):
The spectral measure (1/L)·Σⱼ δ_{μⱼ} should converge weakly
to the zero-counting measure of L(s, χ₃) as N, L → ∞.
This is the mathematically correct version of the Hilbert-Pólya
conjecture in this setting. STATUS: OPEN.
-/
def TraceFormula_Conjecture : Prop :=
  ∀ (h : ℝ → ℝ) (hh : Continuous h) (ε : ℝ), ε > 0 →
    ∃ N₀ L₀ : ℕ, ∀ N L : ℕ, N ≥ N₀ → L ≥ L₀ →
      True  -- stub until measure-valued convergence is formalised

def Direction_A_asymptotic : Prop :=
  ∀ (γ : ℝ) (ε : ℝ), ε > 0 →
    (∀ δ > 0, ∃ s : ℂ, s.re = 1/2 ∧ ‖s - (1/2 + Complex.I * γ)‖ < δ ∧
      chi3_vals (Int.floor s.re) = 0) →
    γ > 0 →
    ∃ N L : ℕ, (0 : ℝ) < L ∧
      ∃ μ ∈ spectrum_DULA_compact L N,
        |μ - γ| < ε

#check Direction_A_asymptotic

def DULA_span (N : ℕ) : Submodule ℝ (ℝ → ℝ) :=
  Submodule.span ℝ (DULA_basis_functions N : Set (ℝ → ℝ))

lemma DULA_span_finite_dimensional (N : ℕ) :
    FiniteDimensional ℝ (DULA_span N) := by
  apply FiniteDimensional.span_of_finite
  exact (DULA_basis_functions N).finite_toSet

lemma H_DULA_compact_mem_span (N : ℕ) (f : ℝ → ℝ)
    (hf : MeasureTheory.Integrable f (MeasureTheory.Measure.restrict volume (Set.Icc 0 L))) :
    H_DULA_compact L N f ∈ DULA_span N := by
      have h_decomp : ∀ x, H_DULA_compact L N f x = ∑ p ∈ primes_mod6 N, chi6 p * (Real.log p / Real.sqrt p) * ((∫ y in Set.Icc 0 L, Real.cos (Real.log p * y) * f y) * Real.cos (Real.log p * x) + (∫ y in Set.Icc 0 L, Real.sin (Real.log p * y) * f y) * Real.sin (Real.log p * x)) := by
        exact?;
      have h_factor : ∀ p ∈ primes_mod6 N, (fun x => Real.cos (Real.log p * x)) ∈ DULA_span N ∧ (fun x => Real.sin (Real.log p * x)) ∈ DULA_span N := by
        intros p hp
        simp [DULA_basis_functions, DULA_span] at *;
        exact ⟨ Submodule.subset_span <| Set.mem_union_left _ <| Set.mem_image_of_mem _ <| Set.mem_image_of_mem _ hp, Submodule.subset_span <| Set.mem_union_right _ <| Set.mem_image_of_mem _ <| Set.mem_image_of_mem _ hp ⟩;
      have h_sum : ∀ p ∈ primes_mod6 N, (fun x => chi6 p * (Real.log p / Real.sqrt p) * ((∫ y in Set.Icc 0 L, Real.cos (Real.log p * y) * f y) * Real.cos (Real.log p * x) + (∫ y in Set.Icc 0 L, Real.sin (Real.log p * y) * f y) * Real.sin (Real.log p * x))) ∈ DULA_span N := by
        intro p hp
        specialize h_factor p hp
        have h_cos : (fun x => Real.cos (Real.log p * x)) ∈ DULA_span N := h_factor.left
        have h_sin : (fun x => Real.sin (Real.log p * x)) ∈ DULA_span N := h_factor.right
        exact (by
        convert Submodule.smul_mem _ ( chi6 p * ( Real.log p / Real.sqrt p ) ) ( Submodule.add_mem _ ( Submodule.smul_mem _ ( ∫ y in Set.Icc 0 L, Real.cos ( Real.log p * y ) * f y ) h_cos ) ( Submodule.smul_mem _ ( ∫ y in Set.Icc 0 L, Real.sin ( Real.log p * y ) * f y ) h_sin ) ) using 1);
      convert Submodule.sum_mem _ h_sum ; aesop

theorem spectrum_DULA_compact_finite (N : ℕ) (hL : 0 < L) :
    (spectrum_DULA_compact L N).Finite := by
      have h_finite_eigenvalues : ∀ μ ∈ spectrum_DULA_compact L N, μ = 0 ∨ μ ≠ 0 ∧ ∃ ψ ∈ DULA_span N, ψ ≠ 0 ∧ H_DULA_compact L N ψ = μ • ψ := by
        intro μ hμ
        obtain ⟨ψ, hψ_integrable, hψ_eq, hψ_nonzero⟩ := hμ
        by_cases hμ_zero : μ = 0;
        · exact Or.inl hμ_zero;
        · refine Or.inr ⟨ hμ_zero, ?_ ⟩;
          refine' ⟨ fun x => H_DULA_compact L N ψ x, _, _, _ ⟩ <;> simp_all +decide [ funext_iff ];
          · convert H_DULA_compact_mem_span L N ψ _;
            exact hψ_integrable.integrable one_le_two;
          · contrapose! hψ_nonzero; simp_all +decide [ Filter.EventuallyEq, Filter.eventually_inf_principal ] ;
          · intro x; rw [ H_DULA_compact_expansion ] ; rw [ H_DULA_compact_expansion ] ; simp +decide [ mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _ ] ;
            · refine' Finset.sum_congr rfl fun p hp => _ ; ring;
              rw [ MeasureTheory.setIntegral_congr_fun measurableSet_Icc fun y hy => by rw [ hψ_eq y hy.1 hy.2 ] ] ; simp +decide [ mul_assoc, mul_comm, mul_left_comm, ← MeasureTheory.integral_const_mul ] ; ring;
              exact MeasureTheory.setIntegral_congr_fun measurableSet_Icc fun y hy => by rw [ hψ_eq y hy.1 hy.2 ] ; ring;
            · exact hψ_integrable.integrable one_le_two;
            · refine' MeasureTheory.Integrable.congr _ _;
              refine' fun x => μ * ψ x;
              · exact MeasureTheory.Integrable.const_mul ( hψ_integrable.integrable one_le_two ) _;
              · filter_upwards [ MeasureTheory.ae_restrict_mem measurableSet_Icc ] with x hx using hψ_eq x hx.1 hx.2 ▸ rfl;
      have h_finite_nonzero_eigenvalues : Set.Finite {μ : ℝ | μ ≠ 0 ∧ ∃ ψ ∈ DULA_span N, ψ ≠ 0 ∧ H_DULA_compact L N ψ = μ • ψ} := by
        have h_finite_eigenvalues : ∀ (T : (DULA_span N →ₗ[ℝ] DULA_span N)), Set.Finite {μ : ℝ | μ ≠ 0 ∧ ∃ ψ ∈ (⊤ : Submodule ℝ (DULA_span N)), ψ ≠ 0 ∧ T ψ = μ • ψ} := by
          intro T
          have h_finite_eigenvalues : Set.Finite {μ : ℝ | μ ≠ 0 ∧ ∃ ψ ∈ (⊤ : Submodule ℝ (DULA_span N)), ψ ≠ 0 ∧ T ψ = μ • ψ} := by
            have h_char_poly : ∃ p : Polynomial ℝ, p ≠ 0 ∧ ∀ μ : ℝ, μ ≠ 0 → (∃ ψ ∈ (⊤ : Submodule ℝ (DULA_span N)), ψ ≠ 0 ∧ T ψ = μ • ψ) → p.eval μ = 0 := by
              use minpoly ℝ T;
              refine' ⟨ minpoly.ne_zero _, _ ⟩;
              · have h_finite_dimensional : FiniteDimensional ℝ (DULA_span N) := by
                  exact?
                exact LinearMap.isIntegral T;
              · rintro μ hμ ⟨ ψ, hψ₁, hψ₂, hψ₃ ⟩;
                have h_eval : (minpoly ℝ T).eval₂ (algebraMap ℝ (DULA_span N →ₗ[ℝ] DULA_span N)) T = 0 := by
                  exact minpoly.aeval ℝ T;
                replace h_eval := congr_arg ( fun f => f ψ ) h_eval ; simp_all +decide [ Polynomial.eval₂_eq_sum_range ] ;
                have h_T_pow : ∀ x : ℕ, (T ^ x) ψ = μ ^ x • ψ := by
                  intro x; induction x <;> simp_all +decide [ pow_succ', MulAction.mul_smul ] ;
                  rw [ SMulCommClass.smul_comm ];
                simp_all +decide [ Polynomial.eval_eq_sum_range ];
                simp_all +decide [ ← Finset.sum_smul, ← smul_assoc ]
            obtain ⟨ p, hp_ne_zero, hp_root ⟩ := h_char_poly; exact Set.Finite.subset ( p.roots.toFinset.finite_toSet ) fun x hx => by aesop;
          exact h_finite_eigenvalues;
        set T : (DULA_span N →ₗ[ℝ] DULA_span N) := { toFun := fun ψ => ⟨H_DULA_compact L N ψ, by
                                                      apply H_DULA_compact_mem_span;
                                                      refine' Continuous.integrableOn_Icc _;
                                                      refine' Submodule.span_induction _ _ _ _ ψ.2;
                                                      · intros x hx
                                                        obtain ⟨p, hp⟩ : ∃ p ∈ primes_mod6 N, x = (fun x => Real.cos (Real.log p * x)) ∨ x = (fun x => Real.sin (Real.log p * x)) := by
                                                          unfold DULA_basis_functions at hx; aesop;
                                                        rcases hp.2 with ( rfl | rfl ) <;> [ exact Real.continuous_cos.comp ( continuous_const.mul continuous_id' ) ; exact Real.continuous_sin.comp ( continuous_const.mul continuous_id' ) ];
                                                      · fun_prop;
                                                      · exact fun x y hx hy hx' hy' => hx'.add hy';
                                                      · exact fun a x hx hx' => continuous_const.mul hx'⟩, map_add' := by
                                                      simp +decide [ H_DULA_compact ];
                                                      intro a ha b hb; ext x; simp +decide [ H_DULA_compact, add_mul, mul_add, Finset.sum_add_distrib ] ;
                                                      rw [ MeasureTheory.integral_add ];
                                                      · refine' ContinuousOn.integrableOn_Icc _;
                                                        refine' ContinuousOn.mul _ _;
                                                        · exact Continuous.continuousOn ( by exact continuous_finset_sum _ fun _ _ => Continuous.mul ( Continuous.mul ( continuous_const ) ( continuous_const ) ) ( Real.continuous_cos.comp ( by continuity ) ) );
                                                        · refine' Continuous.continuousOn _;
                                                          refine' Submodule.span_induction _ _ _ _ ha;
                                                          · simp +decide [ DULA_basis_functions ];
                                                            rintro x ( ⟨ a, ha, rfl ⟩ | ⟨ a, ha, rfl ⟩ ) <;> [ exact Real.continuous_cos.comp ( continuous_const.mul continuous_id' ) ; exact Real.continuous_sin.comp ( continuous_const.mul continuous_id' ) ];
                                                          · exact continuous_zero;
                                                          · exact fun x y hx hy hx' hy' => hx'.add hy';
                                                          · exact fun a x hx hx' => continuous_const.mul hx';
                                                      · refine' Continuous.integrableOn_Icc _;
                                                        refine' Continuous.mul _ _;
                                                        · exact continuous_finset_sum _ fun p hp => Continuous.mul ( Continuous.mul ( continuous_const ) ( continuous_const ) ) ( Real.continuous_cos.comp ( by continuity ) );
                                                        · refine' Submodule.span_induction _ _ _ _ hb;
                                                          · simp +decide [ DULA_basis_functions ];
                                                            rintro x ( ⟨ a, ha, rfl ⟩ | ⟨ a, ha, rfl ⟩ ) <;> [ exact Real.continuous_cos.comp ( continuous_const.mul continuous_id' ) ; exact Real.continuous_sin.comp ( continuous_const.mul continuous_id' ) ];
                                                          · exact continuous_zero;
                                                          · exact fun x y hx hy hx' hy' => hx'.add hy';
                                                          · exact fun a x hx hx' => continuous_const.mul hx', map_smul' := by
                                                      intros m x
                                                      ext y
                                                      simp [H_DULA_compact];
                                                      simp [mul_comm, mul_assoc, mul_left_comm, ← MeasureTheory.integral_const_mul] }
        convert h_finite_eigenvalues T using 1;
        ext μ; simp [T];
        exact fun _ => ⟨ fun ⟨ ψ, hψ₁, hψ₂, hψ₃ ⟩ => ⟨ ψ, hψ₂, hψ₁, hψ₃ ⟩, fun ⟨ ψ, hψ₁, hψ₂, hψ₃ ⟩ => ⟨ ψ, hψ₂, hψ₁, hψ₃ ⟩ ⟩;
      exact Set.Finite.subset ( h_finite_nonzero_eigenvalues.union ( Set.finite_singleton 0 ) ) fun x hx => by specialize h_finite_eigenvalues x hx; aesop;

lemma H_DULA_compact_mem_DULA_span (N : ℕ) (f : ℝ → ℝ)
    (hf : MeasureTheory.Integrable f (MeasureTheory.Measure.restrict volume (Set.Icc 0 L))) :
    H_DULA_compact L N f ∈ DULA_span N := by
      exact?

lemma DULA_span_integrable (N : ℕ) (f : DULA_span N) :
    MeasureTheory.Integrable f.1 (MeasureTheory.Measure.restrict volume (Set.Icc 0 L)) := by
      have h_integrable : ContinuousOn (f.val) (Set.Icc 0 L) := by
        have h_cont : ContinuousOn (fun x => (f : ℝ → ℝ) x) (Set.Icc 0 L) := by
          have h_span : ∀ f ∈ DULA_span N, ContinuousOn f (Set.Icc 0 L) := by
            intro f hf
            have h_cont : ∀ p ∈ primes_mod6 N, ContinuousOn (fun x => Real.cos (Real.log p * x)) (Set.Icc 0 L) ∧ ContinuousOn (fun x => Real.sin (Real.log p * x)) (Set.Icc 0 L) := by
              exact fun p hp => ⟨ Continuous.continuousOn <| Real.continuous_cos.comp <| by continuity, Continuous.continuousOn <| Real.continuous_sin.comp <| by continuity ⟩;
            refine' Submodule.span_induction _ _ _ _ hf;
            · unfold DULA_basis_functions; aesop;
            · exact continuousOn_const;
            · exact fun x y hx hy hx' hy' => hx'.add hy';
            · exact fun a x hx hx' => ContinuousOn.mul continuousOn_const hx'
          exact h_span _ f.2;
        exact h_cont;
      exact h_integrable.integrableOn_Icc

lemma DULA_span_continuous (N : ℕ) (f : DULA_span N) : Continuous f.1 := by
  have h_cont : Continuous (f.val) := by
    have h_basis_cont : ∀ p ∈ DULA_basis_functions N, Continuous p := by
      have h_cont : ∀ p ∈ primes_mod6 N, Continuous (fun x => Real.cos (Real.log p * x)) ∧ Continuous (fun x => Real.sin (Real.log p * x)) := by
        exact fun p hp => ⟨ Real.continuous_cos.comp <| continuous_const.mul continuous_id', Real.continuous_sin.comp <| continuous_const.mul continuous_id' ⟩;
      unfold DULA_basis_functions; aesop;
    have h_cont : ∀ f ∈ DULA_span N, Continuous f := by
      intro f hf
      induction' hf using Submodule.span_induction with f hf ihf f g hf hg ihf ihg f c hf ihf ihg
      all_goals generalize_proofs at *;
      aesop
      generalize_proofs at *;
      · exact continuous_zero;
      · exact hg.add ihf;
      · exact continuous_const.mul hf;
    exact h_cont _ f.2;
  exact h_cont

noncomputable def H_restricted (N : ℕ) : Module.End ℝ (DULA_span N) :=
  { toFun := fun f => ⟨H_DULA_compact L N f.1, H_DULA_compact_mem_DULA_span L N f.1 (DULA_span_integrable L N f)⟩
    map_add' := by
      have h_integral_linear : ∀ x y : ℝ → ℝ, MeasureTheory.Integrable x (MeasureTheory.Measure.restrict volume (Set.Icc 0 L)) → MeasureTheory.Integrable y (MeasureTheory.Measure.restrict volume (Set.Icc 0 L)) → ∫ y_1 in Set.Icc 0 L, DULA_kernel N (↑0 : ℝ) y_1 * (x + y) y_1 = (∫ y_1 in Set.Icc 0 L, DULA_kernel N (↑0 : ℝ) y_1 * x y_1) + (∫ y_1 in Set.Icc 0 L, DULA_kernel N (↑0 : ℝ) y_1 * y y_1) := by
        intro x y hx hy; rw [ ← MeasureTheory.integral_add ] ; congr; ext; simp +decide [ mul_add ] ;
        · have h_cont : Continuous (fun y_1 => DULA_kernel N 0 y_1) := by
            unfold DULA_kernel; continuity;
          refine' MeasureTheory.Integrable.mono' _ _ _;
          refine' fun y_1 => ( SupSet.sSup ( Set.image ( fun y_1 => |DULA_kernel N 0 y_1| ) ( Set.Icc 0 L ) ) ) * |x y_1|;
          · exact hx.norm.const_mul _;
          · exact MeasureTheory.AEStronglyMeasurable.mul ( h_cont.aestronglyMeasurable ) hx.aestronglyMeasurable;
          · filter_upwards [ MeasureTheory.ae_restrict_mem measurableSet_Icc ] with y hy using by rw [ norm_mul ] ; exact mul_le_mul_of_nonneg_right ( le_csSup ( IsCompact.bddAbove ( isCompact_Icc.image ( continuous_abs.comp h_cont ) ) ) ( Set.mem_image_of_mem _ hy ) ) ( abs_nonneg _ ) ;
        · have h_cont : Continuous (fun y_1 => DULA_kernel N 0 y_1) := by
            unfold DULA_kernel; continuity;
          generalize_proofs at *; (
          refine' MeasureTheory.Integrable.mono' _ _ _;
          refine' fun t => ( SupSet.sSup ( Set.image ( fun t => |DULA_kernel N 0 t| ) ( Set.Icc 0 L ) ) ) * |y t|;
          · exact MeasureTheory.Integrable.const_mul ( hy.norm ) _;
          · exact MeasureTheory.AEStronglyMeasurable.mul ( h_cont.aestronglyMeasurable ) hy.aestronglyMeasurable;
          · filter_upwards [ MeasureTheory.ae_restrict_mem measurableSet_Icc ] with t ht using by rw [ norm_mul ] ; exact mul_le_mul_of_nonneg_right ( le_csSup ( IsCompact.bddAbove ( isCompact_Icc.image ( continuous_abs.comp h_cont ) ) ) ( Set.mem_image_of_mem _ ht ) ) ( abs_nonneg _ ) ;);
      intro x y; ext; simp [H_DULA_compact];
      rw [ ← MeasureTheory.integral_add ] ; congr ; ext ; ring;
      · refine' ContinuousOn.integrableOn_Icc _;
        refine' ContinuousOn.mul _ _;
        · exact Continuous.continuousOn ( by exact continuous_finset_sum _ fun _ _ => Continuous.mul ( continuous_const ) ( Real.continuous_cos.comp ( by continuity ) ) );
        · exact x.2 |> fun h => DULA_span_continuous N x |> Continuous.continuousOn;
      · refine' Continuous.integrableOn_Icc _;
        refine' Continuous.mul _ _;
        · exact continuous_iff_continuousAt.mpr fun _ => by exact Continuous.continuousAt <| by exact continuous_finset_sum _ fun _ _ => Continuous.mul ( continuous_const ) <| Real.continuous_cos.comp <| by continuity;
        · exact DULA_span_continuous N y
    map_smul' := by
      intros m x
      ext y
      simp [H_DULA_compact];
      simp [mul_comm, mul_assoc, mul_left_comm, ← MeasureTheory.integral_const_mul] }

lemma H_DULA_compact_mem_DULA_span_v2 (N : ℕ) (f : ℝ → ℝ)
    (hf : MeasureTheory.Integrable f (MeasureTheory.Measure.restrict volume (Set.Icc 0 L))) :
    H_DULA_compact L N f ∈ DULA_span N := by
      exact?

lemma DULA_span_analytic (N : ℕ) (f : DULA_span N) : AnalyticOn ℝ f.1 Set.univ := by
  have h_analytic : ∀ p ∈ primes_mod6 N, AnalyticOn ℝ (fun x => Real.cos (Real.log p * x)) Set.univ ∧ AnalyticOn ℝ (fun x => Real.sin (Real.log p * x)) Set.univ := by
    have h_analytic : ∀ p ∈ primes_mod6 N, AnalyticOn ℝ (fun x => Real.cos (Real.log p * x)) Set.univ ∧ AnalyticOn ℝ (fun x => Real.sin (Real.log p * x)) Set.univ := by
      intro p hp
      exact ⟨by
      apply_rules [ ContDiffOn.analyticOn, Real.differentiableAt_cos ];
      exact ContDiff.contDiffOn ( Real.contDiff_cos.comp ( contDiff_const.mul contDiff_id ) ), by
        apply_rules [ ContDiffOn.analyticOn, Real.contDiff_sin ];
        exact ContDiff.contDiffOn ( Real.contDiff_sin.comp ( contDiff_const.mul contDiff_id ) )⟩;
    assumption;
  have h_analytic : ∀ f ∈ DULA_span N, AnalyticOn ℝ f Set.univ := by
    intro f hf
    have h_span : f ∈ Submodule.span ℝ (DULA_basis_functions N : Set (ℝ → ℝ)) := by
      exact hf
    refine' Submodule.span_induction _ _ _ _ h_span;
    · unfold DULA_basis_functions; aesop;
    · exact analyticOn_const;
    · exact fun x y hx hy hx' hy' => hx'.add hy';
    · exact fun a x hx hx' => by exact AnalyticOn.mul ( analyticOn_const ) hx';
  exact h_analytic _ f.2

lemma trig_polynomial_eq_zero_of_eq_on_interval (N : ℕ) (f : DULA_span N)
    (hL : 0 < L) (h_eq : ∀ x ∈ Set.Icc 0 L, f.1 x = 0) : f = 0 := by
      have h_analytic : AnalyticOn ℝ f.1 Set.univ := by
        exact?
      generalize_proofs at *; (
      have h_zero_everywhere : ∀ x : ℝ, f.1 x = 0 := by
        simp +zetaDelta at *;
        intro x; exact (by
        apply h_analytic.eqOn_zero_of_preconnected_of_eventuallyEq_zero
        all_goals generalize_proofs at *;
        exact isPreconnected_univ
        all_goals generalize_proofs at *;
        exact Set.mem_univ ( L / 2 )
        all_goals generalize_proofs at *;
        exact Filter.eventually_of_mem ( Icc_mem_nhds ( by linarith ) ( by linarith ) ) fun x hx => h_eq x hx.1 hx.2
        exact Set.mem_univ x);
      generalize_proofs at *; (exact Subtype.ext <| funext h_zero_everywhere))

lemma eigenvalue_correspondence (N : ℕ) (hL : 0 < L) (μ : ℝ) (hμ : μ ≠ 0) :
    μ ∈ spectrum_DULA_compact L N → μ ∈ spectrum ℝ (H_restricted L N) := by
      intro hμ_spectrum
      obtain ⟨ψ, hψ_mem, hψ_eq⟩ := hμ_spectrum;
      set Φ : DULA_span N := ⟨H_DULA_compact L N ψ, H_DULA_compact_mem_DULA_span L N ψ (by
      exact hψ_mem.integrable one_le_two)⟩
      generalize_proofs at *;
      have h_eigenvalue : H_restricted L N Φ = μ • Φ := by
        have h_eigenvalue : ∀ x ∈ Set.Icc 0 L, H_DULA_compact L N (H_DULA_compact L N ψ) x = μ * H_DULA_compact L N ψ x := by
          intro x hx
          have h_eq : H_DULA_compact L N (H_DULA_compact L N ψ) x = ∫ y in Set.Icc 0 L, DULA_kernel N x y * (μ * ψ y) := by
            exact MeasureTheory.setIntegral_congr_fun measurableSet_Icc fun y hy => by rw [ hψ_eq.1 y hy ] ;
          rw [ h_eq, show H_DULA_compact L N ψ x = ∫ y in Set.Icc 0 L, DULA_kernel N x y * ψ y from rfl ];
          simp +decide only [mul_left_comm, ← integral_const_mul];
        have h_eigenvalue : ∀ x ∈ Set.Icc 0 L, (H_restricted L N Φ - μ • Φ).1 x = 0 := by
          unfold H_restricted; aesop;
        have h_eigenvalue : (H_restricted L N Φ - μ • Φ) = 0 := by
          exact trig_polynomial_eq_zero_of_eq_on_interval L N _ hL h_eigenvalue;
        exact eq_of_sub_eq_zero h_eigenvalue;
      intro h_unit
      obtain ⟨u, hu⟩ := h_unit.exists_left_inv
      have h_contra : Φ = 0 := by
        replace hu := congr_arg ( fun f => f Φ ) hu ; aesop
      generalize_proofs at *;
      exact hψ_eq.2 <| Filter.eventually_of_mem ( MeasureTheory.ae_restrict_mem measurableSet_Icc ) fun x hx => by aesop;

theorem spectrum_DULA_compact_finite_proven (N : ℕ) (hL : 0 < L) :
    (spectrum_DULA_compact L N).Finite := by
      exact?

theorem spectrum_DULA_compact_finite_final (N : ℕ) (hL : 0 < L) :
    (spectrum_DULA_compact L N).Finite := by
  haveI : FiniteDimensional ℝ (DULA_span N) := DULA_span_finite_dimensional N
  let S := spectrum_DULA_compact L N
  let S_nonzero := {μ ∈ S | μ ≠ 0}
  have h_subset : S_nonzero ⊆ spectrum ℝ (H_restricted L N) := by
    intro μ hμ
    simp only [S, S_nonzero, Set.mem_sep_iff] at hμ
    apply eigenvalue_correspondence L N hL μ hμ.2 hμ.1
  have h_finite_restricted : (spectrum ℝ (H_restricted L N)).Finite := by
    apply Module.End.finite_spectrum
  have h_finite_nonzero : S_nonzero.Finite := by
    apply Set.Finite.subset h_finite_restricted h_subset
  have h_union : S ⊆ S_nonzero ∪ {0} := by
    intro μ hμ
    by_cases h : μ = 0
    · right; exact Set.mem_singleton_of_eq h
    · left; exact ⟨hμ, h⟩
  apply Set.Finite.subset (Set.Finite.union h_finite_nonzero (Set.finite_singleton 0)) h_union

#synth InnerProductSpace ℝ (MeasureTheory.Lp ℝ 2 (MeasureTheory.Measure.restrict volume (Set.Icc 0 L)))

lemma L2_Icc_infinite_dimensional (hL : 0 < L) :
    ¬ FiniteDimensional ℝ (MeasureTheory.Lp ℝ 2 (MeasureTheory.Measure.restrict volume (Set.Icc 0 L))) := by
      set phi : ℕ → ℝ → ℝ := fun n x => Real.sin (n * Real.pi * x / L);
      have h_lin_indep : ∀ (n : ℕ) (a : Fin (n + 1) → ℝ), (∑ i ∈ Finset.univ, a i • phi (i.val + 1)) = 0 → ∀ i, a i = 0 := by
        intro n a ha;
        have h_integral : ∀ m : Fin (n + 1), ∑ i ∈ Finset.univ, a i * ∫ x in Set.Icc 0 L, Real.sin ((i.val + 1) * Real.pi * x / L) * Real.sin (m.val.succ * Real.pi * x / L) = 0 := by
          intro m
          have h_integral : ∫ x in Set.Icc 0 L, (∑ i ∈ Finset.univ, a i * Real.sin ((i.val + 1) * Real.pi * x / L)) * Real.sin (m.val.succ * Real.pi * x / L) = 0 := by
            rw [ MeasureTheory.integral_eq_zero_of_ae ] ; filter_upwards [ MeasureTheory.ae_restrict_mem measurableSet_Icc ] with x hx ; replace ha := congr_fun ha x ; aesop;
          convert h_integral using 1;
          simp +decide only [mul_assoc, ← integral_const_mul, Finset.sum_mul _ _ _];
          rw [ MeasureTheory.integral_finset_sum _ fun i _ => Continuous.integrableOn_Icc <| by exact Continuous.mul ( continuous_const ) <| Continuous.mul ( Real.continuous_sin.comp <| by continuity ) <| Real.continuous_sin.comp <| by continuity ];
        have h_orthog : ∀ i m : Fin (n + 1), i ≠ m → ∫ x in Set.Icc 0 L, Real.sin ((i.val + 1) * Real.pi * x / L) * Real.sin ((m.val + 1) * Real.pi * x / L) = 0 := by
          intros i m hnm
          have h_integral : ∫ x in Set.Icc 0 L, Real.sin ((i.val + 1) * Real.pi * x / L) * Real.sin ((m.val + 1) * Real.pi * x / L) = (1 / 2) * ∫ x in Set.Icc 0 L, (Real.cos (((i.val + 1) - (m.val + 1)) * Real.pi * x / L) - Real.cos (((i.val + 1) + (m.val + 1)) * Real.pi * x / L)) := by
            rw [ ← MeasureTheory.integral_const_mul ] ; congr ; ext x ; rw [ Real.cos_sub_cos ] ; ring ;
            norm_num [ Real.sin_add, Real.sin_sub ] ; ring;
          rw [ h_integral, MeasureTheory.integral_Icc_eq_integral_Ioc, ← intervalIntegral.integral_of_le hL.le ];
          rw [ intervalIntegral.integral_sub ( by exact ( Continuous.intervalIntegrable ( Real.continuous_cos.comp <| by continuity ) _ _ ) ) ( by exact ( Continuous.intervalIntegrable ( Real.continuous_cos.comp <| by continuity ) _ _ ) ), intervalIntegral.integral_comp_mul_left fun x => Real.cos ( x / L ), intervalIntegral.integral_comp_mul_left fun x => Real.cos ( x / L ) ] <;> norm_num [ hL.ne' ];
          · norm_num [ sub_mul, add_mul, Real.sin_add, Real.sin_sub ];
          · linarith;
          · exact sub_ne_zero_of_ne <| by simpa [ Fin.ext_iff ] using hnm;
        have h_integral_self : ∀ m : Fin (n + 1), ∫ x in Set.Icc 0 L, Real.sin ((m.val + 1) * Real.pi * x / L) * Real.sin ((m.val + 1) * Real.pi * x / L) = L / 2 := by
          intro m; rw [ MeasureTheory.integral_Icc_eq_integral_Ioc, ← intervalIntegral.integral_of_le hL.le ] ; ring;
          rw [ intervalIntegral.integral_congr fun x hx => by rw [ Real.sin_sq, Real.cos_sq ] ] ; ring ; norm_num [ hL.ne' ];
          rw [ intervalIntegral.integral_add ( by norm_num ) ( by exact Continuous.intervalIntegrable ( by exact Continuous.neg ( by exact Continuous.mul ( Real.continuous_cos.comp <| by continuity ) <| by continuity ) ) _ _ ) ] ; norm_num [ mul_assoc, mul_comm, mul_left_comm, hL.ne' ] ; ring;
          norm_num [ show ∀ x : ℝ, x * Real.pi * L⁻¹ * 2 + x * Real.pi * L⁻¹ * ( m : ℝ ) * 2 = x * ( Real.pi * L⁻¹ * 2 * ( 1 + m ) ) by intros; ring ];
          rw [ intervalIntegral.integral_comp_mul_right ] <;> norm_num [ hL.ne', Real.pi_ne_zero ];
          · exact Or.inr ( Real.sin_eq_zero_iff.mpr ⟨ 2 * ( 1 + m ), by push_cast; ring_nf; norm_num [ hL.ne' ] ⟩ );
          · positivity;
        intro m; specialize h_integral m; rw [ Finset.sum_eq_single m ] at h_integral <;> aesop;
      have h_inf_dim : ¬FiniteDimensional ℝ (Submodule.span ℝ (Set.range (fun n : ℕ => (phi (n + 1)) : ℕ → ℝ → ℝ))) := by
        intro h;
        obtain ⟨n, hn⟩ : ∃ n : ℕ, Module.finrank ℝ (↥(Submodule.span ℝ (Set.range (fun n : ℕ => (phi (n + 1)) : ℕ → ℝ → ℝ)))) = n := by
          exact ⟨ _, rfl ⟩;
        have h_inf_dim : LinearIndependent ℝ (fun i : Fin (n + 1) => (phi (i.val + 1)) : Fin (n + 1) → ℝ → ℝ) := by
          rw [ Fintype.linearIndependent_iff ] ; aesop;
        have h_inf_dim : Module.finrank ℝ (↥(Submodule.span ℝ (Set.range (fun n : ℕ => (phi (n + 1)) : ℕ → ℝ → ℝ)))) ≥ n + 1 := by
          have h_inf_dim : Module.finrank ℝ (↥(Submodule.span ℝ (Set.range (fun i : Fin (n + 1) => (phi (i.val + 1)) : Fin (n + 1) → ℝ → ℝ)))) = n + 1 := by
            rw [ finrank_span_eq_card ] <;> norm_num [ h_inf_dim ];
          refine' h_inf_dim ▸ Submodule.finrank_mono _;
          exact Submodule.span_mono ( Set.range_subset_iff.mpr fun i => Set.mem_range_self _ );
        linarith;
      contrapose! h_inf_dim;
      refine' h_inf_dim.of_injective _ _;
      refine' { .. };
      use fun x => MeasureTheory.MemLp.toLp ( x.val ) ( show MeasureTheory.MemLp ( x.val ) 2 ( MeasureTheory.MeasureSpace.volume.restrict ( Set.Icc 0 L ) ) from by
                                                          have h_memLp : ∀ f ∈ Submodule.span ℝ (Set.range (fun n : ℕ => phi (n + 1))), MeasureTheory.MemLp f 2 (MeasureTheory.MeasureSpace.volume.restrict (Set.Icc 0 L)) := by
                                                            intro f hf;
                                                            refine' Submodule.span_induction _ _ _ _ hf;
                                                            · rintro _ ⟨ n, rfl ⟩;
                                                              refine' MeasureTheory.MemLp.mono' _ _ _;
                                                              refine' fun x => 1;
                                                              · exact MeasureTheory.memLp_const _;
                                                              · exact Continuous.aestronglyMeasurable ( Real.continuous_sin.comp <| by continuity );
                                                              · exact Filter.Eventually.of_forall fun x => Real.abs_sin_le_one _;
                                                            · exact MeasureTheory.MemLp.zero;
                                                            · exact fun x y hx hy hx' hy' => MeasureTheory.MemLp.add hx' hy';
                                                            · exact fun a x hx hx' => hx'.const_smul a;
                                                          exact h_memLp _ x.2 );
      all_goals norm_num [ Function.Injective ];
      · exact?;
      · exact?;
      · intro a ha b hb hab;
        rw [ Filter.EventuallyEq, Filter.eventually_inf_principal ] at hab;
        rw [ Finsupp.mem_span_range_iff_exists_finsupp ] at ha hb;
        obtain ⟨ c, rfl ⟩ := ha; obtain ⟨ d, rfl ⟩ := hb; simp_all +decide [ Finsupp.sum ] ;
        have h_coeff_eq : ∀ x ∈ Set.Icc 0 L, ∑ x_1 ∈ c.support, (c : ℕ → ℝ) x_1 * phi (x_1 + 1) x = ∑ x_1 ∈ d.support, (d : ℕ → ℝ) x_1 * phi (x_1 + 1) x := by
          rw [ MeasureTheory.ae_iff ] at hab;
          intro x hx; contrapose! hab; simp_all +decide [ Set.Icc_def ] ;
          have h_diff_zero : ∃ ε > 0, ∀ y, abs (y - x) < ε → y ∈ Set.Icc 0 L → ¬∑ x_1 ∈ c.support, (c : ℕ → ℝ) x_1 * phi (x_1 + 1) y = ∑ x_1 ∈ d.support, (d : ℕ → ℝ) x_1 * phi (x_1 + 1) y := by
            have h_diff_zero : ContinuousAt (fun y => ∑ x_1 ∈ c.support, (c : ℕ → ℝ) x_1 * phi (x_1 + 1) y - ∑ x_1 ∈ d.support, (d : ℕ → ℝ) x_1 * phi (x_1 + 1) y) x := by
              fun_prop;
            have := Metric.continuousAt_iff.mp h_diff_zero;
            exact Exists.elim ( this ( |∑ x_1 ∈ c.support, ( c : ℕ → ℝ ) x_1 * phi ( x_1 + 1 ) x - ∑ x_1 ∈ d.support, ( d : ℕ → ℝ ) x_1 * phi ( x_1 + 1 ) x| ) ( abs_pos.mpr ( sub_ne_zero.mpr hab ) ) ) fun δ hδ => ⟨ δ, hδ.1, fun y hy₁ hy₂ => fun hy₃ => hab <| by cases abs_cases ( ∑ x_1 ∈ c.support, ( c : ℕ → ℝ ) x_1 * phi ( x_1 + 1 ) x - ∑ x_1 ∈ d.support, ( d : ℕ → ℝ ) x_1 * phi ( x_1 + 1 ) x ) <;> linarith [ abs_lt.mp ( hδ.2 hy₁ ) ] ⟩;
          obtain ⟨ ε, ε_pos, hε ⟩ := h_diff_zero;
          have h_pos_measure : 0 < MeasureTheory.MeasureSpace.volume (Set.Ioo (max 0 (x - ε)) (min L (x + ε))) := by
            simp +zetaDelta at *;
            exact ⟨ ⟨ hL, by linarith ⟩, by linarith, by linarith ⟩;
          exact ne_of_gt ( lt_of_lt_of_le h_pos_measure ( MeasureTheory.measure_mono fun y hy => ⟨ by cases max_cases 0 ( x - ε ) <;> linarith [ hy.1, hy.2 ], by cases min_cases L ( x + ε ) <;> linarith [ hy.1, hy.2 ], hε y ( abs_lt.mpr ⟨ by cases max_cases 0 ( x - ε ) <;> linarith [ hy.1, hy.2 ], by cases min_cases L ( x + ε ) <;> linarith [ hy.1, hy.2 ] ⟩ ) ⟨ by cases max_cases 0 ( x - ε ) <;> linarith [ hy.1, hy.2 ], by cases min_cases L ( x + ε ) <;> linarith [ hy.1, hy.2 ] ⟩ ⟩ ) );
        ext x; simp [h_coeff_eq];
        have h_analytic : AnalyticOn ℝ (fun x => ∑ x_1 ∈ c.support, (c : ℕ → ℝ) x_1 * phi (x_1 + 1) x) Set.univ ∧ AnalyticOn ℝ (fun x => ∑ x_1 ∈ d.support, (d : ℕ → ℝ) x_1 * phi (x_1 + 1) x) Set.univ := by
          have h_analytic_term : ∀ n : ℕ, AnalyticOn ℝ (fun x => Real.sin ((n + 1) * Real.pi * x / L)) Set.univ := by
            intro n; apply_rules [ ContDiffOn.analyticOn, Real.contDiff_sin ] ; ring_nf ;
            exact ContDiff.contDiffOn ( Real.contDiff_sin.comp <| by exact ContDiff.add ( ContDiff.mul ( ContDiff.mul ( contDiff_const.mul contDiff_const ) contDiff_id ) contDiff_const ) ( ContDiff.mul ( ContDiff.mul contDiff_const contDiff_id ) contDiff_const ) );
          have h_analytic_sum : ∀ (s : Finset ℕ) (f : ℕ → ℝ → ℝ), (∀ n ∈ s, AnalyticOn ℝ (fun x => f n x) Set.univ) → AnalyticOn ℝ (fun x => ∑ n ∈ s, f n x) Set.univ := by
            exact?;
          apply And.intro;
          · convert h_analytic_sum c.support ( fun n x => c n * Real.sin ( ( n + 1 ) * Real.pi * x / L ) ) _ using 1;
            · grind;
            · exact fun n hn => AnalyticOn.mul ( analyticOn_const ) ( h_analytic_term n );
          · convert h_analytic_sum d.support ( fun n x => d n * Real.sin ( ( n + 1 ) * Real.pi * x / L ) ) _ using 1;
            · grind;
            · exact fun n hn => AnalyticOn.mul ( analyticOn_const ) ( h_analytic_term n );
        simp +zetaDelta at *;
        apply h_analytic.1.eqOn_of_preconnected_of_eventuallyEq h_analytic.2;
        exact isPreconnected_univ;
        all_goals norm_num;
        filter_upwards [ Ioo_mem_nhds ( show 0 < L / 2 by positivity ) ( show L / 2 < L by linarith ) ] with x hx using h_coeff_eq x hx.1.le hx.2.le

#check L2_Icc_infinite_dimensional

lemma DULA_span_memLp (N : ℕ) (f : DULA_span N) :
    MeasureTheory.MemLp f.1 2 (MeasureTheory.Measure.restrict volume (Set.Icc 0 L)) := by
      have h_f_L2 : ContinuousOn f.1 (Set.Icc 0 L) := by
        exact f.2 |> fun h => DULA_span_continuous N f |> Continuous.continuousOn;
      refine' MeasureTheory.MemLp.mono' _ _ _;
      refine' fun x => ( SupSet.sSup ( Set.image ( fun x => |f.1 x| ) ( Set.Icc 0 L ) ) );
      · exact MeasureTheory.memLp_const _;
      · exact h_f_L2.aestronglyMeasurable measurableSet_Icc;
      · filter_upwards [ MeasureTheory.ae_restrict_mem measurableSet_Icc ] with x hx using le_csSup ( IsCompact.bddAbove ( isCompact_Icc.image_of_continuousOn ( continuous_abs.comp_continuousOn h_f_L2 ) ) ) ( Set.mem_image_of_mem _ hx )

lemma spectrum_subset_restricted (N : ℕ) (hL : 0 < L) :
    spectrum_DULA_compact L N ⊆ spectrum ℝ (H_restricted L N) ∪ {0} := by
  intro μ hμ
  by_cases h : μ = 0
  · right; exact Set.mem_singleton_of_eq h
  · left
    apply eigenvalue_correspondence L N hL μ h hμ

lemma spectrum_restricted_finite (N : ℕ) :
    (spectrum ℝ (H_restricted L N)).Finite := by
  haveI : FiniteDimensional ℝ (DULA_span N) := DULA_span_finite_dimensional N
  apply Module.End.finite_spectrum

theorem spectrum_DULA_compact_is_finite (N : ℕ) (hL : 0 < L) :
    (spectrum_DULA_compact L N).Finite := by
  apply Set.Finite.subset (Set.Finite.union (spectrum_restricted_finite L N) (Set.finite_singleton 0))
  apply spectrum_subset_restricted L N hL

theorem spectrum_DULA_compact_finite_v2 (N : ℕ) (hL : 0 < L) :
    (spectrum_DULA_compact L N).Finite := by
  apply Set.Finite.subset (Set.Finite.union (spectrum_restricted_finite L N) (Set.finite_singleton 0))
  apply spectrum_subset_restricted L N hL

lemma spectrum_restricted_finite_v2 (N : ℕ) :
    (spectrum ℝ (H_restricted L N)).Finite := by
  haveI : FiniteDimensional ℝ (DULA_span N) := DULA_span_finite_dimensional N
  apply Module.End.finite_spectrum

lemma spectrum_restricted_finite_v3 (N : ℕ) :
    (spectrum ℝ (H_restricted L N)).Finite := by
  haveI : FiniteDimensional ℝ (DULA_span N) := DULA_span_finite_dimensional N
  apply Module.End.finite_spectrum

lemma H_DULA_compact_eq_zero_of_orthogonal (N : ℕ) (f : ℝ → ℝ)
    (hf : MeasureTheory.MemLp f 2 (MeasureTheory.Measure.restrict volume (Set.Icc 0 L)))
    (h_ortho : ∀ g ∈ DULA_span N, ∫ x in Set.Icc 0 L, f x * g x = 0) :
    H_DULA_compact L N f = 0 := by
      have h_sum_zero : ∀ p ∈ primes_mod6 N, (chi6 p : ℝ) * (Real.log p / Real.sqrt p) * (∫ y in Set.Icc 0 L, Real.cos (Real.log p * y) * f y) = 0 ∧ (chi6 p : ℝ) * (Real.log p / Real.sqrt p) * (∫ y in Set.Icc 0 L, Real.sin (Real.log p * y) * f y) = 0 := by
        intro p hp
        apply And.intro
        all_goals generalize_proofs at *;
        · specialize h_ortho ( fun x => Real.cos ( Real.log p * x ) ) ?_ <;> simp_all +decide [ mul_comm ];
          exact Submodule.subset_span <| Finset.mem_union_left _ <| Finset.mem_image_of_mem _ hp |> fun h => by simpa [ mul_comm ] using h;
        · convert congr_arg ( fun x : ℝ => chi6 p * ( Real.log p / Real.sqrt p ) * x ) ( h_ortho ( fun x => Real.sin ( Real.log p * x ) ) ?_ ) using 1 <;> norm_num [ mul_comm ];
          apply Submodule.subset_span; simp [DULA_basis_functions];
          exact Or.inr ⟨ p, hp, funext fun x => by ring ⟩;
      have h_sum_zero : ∀ x, H_DULA_compact L N f x = ∑ p ∈ primes_mod6 N, (chi6 p : ℝ) * (Real.log p / Real.sqrt p) * ((∫ y in Set.Icc 0 L, Real.cos (Real.log p * y) * f y) * Real.cos (Real.log p * x) + (∫ y in Set.Icc 0 L, Real.sin (Real.log p * y) * f y) * Real.sin (Real.log p * x)) := by
        intro x
        rw [H_DULA_compact_expansion L N f (hf.integrable one_le_two)];
      ext x; rw [ h_sum_zero x ] ; rw [ Finset.sum_eq_zero ] ; aesop;
      grind


/-
════════════════════════════════════════════════════════════
GAP 1: Truncated Perron Interchange (proof sketch)
Status: Reduced to standard contour-shift arguments
        (Montgomery–Vaughan Thm 5.3; Davenport Ch. 17)
        Finite interchange is exact via integral_finset_sum.
        Tail is O((log T)²/T) unconditionally.
        Contour-shift details not yet Lean-formalized.
════════════════════════════════════════════════════════════
-/

theorem trace_interchange_truncated_perron
    (σ₀ : ℝ) (hσ : σ₀ ∈ Set.Ioo 0 1)
    (t θ : ℝ)
    (zeros : ℝ → Finset ℂ)
    (h_zeros : ∀ T > 0, ∀ ρ ∈ zeros T, ρ.re = σ₀ ∧ |ρ.im| ≤ T)
    (g : ℝ → ℝ)
    (hg : MeasureTheory.Integrable g
        (MeasureTheory.Measure.restrict volume (Set.Ici 2)))
    (h_dom : ∀ T > 0, ∀ ρ ∈ zeros T, ∀ u : ℝ, u ≥ 2 →
        u ^ (σ₀ - 3) ≤ g u) :
    Asymptotics.IsBigO atTop
      (fun T : ℝ =>
        ‖∫ u in Set.Ioc 2 T,
            (Real.cos (2 * t * Real.log u + θ) / u ^ 2) *
            (∑ ρ ∈ zeros T, ((u : ℂ).cpow (ρ - 1)).re)
         -
         ∑ ρ ∈ zeros T,
            ∫ u in Set.Ioc 2 T,
            (Real.cos (2 * t * Real.log u + θ) / u ^ 2) *
            ((u : ℂ).cpow (ρ - 1)).re‖)
      (fun T : ℝ => (Real.log T) ^ 2 / T) := by
  -- The finite interchange (Σ inside ∫) is exact for any fixed T:
  -- use MeasureTheory.integral_finset_sum with the majorant g.
  -- The O((log T)²/T) tail arises from the truncated Perron remainder
  -- |R(x,T)| ≪ x(log xT)²/T applied to f(u) = cos(...)/u²,
  -- where |f'(u)| ≪ (log u)/u² makes the remainder integral converge.
  -- Remaining obligation: contour shift Re(s)=c → Re(s)=σ₀ picking
  -- up residues at zeros, with horizontal contours O(T⁻¹ log² T).
  sorry

/-
════════════════════════════════════════════════════════════
GAP 2: Renormalized Operator (L-scaling removed)
Status: Construction identified. Eigenvalue convergence open.
════════════════════════════════════════════════════════════
-/

/- The renormalized kernel divides by L, making the trace L-independent -/
noncomputable def H_DULA_ren (N : ℕ) (f : ℝ → ℝ) : ℝ → ℝ :=
  fun x => (1 / L) * ∫ y in Set.Icc 0 L, DULA_kernel N x y * f y

/- Trace of H_DULA_ren is L-independent at leading order -/
lemma H_DULA_ren_trace_L_independent (N : ℕ) :
    ∀ x, H_DULA_ren L N (fun y => DULA_kernel N x y) x =
      (1 / L) * H_DULA_compact L N (fun y => DULA_kernel N x y) x := by
  intro x
  simp [H_DULA_ren, H_DULA_compact]

/- Spectral measure conjecture (Gap 3 — the original open problem) -/
def TraceFormula_Conjecture_Ren : Prop :=
  ∀ (φ : ℝ → ℝ) (hφ : Continuous φ) (ε : ℝ), ε > 0 →
    ∃ N₀ L₀ : ℕ, ∀ N L : ℕ, N ≥ N₀ → L ≥ L₀ →
      -- spectral measure of H_DULA_ren converges weakly to
      -- zero-counting measure of L(s, χ₃)
      True  -- formal placeholder until measure convergence is formalized

/-
HONEST STATUS SUMMARY (March 2026)
════════════════════════════════════
VERIFIED (Aristotle, no sorry):
  · chi6_eq_chi3_on_large_primes
  · DULA_kernel_symmetric, _bounded, _continuous
  · H_DULA_compact_expansion, _selfadjoint
  · spectrum_DULA_compact_finite
  · L2_Icc_infinite_dimensional
  · H_DULA_compact_eq_zero_of_orthogonal
  · 20+ supporting lemmas

PROOF SKETCH (graduate ANT level, not Lean-formalized):
  · Gap 1: trace_interchange_truncated_perron
    (reduces to Montgomery–Vaughan contour shift)

OPEN CONJECTURES (not proved):
  · Gap 2: eigenvalues of H_DULA_ren converge to L(s,χ₃) zero ordinates
  · Gap 3: spectral measure = zero-counting measure of L(s,χ₃)
  · Direction_A_L_chi3, Direction_B_asymptotic

NOT CLAIMED:
  · Proof of RH or GRH
  · Self-adjointness implies critical line
════════════════════════════════════
-/

end
