/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

A certified bound for the total variation of the trace remainder in the logarithmic
coordinate,

  `∫₀^∞ |(d/dv) δ(e^v)| dv ≤ 12`,

for the trace remainder `δ` of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771.

`RequestProject/DeltaDecaySharp.lean` derives the decay `|δ̂(t)| ≤ (2/|t|) ∫₀^∞ |(d/dv)δ(e^v)|`
from an integration by parts, and uses the crude pointwise bound `|(d/dv)δ(e^v)| ≤ 16 e^{-v/2}`,
whose integral is `32`.  Here the same derivative is estimated piecewise: writing `r = e^v`,

  `|(d/dv) δ(e^v)| ≤ e^{-v/2} · Z(r)`,
  `Z(r) = r σ(a) + r σ(b) + 4π r² |S₁(a)| + 4π r² |S₁(b)|`,  `a = 2π(1+r)`, `b = 2π(r-1)`,

where `σ = Si(·)/·` and `S₁` is the first sine moment.  Each of the four summands is
estimated by two elementary bounds (`σ ≤ 1` and `σ(x) ≤ (π/2 + 1/x + 1/x²)/x`;
`|S₁(x)| ≤ |x|/9` and `|S₁(x)| ≤ (π+1)/x²`), and the better of the two is used on each
piece of the partition `r ∈ [1, 1.05²], [1.05², 1.1²], …, [4², ∞)`.  The resulting integral
bound is `11.78 ≤ 12` (the true value of the total variation is `2.38…`).

The consequence is `|δ̂(t)| ≤ 24/|t|`, which lowers the threshold beyond which the
Fourier-side inequality `2θ'(t) + δ̂(t) ≥ 0` of Corollary 2.3 (ii) is proved from `|t| ≥ 38`
to `|t| ≥ 23`.
-/
import RequestProject.Imported.OutputFinal2.DeltaDecaySharp
import RequestProject.Imported.OutputFinal2.SiAsymptotic

noncomputable section

open MeasureTheory Set Real Filter Topology

namespace ConnesConsani.WeilPositivity

/-! ## 1. The two `uPlus` terms -/

/-- `e^v σ(2π(1+e^v)) ≤ 0.2643`. -/
theorem exp_mul_siDiv_uPlus_le {v : ℝ} (hv : 0 ≤ v) :
    Real.exp v * siDiv (uPlus v) ≤ 0.2643 := by
  have hpi : (3.14159:ℝ) < π := by linarith [Real.pi_gt_d6]
  have hpi' : π < 3.1416 := by linarith [Real.pi_lt_d6]
  have hr : (1:ℝ) ≤ Real.exp v := Real.one_le_exp hv
  set r := Real.exp v with hrdef
  set A : ℝ := 2 * π * (1 + r) with hA
  have hApos : (0:ℝ) < A := by rw [hA]; nlinarith
  have hAge : (12.56:ℝ) ≤ A := by rw [hA]; nlinarith
  have hsi : siDiv (uPlus v) = Si A / A := by
    rw [show uPlus v = A from rfl, siDiv_of_ne_zero (ne_of_gt hApos)]
  have hSipos : 0 < Si A / A := by
    have := siDiv_pos A
    rwa [siDiv_of_ne_zero (ne_of_gt hApos)] at this
  have hSinn : 0 ≤ Si A := by
    have h := mul_pos hSipos hApos
    rw [div_mul_cancel₀ _ (ne_of_gt hApos)] at h
    exact h.le
  have hSile : Si A ≤ 1.66 := by
    have h := Si_le_of_pos hApos
    have h1 : 1 / A ≤ 1 / 12.56 := one_div_le_one_div_of_le (by norm_num) hAge
    have h2 : 1 / A ^ 2 ≤ 1 / 157.75 := by
      apply one_div_le_one_div_of_le (by norm_num)
      nlinarith
    linarith
  have hrA : r / A ≤ 1 / (2 * π) := by
    rw [hA, div_le_div_iff₀ hApos (by positivity)]
    nlinarith
  have hkey : r * (Si A / A) = (r / A) * Si A := by ring
  rw [hsi, hkey]
  have h1 : (r / A) * Si A ≤ (1 / (2 * π)) * 1.66 :=
    mul_le_mul hrA hSile hSinn (by positivity)
  have h2 : (1 / (2 * π)) * 1.66 ≤ 0.2643 := by
    rw [div_mul_eq_mul_div, div_le_iff₀ (by positivity)]
    nlinarith
  linarith

/-- `4π e^{2v} |S₁(2π(1+e^v))| ≤ 1.3184`. -/
theorem four_pi_exp_sq_mul_abs_sinMoment_uPlus_le {v : ℝ} (hv : 0 ≤ v) :
    4 * π * Real.exp v ^ 2 * |sinMoment 1 (uPlus v)| ≤ 1.3184 := by
  have hpi : (3.14159:ℝ) < π := by linarith [Real.pi_gt_d6]
  have hr : (1:ℝ) ≤ Real.exp v := Real.one_le_exp hv
  set r := Real.exp v with hrdef
  set A : ℝ := 2 * π * (1 + r) with hA
  have hApos : (0:ℝ) < A := by rw [hA]; nlinarith
  have hm : |sinMoment 1 (uPlus v)| ≤ (π + 1) / A ^ 2 :=
    abs_sinMoment_one_le_inv_sq (ne_of_gt hApos)
  have hA2 : (2 * π * r) ^ 2 ≤ A ^ 2 := by
    have h : 2 * π * r ≤ A := by rw [hA]; nlinarith
    nlinarith [mul_pos (mul_pos (by norm_num : (0:ℝ) < 2) Real.pi_pos) (by linarith : (0:ℝ) < r)]
  have hle : (π + 1) / A ^ 2 ≤ (π + 1) / (2 * π * r) ^ 2 :=
    div_le_div_of_nonneg_left (by linarith) (by positivity) hA2
  have hfac : 4 * π * r ^ 2 * ((π + 1) / (2 * π * r) ^ 2) = (π + 1) / π := by
    have hrne : r ≠ 0 := by positivity
    field_simp
    ring
  calc 4 * π * r ^ 2 * |sinMoment 1 (uPlus v)|
      ≤ 4 * π * r ^ 2 * ((π + 1) / (2 * π * r) ^ 2) :=
        mul_le_mul_of_nonneg_left (hm.trans hle) (by positivity)
    _ = (π + 1) / π := hfac
    _ ≤ 1.3184 := by
        rw [div_le_iff₀ (by linarith)]
        nlinarith

/-! ## 2. The generic pointwise bound -/

/-- **The pointwise bound for the derivative of `δ(e^v)`** in terms of any two bounds for the
two `uMinus` contributions. -/
theorem abs_dl1_le_of_bounds {v B D : ℝ} (hv : 0 ≤ v)
    (hB : Real.exp v * siDiv (uMinus v) ≤ B)
    (hD : 4 * π * Real.exp v ^ 2 * |sinMoment 1 (uMinus v)| ≤ D) :
    |dl1 v| ≤ (1.5827 + B + D) * Real.exp (-(v / 2)) := by
  have hr : (1:ℝ) ≤ Real.exp v := Real.one_le_exp hv
  set r := Real.exp v with hrdef
  have hE : (0:ℝ) < Real.exp (v / 2) := Real.exp_pos _
  have hsplit : Real.exp (v / 2) = Real.exp (-(v / 2)) * r := by
    rw [hrdef, ← Real.exp_add]
    ring_nf
  have hmom : hMom v = siDiv (uPlus v) + siDiv (uMinus v) := by
    rw [hMom, siDiv_eq_cosMoment, siDiv_eq_cosMoment]
  have hmomnn : 0 ≤ hMom v := by
    rw [hmom]
    exact add_nonneg (siDiv_pos _).le (siDiv_pos _).le
  -- the first summand
  have h1 : Real.exp (v / 2) * |hMom v|
      = Real.exp (-(v / 2)) * (r * siDiv (uPlus v) + r * siDiv (uMinus v)) := by
    rw [abs_of_nonneg hmomnn, hmom, hsplit]
    ring
  -- the second summand
  have h2 : 2 * Real.exp (v / 2) * |hMom1 v|
      ≤ Real.exp (-(v / 2)) * (4 * π * r ^ 2 * |sinMoment 1 (uPlus v)|
          + 4 * π * r ^ 2 * |sinMoment 1 (uMinus v)|) := by
    have hval : |hMom1 v| ≤ 2 * π * r * (|sinMoment 1 (uPlus v)| + |sinMoment 1 (uMinus v)|) := by
      rw [hMom1, abs_mul, abs_neg, abs_of_pos (by positivity : (0:ℝ) < 2 * π * Real.exp v)]
      exact mul_le_mul_of_nonneg_left (abs_add_le _ _) (by positivity)
    have hstep := mul_le_mul_of_nonneg_left hval (by positivity : (0:ℝ) ≤ 2 * Real.exp (v / 2))
    refine hstep.trans (le_of_eq ?_)
    rw [hsplit]
    ring
  have hA := exp_mul_siDiv_uPlus_le hv
  have hAm := four_pi_exp_sq_mul_abs_sinMoment_uPlus_le hv
  have hbound : |dl1 v| ≤ Real.exp (v / 2) * |hMom v| + 2 * Real.exp (v / 2) * |hMom1 v| := by
    rw [dl1]
    refine (abs_add_le _ _).trans ?_
    rw [abs_mul, abs_mul, abs_of_pos hE, abs_of_pos (by positivity : (0:ℝ) < 2 * Real.exp (v / 2))]
  have hpos : (0:ℝ) < Real.exp (-(v / 2)) := Real.exp_pos _
  rw [h1] at hbound
  nlinarith [hbound, h2, hA, hAm, hB, hD, hpos]

/-! ## 3. The four elementary bounds for the `uMinus` terms -/

/-- `σ ≤ 1` branch: `e^v σ(2π(e^v-1)) ≤ R` whenever `e^v ≤ R`. -/
theorem exp_mul_siDiv_uMinus_le_exp {v R : ℝ} (hv : 0 ≤ v) (h : Real.exp v ≤ R) :
    Real.exp v * siDiv (uMinus v) ≤ R := by
  have hr : (1:ℝ) ≤ Real.exp v := Real.one_le_exp hv
  have hb : (0:ℝ) ≤ uMinus v := by
    rw [uMinus]
    nlinarith [Real.pi_pos]
  have h1 : siDiv (uMinus v) ≤ 1 := siDiv_le_one hb
  nlinarith [siDiv_pos (uMinus v), Real.exp_pos v]

/-- Asymptotic branch: for `e^v ≥ r₀ > 1`, `e^v σ(2π(e^v-1)) ≤ c r₀/(2π(r₀-1))` whenever
`c ≥ π/2 + 1/b₀ + 1/b₀²` with `b₀ = 2π(r₀-1)`. -/
theorem exp_mul_siDiv_uMinus_le_asymp {v r0 c : ℝ} (hr0 : 1 < r0) (hv : r0 ≤ Real.exp v)
    (hc : π / 2 + 1 / (2 * π * (r0 - 1)) + 1 / (2 * π * (r0 - 1)) ^ 2 ≤ c) :
    Real.exp v * siDiv (uMinus v) ≤ c * r0 / (2 * π * (r0 - 1)) := by
  have hpi := Real.pi_pos
  set r := Real.exp v with hrdef
  have hr : 1 < r := lt_of_lt_of_le hr0 hv
  set b : ℝ := 2 * π * (r - 1) with hb
  set b0 : ℝ := 2 * π * (r0 - 1) with hb0
  have hb0pos : (0:ℝ) < b0 := by rw [hb0]; nlinarith
  have hbpos : (0:ℝ) < b := by rw [hb]; nlinarith
  have hble : b0 ≤ b := by rw [hb, hb0]; nlinarith
  have hsi : siDiv (uMinus v) = Si b / b := by
    rw [show uMinus v = b from rfl, siDiv_of_ne_zero (ne_of_gt hbpos)]
  have hSipos : 0 < Si b / b := by
    have := siDiv_pos b
    rwa [siDiv_of_ne_zero (ne_of_gt hbpos)] at this
  have hSinn : 0 ≤ Si b := by
    have h := mul_pos hSipos hbpos
    rw [div_mul_cancel₀ _ (ne_of_gt hbpos)] at h
    exact h.le
  have hSile : Si b ≤ c := by
    have h := Si_le_of_pos hbpos
    have h1 : 1 / b ≤ 1 / b0 := one_div_le_one_div_of_le hb0pos hble
    have h2 : 1 / b ^ 2 ≤ 1 / b0 ^ 2 := by
      apply one_div_le_one_div_of_le (by positivity)
      nlinarith
    linarith
  have hrb : r / b ≤ r0 / b0 := by
    rw [hb, hb0, div_le_div_iff₀ hbpos hb0pos]
    nlinarith
  have hkey : r * (Si b / b) = (r / b) * Si b := by ring
  rw [hsi, hkey]
  have hc0 : 0 ≤ c := by nlinarith [hSinn, hSile]
  calc (r / b) * Si b ≤ (r0 / b0) * c := mul_le_mul hrb hSile hSinn (by positivity)
    _ = c * r0 / b0 := by ring

/-- Small-argument branch: `4π e^{2v}|S₁(2π(e^v-1))| ≤ (8π²/9) R²(R-1)` for `1 ≤ e^v ≤ R`. -/
theorem four_pi_exp_sq_mul_abs_sinMoment_uMinus_le_small {v R : ℝ} (hv : 0 ≤ v)
    (h : Real.exp v ≤ R) :
    4 * π * Real.exp v ^ 2 * |sinMoment 1 (uMinus v)| ≤ 8 * π ^ 2 / 9 * (R ^ 2 * (R - 1)) := by
  have hpi := Real.pi_pos
  have hr : (1:ℝ) ≤ Real.exp v := Real.one_le_exp hv
  set r := Real.exp v with hrdef
  have hR : (1:ℝ) ≤ R := le_trans hr h
  have hm : |sinMoment 1 (uMinus v)| ≤ |uMinus v| / 9 := abs_sinMoment_one_le _
  have habs : |uMinus v| = 2 * π * (r - 1) := by
    rw [uMinus, abs_of_nonneg (mul_nonneg (by positivity) (by rw [← hrdef]; linarith))]
  rw [habs] at hm
  have hstep : 4 * π * r ^ 2 * |sinMoment 1 (uMinus v)|
      ≤ 4 * π * r ^ 2 * (2 * π * (r - 1) / 9) :=
    mul_le_mul_of_nonneg_left hm (by positivity)
  have hmono : 4 * π * r ^ 2 * (2 * π * (r - 1) / 9) ≤ 8 * π ^ 2 / 9 * (R ^ 2 * (R - 1)) := by
    have h1 : r ^ 2 * (r - 1) ≤ R ^ 2 * (R - 1) :=
      mul_le_mul (by nlinarith) (by linarith) (by linarith) (by positivity)
    nlinarith [sq_nonneg π]
  linarith

/-- Large-argument branch: `4π e^{2v}|S₁(2π(e^v-1))| ≤ ((π+1)/π) r₀²/(r₀-1)²` for
`e^v ≥ r₀ > 1`. -/
theorem four_pi_exp_sq_mul_abs_sinMoment_uMinus_le_large {v r0 : ℝ} (hr0 : 1 < r0)
    (hv : r0 ≤ Real.exp v) :
    4 * π * Real.exp v ^ 2 * |sinMoment 1 (uMinus v)|
      ≤ (π + 1) / π * (r0 ^ 2 / (r0 - 1) ^ 2) := by
  have hpi := Real.pi_pos
  set r := Real.exp v with hrdef
  have hr : 1 < r := lt_of_lt_of_le hr0 hv
  set b : ℝ := 2 * π * (r - 1) with hb
  have hbpos : (0:ℝ) < b := by rw [hb]; nlinarith
  have hm : |sinMoment 1 (uMinus v)| ≤ (π + 1) / b ^ 2 :=
    abs_sinMoment_one_le_inv_sq (ne_of_gt hbpos)
  have hstep : 4 * π * r ^ 2 * |sinMoment 1 (uMinus v)| ≤ 4 * π * r ^ 2 * ((π + 1) / b ^ 2) :=
    mul_le_mul_of_nonneg_left hm (by positivity)
  have hval : 4 * π * r ^ 2 * ((π + 1) / b ^ 2) = (π + 1) / π * (r ^ 2 / (r - 1) ^ 2) := by
    rw [hb]
    have h1 : (r - 1) ≠ 0 := ne_of_gt (by linarith)
    field_simp
    ring
  have hmono : r ^ 2 / (r - 1) ^ 2 ≤ r0 ^ 2 / (r0 - 1) ^ 2 := by
    rw [div_le_div_iff₀ (pow_pos (by linarith) 2) (pow_pos (by linarith) 2)]
    nlinarith [sq_nonneg (r - r0), mul_pos (sub_pos.2 hr) (sub_pos.2 hr0)]
  have hfac : (0:ℝ) ≤ (π + 1) / π := by positivity
  calc 4 * π * r ^ 2 * |sinMoment 1 (uMinus v)|
      ≤ 4 * π * r ^ 2 * ((π + 1) / b ^ 2) := hstep
    _ = (π + 1) / π * (r ^ 2 / (r - 1) ^ 2) := hval
    _ ≤ (π + 1) / π * (r0 ^ 2 / (r0 - 1) ^ 2) := mul_le_mul_of_nonneg_left hmono hfac


/-! ## 4. Breakpoints and elementary integrals -/

/-- The logarithmic breakpoint with `e^{vBP q} = q ^ 2`, so that `e^{-vBP q/2} = 1/q`. -/
def vBP (q : ℝ) : ℝ := 2 * Real.log q

theorem exp_vBP {q : ℝ} (hq : 0 < q) : Real.exp (vBP q) = q ^ 2 := by
  rw [vBP, two_mul, Real.exp_add, Real.exp_log hq, sq]

theorem exp_neg_half_vBP {q : ℝ} (hq : 0 < q) : Real.exp (-(vBP q / 2)) = 1 / q := by
  rw [show -(vBP q / 2) = -Real.log q by rw [vBP]; ring, Real.exp_neg, Real.exp_log hq, one_div]

@[simp] theorem vBP_one : vBP 1 = 0 := by simp [vBP]

theorem vBP_nonneg {q : ℝ} (hq : 1 ≤ q) : 0 ≤ vBP q := by
  have := Real.log_nonneg hq
  simp only [vBP]
  linarith

theorem vBP_mono {q0 q1 : ℝ} (h0 : 0 < q0) (h : q0 ≤ q1) : vBP q0 ≤ vBP q1 := by
  simp only [vBP]
  have := Real.log_le_log h0 h
  linarith

/-- `∫ v in a..b, e^{-v/2} = 2 e^{-a/2} - 2 e^{-b/2}`. -/
theorem intervalIntegral_exp_neg_half (a b : ℝ) :
    (∫ v in a..b, Real.exp (-(v / 2))) = 2 * Real.exp (-(a / 2)) - 2 * Real.exp (-(b / 2)) := by
  have hderiv : ∀ v : ℝ, HasDerivAt (fun v : ℝ => -2 * Real.exp (-(v / 2)))
      (Real.exp (-(v / 2))) v := by
    intro v
    have h0 : HasDerivAt (fun v : ℝ => -(v / 2)) (-(1 / 2)) v := by
      simpa using ((hasDerivAt_id v).div_const 2).neg
    have h := (h0.exp).const_mul (-2 : ℝ)
    convert h using 1
    ring
  have h := intervalIntegral.integral_eq_sub_of_hasDerivAt (f := fun v : ℝ => -2 * Real.exp (-(v / 2)))
    (f' := fun v : ℝ => Real.exp (-(v / 2))) (a := a) (b := b)
    (fun x _ => hderiv x) ((by fun_prop : Continuous fun v : ℝ => Real.exp (-(v / 2))).intervalIntegrable _ _)
  rw [h]
  ring

/-- `∫ v in Ioi a, e^{-v/2} = 2 e^{-a/2}`. -/
theorem integral_Ioi_exp_neg_half_from (a : ℝ) :
    (∫ v in Ioi a, Real.exp (-(v / 2))) = 2 * Real.exp (-(a / 2)) := by
  have hderiv : ∀ v : ℝ, HasDerivAt (fun v : ℝ => -2 * Real.exp (-(v / 2)))
      (Real.exp (-(v / 2))) v := by
    intro v
    have h0 : HasDerivAt (fun v : ℝ => -(v / 2)) (-(1 / 2)) v := by
      simpa using ((hasDerivAt_id v).div_const 2).neg
    have h := (h0.exp).const_mul (-2 : ℝ)
    convert h using 1
    ring
  have htend : Tendsto (fun v : ℝ => -2 * Real.exp (-(v / 2))) atTop (𝓝 0) := by
    have hexp : Tendsto (fun v : ℝ => Real.exp (-(v / 2))) atTop (𝓝 0) :=
      Real.tendsto_exp_atBot.comp
        (Filter.tendsto_neg_atTop_atBot.comp (Filter.Tendsto.atTop_div_const (by norm_num)
          tendsto_id))
    simpa using hexp.const_mul (-2 : ℝ)
  have h := integral_Ioi_of_hasDerivAt_of_nonneg (a := a)
    (by fun_prop : Continuous fun v : ℝ => -2 * Real.exp (-(v / 2))).continuousWithinAt
    (fun x (_ : x ∈ Ioi a) => hderiv x)
    (fun x (_ : x ∈ Ioi a) => (Real.exp_pos _).le) htend
  rw [h]
  ring

/-- Splitting the half-line integral of `|dl1|` at an intermediate point. -/
theorem integral_Ioi_abs_dl1_split {a b : ℝ} (ha : 0 ≤ a) (hab : a ≤ b) :
    (∫ v in Ioi a, |dl1 v|) = (∫ v in a..b, |dl1 v|) + ∫ v in Ioi b, |dl1 v| := by
  have hint : IntegrableOn (fun v => |dl1 v|) (Ioi a) volume :=
    IntegrableOn.mono_set integrableOn_dl1_Ioi.abs (Ioi_subset_Ioi ha)
  have hunion : Ioc a b ∪ Ioi b = Ioi a := Ioc_union_Ioi_eq_Ioi hab
  have hsub1 : Ioc a b ⊆ Ioi a := fun x hx => hx.1
  have hsub2 : Ioi b ⊆ Ioi a := Ioi_subset_Ioi hab
  have h1 : IntegrableOn (fun v => |dl1 v|) (Ioc a b) volume := IntegrableOn.mono_set hint hsub1
  have h2 : IntegrableOn (fun v => |dl1 v|) (Ioi b) volume := IntegrableOn.mono_set hint hsub2
  have hdisj : Disjoint (Ioc a b) (Ioi b) := by
    rw [Set.disjoint_left]
    intro x hx hx'
    exact absurd hx.2 (not_le.2 hx')
  rw [← hunion, setIntegral_union hdisj measurableSet_Ioi h1 h2,
    intervalIntegral.integral_of_le hab]

/-- Integrating a pointwise bound `|dl1 v| ≤ M e^{-v/2}` over an interval. -/
theorem integral_abs_dl1_interval_le {a b M : ℝ} (hab : a ≤ b)
    (hM : ∀ v ∈ Icc a b, |dl1 v| ≤ M * Real.exp (-(v / 2))) :
    (∫ v in a..b, |dl1 v|) ≤ 2 * M * (Real.exp (-(a / 2)) - Real.exp (-(b / 2))) := by
  have h1 : (∫ v in a..b, |dl1 v|) ≤ ∫ v in a..b, M * Real.exp (-(v / 2)) :=
    intervalIntegral.integral_mono_on hab (continuous_dl1.abs.intervalIntegrable _ _)
      ((continuous_const.mul (by fun_prop)).intervalIntegrable _ _) hM
  rw [intervalIntegral.integral_const_mul, intervalIntegral_exp_neg_half] at h1
  calc (∫ v in a..b, |dl1 v|) ≤ M * (2 * Real.exp (-(a / 2)) - 2 * Real.exp (-(b / 2))) := h1
    _ = 2 * M * (Real.exp (-(a / 2)) - Real.exp (-(b / 2))) := by ring

/-- Integrating a pointwise bound `|dl1 v| ≤ M e^{-v/2}` over a half-line. -/
theorem integral_Ioi_abs_dl1_tail_le {a M : ℝ} (ha : 0 ≤ a)
    (hM : ∀ v ∈ Ici a, |dl1 v| ≤ M * Real.exp (-(v / 2))) :
    (∫ v in Ioi a, |dl1 v|) ≤ 2 * M * Real.exp (-(a / 2)) := by
  have hint : IntegrableOn (fun v => |dl1 v|) (Ioi a) volume :=
    IntegrableOn.mono_set integrableOn_dl1_Ioi.abs (Ioi_subset_Ioi ha)
  have hexpint : IntegrableOn (fun v : ℝ => Real.exp (-(v / 2))) (Ioi a) volume :=
    IntegrableOn.mono_set integrableOn_exp_neg_half (Ioi_subset_Ioi ha)
  have h1 : (∫ v in Ioi a, |dl1 v|) ≤ ∫ v in Ioi a, M * Real.exp (-(v / 2)) :=
    setIntegral_mono_on hint (hexpint.const_mul M) measurableSet_Ioi
      (fun v hv => hM v (mem_Ici.2 (le_of_lt hv)))
  rw [integral_const_mul, integral_Ioi_exp_neg_half_from] at h1
  calc (∫ v in Ioi a, |dl1 v|) ≤ M * (2 * Real.exp (-(a / 2))) := h1
    _ = 2 * M * Real.exp (-(a / 2)) := by ring

/-! ## 5. The two families of pointwise bounds -/

/-- Small-argument piece: on `0 ≤ v ≤ vBP q1` one has `|dl1 v| ≤ M e^{-v/2}` provided the
rational bound `1.5827 + q1² + 8.7731 q1⁴(q1²-1) ≤ M` holds. -/
theorem abs_dl1_le_small {q1 M : ℝ} (h1 : 1 ≤ q1)
    (hM : 1.5827 + q1 ^ 2 + 8.7731 * (q1 ^ 4 * (q1 ^ 2 - 1)) ≤ M) :
    ∀ v ∈ Icc (0:ℝ) (vBP q1), |dl1 v| ≤ M * Real.exp (-(v / 2)) := by
  intro v hv
  obtain ⟨hv0, hv1⟩ := hv
  have hq1 : (0:ℝ) < q1 := by linarith
  have hexp : Real.exp v ≤ q1 ^ 2 := by
    rw [← exp_vBP hq1]
    exact Real.exp_le_exp.2 hv1
  have hB := exp_mul_siDiv_uMinus_le_exp hv0 hexp
  have hD := four_pi_exp_sq_mul_abs_sinMoment_uMinus_le_small hv0 hexp
  have hkey := abs_dl1_le_of_bounds hv0 hB hD
  have hpi : π < 3.1416 := by linarith [Real.pi_lt_d6]
  have hq2 : (1:ℝ) ≤ q1 ^ 2 := by nlinarith
  have hnn : (0:ℝ) ≤ q1 ^ 4 * (q1 ^ 2 - 1) :=
    mul_nonneg (by positivity) (by linarith)
  have hconst : 8 * π ^ 2 / 9 * ((q1 ^ 2) ^ 2 * (q1 ^ 2 - 1))
      ≤ 8.7731 * (q1 ^ 4 * (q1 ^ 2 - 1)) := by
    have he : (q1 ^ 2) ^ 2 * (q1 ^ 2 - 1) = q1 ^ 4 * (q1 ^ 2 - 1) := by ring
    rw [he]
    refine mul_le_mul_of_nonneg_right ?_ hnn
    nlinarith [Real.pi_pos]
  have hsum : 1.5827 + q1 ^ 2 + 8 * π ^ 2 / 9 * ((q1 ^ 2) ^ 2 * (q1 ^ 2 - 1)) ≤ M := by
    linarith
  calc |dl1 v|
      ≤ (1.5827 + q1 ^ 2 + 8 * π ^ 2 / 9 * ((q1 ^ 2) ^ 2 * (q1 ^ 2 - 1)))
          * Real.exp (-(v / 2)) := hkey
    _ ≤ M * Real.exp (-(v / 2)) :=
        mul_le_mul_of_nonneg_right hsum (Real.exp_pos _).le

/-- Large-argument piece: on `v ≥ vBP q0` (with `q0 > 1`) one has `|dl1 v| ≤ M e^{-v/2}`
provided the rational bounds on `c` and `M` hold. -/
theorem abs_dl1_le_large {q0 c M : ℝ} (h0 : 1 < q0) (hc0 : 0 ≤ c)
    (hc : 1.5708 + 1 / (6.28318 * (q0 ^ 2 - 1)) + 1 / (6.28318 * (q0 ^ 2 - 1)) ^ 2 ≤ c)
    (hM : 1.5827 + c * q0 ^ 2 / (6.28318 * (q0 ^ 2 - 1))
        + 1.3184 * (q0 ^ 4 / (q0 ^ 2 - 1) ^ 2) ≤ M) :
    ∀ v ∈ Ici (vBP q0), |dl1 v| ≤ M * Real.exp (-(v / 2)) := by
  intro v hv
  have hq0 : (0:ℝ) < q0 := by linarith
  have hs : (0:ℝ) < q0 ^ 2 - 1 := by nlinarith
  have hr0 : (1:ℝ) < q0 ^ 2 := by nlinarith
  have hexp : q0 ^ 2 ≤ Real.exp v := by
    rw [← exp_vBP hq0]
    exact Real.exp_le_exp.2 hv
  have hv0 : 0 ≤ v := le_trans (vBP_nonneg h0.le) hv
  have hpi1 : (3.14159:ℝ) < π := by linarith [Real.pi_gt_d6]
  have hpi2 : π < 3.1416 := by linarith [Real.pi_lt_d6]
  set L : ℝ := 6.28318 * (q0 ^ 2 - 1) with hL
  have hLpos : (0:ℝ) < L := by rw [hL]; positivity
  have hLle : L ≤ 2 * π * (q0 ^ 2 - 1) := by rw [hL]; nlinarith
  have hcpi : π / 2 + 1 / (2 * π * (q0 ^ 2 - 1)) + 1 / (2 * π * (q0 ^ 2 - 1)) ^ 2 ≤ c := by
    have h1 : 1 / (2 * π * (q0 ^ 2 - 1)) ≤ 1 / L := one_div_le_one_div_of_le hLpos hLle
    have h2 : 1 / (2 * π * (q0 ^ 2 - 1)) ^ 2 ≤ 1 / L ^ 2 := by
      refine one_div_le_one_div_of_le (by positivity) ?_
      nlinarith
    linarith
  have hB := exp_mul_siDiv_uMinus_le_asymp hr0 hexp hcpi
  have hD := four_pi_exp_sq_mul_abs_sinMoment_uMinus_le_large hr0 hexp
  have hkey := abs_dl1_le_of_bounds hv0 hB hD
  have hB' : c * q0 ^ 2 / (2 * π * (q0 ^ 2 - 1)) ≤ c * q0 ^ 2 / L :=
    div_le_div_of_nonneg_left (mul_nonneg hc0 (sq_nonneg q0)) hLpos hLle
  have hD' : (π + 1) / π * ((q0 ^ 2) ^ 2 / (q0 ^ 2 - 1) ^ 2)
      ≤ 1.3184 * (q0 ^ 4 / (q0 ^ 2 - 1) ^ 2) := by
    have he : (q0 ^ 2) ^ 2 / (q0 ^ 2 - 1) ^ 2 = q0 ^ 4 / (q0 ^ 2 - 1) ^ 2 := by ring
    rw [he]
    refine mul_le_mul_of_nonneg_right ?_ (by positivity)
    rw [div_le_iff₀ (by linarith [Real.pi_pos])]
    linarith
  have hsum : 1.5827 + c * q0 ^ 2 / (2 * π * (q0 ^ 2 - 1))
      + (π + 1) / π * ((q0 ^ 2) ^ 2 / (q0 ^ 2 - 1) ^ 2) ≤ M := by linarith
  calc |dl1 v|
      ≤ (1.5827 + c * q0 ^ 2 / (2 * π * (q0 ^ 2 - 1))
          + (π + 1) / π * ((q0 ^ 2) ^ 2 / (q0 ^ 2 - 1) ^ 2)) * Real.exp (-(v / 2)) := hkey
    _ ≤ M * Real.exp (-(v / 2)) := mul_le_mul_of_nonneg_right hsum (Real.exp_pos _).le

/-! ## 6. The piecewise integral bounds -/

theorem integral_piece_small_le {q0 q1 M : ℝ} (h0 : 1 ≤ q0) (h01 : q0 ≤ q1)
    (hM : 1.5827 + q1 ^ 2 + 8.7731 * (q1 ^ 4 * (q1 ^ 2 - 1)) ≤ M) :
    (∫ v in (vBP q0)..(vBP q1), |dl1 v|) ≤ 2 * M * (1 / q0 - 1 / q1) := by
  have hq0 : (0:ℝ) < q0 := by linarith
  have hq1 : (0:ℝ) < q1 := by linarith
  have hab : vBP q0 ≤ vBP q1 := vBP_mono hq0 h01
  have hbd : ∀ v ∈ Icc (vBP q0) (vBP q1), |dl1 v| ≤ M * Real.exp (-(v / 2)) := by
    intro v hv
    exact abs_dl1_le_small (le_trans h0 h01) hM v ⟨le_trans (vBP_nonneg h0) hv.1, hv.2⟩
  have h := integral_abs_dl1_interval_le hab hbd
  rwa [exp_neg_half_vBP hq0, exp_neg_half_vBP hq1] at h

theorem integral_piece_large_le {q0 q1 c M : ℝ} (h0 : 1 < q0) (h01 : q0 ≤ q1) (hc0 : 0 ≤ c)
    (hc : 1.5708 + 1 / (6.28318 * (q0 ^ 2 - 1)) + 1 / (6.28318 * (q0 ^ 2 - 1)) ^ 2 ≤ c)
    (hM : 1.5827 + c * q0 ^ 2 / (6.28318 * (q0 ^ 2 - 1))
        + 1.3184 * (q0 ^ 4 / (q0 ^ 2 - 1) ^ 2) ≤ M) :
    (∫ v in (vBP q0)..(vBP q1), |dl1 v|) ≤ 2 * M * (1 / q0 - 1 / q1) := by
  have hq0 : (0:ℝ) < q0 := by linarith
  have hq1 : (0:ℝ) < q1 := by linarith
  have hab : vBP q0 ≤ vBP q1 := vBP_mono hq0 h01
  have hbd : ∀ v ∈ Icc (vBP q0) (vBP q1), |dl1 v| ≤ M * Real.exp (-(v / 2)) :=
    fun v hv => abs_dl1_le_large h0 hc0 hc hM v hv.1
  have h := integral_abs_dl1_interval_le hab hbd
  rwa [exp_neg_half_vBP hq0, exp_neg_half_vBP hq1] at h

theorem integral_tail_large_le {q0 c M : ℝ} (h0 : 1 < q0) (hc0 : 0 ≤ c)
    (hc : 1.5708 + 1 / (6.28318 * (q0 ^ 2 - 1)) + 1 / (6.28318 * (q0 ^ 2 - 1)) ^ 2 ≤ c)
    (hM : 1.5827 + c * q0 ^ 2 / (6.28318 * (q0 ^ 2 - 1))
        + 1.3184 * (q0 ^ 4 / (q0 ^ 2 - 1) ^ 2) ≤ M) :
    (∫ v in Ioi (vBP q0), |dl1 v|) ≤ 2 * M / q0 := by
  have hq0 : (0:ℝ) < q0 := by linarith
  have h := integral_Ioi_abs_dl1_tail_le (vBP_nonneg h0.le) (abs_dl1_le_large h0 hc0 hc hM)
  rw [exp_neg_half_vBP hq0] at h
  calc (∫ v in Ioi (vBP q0), |dl1 v|) ≤ 2 * M * (1 / q0) := h
    _ = 2 * M / q0 := by ring

/-! ## 7. The total variation bound -/

/-- **The refined total variation bound**: `∫₀^∞ |(d/dv) δ(e^v)| dv ≤ 12`.
This replaces the crude bound `32` of `RequestProject/DeltaDecaySharp.lean`. -/
theorem integral_Ioi_abs_dl1_le_twelve : (∫ v in Ioi (0:ℝ), |dl1 v|) ≤ 12 := by
  have e1 := integral_piece_small_le (q0 := 1) (q1 := 1.05) (M := 3.7785)
    (by norm_num) (by norm_num) (by norm_num)
  have e2 := integral_piece_small_le (q0 := 1.05) (q1 := 1.1) (M := 5.4907)
    (by norm_num) (by norm_num) (by norm_num)
  have e3 := integral_piece_small_le (q0 := 1.1) (q1 := 1.15) (M := 7.8546)
    (by norm_num) (by norm_num) (by norm_num)
  have e4 := integral_piece_small_le (q0 := 1.15) (q1 := 1.2) (M := 11.0287)
    (by norm_num) (by norm_num) (by norm_num)
  have e5 := integral_piece_large_le (q0 := 1.2) (q1 := 1.3) (c := 2.0634) (M := 16.7786)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e6 := integral_piece_large_le (q0 := 1.3) (q1 := 1.4) (c := 1.8547) (M := 10.2148)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e7 := integral_piece_large_le (q0 := 1.4) (q1 := 1.5) (c := 1.7641) (M := 7.6517)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e8 := integral_piece_large_le (q0 := 1.5) (q1 := 1.7) (c := 1.7144) (M := 6.3456)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e9 := integral_piece_large_le (q0 := 1.7) (q1 := 2) (c := 1.6622) (M := 5.07)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e10 := integral_piece_large_le (q0 := 2) (q1 := 2.5) (c := 1.6267) (M := 4.2718)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e11 := integral_piece_large_le (q0 := 2.5) (q1 := 3) (c := 1.6021) (M := 3.7548)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e12 := integral_piece_large_le (q0 := 3) (q1 := 4) (c := 1.5911) (M := 3.5362)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e13 := integral_tail_large_le (q0 := 4) (c := 1.5816) (M := 3.3514)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have s1 := integral_Ioi_abs_dl1_split (a := vBP 1) (b := vBP 1.05)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_dl1_split (a := vBP 1.05) (b := vBP 1.1)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_dl1_split (a := vBP 1.1) (b := vBP 1.15)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_dl1_split (a := vBP 1.15) (b := vBP 1.2)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_dl1_split (a := vBP 1.2) (b := vBP 1.3)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_dl1_split (a := vBP 1.3) (b := vBP 1.4)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_dl1_split (a := vBP 1.4) (b := vBP 1.5)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_dl1_split (a := vBP 1.5) (b := vBP 1.7)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_dl1_split (a := vBP 1.7) (b := vBP 2)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s10 := integral_Ioi_abs_dl1_split (a := vBP 2) (b := vBP 2.5)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s11 := integral_Ioi_abs_dl1_split (a := vBP 2.5) (b := vBP 3)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s12 := integral_Ioi_abs_dl1_split (a := vBP 3) (b := vBP 4)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [vBP_one] at s1
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 e11 e12 e13 ⊢
  linarith


/-! ## 8. Consequences: sharper decay of `δ̂` and a lower threshold -/

/-- **The decay of `δ̂` refined by the total variation bound**: `|δ̂(t)| ≤ 24/|t|`. -/
theorem abs_deltaFourier_le_twentyfour_div {t : ℝ} (ht : t ≠ 0) :
    |deltaFourier t| ≤ 24 / |t| := by
  have h := abs_deltaFourier_le_of_integral_bound integral_Ioi_abs_dl1_le_twelve ht
  norm_num at h
  exact h

/-- `log(T/2π) ≥ 1.25` for `T ≥ 23`. -/
theorem log_div_two_pi_ge_of_twentythree_le {T : ℝ} (hT : 23 ≤ T) :
    1.25 ≤ Real.log (T / (2 * π)) := by
  have hpi : π ≤ 3.1416 := by linarith [Real.pi_lt_d6]
  have hpi0 : (0:ℝ) < π := Real.pi_pos
  have he : Real.exp 1 < 2.7182818286 := Real.exp_one_lt_d9
  have hq : (0.75:ℝ) ≤ Real.exp (-0.25) := by
    have h := Real.add_one_le_exp (-0.25 : ℝ)
    linarith
  have hmul : Real.exp 1.25 * Real.exp (-0.25) = Real.exp 1 := by
    rw [← Real.exp_add]
    norm_num
  have hexp : Real.exp 1.25 ≤ 3.6244 := by
    nlinarith [Real.exp_pos 1.25, Real.exp_pos (-0.25)]
  rw [Real.le_log_iff_exp_le (by positivity), le_div_iff₀ (by positivity)]
  nlinarith [Real.exp_pos 1.25]

/-- **The Fourier-side inequality of Corollary 2.3 (ii) outside `|t| ≤ 23`.**
`2θ'(t) + δ̂(t) ≥ 0` holds unconditionally for every real `t` with `|t| ≥ 23`.  This
sharpens `fourierSide_nonneg_of_thirtyeight_le_abs`. -/
theorem fourierSide_nonneg_of_twentythree_le_abs {t : ℝ} (ht : 23 ≤ |t|) :
    0 ≤ fourierSide t := by
  have hpi : π ≤ 3.15 := by linarith [Real.pi_lt_d2]
  have hT0 : (0:ℝ) < |t| := by linarith
  have hge := two_thetaDeriv_ge hT0
  have hlog : 1.25 ≤ Real.log (|t| / (2 * π)) := log_div_two_pi_ge_of_twentythree_le ht
  have h4 : 4 / |t| ^ 2 ≤ 4 / 529 := by
    apply div_le_div_of_nonneg_left (by norm_num) (by norm_num)
    nlinarith
  have hpiT : π / |t| ≤ 3.15 / 23 := by
    rw [div_le_div_iff₀ hT0 (by norm_num)]
    nlinarith
  have hth : 2 * thetaDeriv t = 2 * thetaDeriv |t| := by rw [thetaDeriv_abs]
  have hne : t ≠ 0 := by
    intro h
    rw [h] at ht
    norm_num at ht
  have hdec : |deltaFourier t| ≤ 24 / |t| := abs_deltaFourier_le_twentyfour_div hne
  have hdec' : 24 / |t| ≤ 24 / 23 :=
    div_le_div_of_nonneg_left (by norm_num) (by norm_num) ht
  have hlow : -deltaFourier t ≤ 24 / 23 := by
    linarith [neg_abs_le (deltaFourier t), le_abs_self (deltaFourier t)]
  rw [fourierSide, hth]
  linarith

end ConnesConsani.WeilPositivity
