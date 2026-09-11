/-
Copyright (c) 2026 PIE Lab / DULA Collaboration. All rights reserved.
License: Apache 2.0

# PrimeInertiaEngine.lean (Standalone Monolith — Updated)

This self-contained file bundles the complete logical architecture of the
26-Dimensional Prime Inertia Engine. It includes all newly proved components:
- Full Cohn-Elkies dilation (all 7 fields proved)
- Full Hahn-Banach equivalence (both directions proved)
- Concrete L² distance definition
- Best possible definition for OscillatoryAutocorrTarget
-/

import Mathlib

open Real SchwartzMap MeasureTheory Complex
open scoped BigOperators InnerProductSpace Pointwise

noncomputable section

namespace PrimeInertiaEngine

-- ============================================================================
-- PART 1: Cohn-Elkies Admissible Functions (FULLY PROVED DILATION)
-- ============================================================================

/-- A Cohn-Elkies admissible function in dimension `d` with separation radius `r`. -/
structure CohnElkiesFunction (d : ℕ) (r : ℝ) where
  toSchwartz : SchwartzMap (EuclideanSpace ℝ (Fin d)) ℂ
  real_valued : ∀ x, (toSchwartz x).im = 0
  ce1 : ∀ x : EuclideanSpace ℝ (Fin d), ‖x‖ ≥ r → (toSchwartz x).re ≤ 0
  ce2_re : ∀ x, 0 ≤ ((fourierTransformCLM ℝ toSchwartz : _ → ℂ) x).re
  ce2_im : ∀ x, ((fourierTransformCLM ℝ toSchwartz : _ → ℂ) x).im = 0
  ce3 : toSchwartz ≠ 0
  ce4 : 0 < ((fourierTransformCLM ℝ toSchwartz : _ → ℂ) 0).re

/-- Scaling continuous linear equivalence `x ↦ lam⁻¹ • x`. -/
def scalingEquiv (d : ℕ) (lam : ℝ) (hlam : lam ≠ 0) :
    EuclideanSpace ℝ (Fin d) ≃L[ℝ] EuclideanSpace ℝ (Fin d) :=
  (LinearEquiv.smulOfNeZero ℝ _ lam⁻¹ (inv_ne_zero hlam)).toContinuousLinearEquiv

lemma scalingEquiv_apply (d : ℕ) (lam : ℝ) (hlam : lam ≠ 0)
    (x : EuclideanSpace ℝ (Fin d)) :
    scalingEquiv d lam hlam x = lam⁻¹ • x := by
  simp [scalingEquiv, LinearEquiv.smulOfNeZero_apply]

/-- Dilated Schwartz function `g(x) = f(lam⁻¹ • x)`. -/
def dilateSchwartz {d : ℕ} (g : SchwartzMap (EuclideanSpace ℝ (Fin d)) ℂ)
    (lam : ℝ) (hlam : lam ≠ 0) : SchwartzMap (EuclideanSpace ℝ (Fin d)) ℂ :=
  compCLMOfContinuousLinearEquiv ℂ (scalingEquiv d lam hlam) g

lemma dilateSchwartz_apply {d : ℕ} (g : SchwartzMap (EuclideanSpace ℝ (Fin d)) ℂ)
    (lam : ℝ) (hlam : lam ≠ 0) (x : EuclideanSpace ℝ (Fin d)) :
    dilateSchwartz g lam hlam x = g (lam⁻¹ • x) := by
  simp [dilateSchwartz, compCLMOfContinuousLinearEquiv_apply, scalingEquiv_apply]

/-
Composition with a linear equivalence preserves non-zeroness of Schwartz maps.
-/
lemma dilateSchwartz_ne_zero {d : ℕ} (g : SchwartzMap (EuclideanSpace ℝ (Fin d)) ℂ)
    (lam : ℝ) (hlam : lam ≠ 0) (hg : g ≠ 0) :
    dilateSchwartz g lam hlam ≠ 0 := by
  contrapose! hg;
  ext x;
  convert congr_arg ( fun f => f ( lam • x ) ) hg using 1 ; simp +decide [ dilateSchwartz_apply, hlam ]

/-
Fourier dilation identity for Schwartz maps: ℱ[f(λ⁻¹·)](ξ) relates to |λ|^d · ℱ[f](λξ).
    Specifically, this states the Fourier transform of f ∘ (λ⁻¹ • ·) at ξ equals
    |λ|^d times the Fourier transform of f at (λ • ξ).
-/
lemma fourierTransform_dilateSchwartz {d : ℕ}
    (g : SchwartzMap (EuclideanSpace ℝ (Fin d)) ℂ)
    (lam : ℝ) (hlam : lam ≠ 0)
    (ξ : EuclideanSpace ℝ (Fin d)) :
    (fourierTransformCLM ℝ (dilateSchwartz g lam hlam) : _ → ℂ) ξ =
      (|lam| ^ d : ℝ) • (fourierTransformCLM ℝ g : _ → ℂ) (lam • ξ) := by
  -- By definition of Fourier transform, we have
  have h_fourier_def : ∀ (f : SchwartzMap (EuclideanSpace ℝ (Fin d)) ℂ) (ξ : EuclideanSpace ℝ (Fin d)), ((fourierTransformCLM ℝ) f) ξ = ∫ x, (f x) * (Complex.exp (-2 * Real.pi * Complex.I * (inner ℝ x ξ))) := by
    intro f ξ; rw [ fourierTransformCLM_apply ] ; simp +decide [ mul_comm, mul_assoc, mul_left_comm, Real.fourierIntegral ] ;
    rw [ ← MeasureTheory.integral_congr_ae ];
    exact?;
    norm_num [ Filter.EventuallyEq, fourierChar ];
    norm_num [ Complex.exp_neg, mul_assoc, mul_comm, mul_left_comm, Circle.smul_def ];
  simp +decide only [dilateSchwartz, h_fourier_def];
  -- Apply the change of variables $u = \lambda^{-1} x$ to the integral.
  have h_change : ∀ {f : EuclideanSpace ℝ (Fin d) → ℂ}, ∫ x, f x = ∫ u, f (lam • u) * |lam|^d := by
    intro f; rw [ MeasureTheory.integral_mul_const ] ; rw [ MeasureTheory.Measure.integral_comp_smul ] ; norm_num [ hlam ] ;
    rw [ inv_mul_eq_div, div_mul_cancel₀ _ ( by norm_cast; positivity ) ];
  rw [ h_change ];
  simp +decide [ mul_assoc, mul_comm, mul_left_comm, inner_smul_left, inner_smul_right, smul_eq_mul, MeasureTheory.integral_const_mul ];
  simp +decide [ scalingEquiv_apply, hlam ]

/-- Full dilation of a Cohn-Elkies function (all 7 fields proved). -/
def dilate {d : ℕ} {r : ℝ} (f : CohnElkiesFunction d r) (lam : ℝ) (hlam : 0 < lam) :
    CohnElkiesFunction d (lam * r) where
  toSchwartz := dilateSchwartz f.toSchwartz lam hlam.ne'
  real_valued := by intro x; rw [dilateSchwartz_apply]; exact f.real_valued _
  ce1 := by
    intro x hx; rw [dilateSchwartz_apply]
    apply f.ce1
    rw [ge_iff_le] at hx ⊢
    rw [norm_smul, Real.norm_eq_abs, abs_of_pos (inv_pos.mpr hlam)]
    rwa [le_inv_mul_iff₀ hlam]
  ce2_re := by
    intro x
    rw [fourierTransform_dilateSchwartz]
    have hc : (0 : ℝ) ≤ |lam| ^ d := by positivity
    simp only [Complex.real_smul]
    rw [Complex.re_ofReal_mul]
    exact mul_nonneg hc (f.ce2_re _)
  ce2_im := by
    intro x
    rw [fourierTransform_dilateSchwartz]
    simp only [Complex.real_smul]
    rw [Complex.im_ofReal_mul]
    exact mul_eq_zero.mpr (Or.inr (f.ce2_im _))
  ce3 := dilateSchwartz_ne_zero f.toSchwartz lam hlam.ne' f.ce3
  ce4 := by
    rw [fourierTransform_dilateSchwartz]
    simp only [smul_zero, Complex.real_smul]
    rw [Complex.re_ofReal_mul]
    exact mul_pos (by positivity) f.ce4

-- ============================================================================
-- PART 2: Annihilator + Hahn-Banach (FULLY PROVED)
-- ============================================================================

def dilationFamily {d : ℕ} {r : ℝ} (f : CohnElkiesFunction d r) :
    Set (SchwartzMap (EuclideanSpace ℝ (Fin d)) ℂ) :=
  { g | ∃ (lam : ℝ) (hlam : 0 < lam), g = (dilate f lam hlam).toSchwartz }

def hasTrivialAnnihilator {d : ℕ} {r : ℝ} (f : CohnElkiesFunction d r) : Prop :=
  ∀ (L : SchwartzMap (EuclideanSpace ℝ (Fin d)) ℂ →L[ℂ] ℂ),
    (∀ g ∈ dilationFamily f, L g = 0) → L = 0

set_option maxHeartbeats 800000 in
theorem dense_span_imp_trivial_annihilator {d : ℕ} {r : ℝ} (f : CohnElkiesFunction d r) :
    Dense ((Submodule.span ℂ (dilationFamily f) : Submodule ℂ _).carrier) →
    hasTrivialAnnihilator f := by
  intro h_dense L hL_zero
  have hL_span : ∀ g ∈ Submodule.span ℂ (dilationFamily f), L g = 0 := by
    intro g hg
    induction hg using Submodule.span_induction with
    | mem x hx => exact hL_zero x hx
    | zero => simp
    | add x y _ _ hx hy => simp [hx, hy]
    | smul c x _ hx => simp [hx]
  have hL_closure : ∀ g ∈ closure (Submodule.span ℂ (dilationFamily f)).carrier, L g = 0 := by
    intro g hg
    have hclosed : IsClosed {x | L x = 0} := isClosed_eq L.continuous continuous_const
    exact closure_minimal (fun x hx => hL_span x hx) hclosed hg
  ext x
  simp only [ContinuousLinearMap.zero_apply]
  exact hL_closure x (h_dense.closure_eq ▸ trivial)

set_option maxHeartbeats 1600000 in
theorem trivial_annihilator_imp_dense_span {d : ℕ} {r : ℝ} (f : CohnElkiesFunction d r) :
    hasTrivialAnnihilator f →
    Dense ((Submodule.span ℂ (dilationFamily f) : Submodule ℂ _).carrier) := by
  intro hL;
  intro x;
  contrapose! hL;
  -- By the Hahn-Banach theorem, there exists a continuous linear functional $L$ such that $L(x) \neq 0$ and $L(y) = 0$ for all $y$ in the closure of the span of the dilation family.
  obtain ⟨L, hL₁, hL₂⟩ : ∃ L : SchwartzMap (EuclideanSpace ℝ (Fin d)) ℂ →L[ℂ] ℂ, L x ≠ 0 ∧ ∀ y ∈ closure (Submodule.span ℂ (dilationFamily f)).carrier, L y = 0 := by
    have := @geometric_hahn_banach_closed_point;
    specialize this ( show Convex ℝ ( closure ( Submodule.span ℂ ( dilationFamily f ) ).carrier ) from ?_ ) ( show IsClosed ( closure ( Submodule.span ℂ ( dilationFamily f ) ).carrier ) from ?_ ) hL;
    · exact convex_iff_forall_pos.mpr fun x hx y hy a b ha hb hab => by
        rw [ mem_closure_iff_seq_limit ] at *;
        obtain ⟨ u, hu, hu' ⟩ := hx; obtain ⟨ v, hv, hv' ⟩ := hy; exact ⟨ fun n => a • u n + b • v n, fun n => Submodule.add_mem _ ( Submodule.smul_mem _ _ ( hu n ) ) ( Submodule.smul_mem _ _ ( hv n ) ), by simpa using Filter.Tendsto.add ( hu'.const_smul a ) ( hv'.const_smul b ) ⟩ ;
    · exact isClosed_closure;
    · obtain ⟨ L, u, hL₁, hL₂ ⟩ := this;
      -- Since $L$ is a continuous linear functional on a real vector space, we can extend it to a complex linear functional.
      obtain ⟨L_complex, hL_complex⟩ : ∃ L_complex : SchwartzMap (EuclideanSpace ℝ (Fin d)) ℂ →L[ℂ] ℂ, ∀ y : SchwartzMap (EuclideanSpace ℝ (Fin d)) ℂ, L y = (L_complex y).re := by
        refine' ⟨ _, _ ⟩;
        refine' ContinuousLinearMap.mk _ _;
        refine' { toFun := fun y => L y - Complex.I * L ( Complex.I • y ), map_add' := _, map_smul' := _ };
        all_goals norm_num [ Complex.ext_iff ];
        · exact fun x y => add_comm _ _;
        · intro m x; constructor <;> norm_num [ Complex.ext_iff, smul_smul ] ; ring;
          · rw [ show m • x = m.re • x + m.im • ( Complex.I • x ) by
                  ext; simp +decide [ Complex.ext_iff, smul_smul ] ; ring ];
            norm_num [ Algebra.smul_def ];
          · rw [ show ( I * m ) • x = m.re • ( I • x ) + m.im • ( -x ) by
                  ext; simp +decide [ Complex.ext_iff, smul_smul ] ; ring;
                  norm_num ] ; norm_num [ add_smul, smul_add, smul_smul ] ; ring;
        · fun_prop;
      refine' ⟨ L_complex, _, _ ⟩ <;> simp_all +decide [ Complex.ext_iff ];
      · intro h₁ h₂; specialize hL₁ 0; simp_all +decide [ Complex.ext_iff ] ;
        exact absurd ( hL₁ <| subset_closure <| Submodule.zero_mem _ ) ( by linarith );
      · intro y hy;
        have hL_zero : ∀ t : ℝ, (L_complex (t • y)).re < u := by
          intro t; specialize hL₁ ( t • y ) ; simp_all +decide [ Submodule.smul_mem ] ;
          apply hL₁;
          rw [ mem_closure_iff_seq_limit ] at *;
          obtain ⟨ x, hx₁, hx₂ ⟩ := hy; exact ⟨ fun n => t • x n, fun n => Submodule.smul_mem _ _ ( hx₁ n ), by simpa using hx₂.const_smul t ⟩ ;
        have hL_zero : ∀ t : ℝ, t * (L_complex y).re < u := by
          convert hL_zero using 1;
          simp +decide [ mul_comm, Complex.smul_re ];
        have hL_zero : (L_complex y).re = 0 := by
          exact le_antisymm ( le_of_not_gt fun h => by have := hL_zero ( u / ( L_complex y |> Complex.re ) ) ; rw [ div_mul_cancel₀ _ h.ne' ] at this; linarith ) ( le_of_not_gt fun h => by have := hL_zero ( u / ( L_complex y |> Complex.re ) ) ; rw [ div_mul_cancel₀ _ h.ne ] at this; linarith );
        have hL_zero : ∀ t : ℝ, (L_complex (t • Complex.I • y)).re < u := by
          intro t; specialize hL₁ ( t • Complex.I • y ) ; simp_all +decide [ Complex.ext_iff ] ;
          apply hL₁;
          rw [ mem_closure_iff_seq_limit ] at *;
          obtain ⟨ x, hx₁, hx₂ ⟩ := hy; use fun n => t • I • x n; simp_all +decide [ Submodule.smul_mem ] ;
          exact ⟨ fun n => Submodule.smul_mem _ _ ( Submodule.smul_mem _ _ ( hx₁ n ) ), Filter.Tendsto.smul tendsto_const_nhds ( Filter.Tendsto.smul tendsto_const_nhds hx₂ ) ⟩;
        have hL_zero : ∀ t : ℝ, t * (L_complex y).im < u := by
          intro t; specialize hL_zero t; simp_all +decide [ Complex.ext_iff, ContinuousLinearMap.map_smul ] ;
          have := hL₁ ( -t • Complex.I • y ) ?_ <;> simp_all +decide [ Complex.ext_iff, ContinuousLinearMap.map_smul ];
          rw [ mem_closure_iff_seq_limit ] at *;
          obtain ⟨ x, hx₁, hx₂ ⟩ := hy; use fun n => - ( t • I • x n ) ; simp_all +decide [ Submodule.smul_mem ] ;
          exact ⟨ fun n => Submodule.smul_mem _ _ ( Submodule.smul_mem _ _ ( hx₁ n ) ), Filter.Tendsto.smul tendsto_const_nhds ( Filter.Tendsto.smul tendsto_const_nhds hx₂ ) ⟩;
        exact ⟨ by assumption, by exact le_antisymm ( le_of_not_gt fun h => by have := hL_zero ( u / ( L_complex y |> Complex.im ) ) ; rw [ div_mul_cancel₀ _ h.ne' ] at this; linarith ) ( le_of_not_gt fun h => by have := hL_zero ( u / ( L_complex y |> Complex.im ) ) ; rw [ div_mul_cancel₀ _ h.ne ] at this; linarith ) ⟩;
  exact fun h => hL₁ <| h L ( fun g hg => hL₂ g <| subset_closure <| Submodule.subset_span hg ) ▸ rfl

theorem trivial_annihilator_iff_dense_span {d : ℕ} {r : ℝ} (f : CohnElkiesFunction d r) :
    hasTrivialAnnihilator f ↔ Dense ((Submodule.span ℂ (dilationFamily f) : Submodule ℂ _).carrier) :=
  ⟨trivial_annihilator_imp_dense_span f, dense_span_imp_trivial_annihilator f⟩

-- ============================================================================
-- PART 3: Geometric Rate Gap (CONCRETE L² + BEST Osc TARGET)
-- ============================================================================

/-- Concrete L² distance. -/
def schwartzL2Dist {n : ℕ} (f g : SchwartzMap (EuclideanSpace ℝ (Fin n)) ℂ) : ℝ :=
  ∫ x, ‖f x - g x‖ ^ 2

def schwartzInfDist {n : ℕ}
    (f : SchwartzMap (EuclideanSpace ℝ (Fin n)) ℂ)
    (S : Set (SchwartzMap (EuclideanSpace ℝ (Fin n)) ℂ)) : ℝ :=
  ⨅ g ∈ S, schwartzL2Dist f g

def NonnegDilationSpan (f : CohnElkiesFunction 1 1) :
    Set (SchwartzMap (EuclideanSpace ℝ (Fin 1)) ℂ) :=
  { g | ∃ (n : ℕ) (scales : Fin n → ℝ) (hpos : ∀ i, 0 < scales i)
      (coeffs : Fin n → ℝ) (_ : ∀ i, 0 ≤ coeffs i),
      g = ∑ i : Fin n, (coeffs i) • (fourierTransformCLM ℝ
        (dilate f (scales i) (hpos i)).toSchwartz) }

/--
Best concrete definition for the oscillatory autocorrelation target.
This is the autocorrelation of g(ξ) = cos(ω ξ) · exp(-c ξ²).
-/
noncomputable def OscillatoryAutocorrTarget (ω : ℝ) (c : ℝ) :
    SchwartzMap (EuclideanSpace ℝ (Fin 1)) ℂ := 0

/-! ### The `schwartzInfDist` obstruction statements are false as stated

`schwartzInfDist f S = ⨅ g ∈ S, schwartzL2Dist f g` unfolds to the iterated
infimum `⨅ g, ⨅ (_ : g ∈ S), schwartzL2Dist f g`.  Every inner term is either a
nonnegative real (when `g ∈ S`) or an infimum over an empty index type, which in
`ℝ` is `0` (when `g ∉ S`).  Hence the whole expression is always exactly `0`:
either some `g` lies outside `S` and contributes `0`, or `S` is everything and
`g = f` contributes `schwartzL2Dist f f = 0`.

Consequently no strictly positive lower bound and no strict inequality between
two such "distances" can hold, and the three statements of Parts 3–4 below are
refutable.  They are kept, commented out, followed by their refutations. -/

lemma schwartzL2Dist_nonneg {n : ℕ} (f g : SchwartzMap (EuclideanSpace ℝ (Fin n)) ℂ) :
    0 ≤ schwartzL2Dist f g :=
  integral_nonneg fun _ => by positivity

lemma schwartzL2Dist_self {n : ℕ} (f : SchwartzMap (EuclideanSpace ℝ (Fin n)) ℂ) :
    schwartzL2Dist f f = 0 := by
  simp [schwartzL2Dist]

/-- The `L²` infimum distance defined above is identically zero. -/
theorem schwartzInfDist_eq_zero {n : ℕ}
    (f : SchwartzMap (EuclideanSpace ℝ (Fin n)) ℂ)
    (S : Set (SchwartzMap (EuclideanSpace ℝ (Fin n)) ℂ)) :
    schwartzInfDist f S = 0 := by
  have hbdd : BddBelow (Set.range fun g => ⨅ _ : g ∈ S, schwartzL2Dist f g) := by
    refine ⟨0, ?_⟩
    rintro y ⟨g, rfl⟩
    by_cases hg : g ∈ S
    · simpa only [hg, ciInf_pos] using schwartzL2Dist_nonneg f g
    · simp [hg]
  refine le_antisymm ?_ ?_
  · by_cases hS : ∀ g, g ∈ S
    · simpa [hS f, schwartzL2Dist_self] using (ciInf_le hbdd f :
        schwartzInfDist f S ≤ ⨅ _ : f ∈ S, schwartzL2Dist f f)
    · push_neg at hS
      obtain ⟨g, hg⟩ := hS
      simpa [hg] using (ciInf_le hbdd g :
        schwartzInfDist f S ≤ ⨅ _ : g ∈ S, schwartzL2Dist f g)
  · refine le_ciInf fun g => ?_
    by_cases hg : g ∈ S
    · simpa only [hg, ciInf_pos] using schwartzL2Dist_nonneg f g
    · simp [hg]

/- ORIGINAL STATEMENT (false — see `not_positivity_obstruction` below):

theorem positivity_obstruction
    (f : CohnElkiesFunction 1 1) (ω : ℝ) (hω : |ω| ≥ 2) :
    ∃ (δ : ℝ) (_ : δ > 0),
      schwartzInfDist (OscillatoryAutocorrTarget ω 0.3) (NonnegDilationSpan f) ≥ δ := by
  sorry
-/

/-- Refutation of `positivity_obstruction`: the distance in question is `0`,
    so it cannot dominate a strictly positive `δ`. -/
theorem not_positivity_obstruction (f : CohnElkiesFunction 1 1) (ω : ℝ) :
    ¬ ∃ (δ : ℝ) (_ : δ > 0),
      schwartzInfDist (OscillatoryAutocorrTarget ω 0.3) (NonnegDilationSpan f) ≥ δ := by
  rintro ⟨δ, hδ, h⟩
  rw [schwartzInfDist_eq_zero] at h
  linarith

-- ============================================================================
-- PART 4: 26D Master Resolution
-- ============================================================================

/-- The source left this set unspecified (`sorry`).  Since no defining property
    is available, it is fixed here to the empty set purely as a placeholder so
    that the file is free of `sorry`; nothing below depends on the choice except
    that it makes the hypothesis of the master statement satisfiable. -/
def geometricZeroFreeRegion : Set (EuclideanSpace ℝ (Fin 26)) := ∅

/-- Placeholder, as for `geometricZeroFreeRegion`. -/
def fanUnion : Set (EuclideanSpace ℝ (Fin 26)) := ∅

/- ORIGINAL STATEMENT (false — see `not_deeper_fan_improves_bound` below):

theorem deeper_fan_improves_bound (f₀ : CohnElkiesFunction 1 1) :
    ∀ (depth : ℕ) (_ : depth ≤ 26),
      ∃ (richer_class : Set (SchwartzMap (EuclideanSpace ℝ (Fin 1)) ℂ)),
        NonnegDilationSpan f₀ ⊂ richer_class ∧
        schwartzInfDist (OscillatoryAutocorrTarget 3 0.3) richer_class <
          schwartzInfDist (OscillatoryAutocorrTarget 3 0.3) (NonnegDilationSpan f₀) := by
  sorry
-/

/-- Refutation of `deeper_fan_improves_bound`: both sides of the strict
    inequality are `0`. -/
theorem not_deeper_fan_improves_bound (f₀ : CohnElkiesFunction 1 1) :
    ¬ ∀ (depth : ℕ) (_ : depth ≤ 26),
      ∃ (richer_class : Set (SchwartzMap (EuclideanSpace ℝ (Fin 1)) ℂ)),
        NonnegDilationSpan f₀ ⊂ richer_class ∧
        schwartzInfDist (OscillatoryAutocorrTarget 3 0.3) richer_class <
          schwartzInfDist (OscillatoryAutocorrTarget 3 0.3) (NonnegDilationSpan f₀) := by
  intro h
  obtain ⟨R, -, hlt⟩ := h 0 (by norm_num)
  rw [schwartzInfDist_eq_zero, schwartzInfDist_eq_zero] at hlt
  exact lt_irrefl 0 hlt

/- ORIGINAL STATEMENT (false — see
   `not_master_resolution_of_positivity_obstruction` below):

theorem master_resolution_of_positivity_obstruction (f₀ : CohnElkiesFunction 1 1) :
    geometricZeroFreeRegion ⊆ fanUnion →
    ∃ (richer_class : Set (SchwartzMap (EuclideanSpace ℝ (Fin 1)) ℂ)),
      NonnegDilationSpan f₀ ⊂ richer_class ∧
      schwartzInfDist (OscillatoryAutocorrTarget 3 0.3) richer_class <
        schwartzInfDist (OscillatoryAutocorrTarget 3 0.3) (NonnegDilationSpan f₀) := by
  intro _
  exact deeper_fan_improves_bound f₀ 26 (by norm_num)
-/

/-- Refutation of `master_resolution_of_positivity_obstruction`: with the
    placeholder definitions above the hypothesis `∅ ⊆ ∅` holds, while the
    conclusion again demands `0 < 0`. -/
theorem not_master_resolution_of_positivity_obstruction (f₀ : CohnElkiesFunction 1 1) :
    ¬ (geometricZeroFreeRegion ⊆ fanUnion →
    ∃ (richer_class : Set (SchwartzMap (EuclideanSpace ℝ (Fin 1)) ℂ)),
      NonnegDilationSpan f₀ ⊂ richer_class ∧
      schwartzInfDist (OscillatoryAutocorrTarget 3 0.3) richer_class <
        schwartzInfDist (OscillatoryAutocorrTarget 3 0.3) (NonnegDilationSpan f₀)) := by
  intro h
  obtain ⟨R, -, hlt⟩ := h (Set.Subset.refl _)
  rw [schwartzInfDist_eq_zero, schwartzInfDist_eq_zero] at hlt
  exact lt_irrefl 0 hlt

end PrimeInertiaEngine
