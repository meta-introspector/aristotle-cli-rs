/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Decay of the Fourier–Mellin transform of a `C²` compactly supported test function, and the
resulting *unconditional* form of Corollary 2.3 (i) of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771,

for convolution squares.

`RequestProject/ArchimedeanExplicit.lean` proves Corollary 2.3 (i) in the form
`LfunNorm_re_nonneg_of_fourierSide_nonneg`, but under three analytic side conditions on the
test function `G`:

* `Integrable (fourierLog G)`;
* `Integrable (fun t => ‖fourierLog G t‖ * digammaDiff t)`;
* a Lipschitz bound at the origin, `‖G u - G 0‖ ≤ C |u|`.

Here all three are *proved* for `G = F ⋆ F*` with `F` of class `C²` and compactly
supported, which is exactly the class of test functions the paper works with.  The
mechanism is the classical `1/(1+t²)` decay of the transform of a `C²` compactly supported
function, obtained by transforming the second derivative.
-/
import RequestProject.Imported.OutputFinal.RequestProject.ArchimedeanExplicit
import RequestProject.Imported.OutputFinal.RequestProject.Positivity

noncomputable section

open MeasureTheory Set Real FourierTransform

namespace ConnesConsani.WeilPositivity

/-! ## Elementary bounds on `fourierLog` -/

/-- `fourierLog` written out as an integral. -/
theorem fourierLog_eq_integral (F : ℝ → ℂ) (t : ℝ) :
    fourierLog F t = ∫ u : ℝ, F u * Complex.exp (Complex.I * (t : ℂ) * (u : ℂ)) := rfl

theorem norm_mul_exp_I_mul (F : ℝ → ℂ) (t u : ℝ) :
    ‖F u * Complex.exp (Complex.I * (t : ℂ) * (u : ℂ))‖ = ‖F u‖ := by
  have hz : Complex.I * (t : ℂ) * (u : ℂ) = ((t * u : ℝ) : ℂ) * Complex.I := by
    push_cast; ring
  rw [norm_mul, hz, Complex.norm_exp_ofReal_mul_I, mul_one]

/-- The transform is bounded by the `L¹` norm. -/
theorem norm_fourierLog_le (F : ℝ → ℂ) (t : ℝ) : ‖fourierLog F t‖ ≤ ∫ u : ℝ, ‖F u‖ := by
  have h := norm_integral_le_integral_norm
    (μ := (volume : Measure ℝ)) (fun u : ℝ => F u * Complex.exp (Complex.I * (t : ℂ) * (u : ℂ)))
  simp_rw [norm_mul_exp_I_mul F t] at h
  rw [fourierLog_eq_integral]
  exact h

/-- The transform of an integrable function is continuous. -/
theorem continuous_fourierLog {F : ℝ → ℂ} (hF : Integrable F) : Continuous (fourierLog F) := by
  have hcont : Continuous
      fun t : ℝ => ∫ u : ℝ, F u * Complex.exp (Complex.I * (t : ℂ) * (u : ℂ)) := by
    refine continuous_of_dominated (bound := fun u : ℝ => ‖F u‖) (fun t => ?_) (fun t => ?_)
      hF.norm ?_
    · exact hF.aestronglyMeasurable.mul
        (Complex.continuous_exp.comp (by fun_prop)).aestronglyMeasurable
    · filter_upwards with u using le_of_eq (norm_mul_exp_I_mul F t u)
    · filter_upwards with u
      exact continuous_const.mul (Complex.continuous_exp.comp (by fun_prop))
  exact hcont.congr fun t => (fourierLog_eq_integral F t).symm

/-- Transforming a derivative multiplies the transform by `-i t`. -/
theorem fourierLog_deriv {F : ℝ → ℂ} (hF : Integrable F) (hFd : Differentiable ℝ F)
    (hF' : Integrable (deriv F)) (t : ℝ) :
    fourierLog (deriv F) t = -(Complex.I * t) * fourierLog F t := by
  have h := congrFun (Real.fourier_deriv hF hFd hF') (-t / (2 * π))
  rw [fourierLog_eq_fourier, h, fourierLog_eq_fourier, smul_eq_mul]
  have hpi : (π : ℝ) ≠ 0 := Real.pi_ne_zero
  congr 1
  push_cast
  field_simp

/-! ## Quadratic decay -/

section Decay

variable {F : ℝ → ℂ}

theorem contDiff_deriv_of_two (hF : ContDiff ℝ 2 F) : ContDiff ℝ 1 (deriv F) := by
  have h : ContDiff ℝ ((1 : WithTop ℕ∞) + 1) F := by convert hF using 2
  exact h.deriv'

theorem contDiff_deriv_deriv_of_two (hF : ContDiff ℝ 2 F) : ContDiff ℝ 0 (deriv (deriv F)) := by
  have h : ContDiff ℝ ((0 : WithTop ℕ∞) + 1) (deriv F) := by
    convert contDiff_deriv_of_two hF using 2
  exact h.deriv'

/-- Quadratic decay of the transform of a `C²` compactly supported function. -/
theorem sq_mul_norm_fourierLog_le (hF : ContDiff ℝ 2 F) (hsF : HasCompactSupport F)
    (t : ℝ) : t ^ 2 * ‖fourierLog F t‖ ≤ ∫ u : ℝ, ‖deriv (deriv F) u‖ := by
  have hdF : ContDiff ℝ 1 (deriv F) := contDiff_deriv_of_two hF
  have hddF : ContDiff ℝ 0 (deriv (deriv F)) := contDiff_deriv_deriv_of_two hF
  have hFint : Integrable F := hF.continuous.integrable_of_hasCompactSupport hsF
  have hdFint : Integrable (deriv F) :=
    hdF.continuous.integrable_of_hasCompactSupport hsF.deriv
  have hddFint : Integrable (deriv (deriv F)) :=
    hddF.continuous.integrable_of_hasCompactSupport hsF.deriv.deriv
  have key : fourierLog (deriv (deriv F)) t = -((t : ℂ) ^ 2) * fourierLog F t := by
    rw [fourierLog_deriv hdFint (hdF.differentiable (by norm_num)) hddFint t,
      fourierLog_deriv hFint (hF.differentiable (by norm_num)) hdFint t]
    linear_combination ((t : ℂ) ^ 2 * fourierLog F t) * Complex.I_sq
  have hnorm : t ^ 2 * ‖fourierLog F t‖ = ‖fourierLog (deriv (deriv F)) t‖ := by
    rw [key, norm_mul, norm_neg, norm_pow, Complex.norm_real, Real.norm_eq_abs, sq_abs]
  rw [hnorm]
  exact norm_fourierLog_le _ t

/-- **Decay of the Fourier–Mellin transform**: the transform of a `C²` compactly supported
function is `O(1/(1+t²))`. -/
theorem exists_norm_fourierLog_le_div (hF : ContDiff ℝ 2 F) (hsF : HasCompactSupport F) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ t : ℝ, ‖fourierLog F t‖ ≤ C / (1 + t ^ 2) := by
  refine ⟨(∫ u : ℝ, ‖F u‖) + ∫ u : ℝ, ‖deriv (deriv F) u‖, ?_, fun t => ?_⟩
  · have h1 : (0:ℝ) ≤ ∫ u : ℝ, ‖F u‖ := integral_nonneg fun u => norm_nonneg _
    have h2 : (0:ℝ) ≤ ∫ u : ℝ, ‖deriv (deriv F) u‖ := integral_nonneg fun u => norm_nonneg _
    linarith
  · have hpos : (0:ℝ) < 1 + t ^ 2 := by positivity
    rw [le_div_iff₀ hpos]
    have h1 := norm_fourierLog_le F t
    have h2 := sq_mul_norm_fourierLog_le hF hsF t
    nlinarith [norm_nonneg (fourierLog F t)]

end Decay

/-! ## Integrability of the transform of a convolution square -/

theorem norm_fourierLog_convLog_starLog_self {F : ℝ → ℂ} (hF : Continuous F)
    (hsF : HasCompactSupport F) (t : ℝ) :
    ‖fourierLog (convLog F (starLog F)) t‖ = ‖fourierLog F t‖ ^ 2 := by
  have h : fourierLog (convLog F (starLog F)) t
      = ((‖fourierLog F t‖ : ℝ) : ℂ) ^ 2 := mellinLog_convLog_starLog_self hF hsF t
  rw [h, ← Complex.ofReal_pow, Complex.norm_real, Real.norm_eq_abs,
    abs_of_nonneg (by positivity)]

theorem integrable_fourierLog_convLog_starLog_self {F : ℝ → ℂ} (hF : ContDiff ℝ 2 F)
    (hsF : HasCompactSupport F) : Integrable (fourierLog (convLog F (starLog F))) := by
  obtain ⟨C, hC0, hC⟩ := exists_norm_fourierLog_le_div hF hsF
  have hGc : Continuous (convLog F (starLog F)) :=
    continuous_convLog hF.continuous hsF (continuous_starLog hF.continuous)
  have hGs : HasCompactSupport (convLog F (starLog F)) :=
    hasCompactSupport_convLog hsF (hasCompactSupport_starLog hsF)
  have hGint : Integrable (convLog F (starLog F)) :=
    hGc.integrable_of_hasCompactSupport hGs
  refine Integrable.mono' (integrable_inv_one_add_sq.const_mul (C ^ 2))
    (continuous_fourierLog hGint).aestronglyMeasurable ?_
  filter_upwards with t
  have hpos : (0:ℝ) < 1 + t ^ 2 := by positivity
  have h1 : ‖fourierLog F t‖ ≤ C / (1 + t ^ 2) := hC t
  have h2 : ‖fourierLog (convLog F (starLog F)) t‖ = ‖fourierLog F t‖ ^ 2 :=
    norm_fourierLog_convLog_starLog_self hF.continuous hsF t
  have hsq : ‖fourierLog F t‖ ^ 2 ≤ (C / (1 + t ^ 2)) ^ 2 :=
    pow_le_pow_left₀ (norm_nonneg _) h1 2
  have hle : (C / (1 + t ^ 2)) ^ 2 ≤ C ^ 2 * (1 + t ^ 2)⁻¹ := by
    rw [div_pow, ← one_div, mul_one_div, div_le_div_iff₀ (by positivity) hpos]
    nlinarith [mul_nonneg (sq_nonneg C) (sq_nonneg t),
      mul_nonneg (sq_nonneg C) (sq_nonneg (t ^ 2))]
  rw [h2]
  exact le_trans hsq hle

/-! ## A quadratic bound on the digamma increment -/

theorem summable_one_div_poleA_cube : Summable (fun n : ℕ => 1 / poleA n ^ 3) := by
  have hbase : Summable (fun n : ℕ => 1 / ((n : ℝ) + 1) ^ 3) := by
    have h : Summable (fun n : ℕ => 1 / (n : ℝ) ^ 3) :=
      Real.summable_one_div_nat_pow.mpr (by norm_num)
    have h1 : Summable (fun n : ℕ => 1 / ((n + 1 : ℕ) : ℝ) ^ 3) := (summable_nat_add_iff 1).2 h
    exact h1.congr fun n => by push_cast; ring
  refine Summable.of_nonneg_of_le (fun n => ?_) (fun n => ?_) (hbase.mul_left 64)
  · have := poleA_pos n
    positivity
  · have ha : 0 < poleA n := poleA_pos n
    have hn : (0:ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
    have hge : ((n : ℝ) + 1) / 4 ≤ poleA n := by
      rw [poleA]; linarith
    have h1 : (0:ℝ) < ((n : ℝ) + 1) / 4 := by linarith
    have h2 : (((n : ℝ) + 1) / 4) ^ 3 ≤ poleA n ^ 3 := by
      exact pow_le_pow_left₀ h1.le hge 3
    have h3 : (0:ℝ) < (((n : ℝ) + 1) / 4) ^ 3 := by positivity
    calc 1 / poleA n ^ 3 ≤ 1 / (((n : ℝ) + 1) / 4) ^ 3 := by
          exact one_div_le_one_div_of_le h3 h2
      _ = 64 * (1 / ((n : ℝ) + 1) ^ 3) := by
          rw [div_pow]
          field_simp
          ring
  
theorem exists_digammaDiff_le : ∃ C : ℝ, 0 ≤ C ∧ ∀ t : ℝ, digammaDiff t ≤ C * t ^ 2 := by
  set S : ℝ := ∑' n : ℕ, 1 / poleA n ^ 3 with hS
  have hS0 : 0 ≤ S := by
    rw [hS]
    refine tsum_nonneg fun n => ?_
    have := poleA_pos n
    positivity
  refine ⟨S / 4, by positivity, fun t => ?_⟩
  have hsum := digammaPartialFractions t
  have hmaj : Summable (fun n : ℕ => (t ^ 2 / 4) * (1 / poleA n ^ 3)) :=
    summable_one_div_poleA_cube.mul_left _
  have hle : ∀ n : ℕ, digammaTerm n t ≤ (t ^ 2 / 4) * (1 / poleA n ^ 3) := by
    intro n
    have ha : 0 < poleA n := poleA_pos n
    have h1 : (0:ℝ) < poleA n * ((poleA n) ^ 2 + t ^ 2 / 4) := by positivity
    have h2 : (0:ℝ) < poleA n * (poleA n) ^ 2 := by positivity
    rw [digammaTerm, div_le_iff₀ h1]
    have h3 : poleA n ^ 2 ≤ poleA n ^ 2 + t ^ 2 / 4 := by nlinarith [sq_nonneg t]
    have h4 : (0:ℝ) ≤ t ^ 2 / 4 := by positivity
    rw [show (t ^ 2 / 4) * (1 / poleA n ^ 3) * (poleA n * ((poleA n) ^ 2 + t ^ 2 / 4))
        = (t ^ 2 / 4) * ((poleA n * ((poleA n) ^ 2 + t ^ 2 / 4)) / poleA n ^ 3) by ring]
    have h5 : (1:ℝ) ≤ (poleA n * ((poleA n) ^ 2 + t ^ 2 / 4)) / poleA n ^ 3 := by
      rw [le_div_iff₀ (by positivity)]
      nlinarith
    nlinarith
  calc digammaDiff t = ∑' n : ℕ, digammaTerm n t := hsum.tsum_eq.symm
    _ ≤ ∑' n : ℕ, (t ^ 2 / 4) * (1 / poleA n ^ 3) := hsum.summable.tsum_le_tsum hle hmaj
    _ = (S / 4) * t ^ 2 := by
        rw [tsum_mul_left, hS]; ring

theorem integrable_fourierLog_convLog_starLog_self_mul_digammaDiff {F : ℝ → ℂ}
    (hF : ContDiff ℝ 2 F) (hsF : HasCompactSupport F) :
    Integrable (fun t : ℝ => ‖fourierLog (convLog F (starLog F)) t‖ * digammaDiff t) := by
  obtain ⟨C, hC0, hC⟩ := exists_norm_fourierLog_le_div hF hsF
  obtain ⟨D, hD0, hD⟩ := exists_digammaDiff_le
  have hGc : Continuous (convLog F (starLog F)) :=
    continuous_convLog hF.continuous hsF (continuous_starLog hF.continuous)
  have hGs : HasCompactSupport (convLog F (starLog F)) :=
    hasCompactSupport_convLog hsF (hasCompactSupport_starLog hsF)
  have hGint : Integrable (convLog F (starLog F)) :=
    hGc.integrable_of_hasCompactSupport hGs
  refine Integrable.mono' (integrable_inv_one_add_sq.const_mul (C ^ 2 * D))
    (((continuous_fourierLog hGint).norm.aestronglyMeasurable).mul
      measurable_digammaDiff.aestronglyMeasurable) ?_
  filter_upwards with t
  have hpos : (0:ℝ) < 1 + t ^ 2 := by positivity
  have hdd : 0 ≤ digammaDiff t := digammaDiff_nonneg t
  have h2 : ‖fourierLog (convLog F (starLog F)) t‖ = ‖fourierLog F t‖ ^ 2 :=
    norm_fourierLog_convLog_starLog_self hF.continuous hsF t
  have hsq : ‖fourierLog F t‖ ^ 2 ≤ (C / (1 + t ^ 2)) ^ 2 :=
    pow_le_pow_left₀ (norm_nonneg _) (hC t) 2
  have hstep : ‖fourierLog (convLog F (starLog F)) t‖ * digammaDiff t
      ≤ (C / (1 + t ^ 2)) ^ 2 * (D * t ^ 2) := by
    rw [h2]
    exact mul_le_mul hsq (hD t) hdd (by positivity)
  have hfinal : (C / (1 + t ^ 2)) ^ 2 * (D * t ^ 2) ≤ C ^ 2 * D * (1 + t ^ 2)⁻¹ := by
    rw [div_pow]
    rw [show C ^ 2 / (1 + t ^ 2) ^ 2 * (D * t ^ 2)
        = (C ^ 2 * D) * (t ^ 2 / (1 + t ^ 2) ^ 2) by ring]
    have hkey : t ^ 2 / (1 + t ^ 2) ^ 2 ≤ (1 + t ^ 2)⁻¹ := by
      rw [div_le_iff₀ (by positivity), inv_mul_eq_div, le_div_iff₀ hpos]
      nlinarith [sq_nonneg t]
    have : (0:ℝ) ≤ C ^ 2 * D := by positivity
    exact mul_le_mul_of_nonneg_left hkey this
  have hnn : 0 ≤ ‖fourierLog (convLog F (starLog F)) t‖ * digammaDiff t := by positivity
  rw [Real.norm_eq_abs, abs_of_nonneg hnn]
  linarith

/-! ## The Lipschitz bound at the origin -/

theorem exists_lipschitz_at_zero {G : ℝ → ℂ} (hG : ContDiff ℝ 1 G) (hsG : HasCompactSupport G) :
    ∃ C : ℝ, ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u| := by
  obtain ⟨M, hM⟩ := (hG.continuous_deriv le_rfl).bounded_above_of_compact_support hsG.deriv
  refine ⟨M, fun u => ?_⟩
  have hdiff : ∀ x ∈ (univ : Set ℝ), DifferentiableAt ℝ G x :=
    fun x _ => hG.differentiable (by norm_num) x
  have hbound : ∀ x ∈ (univ : Set ℝ), ‖deriv G x‖ ≤ M := fun x _ => hM x
  have := (convex_univ (𝕜 := ℝ) (E := ℝ)).norm_image_sub_le_of_norm_deriv_le
    hdiff hbound (mem_univ 0) (mem_univ u)
  simpa [Real.norm_eq_abs] using this

/-! ## Corollary 2.3 (i) for convolution squares, unconditionally -/

/-- **Corollary 2.3 (i) of the paper for convolution squares.**  Granted only the
Fourier-side inequality `2θ' + δ̂ ≥ 0`, the functional `L` is nonnegative on every
convolution square `F ⋆ F*` with `F` of class `C²` and compactly supported.  In contrast
with `LfunNorm_re_nonneg_of_fourierSide_nonneg`, no analytic side condition on the transform
is assumed. -/
theorem LfunNorm_re_nonneg_convLog_starLog_self
    (hpos : ∀ t : ℝ, 0 ≤ 2 * thetaDeriv t + deltaFourier t) {F : ℝ → ℂ} (hF : ContDiff ℝ 2 F)
    (hsF : HasCompactSupport F) :
    0 ≤ (LfunNorm (convLog F (starLog F))).re := by
  have hG2 : ContDiff ℝ 2 (convLog F (starLog F)) := contDiff_convLog_starLog_self hF hsF
  have hGc : Continuous (convLog F (starLog F)) := hG2.continuous
  have hGs : HasCompactSupport (convLog F (starLog F)) :=
    hasCompactSupport_convLog hsF (hasCompactSupport_starLog hsF)
  have hG1 : ContDiff ℝ 1 (convLog F (starLog F)) := hG2.of_le (by norm_num)
  obtain ⟨C, hLip⟩ := exists_lipschitz_at_zero hG1 hGs
  exact LfunNorm_re_nonneg_of_fourierSide_nonneg hpos hGc hGs
    (integrable_fourierLog_convLog_starLog_self hF hsF)
    (integrable_fourierLog_convLog_starLog_self_mul_digammaDiff hF hsF) hLip
    (positiveDefiniteLog_convLog_starLog hF.continuous hsF)

end ConnesConsani.WeilPositivity
