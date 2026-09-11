/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**The normalized trace identity with a fixed cutoff is impossible**, for arXiv:2006.13771
(Connes–Consani, *Weil positivity and Trace formula – the archimedean place*).

`RequestProject/TraceDensity.lean` reduces the identity `L_Norm(f) = Tr(ϑ(f) P P̂ P)`
(`NormalizedTraceIdentity`) to an identity of functions: the trace functional is
integration against the *bounded continuous* trace density `κ`
(`traceAlong_thetaOpOf_soninSandwich_eq_integral`, `continuous_traceDensity`).

That reduction settles the question, in the negative.  A functional of the form
`f ↦ ∫ f κ d*λ` with `κ` bounded is continuous for the `L¹(d*λ)` norm, whereas the
archimedean functional `L_Norm` is a *distribution of order one*: on the triangular bump of
half width `w` it grows like `log(1/w)` while the `L¹`-norm of the bump tends to `0`.  The
mechanism is the singularity `κ_∞(u) ≈ 1/(2|u|)` of the kernel `sinhKernel` of the
archimedean explicit formula at `u = 0` (`sinhDeficit_ge`), which no trace-class operator
can produce.

The main theorem is `not_normalizedTraceIdentity`: for **every** unitary identification `U`
of the two pictures, `NormalizedTraceIdentity U` is false.  Consequently the trace formula
of the paper cannot hold with the *fixed* cutoff projections `P₁, P̂₁`; it requires the
cutoff `Λ → ∞` of Connes' local trace formula, together with the `log Λ` subtraction, i.e.
the trace has to be renormalized.  The conditional theorem
`LfunNorm_re_nonneg_of_normalizedTraceIdentity` of
`RequestProject/TraceIdentityNorm.lean` is therefore vacuous; the positivity of `L_Norm` is
proved unconditionally, by the analytic route, in
`RequestProject/ArchimedeanPositivity.lean` and
`RequestProject/NormalizedPositivity.lean`.

Nothing in the analytic part of the project is used here beyond results already proved:
the closed form of the normalized archimedean term (`WeilR_deltaHalfInv_ofLog_value`), the
bound on `D` (`Dcomplex_ofLog_re_le`) and the triangular bump of
`RequestProject/UnnormalizedCounterexample.lean`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.TraceDensitySymmetry
import RequestProject.Imported.OutputFinal.RequestProject.UnnormalizedCounterexample

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory Set Real ContinuousLinearMap

open scoped CompactlySupported ENNReal

namespace ConnesConsani.WeilPositivity

variable {ι : Type*}

/-! ## The trace functional is `L¹`-bounded -/

variable (U : L2Rplus ≃ₗᵢ[ℂ] L2R)

theorem norm_traceDensity_le (b : HilbertBasis ι ℂ L2R) (lam : Rplus) :
    ‖traceDensity U b lam‖ ≤ (soninHSNormSq b).toReal := by
  have h := ENNReal.toReal_mono (soninHSNormSq_ne_top b) (enorm_traceDensity_le U b lam)
  simpa using h

/-- The trace density is bounded, so the trace functional `f ↦ Tr(ϑ(f) P P̂ P)` is bounded
by a constant times the `L¹(d*λ)` norm of `f`. -/
theorem norm_integral_mul_traceDensityStd_le (g : C_c(Rplus, ℂ)) :
    ‖∫ lam, g lam * traceDensityStd U lam ∂(Rplus.haar)‖
      ≤ (soninHSNormSq stdBasis).toReal * ∫ lam, ‖g lam‖ ∂(Rplus.haar) := by
  set C : ℝ := (soninHSNormSq stdBasis).toReal with hC
  have hC0 : 0 ≤ C := ENNReal.toReal_nonneg
  have hgnorm : Integrable (fun lam : Rplus => ‖g lam‖) Rplus.haar := integrable_norm g
  have hb : ∀ lam : Rplus, ‖g lam * traceDensityStd U lam‖ ≤ C * ‖g lam‖ := by
    intro lam
    rw [norm_mul, mul_comm]
    exact mul_le_mul_of_nonneg_right (norm_traceDensity_le U stdBasis lam) (norm_nonneg _)
  have hmeas : AEStronglyMeasurable (fun lam : Rplus => g lam * traceDensityStd U lam)
      Rplus.haar :=
    ((map_continuous g).mul (continuous_traceDensityStd U)).aestronglyMeasurable
  have hint : Integrable (fun lam : Rplus => g lam * traceDensityStd U lam) Rplus.haar :=
    Integrable.mono' (hgnorm.const_mul C) hmeas (.of_forall hb)
  calc ‖∫ lam, g lam * traceDensityStd U lam ∂(Rplus.haar)‖
      ≤ ∫ lam, ‖g lam * traceDensityStd U lam‖ ∂(Rplus.haar) :=
        norm_integral_le_integral_norm _
    _ ≤ ∫ lam, C * ‖g lam‖ ∂(Rplus.haar) :=
        integral_mono hint.norm (hgnorm.const_mul C) hb
    _ = C * ∫ lam, ‖g lam‖ ∂(Rplus.haar) := integral_const_mul _ _

/-! ## The triangular bump as a test function on `ℝ⋆₊` -/

/-- The triangular bump of half width `w` in the logarithmic coordinate, read as a test
function on `ℝ⋆₊`: `g(ρ) = max(0, 1 - |log ρ|/w)`. -/
def logBump (w : ℝ) (hw : 0 < w) : C_c(Rplus, ℂ) where
  toFun := fun ρ => triC w (Rplus.expHomeo.symm ρ)
  continuous_toFun := (continuous_triC w).comp Rplus.expHomeo.symm.continuous
  hasCompactSupport' := (hasCompactSupport_triC hw).comp_homeomorph Rplus.expHomeo.symm

@[simp] theorem logTest_logBump {w : ℝ} (hw : 0 < w) : logTest (logBump w hw) = triC w := by
  funext t
  show triC w (Rplus.expHomeo.symm (Rplus.expHomeo t)) = triC w t
  rw [Homeomorph.symm_apply_apply]

/-! ## The `L¹` norm of the bump -/

theorem hasCompactSupport_triReal {w : ℝ} (hw : 0 < w) : HasCompactSupport (triReal w) := by
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
  exact triReal_eq_zero hw h

theorem integrable_triReal {w : ℝ} (hw : 0 < w) : Integrable (triReal w) :=
  (continuous_triReal w).integrable_of_hasCompactSupport (hasCompactSupport_triReal hw)

theorem integral_triReal_le {w : ℝ} (hw : 0 < w) : (∫ t : ℝ, triReal w t) ≤ 2 * w := by
  have hind : Integrable (Set.indicator (Set.Icc (-w) w) (fun _ : ℝ => (1:ℝ))) := by
    rw [integrable_indicator_iff measurableSet_Icc]
    exact integrableOn_const measure_Icc_lt_top.ne
  have hle : ∀ t : ℝ, triReal w t ≤ Set.indicator (Set.Icc (-w) w) (fun _ : ℝ => (1:ℝ)) t := by
    intro t
    by_cases ht : t ∈ Set.Icc (-w) w
    · rw [Set.indicator_of_mem ht]
      exact triReal_le_one hw t
    · have h : w ≤ |t| := by
        rcases abs_cases t with ⟨h1, h2⟩ | ⟨h1, h2⟩
        · rw [h1]
          by_contra hc
          exact ht ⟨by linarith, by linarith⟩
        · rw [h1]
          by_contra hc
          exact ht ⟨by linarith, by linarith⟩
      rw [Set.indicator_of_notMem ht, triReal_eq_zero hw h]
  refine le_trans (integral_mono (integrable_triReal hw) hind hle) ?_
  rw [integral_indicator_const _ measurableSet_Icc]
  simp only [smul_eq_mul, mul_one]
  rw [Real.volume_real_Icc_of_le (by linarith)]
  linarith

/-- The `L¹(d*λ)` norm of the bump is at most `2w`. -/
theorem integral_norm_logBump_le {w : ℝ} (hw : 0 < w) :
    (∫ lam, ‖(logBump w hw) lam‖ ∂(Rplus.haar)) ≤ 2 * w := by
  have hrw : (∫ lam, ‖(logBump w hw) lam‖ ∂(Rplus.haar)) = ∫ t : ℝ, triReal w t := by
    rw [Rplus.integral_haar]
    refine integral_congr_ae (.of_forall fun t => ?_)
    have h : (logBump w hw) (Rplus.expHomeo t) = triC w t := by
      show triC w (Rplus.expHomeo.symm (Rplus.expHomeo t)) = triC w t
      rw [Homeomorph.symm_apply_apply]
    show ‖(logBump w hw) (Rplus.expHomeo t)‖ = triReal w t
    rw [h, triC, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (triReal_nonneg w t)]
  rw [hrw]
  exact integral_triReal_le hw

/-! ## The logarithmic divergence of the archimedean kernel -/

/-- The pairing of the bump with the kernel of the archimedean explicit formula,
`∫ (1 - tri_w(u)) κ(u) du`. -/
def sinhDeficit (w : ℝ) : ℝ := ∫ u : ℝ, (1 - triReal w u) * sinhKernel u

theorem integrable_sinhDeficit_integrand {w : ℝ} (hw : 0 < w) :
    Integrable (fun u : ℝ => (1 - triReal w u) * sinhKernel u) := by
  have hC := integrable_sub_mul_sinhKernel (continuous_triC w) (triC_lipschitz hw)
  have hcongr : (fun u : ℝ => (triC w 0 - triC w u) * ((sinhKernel u : ℝ) : ℂ))
      = fun u : ℝ => (((1 - triReal w u) * sinhKernel u : ℝ) : ℂ) := by
    funext u
    rw [triC_zero]
    simp only [triC]
    push_cast
    ring
  rw [hcongr] at hC
  simpa using hC.re

/-- The kernel of the archimedean explicit formula has a `1/(2u)` singularity at the
origin; the crude bound `κ(u) ≥ 1/(6u)` on `(0,1]` is all that is needed. -/
theorem sinhKernel_ge_inv {u : ℝ} (hu : 0 < u) (hu1 : u ≤ 1) : (6 * u)⁻¹ ≤ sinhKernel u := by
  have habs : |u| = u := abs_of_pos hu
  have hD : Real.exp u - Real.exp (-u) ≤ 2 * u * Real.exp u := by
    have h := Real.add_one_le_exp (-(2 * u))
    have hexp : Real.exp (-u) = Real.exp u * Real.exp (-(2 * u)) := by
      rw [← Real.exp_add]; ring_nf
    have hEpos : 0 < Real.exp u := Real.exp_pos u
    nlinarith [hEpos, h]
  have hEle : Real.exp u ≤ 3 * Real.exp (u / 2) := by
    have h1 : Real.exp u = Real.exp (u / 2) * Real.exp (u / 2) := by
      rw [← Real.exp_add]; ring_nf
    have h2 : Real.exp (u / 2) ≤ Real.exp 1 := Real.exp_le_exp.2 (by linarith)
    have h3 : Real.exp 1 < 3 := by
      have := Real.exp_one_lt_d9
      linarith
    have h4 : 0 < Real.exp (u / 2) := Real.exp_pos _
    nlinarith
  have hDpos : 0 < Real.exp u - Real.exp (-u) := by
    have : Real.exp (-u) < Real.exp u := Real.exp_lt_exp.2 (by linarith)
    linarith
  have hkey : Real.exp u - Real.exp (-u) ≤ 6 * u * Real.exp (u / 2) := by
    nlinarith [hD, hEle, hu]
  rw [sinhKernel, habs, le_div_iff₀ hDpos, inv_mul_eq_div, div_le_iff₀ (by positivity : (0:ℝ) < 6 * u)]
  nlinarith [hkey]

theorem continuousOn_sinhKernel_Icc {w : ℝ} (hw : 0 < w) :
    ContinuousOn sinhKernel (Set.Icc w 1) := by
  have hg : ContinuousOn (fun u : ℝ => Real.exp (u / 2) / (Real.exp u - Real.exp (-u)))
      (Set.Icc w 1) := by
    refine ContinuousOn.div (by fun_prop) (by fun_prop) ?_
    intro u hu
    have hu0 : 0 < u := lt_of_lt_of_le hw hu.1
    have : Real.exp (-u) < Real.exp u := Real.exp_lt_exp.2 (by linarith)
    linarith
  refine hg.congr ?_
  intro u hu
  have hu0 : 0 < u := lt_of_lt_of_le hw hu.1
  rw [sinhKernel, abs_of_pos hu0]

/-- **The logarithmic divergence**: on the triangular bump of half width `w ≤ 1` the pairing
with the archimedean kernel is at least `(1/6) log(1/w)`. -/
theorem sinhDeficit_ge {w : ℝ} (hw : 0 < w) (hw1 : w ≤ 1) :
    -Real.log w / 6 ≤ sinhDeficit w := by
  have hint := integrable_sinhDeficit_integrand hw
  have hnonneg : ∀ u : ℝ, 0 ≤ (1 - triReal w u) * sinhKernel u := by
    intro u
    exact mul_nonneg (by linarith [triReal_le_one hw u]) (sinhKernel_nonneg u)
  have hsub : (∫ u in Set.Icc w 1, (1 - triReal w u) * sinhKernel u) ≤ sinhDeficit w :=
    setIntegral_le_integral hint (.of_forall hnonneg)
  have heq : (∫ u in Set.Icc w 1, (1 - triReal w u) * sinhKernel u)
      = ∫ u in Set.Icc w 1, sinhKernel u := by
    refine setIntegral_congr_fun measurableSet_Icc (fun u hu => ?_)
    have hu0 : 0 < u := lt_of_lt_of_le hw hu.1
    have hge : w ≤ |u| := by rw [abs_of_pos hu0]; exact hu.1
    rw [triReal_eq_zero hw hge]
    ring
  have hIoc : (∫ u in Set.Icc w 1, sinhKernel u) = ∫ u in w..1, sinhKernel u := by
    rw [intervalIntegral.integral_of_le hw1, ← integral_Icc_eq_integral_Ioc]
  have hcont : ContinuousOn sinhKernel (Set.Icc w 1) := continuousOn_sinhKernel_Icc hw
  have hii : IntervalIntegrable sinhKernel volume w 1 := by
    rw [intervalIntegrable_iff_integrableOn_Icc_of_le hw1]
    exact hcont.integrableOn_compact isCompact_Icc
  have hii2 : IntervalIntegrable (fun u : ℝ => (6 * u)⁻¹) volume w 1 := by
    apply ContinuousOn.intervalIntegrable
    rw [Set.uIcc_of_le hw1]
    refine ContinuousOn.inv₀ (by fun_prop) ?_
    intro u hu
    have hu0 : 0 < u := lt_of_lt_of_le hw hu.1
    positivity
  have hmono : (∫ u in w..1, (6 * u)⁻¹) ≤ ∫ u in w..1, sinhKernel u := by
    refine intervalIntegral.integral_mono_on hw1 hii2 hii (fun u hu => ?_)
    exact sinhKernel_ge_inv (lt_of_lt_of_le hw hu.1) hu.2
  have hval : (∫ u in w..1, (6 * u)⁻¹) = -Real.log w / 6 := by
    have h6 : ∀ u : ℝ, (6 * u)⁻¹ = 6⁻¹ * u⁻¹ := by
      intro u; rw [mul_inv]
    simp only [h6]
    rw [intervalIntegral.integral_const_mul, integral_inv_of_pos hw (by norm_num)]
    rw [Real.log_div (by norm_num) (ne_of_gt hw), Real.log_one]
    ring
  rw [hval] at hmono
  calc -Real.log w / 6 ≤ ∫ u in w..1, sinhKernel u := hmono
    _ = ∫ u in Set.Icc w 1, sinhKernel u := hIoc.symm
    _ = ∫ u in Set.Icc w 1, (1 - triReal w u) * sinhKernel u := heq.symm
    _ ≤ sinhDeficit w := hsub

/-! ## The analytic functional on the bump -/

theorem zero_le_Dcomplex_ofLog_re {g : ℝ → ℝ} (hgc : Continuous g) (h0 : ∀ t, 0 ≤ g t)
    (h1 : ∀ t, g t ≤ 1) :
    0 ≤ (Dcomplex (ofLog (fun t => ((g t : ℝ) : ℂ)))).re := by
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
  refine integral_nonneg fun t => ?_
  exact mul_nonneg (h0 t) (delta_pos _).le

/-- **The value of the normalized functional on the triangular bump**:
`Re L_Norm(tri_w) = Re D(tri_w) - c₀ + ∫ (1 - tri_w(u)) κ(u) du`. -/
theorem LfunNorm_triC_re {w : ℝ} (hw : 0 < w) :
    (LfunNorm (triC w)).re
      = (Dcomplex (ofLog (triC w))).re - weilConst + sinhDeficit w := by
  have hval := WeilR_deltaHalfInv_ofLog_value (continuous_triC w) (triC_lipschitz hw)
  have hS : (∫ u : ℝ, (triC w 0 - triC w u) * ((sinhKernel u : ℝ) : ℂ))
      = ((sinhDeficit w : ℝ) : ℂ) := by
    have hcongr : (fun u : ℝ => (triC w 0 - triC w u) * ((sinhKernel u : ℝ) : ℂ))
        = fun u : ℝ => (((1 - triReal w u) * sinhKernel u : ℝ) : ℂ) := by
      funext u
      rw [triC_zero]
      simp only [triC]
      push_cast
      ring
    rw [hcongr, sinhDeficit]
    exact integral_complex_ofReal
  rw [LfunNorm, Winfty, hval, hS, triC_zero]
  simp only [Complex.sub_re, Complex.add_re, Complex.neg_re, Complex.mul_re, Complex.one_re,
    Complex.one_im, Complex.ofReal_re, Complex.ofReal_im]
  ring

/-! ## The obstruction -/

/-- The half width of the bump that produces the contradiction: it is chosen so that
`(1/6) log(1/w)` exceeds all the bounded contributions. -/
def wObstruction : ℝ :=
  Real.exp (-(6 * (|weilConst| + 2 * (soninHSNormSq stdBasis).toReal
    + (16 * Si π + 16) + 1)))

theorem wObstruction_pos : 0 < wObstruction := Real.exp_pos _

theorem wObstruction_le_one : wObstruction ≤ 1 := by
  rw [wObstruction, Real.exp_le_one_iff]
  have h1 : (0:ℝ) ≤ |weilConst| := abs_nonneg _
  have h2 : (0:ℝ) ≤ (soninHSNormSq stdBasis).toReal := ENNReal.toReal_nonneg
  have h3 : (0:ℝ) < Si π := Si_pi_pos
  nlinarith

/-- **The normalized trace identity is impossible.**  For every unitary identification `U`
of `L²(ℝ⋆₊, d*ρ)` with `L²(ℝ)`, the identity `L_Norm(f) = Tr(ϑ(f) P₁P̂₁P₁)` fails: the right
hand side is bounded by the `L¹(d*λ)` norm of `f` (the sandwich is trace class), while the
left hand side is a distribution of order one, whose value on the triangular bump of half
width `w` grows like `log(1/w)` because of the singularity of the archimedean kernel at the
origin. -/
theorem not_normalizedTraceIdentity : ¬ NormalizedTraceIdentity U := by
  intro h
  set C : ℝ := (soninHSNormSq stdBasis).toReal with hC
  have hC0 : 0 ≤ C := ENNReal.toReal_nonneg
  set K : ℝ := |weilConst| + 2 * C + (16 * Si π + 16) + 1 with hK
  set w : ℝ := wObstruction with hw'
  have hw : 0 < w := wObstruction_pos
  have hw1 : w ≤ 1 := wObstruction_le_one
  have hlogw : -Real.log w / 6 = K := by
    rw [hw', wObstruction, Real.log_exp, hK, hC]
    ring
  -- the analytic value of the functional on the bump
  have hg := (normalizedTraceIdentity_iff_traceDensity U).1 h (logBump w hw)
  rw [logTest_logBump hw] at hg
  have hDle : (Dcomplex (ofLog (triC w))).re ≤ 16 * Si π + 16 := by
    have := Dcomplex_ofLog_re_le (g := triReal w) (continuous_triReal w)
      (fun t => triReal_nonneg w t) (fun t => triReal_le_one hw t)
    simpa [triC] using this
  have hD0 : 0 ≤ (Dcomplex (ofLog (triC w))).re := by
    have := zero_le_Dcomplex_ofLog_re (g := triReal w) (continuous_triReal w)
      (fun t => triReal_nonneg w t) (fun t => triReal_le_one hw t)
    simpa [triC] using this
  have hlow : K - |weilConst| ≤ (LfunNorm (triC w)).re := by
    rw [LfunNorm_triC_re hw]
    have hs : K ≤ sinhDeficit w := by
      rw [← hlogw]
      exact sinhDeficit_ge hw hw1
    have hwc : weilConst ≤ |weilConst| := le_abs_self _
    linarith
  -- the trace value of the functional on the bump
  have hup : (LfunNorm (triC w)).re ≤ 2 * C := by
    rw [hg]
    have h1 : (∫ lam, (logBump w hw) lam * traceDensityStd U lam ∂(Rplus.haar)).re
        ≤ ‖∫ lam, (logBump w hw) lam * traceDensityStd U lam ∂(Rplus.haar)‖ :=
      Complex.re_le_norm _
    have h2 := norm_integral_mul_traceDensityStd_le U (logBump w hw)
    have h3 : (∫ lam, ‖(logBump w hw) lam‖ ∂(Rplus.haar)) ≤ 2 * w :=
      integral_norm_logBump_le hw
    have h4 : C * (∫ lam, ‖(logBump w hw) lam‖ ∂(Rplus.haar)) ≤ C * (2 * w) :=
      mul_le_mul_of_nonneg_left h3 hC0
    have h5 : C * (2 * w) ≤ 2 * C := by nlinarith
    linarith
  have hSi : 0 < Si π := Si_pi_pos
  rw [hK] at hlow
  linarith

end ConnesConsani.WeilPositivity
