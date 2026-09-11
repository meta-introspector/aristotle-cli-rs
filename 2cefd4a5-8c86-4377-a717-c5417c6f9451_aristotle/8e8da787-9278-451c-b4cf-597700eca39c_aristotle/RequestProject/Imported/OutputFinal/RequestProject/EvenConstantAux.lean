/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
Authors: Formalization of
  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771

**The key cancellation `thetaAVal + triJVal = 4 log 2 + 2`.**

Two integrals enter the evaluation of the universal constant of the renormalized trace
formula for the reference triangular bump:

* `thetaAVal = ∫ tri(u) sgn(u) (π/2) w(u) du`, the limit of the regular piece of the
  logarithmic profile (`RequestProject/CutoffConstants.lean`);
* `triJVal = ∫ (1 - tri(u)) (κ(u) + κ^{refl}(u)) du`, the pairing of the reference bump with
  the full archimedean kernel.

Separately neither is elementary, but on the positive half-line the first is
`∫ tri(t) (1/sinh(t/2) - 2/t) dt` and the second is `∫ (1 - tri(t))/sinh(t/2) dt`, and the
`tri`-weights cancel:

  `thetaAVal + triJVal = ∫_0^∞ (1/sinh(t/2) - 2 tri(t)/t) dt = 4 log 2 + 2`,

by the regularized hyperbolic identity of `RequestProject/HyperbolicIntegrals.lean`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.HyperbolicIntegrals
import RequestProject.Imported.OutputFinal.RequestProject.CutoffConstants

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Filter Topology Set Real

namespace ConnesConsani.WeilPositivity

/-! ## 1. The sum of the two archimedean kernels -/

theorem sinhKernel_add_sinhKernelRefl {u : ℝ} (hu : u ≠ 0) :
    sinhKernel u + sinhKernelRefl u = 1 / (2 * Real.sinh (|u| / 2)) := by
  have hpos : 0 < |u| := abs_pos.2 hu
  set s : ℝ := |u| / 2 with hs
  have hs0 : 0 < s := by rw [hs]; linarith
  have hes : (0:ℝ) < Real.exp s := Real.exp_pos _
  have hes1 : 1 < Real.exp s := by
    rw [show (1:ℝ) = Real.exp 0 by simp]
    exact Real.exp_lt_exp.2 hs0
  have habs : |u| = 2 * s := by rw [hs]; ring
  have he1 : Real.exp (|u| / 2) = Real.exp s := by rw [hs]
  have he2 : Real.exp |u| = Real.exp s * Real.exp s := by
    rw [habs, ← Real.exp_add]; ring_nf
  have he3 : Real.exp (-|u|) = (Real.exp s * Real.exp s)⁻¹ := by
    rw [← he2, ← Real.exp_neg]
  have he4 : Real.exp (-(|u| / 2)) = (Real.exp s)⁻¹ := by rw [← he1, ← Real.exp_neg]
  have hsinhs : Real.sinh s = (Real.exp s - (Real.exp s)⁻¹) / 2 := by
    rw [Real.sinh_eq, Real.exp_neg]
  have hlt : (Real.exp s)⁻¹ < 1 := by rw [inv_lt_one₀ hes]; exact hes1
  have hden1 : Real.exp s * Real.exp s - (Real.exp s * Real.exp s)⁻¹ ≠ 0 := by
    have h2 : (Real.exp s * Real.exp s)⁻¹ < 1 := by
      rw [inv_lt_one₀ (by positivity)]
      nlinarith
    intro h
    nlinarith [sub_eq_zero.1 h]
  have hden2 : 2 * Real.sinh s ≠ 0 := by
    rw [hsinhs]
    intro h
    nlinarith
  rw [sinhKernel, sinhKernelRefl, he1, he2, he3, he4, ← add_div,
    div_eq_div_iff hden1 hden2, hsinhs]
  field_simp
  ring

/-! ## 2. Reduction of the two integrals to the positive half-line -/

theorem wKer_neg (u : ℝ) : wKer (-u) = -wKer u := by
  rw [wKer, wKer, show -u / 2 = -(u / 2) by ring, Real.sinh_neg]
  rcases eq_or_ne u 0 with rfl | hu
  · simp
  · field_simp
    ring

theorem triReal_one_neg (u : ℝ) : triReal 1 (-u) = triReal 1 u := by
  simp [triReal]

theorem measurable_cschReg : Measurable fun t : ℝ => 1 / Real.sinh (t / 2) - 2 / t := by
  have h := (measurable_const (a := π)).mul measurable_wKer
  simpa only [pi_mul_wKer_eq] using h

theorem thetaAVal_eq_integral_Ioi :
    thetaAVal = ∫ t in Ioi (0:ℝ), triReal 1 t * (1 / Real.sinh (t / 2) - 2 / t) := by
  have hcongr : (fun u : ℝ => triReal 1 u * (if 0 < u then π / 2 else -(π / 2)) * wKer u)
      =ᵐ[volume] fun u : ℝ => (fun t : ℝ => triReal 1 t * (π / 2) * wKer t) |u| := by
    have hae : ∀ᵐ u : ℝ, u ≠ 0 := by rw [ae_iff]; simp
    filter_upwards [hae] with u hu
    rcases lt_or_gt_of_ne hu with h | h
    · show _ = triReal 1 |u| * (π / 2) * wKer |u|
      rw [if_neg (not_lt.2 h.le), abs_of_neg h, triReal_one_neg, wKer_neg]
      ring
    · show _ = triReal 1 |u| * (π / 2) * wKer |u|
      rw [if_pos h, abs_of_pos h]
  have key : thetaAVal = 2 * ∫ t in Ioi (0:ℝ), triReal 1 t * (π / 2) * wKer t := by
    rw [thetaAVal, integral_congr_ae hcongr]
    exact integral_comp_abs (f := fun t : ℝ => triReal 1 t * (π / 2) * wKer t)
  rw [key, ← integral_const_mul]
  refine setIntegral_congr_fun measurableSet_Ioi fun t ht => ?_
  show 2 * (triReal 1 t * (π / 2) * wKer t) = triReal 1 t * (1 / Real.sinh (t / 2) - 2 / t)
  rw [← pi_mul_wKer_eq]
  ring

/-- The pairing of the reference bump with the full archimedean kernel. -/
def triJVal : ℝ := ∫ u : ℝ, (1 - triReal 1 u) * (sinhKernel u + sinhKernelRefl u)

theorem triJVal_eq_integral_Ioi :
    triJVal = ∫ t in Ioi (0:ℝ), (1 - triReal 1 t) / Real.sinh (t / 2) := by
  have hcongr : (fun u : ℝ => (1 - triReal 1 u) * (sinhKernel u + sinhKernelRefl u))
      =ᵐ[volume]
        fun u : ℝ => (fun t : ℝ => (1 - triReal 1 t) * (sinhKernel t + sinhKernelRefl t)) |u| := by
    have hae : ∀ᵐ u : ℝ, u ≠ 0 := by rw [ae_iff]; simp
    filter_upwards [hae] with u hu
    show _ = (1 - triReal 1 |u|) * (sinhKernel |u| + sinhKernelRefl |u|)
    rcases lt_or_gt_of_ne hu with h | h
    · rw [abs_of_neg h, triReal_one_neg, sinhKernel_even u, sinhKernelRefl_even u]
    · rw [abs_of_pos h]
  have key : triJVal
      = 2 * ∫ t in Ioi (0:ℝ), (1 - triReal 1 t) * (sinhKernel t + sinhKernelRefl t) := by
    rw [triJVal, integral_congr_ae hcongr]
    exact integral_comp_abs
      (f := fun t : ℝ => (1 - triReal 1 t) * (sinhKernel t + sinhKernelRefl t))
  rw [key, ← integral_const_mul]
  refine setIntegral_congr_fun measurableSet_Ioi fun t ht => ?_
  have ht0 : (0:ℝ) < t := ht
  show 2 * ((1 - triReal 1 t) * (sinhKernel t + sinhKernelRefl t))
      = (1 - triReal 1 t) / Real.sinh (t / 2)
  have hsinh : 0 < Real.sinh (t / 2) := Real.sinh_pos_iff.2 (by linarith)
  rw [sinhKernel_add_sinhKernelRefl (ne_of_gt ht0), abs_of_pos ht0]
  field_simp

/-! ## 3. Integrability on the half-line -/

theorem integrableOn_cschReg_Ioc :
    IntegrableOn (fun t : ℝ => 1 / Real.sinh (t / 2) - 2 / t) (Ioc (0:ℝ) 1) volume := by
  have h := intervalIntegrable_cschReg
  rw [intervalIntegrable_iff, uIoc_of_le zero_le_one] at h
  exact h

theorem integrableOn_const_two_Ioc :
    IntegrableOn (fun _ : ℝ => (2:ℝ)) (Ioc (0:ℝ) 1) volume :=
  integrableOn_const measure_Ioc_lt_top.ne

theorem triReal_one_of_mem_Ioc {t : ℝ} (ht : t ∈ Ioc (0:ℝ) 1) : triReal 1 t = 1 - t := by
  rw [triReal, abs_of_pos ht.1, div_one, max_eq_right (by linarith [ht.2])]

theorem triReal_one_of_one_lt {t : ℝ} (ht : 1 < t) : triReal 1 t = 0 :=
  triReal_eq_zero one_pos (by rw [abs_of_pos (by linarith)]; linarith)

theorem integrableOn_G_Ioc :
    IntegrableOn (fun t : ℝ => 1 / Real.sinh (t / 2) - 2 * triReal 1 t / t)
      (Ioc (0:ℝ) 1) volume := by
  refine MeasureTheory.IntegrableOn.congr_fun
    (integrableOn_cschReg_Ioc.add integrableOn_const_two_Ioc) ?_ measurableSet_Ioc
  intro t ht
  have ht0 : (0:ℝ) < t := ht.1
  show (1 / Real.sinh (t / 2) - 2 / t) + 2 = 1 / Real.sinh (t / 2) - 2 * triReal 1 t / t
  rw [triReal_one_of_mem_Ioc ht]
  field_simp
  ring

theorem integrableOn_G_Ioi_one :
    IntegrableOn (fun t : ℝ => 1 / Real.sinh (t / 2) - 2 * triReal 1 t / t)
      (Ioi (1:ℝ)) volume := by
  refine MeasureTheory.IntegrableOn.congr_fun integrableOn_Ioi_one_cschHalf ?_ measurableSet_Ioi
  intro t ht
  have ht1 : (1:ℝ) < t := ht
  show 1 / Real.sinh (t / 2) = 1 / Real.sinh (t / 2) - 2 * triReal 1 t / t
  rw [triReal_one_of_one_lt ht1]
  ring

theorem integrableOn_G_Ioi :
    IntegrableOn (fun t : ℝ => 1 / Real.sinh (t / 2) - 2 * triReal 1 t / t)
      (Ioi (0:ℝ)) volume := by
  have h := integrableOn_G_Ioc.union integrableOn_G_Ioi_one
  rwa [Set.Ioc_union_Ioi_eq_Ioi (zero_le_one : (0:ℝ) ≤ 1)] at h

theorem integrableOn_triA_Ioi :
    IntegrableOn (fun t : ℝ => triReal 1 t * (1 / Real.sinh (t / 2) - 2 / t))
      (Ioi (0:ℝ)) volume := by
  have hmeasA : Measurable fun t : ℝ => triReal 1 t * (1 / Real.sinh (t / 2) - 2 / t) :=
    (continuous_triReal 1).measurable.mul measurable_cschReg
  have h1 : IntegrableOn (fun t : ℝ => triReal 1 t * (1 / Real.sinh (t / 2) - 2 / t))
      (Ioc (0:ℝ) 1) volume := by
    refine Integrable.mono' integrableOn_cschReg_Ioc.abs hmeasA.aestronglyMeasurable ?_
    filter_upwards with t
    rw [Real.norm_eq_abs, abs_mul]
    refine mul_le_of_le_one_left (abs_nonneg _) ?_
    rw [abs_of_nonneg (triReal_nonneg 1 t)]
    exact triReal_le_one one_pos t
  have h2 : IntegrableOn (fun t : ℝ => triReal 1 t * (1 / Real.sinh (t / 2) - 2 / t))
      (Ioi (1:ℝ)) volume := by
    refine MeasureTheory.IntegrableOn.congr_fun
      (integrableOn_zero (s := Ioi (1:ℝ)) (μ := volume)) ?_ measurableSet_Ioi
    intro t ht
    have ht1 : (1:ℝ) < t := ht
    show (0:ℝ) = triReal 1 t * (1 / Real.sinh (t / 2) - 2 / t)
    rw [triReal_one_of_one_lt ht1]
    ring
  have h := h1.union h2
  rwa [Set.Ioc_union_Ioi_eq_Ioi (zero_le_one : (0:ℝ) ≤ 1)] at h

theorem integrableOn_triB_Ioi :
    IntegrableOn (fun t : ℝ => (1 - triReal 1 t) / Real.sinh (t / 2)) (Ioi (0:ℝ)) volume := by
  refine MeasureTheory.IntegrableOn.congr_fun
    (integrableOn_G_Ioi.sub integrableOn_triA_Ioi) ?_ measurableSet_Ioi
  intro t ht
  have ht0 : (0:ℝ) < t := ht
  have hsinh : Real.sinh (t / 2) ≠ 0 := (Real.sinh_pos_iff.2 (by linarith)).ne'
  show 1 / Real.sinh (t / 2) - 2 * triReal 1 t / t
      - triReal 1 t * (1 / Real.sinh (t / 2) - 2 / t) = (1 - triReal 1 t) / Real.sinh (t / 2)
  field_simp
  ring

/-! ## 4. The cancellation -/

theorem integral_G_Ioc :
    (∫ t in Ioc (0:ℝ) 1, (1 / Real.sinh (t / 2) - 2 * triReal 1 t / t))
      = (∫ t in (0:ℝ)..1, (1 / Real.sinh (t / 2) - 2 / t)) + 2 := by
  have hcongr : ∀ t ∈ Ioc (0:ℝ) 1,
      1 / Real.sinh (t / 2) - 2 * triReal 1 t / t
        = (1 / Real.sinh (t / 2) - 2 / t) + 2 := by
    intro t ht
    have ht0 : (0:ℝ) < t := ht.1
    rw [triReal_one_of_mem_Ioc ht]
    field_simp
    ring
  rw [setIntegral_congr_fun measurableSet_Ioc hcongr,
    integral_add integrableOn_cschReg_Ioc integrableOn_const_two_Ioc,
    intervalIntegral.integral_of_le zero_le_one]
  simp

theorem integral_G_Ioi_one :
    (∫ t in Ioi (1:ℝ), (1 / Real.sinh (t / 2) - 2 * triReal 1 t / t)) = -cschHalfPrim 1 := by
  rw [← integral_Ioi_one_cschHalf]
  refine setIntegral_congr_fun measurableSet_Ioi fun t ht => ?_
  have ht1 : (1:ℝ) < t := ht
  show 1 / Real.sinh (t / 2) - 2 * triReal 1 t / t = 1 / Real.sinh (t / 2)
  rw [triReal_one_of_one_lt ht1]
  ring

/-- **The key cancellation.**  The `tri`-weights of the two integrals combine into the
regularized hyperbolic integral: `thetaAVal + triJVal = 4 log 2 + 2`. -/
theorem thetaAVal_add_triJVal : thetaAVal + triJVal = 4 * Real.log 2 + 2 := by
  have hsum : thetaAVal + triJVal
      = ∫ t in Ioi (0:ℝ), (1 / Real.sinh (t / 2) - 2 * triReal 1 t / t) := by
    rw [thetaAVal_eq_integral_Ioi, triJVal_eq_integral_Ioi,
      ← integral_add integrableOn_triA_Ioi integrableOn_triB_Ioi]
    refine setIntegral_congr_fun measurableSet_Ioi fun t ht => ?_
    have ht0 : (0:ℝ) < t := ht
    have hsinh : Real.sinh (t / 2) ≠ 0 := (Real.sinh_pos_iff.2 (by linarith)).ne'
    show triReal 1 t * (1 / Real.sinh (t / 2) - 2 / t) + (1 - triReal 1 t) / Real.sinh (t / 2)
        = 1 / Real.sinh (t / 2) - 2 * triReal 1 t / t
    field_simp
    ring
  rw [hsum, ← Set.Ioc_union_Ioi_eq_Ioi (zero_le_one : (0:ℝ) ≤ 1),
    setIntegral_union (Set.Ioc_disjoint_Ioi le_rfl) measurableSet_Ioi
      integrableOn_G_Ioc integrableOn_G_Ioi_one,
    integral_G_Ioc, integral_G_Ioi_one]
  have h := cschHalf_regularized_identity
  rw [integral_Ioi_one_cschHalf] at h
  linarith

end ConnesConsani.WeilPositivity
