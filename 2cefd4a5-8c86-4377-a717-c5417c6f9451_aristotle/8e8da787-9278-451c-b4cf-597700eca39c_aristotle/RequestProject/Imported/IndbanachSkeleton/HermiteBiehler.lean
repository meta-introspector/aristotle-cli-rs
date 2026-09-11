import Mathlib
import RequestProject.Imported.IndbanachSkeleton.WeilTestFunction
import RequestProject.Imported.IndbanachSkeleton.ZetaConj

/-!
# Hermite-Biehler Function from the Leech Lattice
-/

open Real Complex MeasureTheory Set
open scoped BigOperators

noncomputable section

-- ============================================================================
-- PART 1: THE COMPLETED ZETA FUNCTION ON THE CRITICAL LINE
-- ============================================================================

/-- The completed Riemann zeta function ξ(s). -/
def xi (s : ℂ) : ℂ := completedRiemannZeta s

/-- Ξ(z) = ξ(1/2 + iz): the completed zeta on the critical line. -/
def Xi (z : ℂ) : ℂ := xi (1/2 + Complex.I * z)

/-- The functional equation of ξ: ξ(s) = ξ(1-s). -/
theorem xi_functional_equation (s : ℂ) : xi s = xi (1 - s) :=
  (completedRiemannZeta_one_sub s).symm

/-- Ξ is an even function: Ξ(z) = Ξ(-z). -/
theorem Xi_even (z : ℂ) : Xi z = Xi (-z) := by
  unfold Xi xi
  have h : (1 : ℂ)/2 + Complex.I * z = 1 - ((1 : ℂ)/2 + Complex.I * (-z)) := by ring
  rw [h]; simp [completedRiemannZeta_one_sub]

-- ============================================================================
-- PART 2: THE LEECH LATTICE PARAMETER
-- ============================================================================

/-- The kissing number of the Leech lattice. -/
def leech_kissing_number : ℕ := 196560

lemma leech_kissing_pos : (0 : ℝ) < (leech_kissing_number : ℝ) := by
  unfold leech_kissing_number; positivity

/-- The Hermite-Biehler parameter α derived from the Leech lattice. -/
def alpha_leech : ℝ := Real.pi / Real.log (leech_kissing_number : ℝ)

lemma alpha_leech_pos : alpha_leech > 0 := by
  unfold alpha_leech
  apply div_pos Real.pi_pos
  apply Real.log_pos
  unfold leech_kissing_number
  norm_num

-- ============================================================================
-- PART 3: THE HERMITE-BIEHLER FUNCTION
-- ============================================================================

/-- The candidate Hermite-Biehler function E(z) = Ξ(z) · exp(-i·α·z). -/
def E_leech (z : ℂ) : ℂ :=
  Xi z * Complex.exp (-(Complex.I * (alpha_leech : ℂ) * z))

/-- The real part A(z). -/
def A_leech (z : ℂ) : ℂ :=
  Xi z * Complex.cos ((alpha_leech : ℂ) * z)

/-- The imaginary part B(z). -/
def B_leech (z : ℂ) : ℂ :=
  -(Xi z * Complex.sin ((alpha_leech : ℂ) * z))

/-- E = A + iB decomposition. -/
theorem E_eq_A_plus_iB (z : ℂ) :
    E_leech z = A_leech z + Complex.I * B_leech z := by
  unfold E_leech A_leech B_leech
  rw [show -(Complex.I * ↑alpha_leech * z) = (-(↑alpha_leech * z)) * Complex.I from by ring]
  rw [Complex.exp_mul_I]
  simp [Complex.cos_neg, Complex.sin_neg]
  ring

-- ============================================================================
-- PART 4: THE HERMITE-BIEHLER CONDITIONS
-- ============================================================================

/-- HB1: E has no zeros in the upper half-plane. -/
def HB1_no_upper_zeros : Prop :=
  ∀ z : ℂ, z.im > 0 → E_leech z ≠ 0

/-- E_leech z = 0 iff Xi z = 0. -/
lemma E_leech_zero_iff (z : ℂ) : E_leech z = 0 ↔ Xi z = 0 := by
  constructor
  · intro h
    unfold E_leech at h
    exact (mul_eq_zero.mp h).resolve_right (Complex.exp_ne_zero _)
  · intro h; unfold E_leech; rw [h, zero_mul]

/-- If completedRiemannZeta(s) = 0 and s ≠ 0, then riemannZeta(s) = 0. -/
lemma completedRiemannZeta_zero_imp_riemannZeta_zero {s : ℂ} (hs : s ≠ 0)
    (h : completedRiemannZeta s = 0) : riemannZeta s = 0 := by
  rw [riemannZeta_def_of_ne_zero hs, h, zero_div]

/-- The real part of 1/2 + I*z is 1/2 - z.im. -/
lemma re_half_add_I_mul (z : ℂ) : (1/2 + Complex.I * z).re = 1/2 - z.im := by
  simp [Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im]
  ring

/-- 1/2 + I*z ≠ 0 when z.im ≠ 1/2. -/
lemma half_add_I_mul_ne_zero (z : ℂ) (hz : z.im ≠ 1/2) :
    (1/2 : ℂ) + Complex.I * z ≠ 0 := by
  exact fun h => hz <| by norm_num [Complex.ext_iff] at h; linarith

/-- 1/2 + I*z ≠ 1 when z.im > 0. -/
lemma half_add_I_mul_ne_one (z : ℂ) (hz : z.im > 0) :
    (1/2 : ℂ) + Complex.I * z ≠ 1 := by
  exact ne_of_apply_ne Complex.re (by norm_num; linarith)

/-
RH implies all zeros of completedRiemannZeta have Re = 1/2.
-/
lemma rh_completedRiemannZeta_zeros (hRH : RiemannHypothesis) {s : ℂ}
    (h : completedRiemannZeta s = 0) : s.re = 1/2 := by
  -- Apply the Riemann Hypothesis to the zero s.
  apply hRH;
  · convert completedRiemannZeta_zero_imp_riemannZeta_zero _ h using 1;
    rintro rfl;
    convert completedRiemannZeta_one_sub _;
    swap;
    exact 1;
    norm_num [ h ];
    rw [ completedRiemannZeta_one ];
    norm_num [ Complex.ext_iff, Complex.log_re, Complex.log_im ];
    rw [ abs_of_pos Real.pi_pos ] ; norm_num [ Real.log_mul, Real.pi_ne_zero ];
    intro h;
    have h_gamma_lt_log4 : eulerMascheroniConstant < Real.log 4 := by
      have h_gamma_lt_log4 : eulerMascheroniConstant < 1 := by
        grind +suggestions;
      exact h_gamma_lt_log4.trans_le ( Real.le_log_iff_exp_le ( by norm_num ) |>.2 <| by exact Real.exp_one_lt_d9.le.trans <| by norm_num );
    linarith [ Real.log_pos ( show 4 > 1 by norm_num ), Real.log_pos ( show Real.pi > 1 by linarith [ Real.pi_gt_three ] ) ];
  · rintro ⟨ n, rfl ⟩;
    -- By the functional equation, we have ξ(-2(n+1)) = ξ(2n+3).
    have h_fun_eq : completedRiemannZeta (-2 * (n + 1)) = completedRiemannZeta (2 * n + 3) := by
      convert completedRiemannZeta_one_sub _ using 2 ; ring;
    -- Since $2n + 3 > 1$, we have $\zeta(2n + 3) \neq 0$.
    have h_zeta_ne_zero : riemannZeta (2 * n + 3) ≠ 0 := by
      apply riemannZeta_ne_zero_of_one_lt_re;
      norm_cast ; linarith;
    rw [ riemannZeta_def_of_ne_zero ] at h_zeta_ne_zero <;> norm_num at *;
    · aesop;
    · norm_cast;
  · rintro rfl;
    convert riemannZeta_one_ne_zero _;
    grind +suggestions

/-- HB1 follows from RH. -/
theorem rh_implies_hb1 : RiemannHypothesis → HB1_no_upper_zeros := by
  intro hRH z hz hEz
  rw [E_leech_zero_iff] at hEz
  unfold Xi xi at hEz
  have hre := rh_completedRiemannZeta_zeros hRH hEz
  rw [re_half_add_I_mul] at hre
  linarith

/-- The conjugation identity for Xi: Xi(conj z) = conj(Xi z). -/
lemma Xi_conj (z : ℂ) : Xi (starRingEnd ℂ z) = starRingEnd ℂ (Xi z) := by
  unfold Xi xi
  rw [← completedRiemannZeta_conj]
  convert completedRiemannZeta_one_sub _ using 2
  norm_num [Complex.ext_iff]; ring

/-- HB2: |E(z̄)| < |E(z)| for Im(z) > 0, provided Xi(z) ≠ 0. -/
theorem hb2_ratio_bound (z : ℂ) (hz : z.im > 0) (hXi : Xi z ≠ 0) :
    ‖E_leech (starRingEnd ℂ z)‖ < ‖E_leech z‖ := by
  have h_exp_norm : ‖Complex.exp (-(Complex.I * (alpha_leech : ℂ) * starRingEnd ℂ z))‖ <
      ‖Complex.exp (-(Complex.I * (alpha_leech : ℂ) * z))‖ := by
    simp [Complex.norm_exp]
    exact mul_pos alpha_leech_pos hz
  convert mul_lt_mul_of_pos_left h_exp_norm (norm_pos_iff.mpr hXi) using 1
  · simp [E_leech, Xi_conj]
  · exact norm_mul _ _

/-- HB3: Real zeros of E are exactly the zeta zeros. -/
theorem hb3_real_zeros (t : ℝ) :
    E_leech (t : ℂ) = 0 ↔ Xi (t : ℂ) = 0 := by
  constructor
  · intro h
    unfold E_leech at h
    have hexp : Complex.exp (-(Complex.I * (alpha_leech : ℂ) * (t : ℂ))) ≠ 0 :=
      Complex.exp_ne_zero _
    exact (mul_eq_zero.mp h).resolve_right hexp
  · intro h; unfold E_leech; rw [h, zero_mul]

/-
============================================================================
PART 5: CONNECTION TO WEIL POSITIVITY
============================================================================

HB1 implies no zeros of completedRiemannZeta with Re(s) < 1/2.
-/
lemma hb1_no_zeros_re_lt_half (hHB : HB1_no_upper_zeros)
    {s : ℂ} (hs : s.re < 1/2) : completedRiemannZeta s ≠ 0 := by
  contrapose! hHB;
  unfold HB1_no_upper_zeros;
  simp;
  use -Complex.I * (s - 1 / 2);
  unfold E_leech; norm_num [ hHB, Xi ] ; ring_nf; norm_num [ hs ] ;
  exact hHB

/-
HB1 implies no zeros of completedRiemannZeta with Re(s) > 1/2.
-/
lemma hb1_no_zeros_re_gt_half (hHB : HB1_no_upper_zeros)
    {s : ℂ} (hs : s.re > 1/2) : completedRiemannZeta s ≠ 0 := by
  convert hb1_no_zeros_re_lt_half hHB ( show ( 1 - s ).re < 1 / 2 by norm_num; linarith ) using 1;
  exact Eq.symm (completedRiemannZeta_one_sub s)

/-
The Gammaℝ factor is nonzero at non-trivial, non-zero points.
-/
lemma gammaR_ne_zero_of_not_trivial {s : ℂ} (hs0 : s ≠ 0)
    (htrivial : ∀ n : ℕ, s ≠ -2 * (↑n + 1)) : s.Gammaℝ ≠ 0 := by
  refine' mul_ne_zero _ ( Complex.Gamma_ne_zero fun n => _ );
  · norm_num [ Real.pi_ne_zero, Complex.cpow_def ];
  · intro h; specialize htrivial ( n - 1 ) ; rcases n with ( _ | n ) <;> simp_all +decide [ div_eq_iff ] ;
    exact htrivial ( by ring )

/-
riemannZeta s = 0 at a non-trivial zero implies completedRiemannZeta s = 0.
-/
lemma riemannZeta_zero_imp_completed_zero {s : ℂ}
    (hzeta : riemannZeta s = 0)
    (htrivial : ∀ n : ℕ, s ≠ -2 * (↑n + 1))
    (_hs1 : s ≠ 1) : completedRiemannZeta s = 0 := by
  have h_gamma_ne_zero : s.Gammaℝ ≠ 0 := by
    apply gammaR_ne_zero_of_not_trivial;
    · rintro rfl; norm_num at *;
      exact absurd hzeta ( by rw [ riemannZeta_zero ] ; norm_num );
    · assumption;
  rw [riemannZeta_def_of_ne_zero] at hzeta;
  · aesop;
  · rintro rfl; norm_num at *;
    exact h_gamma_ne_zero ( by norm_num [ Complex.Gammaℝ ] )

/-
HB1 implies RH.
-/
theorem hb1_implies_rh : HB1_no_upper_zeros → RiemannHypothesis := by
  intro h;
  intro s hs htrivial hs1;
  -- By riemannZeta_zero_imp_completed_zero, completedRiemannZeta s = 0.
  have h_completed : completedRiemannZeta s = 0 := by
    apply riemannZeta_zero_imp_completed_zero hs (by
    exact fun n hn => htrivial ⟨ n, hn ⟩) hs1;
  by_cases hs_lt : s.re < 1 / 2;
  · exact False.elim <| hb1_no_zeros_re_lt_half h hs_lt h_completed;
  · by_cases hs_gt : s.re > 1 / 2;
    · exact False.elim <| hb1_no_zeros_re_gt_half h hs_gt h_completed;
    · lia

/-- RH and HB1 are equivalent. -/
theorem rh_iff_hb1 : RiemannHypothesis ↔ HB1_no_upper_zeros := by
  exact ⟨rh_implies_hb1, hb1_implies_rh⟩

/-- The HB conditions imply Weil positivity (on WeilTestFunction). -/
theorem hb_implies_weil_positivity_WTF :
    HB1_no_upper_zeros → WeilPositivity_WTF := by
  intro h
  exact WeilCriterion_WTF.mpr (hb1_implies_rh h)

-- ============================================================================
-- PART 6: THE LATTICE-ENHANCED HB FUNCTION
-- ============================================================================

/-- Leech lattice theta series coefficients. -/
def leech_theta_coeff : ℕ → ℕ
  | 0 => 1
  | 1 => 0      -- THE SPECTRAL GAP
  | 2 => 196560
  | 3 => 16773120
  | 4 => 398034000
  | _ => 0      -- truncated

lemma leech_spectral_gap : leech_theta_coeff 1 = 0 := rfl
lemma leech_kissing_at_2 : leech_theta_coeff 2 = 196560 := rfl

end