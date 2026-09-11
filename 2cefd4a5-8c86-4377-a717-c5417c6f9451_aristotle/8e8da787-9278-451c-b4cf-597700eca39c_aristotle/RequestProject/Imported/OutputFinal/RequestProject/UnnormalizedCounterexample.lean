/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**The unnormalized functional `L = D + W_∞` is not positive.**

`LPositivity` (`RequestProject/Positivity.lean`) asserts

  `0 ≤ Re (D(f) + W_∞(f))`   for every continuous, compactly supported, positive
                              definite test function `f` on `ℝ⋆₊`,

where *both* `D` and `W_∞` are paired with the *same* `f`.  The paper pairs the
archimedean distribution with `∆^{-1/2} f` instead (see the introduction of
arXiv:2006.13771 and `LfunNorm` in `RequestProject/ArchimedeanExplicit.lean`), and in that
normalization the positivity is a theorem of this project
(`LPositivityNorm_holds`, `RequestProject/NormalizedPositivity.lean`).

This file proves that the unnormalized statement is **false** (`not_LPositivity`).  The
mechanism is exact: in the logarithmic coordinate the two pairings of the archimedean
distribution differ by

  `W_ℝ(f) - W_ℝ(∆^{-1/2} f) = ∫₀^∞ F(u) (e^{u/2}-1)²/(e^u - e^{-u}) du`

for an even test function `F` (`WeilR_ofLog_eq_add_deficit`).  The kernel is nonnegative
and tends to `1` at infinity, so for a nonnegative test function supported in `[-w,w]` the
deficit grows linearly in `w`, whereas the two remaining contributions stay bounded: `D` by
`16 Si π + 16` (the decay `δ(e^t) ≤ (4 Si π + 4) e^{-|t|/2}`) and the normalized
archimedean term by `weilConst + 40 C` for a `C`-Lipschitz test function.  The triangular
(Fejér) bump of half width `w` is positive definite, has values in `[0,1]` and is
`1/w`-Lipschitz, so for `w` large enough the unnormalized functional is strictly negative
on it.

Numerically (see `scripts/unnormalized_check.py`) the unnormalized functional already turns
negative on convolution squares of bumps of half width `w ≈ 1`, while the normalized one
stays positive; the value of `w` used here is the (very generous) one that the crude bounds
above can certify.
-/
import RequestProject.Imported.OutputFinal.RequestProject.ArchimedeanExplicit

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

/-! ## The triangular bump and its positive definiteness -/

/-- The triangular bump of half width `w`: `t ↦ max 0 (1 - |t|/w)`. -/
def triReal (w t : ℝ) : ℝ := max 0 (1 - |t| / w)

/-- The triangular bump, complex valued. -/
def triC (w : ℝ) : ℝ → ℂ := fun t => ((triReal w t : ℝ) : ℂ)

theorem triReal_nonneg (w t : ℝ) : 0 ≤ triReal w t := le_max_left _ _

theorem triReal_le_one {w : ℝ} (hw : 0 < w) (t : ℝ) : triReal w t ≤ 1 := by
  have h : 1 - |t| / w ≤ 1 := by
    have : 0 ≤ |t| / w := div_nonneg (abs_nonneg t) hw.le
    linarith
  exact max_le zero_le_one h

theorem triReal_zero (w : ℝ) : triReal w 0 = 1 := by
  simp [triReal]

theorem triReal_even (w t : ℝ) : triReal w (-t) = triReal w t := by
  simp [triReal]

theorem triReal_eq_zero {w t : ℝ} (hw : 0 < w) (h : w ≤ |t|) : triReal w t = 0 := by
  have : 1 - |t| / w ≤ 0 := by
    rw [sub_nonpos, le_div_iff₀ hw]
    linarith
  simp [triReal, max_eq_left this]

theorem triReal_half_le {w t : ℝ} (hw : 0 < w) (h : |t| ≤ w / 2) : 1 / 2 ≤ triReal w t := by
  have h1 : |t| / w ≤ 1 / 2 := by
    rw [div_le_div_iff₀ hw (by norm_num)]
    linarith
  have : (1:ℝ) / 2 ≤ 1 - |t| / w := by linarith
  exact le_trans this (le_max_right _ _)

theorem continuous_triReal (w : ℝ) : Continuous (triReal w) := by
  unfold triReal
  fun_prop

theorem continuous_triC (w : ℝ) : Continuous (triC w) :=
  Complex.continuous_ofReal.comp (continuous_triReal w)

theorem triC_even {w : ℝ} (t : ℝ) : triC w (-t) = triC w t := by
  simp [triC, triReal_even]

theorem triC_zero (w : ℝ) : triC w 0 = 1 := by
  simp [triC, triReal_zero]

theorem hasCompactSupport_triC {w : ℝ} (hw : 0 < w) : HasCompactSupport (triC w) := by
  apply HasCompactSupport.intro (isCompact_Icc (a := -w) (b := w))
  intro t ht
  have h : w ≤ |t| := by
    rcases abs_cases t with ⟨h1, h2⟩ | ⟨h1, h2⟩
    · rw [h1]
      by_contra hc
      exact ht ⟨by linarith, by linarith⟩
    · rw [h1]
      by_contra hc
      exact ht ⟨by linarith, by linarith⟩
  simp [triC, triReal_eq_zero hw h]

theorem triC_lipschitz {w : ℝ} (hw : 0 < w) (u : ℝ) :
    ‖triC w u - triC w 0‖ ≤ (1 / w) * |u| := by
  have hle : triReal w u ≤ 1 := triReal_le_one hw u
  have hge : 1 - |u| / w ≤ triReal w u := le_max_right _ _
  have h : |triReal w u - triReal w 0| ≤ (1 / w) * |u| := by
    rw [triReal_zero, abs_le]
    constructor
    · have hrw : |u| / w = (1 / w) * |u| := by ring
      linarith [hrw ▸ hge]
    · linarith [mul_nonneg (by positivity : (0:ℝ) ≤ 1 / w) (abs_nonneg u)]
  simpa [triC, ← Complex.ofReal_sub, Complex.norm_real, Real.norm_eq_abs] using h

/-- The elementary integral `∫₀^w (1 - t/w) cos(x t) dt = (1 - cos(w x))/(w x²)`. -/
theorem integral_triReal_mul_cos_eq {w x : ℝ} (hw : 0 < w) (hx : x ≠ 0) :
    (∫ t in (0:ℝ)..w, (1 - t / w) * Real.cos (x * t)) = (1 - Real.cos (w * x)) / (w * x ^ 2) := by
  set P : ℝ → ℝ := fun t => (1 - t / w) * (Real.sin (x * t) / x) - Real.cos (x * t) / (w * x ^ 2)
    with hP
  have hderiv : ∀ t ∈ Set.uIcc (0:ℝ) w, HasDerivAt P ((1 - t / w) * Real.cos (x * t)) t := by
    intro t _
    have h1 : HasDerivAt (fun t : ℝ => 1 - t / w) (-(1 / w)) t := by
      simpa using ((hasDerivAt_id t).div_const w).const_sub 1
    have h2 : HasDerivAt (fun t : ℝ => Real.sin (x * t) / x) (Real.cos (x * t)) t := by
      have := ((Real.hasDerivAt_sin (x * t)).comp t ((hasDerivAt_id t).const_mul x))
      simpa [mul_comm, mul_div_assoc, hx] using this.div_const x
    have h3 : HasDerivAt (fun t : ℝ => Real.cos (x * t) / (w * x ^ 2))
        (-(Real.sin (x * t)) * x / (w * x ^ 2)) t := by
      have := ((Real.hasDerivAt_cos (x * t)).comp t ((hasDerivAt_id t).const_mul x))
      simpa [mul_comm] using this.div_const (w * x ^ 2)
    have := (h1.mul h2).sub h3
    convert this using 1
    field_simp
    ring
  have hint : IntervalIntegrable (fun t : ℝ => (1 - t / w) * Real.cos (x * t)) volume 0 w := by
    apply Continuous.intervalIntegrable
    fun_prop
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hint]
  simp only [hP]
  field_simp
  simp only [Real.sin_zero, Real.cos_zero, mul_zero]
  ring

/-- **The Fourier transform of the triangular bump is the Fejér kernel**, hence
nonnegative. -/
theorem integral_triReal_mul_cos_nonneg {w : ℝ} (hw : 0 < w) (x : ℝ) :
    0 ≤ ∫ t : ℝ, triReal w t * Real.cos (x * t) := by
  rcases eq_or_ne x 0 with rfl | hx
  · exact integral_nonneg (fun t => by simpa using triReal_nonneg w t)
  set f : ℝ → ℝ := fun t => triReal w t * Real.cos (x * t) with hf
  have heven : ∀ t : ℝ, f (-t) = f t := by
    intro t
    simp only [hf, triReal_even, mul_neg, Real.cos_neg]
  have hzero : ∀ t ∉ Set.Ioc (-w) w, f t = 0 := by
    intro t ht
    have hge : w ≤ |t| := by
      by_contra hc
      push_neg at hc
      exact ht ⟨by cases abs_lt.1 hc with | intro h1 h2 => linarith, (le_abs_self t).trans hc.le⟩
    simp [hf, triReal_eq_zero hw hge]
  have hcont : Continuous f :=
    (continuous_triReal w).mul (Real.continuous_cos.comp (continuous_const.mul continuous_id))
  have h1 : (∫ t : ℝ, f t) = ∫ t in (-w)..w, f t := by
    rw [intervalIntegral.integral_of_le (by linarith)]
    exact (setIntegral_eq_integral_of_forall_compl_eq_zero hzero).symm
  have hsplit : (∫ t in (-w)..w, f t) = (∫ t in (-w)..(0:ℝ), f t) + ∫ t in (0:ℝ)..w, f t :=
    (intervalIntegral.integral_add_adjacent_intervals
      (hcont.intervalIntegrable _ _) (hcont.intervalIntegrable _ _)).symm
  have hneg : (∫ t in (-w)..(0:ℝ), f t) = ∫ t in (0:ℝ)..w, f t := by
    have h := intervalIntegral.integral_comp_neg (a := (0:ℝ)) (b := w) f
    simp only [neg_zero] at h
    rw [← h]
    simp only [heven]
  have hcongr : (∫ t in (0:ℝ)..w, f t) = ∫ t in (0:ℝ)..w, (1 - t / w) * Real.cos (x * t) := by
    refine intervalIntegral.integral_congr (fun t ht => ?_)
    rw [Set.uIcc_of_le (by linarith : (0:ℝ) ≤ w)] at ht
    have habs : |t| = t := abs_of_nonneg ht.1
    have hle : 0 ≤ 1 - t / w := by
      rw [sub_nonneg, div_le_one hw]; exact ht.2
    simp [hf, triReal, habs, max_eq_right hle]
  rw [h1, hsplit, hneg, hcongr, integral_triReal_mul_cos_eq hw hx]
  have hc : Real.cos (w * x) ≤ 1 := Real.cos_le_one _
  have hq : 0 ≤ (1 - Real.cos (w * x)) / (w * x ^ 2) := by
    apply div_nonneg (by linarith)
    have : 0 < x ^ 2 := by positivity
    positivity
  linarith

/-- **The triangular bump is a positive definite test function** on `ℝ⋆₊` in the
logarithmic coordinate. -/
theorem positiveDefiniteLog_triC {w : ℝ} (hw : 0 < w) : PositiveDefiniteLog (triC w) := by
  intro x
  have hint : Integrable (fun t : ℝ => triC w t * Complex.exp (Complex.I * (x:ℂ) * (t:ℂ))) := by
    have hc : Continuous (fun t : ℝ => triC w t * Complex.exp (Complex.I * (x:ℂ) * (t:ℂ))) :=
      (continuous_triC w).mul (Complex.continuous_exp.comp (by fun_prop))
    exact hc.integrable_of_hasCompactSupport (hasCompactSupport_triC hw).mul_right
  have hre : ∀ t : ℝ, (triC w t * Complex.exp (Complex.I * (x:ℂ) * (t:ℂ))).re
      = triReal w t * Real.cos (x * t) := by
    intro t
    have harg : Complex.I * (x:ℂ) * (t:ℂ) = ((x * t : ℝ) : ℂ) * Complex.I := by
      push_cast; ring
    rw [triC, harg, Complex.re_ofReal_mul, Complex.exp_ofReal_mul_I_re]
  rw [mellinLog]
  have hcomm : (∫ t : ℝ, (triC w t * Complex.exp (Complex.I * (x:ℂ) * (t:ℂ))).re)
      = (∫ t : ℝ, triC w t * Complex.exp (Complex.I * (x:ℂ) * (t:ℂ))).re := by
    simpa using Complex.reCLM.integral_comp_comm hint
  rw [← hcomm, integral_congr_ae (Filter.Eventually.of_forall hre)]
  exact integral_triReal_mul_cos_nonneg hw x

/-! ## `W_ℝ` in the unnormalized pairing -/

/-- **The distribution (150) in the logarithmic coordinate**, in the *unnormalized*
pairing, i.e. applied to `f = G ∘ log` itself:

  `W_ℝ(f) = (log 4π + γ) G(0) + ∫₀^∞ (e^u G(u) + G(-u) - 2G(0)) du/(e^u - e^{-u})`.

Compare `WeilR_deltaHalfInv_ofLog`, where the factor `e^u` and the `1` are both replaced
by `e^{u/2}`. -/
theorem WeilR_ofLog {G : ℝ → ℂ} :
    WeilR (ofLog G)
      = ((Real.log (4 * π) + Real.eulerMascheroniConstant : ℝ) : ℂ) * G 0
        + ∫ u in Ioi (0:ℝ),
            (((Real.exp u : ℝ) : ℂ) * G u + G (-u) - 2 * G 0)
              / ((Real.exp u - Real.exp (-u) : ℝ) : ℂ) := by
  have hone : ofLog G 1 = G 0 := by simp [ofLog]
  set f : ℝ → ℂ := ofLog G with hf
  set g : ℝ → ℂ := fun x => (f x + sharp f x - 2 * f 1 / (x : ℂ)) / ((x : ℂ) - (x : ℂ)⁻¹)
    with hgdef
  have himg : Real.exp '' (Ioi 0) = Ioi 1 := by
    ext y
    constructor
    · rintro ⟨u, hu, rfl⟩
      exact one_lt_exp_iff.mpr hu
    · intro hy
      exact ⟨Real.log y, Real.log_pos hy, Real.exp_log (by linarith [hy.out])⟩
  have hderiv : ∀ u ∈ Ioi (0:ℝ), HasDerivWithinAt Real.exp (Real.exp u) (Ioi 0) u :=
    fun u _ => (Real.hasDerivAt_exp u).hasDerivWithinAt
  have hinj : Set.InjOn Real.exp (Ioi 0) := Real.exp_injective.injOn
  have hcov := MeasureTheory.integral_image_eq_integral_abs_deriv_smul measurableSet_Ioi
    hderiv hinj g
  have key : (∫ x in Ioi (1:ℝ), g x)
      = ∫ u in Ioi (0:ℝ), (((Real.exp u : ℝ) : ℂ) * G u + G (-u) - 2 * G 0)
          / ((Real.exp u - Real.exp (-u) : ℝ) : ℂ) := by
    rw [← himg, hcov]
    refine setIntegral_congr_fun measurableSet_Ioi (fun u hu => ?_)
    have hu' : (0:ℝ) < u := hu
    have hE0 : (0:ℝ) < Real.exp u := Real.exp_pos u
    have hEc : ((Real.exp u : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hE0.ne'
    have h1 : f (Real.exp u) = G u := by simp [hf]
    have h2 : sharp f (Real.exp u) = ((Real.exp u : ℝ) : ℂ)⁻¹ * G (-u) := by
      simp only [sharp, hf, ofLog]
      rw [if_pos (by positivity : (0:ℝ) < (Real.exp u)⁻¹), Real.log_inv, Real.log_exp]
    have hnegc : ((Real.exp (-u) : ℝ) : ℂ) = ((Real.exp u : ℝ) : ℂ)⁻¹ := by
      rw [Real.exp_neg]; push_cast; ring
    have hden : ((Real.exp u - Real.exp (-u) : ℝ) : ℂ)
        = ((Real.exp u : ℝ) : ℂ) - ((Real.exp u : ℝ) : ℂ)⁻¹ := by
      rw [Complex.ofReal_sub, hnegc]
    have hdenne : ((Real.exp u : ℝ) : ℂ) - ((Real.exp u : ℝ) : ℂ)⁻¹ ≠ 0 := by
      have h1' : (1:ℝ) < Real.exp u := one_lt_exp_iff.mpr hu'
      have hlt : (Real.exp u)⁻¹ < Real.exp u := by
        rw [inv_lt_iff_one_lt_mul₀ hE0]
        nlinarith
      have hne : ((Real.exp u - (Real.exp u)⁻¹ : ℝ) : ℂ) ≠ 0 := by
        have : (0:ℝ) < Real.exp u - (Real.exp u)⁻¹ := by linarith
        exact_mod_cast this.ne'
      simpa [Complex.ofReal_sub, Complex.ofReal_inv] using hne
    simp only [hgdef, hone, h1, h2]
    rw [Complex.real_smul, abs_of_pos hE0, hden]
    field_simp
  rw [WeilR, key, hone]

/-! ## The deficit kernel -/

/-- The kernel `(e^{u/2} - 1)²/(e^u - e^{-u})` by which the unnormalized pairing exceeds
the normalized one. -/
def deficitKernel (u : ℝ) : ℝ := (Real.exp (u / 2) - 1) ^ 2 / (Real.exp u - Real.exp (-u))

theorem deficitKernel_nonneg {u : ℝ} (hu : 0 < u) : 0 ≤ deficitKernel u := by
  have hD : 0 < Real.exp u - Real.exp (-u) := by
    have : Real.exp (-u) < Real.exp u := Real.exp_lt_exp.2 (by linarith)
    linarith
  exact div_nonneg (sq_nonneg _) hD.le

theorem deficitKernel_le_one {u : ℝ} (hu : 0 < u) : deficitKernel u ≤ 1 := by
  have ha0 : 0 < Real.exp (u / 2) := Real.exp_pos _
  set a := Real.exp (u / 2) with ha
  have ha2 : a ^ 2 = Real.exp u := by rw [ha, sq, ← Real.exp_add]; ring_nf
  have ha1 : 1 < a := by rw [ha]; exact one_lt_exp_iff.mpr (by linarith)
  have hinv : Real.exp (-u) = (a ^ 2)⁻¹ := by rw [Real.exp_neg, ha2]
  have hD : 0 < Real.exp u - Real.exp (-u) := by
    rw [← ha2, hinv]
    have h1 : (a ^ 2)⁻¹ < 1 := by rw [inv_lt_one_iff₀]; right; nlinarith
    nlinarith
  rw [deficitKernel, div_le_one hD, ← ha2, hinv]
  have h1 : (a ^ 2)⁻¹ * a ^ 2 = 1 := by field_simp
  nlinarith [sq_nonneg (a - 1), mul_pos ha0 ha0]

/-- On `[1,∞)` the deficit kernel is bounded below by `1/8`. -/
theorem deficitKernel_ge {u : ℝ} (hu : 1 ≤ u) : 1 / 8 ≤ deficitKernel u := by
  have ha0 : 0 < Real.exp (u / 2) := Real.exp_pos _
  set a := Real.exp (u / 2) with ha
  have ha2 : a ^ 2 = Real.exp u := by rw [ha, sq, ← Real.exp_add]; ring_nf
  have hexpu : Real.exp 1 ≤ Real.exp u := Real.exp_le_exp.2 hu
  have he : (2.7 : ℝ) < Real.exp 1 := by
    have := Real.exp_one_gt_d9
    linarith
  have ha16 : (1.6 : ℝ) < a := by nlinarith
  have hinv : Real.exp (-u) = (a ^ 2)⁻¹ := by rw [Real.exp_neg, ha2]
  have hD : 0 < Real.exp u - Real.exp (-u) := by
    rw [← ha2, hinv]
    have h1 : (a ^ 2)⁻¹ < 1 := by
      rw [inv_lt_one_iff₀]; right; nlinarith
    nlinarith
  rw [deficitKernel, le_div_iff₀ hD, ← ha2, hinv]
  have h1 : (a ^ 2)⁻¹ * a ^ 2 = 1 := by field_simp
  nlinarith [sq_nonneg (a - 1), sq_nonneg a, mul_pos ha0 ha0, sq_nonneg (a * a - 1)]

theorem measurable_deficitKernel : Measurable deficitKernel := by
  unfold deficitKernel
  fun_prop

/-- The pairing of a compactly supported continuous function with the deficit kernel is
integrable on `(0,∞)`. -/
theorem integrableOn_mul_deficitKernel {G : ℝ → ℂ} (hGc : Continuous G)
    (hGs : HasCompactSupport G) :
    IntegrableOn (fun u : ℝ => G u * ((deficitKernel u : ℝ) : ℂ)) (Ioi (0:ℝ)) := by
  have hGint : Integrable G := hGc.integrable_of_hasCompactSupport hGs
  refine Integrable.mono' (hGint.norm.restrict) ?_ ?_
  · exact (hGc.aestronglyMeasurable.mul
      (Complex.continuous_ofReal.measurable.comp measurable_deficitKernel).aestronglyMeasurable)
  · refine (ae_restrict_iff' measurableSet_Ioi).2 (Filter.Eventually.of_forall fun u hu => ?_)
    have hu' : (0:ℝ) < u := hu
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs,
      abs_of_nonneg (deficitKernel_nonneg hu')]
    calc ‖G u‖ * deficitKernel u ≤ ‖G u‖ * 1 :=
          mul_le_mul_of_nonneg_left (deficitKernel_le_one hu') (norm_nonneg _)
      _ = ‖G u‖ := mul_one _

/-- The integrand of the normalized archimedean term is integrable on `(0,∞)`. -/
theorem integrableOn_weilNormIntegrand {G : ℝ → ℂ} (hGc : Continuous G) {C : ℝ}
    (hLip : ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u|) :
    IntegrableOn (fun u : ℝ => (((Real.exp (u / 2) : ℝ) : ℂ) * (G u + G (-u)) - 2 * G 0)
      / ((Real.exp u - Real.exp (-u) : ℝ) : ℂ)) (Ioi (0:ℝ)) := by
  have hAint : IntegrableOn (fun u : ℝ => (2 * G 0 - G u - G (-u))
      * ((Real.exp (u / 2) / (Real.exp u - Real.exp (-u)) : ℝ) : ℂ)) (Ioi (0:ℝ)) := by
    have hint : Integrable (fun u : ℝ => (G 0 - G u) * ((sinhKernel u : ℝ) : ℂ)) :=
      integrable_sub_mul_sinhKernel hGc hLip
    refine IntegrableOn.congr_fun ((hint.comp_neg).integrableOn.add hint.integrableOn)
      ?_ measurableSet_Ioi
    intro u hu
    have hu' : (0:ℝ) < u := hu
    have habs : |u| = u := abs_of_pos hu'
    have hk : sinhKernel u = Real.exp (u / 2) / (Real.exp u - Real.exp (-u)) := by
      rw [sinhKernel, habs]
    have hkneg : sinhKernel (-u) = sinhKernel u := sinhKernel_even u
    simp only [Pi.add_apply, hkneg, hk]
    ring
  have hBint : IntegrableOn (fun u : ℝ =>
      (((Real.exp (u / 2) - 1) / (Real.exp u - Real.exp (-u)) : ℝ) : ℂ)) (Ioi (0:ℝ)) :=
    integrableOn_sinhKernelConst.ofReal
  refine IntegrableOn.congr_fun ((hBint.const_mul (2 * G 0)).sub hAint) ?_ measurableSet_Ioi
  intro u hu
  have hu' : (0:ℝ) < u := hu
  have hDpos : (0:ℝ) < Real.exp u - Real.exp (-u) := by
    have : Real.exp (-u) < Real.exp u := Real.exp_lt_exp.2 (by linarith)
    linarith
  have hDne : ((Real.exp u - Real.exp (-u) : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hDpos.ne'
  show 2 * G 0 * _ - _ = _
  push_cast
  field_simp
  ring

/-- **The exact discrepancy between the two pairings.**  For an even test function the
unnormalized `W_ℝ` exceeds the normalized one by the deficit integral, which is
nonnegative whenever the test function is. -/
theorem WeilR_ofLog_eq_add_deficit {G : ℝ → ℂ} (hGc : Continuous G)
    (hGs : HasCompactSupport G) (heven : ∀ t : ℝ, G (-t) = G t) {C : ℝ}
    (hLip : ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u|) :
    WeilR (ofLog G)
      = WeilR (deltaHalfInv (ofLog G))
        + ∫ u in Ioi (0:ℝ), G u * ((deficitKernel u : ℝ) : ℂ) := by
  have hDef := integrableOn_mul_deficitKernel hGc hGs
  have hB := integrableOn_weilNormIntegrand hGc hLip
  have hsum : (∫ u in Ioi (0:ℝ), (((Real.exp u : ℝ) : ℂ) * G u + G (-u) - 2 * G 0)
        / ((Real.exp u - Real.exp (-u) : ℝ) : ℂ))
      = (∫ u in Ioi (0:ℝ), (((Real.exp (u / 2) : ℝ) : ℂ) * (G u + G (-u)) - 2 * G 0)
          / ((Real.exp u - Real.exp (-u) : ℝ) : ℂ))
        + ∫ u in Ioi (0:ℝ), G u * ((deficitKernel u : ℝ) : ℂ) := by
    rw [← integral_add hB hDef]
    refine setIntegral_congr_fun measurableSet_Ioi (fun u hu => ?_)
    have hu' : (0:ℝ) < u := hu
    have hDpos : (0:ℝ) < Real.exp u - Real.exp (-u) := by
      have : Real.exp (-u) < Real.exp u := Real.exp_lt_exp.2 (by linarith)
      linarith
    have hDne : ((Real.exp u - Real.exp (-u) : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hDpos.ne'
    have hhalf : ((Real.exp (u / 2) : ℝ) : ℂ) * ((Real.exp (u / 2) : ℝ) : ℂ)
        = ((Real.exp u : ℝ) : ℂ) := by
      rw [← Complex.ofReal_mul, ← Real.exp_add]; norm_num
    have hnum : ((Real.exp u : ℝ) : ℂ) * G u + G (-u) - 2 * G 0
        = (((Real.exp (u / 2) : ℝ) : ℂ) * (G u + G (-u)) - 2 * G 0)
          + G u * (((Real.exp (u / 2) : ℝ) : ℂ) - 1) ^ 2 := by
      rw [heven u, ← hhalf]; ring
    have hdefc : ((deficitKernel u : ℝ) : ℂ)
        = ((((Real.exp (u / 2) : ℝ) : ℂ) - 1) ^ 2) / ((Real.exp u - Real.exp (-u) : ℝ) : ℂ) := by
      rw [deficitKernel]; push_cast; ring
    show _ = _ + _
    rw [hnum, hdefc, add_div, mul_div_assoc]
  rw [WeilR_ofLog, WeilR_deltaHalfInv_ofLog, hsum]
  ring

/-! ## The value of the normalized `W_ℝ` -/

/-- The constant `log 4π + γ + log 2 + π/2` of the archimedean explicit formula. -/
def weilConst : ℝ := Real.log (4 * π) + Real.eulerMascheroniConstant + Real.log 2 + π / 2

/-- **The normalized `W_ℝ` in closed form**: `W_ℝ(∆^{-1/2} f) = c₀ G(0) - S(G)` with
`S(G) = ∫ (G(0) - G(u)) κ(u) du` the pairing with the kernel `κ` of the explicit formula.
This is the computation inside `Winfty_deltaHalfInv_ofLog`, isolated. -/
theorem WeilR_deltaHalfInv_ofLog_value {G : ℝ → ℂ} (hGc : Continuous G) {C : ℝ}
    (hLip : ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u|) :
    WeilR (deltaHalfInv (ofLog G))
      = ((weilConst : ℝ) : ℂ) * G 0 - ∫ u : ℝ, (G 0 - G u) * ((sinhKernel u : ℝ) : ℂ) := by
  set S : ℂ := ∫ u : ℝ, (G 0 - G u) * ((sinhKernel u : ℝ) : ℂ) with hS
  have hAint : IntegrableOn (fun u : ℝ => (2 * G 0 - G u - G (-u))
      * ((Real.exp (u / 2) / (Real.exp u - Real.exp (-u)) : ℝ) : ℂ)) (Ioi (0:ℝ)) := by
    have hint : Integrable (fun u : ℝ => (G 0 - G u) * ((sinhKernel u : ℝ) : ℂ)) :=
      integrable_sub_mul_sinhKernel hGc hLip
    refine IntegrableOn.congr_fun ((hint.comp_neg).integrableOn.add hint.integrableOn)
      ?_ measurableSet_Ioi
    intro u hu
    have hu' : (0:ℝ) < u := hu
    have habs : |u| = u := abs_of_pos hu'
    have hk : sinhKernel u = Real.exp (u / 2) / (Real.exp u - Real.exp (-u)) := by
      rw [sinhKernel, habs]
    have hkneg : sinhKernel (-u) = sinhKernel u := sinhKernel_even u
    simp only [Pi.add_apply, hkneg, hk]
    ring
  have hBint : IntegrableOn (fun u : ℝ =>
      (((Real.exp (u / 2) - 1) / (Real.exp u - Real.exp (-u)) : ℝ) : ℂ)) (Ioi (0:ℝ)) :=
    integrableOn_sinhKernelConst.ofReal
  have hBval : (∫ u in Ioi (0:ℝ),
      (((Real.exp (u / 2) - 1) / (Real.exp u - Real.exp (-u)) : ℝ) : ℂ))
      = ((Real.log 2 / 2 + π / 4 : ℝ) : ℂ) := by
    have h := Complex.ofRealCLM.integral_comp_comm integrableOn_sinhKernelConst
    simp only [Complex.ofRealCLM_apply] at h
    rw [h, integral_sinhKernel_const]
  have hI : (∫ u in Ioi (0:ℝ),
        (((Real.exp (u / 2) : ℝ) : ℂ) * (G u + G (-u)) - 2 * G 0)
          / ((Real.exp u - Real.exp (-u) : ℝ) : ℂ))
      = 2 * G 0 * ((Real.log 2 / 2 + π / 4 : ℝ) : ℂ) - S := by
    have hcomb : (∫ u in Ioi (0:ℝ),
        (((Real.exp (u / 2) : ℝ) : ℂ) * (G u + G (-u)) - 2 * G 0)
          / ((Real.exp u - Real.exp (-u) : ℝ) : ℂ))
        = (∫ u in Ioi (0:ℝ), 2 * G 0 *
            (((Real.exp (u / 2) - 1) / (Real.exp u - Real.exp (-u)) : ℝ) : ℂ))
          - ∫ u in Ioi (0:ℝ), (2 * G 0 - G u - G (-u))
              * ((Real.exp (u / 2) / (Real.exp u - Real.exp (-u)) : ℝ) : ℂ) := by
      rw [← integral_sub (hBint.const_mul _) hAint]
      refine setIntegral_congr_fun measurableSet_Ioi (fun u hu => ?_)
      have hu' : (0:ℝ) < u := hu
      have hDpos : (0:ℝ) < Real.exp u - Real.exp (-u) := by
        have : Real.exp (-u) < Real.exp u := Real.exp_lt_exp.2 (by linarith)
        linarith
      have hDne : ((Real.exp u - Real.exp (-u) : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hDpos.ne'
      push_cast
      field_simp
      ring
    rw [hcomb, integral_const_mul, hBval, hS, integral_sub_mul_sinhKernel_Ioi hGc hLip]
  rw [WeilR_deltaHalfInv_ofLog, hI, weilConst]
  push_cast
  ring

theorem integral_expNegAbs_real' {b : ℝ} (hb : 0 < b) :
    (∫ u : ℝ, Real.exp (-b * |u|)) = 2 / b := by
  have h := integral_expNegAbs hb
  have h2 : ((∫ u : ℝ, Real.exp (-b * |u|) : ℝ) : ℂ) = ((2 / b : ℝ) : ℂ) := by
    rw [← h]
    exact (Complex.ofRealCLM.integral_comp_comm (integrable_expNegAbs_real hb)).symm
  exact_mod_cast h2

/-- The `κ`-pairing is bounded by `40 C` for a `C`-Lipschitz test function. -/
theorem norm_integral_sub_mul_sinhKernel_le {G : ℝ → ℂ} (hGc : Continuous G) {C : ℝ}
    (hLip : ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u|) :
    ‖∫ u : ℝ, (G 0 - G u) * ((sinhKernel u : ℝ) : ℂ)‖ ≤ 40 * C := by
  have hC : 0 ≤ C := by
    have h := hLip 1
    have h0 : (0:ℝ) ≤ ‖G 1 - G 0‖ := norm_nonneg _
    simpa using le_trans h0 (by simpa using h)
  have h1 : ‖∫ u : ℝ, (G 0 - G u) * ((sinhKernel u : ℝ) : ℂ)‖
      ≤ ∫ u : ℝ, ‖(G 0 - G u) * ((sinhKernel u : ℝ) : ℂ)‖ :=
    norm_integral_le_integral_norm _
  have hnormeq : ∀ u : ℝ, ‖(G 0 - G u) * ((sinhKernel u : ℝ) : ℂ)‖
      = ‖G 0 - G u‖ * sinhKernel u := by
    intro u
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (sinhKernel_nonneg u)]
  have h2 : (∫ u : ℝ, ‖(G 0 - G u) * ((sinhKernel u : ℝ) : ℂ)‖)
      = ∫ u : ℝ, ‖G 0 - G u‖ * sinhKernel u :=
    integral_congr_ae (Filter.Eventually.of_forall hnormeq)
  have h3 : (∫ u : ℝ, ‖G 0 - G u‖ * sinhKernel u)
      ≤ ∫ u : ℝ, (5 * C) * Real.exp (-(1/4 : ℝ) * |u|) := by
    refine integral_mono (integrable_norm_sub_mul_sinhKernel hGc hLip)
      ((integrable_expNegAbs_real (by norm_num)).const_mul _) (fun u => ?_)
    have hk : 0 ≤ sinhKernel u := sinhKernel_nonneg u
    have hlip : ‖G 0 - G u‖ ≤ C * |u| := by
      rw [← norm_neg]; simpa using hLip u
    have := abs_mul_sinhKernel_le u
    nlinarith [mul_le_mul_of_nonneg_right hlip hk]
  have h4 : (∫ u : ℝ, (5 * C) * Real.exp (-(1/4 : ℝ) * |u|)) = 40 * C := by
    rw [integral_const_mul, integral_expNegAbs_real' (by norm_num : (0:ℝ) < 1/4)]
    ring
  linarith [h1, h2 ▸ h1, h3, h4]

/-! ## The bound on `D` -/

theorem integral_delta_log_le : (∫ t : ℝ, delta (Rplus.expHomeo t)) ≤ 16 * Si π + 16 := by
  have hb : (0:ℝ) < 1/2 := by norm_num
  have hmaj : Integrable (fun t : ℝ => (4 * Si π + 4) * Real.exp (-(1/2 : ℝ) * |t|)) :=
    (integrable_expNegAbs_real hb).const_mul _
  have hle : (∫ t : ℝ, delta (Rplus.expHomeo t))
      ≤ ∫ t : ℝ, (4 * Si π + 4) * Real.exp (-(1/2 : ℝ) * |t|) := by
    refine integral_mono integrable_delta_log hmaj (fun t => ?_)
    have h := delta_expHomeo_le t
    have hrw : -(|t| / 2) = -(1/2 : ℝ) * |t| := by ring
    rwa [hrw] at h
  have hval : (∫ t : ℝ, (4 * Si π + 4) * Real.exp (-(1/2 : ℝ) * |t|)) = 16 * Si π + 16 := by
    rw [integral_const_mul, integral_expNegAbs_real' hb]
    ring
  linarith [hval ▸ hle]

/-- `D` is bounded by `16 Si π + 16` on test functions with values in `[0,1]`. -/
theorem Dcomplex_ofLog_re_le {g : ℝ → ℝ} (hgc : Continuous g) (h0 : ∀ t, 0 ≤ g t)
    (h1 : ∀ t, g t ≤ 1) :
    (Dcomplex (ofLog (fun t => ((g t : ℝ) : ℂ)))).re ≤ 16 * Si π + 16 := by
  have hprod : Integrable (fun t : ℝ => g t * delta (Rplus.expHomeo t)) := by
    refine Integrable.mono' integrable_delta_log
      (hgc.aestronglyMeasurable.mul
        ((delta_continuous.comp Rplus.expHomeo.continuous)).aestronglyMeasurable)
      (Filter.Eventually.of_forall fun t => ?_)
    have hd : 0 < delta (Rplus.expHomeo t) := delta_pos _
    rw [Real.norm_eq_abs, abs_of_nonneg (mul_nonneg (h0 t) hd.le)]
    nlinarith [h1 t]
  have hre : (Dcomplex (ofLog (fun t => ((g t : ℝ) : ℂ)))).re
      = ∫ t : ℝ, g t * delta (Rplus.expHomeo t) := by
    rw [Dcomplex_ofLog]
    have hint : Integrable (fun t : ℝ => ((g t : ℝ) : ℂ) * ((delta (Rplus.expHomeo t) : ℝ) : ℂ)) :=
      hprod.ofReal.congr (Filter.Eventually.of_forall fun t => by push_cast; rfl)
    have hcomm := Complex.reCLM.integral_comp_comm hint
    simp only [Complex.reCLM_apply] at hcomm
    rw [← hcomm]
    refine integral_congr_ae (Filter.Eventually.of_forall fun t => ?_)
    simp [← Complex.ofReal_mul]
  rw [hre]
  refine le_trans (integral_mono hprod integrable_delta_log (fun t => ?_)) integral_delta_log_le
  have hd : 0 < delta (Rplus.expHomeo t) := delta_pos _
  nlinarith [h1 t]

/-! ## The counterexample -/

/-- The half width of the counterexample bump.  Any `w` beyond the (very crude) threshold
`32 (16 Si π + 56 + |c₀|)` works. -/
def wBad : ℝ := 32 * (16 * Si π + 56 + |weilConst|) + 10

theorem two_le_wBad : 2 ≤ wBad := by
  have h := Si_pi_pos
  have h2 : 0 ≤ |weilConst| := abs_nonneg _
  unfold wBad
  nlinarith

theorem wBad_pos : 0 < wBad := lt_of_lt_of_le (by norm_num) two_le_wBad

/-- The deficit of the triangular bump of half width `w` is at least `(w/2 - 1)/16`. -/
theorem deficit_triC_ge {w : ℝ} (hw : 2 ≤ w) :
    (w / 2 - 1) / 16
      ≤ (∫ u in Ioi (0:ℝ), triC w u * ((deficitKernel u : ℝ) : ℂ)).re := by
  have hw0 : 0 < w := by linarith
  set h : ℝ → ℝ := fun u => triReal w u * deficitKernel u with hh
  have hintC : IntegrableOn (fun u : ℝ => triC w u * ((deficitKernel u : ℝ) : ℂ)) (Ioi (0:ℝ)) :=
    integrableOn_mul_deficitKernel (continuous_triC w) (hasCompactSupport_triC hw0)
  have hcast : (fun u : ℝ => triC w u * ((deficitKernel u : ℝ) : ℂ))
      = fun u : ℝ => ((h u : ℝ) : ℂ) := by
    funext u
    simp [hh, triC, ← Complex.ofReal_mul]
  have hintR : IntegrableOn h (Ioi (0:ℝ)) := by
    have hintC' := hintC
    rw [hcast] at hintC'
    have h2 := hintC'.re
    simpa using h2
  have hre : (∫ u in Ioi (0:ℝ), triC w u * ((deficitKernel u : ℝ) : ℂ)).re
      = ∫ u in Ioi (0:ℝ), h u := by
    have hcomm := Complex.reCLM.integral_comp_comm hintC
    simp only [Complex.reCLM_apply] at hcomm
    rw [← hcomm]
    refine setIntegral_congr_fun measurableSet_Ioi (fun u _ => ?_)
    simp [hh, triC, ← Complex.ofReal_mul]
  rw [hre]
  have hsub : Ioc (1:ℝ) (w / 2) ⊆ Ioi (0:ℝ) := fun u hu => lt_trans zero_lt_one hu.1
  have hnn : 0 ≤ᶠ[ae (volume.restrict (Ioi (0:ℝ)))] h := by
    refine (ae_restrict_iff' measurableSet_Ioi).2 (Filter.Eventually.of_forall fun u hu => ?_)
    exact mul_nonneg (triReal_nonneg w u) (deficitKernel_nonneg hu)
  have hstep1 : (∫ u in Ioc (1:ℝ) (w / 2), h u) ≤ ∫ u in Ioi (0:ℝ), h u :=
    setIntegral_mono_set hintR hnn (Filter.Eventually.of_forall hsub)
  have hconst : ∀ u ∈ Ioc (1:ℝ) (w / 2), (1:ℝ) / 16 ≤ h u := by
    intro u hu
    have h1 : 1 ≤ u := hu.1.le
    have habs : |u| = u := abs_of_nonneg (by linarith)
    have htri : 1 / 2 ≤ triReal w u := by
      refine triReal_half_le hw0 ?_
      rw [habs]; exact hu.2
    have hker : 1 / 8 ≤ deficitKernel u := deficitKernel_ge h1
    have hk0 : 0 ≤ deficitKernel u := deficitKernel_nonneg (by linarith)
    nlinarith
  have hstep2 : (volume.real (Ioc (1:ℝ) (w/2))) • ((1:ℝ)/16) ≤ ∫ u in Ioc (1:ℝ) (w/2), h u := by
    refine setIntegral_ge_of_const_le measurableSet_Ioc ?_ hconst (hintR.mono_set hsub)
    rw [Real.volume_Ioc]
    exact ENNReal.ofReal_ne_top
  have hmeas : volume.real (Ioc (1:ℝ) (w/2)) = w / 2 - 1 := by
    rw [Measure.real, Real.volume_Ioc, ENNReal.toReal_ofReal (by linarith)]
  rw [hmeas] at hstep2
  simp only [smul_eq_mul] at hstep2
  linarith

/-- **The unnormalized functional is strictly negative on the triangular bump of half
width `wBad`.** -/
theorem L_real_triC_neg : L_real (ofLog (triC wBad)) < 0 := by
  have hw2 : 2 ≤ wBad := two_le_wBad
  have hw0 : 0 < wBad := wBad_pos
  have hcont := continuous_triC wBad
  have hsupp := hasCompactSupport_triC hw0
  have hLip := triC_lipschitz hw0
  set S : ℂ := ∫ u : ℝ, (1 - triC wBad u) * ((sinhKernel u : ℝ) : ℂ) with hS
  set Def : ℂ := ∫ u in Ioi (0:ℝ), triC wBad u * ((deficitKernel u : ℝ) : ℂ) with hDef
  -- the archimedean term
  have hW : WeilR (ofLog (triC wBad)) = ((weilConst : ℝ) : ℂ) - S + Def := by
    rw [WeilR_ofLog_eq_add_deficit hcont hsupp (fun t => triC_even t) hLip,
      WeilR_deltaHalfInv_ofLog_value hcont hLip, triC_zero, ← hS, ← hDef]
    ring
  have hWre : (WeilR (ofLog (triC wBad))).re = weilConst - S.re + Def.re := by
    rw [hW]
    simp
  -- the three estimates
  have hSbound : S.re ≤ 40 * (1 / wBad) := by
    have h := norm_integral_sub_mul_sinhKernel_le hcont hLip
    rw [triC_zero, ← hS] at h
    exact le_trans (Complex.re_le_norm S) h
  have hDefbound : (wBad / 2 - 1) / 16 ≤ Def.re := deficit_triC_ge hw2
  have hDbound : (Dcomplex (ofLog (triC wBad))).re ≤ 16 * Si π + 16 := by
    have := Dcomplex_ofLog_re_le (g := triReal wBad) (continuous_triReal wBad)
      (triReal_nonneg wBad) (triReal_le_one hw0)
    exact this
  -- assembling
  have hL : L_real (ofLog (triC wBad))
      = (Dcomplex (ofLog (triC wBad))).re - (WeilR (ofLog (triC wBad))).re := by
    rw [L_real_eq, Winfty]
    simp [sub_eq_add_neg]
  have hinv : 40 * (1 / wBad) ≤ 40 := by
    rw [mul_one_div, div_le_iff₀ hw0]
    nlinarith
  have habs : -weilConst ≤ |weilConst| := neg_le_abs _
  have hwval : wBad = 32 * (16 * Si π + 56 + |weilConst|) + 10 := rfl
  rw [hL, hWre]
  nlinarith [hDbound, hSbound, hDefbound, hinv, habs, hwval]

/-- **`LPositivity` is false.**  The unnormalized pairing of `D` and `W_∞` with the same
test function is *not* a positive functional; the statement of the paper (Corollary 2.3
(i)) is the positivity of the normalized functional `LfunNorm`, which is proved in
`RequestProject/NormalizedPositivity.lean` (`LPositivityNorm_holds`). -/
theorem not_LPositivity : ¬ LPositivity := by
  intro h
  have hpos := h (triC wBad) (continuous_triC wBad) (hasCompactSupport_triC wBad_pos)
    (positiveDefiniteLog_triC wBad_pos)
  exact absurd hpos (not_le.2 L_real_triC_neg)

end ConnesConsani.WeilPositivity
