/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
Authors: Formalization of
  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771

**Elementary estimates for the diagonal asymptotics of the cut-off trace.**

`RequestProject/SemiLocalSi.lean` evaluates the semi-local trace density of the cut-off
Sonin sandwich in closed form,

  `κ_Λ(a) = √a · (2 / (π (a-1))) · Si(2π (a-1) Λ² / max(1,a))`.

In the logarithmic coordinate `a = e^u` the two structural ingredients of that formula are

* the **compression** `ψ(u) = (e^u - 1)/max(1, e^u)`, which is the argument of the sine
  integral, an odd function with `ψ(u) = u + O(u²)`;
* the kernel `1/(π sinh(u/2))`, which differs from the pure pole `2/(π u)` by a bounded
  function.

This file collects the elementary real-variable estimates for these two ingredients, and
bounds on the sine integral, which together control the passage to the limit `Λ → ∞`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.SiAsymptotic
import RequestProject.Imported.OutputFinal.RequestProject.SiPositivity

noncomputable section

open MeasureTheory Filter Topology Set Real

namespace ConnesConsani.WeilPositivity

/-! ## 1. Two bounds on the sine integral -/

/-- `Si` is `1`-Lipschitz, because `|sinc| ≤ 1`. -/
theorem abs_Si_sub_Si_le (x y : ℝ) : |Si x - Si y| ≤ |x - y| := by
  have hint : ∀ a b : ℝ, IntervalIntegrable Real.sinc volume a b := fun a b =>
    Real.continuous_sinc.intervalIntegrable a b
  have h : Si x - Si y = ∫ t in y..x, Real.sinc t := by
    rw [Si, Si, intervalIntegral.integral_interval_sub_left (hint 0 x) (hint 0 y)]
  rw [h]
  have hb := intervalIntegral.norm_integral_le_of_norm_le_const
    (f := Real.sinc) (a := y) (b := x) (C := 1) (fun t _ => by
      simpa [Real.norm_eq_abs] using abs_sinc_le_one t)
  simpa [Real.norm_eq_abs, abs_sub_comm] using hb

/-! ## 2. The compression `ψ` -/

/-- The **compression** `ψ(u) = (e^u - 1)/max(1, e^u)`: the argument of the sine integral in
the closed form of the semi-local density, read in the logarithmic coordinate. -/
def psiCut (u : ℝ) : ℝ := (Real.exp u - 1) / max 1 (Real.exp u)

theorem psiCut_of_nonneg {u : ℝ} (hu : 0 ≤ u) : psiCut u = 1 - Real.exp (-u) := by
  have h1 : (1:ℝ) ≤ Real.exp u := Real.one_le_exp hu
  rw [psiCut, max_eq_right h1, Real.exp_neg]
  field_simp

theorem psiCut_of_nonpos {u : ℝ} (hu : u ≤ 0) : psiCut u = Real.exp u - 1 := by
  have h1 : Real.exp u ≤ 1 := Real.exp_le_one_iff.2 hu
  rw [psiCut, max_eq_left h1, div_one]

@[simp] theorem psiCut_zero : psiCut 0 = 0 := by simp [psiCut_of_nonneg le_rfl]

theorem psiCut_neg (u : ℝ) : psiCut (-u) = - psiCut u := by
  rcases le_total 0 u with hu | hu
  · rw [psiCut_of_nonneg hu, psiCut_of_nonpos (neg_nonpos.2 hu)]; ring
  · rw [psiCut_of_nonpos hu, psiCut_of_nonneg (neg_nonneg.2 hu), neg_neg]; ring

theorem psiCut_pos {u : ℝ} (hu : 0 < u) : 0 < psiCut u := by
  rw [psiCut_of_nonneg hu.le]
  have : Real.exp (-u) < 1 := Real.exp_lt_one_iff.2 (by linarith)
  linarith

theorem psiCut_ne_zero {u : ℝ} (hu : u ≠ 0) : psiCut u ≠ 0 := by
  rcases lt_or_gt_of_ne hu with h | h
  · have : 0 < psiCut (-u) := psiCut_pos (by linarith)
    rw [psiCut_neg] at this
    linarith
  · exact ne_of_gt (psiCut_pos h)

/-- `ψ(u) = u + O(u²)`. -/
theorem abs_psiCut_sub_le {u : ℝ} (hu : |u| ≤ 1) : |psiCut u - u| ≤ u ^ 2 := by
  rcases le_total 0 u with h | h
  · rw [psiCut_of_nonneg h]
    have hb := Real.abs_exp_sub_one_sub_id_le (x := -u) (by rwa [abs_neg])
    have heq : |1 - Real.exp (-u) - u| = |Real.exp (-u) - 1 - (-u)| := by
      rw [← abs_neg]; ring_nf
    rw [heq]
    calc |Real.exp (-u) - 1 - (-u)| ≤ (-u) ^ 2 := hb
      _ = u ^ 2 := by ring
  · rw [psiCut_of_nonpos h]
    exact Real.abs_exp_sub_one_sub_id_le hu

/-- `ψ` does not compress by more than a factor `2` on `[0,1]`. -/
theorem psiCut_ge_half {u : ℝ} (h0 : 0 ≤ u) (h1 : u ≤ 1) : u / 2 ≤ psiCut u := by
  rw [psiCut_of_nonneg h0]
  have hpos : (0:ℝ) < 1 + u := by linarith
  have key : Real.exp (-u) * (1 + u) ≤ 1 := by
    have h := Real.add_one_le_exp u
    have hpos' : (0:ℝ) < Real.exp (-u) := Real.exp_pos _
    calc Real.exp (-u) * (1 + u) ≤ Real.exp (-u) * Real.exp u := by nlinarith
      _ = 1 := by rw [← Real.exp_add]; simp
  have hexp : Real.exp (-u) ≤ 1 / (1 + u) := by
    rw [le_div_iff₀ hpos]; linarith
  have heq : 1 - 1 / (1 + u) = u / (1 + u) := by field_simp; ring
  have h2 : u / 2 ≤ u / (1 + u) := by
    rw [div_le_div_iff₀ (by norm_num) hpos]; nlinarith
  linarith

theorem continuous_psiCut : Continuous psiCut := by
  unfold psiCut
  exact (Real.continuous_exp.sub continuous_const).div
    (continuous_const.max Real.continuous_exp)
    (fun u => ne_of_gt (lt_of_lt_of_le zero_lt_one (le_max_left _ _)))

theorem measurable_psiCut : Measurable psiCut := continuous_psiCut.measurable

/-! ## 3. The hyperbolic kernel against the pure pole -/

theorem abs_le_abs_sinh (x : ℝ) : |x| ≤ |Real.sinh x| := by
  rcases lt_trichotomy x 0 with h | h | h
  · have h1 : -x < Real.sinh (-x) := Real.self_lt_sinh_iff.mpr (by linarith)
    rw [Real.sinh_neg] at h1
    have hs : Real.sinh x < 0 := by linarith
    rw [abs_of_neg h, abs_of_neg hs]; linarith
  · simp [h]
  · have h1 : x < Real.sinh x := Real.self_lt_sinh_iff.mpr h
    rw [abs_of_pos h, abs_of_pos (by linarith)]; linarith

theorem abs_sinh_sub_le {x : ℝ} (hx : |x| ≤ 1) : |Real.sinh x - x| ≤ x ^ 2 := by
  have h1 := Real.abs_exp_sub_one_sub_id_le (x := x) hx
  have h2 := Real.abs_exp_sub_one_sub_id_le (x := -x) (by rwa [abs_neg])
  have hrw : Real.sinh x - x
      = ((Real.exp x - 1 - x) - (Real.exp (-x) - 1 - (-x))) / 2 := by
    rw [Real.sinh_eq]; ring
  rw [hrw, abs_div, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 2)]
  have h4 := abs_sub (Real.exp x - 1 - x) (Real.exp (-x) - 1 - (-x))
  have h3 : (-x) ^ 2 = x ^ 2 := by ring
  rw [h3] at h2
  rw [div_le_iff₀ (by norm_num : (0:ℝ) < 2)]
  linarith

/-- **The hyperbolic kernel differs from the pure pole by a bounded function**:
`|1/sinh(u/2) - 2/u| ≤ 1` for `0 < |u| ≤ 2`. -/
theorem abs_inv_sinh_half_sub_le {u : ℝ} (hu0 : u ≠ 0) (hu : |u| ≤ 2) :
    |1 / Real.sinh (u / 2) - 2 / u| ≤ 1 := by
  set x : ℝ := u / 2 with hxdef
  have hx0 : x ≠ 0 := div_ne_zero hu0 (by norm_num)
  have hxabs : |x| ≤ 1 := by
    rw [hxdef, abs_div, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 2), div_le_one (by norm_num)]
    linarith
  have hsne : Real.sinh x ≠ 0 := Real.sinh_ne_zero.mpr hx0
  have h2u : 2 / u = 1 / x := by rw [hxdef]; field_simp
  rw [h2u]
  have hrw : 1 / Real.sinh x - 1 / x = (x - Real.sinh x) / (x * Real.sinh x) := by
    field_simp
  have hxpos : (0:ℝ) < |x| := abs_pos.mpr hx0
  have hspos : (0:ℝ) < |Real.sinh x| := abs_pos.mpr hsne
  rw [hrw, abs_div, abs_mul, div_le_one (by positivity)]
  calc |x - Real.sinh x| = |Real.sinh x - x| := abs_sub_comm _ _
    _ ≤ x ^ 2 := abs_sinh_sub_le hxabs
    _ = |x| * |x| := by rw [← sq_abs]; ring
    _ ≤ |x| * |Real.sinh x| := mul_le_mul_of_nonneg_left (abs_le_abs_sinh x) (abs_nonneg x)

/-! ## 4. The difference `Si(T ψ(u)) - Si(T u)` -/

theorem abs_sinc_le_inv_abs {t : ℝ} (ht : t ≠ 0) : |Real.sinc t| ≤ 1 / |t| := by
  rw [Real.sinc_of_ne_zero ht, abs_div, div_le_div_iff₀ (abs_pos.mpr ht) (abs_pos.mpr ht)]
  nlinarith [Real.abs_sin_le_one t, abs_pos.mpr ht]

/-- A sharper Lipschitz bound for `Si` on a half line: the derivative `sinc` decays. -/
theorem abs_Si_sub_Si_le_div {x y : ℝ} (hx : 0 < x) (hy : 0 < y) :
    |Si x - Si y| ≤ |x - y| / min x y := by
  have hint : ∀ a b : ℝ, IntervalIntegrable Real.sinc volume a b := fun a b =>
    Real.continuous_sinc.intervalIntegrable a b
  have h : Si x - Si y = ∫ t in y..x, Real.sinc t := by
    rw [Si, Si, intervalIntegral.integral_interval_sub_left (hint 0 x) (hint 0 y)]
  have hm : 0 < min x y := lt_min hx hy
  have hb := intervalIntegral.norm_integral_le_of_norm_le_const
    (f := Real.sinc) (a := y) (b := x) (C := 1 / min x y) (fun t ht => by
      have ht0 : min x y < t := by
        rw [Set.uIoc_eq_union] at ht
        rcases ht with ht | ht
        · exact lt_of_le_of_lt (min_le_right _ _) ht.1
        · exact lt_of_le_of_lt (min_le_left _ _) ht.1
      have htpos : 0 < t := lt_trans hm ht0
      rw [Real.norm_eq_abs]
      refine le_trans (abs_sinc_le_inv_abs (ne_of_gt htpos)) ?_
      rw [abs_of_pos htpos]
      exact one_div_le_one_div_of_le hm ht0.le)
  rw [Real.norm_eq_abs] at hb
  rw [h]
  calc |∫ t in y..x, Real.sinc t| ≤ 1 / min x y * |x - y| := by
        simpa [abs_sub_comm] using hb
    _ = |x - y| / min x y := by ring

/-- **The key uniform bound**: replacing `u` by the compression `ψ(u)` changes the sine
integral by at most `2|u|`, *uniformly in the cut-off* `T`.  Indeed the two arguments have
the same sign and are of comparable size, while `|sinc t| ≤ 1/|t|`. -/
theorem abs_Si_psi_sub_Si_le_two_abs {T u : ℝ} (hT : 0 < T) (hu0 : u ≠ 0) (hu : |u| ≤ 1) :
    |Si (T * psiCut u) - Si (T * u)| ≤ 2 * |u| := by
  have key : ∀ v : ℝ, 0 < v → v ≤ 1 → |Si (T * psiCut v) - Si (T * v)| ≤ 2 * v := by
    intro v hv hv1
    have hpsi : v / 2 ≤ psiCut v := psiCut_ge_half hv.le hv1
    have hpsipos : 0 < psiCut v := psiCut_pos hv
    have hmin : T * v / 2 ≤ min (T * psiCut v) (T * v) := by
      refine le_min ?_ ?_ <;> nlinarith
    have hminpos : 0 < min (T * psiCut v) (T * v) := lt_min (by positivity) (by positivity)
    have hnum : |T * psiCut v - T * v| ≤ T * v ^ 2 := by
      have h : T * psiCut v - T * v = T * (psiCut v - v) := by ring
      rw [h, abs_mul, abs_of_pos hT]
      exact mul_le_mul_of_nonneg_left
        (abs_psiCut_sub_le (by rw [abs_of_pos hv]; exact hv1)) hT.le
    refine le_trans (abs_Si_sub_Si_le_div (by positivity) (by positivity)) ?_
    rw [div_le_iff₀ hminpos]
    calc |T * psiCut v - T * v| ≤ T * v ^ 2 := hnum
      _ = 2 * v * (T * v / 2) := by ring
      _ ≤ 2 * v * min (T * psiCut v) (T * v) :=
          mul_le_mul_of_nonneg_left hmin (by positivity)
  rcases lt_or_gt_of_ne hu0 with h | h
  · have h1 := key (-u) (by linarith) (by rwa [abs_of_neg h] at hu)
    have hrw : Si (T * psiCut u) - Si (T * u) = -(Si (T * psiCut (-u)) - Si (T * (-u))) := by
      rw [psiCut_neg]
      have e1 : T * -psiCut u = -(T * psiCut u) := by ring
      have e2 : T * -u = -(T * u) := by ring
      rw [e1, e2, Si_neg, Si_neg]; ring
    rw [hrw, abs_neg, abs_of_neg h]
    exact h1
  · rw [abs_of_pos h]
    exact key u h (by rwa [abs_of_pos h] at hu)

end ConnesConsani.WeilPositivity
