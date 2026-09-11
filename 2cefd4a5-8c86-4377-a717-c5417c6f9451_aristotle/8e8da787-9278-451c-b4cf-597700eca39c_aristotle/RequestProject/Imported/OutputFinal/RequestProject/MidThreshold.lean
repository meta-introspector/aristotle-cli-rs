/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Lowering the threshold in the Fourier-side inequality of Corollary 2.3 (ii) of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771,

from `|t| ≥ 60` to `|t| ≥ 34`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.NearOrigin

noncomputable section

open MeasureTheory Set Real Filter Topology

namespace ConnesConsani.WeilPositivity

/-! ## 1. The alternating *upper* Taylor bound for `Si` -/

/-- For odd `n`, the partial sum of the Taylor series of `sin` is an upper bound on `[0,∞)`. -/
theorem sin_le_sinPart {n : ℕ} (hn : 1 ≤ n) (hodd : Odd n) {t : ℝ} (ht : 0 ≤ t) :
    Real.sin t ≤ sinPart n t := by
  have h := (taylor_sign hn ht).2
  rw [hodd.neg_one_pow] at h
  nlinarith [h]

/-- For odd `n`, the partial sum of the Taylor series of `sinc` is an upper bound on `[0,∞)`. -/
theorem sinc_le_sincPart {n : ℕ} (hn : 1 ≤ n) (hodd : Odd n) {t : ℝ} (ht : 0 ≤ t) :
    Real.sinc t ≤ sincPart n t := by
  rcases eq_or_lt_of_le ht with h | h
  · subst_vars
    rw [sincPart_zero hn]
    simp [Real.sinc]
  · have hsin := sin_le_sinPart hn hodd (le_of_lt h)
    rw [Real.sinc_of_ne_zero (ne_of_gt h), ← sinPart_div n (ne_of_gt h)]
    exact div_le_div_of_nonneg_right hsin h.le

/-- **The Taylor upper bound for `Si`**: for odd `n` and `x ≥ 0`,
`Si x ≤ ∑_{k<n} (-1)^k x^{2k+1}/((2k+1)(2k+1)!)`. -/
theorem Si_le_siPart {n : ℕ} (hn : 1 ≤ n) (hodd : Odd n) {x : ℝ} (hx : 0 ≤ x) :
    Si x ≤ siPart n x := by
  have := nonneg_of_deriv_nonneg (F := fun x => siPart n x - Si x)
    (F' := fun x => sincPart n x - Real.sinc x)
    (fun u => (hasDerivAt_siPart n u).sub (Si_hasDerivAt u))
    (by simp [siPart]) (fun u hu => by linarith [sinc_le_sincPart hn hodd hu]) hx
  linarith

/-- The explicit quintic upper bound `Si x ≤ x - x³/18 + x⁵/600` for `x ≥ 0`. -/
theorem Si_le_quintic {x : ℝ} (hx : 0 ≤ x) : Si x ≤ x - x ^ 3 / 18 + x ^ 5 / 600 := by
  have h := Si_le_siPart (n := 3) (by norm_num) (by decide) hx
  refine h.trans (le_of_eq ?_)
  simp [siPart, Finset.sum_range_succ, Nat.factorial]
  ring

/-! ## 2. The smooth kernel and the two pointwise comparisons -/

/-- The kernel `k_Θ(v) = 2 e^{-v/2}/(1 - e^{-2v})` of `Θ(t) = 2θ'(t) - 2θ'(0)`, written in
`u = e^{-v/2}`. -/
def smoothKernel (v : ℝ) : ℝ :=
  2 * Real.exp (-(v / 2)) / (1 - Real.exp (-(v / 2)) ^ 4)

/-- The unweighted majorant for the excess of `2δ(e^v)` over the smooth kernel. -/
def tailMajorant (v : ℝ) : ℝ :=
  Real.exp (-(v / 2)) ^ 3 / π ^ 2 * (1 + 1 / (1 - Real.exp (-(v / 2)) ^ 2) ^ 2)
    + Real.exp (-(v / 2)) ^ 5 / (2 * π ^ 3) * (1 + 1 / (1 - Real.exp (-(v / 2)) ^ 2) ^ 3)

theorem tailMajorant_nonneg {v : ℝ} (hv : 0 < v) : 0 ≤ tailMajorant v := by
  have hπ : (0:ℝ) < π := Real.pi_pos
  have hu0 : (0:ℝ) < Real.exp (-(v / 2)) := Real.exp_pos _
  have hu1 : Real.exp (-(v / 2)) < 1 := Real.exp_lt_one_iff.2 (by linarith)
  have hu2 : Real.exp (-(v / 2)) ^ 2 < 1 := by nlinarith
  have hden : (0:ℝ) < 1 - Real.exp (-(v / 2)) ^ 2 := by linarith
  unfold tailMajorant
  positivity

/-- `2δ(e^v)` in terms of the two sine integrals. -/
theorem two_delta_eq_si {v : ℝ} (hv : 0 < v) :
    2 * delta (Rplus.expHomeo v)
      = 4 * (1 / Real.exp (-(v / 2))) *
          (Si (2 * π * (1 + Real.exp v)) / (2 * π * (1 + Real.exp v))
            + Si (2 * π * (Real.exp v - 1)) / (2 * π * (Real.exp v - 1))) := by
  have hR1 : (1:ℝ) < Real.exp v := by linarith [Real.add_one_le_exp v]
  have hcoe : ((Rplus.expHomeo v : Rplus) : ℝ) = Real.exp v := rfl
  have hbne : 2 * π * (Real.exp v - 1) ≠ 0 := by
    have : (0:ℝ) < 2 * π * (Real.exp v - 1) := by
      have := Real.pi_pos; nlinarith
    linarith
  have hdelta := delta_explicit (ρ := Rplus.expHomeo v) (by rw [hcoe]; linarith)
  rw [hcoe, siDiv_of_ne_zero hbne] at hdelta
  have hsqrt : Real.sqrt (Real.exp v) = 1 / Real.exp (-(v / 2)) := by
    rw [show Real.exp v = Real.exp (v / 2) * Real.exp (v / 2) by rw [← Real.exp_add]; ring_nf,
      Real.sqrt_mul_self (Real.exp_pos _).le, Real.exp_neg]
    field_simp
  rw [hdelta, hsqrt]
  ring

/-- The smooth kernel in terms of the same two abscissae. -/
theorem smoothKernel_eq_si {v : ℝ} (hv : 0 < v) :
    smoothKernel v
      = 4 * (1 / Real.exp (-(v / 2))) *
          (π / 2 / (2 * π * (1 + Real.exp v)) + π / 2 / (2 * π * (Real.exp v - 1))) := by
  have hπ : (0:ℝ) < π := Real.pi_pos
  set u := Real.exp (-(v / 2)) with hu
  have hu0 : (0:ℝ) < u := Real.exp_pos _
  have hu1 : u < 1 := by rw [hu]; exact Real.exp_lt_one_iff.2 (by linarith)
  have husq : u ^ 2 = Real.exp (-v) := by
    rw [hu, ← Real.exp_nat_mul]; congr 1; push_cast; ring
  have hRu : Real.exp v = 1 / u ^ 2 := by
    rw [husq, Real.exp_neg]; field_simp
  have hu2lt : u ^ 2 < 1 := by nlinarith
  have h1 : (0:ℝ) < 1 - u ^ 2 := by linarith
  have h2 : (0:ℝ) < 1 + u ^ 2 := by positivity
  have h4 : (0:ℝ) < 1 - u ^ 4 := by nlinarith
  rw [smoothKernel, ← hu, hRu]
  field_simp
  ring

/-- **The tail comparison**: for every `v > 0` the excess of `2δ(e^v)` over the smooth
kernel is at most `tailMajorant v`. -/
theorem two_delta_le_smooth_add {v : ℝ} (hv : 0 < v) :
    2 * delta (Rplus.expHomeo v) ≤ smoothKernel v + tailMajorant v := by
  have hπ : (0:ℝ) < π := Real.pi_pos
  set u := Real.exp (-(v / 2)) with hu
  have hu0 : (0:ℝ) < u := Real.exp_pos _
  have hu1 : u < 1 := by rw [hu]; exact Real.exp_lt_one_iff.2 (by linarith)
  have husq : u ^ 2 = Real.exp (-v) := by
    rw [hu, ← Real.exp_nat_mul]; congr 1; push_cast; ring
  have hRu : Real.exp v = 1 / u ^ 2 := by
    rw [husq, Real.exp_neg]; field_simp
  have hu2lt : u ^ 2 < 1 := by nlinarith
  have hden : (0:ℝ) < 1 - u ^ 2 := by linarith
  set a := 2 * π * (1 + Real.exp v) with ha
  set b := 2 * π * (Real.exp v - 1) with hb
  have hRgt : (1:ℝ) < Real.exp v := by linarith [Real.add_one_le_exp v]
  have hapos : (0:ℝ) < a := by rw [ha]; nlinarith
  have hbpos : (0:ℝ) < b := by rw [hb]; nlinarith
  have hSa : Si a / a ≤ π / 2 / a + 1 / a ^ 2 + 1 / a ^ 3 := by
    have h := Si_le_of_pos hapos
    rw [div_le_iff₀ hapos]
    have h2 : (π / 2 / a + 1 / a ^ 2 + 1 / a ^ 3) * a = π / 2 + 1 / a + 1 / a ^ 2 := by field_simp
    rw [h2]; exact h
  have hSb : Si b / b ≤ π / 2 / b + 1 / b ^ 2 + 1 / b ^ 3 := by
    have h := Si_le_of_pos hbpos
    rw [div_le_iff₀ hbpos]
    have h2 : (π / 2 / b + 1 / b ^ 2 + 1 / b ^ 3) * b = π / 2 + 1 / b + 1 / b ^ 2 := by field_simp
    rw [h2]; exact h
  -- lower bound for `a`, exact value of `b`
  have ha_lb : 2 * π / u ^ 2 ≤ a := by
    rw [ha, hRu]
    have : (0:ℝ) < u ^ 2 := by positivity
    rw [div_le_iff₀ this]
    field_simp
    nlinarith
  have hb_eq : b = 2 * π * (1 - u ^ 2) / u ^ 2 := by
    rw [hb, hRu]; field_simp
  -- the four error terms
  have hcpos : (0:ℝ) < 4 * (1 / u) := by positivity
  have t1 : 4 * (1 / u) * (1 / a ^ 2) ≤ u ^ 3 / π ^ 2 := by
    have h1 : (2 * π / u ^ 2) ^ 2 ≤ a ^ 2 := pow_le_pow_left₀ (by positivity) ha_lb 2
    have h3 : 1 / a ^ 2 ≤ 1 / (2 * π / u ^ 2) ^ 2 := one_div_le_one_div_of_le (by positivity) h1
    have h2 : 1 / (2 * π / u ^ 2) ^ 2 = u ^ 4 / (4 * π ^ 2) := by
      rw [div_pow]; field_simp; ring
    rw [h2] at h3
    calc 4 * (1 / u) * (1 / a ^ 2) ≤ 4 * (1 / u) * (u ^ 4 / (4 * π ^ 2)) :=
          mul_le_mul_of_nonneg_left h3 hcpos.le
      _ = u ^ 3 / π ^ 2 := by field_simp
  have t2 : 4 * (1 / u) * (1 / a ^ 3) ≤ u ^ 5 / (2 * π ^ 3) := by
    have h1 : (2 * π / u ^ 2) ^ 3 ≤ a ^ 3 := pow_le_pow_left₀ (by positivity) ha_lb 3
    have h3 : 1 / a ^ 3 ≤ 1 / (2 * π / u ^ 2) ^ 3 := one_div_le_one_div_of_le (by positivity) h1
    have h2 : 1 / (2 * π / u ^ 2) ^ 3 = u ^ 6 / (8 * π ^ 3) := by
      rw [div_pow]; field_simp; ring
    rw [h2] at h3
    calc 4 * (1 / u) * (1 / a ^ 3) ≤ 4 * (1 / u) * (u ^ 6 / (8 * π ^ 3)) :=
          mul_le_mul_of_nonneg_left h3 hcpos.le
      _ = u ^ 5 / (2 * π ^ 3) := by field_simp; ring
  have t3 : 4 * (1 / u) * (1 / b ^ 2) = u ^ 3 / π ^ 2 * (1 / (1 - u ^ 2) ^ 2) := by
    rw [hb_eq]
    field_simp
    ring
  have t4 : 4 * (1 / u) * (1 / b ^ 3) = u ^ 5 / (2 * π ^ 3) * (1 / (1 - u ^ 2) ^ 3) := by
    rw [hb_eq]
    field_simp
    ring
  have hexpand : 2 * delta (Rplus.expHomeo v)
      ≤ smoothKernel v + (4 * (1 / u) * (1 / a ^ 2) + 4 * (1 / u) * (1 / a ^ 3)
          + 4 * (1 / u) * (1 / b ^ 2) + 4 * (1 / u) * (1 / b ^ 3)) := by
    rw [two_delta_eq_si hv, smoothKernel_eq_si hv, ← ha, ← hb, ← hu]
    have hupos : (0:ℝ) < 1 / u := by positivity
    nlinarith [hSa, hSb, hupos]
  refine hexpand.trans ?_
  rw [tailMajorant, ← hu, t3, t4]
  have e1 : u ^ 3 / π ^ 2 * (1 + 1 / (1 - u ^ 2) ^ 2)
      = u ^ 3 / π ^ 2 + u ^ 3 / π ^ 2 * (1 / (1 - u ^ 2) ^ 2) := by ring
  have e2 : u ^ 5 / (2 * π ^ 3) * (1 + 1 / (1 - u ^ 2) ^ 3)
      = u ^ 5 / (2 * π ^ 3) + u ^ 5 / (2 * π ^ 3) * (1 / (1 - u ^ 2) ^ 3) := by ring
  rw [e1, e2]
  linarith [t1, t2]

/-! ## 3. The kernel dominates `2δ` up to `v = 1/4` -/

/-- `exp (1/4) ≤ 1.28403`. -/
theorem exp_quarter_le : Real.exp (1 / 4 : ℝ) ≤ 1.28403 := by
  have hb := Real.exp_bound (x := (1/4 : ℝ)) (by rw [abs_of_nonneg (by norm_num)]; norm_num)
    (n := 5) (by norm_num)
  have h := (abs_le.1 hb).2
  rw [abs_of_nonneg (by norm_num : (0:ℝ) ≤ (1/4:ℝ))] at h
  norm_num [Finset.sum_range_succ, Nat.factorial] at h
  linarith

/-- The gap between `π/2` and `Si b` on the range of abscissae `b = 2π(ρ-1)`, `ρ ≤ e^{1/4}`,
which occur below `v = 1/4`. -/
theorem si_gap_lower {b : ℝ} (hb0 : 0 < b) (hb : b ≤ 1.7851) : 0.0057 * b ≤ π / 2 - Si b := by
  have hπ : (3.14159 : ℝ) < π := by linarith [Real.pi_gt_d6]
  have hq := Si_le_quintic hb0.le
  have hb4 : b ^ 4 ≤ 1.7851 ^ 4 := pow_le_pow_left₀ hb0.le hb 4
  have h5 : b ^ 5 ≤ 1.7851 ^ 4 * b := by nlinarith
  have hfac : 0 ≤ (1.7851 - b) * (1.0227 - (b ^ 2 + b * 1.7851 + 1.7851 ^ 2) / 18) := by
    refine mul_nonneg (by linarith) ?_
    nlinarith
  nlinarith [hfac, h5, hq]

/-- **The kernel already dominates `2δ(e^v)` for `v ≤ 1/4`.** -/
theorem two_delta_le_smoothKernel {v : ℝ} (h1 : 1 / 5 ≤ v) (h2 : v ≤ 1 / 4) :
    2 * delta (Rplus.expHomeo v) ≤ smoothKernel v := by
  have hπ : (3.14159 : ℝ) < π := by linarith [Real.pi_gt_d6]
  have hπ' : π < 3.1416 := by linarith [Real.pi_lt_d4]
  have hv : (0:ℝ) < v := by linarith
  have hRlb : (1.2 : ℝ) ≤ Real.exp v := by linarith [Real.add_one_le_exp v]
  have hRub : Real.exp v ≤ 1.28403 := le_trans (Real.exp_le_exp.2 h2) exp_quarter_le
  set a := 2 * π * (1 + Real.exp v) with ha
  set b := 2 * π * (Real.exp v - 1) with hb
  have hapos : (0:ℝ) < a := by rw [ha]; nlinarith
  have hbpos : (0:ℝ) < b := by rw [hb]; nlinarith
  have ha_lb : (13.82 : ℝ) ≤ a := by rw [ha]; nlinarith
  have hb_ub : b ≤ 1.7851 := by rw [hb]; nlinarith
  -- the `a`-side error is at most `0.0057`
  have hAa : Si a / a ≤ π / 2 / a + 0.0057 := by
    have h := Si_le_of_pos hapos
    have hinv : 1 / a ^ 2 + 1 / a ^ 3 ≤ 0.0057 := by
      have h2a : (13.82:ℝ) ^ 2 ≤ a ^ 2 := by nlinarith
      have h3a : (13.82:ℝ) ^ 3 ≤ a ^ 3 := by nlinarith
      have i2 : 1 / a ^ 2 ≤ 1 / (13.82:ℝ) ^ 2 := one_div_le_one_div_of_le (by norm_num) h2a
      have i3 : 1 / a ^ 3 ≤ 1 / (13.82:ℝ) ^ 3 := one_div_le_one_div_of_le (by norm_num) h3a
      norm_num at i2 i3 ⊢
      linarith
    rw [div_le_iff₀ hapos]
    have hid : (π / 2 / a + 0.0057) * a = π / 2 + 0.0057 * a := by field_simp
    rw [hid]
    have hcalc : 1 / a + 1 / a ^ 2 ≤ 0.0057 * a := by
      have hmul := mul_le_mul_of_nonneg_right hinv hapos.le
      have hid2 : (1 / a ^ 2 + 1 / a ^ 3) * a = 1 / a + 1 / a ^ 2 := by field_simp
      rw [hid2] at hmul
      linarith
    linarith
  -- the `b`-side gain is at least `0.0057`
  have hAb : Si b / b ≤ π / 2 / b - 0.0057 := by
    have h := si_gap_lower hbpos hb_ub
    rw [div_le_iff₀ hbpos]
    have hid : (π / 2 / b - 0.0057) * b = π / 2 - 0.0057 * b := by field_simp
    rw [hid]
    linarith
  have hsum : Si a / a + Si b / b ≤ π / 2 / a + π / 2 / b := by linarith
  rw [two_delta_eq_si hv, smoothKernel_eq_si hv, ← ha, ← hb]
  have hupos : (0:ℝ) < 4 * (1 / Real.exp (-(v / 2))) := by positivity
  exact mul_le_mul_of_nonneg_left hsum hupos.le

/-! ## 4. The mass of the tail majorant -/

/-- The antiderivative of the tail majorant, as a function of `u = e^{-v/2}`. -/
def midAntiU (x : ℝ) : ℝ :=
  (-(2 / 3) * x ^ 3 - x / (1 - x ^ 2) + (Real.log (1 + x) - Real.log (1 - x)) / 2) / π ^ 2
    + (-(2 / 5) * x ^ 5 - 1 / 2 * (x / (1 - x ^ 2) ^ 2) + 5 / 4 * (x / (1 - x ^ 2))
        - 3 * (Real.log (1 + x) - Real.log (1 - x)) / 8) / (2 * π ^ 3)

/-- The antiderivative of the tail majorant. -/
def midAnti (v : ℝ) : ℝ := midAntiU (Real.exp (-(v / 2)))

theorem hasDerivAt_div_one_sub_sq {x : ℝ} (hx : 1 - x ^ 2 ≠ 0) :
    HasDerivAt (fun y : ℝ => y / (1 - y ^ 2)) ((1 + x ^ 2) / (1 - x ^ 2) ^ 2) x := by
  have hd : HasDerivAt (fun y : ℝ => 1 - y ^ 2) (-(2 * x)) x := by
    have h := (hasDerivAt_pow 2 x).const_sub 1
    convert h using 1
    norm_num
  have h := (hasDerivAt_id x).div hd hx
  convert h using 1
  simp only [id_eq]
  field_simp
  ring

theorem hasDerivAt_div_one_sub_sq_sq {x : ℝ} (hx : 1 - x ^ 2 ≠ 0) :
    HasDerivAt (fun y : ℝ => y / (1 - y ^ 2) ^ 2) ((1 + 3 * x ^ 2) / (1 - x ^ 2) ^ 3) x := by
  have hd : HasDerivAt (fun y : ℝ => 1 - y ^ 2) (-(2 * x)) x := by
    have h := (hasDerivAt_pow 2 x).const_sub 1
    convert h using 1
    norm_num
  have hd2 : HasDerivAt (fun y : ℝ => (1 - y ^ 2) ^ 2) (2 * (1 - x ^ 2) * -(2 * x)) x := by
    have h := hd.pow 2
    convert h using 1
    ring
  have hne : (1 - x ^ 2) ^ 2 ≠ 0 := pow_ne_zero 2 hx
  have h := (hasDerivAt_id x).div hd2 hne
  convert h using 1
  simp only [id_eq]
  field_simp
  ring

theorem hasDerivAt_logDiff {x : ℝ} (hx1 : 1 + x ≠ 0) (hx2 : 1 - x ≠ 0) :
    HasDerivAt (fun y : ℝ => Real.log (1 + y) - Real.log (1 - y)) (2 / (1 - x ^ 2)) x := by
  have hnex : 1 - x ^ 2 ≠ 0 := by
    have h : 1 - x ^ 2 = (1 - x) * (1 + x) := by ring
    rw [h]; exact mul_ne_zero hx2 hx1
  have h1 : HasDerivAt (fun y : ℝ => Real.log (1 + y)) (1 / (1 + x)) x := by
    have hd : HasDerivAt (fun y : ℝ => 1 + y) 1 x := by simpa using (hasDerivAt_id x).const_add 1
    simpa [one_div] using hd.log hx1
  have h2 : HasDerivAt (fun y : ℝ => Real.log (1 - y)) (-(1 / (1 - x))) x := by
    have hd : HasDerivAt (fun y : ℝ => 1 - y) (-1) x := by
      simpa using (hasDerivAt_id x).const_sub 1
    have h := hd.log hx2
    convert h using 1
    field_simp
  have h := h1.sub h2
  convert h using 1
  field_simp
  ring

theorem hasDerivAt_midAntiU {x : ℝ} (hx1 : 1 + x ≠ 0) (hx2 : 1 - x ≠ 0) :
    HasDerivAt midAntiU
      ((-(2 / 3) * (3 * x ^ 2) - (1 + x ^ 2) / (1 - x ^ 2) ^ 2 + 2 / (1 - x ^ 2) / 2) / π ^ 2
        + (-(2 / 5) * (5 * x ^ 4) - 1 / 2 * ((1 + 3 * x ^ 2) / (1 - x ^ 2) ^ 3)
            + 5 / 4 * ((1 + x ^ 2) / (1 - x ^ 2) ^ 2) - 3 * (2 / (1 - x ^ 2)) / 8)
          / (2 * π ^ 3)) x := by
  have hne : 1 - x ^ 2 ≠ 0 := by
    have h : 1 - x ^ 2 = (1 - x) * (1 + x) := by ring
    rw [h]
    exact mul_ne_zero hx2 hx1
  have hA := hasDerivAt_div_one_sub_sq hne
  have hB := hasDerivAt_div_one_sub_sq_sq hne
  have hC := hasDerivAt_logDiff hx1 hx2
  have h3 : HasDerivAt (fun y : ℝ => -(2 / 3) * y ^ 3) (-(2 / 3) * (3 * x ^ 2)) x := by
    simpa using (hasDerivAt_pow 3 x).const_mul (-(2 / 3) : ℝ)
  have h5 : HasDerivAt (fun y : ℝ => -(2 / 5) * y ^ 5) (-(2 / 5) * (5 * x ^ 4)) x := by
    simpa using (hasDerivAt_pow 5 x).const_mul (-(2 / 5) : ℝ)
  exact (((h3.sub hA).add (hC.div_const 2)).div_const _).add
    ((((h5.sub (hB.const_mul (1 / 2 : ℝ))).add (hA.const_mul (5 / 4 : ℝ))).sub
      ((hC.const_mul (3 : ℝ)).div_const 8)).div_const _)

theorem hasDerivAt_midAnti {v : ℝ} (hv : 0 < v) : HasDerivAt midAnti (tailMajorant v) v := by
  have hπ : (0:ℝ) < π := Real.pi_pos
  set u := Real.exp (-(v / 2)) with hu
  have hu0 : (0:ℝ) < u := Real.exp_pos _
  have hu1 : u < 1 := by rw [hu]; exact Real.exp_lt_one_iff.2 (by linarith)
  have hx1 : 1 + u ≠ 0 := by positivity
  have hx2 : 1 - u ≠ 0 := by
    intro h
    have : u = 1 := by linarith
    linarith
  have hne : (0:ℝ) < 1 - u ^ 2 := by nlinarith
  have hexp : HasDerivAt (fun w : ℝ => Real.exp (-(w / 2))) (-(u / 2)) v := by
    have hd : HasDerivAt (fun w : ℝ => -(w / 2)) (-(1 / 2) : ℝ) v := by
      simpa using ((hasDerivAt_id v).div_const 2).neg
    have h := hd.exp
    rw [hu]
    convert h using 1
    ring
  have hcomp := (hasDerivAt_midAntiU hx1 hx2).comp v hexp
  have hgoal : HasDerivAt midAnti
      (((-(2 / 3) * (3 * u ^ 2) - (1 + u ^ 2) / (1 - u ^ 2) ^ 2 + 2 / (1 - u ^ 2) / 2) / π ^ 2
        + (-(2 / 5) * (5 * u ^ 4) - 1 / 2 * ((1 + 3 * u ^ 2) / (1 - u ^ 2) ^ 3)
            + 5 / 4 * ((1 + u ^ 2) / (1 - u ^ 2) ^ 2) - 3 * (2 / (1 - u ^ 2)) / 8)
          / (2 * π ^ 3)) * -(u / 2)) v := hcomp
  convert hgoal using 1
  rw [tailMajorant, ← hu]
  have hnez : (1 - u ^ 2) ≠ 0 := ne_of_gt hne
  field_simp
  ring

theorem tendsto_midAnti : Tendsto midAnti atTop (𝓝 0) := by
  have h1 : Tendsto (fun v : ℝ => Real.exp (-(v / 2))) atTop (𝓝 0) := by
    have hb : Tendsto (fun v : ℝ => -(v / 2)) atTop atBot :=
      Filter.tendsto_neg_atTop_atBot.comp (Filter.tendsto_id.atTop_div_const (by norm_num))
    exact Real.tendsto_exp_atBot.comp hb
  have h2 : ContinuousAt midAntiU 0 :=
    (hasDerivAt_midAntiU (by norm_num) (by norm_num)).continuousAt
  have h := h2.tendsto.comp h1
  have hzero : midAntiU 0 = 0 := by
    simp [midAntiU]
  rw [hzero] at h
  exact h

theorem integral_tailMajorant_Ioi :
    ∫ v in Ioi (1 / 4 : ℝ), tailMajorant v = -midAnti (1 / 4) := by
  have h := integral_Ioi_of_hasDerivAt_of_nonneg
    ((hasDerivAt_midAnti (by norm_num : (0:ℝ) < 1 / 4)).continuousAt.continuousWithinAt)
    (fun x hx => hasDerivAt_midAnti (lt_trans (by norm_num) hx))
    (fun x hx => tailMajorant_nonneg (lt_trans (by norm_num) hx)) tendsto_midAnti
  simpa using h

/-- Two-sided bounds for `e^{-1/8}`. -/
theorem exp_neg_eighth_bounds :
    (0.8824 : ℝ) ≤ Real.exp (-(1 / 8) : ℝ) ∧ Real.exp (-(1 / 8) : ℝ) ≤ 0.8825 := by
  have hb := Real.exp_bound (x := (-(1/8) : ℝ)) (by rw [abs_of_nonpos (by norm_num)]; norm_num)
    (n := 5) (by norm_num)
  rw [abs_of_nonpos (by norm_num : (-(1/8):ℝ) ≤ 0)] at hb
  have h1 := (abs_le.1 hb).1
  have h2 := (abs_le.1 hb).2
  norm_num [Finset.sum_range_succ, Nat.factorial] at h1 h2
  constructor <;> linarith

/-- **The total mass of the tail majorant beyond `v = 1/4` is at most `0.4`** (its true value
is `0.39536…`). -/
theorem integral_tailMajorant_le : ∫ v in Ioi (1 / 4 : ℝ), tailMajorant v ≤ 0.4 := by
  have hπ : (3.14159 : ℝ) < π := by linarith [Real.pi_gt_d6]
  rw [integral_tailMajorant_Ioi, midAnti, midAntiU]
  set x := Real.exp (-((1:ℝ) / 4 / 2)) with hxdef
  have hxe : x = Real.exp (-(1 / 8) : ℝ) := by rw [hxdef]; norm_num
  have hx_lb : (0.8824 : ℝ) ≤ x := by rw [hxe]; exact exp_neg_eighth_bounds.1
  have hx_ub : x ≤ 0.8825 := by rw [hxe]; exact exp_neg_eighth_bounds.2
  have hd_lb : (0.2211 : ℝ) ≤ 1 - x ^ 2 := by nlinarith
  have hd_ub : 1 - x ^ 2 ≤ 0.2214 := by nlinarith
  have hdpos : (0:ℝ) < 1 - x ^ 2 := by linarith
  set A := Real.log (1 + x) - Real.log (1 - x) with hAdef
  have hA_eq : A = Real.log ((1 + x) / (1 - x)) := by
    rw [hAdef, Real.log_div (by linarith) (by linarith)]
  have hr_lb : (16:ℝ) ≤ (1 + x) / (1 - x) := by
    rw [le_div_iff₀ (by linarith)]; linarith
  have hr_ub : (1 + x) / (1 - x) ≤ 16.03 := by
    rw [div_le_iff₀ (by linarith)]; linarith
  have hlog16 : Real.log 16 = 4 * Real.log 2 := by
    rw [show (16:ℝ) = 2 ^ (4:ℕ) by norm_num, Real.log_pow]
    norm_num
  have hA_lb : (2.7725887 : ℝ) ≤ A := by
    have h := Real.log_le_log (by norm_num : (0:ℝ) < 16) hr_lb
    rw [hlog16] at h
    have h2 := Real.log_two_gt_d9
    rw [hA_eq]
    linarith
  have hA_ub : A ≤ 2.7744638 := by
    have hrpos : (0:ℝ) < (1 + x) / (1 - x) := by linarith
    have h := Real.log_le_sub_one_of_pos (x := (1 + x) / (1 - x) / 16) (by positivity)
    rw [Real.log_div (by positivity) (by norm_num), hlog16] at h
    have hq : (1 + x) / (1 - x) / 16 ≤ 16.03 / 16 := by linarith
    have h2 := Real.log_two_lt_d9
    rw [hA_eq]
    linarith
  clear_value A x
  clear hxdef hAdef hxe hA_eq hlog16 hr_lb hr_ub
  -- bounds on the two rational functions of `x`
  have e_up : x / (1 - x ^ 2) ≤ 3.99 := by
    rw [div_le_iff₀ hdpos]; nlinarith
  have e_lo : (3.98 : ℝ) ≤ x / (1 - x ^ 2) := by
    rw [le_div_iff₀ hdpos]; nlinarith
  have f_up : x / (1 - x ^ 2) ^ 2 ≤ 18.06 := by
    rw [div_le_iff₀ (by positivity)]; nlinarith
  have hp2 : (9.8695 : ℝ) ≤ π ^ 2 := by nlinarith [hπ, Real.pi_pos]
  have hp3 : (31.006 : ℝ) ≤ π ^ 3 := by nlinarith [hπ, Real.pi_pos]
  have hx3 : x ^ 3 ≤ 0.68746 := by
    have h := pow_le_pow_left₀ (by linarith : (0:ℝ) ≤ x) hx_ub 3
    norm_num at h
    linarith
  have hx5 : x ^ 5 ≤ 0.53547 := by
    have h := pow_le_pow_left₀ (by linarith : (0:ℝ) ≤ x) hx_ub 5
    norm_num at h
    linarith
  have hsplit : -((-(2 / 3) * x ^ 3 - x / (1 - x ^ 2) + A / 2) / π ^ 2
        + (-(2 / 5) * x ^ 5 - 1 / 2 * (x / (1 - x ^ 2) ^ 2) + 5 / 4 * (x / (1 - x ^ 2))
            - 3 * A / 8) / (2 * π ^ 3))
      = ((2 / 3) * x ^ 3 + x / (1 - x ^ 2) - A / 2) / π ^ 2
        + ((2 / 5) * x ^ 5 + 1 / 2 * (x / (1 - x ^ 2) ^ 2) - 5 / 4 * (x / (1 - x ^ 2))
            + 3 * A / 8) / (2 * π ^ 3) := by ring
  rw [hsplit]
  have hb1 : (2 / 3) * x ^ 3 + x / (1 - x ^ 2) - A / 2 ≤ 3.063 := by linarith
  have hb2 : (2 / 5) * x ^ 5 + 1 / 2 * (x / (1 - x ^ 2) ^ 2) - 5 / 4 * (x / (1 - x ^ 2))
      + 3 * A / 8 ≤ 5.31 := by linarith
  have hs1 : ((2 / 3) * x ^ 3 + x / (1 - x ^ 2) - A / 2) / π ^ 2 ≤ 0.3104 := by
    rw [div_le_iff₀ (by positivity)]
    nlinarith
  have hs2 : ((2 / 5) * x ^ 5 + 1 / 2 * (x / (1 - x ^ 2) ^ 2) - 5 / 4 * (x / (1 - x ^ 2))
      + 3 * A / 8) / (2 * π ^ 3) ≤ 0.0857 := by
    rw [div_le_iff₀ (by positivity)]
    nlinarith
  linarith

/-! ## 5. The gap between the smooth kernel and its truncation -/

/-- The majorant for the excess of the smooth kernel over its eight-term truncation. -/
def gapMajorant (v : ℝ) : ℝ := 6.07 * Real.exp (-(33 * v / 2))

/-- An antiderivative of `gapMajorant`. -/
def gapAnti (v : ℝ) : ℝ := -(6.07 * (2 / 33)) * Real.exp (-(33 * v / 2))

theorem gapMajorant_nonneg (v : ℝ) : 0 ≤ gapMajorant v := by
  unfold gapMajorant; positivity

theorem hasDerivAt_gapAnti (v : ℝ) : HasDerivAt gapAnti (gapMajorant v) v := by
  have hd : HasDerivAt (fun w : ℝ => -(33 * w / 2)) (-(33 / 2) : ℝ) v := by
    simpa using (((hasDerivAt_id v).const_mul (33:ℝ)).div_const 2).neg
  have h := (hd.exp).const_mul (-(6.07 * (2 / 33)) : ℝ)
  convert h using 1
  rw [gapMajorant]
  ring

theorem continuous_gapAnti : Continuous gapAnti := by
  unfold gapAnti
  fun_prop

theorem tendsto_gapAnti : Tendsto gapAnti atTop (𝓝 0) := by
  have hb : Tendsto (fun v : ℝ => -(33 * v / 2)) atTop atBot := by
    have : Tendsto (fun v : ℝ => 33 * v / 2) atTop atTop := by
      apply Filter.Tendsto.atTop_div_const (by norm_num)
      exact Filter.tendsto_id.const_mul_atTop (by norm_num)
    exact Filter.tendsto_neg_atTop_atBot.comp this
  have h := (Real.tendsto_exp_atBot.comp hb).const_mul (-(6.07 * (2 / 33)) : ℝ)
  rw [mul_zero] at h
  exact h.congr fun v => by rw [gapAnti]; rfl

/-- `exp (-2/5) ≤ 0.6705`. -/
theorem exp_neg_two_fifths_le : Real.exp (-(2 / 5 : ℝ)) ≤ 0.6705 := by
  have h := Real.sum_le_exp_of_nonneg (x := (2 / 5 : ℝ)) (by norm_num) 5
  have hs : (1.4917 : ℝ) ≤ ∑ i ∈ Finset.range 5, (2 / 5 : ℝ) ^ i / (i.factorial : ℝ) := by
    norm_num [Finset.sum_range_succ, Nat.factorial]
  have hle : (1.4917 : ℝ) ≤ Real.exp (2 / 5) := le_trans hs h
  have hinv := one_div_le_one_div_of_le (by norm_num : (0:ℝ) < 1.4917) hle
  rw [Real.exp_neg, inv_eq_one_div]
  norm_num at hinv ⊢
  linarith

theorem thetaTruncKernel_le_smoothKernel {v : ℝ} (hv : 0 < v) :
    thetaTruncKernel v ≤ smoothKernel v := by
  set u := Real.exp (-(v / 2)) with hu
  have hu0 : (0:ℝ) < u := Real.exp_pos _
  have hu1 : u < 1 := by rw [hu]; exact Real.exp_lt_one_iff.2 (by linarith)
  have hu4 : u ^ 4 < 1 := pow_lt_one₀ hu0.le hu1 (by norm_num)
  have hden : (0:ℝ) < 1 - u ^ 4 := by linarith
  have h32 : (0:ℝ) < u ^ 32 := by positivity
  rw [thetaTruncKernel_eq_u hv, smoothKernel, ← hu]
  rw [div_le_div_iff₀ hden hden]
  nlinarith [mul_nonneg (mul_nonneg (by positivity : (0:ℝ) ≤ 2 * u) hden.le) h32.le]

/-- The excess of the smooth kernel over its truncation decays like `e^{-33v/2}`. -/
theorem smooth_sub_trunc_le_gap {v : ℝ} (hv : 1 / 5 ≤ v) :
    smoothKernel v - thetaTruncKernel v ≤ gapMajorant v := by
  have hv0 : (0:ℝ) < v := by linarith
  set u := Real.exp (-(v / 2)) with hu
  have hu0 : (0:ℝ) < u := Real.exp_pos _
  have hu1 : u < 1 := by rw [hu]; exact Real.exp_lt_one_iff.2 (by linarith)
  have hu4eq : u ^ 4 = Real.exp (-(2 * v)) := by
    rw [hu, ← Real.exp_nat_mul]; congr 1; push_cast; ring
  have hu4le : u ^ 4 ≤ 0.6705 := by
    rw [hu4eq]
    exact le_trans (Real.exp_le_exp.2 (by linarith)) exp_neg_two_fifths_le
  have hden : (0.3295 : ℝ) ≤ 1 - u ^ 4 := by linarith
  have hdenpos : (0:ℝ) < 1 - u ^ 4 := by linarith
  have hu33 : u ^ 33 = Real.exp (-(33 * v / 2)) := by
    rw [hu, ← Real.exp_nat_mul]; congr 1; push_cast; ring
  have hdiff : smoothKernel v - thetaTruncKernel v = 2 * u ^ 33 / (1 - u ^ 4) := by
    rw [thetaTruncKernel_eq_u hv0, smoothKernel, ← hu]
    field_simp
    ring
  rw [hdiff, gapMajorant, ← hu33]
  rw [div_le_iff₀ hdenpos]
  have hpos : (0:ℝ) < u ^ 33 := by positivity
  nlinarith

theorem integrableOn_gapMajorant_Ioi : IntegrableOn gapMajorant (Ioi (1 / 5 : ℝ)) :=
  integrableOn_Ioi_deriv_of_nonneg (a := (1 / 5 : ℝ)) continuous_gapAnti.continuousWithinAt
    (fun x _ => hasDerivAt_gapAnti x) (fun x _ => gapMajorant_nonneg x) tendsto_gapAnti

theorem integral_gapMajorant_Ioi :
    ∫ v in Ioi (1 / 5 : ℝ), gapMajorant v = -gapAnti (1 / 5) := by
  have h := integral_Ioi_of_hasDerivAt_of_nonneg (a := (1 / 5 : ℝ))
    continuous_gapAnti.continuousWithinAt (fun x _ => hasDerivAt_gapAnti x)
    (fun x _ => gapMajorant_nonneg x) tendsto_gapAnti
  simpa using h

theorem integral_gapMajorant_le : ∫ v in Ioi (1 / 5 : ℝ), gapMajorant v ≤ 0.015 := by
  rw [integral_gapMajorant_Ioi, gapAnti]
  have h : Real.exp (-(33 * (1 / 5 : ℝ) / 2)) ≤ 0.04 := by
    have hx : (33 * (1 / 5 : ℝ) / 2) = 33 / 10 := by norm_num
    rw [hx]
    exact exp_neg_thirtythree_tenths_le
  nlinarith [Real.exp_pos (-(33 * (1 / 5 : ℝ) / 2))]

/-! ## 6. The combined majorant and the spread comparison -/

/-- The majorant used to compare `Δ` with the eight-term partial sum of `Θ`. -/
def midMajorant (v : ℝ) : ℝ :=
  Set.indicator (Ici (1 / 5 : ℝ)) gapMajorant v
    + Set.indicator (Ici (1 / 4 : ℝ)) tailMajorant v

theorem midMajorant_nonneg {v : ℝ} (hv : 0 < v) : 0 ≤ midMajorant v := by
  refine add_nonneg ?_ ?_
  · exact Set.indicator_apply_nonneg fun _ => gapMajorant_nonneg v
  · exact Set.indicator_apply_nonneg fun _ => tailMajorant_nonneg hv

/-- **The pointwise comparison**: `2δ(e^v) ≤ k_{Θ,8}(v) + midMajorant v` for every `v > 0`. -/
theorem two_delta_le_trunc_add_mid {v : ℝ} (hv : 0 < v) :
    2 * delta (Rplus.expHomeo v) ≤ thetaTruncKernel v + midMajorant v := by
  have hgap0 : 0 ≤ Set.indicator (Ici (1 / 5 : ℝ)) gapMajorant v :=
    Set.indicator_apply_nonneg fun _ => gapMajorant_nonneg v
  have htail0 : 0 ≤ Set.indicator (Ici (1 / 4 : ℝ)) tailMajorant v :=
    Set.indicator_apply_nonneg fun _ => tailMajorant_nonneg hv
  rcases le_or_gt v (1 / 5) with hsmall | hbig
  · have hk := two_delta_le_thetaTruncKernel hv.le hsmall
    have := midMajorant_nonneg hv
    linarith
  · have hgap : Set.indicator (Ici (1 / 5 : ℝ)) gapMajorant v = gapMajorant v :=
      Set.indicator_of_mem (mem_Ici.2 hbig.le) _
    have hge : smoothKernel v - thetaTruncKernel v ≤ gapMajorant v :=
      smooth_sub_trunc_le_gap hbig.le
    rcases le_or_gt v (1 / 4) with hmid | hlarge
    · have hk := two_delta_le_smoothKernel hbig.le hmid
      rw [midMajorant, hgap]
      linarith
    · have htail : Set.indicator (Ici (1 / 4 : ℝ)) tailMajorant v = tailMajorant v :=
        Set.indicator_of_mem (mem_Ici.2 hlarge.le) _
      have hk := two_delta_le_smooth_add hv
      rw [midMajorant, hgap, htail]
      linarith

theorem integrableOn_indicator_of_Ici {a : ℝ} (ha : 0 < a) {f : ℝ → ℝ}
    (hf : IntegrableOn f (Ioi a)) : IntegrableOn (Set.indicator (Ici a) f) (Ioi 0) := by
  have hsub : Ici a ∩ Ioi (0:ℝ) = Ici a := by
    ext x
    simp only [Set.mem_inter_iff, Set.mem_Ici, Set.mem_Ioi]
    exact ⟨fun h => h.1, fun h => ⟨h, by linarith⟩⟩
  have hInt : IntegrableOn f (Ici a) := hf.congr_set_ae Ioi_ae_eq_Ici.symm
  rw [IntegrableOn, MeasureTheory.integrable_indicator_iff measurableSet_Ici,
    IntegrableOn, Measure.restrict_restrict measurableSet_Ici, hsub]
  exact hInt

theorem integral_indicator_of_Ici {a : ℝ} (ha : 0 < a) {f : ℝ → ℝ} :
    ∫ v in Ioi (0:ℝ), Set.indicator (Ici a) f v = ∫ v in Ioi a, f v := by
  have hsub : Ioi (0:ℝ) ∩ Ici a = Ici a := by
    ext x
    simp only [Set.mem_inter_iff, Set.mem_Ici, Set.mem_Ioi]
    exact ⟨fun h => h.2, fun h => ⟨by linarith, h⟩⟩
  rw [MeasureTheory.setIntegral_indicator measurableSet_Ici, hsub,
    MeasureTheory.integral_Ici_eq_integral_Ioi]

theorem integrableOn_tailMajorant_Ioi : IntegrableOn tailMajorant (Ioi (1 / 4 : ℝ)) :=
  integrableOn_Ioi_deriv_of_nonneg (a := (1 / 4 : ℝ))
    (hasDerivAt_midAnti (by norm_num : (0:ℝ) < 1 / 4)).continuousAt.continuousWithinAt
    (fun x hx => hasDerivAt_midAnti (lt_trans (by norm_num) hx))
    (fun x hx => tailMajorant_nonneg (lt_trans (by norm_num) hx)) tendsto_midAnti

theorem integrableOn_midMajorant : IntegrableOn midMajorant (Ioi 0) := by
  unfold midMajorant
  exact (integrableOn_indicator_of_Ici (by norm_num) integrableOn_gapMajorant_Ioi).add
    (integrableOn_indicator_of_Ici (by norm_num) integrableOn_tailMajorant_Ioi)

/-- **The total mass of the combined majorant is at most `0.415`.** -/
theorem integral_midMajorant_le : ∫ v in Ioi (0:ℝ), midMajorant v ≤ 0.415 := by
  have hsplit : ∫ v in Ioi (0:ℝ), midMajorant v
      = (∫ v in Ioi (0:ℝ), Set.indicator (Ici (1 / 5 : ℝ)) gapMajorant v)
        + ∫ v in Ioi (0:ℝ), Set.indicator (Ici (1 / 4 : ℝ)) tailMajorant v := by
    simp only [midMajorant]
    exact MeasureTheory.integral_add
      (integrableOn_indicator_of_Ici (by norm_num) integrableOn_gapMajorant_Ioi)
      (integrableOn_indicator_of_Ici (by norm_num) integrableOn_tailMajorant_Ioi)
  rw [hsplit, integral_indicator_of_Ici (by norm_num : (0:ℝ) < 1 / 5),
    integral_indicator_of_Ici (by norm_num : (0:ℝ) < 1 / 4)]
  linarith [integral_gapMajorant_le, integral_tailMajorant_le]

/-! ## 7. The Fourier-side inequality for `|t| ≥ 34` -/

/-- The pointwise bound that is integrated to compare `Δ` with the truncated `Θ`. -/
theorem pointwise_delta_bound_mid (t : ℝ) {v : ℝ} (hv : 0 < v) :
    2 * delta (Rplus.expHomeo v) * (1 - Real.cos (t * v))
      ≤ thetaTruncKernel v * (1 - Real.cos (t * v)) + 2 * midMajorant v := by
  have hcos0 : 0 ≤ 1 - Real.cos (t * v) := by linarith [Real.cos_le_one (t * v)]
  have hcos2 : 1 - Real.cos (t * v) ≤ 2 := by linarith [Real.neg_one_le_cos (t * v)]
  have hk := two_delta_le_trunc_add_mid hv
  have hmid := midMajorant_nonneg hv
  nlinarith [mul_le_mul_of_nonneg_right hk hcos0]

/-- **The spread comparison away from the origin**: `Δ(t) ≤ ∑_{n<8} Θₙ(t) + 0.83`. -/
theorem deltaSpread_le_truncSum_add (t : ℝ) :
    deltaSpread t ≤ (∑ n ∈ Finset.range 8, thetaSeriesTerm t n) + 0.83 := by
  have hIntMaj : IntegrableOn (fun v => 2 * midMajorant v) (Ioi 0) :=
    integrableOn_midMajorant.const_mul 2
  have hIntRHS : IntegrableOn
      (fun v => thetaTruncKernel v * (1 - Real.cos (t * v)) + 2 * midMajorant v) (Ioi 0) :=
    (integrableOn_thetaTruncKernel_mul t).add hIntMaj
  have hmono : ∫ v in Ioi (0:ℝ), 2 * delta (Rplus.expHomeo v) * (1 - Real.cos (t * v))
      ≤ ∫ v in Ioi (0:ℝ),
          (thetaTruncKernel v * (1 - Real.cos (t * v)) + 2 * midMajorant v) := by
    refine MeasureTheory.setIntegral_mono_on (integrableOn_two_delta_mul t) hIntRHS
      measurableSet_Ioi fun v hv => ?_
    exact pointwise_delta_bound_mid t hv
  have hsplit : ∫ v in Ioi (0:ℝ),
      (thetaTruncKernel v * (1 - Real.cos (t * v)) + 2 * midMajorant v)
      = (∑ n ∈ Finset.range 8, thetaSeriesTerm t n)
        + 2 * ∫ v in Ioi (0:ℝ), midMajorant v := by
    rw [MeasureTheory.integral_add (integrableOn_thetaTruncKernel_mul t) hIntMaj,
      integral_thetaTruncKernel, MeasureTheory.integral_const_mul]
  have hmass : 2 * ∫ v in Ioi (0:ℝ), midMajorant v ≤ 0.83 := by
    linarith [integral_midMajorant_le]
  rw [deltaSpread_eq_two_mul_integral_Ioi t]
  rw [hsplit] at hmono
  linarith

theorem thetaSeriesTerm_abs (t : ℝ) (n : ℕ) : thetaSeriesTerm |t| n = thetaSeriesTerm t n := by
  simp [thetaSeriesTerm, sq_abs]

set_option maxHeartbeats 1000000 in
/-- The seventy-two terms `8 ≤ n < 80` of the series for `Θ` already contribute more than
`0.8228` once `|t| ≥ 34`. -/
theorem sum_thetaSeriesTerm_ge_of_thirtyfour {t : ℝ} (ht : 34 ≤ |t|) :
    (0.8228 : ℝ) ≤ ∑ n ∈ Finset.Ico 8 80, thetaSeriesTerm t n := by
  have hmono : ∀ n ∈ Finset.Ico 8 80, thetaSeriesTerm 34 n ≤ thetaSeriesTerm t n := by
    intro n _
    rw [← thetaSeriesTerm_abs t n]
    exact thetaSeriesTerm_mono (by norm_num) ht n
  have hnum : (0.8228 : ℝ) ≤ ∑ n ∈ Finset.Ico 8 80, thetaSeriesTerm (34 : ℝ) n := by
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  linarith [Finset.sum_le_sum hmono]

/-- **The Fourier-side inequality for `|t| ≥ 34`**: `f(t) = 2θ'(t) + δ̂(t) ≥ 0` outside the
interval `|t| < 34`.  This improves the threshold `|t| ≥ 60` of
`RequestProject/ThetaGrowth.lean`. -/
theorem fourierSide_nonneg_of_thirtyfour_le_abs {t : ℝ} (ht : 34 ≤ |t|) :
    0 ≤ fourierSide t := by
  rw [fourierSide_nonneg_iff]
  have hsp := deltaSpread_le_truncSum_add t
  have hsum := sum_thetaSeriesTerm_ge_of_thirtyfour ht
  have hpartial : (∑ n ∈ Finset.range 80, thetaSeriesTerm t n)
      ≤ 2 * thetaDeriv t - 2 * thetaDeriv 0 :=
    sum_le_hasSum _ (fun n _ => thetaSeriesTerm_nonneg t n) (hasSum_thetaDeriv_sub t)
  have hsplit : (∑ n ∈ Finset.range 8, thetaSeriesTerm t n)
      + ∑ n ∈ Finset.Ico 8 80, thetaSeriesTerm t n
      = ∑ n ∈ Finset.range 80, thetaSeriesTerm t n := by
    rw [Finset.range_eq_Ico, Finset.sum_Ico_consecutive _ (by norm_num) (by norm_num)]
  have hzero := fourierSide_zero_ge
  linarith

end ConnesConsani.WeilPositivity
