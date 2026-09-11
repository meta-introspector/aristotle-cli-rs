/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
Authors: Formalization of
  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771

**The regularized arctangent integral vanishes.**

The evaluation of the universal constant of the even (Sonin) renormalized trace formula
reduces to the vanishing of

  `I = ∫_0^∞ (1/v) [ arctan (1/v) - (π/2)/(1+v) ] dv
     = ∫_0^∞ [ (π/2)/(1+v) - arctan v / v ] dv = 0`,

which follows from the antisymmetry of the integrand under `v ↦ 1/v`.
-/
import Mathlib

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Filter Topology Set Real

namespace ConnesConsani.WeilPositivity

theorem arctan_le_self {x : ℝ} (h : 0 ≤ x) : Real.arctan x ≤ x := by
  rcases eq_or_lt_of_le h with rfl | hx
  · simp
  · have h1 : 0 < Real.arctan x := Real.arctan_pos.2 hx
    have h2 : Real.arctan x < π / 2 := Real.arctan_lt_pi_div_two x
    have h3 := Real.lt_tan h1 h2
    rw [Real.tan_arctan] at h3
    exact h3.le

/-- The regularized arctangent integrand `(π/2)/(1+v) - arctan v / v`.  For `v > 0` this is
also `(1/v)(arctan (1/v) - (π/2)/(1+v))`. -/
def arctanReg (v : ℝ) : ℝ := (π / 2) / (1 + v) - Real.arctan v / v

theorem arctanReg_eq {v : ℝ} (hv : 0 < v) :
    arctanReg v = (Real.arctan (1 / v) - (π / 2) / (1 + v)) / v := by
  have h : Real.arctan (1 / v) = π / 2 - Real.arctan v := by
    rw [one_div, Real.arctan_inv_of_pos hv]
  rw [arctanReg, h]
  field_simp
  ring

/-! ## 1. Antisymmetry under `v ↦ 1/v` -/

theorem arctanReg_inv {w : ℝ} (hw : 0 < w) :
    arctanReg w⁻¹ / w ^ 2 = -arctanReg w := by
  have h : Real.arctan w⁻¹ = π / 2 - Real.arctan w := Real.arctan_inv_of_pos hw
  rw [arctanReg, arctanReg, h]
  have hw0 : w ≠ 0 := hw.ne'
  have h1 : (1 : ℝ) + w⁻¹ ≠ 0 := by positivity
  have h2 : (1 : ℝ) + w ≠ 0 := by positivity
  field_simp
  ring

/-! ## 2. The vanishing of the integral -/

/-- **The regularized arctangent integral vanishes.** -/
theorem integral_arctanReg : ∫ v in Ioi (0:ℝ), arctanReg v = 0 := by
  have hsub := integral_comp_rpow_Ioi (E := ℝ) arctanReg (p := -1) (by norm_num)
  have hcongr : ∫ x in Ioi (0:ℝ), (|(-1 : ℝ)| * x ^ ((-1 : ℝ) - 1)) • arctanReg (x ^ (-1 : ℝ))
      = ∫ x in Ioi (0:ℝ), -arctanReg x := by
    refine setIntegral_congr_fun measurableSet_Ioi ?_
    intro x hx
    have hx0 : (0:ℝ) < x := hx
    have hinv : x ^ (-1 : ℝ) = x⁻¹ := by
      rw [Real.rpow_neg_one]
    have hsq : x ^ ((-1 : ℝ) - 1) = (x ^ 2)⁻¹ := by
      rw [show ((-1 : ℝ) - 1) = -(2:ℝ) by norm_num, Real.rpow_neg hx0.le,
        show (2:ℝ) = ((2:ℕ):ℝ) by norm_num, Real.rpow_natCast]
    show (|(-1 : ℝ)| * x ^ ((-1 : ℝ) - 1)) • arctanReg (x ^ (-1 : ℝ)) = -arctanReg x
    rw [hinv, hsq, smul_eq_mul, abs_neg, abs_one, one_mul, ← arctanReg_inv hx0]
    ring
  rw [hcongr, MeasureTheory.integral_neg] at hsub
  linarith [hsub]

/-! ## 3. Bounds and integrability -/

theorem abs_arctanReg_le {v : ℝ} (hv : 0 < v) : |arctanReg v| ≤ π / 2 + 1 := by
  have h1 : |(π / 2) / (1 + v)| ≤ π / 2 := by
    rw [abs_div, abs_of_pos (by positivity : (0:ℝ) < 1 + v),
      abs_of_pos (by positivity : (0:ℝ) < π / 2), div_le_iff₀ (by positivity)]
    nlinarith [Real.pi_pos]
  have h2 : |Real.arctan v / v| ≤ 1 := by
    rw [abs_div, abs_of_pos hv, div_le_one hv]
    have hle := arctan_le_self hv.le
    have hpos : 0 ≤ Real.arctan v := Real.arctan_nonneg.2 hv.le
    rw [abs_of_nonneg hpos]
    exact hle
  calc |arctanReg v| ≤ |(π / 2) / (1 + v)| + |Real.arctan v / v| := abs_sub _ _
    _ ≤ π / 2 + 1 := by linarith

theorem abs_arctanReg_le_sq {v : ℝ} (hv : 1 ≤ v) : |arctanReg v| ≤ (π / 2 + 1) / v ^ 2 := by
  have hv0 : (0:ℝ) < v := lt_of_lt_of_le zero_lt_one hv
  have h : Real.arctan v = π / 2 - Real.arctan v⁻¹ := by
    rw [Real.arctan_inv_of_pos hv0]; ring
  have hrw : arctanReg v = -((π / 2) / (v * (1 + v))) + Real.arctan v⁻¹ / v := by
    rw [arctanReg, h]
    field_simp
    ring
  have hb1 : |(π / 2) / (v * (1 + v))| ≤ (π / 2) / v ^ 2 := by
    rw [abs_of_pos (by positivity), div_le_div_iff₀ (by positivity) (by positivity)]
    nlinarith [Real.pi_pos]
  have hb2 : |Real.arctan v⁻¹ / v| ≤ 1 / v ^ 2 := by
    have hinvpos : (0:ℝ) < v⁻¹ := by positivity
    have hle : Real.arctan v⁻¹ ≤ v⁻¹ := arctan_le_self hinvpos.le
    have hnn : 0 ≤ Real.arctan v⁻¹ := Real.arctan_nonneg.2 hinvpos.le
    rw [abs_div, abs_of_pos hv0, abs_of_nonneg hnn, div_le_div_iff₀ hv0 (by positivity)]
    have : Real.arctan v⁻¹ * v ^ 2 ≤ v⁻¹ * v ^ 2 := by nlinarith
    calc Real.arctan v⁻¹ * v ^ 2 ≤ v⁻¹ * v ^ 2 := this
      _ = v := by field_simp
      _ = 1 * v := (one_mul v).symm
  have := abs_add_le (-((π / 2) / (v * (1 + v)))) (Real.arctan v⁻¹ / v)
  rw [hrw]
  rw [abs_neg] at this
  have hsum : (π / 2) / v ^ 2 + 1 / v ^ 2 = (π / 2 + 1) / v ^ 2 := by ring
  linarith [this, hb1, hb2]

theorem measurable_arctanReg : Measurable arctanReg := by
  unfold arctanReg
  fun_prop

theorem integrableOn_arctanReg : IntegrableOn arctanReg (Ioi 0) := by
  have hsplit : Ioi (0:ℝ) = Ioc 0 1 ∪ Ioi 1 := by
    ext x; simp only [mem_Ioi, mem_union, mem_Ioc]; constructor
    · intro hx; rcases le_or_gt x 1 with h | h
      · exact Or.inl ⟨hx, h⟩
      · exact Or.inr h
    · rintro (⟨hx, _⟩ | hx) <;> linarith
  rw [hsplit]
  refine IntegrableOn.union ?_ ?_
  · refine Measure.integrableOn_of_bounded (M := π / 2 + 1) (by simp) ?_ ?_
    · exact measurable_arctanReg.aestronglyMeasurable
    · filter_upwards [self_mem_ae_restrict measurableSet_Ioc] with v hv
      exact abs_arctanReg_le hv.1
  · have hb : IntegrableOn (fun v : ℝ => (π / 2 + 1) / v ^ 2) (Ioi 1) := by
      have h := integrableOn_Ioi_rpow_of_lt (a := (-2 : ℝ)) (by norm_num) (by norm_num : (0:ℝ) < 1)
      have h2 : IntegrableOn (fun v : ℝ => v ^ (-2 : ℝ)) (Ioi (1:ℝ)) := h
      refine MeasureTheory.IntegrableOn.congr_fun (h2.const_mul (π / 2 + 1)) ?_
        measurableSet_Ioi
      intro v hv
      have hv0 : (0:ℝ) < v := lt_trans zero_lt_one hv
      show (π / 2 + 1) * v ^ (-2 : ℝ) = (π / 2 + 1) / v ^ 2
      rw [show ((-2 : ℝ)) = -((2:ℕ):ℝ) by norm_num, Real.rpow_neg hv0.le,
        Real.rpow_natCast]
      field_simp
    refine Integrable.mono' hb measurable_arctanReg.aestronglyMeasurable.restrict ?_
    filter_upwards [self_mem_ae_restrict measurableSet_Ioi] with v hv
    exact abs_arctanReg_le_sq (le_of_lt hv)

end ConnesConsani.WeilPositivity
