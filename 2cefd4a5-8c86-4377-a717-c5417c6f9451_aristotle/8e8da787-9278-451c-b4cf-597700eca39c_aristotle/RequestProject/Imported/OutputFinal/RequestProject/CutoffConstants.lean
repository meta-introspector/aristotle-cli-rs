/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
Authors: Formalization of
  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771

**Explicit values for the constants of the cut-off logarithmic profile.**

`RequestProject/CutoffLogProfile.lean` establishes the logarithmic profile of the cut-off
trace of the reference bump in *existential* form (`∃ z₀, HasCutoffLogProfile b refBump 4 z₀`).
For the evaluation of the universal constant of the renormalized trace formula the actual
value is needed.  This file simply names the limits which the proofs there already exhibit:

* `siLogConst = Φ(1) + ∫_1^∞ (Si s - π/2) ds/s`, the finite part of `Φ(X) = ∫_0^X Si(s) ds/s`
  against `(π/2) log X`;
* `thetaAVal = ∫ tri(u) sgn(u) (π/2) w(u) du`, the limit of the regular piece `thetaA`;
* `zRef = thetaAVal + (4/π)(siLogConst - π/2) + 2 log (2π)`, the finite part of the
  logarithmic profile of the reference bump.

All the analytic content is already in `CutoffLogProfile.lean`; the statements below are the
same limits with the witnesses written out.
-/
import RequestProject.Imported.OutputFinal.RequestProject.CutoffLogProfile

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory Filter Topology Set Real

open scoped CompactlySupported

namespace ConnesConsani.WeilPositivity

variable {ι : Type*}

/-! ## 1. The sine-integral logarithm constant -/

/-- **The universal sine-integral constant**
`K = ∫_0^1 Si(s) ds/s + ∫_1^∞ (Si s - π/2) ds/s`, i.e. the finite part of
`∫_0^X Si(s) ds/s` relative to `(π/2) log X`. -/
def siLogConst : ℝ := siDivInt 1 + ∫ s in Ioi (1:ℝ), (Si s - π / 2) / s

theorem tendsto_siDivInt_sub_log :
    Tendsto (fun X : ℝ => siDivInt X - π / 2 * Real.log X) atTop (𝓝 siLogConst) := by
  set g : ℝ → ℝ := fun s => (Si s - π / 2) / s with hgdef
  have hgcont : Continuous fun s : ℝ => Si s - π / 2 := Si_continuous.sub continuous_const
  have hdom : IntegrableOn (fun s : ℝ => 2 * s ^ (-2:ℝ)) (Ioi 1) volume :=
    (integrableOn_Ioi_rpow_of_lt (by norm_num) zero_lt_one).const_mul 2
  have hgmeas : Measurable g :=
    (Si_continuous.measurable.sub measurable_const).div measurable_id
  have hgint : IntegrableOn g (Ioi 1) volume := by
    refine hdom.mono' hgmeas.aestronglyMeasurable ?_
    filter_upwards [self_mem_ae_restrict measurableSet_Ioi] with s hs
    have hs1 : (1:ℝ) < s := hs
    have hs0 : (0:ℝ) < s := lt_trans zero_lt_one hs1
    have hrpow : s ^ (-2:ℝ) = (s ^ 2)⁻¹ := by
      rw [show (-2:ℝ) = -((2:ℕ):ℝ) by norm_num, Real.rpow_neg hs0.le, Real.rpow_natCast]
    have hnum : |Si s - π / 2| ≤ 2 / s := by
      have hbd := abs_Si_sub_pi_div_two_le hs0
      have h1 : 1 / s ^ 2 ≤ 1 / s := by
        apply one_div_le_one_div_of_le hs0
        nlinarith
      have h2 : (2:ℝ) / s = 1 / s + 1 / s := by ring
      linarith
    rw [Real.norm_eq_abs, hgdef]
    simp only
    rw [abs_div, abs_of_pos hs0, hrpow, div_le_iff₀ hs0]
    have h2 : 2 * (s ^ 2)⁻¹ * s = 2 / s := by field_simp
    rw [h2]
    exact hnum
  have hlim : Tendsto (fun X : ℝ => siDivInt 1 + ∫ s in (1:ℝ)..X, g s) atTop
      (𝓝 (siDivInt 1 + ∫ s in Ioi (1:ℝ), g s)) :=
    (MeasureTheory.intervalIntegral_tendsto_integral_Ioi 1 hgint tendsto_id).const_add _
  refine hlim.congr' ?_
  filter_upwards [eventually_ge_atTop (1:ℝ)] with X hX
  have hpos : ∀ s ∈ Set.uIcc (1:ℝ) X, s ≠ 0 := by
    intro s hs
    rw [Set.uIcc_of_le hX] at hs
    exact ne_of_gt (lt_of_lt_of_le zero_lt_one hs.1)
  have hsplit : Set.EqOn siDiv (fun s => π / 2 * (1 / s) + g s) (Set.uIcc (1:ℝ) X) := by
    intro s hs
    have hs0 : s ≠ 0 := hpos s hs
    rw [siDiv_of_ne_zero hs0, hgdef]
    field_simp
    ring
  have hinvint : IntervalIntegrable (fun s : ℝ => π / 2 * (1 / s)) volume 1 X :=
    (ContinuousOn.intervalIntegrable (by
      exact (continuousOn_const.mul ((continuousOn_const.div continuousOn_id) hpos))))
  have hgii : IntervalIntegrable g volume 1 X :=
    (ContinuousOn.intervalIntegrable
      (by exact (hgcont.continuousOn.div continuousOn_id hpos)))
  have hadj : siDivInt 1 + ∫ s in (1:ℝ)..X, siDiv s = siDivInt X := by
    rw [siDivInt, siDivInt]
    exact intervalIntegral.integral_add_adjacent_intervals
      (siDiv_continuous.intervalIntegrable _ _) (siDiv_continuous.intervalIntegrable _ _)
  have hlog : (∫ s in (1:ℝ)..X, π / 2 * (1 / s)) = π / 2 * Real.log X := by
    rw [intervalIntegral.integral_const_mul, integral_one_div (by
      rw [Set.uIcc_of_le hX]
      intro h
      exact absurd h.1 (by norm_num)), div_one]
  rw [← hadj, intervalIntegral.integral_congr hsplit,
    intervalIntegral.integral_add hinvint hgii, hlog]
  ring

/-! ## 2. The three pieces of the logarithmic profile -/

/-- The limit of the regular piece `thetaA`. -/
def thetaAVal : ℝ := ∫ u : ℝ, triReal 1 u * (if 0 < u then π / 2 else -(π / 2)) * wKer u

theorem tendsto_thetaA : Tendsto thetaA atTop (𝓝 thetaAVal) := by
  rw [thetaAVal]
  refine MeasureTheory.tendsto_integral_filter_of_dominated_convergence
    ((Icc (-1:ℝ) 1).indicator (fun _ => Si π * (1 / π))) ?_ ?_ ?_ ?_
  · exact .of_forall fun T => (integrable_thetaA_integrand T).aestronglyMeasurable
  · refine .of_forall fun T => .of_forall fun u => ?_
    by_cases hu : u ∈ Icc (-1:ℝ) 1
    · rw [Set.indicator_of_mem hu, Real.norm_eq_abs]
      have huabs : |u| ≤ 1 := abs_le.2 ⟨hu.1, hu.2⟩
      calc |triReal 1 u * Si (T * psiCut u) * wKer u|
          ≤ 1 * Si π * (1 / π) :=
            abs_mul₃_le (abs_triReal_one_le u) (abs_Si_le_Si_pi _) (abs_wKer_le huabs)
              Si_pi_nonneg
        _ = Si π * (1 / π) := by ring
    · rw [Set.indicator_of_notMem hu, triReal_eq_zero_of_one_lt (one_lt_abs_of_not_mem_Icc hu)]
      simp
  · rw [integrable_indicator_iff measurableSet_Icc]
    exact integrableOn_const measure_Icc_lt_top.ne
  · have hae : ∀ᵐ u : ℝ, u ≠ 0 := by rw [ae_iff]; simp
    filter_upwards [hae] with u hu
    exact ((tendsto_Si_mul_psiCut hu).const_mul (triReal 1 u)).mul_const (wKer u)

theorem tendsto_thetaC_sub_log :
    Tendsto (fun T : ℝ => thetaC T - 2 * Real.log T) atTop
      (𝓝 (4 / π * (siLogConst - π / 2))) := by
  have hlim : Tendsto
      (fun T : ℝ => 4 / π * ((siDivInt T - π / 2 * Real.log T) - ∫ u in (0:ℝ)..1, Si (T * u)))
      atTop (𝓝 (4 / π * (siLogConst - π / 2))) :=
    (tendsto_siDivInt_sub_log.sub tendsto_integral_Si_mul).const_mul (4 / π)
  refine hlim.congr' ?_
  filter_upwards [eventually_gt_atTop (0:ℝ)] with T hT
  rw [thetaC_eq hT]
  have hpi : π ≠ 0 := ne_of_gt Real.pi_pos
  field_simp
  ring

theorem tendsto_theta_sub_log :
    Tendsto (fun T : ℝ => theta T - 2 * Real.log T) atTop
      (𝓝 (thetaAVal + 4 / π * (siLogConst - π / 2))) := by
  have h := ((tendsto_thetaA.add tendsto_thetaB).add tendsto_thetaC_sub_log)
  have hval : thetaAVal + 0 + 4 / π * (siLogConst - π / 2)
      = thetaAVal + 4 / π * (siLogConst - π / 2) := by ring
  rw [hval] at h
  refine h.congr' ?_
  filter_upwards [eventually_gt_atTop (0:ℝ)] with T hT
  rw [theta_eq_add hT]
  ring

/-! ## 3. The logarithmic profile of the reference bump, with explicit finite part -/

/-- **The finite part of the logarithmic profile of the reference triangular bump**,
`Tr(ϑ(h) S^{(Λ)}) = 4 log Λ + zRef + o(1)`. -/
def zRef : ℝ := thetaAVal + 4 / π * (siLogConst - π / 2) + 2 * Real.log (2 * π)

theorem hasCutoffLogProfile_refBump [Countable ι] (b : HilbertBasis ι ℂ L2R) :
    HasCutoffLogProfile b refBump 4 ((zRef : ℝ) : ℂ) := by
  have hTtop : Tendsto (fun cut : ℝ => 2 * π * cut ^ 2) atTop atTop := by
    have h1 : Tendsto (fun cut : ℝ => cut ^ 2) atTop atTop := tendsto_pow_atTop two_ne_zero
    exact Filter.Tendsto.const_mul_atTop (by positivity) h1
  have hreal : Tendsto
      (fun cut : ℝ => theta (2 * π * cut ^ 2) - 2 * Real.log (2 * π * cut ^ 2)) atTop
      (𝓝 (thetaAVal + 4 / π * (siLogConst - π / 2))) :=
    tendsto_theta_sub_log.comp hTtop
  have hreal2 : Tendsto
      (fun cut : ℝ => theta (2 * π * cut ^ 2) - 4 * Real.log cut) atTop (𝓝 zRef) := by
    have hadd := hreal.add_const (2 * Real.log (2 * π))
    rw [show thetaAVal + 4 / π * (siLogConst - π / 2) + 2 * Real.log (2 * π) = zRef from rfl]
      at hadd
    refine hadd.congr' ?_
    filter_upwards [eventually_gt_atTop (0:ℝ)] with cut hcut
    have hlog : Real.log (2 * π * cut ^ 2) = Real.log (2 * π) + 2 * Real.log cut := by
      rw [Real.log_mul (by positivity) (by positivity), Real.log_pow]
      push_cast
      ring
    rw [hlog]
    ring
  have hcomplex : Tendsto
      (fun cut : ℝ => (((theta (2 * π * cut ^ 2) - 4 * Real.log cut : ℝ)) : ℂ)) atTop
      (𝓝 ((zRef : ℝ) : ℂ)) :=
    (Complex.continuous_ofReal.tendsto _).comp hreal2
  refine hcomplex.congr' ?_
  filter_upwards [eventually_ge_atTop (0:ℝ)] with cut hcut
  rw [modelCutTrace_refBump b hcut]
  push_cast
  ring

end ConnesConsani.WeilPositivity
