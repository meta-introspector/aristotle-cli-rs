/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
Authors: Formalization of
  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771

**Two elementary Laplace transforms and the Euler constant as a logarithmic moment.**

* `integral_log_mul_exp_neg : ∫_0^∞ (log t) e^{-t} dt = -γ`, obtained from Mathlib's
  derivative of the Gamma integral together with `Γ'(1) = -γ`;
* `integral_exp_neg_mul_sin : ∫_0^∞ e^{-vt} sin t dt = 1/(1+v²)`;
* `integral_exp_neg_mul_sinc : ∫_0^∞ e^{-vt} (sin t)/t dt = arctan (1/v)`.

These are the analytic inputs for the evaluation of the universal constant of the even
(Sonin) renormalized trace formula.
-/
import Mathlib
import RequestProject.Imported.OutputFinal.RequestProject.LogFrullani

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Filter Topology Set Real

namespace ConnesConsani.WeilPositivity

/-! ## 1. The Euler constant as a logarithmic moment of `e^{-t}` -/

theorem integrableOn_log_mul_exp_neg :
    IntegrableOn (fun t : ℝ => Real.log t * Real.exp (-t)) (Ioi 0) := by
  have hsplit : Ioi (0:ℝ) = Ioc 0 1 ∪ Ioi 1 := by
    ext x; simp only [mem_Ioi, mem_union, mem_Ioc]; constructor
    · intro hx; rcases le_or_gt x 1 with h | h
      · exact Or.inl ⟨hx, h⟩
      · exact Or.inr h
    · rintro (⟨hx, _⟩ | hx) <;> linarith
  rw [hsplit]
  refine IntegrableOn.union ?_ ?_
  · have hlog0 : IntervalIntegrable (fun t : ℝ => Real.log t) volume 0 1 :=
      intervalIntegral.intervalIntegrable_log'
    have hlog : IntegrableOn (fun t : ℝ => Real.log t) (Ioc 0 1) := by
      rwa [intervalIntegrable_iff_integrableOn_Ioc_of_le (by norm_num)] at hlog0
    refine Integrable.mono' (hlog.norm) (by fun_prop) ?_
    filter_upwards [self_mem_ae_restrict measurableSet_Ioc] with t ht
    have h1 : Real.exp (-t) ≤ 1 := by
      rw [Real.exp_le_one_iff]; linarith [ht.1]
    rw [norm_mul, Real.norm_eq_abs, Real.norm_eq_abs]
    calc |Real.log t| * |Real.exp (-t)| ≤ |Real.log t| * 1 := by
          gcongr
          rw [abs_of_pos (Real.exp_pos _)]; exact h1
      _ = ‖Real.log t‖ := by simp
  · have hb0 : IntegrableOn (fun t : ℝ => Real.exp (-(1/2 * t))) (Ioi 1) := by
      simpa [neg_mul] using exp_neg_integrableOn_Ioi (1:ℝ) (show (0:ℝ) < 1/2 by norm_num)
    have hb : IntegrableOn (fun t : ℝ => 2 * Real.exp (-(1/2 * t))) (Ioi 1) := hb0.const_mul 2
    refine Integrable.mono' hb (by fun_prop) ?_
    filter_upwards [self_mem_ae_restrict measurableSet_Ioi] with t ht
    have ht1 : (1:ℝ) < t := ht
    have ht0 : (0:ℝ) < t := lt_trans zero_lt_one ht1
    have hlogt : Real.log t ≤ t := by
      have := Real.log_le_sub_one_of_pos ht0; linarith
    have hlognn : 0 ≤ Real.log t := Real.log_nonneg ht1.le
    have hexp : t / 2 + 1 ≤ Real.exp (t / 2) := by
      have := Real.add_one_le_exp (t / 2); linarith
    have hkey : Real.log t * Real.exp (-(t / 2)) ≤ 2 := by
      have hpos : (0:ℝ) < Real.exp (t / 2) := Real.exp_pos _
      have h1 : Real.exp (-(t / 2)) = 1 / Real.exp (t / 2) := by
        rw [Real.exp_neg]; simp
      rw [h1, mul_one_div, div_le_iff₀ hpos]
      nlinarith
    rw [norm_mul, Real.norm_eq_abs, Real.norm_eq_abs, abs_of_nonneg hlognn,
      abs_of_pos (Real.exp_pos _)]
    have hfac : Real.exp (-t) = Real.exp (-(1/2 * t)) * Real.exp (-(t / 2)) := by
      rw [← Real.exp_add]; ring_nf
    rw [hfac]
    nlinarith [hkey, Real.exp_pos (-(1/2 * t))]

/-- **Euler's constant as a logarithmic moment**: `∫_0^∞ (log t) e^{-t} dt = -γ`. -/
theorem integral_log_mul_exp_neg :
    ∫ t in Ioi (0:ℝ), Real.log t * Real.exp (-t) = -Real.eulerMascheroniConstant := by
  set R : ℝ := ∫ t in Ioi (0:ℝ), Real.log t * Real.exp (-t) with hR
  have hcoe : ((R : ℝ) : ℂ) = ∫ t in Ioi (0:ℝ), ((Real.log t * Real.exp (-t) : ℝ) : ℂ) := by
    rw [hR]; exact integral_complex_ofReal.symm
  have hAval : (∫ t : ℝ in Ioi 0,
      (t : ℂ) ^ ((1:ℂ) - 1) * ((Real.log t : ℝ) : ℂ) * ((Real.exp (-t) : ℝ) : ℂ)) = (R : ℂ) := by
    rw [hcoe]
    refine setIntegral_congr_fun measurableSet_Ioi ?_
    intro t ht
    have ht0 : (0:ℝ) < t := ht
    push_cast
    rw [sub_self, Complex.cpow_zero]
    ring
  have hC0 := Complex.hasDerivAt_GammaIntegral (s := (1:ℂ)) (by simp)
  have hC0' : HasDerivAt Complex.GammaIntegral (R : ℂ) 1 := by
    refine hC0.congr_deriv ?_
    rw [← hAval]
    refine setIntegral_congr_fun measurableSet_Ioi ?_
    intro t ht
    ring
  -- `Γ` agrees with the Gamma integral near `1`
  have hev : Complex.Gamma =ᶠ[𝓝 (1:ℂ)] Complex.GammaIntegral := by
    have hopen : IsOpen {s : ℂ | 0 < s.re} := isOpen_lt continuous_const Complex.continuous_re
    have hmem : (1:ℂ) ∈ {s : ℂ | 0 < s.re} := by simp
    filter_upwards [hopen.mem_nhds hmem] with s hs
    exact Complex.Gamma_eq_integral hs
  have hC : HasDerivAt Complex.Gamma (R : ℂ) 1 := hC0'.congr_of_eventuallyEq hev
  have hC1 : HasDerivAt Complex.Gamma (R : ℂ) (((1:ℝ) : ℂ)) := by simpa using hC
  have hRe : HasDerivAt (fun x : ℝ => (Complex.Gamma (x : ℂ)).re) ((R : ℂ)).re 1 :=
    hC1.real_of_complex
  have hfun : (fun x : ℝ => (Complex.Gamma (x : ℂ)).re) = Real.Gamma := by
    funext x
    rw [Complex.Gamma_ofReal]
    simp
  rw [hfun, Complex.ofReal_re] at hRe
  have := hRe.unique Real.hasDerivAt_Gamma_one
  simpa using this

/-! ## 2. The Laplace transform of the sine -/

theorem integrableOn_exp_neg_mul_sin {v : ℝ} (hv : 0 < v) :
    IntegrableOn (fun t : ℝ => Real.exp (-(v * t)) * Real.sin t) (Ioi 0) := by
  refine Integrable.mono' (exp_neg_integrableOn_Ioi (0:ℝ) hv) (by fun_prop) ?_
  filter_upwards with t
  rw [norm_mul, Real.norm_eq_abs, Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
  have : |Real.sin t| ≤ 1 := Real.abs_sin_le_one t
  simpa [neg_mul] using
    (mul_le_of_le_one_right (Real.exp_pos (-(v*t))).le this)

theorem integral_exp_neg_mul_sin {v : ℝ} (hv : 0 < v) :
    ∫ t in Ioi (0:ℝ), Real.exp (-(v * t)) * Real.sin t = 1 / (1 + v ^ 2) := by
  have hden : (0:ℝ) < 1 + v ^ 2 := by positivity
  set F : ℝ → ℝ := fun t =>
    -(Real.exp (-(v * t)) * (v * Real.sin t + Real.cos t)) / (1 + v ^ 2) with hF
  have hderiv : ∀ t : ℝ, HasDerivAt F (Real.exp (-(v * t)) * Real.sin t) t := by
    intro t
    have h1 : HasDerivAt (fun t : ℝ => -(v * t)) (-v) t := by
      simpa using ((hasDerivAt_id t).const_mul v).neg
    have he : HasDerivAt (fun t : ℝ => Real.exp (-(v * t)))
        (Real.exp (-(v * t)) * (-v)) t := h1.exp
    have hs : HasDerivAt (fun t : ℝ => v * Real.sin t + Real.cos t)
        (v * Real.cos t + -Real.sin t) t :=
      ((Real.hasDerivAt_sin t).const_mul v).add (Real.hasDerivAt_cos t)
    have hp := he.mul hs
    have := (hp.neg).div_const (1 + v ^ 2)
    rw [hF]
    convert this using 1
    field_simp
    ring
  have hlim : Tendsto F atTop (𝓝 0) := by
    have hmul : Tendsto (fun t : ℝ => v * t) atTop atTop :=
      Filter.Tendsto.const_mul_atTop hv tendsto_id
    have hneg : Tendsto (fun t : ℝ => -(v * t)) atTop atBot := tendsto_neg_atTop_atBot.comp hmul
    have h0 : Tendsto (fun t : ℝ => Real.exp (-(v * t))) atTop (𝓝 0) :=
      Real.tendsto_exp_atBot.comp hneg
    have hbdd : ∀ t : ℝ, |v * Real.sin t + Real.cos t| ≤ v + 1 := by
      intro t
      have h1 : |v * Real.sin t| ≤ v := by
        rw [abs_mul, abs_of_pos hv]
        nlinarith [Real.abs_sin_le_one t, hv.le, abs_nonneg (Real.sin t)]
      have h2 : |Real.cos t| ≤ 1 := Real.abs_cos_le_one t
      have h3 : |v * Real.sin t + Real.cos t| ≤ |v * Real.sin t| + |Real.cos t| :=
        abs_add_le _ _
      linarith
    have hprod : Tendsto (fun t : ℝ => Real.exp (-(v * t)) * (v * Real.sin t + Real.cos t))
        atTop (𝓝 0) := by
      refine squeeze_zero_norm ?_ (by simpa using h0.const_mul (v + 1))
      intro t
      rw [norm_mul, Real.norm_eq_abs, Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
      have := hbdd t
      nlinarith [Real.exp_pos (-(v*t)), abs_nonneg (v * Real.sin t + Real.cos t)]
    have := (hprod.neg).div_const (1 + v ^ 2)
    simpa [hF] using this
  have hmain := integral_Ioi_of_hasDerivAt_of_tendsto' (f := F)
    (f' := fun t : ℝ => Real.exp (-(v * t)) * Real.sin t) (a := 0) (m := 0)
    (fun t _ => hderiv t) (integrableOn_exp_neg_mul_sin hv) hlim
  rw [hmain, hF]
  simp
  ring

/-! ## 3. The Laplace transform of the cardinal sine -/

theorem abs_sinc_le_one {t : ℝ} (ht : 0 < t) : |Real.sin t / t| ≤ 1 := by
  rw [abs_div, abs_of_pos ht, div_le_one ht]
  simpa [abs_of_pos ht] using Real.abs_sin_le_abs (x := t)

theorem integrableOn_exp_neg_mul_sinc {v : ℝ} (hv : 0 < v) :
    IntegrableOn (fun t : ℝ => Real.exp (-(v * t)) * (Real.sin t / t)) (Ioi 0) := by
  refine Integrable.mono' (exp_neg_integrableOn_Ioi (0:ℝ) hv) (by fun_prop) ?_
  filter_upwards [self_mem_ae_restrict measurableSet_Ioi] with t ht
  have ht0 : (0:ℝ) < t := ht
  rw [norm_mul, Real.norm_eq_abs, Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
  simpa [neg_mul] using
    (mul_le_of_le_one_right (Real.exp_pos (-(v*t))).le (abs_sinc_le_one ht0))

/-- The Laplace transform of the cardinal sine. -/
def laplaceSinc (v : ℝ) : ℝ := ∫ t in Ioi (0:ℝ), Real.exp (-(v * t)) * (Real.sin t / t)

theorem abs_laplaceSinc_le {v : ℝ} (hv : 0 < v) : |laplaceSinc v| ≤ 1 / v := by
  have hint : IntegrableOn (fun t : ℝ => Real.exp (-(v * t))) (Ioi 0) := by
    simpa [neg_mul] using exp_neg_integrableOn_Ioi (0:ℝ) hv
  have hb : ∀ᵐ t ∂(volume.restrict (Ioi (0:ℝ))),
      ‖Real.exp (-(v * t)) * (Real.sin t / t)‖ ≤ Real.exp (-(v * t)) := by
    filter_upwards [self_mem_ae_restrict measurableSet_Ioi] with t ht
    have ht0 : (0:ℝ) < t := ht
    rw [norm_mul, Real.norm_eq_abs, Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
    exact mul_le_of_le_one_right (Real.exp_pos _).le (abs_sinc_le_one ht0)
  have h := norm_integral_le_of_norm_le hint hb
  calc |laplaceSinc v| = ‖laplaceSinc v‖ := rfl
    _ ≤ ∫ t in Ioi (0:ℝ), Real.exp (-(v * t)) := h
    _ = 1 / v := integral_exp_neg_mul_Ioi_zero hv

theorem hasDerivAt_laplaceSinc {v : ℝ} (hv : 0 < v) :
    HasDerivAt laplaceSinc (-(1 / (1 + v ^ 2))) v := by
  have hs : Ioo (v / 2) (2 * v) ∈ 𝓝 v := Ioo_mem_nhds (by linarith) (by linarith)
  have hbdd : IntegrableOn (fun t : ℝ => Real.exp (-(v / 2 * t))) (Ioi 0) := by
    simpa [neg_mul] using exp_neg_integrableOn_Ioi (0:ℝ) (by linarith : (0:ℝ) < v / 2)
  have hdiff : ∀ᵐ t ∂(volume.restrict (Ioi (0:ℝ))), ∀ x ∈ Ioo (v / 2) (2 * v),
      HasDerivAt (fun x : ℝ => Real.exp (-(x * t)) * (Real.sin t / t))
        (-(Real.exp (-(x * t)) * Real.sin t)) x := by
    filter_upwards [self_mem_ae_restrict measurableSet_Ioi] with t ht x _
    have ht0 : (0:ℝ) < t := ht
    have h1 : HasDerivAt (fun x : ℝ => -(x * t)) (-t) x := by
      simpa using ((hasDerivAt_id x).mul_const t).neg
    have h2 := (Real.hasDerivAt_exp (-(x * t))).comp x h1
    have h3 := h2.mul_const (Real.sin t / t)
    convert h3 using 1
    field_simp
  have hmeas : ∀ᶠ x in 𝓝 v, AEStronglyMeasurable
      (fun t : ℝ => Real.exp (-(x * t)) * (Real.sin t / t)) (volume.restrict (Ioi (0:ℝ))) := by
    filter_upwards with x
    fun_prop
  have hbound : ∀ᵐ t ∂(volume.restrict (Ioi (0:ℝ))), ∀ x ∈ Ioo (v / 2) (2 * v),
      ‖-(Real.exp (-(x * t)) * Real.sin t)‖ ≤ Real.exp (-(v / 2 * t)) := by
    filter_upwards [self_mem_ae_restrict measurableSet_Ioi] with t ht x hx
    have ht0 : (0:ℝ) < t := ht
    rw [norm_neg, norm_mul, Real.norm_eq_abs, Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
    have h1 : Real.exp (-(x * t)) ≤ Real.exp (-(v / 2 * t)) :=
      Real.exp_le_exp.2 (by nlinarith [hx.1])
    nlinarith [Real.abs_sin_le_one t, Real.exp_pos (-(x*t)), abs_nonneg (Real.sin t)]
  have hkey := hasDerivAt_integral_of_dominated_loc_of_deriv_le
    (F := fun x t => Real.exp (-(x * t)) * (Real.sin t / t))
    (F' := fun x t => -(Real.exp (-(x * t)) * Real.sin t))
    (bound := fun t => Real.exp (-(v / 2 * t))) (x₀ := v)
    hs hmeas (integrableOn_exp_neg_mul_sinc hv) (by fun_prop) hbound hbdd hdiff
  have h2 := hkey.2
  have hval : ∫ t in Ioi (0:ℝ), -(Real.exp (-(v * t)) * Real.sin t) = -(1 / (1 + v ^ 2)) := by
    rw [MeasureTheory.integral_neg, integral_exp_neg_mul_sin hv]
  rw [hval] at h2
  exact h2

theorem hasDerivAt_arctan_inv {v : ℝ} (hv : 0 < v) :
    HasDerivAt (fun x : ℝ => Real.arctan (1 / x)) (-(1 / (1 + v ^ 2))) v := by
  have h1 : HasDerivAt (fun x : ℝ => 1 / x) (-(1 / v ^ 2)) v := by
    simp only [one_div]
    exact hasDerivAt_inv hv.ne'
  have h2 := (Real.hasDerivAt_arctan (1 / v)).comp v h1
  convert h2 using 1
  have hv2 : (0:ℝ) < v ^ 2 := by positivity
  field_simp
  ring

/-- **The Laplace transform of the cardinal sine.** -/
theorem laplaceSinc_eq_arctan {v : ℝ} (hv : 0 < v) :
    laplaceSinc v = Real.arctan (1 / v) := by
  set g : ℝ → ℝ := fun x => laplaceSinc x - Real.arctan (1 / x) with hg
  have hgderiv : ∀ x : ℝ, 0 < x → HasDerivAt g 0 x := by
    intro x hx
    have := (hasDerivAt_laplaceSinc hx).sub (hasDerivAt_arctan_inv hx)
    simpa [hg] using this
  have hconst : ∀ b : ℝ, v ≤ b → g b = g v := by
    intro b hb
    have hpos : ∀ x ∈ uIcc v b, 0 < x := by
      intro x hx
      rw [uIcc_of_le hb] at hx
      linarith [hx.1]
    have hFTC := intervalIntegral.integral_eq_sub_of_hasDerivAt
      (f := g) (f' := fun _ => (0:ℝ)) (fun x hx => hgderiv x (hpos x hx))
      (_root_.intervalIntegrable_const)
    simp at hFTC
    linarith [hFTC]
  have hlim0 : Tendsto g atTop (𝓝 0) := by
    have hinv : Tendsto (fun x : ℝ => 1 / x) atTop (𝓝 0) := by
      simpa [one_div] using tendsto_inv_atTop_zero
    have hA : Tendsto laplaceSinc atTop (𝓝 0) := by
      refine squeeze_zero_norm' ?_ hinv
      filter_upwards [eventually_gt_atTop (0:ℝ)] with x hx
      exact abs_laplaceSinc_le hx
    have hB : Tendsto (fun x : ℝ => Real.arctan (1 / x)) atTop (𝓝 0) := by
      have := (Real.continuous_arctan.tendsto 0).comp hinv
      simpa using this
    simpa [hg] using hA.sub hB
  have heq : Tendsto g atTop (𝓝 (g v)) := by
    refine Tendsto.congr' ?_ tendsto_const_nhds
    filter_upwards [eventually_ge_atTop v] with b hb
    exact (hconst b hb).symm
  have := tendsto_nhds_unique heq hlim0
  simpa [hg, sub_eq_zero] using this

end ConnesConsani.WeilPositivity
