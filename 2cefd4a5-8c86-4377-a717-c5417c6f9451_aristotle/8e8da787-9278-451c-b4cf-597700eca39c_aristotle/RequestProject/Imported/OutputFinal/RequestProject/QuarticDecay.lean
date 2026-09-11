/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Quartic decay of the Fourier–Mellin transform of a `C⁴` compactly supported test function,
and the resulting form of Corollary 2.3 (i) of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771,

for *all* `C⁴` positive definite test functions (not only convolution squares).

`RequestProject/ArchimedeanExplicit.lean` proves Corollary 2.3 (i) in the form
`LfunNorm_re_nonneg_of_fourierSide_nonneg`, under three analytic side conditions on the
test function `G`:

* `Integrable (fourierLog G)`;
* `Integrable (fun t => ‖fourierLog G t‖ * digammaDiff t)`;
* a Lipschitz bound at the origin, `‖G u - G 0‖ ≤ C |u|`.

`RequestProject/FourierDecay.lean` discharges them for a convolution square `F ⋆ F*` with
`F` of class `C²`.  Here they are discharged for *every* `C⁴` compactly supported `G`: the
transform of such a `G` is `O(1/(1+t⁴))`, which beats the quadratic growth
`digammaDiff t ≤ C t²` of the digamma increment.  This is the class of test functions for
which the Bochner-type integrability of the transform, the one analytic gap left in the
positivity statement of `RequestProject/FourierSide.lean`, is elementary.
-/
import RequestProject.Imported.OutputFinal.RequestProject.FourierDecay

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

section Quartic

variable {F : ℝ → ℂ}

theorem contDiff_deriv_of_four (hF : ContDiff ℝ 4 F) : ContDiff ℝ 3 (deriv F) := by
  have h : ContDiff ℝ ((3 : WithTop ℕ∞) + 1) F := by convert hF using 2
  exact h.deriv'

theorem contDiff_deriv_of_three (hF : ContDiff ℝ 3 F) : ContDiff ℝ 2 (deriv F) := by
  have h : ContDiff ℝ ((2 : WithTop ℕ∞) + 1) F := by convert hF using 2
  exact h.deriv'

theorem contDiff_deriv_of_one (hF : ContDiff ℝ 1 F) : ContDiff ℝ 0 (deriv F) := by
  have h : ContDiff ℝ ((0 : WithTop ℕ∞) + 1) F := by convert hF using 2
  exact h.deriv'

/-- **Quartic decay of the transform of a `C⁴` compactly supported function.** -/
theorem quartic_mul_norm_fourierLog_le (hF : ContDiff ℝ 4 F) (hsF : HasCompactSupport F)
    (t : ℝ) : t ^ 4 * ‖fourierLog F t‖ ≤ ∫ u : ℝ, ‖deriv (deriv (deriv (deriv F))) u‖ := by
  have h3 : ContDiff ℝ 3 (deriv F) := contDiff_deriv_of_four hF
  have h2 : ContDiff ℝ 2 (deriv (deriv F)) := contDiff_deriv_of_three h3
  have h1 : ContDiff ℝ 1 (deriv (deriv (deriv F))) := contDiff_deriv_of_two h2
  have h0 : ContDiff ℝ 0 (deriv (deriv (deriv (deriv F)))) := contDiff_deriv_of_one h1
  have i0 : Integrable F := hF.continuous.integrable_of_hasCompactSupport hsF
  have i1 : Integrable (deriv F) := h3.continuous.integrable_of_hasCompactSupport hsF.deriv
  have i2 : Integrable (deriv (deriv F)) :=
    h2.continuous.integrable_of_hasCompactSupport hsF.deriv.deriv
  have i3 : Integrable (deriv (deriv (deriv F))) :=
    h1.continuous.integrable_of_hasCompactSupport hsF.deriv.deriv.deriv
  have i4 : Integrable (deriv (deriv (deriv (deriv F)))) :=
    h0.continuous.integrable_of_hasCompactSupport hsF.deriv.deriv.deriv.deriv
  have key : fourierLog (deriv (deriv (deriv (deriv F)))) t = ((t : ℂ) ^ 4) * fourierLog F t := by
    rw [fourierLog_deriv i3 (h1.differentiable (by norm_num)) i4 t,
      fourierLog_deriv i2 (h2.differentiable (by norm_num)) i3 t,
      fourierLog_deriv i1 (h3.differentiable (by norm_num)) i2 t,
      fourierLog_deriv i0 (hF.differentiable (by norm_num)) i1 t]
    linear_combination ((t : ℂ) ^ 4 * fourierLog F t * (Complex.I ^ 2 - 1)) * Complex.I_sq
  have hnorm : t ^ 4 * ‖fourierLog F t‖ = ‖fourierLog (deriv (deriv (deriv (deriv F)))) t‖ := by
    rw [key, norm_mul, norm_pow, Complex.norm_real, Real.norm_eq_abs, ← abs_pow,
      abs_of_nonneg (by positivity : (0:ℝ) ≤ t ^ 4)]
  rw [hnorm]
  exact norm_fourierLog_le _ t

/-- The transform of a `C⁴` compactly supported function is `O(1/(1+t⁴))`. -/
theorem exists_norm_fourierLog_le_div_quartic (hF : ContDiff ℝ 4 F)
    (hsF : HasCompactSupport F) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ t : ℝ, ‖fourierLog F t‖ ≤ C / (1 + t ^ 4) := by
  refine ⟨(∫ u : ℝ, ‖F u‖) + ∫ u : ℝ, ‖deriv (deriv (deriv (deriv F))) u‖, ?_, fun t => ?_⟩
  · have h1 : (0:ℝ) ≤ ∫ u : ℝ, ‖F u‖ := integral_nonneg fun u => norm_nonneg _
    have h2 : (0:ℝ) ≤ ∫ u : ℝ, ‖deriv (deriv (deriv (deriv F))) u‖ :=
      integral_nonneg fun u => norm_nonneg _
    linarith
  · have hpos : (0:ℝ) < 1 + t ^ 4 := by positivity
    rw [le_div_iff₀ hpos]
    have h1 := norm_fourierLog_le F t
    have h2 := quartic_mul_norm_fourierLog_le hF hsF t
    nlinarith [norm_nonneg (fourierLog F t)]

end Quartic

/-! ## Integrability of the transform of a `C⁴` test function -/

theorem inv_one_add_pow_four_le (t : ℝ) : (1 + t ^ 4)⁻¹ ≤ 2 * (1 + t ^ 2)⁻¹ := by
  have h4 : (0:ℝ) < 1 + t ^ 4 := by positivity
  have h2 : (0:ℝ) < 1 + t ^ 2 := by positivity
  rw [show (2:ℝ) * (1 + t ^ 2)⁻¹ = 2 / (1 + t ^ 2) by ring, inv_eq_one_div,
    div_le_div_iff₀ h4 h2]
  nlinarith [sq_nonneg (t ^ 2 - 1), sq_nonneg t]

theorem integrable_inv_one_add_pow_four : Integrable (fun t : ℝ => (1 + t ^ 4)⁻¹) := by
  have hne : ∀ t : ℝ, (1 : ℝ) + t ^ 4 ≠ 0 := fun t => by positivity
  have hcont : Continuous fun t : ℝ => (1 + t ^ 4)⁻¹ :=
    (continuous_const.add (continuous_pow 4)).inv₀ hne
  refine Integrable.mono' (integrable_inv_one_add_sq.const_mul 2)
    hcont.aestronglyMeasurable ?_
  filter_upwards with t
  have hnn : (0:ℝ) ≤ (1 + t ^ 4)⁻¹ := by positivity
  rw [Real.norm_eq_abs, abs_of_nonneg hnn]
  exact inv_one_add_pow_four_le t

theorem sq_div_one_add_pow_four_le (t : ℝ) : t ^ 2 / (1 + t ^ 4) ≤ 2 * (1 + t ^ 2)⁻¹ := by
  have h4 : (0:ℝ) < 1 + t ^ 4 := by positivity
  have h2 : (0:ℝ) < 1 + t ^ 2 := by positivity
  rw [show (2:ℝ) * (1 + t ^ 2)⁻¹ = 2 / (1 + t ^ 2) by ring, div_le_div_iff₀ h4 h2]
  nlinarith [sq_nonneg (t ^ 2 - 1), sq_nonneg t, sq_nonneg (t ^ 2 + 1)]

variable {F : ℝ → ℂ}

theorem integrable_fourierLog_of_contDiff_four (hF : ContDiff ℝ 4 F)
    (hsF : HasCompactSupport F) : Integrable (fourierLog F) := by
  obtain ⟨C, hC0, hC⟩ := exists_norm_fourierLog_le_div_quartic hF hsF
  have hFint : Integrable F := hF.continuous.integrable_of_hasCompactSupport hsF
  refine Integrable.mono' (integrable_inv_one_add_pow_four.const_mul C)
    (continuous_fourierLog hFint).aestronglyMeasurable ?_
  filter_upwards with t
  have hpos : (0:ℝ) < 1 + t ^ 4 := by positivity
  have := hC t
  rw [div_eq_mul_inv] at this
  simpa [mul_comm] using this

theorem integrable_norm_fourierLog_mul_digammaDiff_of_contDiff_four (hF : ContDiff ℝ 4 F)
    (hsF : HasCompactSupport F) :
    Integrable (fun t : ℝ => ‖fourierLog F t‖ * digammaDiff t) := by
  obtain ⟨C, hC0, hC⟩ := exists_norm_fourierLog_le_div_quartic hF hsF
  obtain ⟨D, hD0, hD⟩ := exists_digammaDiff_le
  have hFint : Integrable F := hF.continuous.integrable_of_hasCompactSupport hsF
  refine Integrable.mono' ((integrable_inv_one_add_sq.const_mul (2 * (C * D))))
    (((continuous_fourierLog hFint).norm.aestronglyMeasurable).mul
      measurable_digammaDiff.aestronglyMeasurable) ?_
  filter_upwards with t
  have hpos : (0:ℝ) < 1 + t ^ 4 := by positivity
  have hdd : 0 ≤ digammaDiff t := digammaDiff_nonneg t
  have hstep : ‖fourierLog F t‖ * digammaDiff t ≤ (C / (1 + t ^ 4)) * (D * t ^ 2) :=
    mul_le_mul (hC t) (hD t) hdd (by positivity)
  have hfinal : (C / (1 + t ^ 4)) * (D * t ^ 2) ≤ 2 * (C * D) * (1 + t ^ 2)⁻¹ := by
    have h : (C / (1 + t ^ 4)) * (D * t ^ 2) = (C * D) * (t ^ 2 / (1 + t ^ 4)) := by
      rw [div_eq_mul_inv, div_eq_mul_inv]
      ring
    rw [h, show 2 * (C * D) * (1 + t ^ 2)⁻¹ = (C * D) * (2 * (1 + t ^ 2)⁻¹) by ring]
    exact mul_le_mul_of_nonneg_left (sq_div_one_add_pow_four_le t) (by positivity)
  have hnn : 0 ≤ ‖fourierLog F t‖ * digammaDiff t := by positivity
  rw [Real.norm_eq_abs, abs_of_nonneg hnn]
  linarith

/-! ## Corollary 2.3 (i) for `C⁴` positive definite test functions -/

/-- **Corollary 2.3 (i) of the paper for `C⁴` test functions.**  Granted only the
Fourier-side inequality `2θ' + δ̂ ≥ 0`, the functional `L = D + W_∞` (in the `∆^{1/2}`
normalization of the paper) is nonnegative on *every* positive definite test function of
class `C⁴` with compact support: for such a function all the analytic side conditions of
`LfunNorm_re_nonneg_of_fourierSide_nonneg` are automatic. -/
theorem LfunNorm_re_nonneg_of_contDiff_four_of_fourierSide_nonneg
    (hpos : ∀ t : ℝ, 0 ≤ 2 * thetaDeriv t + deltaFourier t) {G : ℝ → ℂ}
    (hG : ContDiff ℝ 4 G) (hsG : HasCompactSupport G) (hpd : PositiveDefiniteLog G) :
    0 ≤ (LfunNorm G).re := by
  obtain ⟨C, hLip⟩ := exists_lipschitz_at_zero (hG.of_le (by norm_num)) hsG
  exact LfunNorm_re_nonneg_of_fourierSide_nonneg hpos hG.continuous hsG
    (integrable_fourierLog_of_contDiff_four hG hsG)
    (integrable_norm_fourierLog_mul_digammaDiff_of_contDiff_four hG hsG) hLip hpd

end ConnesConsani.WeilPositivity
