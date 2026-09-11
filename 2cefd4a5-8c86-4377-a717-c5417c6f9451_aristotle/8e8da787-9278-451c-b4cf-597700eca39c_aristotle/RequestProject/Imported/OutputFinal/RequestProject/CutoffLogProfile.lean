/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
Authors: Formalization of
  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771

**The logarithmic profile of the cut-off trace, and the full asymptotic expansion.**

`RequestProject/RenormalizedFinitePart.lean` reduced the asymptotic expansion of the cut-off
trace `Tr(ϑ(f) S^{(Λ)})` of the semi-local model to the *logarithmic profile*
`HasCutoffLogProfile` of one single reference test function.  This file computes that
profile, and thereby makes the whole expansion unconditional.

In the logarithmic coordinate `λ = e^u` and with `T = 2π Λ²` the closed form of the
semi-local density (`RequestProject/SemiLocalSi.lean`) reads

  `κ_Λ(e^u) = Si(T ψ(u)) / (π sinh(u/2))`,   `ψ(u) = (e^u - 1)/max(1, e^u)`.

Pairing it with the triangular bump `tri(u) = max(0, 1 - |u|)` and splitting

  `Si(T ψ(u))/(π sinh(u/2))
     = Si(T ψ(u)) · w(u) + (Si(T ψ(u)) - Si(T u)) · 2/(π u) + Si(T u) · 2/(π u)`,

with `w(u) = 1/(π sinh(u/2)) - 2/(π u)` bounded, the first two terms converge (the second to
`0`, by the uniform bound `|Si(Tψ(u)) - Si(Tu)| ≤ 2|u|`), while the third is
`(4/π)(∫_0^T Si(s)/s ds - ∫_0^1 Si(Tu) du) = 2 log T + O(1)`.  Hence

  `Tr(ϑ(h) S^{(Λ)}) = 4 log Λ + z₀ + o(1)`

for the reference bump `h`, and the expansion of `RenormalizedAsymptotics.lean` becomes
unconditional.
-/
import RequestProject.Imported.OutputFinal.RequestProject.CutoffLogProfileAux
import RequestProject.Imported.OutputFinal.RequestProject.RenormalizedAsymptotics
import RequestProject.Imported.OutputFinal.RequestProject.TraceIdentityObstruction

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory Filter Topology Set Real

open scoped CompactlySupported

namespace ConnesConsani.WeilPositivity

variable {ι : Type*}

/-! ## 1. The semi-local density in the logarithmic coordinate -/

/-- The semi-local trace density in the logarithmic coordinate `a = e^u`, with
`T = 2π Λ²`:  `κ_Λ(e^u) = Si(T ψ(u)) / (π sinh(u/2))`. -/
def logDens (T u : ℝ) : ℝ := Si (T * psiCut u) / (π * Real.sinh (u / 2))

theorem semiLocal_formula_eq (cut u : ℝ) (hu : u ≠ 0) :
    Real.sqrt (Real.exp u) * (2 / (π * (Real.exp u - 1))) *
        Si (2 * π * (Real.exp u - 1) * (cut / max 1 (Real.exp u)) * cut)
      = logDens (2 * π * cut ^ 2) u := by
  have hmax : (0:ℝ) < max 1 (Real.exp u) := lt_of_lt_of_le zero_lt_one (le_max_left _ _)
  have hne : Real.exp u - 1 ≠ 0 := by
    intro h
    exact hu ((Real.exp_eq_one_iff u).1 (by linarith))
  have hsinh : Real.sinh (u / 2) ≠ 0 := Real.sinh_ne_zero.mpr (by simpa using hu)
  have harg : 2 * π * (Real.exp u - 1) * (cut / max 1 (Real.exp u)) * cut
      = 2 * π * cut ^ 2 * psiCut u := by
    rw [psiCut]; field_simp
  have hmain : 2 * Real.exp (u / 2) * Real.sinh (u / 2) = Real.exp u - 1 := by
    rw [Real.sinh_eq]
    have hexp : Real.exp (u / 2) * Real.exp (-(u / 2)) = 1 := by rw [← Real.exp_add]; simp
    have hsq : Real.exp (u / 2) * Real.exp (u / 2) = Real.exp u := by
      rw [← Real.exp_add]; ring_nf
    nlinarith [hexp, hsq]
  rw [harg, logDens, (Real.exp_half u).symm]
  field_simp
  linear_combination Si (2 * π * cut ^ 2 * psiCut u) * hmain

theorem semiLocalDensity_expHomeo [Countable ι] (b : HilbertBasis ι ℂ L2R) {cut : ℝ}
    (hcut : 0 ≤ cut) {u : ℝ} (hu : u ≠ 0) :
    semiLocalDensity b cut (Rplus.expHomeo u) = ((logDens (2 * π * cut ^ 2) u : ℝ) : ℂ) := by
  have hne : ((Rplus.expHomeo u : Rplus) : ℝ) ≠ 1 := by
    simp only [Rplus.expHomeo_apply]
    intro h
    exact hu ((Real.exp_eq_one_iff u).1 h)
  rw [semiLocalDensity_eq_Si b hcut _ hne]
  simp only [Rplus.expHomeo_apply]
  norm_cast
  exact semiLocal_formula_eq cut u hu

/-- **The cut-off trace in the logarithmic coordinate.** -/
theorem modelCutTrace_eq_integral_logDens [Countable ι] (b : HilbertBasis ι ℂ L2R) {cut : ℝ}
    (hcut : 0 ≤ cut) (g : C_c(Rplus, ℂ)) :
    modelCutTrace b cut g
      = ∫ u : ℝ, g ((Rplus.expHomeo u)⁻¹) * ((logDens (2 * π * cut ^ 2) u : ℝ) : ℂ) := by
  have h1 : (∫ lam, g lam * scalingDensity b cut lam ∂(Rplus.haar))
      = ∫ lam, (fun ρ : Rplus => g ρ⁻¹ * semiLocalDensity b cut ρ) lam⁻¹ ∂(Rplus.haar) := by
    refine integral_congr_ae (.of_forall fun lam => ?_)
    simp [scalingDensity, inv_inv]
  have h2 := Rplus.integral_haar_inv (fun ρ : Rplus => g ρ⁻¹ * semiLocalDensity b cut ρ)
  have h3 := Rplus.integral_haar (fun ρ : Rplus => g ρ⁻¹ * semiLocalDensity b cut ρ)
  rw [modelCutTrace, h1, h2, h3]
  have hae : ∀ᵐ u : ℝ, u ≠ 0 := by rw [ae_iff]; simp
  refine integral_congr_ae ?_
  filter_upwards [hae] with u hu
  rw [semiLocalDensity_expHomeo b hcut hu]

/-! ## 2. The three pieces of the logarithmic profile -/

/-- The difference between the hyperbolic kernel and the pure pole. -/
def wKer (u : ℝ) : ℝ := 1 / (π * Real.sinh (u / 2)) - 2 / (π * u)

theorem measurable_wKer : Measurable wKer := by
  unfold wKer
  exact (measurable_const.div ((measurable_const.mul
    (Real.continuous_sinh.measurable.comp (measurable_id.div_const 2))))).sub
      (measurable_const.div (measurable_const.mul measurable_id))

theorem abs_wKer_le {u : ℝ} (hu : |u| ≤ 1) : |wKer u| ≤ 1 / π := by
  rcases eq_or_ne u 0 with rfl | hu0
  · simp [wKer]
    positivity
  · have h := abs_inv_sinh_half_sub_le hu0 (by linarith)
    have hrw : wKer u = (1 / π) * (1 / Real.sinh (u / 2) - 2 / u) := by
      rw [wKer]; field_simp
    rw [hrw, abs_mul, abs_of_nonneg (by positivity : (0:ℝ) ≤ 1 / π)]
    nlinarith [abs_nonneg (1 / Real.sinh (u / 2) - 2 / u), one_div_pos.2 Real.pi_pos]

/-- The full logarithmic profile of the reference bump. -/
def theta (T : ℝ) : ℝ := ∫ u : ℝ, triReal 1 u * logDens T u

/-- The contribution of the *regular* part of the hyperbolic kernel. -/
def thetaA (T : ℝ) : ℝ := ∫ u : ℝ, triReal 1 u * Si (T * psiCut u) * wKer u

/-- The contribution of the compression `ψ`. -/
def thetaB (T : ℝ) : ℝ :=
  ∫ u : ℝ, triReal 1 u * (Si (T * psiCut u) - Si (T * u)) * (2 / (π * u))

/-- The model contribution `∫ tri(u) Si(T u) · 2/(π u) du`, which carries the logarithmic
divergence. -/
def thetaC (T : ℝ) : ℝ := ∫ u : ℝ, triReal 1 u * Si (T * u) * (2 / (π * u))

/-- The primitive `Φ(X) = ∫_0^X Si(s)/s ds`. -/
def siDivInt (X : ℝ) : ℝ := ∫ s in (0:ℝ)..X, siDiv s

/-! ### Integrability -/

theorem abs_mul₃_le {a b c A B C : ℝ} (ha : |a| ≤ A) (hb : |b| ≤ B) (hc : |c| ≤ C)
    (hB : 0 ≤ B) : |a * b * c| ≤ A * B * C := by
  have hA : 0 ≤ A := le_trans (abs_nonneg a) ha
  rw [abs_mul, abs_mul]
  exact mul_le_mul (mul_le_mul ha hb (abs_nonneg _) hA) hc (abs_nonneg _) (by positivity)

theorem integrable_of_bdd_supp {f : ℝ → ℝ} (hf : Measurable f) {C : ℝ}
    (hb : ∀ u, |f u| ≤ C) (hs : ∀ u, 1 < |u| → f u = 0) : Integrable f volume := by
  have hind : f = (Icc (-1:ℝ) 1).indicator f := by
    funext u
    by_cases h : u ∈ Icc (-1:ℝ) 1
    · rw [Set.indicator_of_mem h]
    · have habs : 1 < |u| := by
        simp only [Set.mem_Icc, not_and_or, not_le] at h
        rcases h with h | h
        · rw [abs_of_neg (by linarith)]; linarith
        · rw [abs_of_pos (by linarith)]; linarith
      rw [Set.indicator_of_notMem h, hs u habs]
  rw [hind, integrable_indicator_iff measurableSet_Icc]
  exact Measure.integrableOn_of_bounded measure_Icc_lt_top.ne hf.aestronglyMeasurable
    (.of_forall fun u => by simpa [Real.norm_eq_abs] using hb u)

theorem triReal_eq_zero_of_one_lt {u : ℝ} (hu : 1 < |u|) : triReal 1 u = 0 :=
  triReal_eq_zero one_pos hu.le

theorem measurable_triReal_one : Measurable (triReal 1) := (continuous_triReal 1).measurable

theorem abs_triReal_one_le (u : ℝ) : |triReal 1 u| ≤ 1 := by
  rw [abs_of_nonneg (triReal_nonneg 1 u)]
  exact triReal_le_one one_pos u

theorem Si_pi_nonneg : 0 ≤ Si π := le_trans (abs_nonneg _) (abs_Si_le_Si_pi π)

theorem one_lt_abs_of_not_mem_Icc {u : ℝ} (hu : u ∉ Icc (-1:ℝ) 1) : 1 < |u| := by
  simp only [Set.mem_Icc, not_and_or, not_le] at hu
  rcases hu with h | h
  · rw [abs_of_neg (by linarith)]; linarith
  · rw [abs_of_pos (by linarith)]; linarith

theorem abs_two_div_pi_mul_le (u : ℝ) : |2 / (π * u)| ≤ 2 / (π * |u|) := by
  rw [abs_div, abs_mul, abs_of_pos Real.pi_pos]
  norm_num

theorem integrable_thetaA_integrand (T : ℝ) :
    Integrable (fun u : ℝ => triReal 1 u * Si (T * psiCut u) * wKer u) volume := by
  refine integrable_of_bdd_supp
    ((measurable_triReal_one.mul
      (Si_continuous.measurable.comp (measurable_const.mul measurable_psiCut))).mul
        measurable_wKer) (C := Si π * (1 / π)) (fun u => ?_) (fun u hu => ?_)
  · by_cases hu : |u| ≤ 1
    · calc |triReal 1 u * Si (T * psiCut u) * wKer u|
          ≤ 1 * Si π * (1 / π) :=
            abs_mul₃_le (abs_triReal_one_le u) (abs_Si_le_Si_pi _) (abs_wKer_le hu)
              Si_pi_nonneg
        _ = Si π * (1 / π) := by ring
    · rw [triReal_eq_zero_of_one_lt (by linarith [not_le.1 hu])]
      simp only [zero_mul, abs_zero]
      have := Si_pi_nonneg
      positivity
  · rw [triReal_eq_zero_of_one_lt hu]; ring

theorem integrable_thetaB_integrand {T : ℝ} (hT : 0 < T) :
    Integrable (fun u : ℝ =>
      triReal 1 u * (Si (T * psiCut u) - Si (T * u)) * (2 / (π * u))) volume := by
  refine integrable_of_bdd_supp
    ((measurable_triReal_one.mul
      ((Si_continuous.measurable.comp (measurable_const.mul measurable_psiCut)).sub
        (Si_continuous.measurable.comp (measurable_const.mul measurable_id)))).mul
          (measurable_const.div (measurable_const.mul measurable_id)))
    (C := 4 / π) (fun u => ?_) (fun u hu => ?_)
  · by_cases hu : |u| ≤ 1
    · rcases eq_or_ne u 0 with rfl | hu0
      · norm_num
        positivity
      · have habs : (0:ℝ) < |u| := abs_pos.2 hu0
        calc |triReal 1 u * (Si (T * psiCut u) - Si (T * u)) * (2 / (π * u))|
            ≤ 1 * (2 * |u|) * (2 / (π * |u|)) :=
              abs_mul₃_le (abs_triReal_one_le u)
                (abs_Si_psi_sub_Si_le_two_abs hT hu0 hu) (abs_two_div_pi_mul_le u)
                (by positivity)
          _ = 4 / π := by field_simp; ring
    · rw [triReal_eq_zero_of_one_lt (by linarith [not_le.1 hu])]
      simp only [zero_mul, abs_zero]
      positivity
  · rw [triReal_eq_zero_of_one_lt hu]; ring

theorem integrable_thetaC_integrand (T : ℝ) :
    Integrable (fun u : ℝ => triReal 1 u * Si (T * u) * (2 / (π * u))) volume := by
  refine integrable_of_bdd_supp
    ((measurable_triReal_one.mul
      (Si_continuous.measurable.comp (measurable_const.mul measurable_id))).mul
        (measurable_const.div (measurable_const.mul measurable_id)))
    (C := 2 * |T| / π) (fun u => ?_) (fun u hu => ?_)
  · by_cases hu : |u| ≤ 1
    · rcases eq_or_ne u 0 with rfl | hu0
      · norm_num
        positivity
      · have habs : (0:ℝ) < |u| := abs_pos.2 hu0
        have h2 : |Si (T * u)| ≤ |T| * |u| := by
          refine le_trans (abs_Si_le_abs _) ?_
          rw [abs_mul]
        calc |triReal 1 u * Si (T * u) * (2 / (π * u))|
            ≤ 1 * (|T| * |u|) * (2 / (π * |u|)) :=
              abs_mul₃_le (abs_triReal_one_le u) h2 (abs_two_div_pi_mul_le u)
                (by positivity)
          _ = 2 * |T| / π := by field_simp
    · rw [triReal_eq_zero_of_one_lt (by linarith [not_le.1 hu])]
      simp only [zero_mul, abs_zero]
      positivity
  · rw [triReal_eq_zero_of_one_lt hu]; ring

/-! ### The decomposition -/

theorem theta_eq_add {T : ℝ} (hT : 0 < T) : theta T = thetaA T + thetaB T + thetaC T := by
  have hpt : ∀ u : ℝ, triReal 1 u * logDens T u
      = triReal 1 u * Si (T * psiCut u) * wKer u
        + triReal 1 u * (Si (T * psiCut u) - Si (T * u)) * (2 / (π * u))
        + triReal 1 u * Si (T * u) * (2 / (π * u)) := by
    intro u
    have hk : wKer u + 2 / (π * u) = 1 / (π * Real.sinh (u / 2)) := by
      rw [wKer]; ring
    have hd : logDens T u = Si (T * psiCut u) * (1 / (π * Real.sinh (u / 2))) := by
      rw [logDens]; ring
    rw [hd, ← hk]
    ring
  have hA := integrable_thetaA_integrand T
  have hB := integrable_thetaB_integrand hT
  have hC := integrable_thetaC_integrand T
  have hsplit : (∫ u, triReal 1 u * logDens T u)
      = ∫ u, ((triReal 1 u * Si (T * psiCut u) * wKer u
            + triReal 1 u * (Si (T * psiCut u) - Si (T * u)) * (2 / (π * u)))
          + triReal 1 u * Si (T * u) * (2 / (π * u))) :=
    integral_congr_ae (.of_forall fun u => by simpa using hpt u)
  have e1 : (∫ u, ((triReal 1 u * Si (T * psiCut u) * wKer u
            + triReal 1 u * (Si (T * psiCut u) - Si (T * u)) * (2 / (π * u)))
          + triReal 1 u * Si (T * u) * (2 / (π * u))))
      = (∫ u, (triReal 1 u * Si (T * psiCut u) * wKer u
            + triReal 1 u * (Si (T * psiCut u) - Si (T * u)) * (2 / (π * u))))
        + ∫ u, triReal 1 u * Si (T * u) * (2 / (π * u)) :=
    integral_add (hA.add hB) hC
  have e2 : (∫ u, (triReal 1 u * Si (T * psiCut u) * wKer u
            + triReal 1 u * (Si (T * psiCut u) - Si (T * u)) * (2 / (π * u))))
      = (∫ u, triReal 1 u * Si (T * psiCut u) * wKer u)
        + ∫ u, triReal 1 u * (Si (T * psiCut u) - Si (T * u)) * (2 / (π * u)) :=
    integral_add hA hB
  rw [theta, thetaA, thetaB, thetaC, hsplit, e1, e2]

/-! ## 3. The limits of the three pieces -/

/-- `Si(T ψ(u)) → ±π/2` as `T → ∞`. -/
theorem tendsto_Si_mul_psiCut {u : ℝ} (hu : u ≠ 0) :
    Tendsto (fun T : ℝ => Si (T * psiCut u)) atTop
      (𝓝 (if 0 < u then π / 2 else -(π / 2))) := by
  rcases lt_or_gt_of_ne hu with h | h
  · have hpsi : psiCut u < 0 := by
      have hp := psiCut_pos (u := -u) (by linarith)
      rw [psiCut_neg] at hp
      linarith
    have hlim : Tendsto (fun T : ℝ => T * (-psiCut u)) atTop atTop :=
      Filter.Tendsto.atTop_mul_const (by linarith) tendsto_id
    have h2 : Tendsto (fun T : ℝ => Si (T * (-psiCut u))) atTop (𝓝 (π / 2)) :=
      tendsto_Si_atTop.comp hlim
    have hrw : ∀ T : ℝ, Si (T * psiCut u) = -Si (T * (-psiCut u)) := by
      intro T
      rw [show T * (-psiCut u) = -(T * psiCut u) by ring, Si_neg]
      ring
    simp only [hrw, if_neg (not_lt.2 h.le)]
    exact h2.neg
  · have hlim : Tendsto (fun T : ℝ => T * psiCut u) atTop atTop :=
      Filter.Tendsto.atTop_mul_const (psiCut_pos h) tendsto_id
    simpa [if_pos h] using tendsto_Si_atTop.comp hlim

theorem tendsto_Si_mul_self {u : ℝ} (hu : u ≠ 0) :
    Tendsto (fun T : ℝ => Si (T * u)) atTop (𝓝 (if 0 < u then π / 2 else -(π / 2))) := by
  rcases lt_or_gt_of_ne hu with h | h
  · have hlim : Tendsto (fun T : ℝ => T * (-u)) atTop atTop :=
      Filter.Tendsto.atTop_mul_const (by linarith) tendsto_id
    have h2 : Tendsto (fun T : ℝ => Si (T * (-u))) atTop (𝓝 (π / 2)) :=
      tendsto_Si_atTop.comp hlim
    have hrw : ∀ T : ℝ, Si (T * u) = -Si (T * (-u)) := by
      intro T
      rw [show T * (-u) = -(T * u) by ring, Si_neg]
      ring
    simp only [hrw, if_neg (not_lt.2 h.le)]
    exact h2.neg
  · have hlim : Tendsto (fun T : ℝ => T * u) atTop atTop :=
      Filter.Tendsto.atTop_mul_const h tendsto_id
    simpa [if_pos h] using tendsto_Si_atTop.comp hlim

theorem exists_tendsto_thetaA : ∃ a : ℝ, Tendsto thetaA atTop (𝓝 a) := by
  refine ⟨∫ u : ℝ, triReal 1 u * (if 0 < u then π / 2 else -(π / 2)) * wKer u, ?_⟩
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

theorem tendsto_thetaB : Tendsto thetaB atTop (𝓝 0) := by
  have h0 : (0:ℝ) = ∫ _u : ℝ, (0:ℝ) := by simp
  rw [h0]
  refine MeasureTheory.tendsto_integral_filter_of_dominated_convergence
    ((Icc (-1:ℝ) 1).indicator (fun _ => 4 / π)) ?_ ?_ ?_ ?_
  · filter_upwards [eventually_gt_atTop (0:ℝ)] with T hT
    exact (integrable_thetaB_integrand hT).aestronglyMeasurable
  · filter_upwards [eventually_gt_atTop (0:ℝ)] with T hT
    refine .of_forall fun u => ?_
    by_cases hu : u ∈ Icc (-1:ℝ) 1
    · rw [Set.indicator_of_mem hu, Real.norm_eq_abs]
      have huabs : |u| ≤ 1 := abs_le.2 ⟨hu.1, hu.2⟩
      rcases eq_or_ne u 0 with rfl | hu0
      · norm_num
        positivity
      · have habs : (0:ℝ) < |u| := abs_pos.2 hu0
        calc |triReal 1 u * (Si (T * psiCut u) - Si (T * u)) * (2 / (π * u))|
            ≤ 1 * (2 * |u|) * (2 / (π * |u|)) :=
              abs_mul₃_le (abs_triReal_one_le u)
                (abs_Si_psi_sub_Si_le_two_abs hT hu0 huabs) (abs_two_div_pi_mul_le u)
                (by positivity)
          _ = 4 / π := by field_simp; ring
    · rw [Set.indicator_of_notMem hu, triReal_eq_zero_of_one_lt (one_lt_abs_of_not_mem_Icc hu)]
      simp
  · rw [integrable_indicator_iff measurableSet_Icc]
    exact integrableOn_const measure_Icc_lt_top.ne
  · have hae : ∀ᵐ u : ℝ, u ≠ 0 := by rw [ae_iff]; simp
    filter_upwards [hae] with u hu
    have h1 := tendsto_Si_mul_psiCut hu
    have h2 := tendsto_Si_mul_self hu
    have h3 : Tendsto (fun T : ℝ => Si (T * psiCut u) - Si (T * u)) atTop (𝓝 0) := by
      simpa using h1.sub h2
    simpa using (h3.const_mul (triReal 1 u)).mul_const (2 / (π * u))

/-! ### The model piece `thetaC` -/

/-- `t · siDiv t = Si t`, valid also at `t = 0`. -/
theorem mul_siDiv_eq_Si (t : ℝ) : t * siDiv t = Si t := by
  rcases eq_or_ne t 0 with rfl | ht
  · simp
  · rw [siDiv_of_ne_zero ht]; field_simp

theorem thetaC_eq {T : ℝ} (hT : 0 < T) :
    thetaC T = 4 / π * (siDivInt T - ∫ u in (0:ℝ)..1, Si (T * u)) := by
  have hTne : T ≠ 0 := ne_of_gt hT
  have hpi : (π:ℝ) ≠ 0 := ne_of_gt Real.pi_pos
  set F : ℝ → ℝ := fun t => 2 * T / π * triReal 1 t * siDiv (T * t) with hFdef
  have hFcont : Continuous F :=
    (continuous_const.mul (continuous_triReal 1)).mul
      (siDiv_continuous.comp (continuous_const.mul continuous_id))
  have hFzero : ∀ t : ℝ, 1 < |t| → F t = 0 := by
    intro t ht
    simp [hFdef, triReal_eq_zero one_pos ht.le]
  have hFint : Integrable F volume :=
    hFcont.integrable_of_hasCompactSupport
      (HasCompactSupport.intro (isCompact_Icc (a := (-1:ℝ)) (b := 1)) fun t ht =>
        hFzero t (one_lt_abs_of_not_mem_Icc ht))
  -- Step 1: the integrand of `thetaC` is (a.e.) the even function `t ↦ F |t|`.
  have hae : (fun u : ℝ => triReal 1 u * Si (T * u) * (2 / (π * u)))
      =ᵐ[volume] fun u : ℝ => F |u| := by
    have h0 : ∀ᵐ u : ℝ, u ≠ 0 := by rw [ae_iff]; simp
    filter_upwards [h0] with u hu
    have habs : triReal 1 |u| = triReal 1 u := by simp [triReal]
    have hsi : siDiv (T * |u|) = siDiv (T * u) := by
      rcases abs_cases u with ⟨h, _⟩ | ⟨h, _⟩
      · rw [h]
      · rw [h, mul_neg, siDiv_neg]
    have hne : T * u ≠ 0 := mul_ne_zero hTne hu
    simp only [hFdef, habs, hsi, siDiv_of_ne_zero hne]
    field_simp
  have h1 : thetaC T = 2 * ∫ t in Ioi (0:ℝ), F t := by
    rw [thetaC, integral_congr_ae hae, integral_comp_abs]
  -- Step 2: `F` is supported in `[0,1]` on the positive half-line.
  have hzero : (∫ t in Ioi (1:ℝ), F t) = 0 :=
    setIntegral_eq_zero_of_forall_eq_zero fun t ht => by
      have ht1 : (1:ℝ) < t := ht
      exact hFzero t (by rw [abs_of_pos (lt_trans zero_lt_one ht1)]; exact ht1)
  have h2 : (∫ t in Ioi (0:ℝ), F t) = ∫ t in (0:ℝ)..1, F t := by
    rw [← Set.Ioc_union_Ioi_eq_Ioi (zero_le_one : (0:ℝ) ≤ 1),
      setIntegral_union (Set.Ioc_disjoint_Ioi le_rfl) measurableSet_Ioi
        hFint.integrableOn hFint.integrableOn, hzero,
      add_zero, intervalIntegral.integral_of_le zero_le_one]
  -- Step 3: split the triangular weight.
  have hFeq : Set.EqOn F (fun t => 2 * T / π * siDiv (T * t) - 2 / π * Si (T * t))
      (Set.uIcc (0:ℝ) 1) := by
    intro t ht
    rw [Set.uIcc_of_le zero_le_one] at ht
    have htri : triReal 1 t = 1 - t := by
      rw [triReal, abs_of_nonneg ht.1, div_one, max_eq_right (by linarith [ht.2])]
    have hval : F t = 2 * T / π * siDiv (T * t) - 2 / π * (T * t * siDiv (T * t)) := by
      simp only [hFdef, htri]; ring
    rw [hval, mul_siDiv_eq_Si]
  have h3 : (∫ t in (0:ℝ)..1, F t)
      = 2 * T / π * (∫ t in (0:ℝ)..1, siDiv (T * t))
        - 2 / π * ∫ t in (0:ℝ)..1, Si (T * t) := by
    have hcont1 : Continuous fun t : ℝ => 2 * T / π * siDiv (T * t) :=
      continuous_const.mul (siDiv_continuous.comp (continuous_const.mul continuous_id))
    have hcont2 : Continuous fun t : ℝ => 2 / π * Si (T * t) :=
      continuous_const.mul (Si_continuous.comp (continuous_const.mul continuous_id))
    rw [intervalIntegral.integral_congr hFeq,
      intervalIntegral.integral_sub (hcont1.intervalIntegrable 0 1)
        (hcont2.intervalIntegrable 0 1),
      intervalIntegral.integral_const_mul, intervalIntegral.integral_const_mul]
  -- Step 4: rescale the model integral.
  have h4 : T * ∫ t in (0:ℝ)..1, siDiv (T * t) = siDivInt T := by
    rw [intervalIntegral.mul_integral_comp_mul_left]
    simp [siDivInt]
  rw [h1, h2, h3, ← h4]
  field_simp
  ring

theorem exists_tendsto_siDivInt :
    ∃ K : ℝ, Tendsto (fun X : ℝ => siDivInt X - π / 2 * Real.log X) atTop (𝓝 K) := by
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
    have hbd := abs_Si_sub_pi_div_two_le hs0
    have hnum : |Si s - π / 2| ≤ 2 / s := by
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
  refine ⟨siDivInt 1 + ∫ s in Ioi (1:ℝ), g s, ?_⟩
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

theorem tendsto_integral_Si_mul :
    Tendsto (fun T : ℝ => ∫ u in (0:ℝ)..1, Si (T * u)) atTop (𝓝 (π / 2)) := by
  have hrw : ∀ T : ℝ, (∫ u in (0:ℝ)..1, Si (T * u)) = ∫ u in Set.Ioc (0:ℝ) 1, Si (T * u) :=
    fun T => intervalIntegral.integral_of_le zero_le_one
  simp only [hrw]
  have hval : (π / 2 : ℝ) = ∫ _u in Set.Ioc (0:ℝ) 1, π / 2 := by simp
  rw [hval]
  refine MeasureTheory.tendsto_integral_filter_of_dominated_convergence
    (fun _ => Si π) ?_ ?_ ?_ ?_
  · exact .of_forall fun T =>
      (Si_continuous.comp (continuous_const.mul continuous_id)).aestronglyMeasurable
  · refine .of_forall fun T => .of_forall fun u => ?_
    rw [Real.norm_eq_abs]
    exact abs_Si_le_Si_pi _
  · exact integrableOn_const measure_Ioc_lt_top.ne
  · filter_upwards [self_mem_ae_restrict measurableSet_Ioc] with u hu
    exact tendsto_Si_atTop.comp (Filter.Tendsto.atTop_mul_const hu.1 tendsto_id)

theorem exists_tendsto_thetaC :
    ∃ c : ℝ, Tendsto (fun T : ℝ => thetaC T - 2 * Real.log T) atTop (𝓝 c) := by
  obtain ⟨K, hK⟩ := exists_tendsto_siDivInt
  refine ⟨4 / π * (K - π / 2), ?_⟩
  have hlim : Tendsto
      (fun T : ℝ => 4 / π * ((siDivInt T - π / 2 * Real.log T) - ∫ u in (0:ℝ)..1, Si (T * u)))
      atTop (𝓝 (4 / π * (K - π / 2))) :=
    (hK.sub tendsto_integral_Si_mul).const_mul (4 / π)
  refine hlim.congr' ?_
  filter_upwards [eventually_gt_atTop (0:ℝ)] with T hT
  rw [thetaC_eq hT]
  have hpi : π ≠ 0 := ne_of_gt Real.pi_pos
  field_simp
  ring

/-! ## 4. The logarithmic profile of the reference bump -/

theorem exists_tendsto_theta :
    ∃ z : ℝ, Tendsto (fun T : ℝ => theta T - 2 * Real.log T) atTop (𝓝 z) := by
  obtain ⟨a, ha⟩ := exists_tendsto_thetaA
  obtain ⟨c, hc⟩ := exists_tendsto_thetaC
  refine ⟨a + 0 + c, ?_⟩
  refine ((ha.add tendsto_thetaB).add hc).congr' ?_
  filter_upwards [eventually_gt_atTop (0:ℝ)] with T hT
  rw [theta_eq_add hT]
  ring

/-- The reference test function: the triangular bump of half width `1` in the logarithmic
coordinate, `h(λ) = max(0, 1 - |log λ|)`. -/
def refBump : C_c(Rplus, ℂ) := logBump 1 one_pos

theorem refBump_apply_inv (u : ℝ) : refBump ((Rplus.expHomeo u)⁻¹) = ((triReal 1 u : ℝ) : ℂ) := by
  show triC 1 (Rplus.expHomeo.symm ((Rplus.expHomeo u)⁻¹)) = _
  have h : Rplus.expHomeo.symm ((Rplus.expHomeo u)⁻¹) = -u := by
    show Real.log (((Rplus.expHomeo u)⁻¹ : Rplus) : ℝ) = -u
    show Real.log ((Real.exp u)⁻¹) = -u
    rw [Real.log_inv, Real.log_exp]
  rw [h, triC_even]
  rfl

@[simp] theorem refBump_one : refBump 1 = 1 := by
  show triC 1 (Rplus.expHomeo.symm 1) = 1
  have h : Rplus.expHomeo.symm (1 : Rplus) = 0 := by
    show Real.log ((1 : Rplus) : ℝ) = 0
    simp
  rw [h, triC_zero]

/-- The reference bump is Lipschitz at `λ = 1`. -/
theorem refBump_lipschitz (lam : Rplus) : ‖refBump lam - refBump 1‖ ≤ 2 * |1 - (lam : ℝ)| := by
  have hlam : (0:ℝ) < (lam : ℝ) := lam.2
  have hval : refBump lam = triC 1 (Real.log (lam : ℝ)) := rfl
  rw [hval, refBump_one]
  have h1 : ‖triC 1 (Real.log (lam : ℝ)) - triC 1 0‖ ≤ 1 * |Real.log (lam : ℝ)| := by
    simpa using triC_lipschitz one_pos (Real.log (lam : ℝ))
  have h0 : triC 1 (0:ℝ) = 1 := triC_zero 1
  rw [h0] at h1
  rcases le_or_gt (1/2 : ℝ) (lam : ℝ) with hcase | hcase
  · have hlog : |Real.log (lam : ℝ)| ≤ 2 * |1 - (lam : ℝ)| := by
      rcases le_or_gt 1 (lam : ℝ) with h | h
      · have hup : Real.log (lam : ℝ) ≤ (lam : ℝ) - 1 := Real.log_le_sub_one_of_pos hlam
        have hlow : 0 ≤ Real.log (lam : ℝ) := Real.log_nonneg h
        rw [abs_of_nonneg hlow, abs_of_nonpos (by linarith)]
        linarith
      · have hlow : Real.log (lam : ℝ) ≤ 0 := Real.log_nonpos hlam.le h.le
        have hup : -Real.log (lam : ℝ) ≤ (1 - (lam : ℝ)) / (lam : ℝ) := by
          have hx := Real.log_le_sub_one_of_pos (x := ((lam : ℝ))⁻¹) (by positivity)
          rw [Real.log_inv] at hx
          have hinv : ((lam : ℝ))⁻¹ - 1 = (1 - (lam : ℝ)) / (lam : ℝ) := by field_simp
          linarith [hx, hinv.le, hinv.ge]
        have hdiv : (1 - (lam : ℝ)) / (lam : ℝ) ≤ 2 * (1 - (lam : ℝ)) := by
          rw [div_le_iff₀ hlam]
          nlinarith
        rw [abs_of_nonpos hlow, abs_of_nonneg (by linarith)]
        linarith
    linarith
  · have hb : ‖triC 1 (Real.log (lam : ℝ)) - 1‖ ≤ 1 := by
      have hle : triReal 1 (Real.log (lam : ℝ)) ≤ 1 := triReal_le_one one_pos _
      have hge : 0 ≤ triReal 1 (Real.log (lam : ℝ)) := triReal_nonneg 1 _
      have hcast : triC 1 (Real.log (lam : ℝ)) - 1
          = (((triReal 1 (Real.log (lam : ℝ)) - 1 : ℝ)) : ℂ) := by
        rw [triC]; push_cast; ring
      rw [hcast, Complex.norm_real, Real.norm_eq_abs, abs_of_nonpos (by linarith)]
      linarith
    have h2 : (1:ℝ) ≤ 2 * |1 - (lam : ℝ)| := by
      rw [abs_of_nonneg (by linarith)]
      linarith
    linarith

theorem modelCutTrace_refBump [Countable ι] (b : HilbertBasis ι ℂ L2R) {cut : ℝ}
    (hcut : 0 ≤ cut) :
    modelCutTrace b cut refBump = ((theta (2 * π * cut ^ 2) : ℝ) : ℂ) := by
  rw [modelCutTrace_eq_integral_logDens b hcut refBump, theta, ← integral_complex_ofReal]
  refine integral_congr_ae (.of_forall fun u => ?_)
  show refBump ((Rplus.expHomeo u)⁻¹) * ((logDens (2 * π * cut ^ 2) u : ℝ) : ℂ)
      = ((triReal 1 u * logDens (2 * π * cut ^ 2) u : ℝ) : ℂ)
  rw [refBump_apply_inv u]
  push_cast
  ring

/-- **The logarithmic profile of the cut-off traces**: for the reference bump,
`Tr(ϑ(h) S^{(Λ)}) = 4 log Λ + z₀ + o(1)`. -/
theorem exists_hasCutoffLogProfile_refBump [Countable ι] (b : HilbertBasis ι ℂ L2R) :
    ∃ z₀ : ℂ, HasCutoffLogProfile b refBump 4 z₀ := by
  obtain ⟨z, hz⟩ := exists_tendsto_theta
  refine ⟨((z + 2 * Real.log (2 * π) : ℝ) : ℂ), ?_⟩
  have hTtop : Tendsto (fun cut : ℝ => 2 * π * cut ^ 2) atTop atTop := by
    have h1 : Tendsto (fun cut : ℝ => cut ^ 2) atTop atTop := tendsto_pow_atTop two_ne_zero
    exact Filter.Tendsto.const_mul_atTop (by positivity) h1
  have hreal : Tendsto
      (fun cut : ℝ => theta (2 * π * cut ^ 2) - 2 * Real.log (2 * π * cut ^ 2)) atTop (𝓝 z) :=
    hz.comp hTtop
  have hreal2 : Tendsto
      (fun cut : ℝ => theta (2 * π * cut ^ 2) - 4 * Real.log cut) atTop
      (𝓝 (z + 2 * Real.log (2 * π))) := by
    have hadd := hreal.add_const (2 * Real.log (2 * π))
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
      (𝓝 (((z + 2 * Real.log (2 * π) : ℝ)) : ℂ)) :=
    (Complex.continuous_ofReal.tendsto _).comp hreal2
  refine hcomplex.congr' ?_
  filter_upwards [eventually_ge_atTop (0:ℝ)] with cut hcut
  rw [modelCutTrace_refBump b hcut]
  push_cast
  ring

/-! ## 5. The full asymptotic expansion -/

/-- **The renormalized cut-off trace converges, and its finite part is the archimedean Weil
distribution.**

For the semi-local model there is a universal constant `z₁` such that for *every*
compactly supported continuous test function `f` on `ℝ⋆₊` which is Lipschitz at `λ = 1`,

  `Tr(ϑ(f) S^{(Λ)}) - 4 f(1) log Λ  ⟶  W_ℝ(∆^{-1/2} F) + E(F) + f(1) z₁`,

with `F = logTest f` the logarithmic transcription of `f`, `W_ℝ` the archimedean Weil
distribution (equivalently `D(F) - L_Norm(F)`, by `weilR_eq_sub_LfunNorm`) and
`E(F) = reflectionPairingReg F` the pairing against the reflected kernel, i.e. the
contribution of the odd part of `L²(ℝ)` (absent from the even Sonin picture of the paper).

The coefficient of `log Λ` is `4 f(1)` in this **full-line** model: the paper's `2 f(1)`
refers to the even subspace, while the model computes on all of `L²(ℝ)`, whose limiting
density is `sinhKernel + sinhKernelRefl`. -/
theorem exists_universal_finitePart_unconditional [Countable ι] (b : HilbertBasis ι ℂ L2R) :
    ∃ z₁ : ℂ, ∀ (f : C_c(Rplus, ℂ)) (C : ℝ),
      (∀ lam : Rplus, ‖f lam - f 1‖ ≤ C * |1 - (lam : ℝ)|) →
      Tendsto (fun cut : ℝ => modelCutTrace b cut f - f 1 * 4 * (Real.log cut : ℂ)) atTop
        (𝓝 (WeilR (deltaHalfInv (ofLog (logTest f))) + reflectionPairingReg (logTest f)
              + f 1 * z₁)) := by
  obtain ⟨z₀, hz₀⟩ := exists_hasCutoffLogProfile_refBump b
  exact exists_universal_finitePart b hz₀ refBump_one refBump_lipschitz

/-- **The finite part of the renormalized cut-off trace, expressed through the normalised
archimedean functional `L_Norm`.**

This is `exists_universal_finitePart_unconditional` after the identification
`W_ℝ(∆^{-1/2} F) = D(F) - L_Norm(F)` (`weilR_eq_sub_LfunNorm`): there is a universal
constant `z₁` such that for every compactly supported continuous `f` on `ℝ⋆₊` which is
Lipschitz at `λ = 1`,

  `Tr(ϑ(f) S^{(Λ)}) - 4 f(1) log Λ  ⟶  D(F) - L_Norm(F) + E(F) + f(1) z₁`,

with `F = logTest f`.  The `f`-dependent part of the limit is exactly the pairing of `f`
against the recovered kernel `λ^{1/2}/|1-λ|` (the content of `D - L_Norm = W_ℝ`) together
with the odd-part contribution `E(F) = reflectionPairingReg F`; the only remaining freedom
is the single scalar `z₁`, which multiplies the local value `f(1)`. -/
theorem exists_universal_finitePart_LfunNorm [Countable ι] (b : HilbertBasis ι ℂ L2R) :
    ∃ z₁ : ℂ, ∀ (f : C_c(Rplus, ℂ)) (C : ℝ),
      (∀ lam : Rplus, ‖f lam - f 1‖ ≤ C * |1 - (lam : ℝ)|) →
      Tendsto (fun cut : ℝ => modelCutTrace b cut f - f 1 * 4 * (Real.log cut : ℂ)) atTop
        (𝓝 (Dcomplex (ofLog (logTest f)) - LfunNorm (logTest f)
              + reflectionPairingReg (logTest f) + f 1 * z₁)) := by
  obtain ⟨z₁, h⟩ := exists_universal_finitePart_unconditional b
  refine ⟨z₁, fun f C hf => ?_⟩
  have hlim := h f C hf
  rwa [weilR_eq_sub_LfunNorm] at hlim

end ConnesConsani.WeilPositivity
