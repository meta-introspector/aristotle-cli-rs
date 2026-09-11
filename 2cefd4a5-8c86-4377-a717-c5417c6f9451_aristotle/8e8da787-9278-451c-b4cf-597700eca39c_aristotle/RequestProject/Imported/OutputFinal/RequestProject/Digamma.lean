/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The two classical properties of the digamma function used in

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771,

namely

* the **Gauss partial-fraction expansion** `ψ(s) = -γ + ∑_{n≥0} (1/(n+1) - 1/(n+s))`
  (`hasSum_digamma`), and
* the **value `ψ(1/4) = -γ - 3 log 2 - π/2`** (`digamma_quarter`),

are proved here from Mathlib's Gamma-function API.

The route is elementary.  On the positive reals the digamma function is the derivative of
the convex function `log Γ` (Bohr–Mollerup), so it is monotone; combined with the
functional equation `ψ(x+1) = ψ(x) + 1/x` and the value `ψ(n+1) = -γ + H_n` at the integers
this gives the partial-fraction expansion for real arguments.  Both sides are holomorphic
on the half plane `Re s > 0`, so the identity theorem extends it to complex arguments.
The value at `1/4` comes from the logarithmic derivatives of the reflection and duplication
formulas for `Γ`.
-/
import Mathlib

noncomputable section

open Real Nat Filter Topology Set

namespace ConnesConsani.WeilPositivity

local notation "γ" => Real.eulerMascheroniConstant

/-! ## The real digamma function -/

/-- `log Γ` on the reals. -/
def logGammaR : ℝ → ℝ := Real.log ∘ Real.Gamma

/-- The real digamma function `ψ = (log Γ)'`. -/
def psiR (x : ℝ) : ℝ := deriv logGammaR x

theorem differentiableAt_logGammaR {x : ℝ} (hx : 0 < x) : DifferentiableAt ℝ logGammaR x := by
  refine (Real.differentiableAt_Gamma ?_).log (Real.Gamma_ne_zero ?_) <;>
    exact fun m => ne_of_gt (by
      have : (0:ℝ) ≤ (m : ℝ) := m.cast_nonneg
      linarith)

theorem convexOn_logGammaR : ConvexOn ℝ (Ioi 0) logGammaR := Real.convexOn_log_Gamma

theorem logGammaR_add_one {x : ℝ} (hx : 0 < x) :
    logGammaR (x + 1) = logGammaR x + Real.log x := by
  simp only [logGammaR, Function.comp_apply, Real.Gamma_add_one hx.ne',
    Real.log_mul hx.ne' (Real.Gamma_pos_of_pos hx).ne', add_comm]

theorem psiR_eq_div {x : ℝ} (hx : 0 < x) : psiR x = deriv Real.Gamma x / Real.Gamma x := by
  have hd : DifferentiableAt ℝ Real.Gamma x :=
    Real.differentiableAt_Gamma fun m => ne_of_gt (by
      have : (0:ℝ) ≤ (m : ℝ) := m.cast_nonneg
      linarith)
  simpa [psiR, logGammaR, Function.comp_def] using
    deriv.log hd (Real.Gamma_pos_of_pos hx).ne'

theorem psiR_add_one {x : ℝ} (hx : 0 < x) : psiR (x + 1) = psiR x + 1 / x := by
  have hx1 : (0:ℝ) < x + 1 := by linarith
  have h1 : HasDerivAt (fun y : ℝ => logGammaR (y + 1)) (psiR (x + 1)) x :=
    (differentiableAt_logGammaR hx1).hasDerivAt.comp_add_const x 1
  have h2 : HasDerivAt (fun y : ℝ => logGammaR y + Real.log y) (psiR x + 1 / x) x := by
    simpa [one_div] using
      (differentiableAt_logGammaR hx).hasDerivAt.add (Real.hasDerivAt_log hx.ne')
  have hEq : (fun y : ℝ => logGammaR (y + 1)) =ᶠ[𝓝 x] fun y => logGammaR y + Real.log y := by
    filter_upwards [eventually_gt_nhds hx] using fun y hy => logGammaR_add_one hy
  exact (h1.congr_of_eventuallyEq hEq.symm).unique h2

theorem psiR_one : psiR 1 = -γ := by
  rw [psiR_eq_div one_pos, Real.hasDerivAt_Gamma_one.deriv, Real.Gamma_one, div_one]

theorem psiR_nat_add_one (n : ℕ) : psiR (n + 1) = -γ + (harmonic n : ℝ) := by
  have hpos : (0:ℝ) < n + 1 := by positivity
  rw [psiR_eq_div hpos, Real.deriv_Gamma_nat n, Real.Gamma_nat_eq_factorial]
  field_simp

theorem psiR_monotoneOn : MonotoneOn psiR (Ioi 0) :=
  convexOn_logGammaR.monotoneOn_deriv fun _ hx => differentiableAt_logGammaR hx

theorem psiR_add_nat {x : ℝ} (hx : 0 < x) (n : ℕ) :
    psiR (x + n) = psiR x + ∑ k ∈ Finset.range n, 1 / (x + k) := by
  induction n with
  | zero => simp
  | succ n ih =>
      have hxn : (0:ℝ) < x + n := by positivity
      have : x + (n + 1 : ℕ) = (x + n) + 1 := by push_cast; ring
      rw [this, psiR_add_one hxn, ih, Finset.sum_range_succ]
      ring

/-- For fixed `x > 0` the difference `ψ(x+n) - ψ(1+n)` tends to `0`. -/
theorem tendsto_psiR_shift {x : ℝ} (hx : 0 < x) :
    Tendsto (fun n : ℕ => psiR (x + n) - psiR (1 + n)) atTop (𝓝 0) := by
  set a : ℝ := min x 1 with ha_def
  have ha : 0 < a := lt_min hx one_pos
  have hax : a ≤ x := min_le_left _ _
  have ha1 : a ≤ 1 := min_le_right _ _
  set N : ℕ := ⌈max x 1 - a⌉₊ with hN_def
  have hceil : max x 1 - a ≤ N := Nat.le_ceil _
  have hxN : x ≤ a + N := by
    have h2 : x ≤ max x 1 := le_max_left _ _
    linarith
  have h1N : (1:ℝ) ≤ a + N := by
    have h2 : (1:ℝ) ≤ max x 1 := le_max_right _ _
    linarith
  have key : ∀ n : ℕ, ‖psiR (x + n) - psiR (1 + n)‖ ≤ (N : ℝ) / (a + n) := by
    intro n
    have hn : (0:ℝ) ≤ n := n.cast_nonneg
    have han : (0:ℝ) < a + n := by linarith
    have hlow : ∀ y : ℝ, a + n ≤ y → psiR (a + n) ≤ psiR y := by
      intro y hy
      exact psiR_monotoneOn (by exact han) (by exact (lt_of_lt_of_le han hy)) hy
    have hNn0 : (0:ℝ) ≤ (N:ℝ) := N.cast_nonneg
    have hhigh : ∀ y : ℝ, a + n ≤ y → y ≤ a + n + N → psiR y ≤ psiR (a + n + N) := by
      intro y hy hy'
      refine psiR_monotoneOn (lt_of_lt_of_le han hy) (show (0:ℝ) < a + n + N by linarith) hy'
    have hsum : psiR (a + n + N) = psiR (a + n) + ∑ k ∈ Finset.range N, 1 / (a + n + k) :=
      psiR_add_nat han N
    have hbound : (∑ k ∈ Finset.range N, 1 / (a + n + (k:ℝ))) ≤ (N : ℝ) / (a + n) := by
      have hterm : ∀ k ∈ Finset.range N, 1 / (a + n + (k : ℝ)) ≤ 1 / (a + n) := by
        intro k _
        have : (0:ℝ) ≤ k := k.cast_nonneg
        exact one_div_le_one_div_of_le han (by linarith)
      calc (∑ k ∈ Finset.range N, 1 / (a + n + (k : ℝ)))
          ≤ ∑ _k ∈ Finset.range N, 1 / (a + n) := Finset.sum_le_sum hterm
        _ = (N : ℝ) / (a + n) := by
            rw [Finset.sum_const, Finset.card_range, nsmul_eq_mul, mul_one_div]
    have hNn : (0:ℝ) ≤ (N:ℝ) := N.cast_nonneg
    have hx1 : psiR (a + n) ≤ psiR (x + n) := hlow _ (by linarith)
    have hx2 : psiR (x + n) ≤ psiR (a + n + N) := hhigh _ (by linarith) (by linarith)
    have hy1 : psiR (a + n) ≤ psiR (1 + n) := hlow _ (by linarith)
    have hy2 : psiR (1 + n) ≤ psiR (a + n + N) := hhigh _ (by linarith) (by linarith)
    rw [Real.norm_eq_abs, abs_le]
    constructor <;> linarith [hsum, hbound]
  refine squeeze_zero_norm key ?_
  have htop : Tendsto (fun n : ℕ => a + (n : ℝ)) atTop atTop :=
    tendsto_atTop_add_const_left _ a tendsto_natCast_atTop_atTop
  exact tendsto_const_nhds.div_atTop htop

theorem partialFractionR_eq {x : ℝ} (hx : 0 < x) (n : ℕ) :
    1 / ((n : ℝ) + 1) - 1 / (x + n) = (x - 1) / (((n : ℝ) + 1) * (x + n)) := by
  have hn : (0:ℝ) ≤ n := n.cast_nonneg
  have h1 : ((n : ℝ) + 1) ≠ 0 := by positivity
  have h2 : (x + n) ≠ 0 := by positivity
  field_simp
  ring

theorem summable_partialFractionR {x : ℝ} (hx : 0 < x) :
    Summable (fun n : ℕ => 1 / ((n : ℝ) + 1) - 1 / (x + n)) := by
  have ha : 0 < min x 1 := lt_min hx one_pos
  have hsq : Summable (fun n : ℕ => |x - 1| / (min x 1) * (1 / ((n : ℝ) + 1) ^ 2)) := by
    refine Summable.mul_left _ ?_
    have h := (summable_nat_add_iff (f := fun n : ℕ => 1 / ((n : ℝ)) ^ 2) 1).2
      (Real.summable_one_div_nat_pow.2 one_lt_two)
    refine h.congr fun n => ?_
    push_cast
    ring
  refine Summable.of_norm_bounded hsq fun n => ?_
  have hn : (0:ℝ) ≤ n := n.cast_nonneg
  have hxn : (0:ℝ) < x + n := by linarith
  have h1 : min x 1 ≤ x := min_le_left _ _
  have h2 : min x 1 ≤ 1 := min_le_right _ _
  have hc : min x 1 * ((n : ℝ) + 1) ≤ x + n := by nlinarith
  have hkey : min x 1 * ((n : ℝ) + 1) ^ 2 ≤ ((n : ℝ) + 1) * (x + n) := by
    nlinarith [mul_le_mul_of_nonneg_left hc (show (0:ℝ) ≤ (n : ℝ) + 1 by positivity)]
  have habs : 0 ≤ |x - 1| := abs_nonneg _
  have heq : |x - 1| / min x 1 * (1 / ((n : ℝ) + 1) ^ 2)
      = |x - 1| / (min x 1 * ((n : ℝ) + 1) ^ 2) := by
    field_simp
  rw [partialFractionR_eq hx n, Real.norm_eq_abs, abs_div,
    abs_of_pos (by positivity : (0:ℝ) < ((n : ℝ) + 1) * (x + n)), heq]
  gcongr

/-- **Gauss' partial-fraction expansion of the digamma function, real case.** -/
theorem hasSum_psiR {x : ℝ} (hx : 0 < x) :
    HasSum (fun n : ℕ => 1 / ((n : ℝ) + 1) - 1 / (x + n)) (psiR x + γ) := by
  refine (summable_partialFractionR hx).hasSum_iff_tendsto_nat.2 ?_
  have hpartial : ∀ n : ℕ, (∑ k ∈ Finset.range n, (1 / ((k : ℝ) + 1) - 1 / (x + k)))
      = psiR x + γ - (psiR (x + n) - psiR (1 + n)) := by
    intro n
    have hharm : (∑ k ∈ Finset.range n, 1 / ((k : ℝ) + 1)) = (harmonic n : ℝ) := by
      rw [harmonic]
      push_cast
      simp [one_div]
    have hpsi : psiR (x + n) = psiR x + ∑ k ∈ Finset.range n, 1 / (x + k) := psiR_add_nat hx n
    have hpsin : psiR (1 + n) = -γ + (harmonic n : ℝ) := by
      rw [show (1 : ℝ) + n = (n : ℝ) + 1 by ring]
      exact psiR_nat_add_one n
    rw [Finset.sum_sub_distrib, hharm, hpsi, hpsin]
    ring
  simp only [hpartial]
  have h : Tendsto (fun n : ℕ => psiR x + γ - (psiR (x + n) - psiR (1 + n))) atTop
      (𝓝 (psiR x + γ - 0)) := tendsto_const_nhds.sub (tendsto_psiR_shift hx)
  simpa using h

/-! ## The complex digamma function -/

/-- Transfer of a real derivative to the complex derivative of a complex extension. -/
theorem hasDerivAt_complex_of_real {f : ℂ → ℂ} {g : ℝ → ℝ} {g' s : ℝ}
    (hf : DifferentiableAt ℂ f (s : ℂ)) (hg : HasDerivAt g g' s)
    (hfg : ∀ y : ℝ, f (y : ℂ) = (g y : ℂ)) :
    HasDerivAt f (g' : ℂ) (s : ℂ) := by
  refine hf.hasDerivAt.congr_deriv ?_
  have h1 : deriv (fun y : ℝ => f (y : ℂ)) s = deriv f (s : ℂ) := hf.hasDerivAt.comp_ofReal.deriv
  have h2 : deriv (fun y : ℝ => f (y : ℂ)) s = (g' : ℂ) := by
    rw [funext hfg]
    exact hg.ofReal_comp.deriv
  rw [← h1, h2]

theorem differentiableAt_Gamma_of_re_pos {s : ℂ} (hs : 0 < s.re) :
    DifferentiableAt ℂ Complex.Gamma s := by
  refine Complex.differentiableAt_Gamma _ fun m => ?_
  intro h
  rw [h] at hs
  simp only [Complex.neg_re, Complex.natCast_re] at hs
  have : (0:ℝ) ≤ (m : ℝ) := m.cast_nonneg
  linarith

theorem Gamma_ne_zero_of_re_pos {s : ℂ} (hs : 0 < s.re) : Complex.Gamma s ≠ 0 := by
  refine Complex.Gamma_ne_zero fun m => ?_
  intro h
  rw [h] at hs
  simp only [Complex.neg_re, Complex.natCast_re] at hs
  have : (0:ℝ) ≤ (m : ℝ) := m.cast_nonneg
  linarith

/-- On the positive reals `Complex.digamma` is the real digamma function. -/
theorem digamma_ofReal {x : ℝ} (hx : 0 < x) :
    Complex.digamma (x : ℂ) = (psiR x : ℂ) := by
  have hgr : DifferentiableAt ℝ Real.Gamma x :=
    Real.differentiableAt_Gamma fun m => ne_of_gt (by
      have : (0:ℝ) ≤ (m : ℝ) := m.cast_nonneg
      linarith)
  have hre : 0 < ((x : ℂ)).re := by simpa using hx
  have hderiv : HasDerivAt Complex.Gamma ((deriv Real.Gamma x : ℝ) : ℂ) (x : ℂ) :=
    hasDerivAt_complex_of_real (differentiableAt_Gamma_of_re_pos hre) hgr.hasDerivAt
      Complex.Gamma_ofReal
  rw [Complex.digamma, logDeriv_apply, hderiv.deriv, Complex.Gamma_ofReal, psiR_eq_div hx]
  push_cast
  ring

/-- The sum side of the partial-fraction expansion. -/
def digammaSum (s : ℂ) : ℂ := ∑' n : ℕ, (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + s))

theorem summable_one_div_sq : Summable (fun n : ℕ => 1 / ((n : ℝ) + 1) ^ 2) := by
  have h := (summable_nat_add_iff (f := fun n : ℕ => 1 / ((n : ℝ)) ^ 2) 1).2
    (Real.summable_one_div_nat_pow.2 one_lt_two)
  refine h.congr fun n => ?_
  push_cast
  ring

theorem partialFractionC_eq (s : ℂ) (hs : 0 < s.re) (n : ℕ) :
    1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + s) = (s - 1) / (((n : ℂ) + 1) * ((n : ℂ) + s)) := by
  have hn : ((n : ℂ) + 1) ≠ 0 := by
    intro h
    have : ((n : ℂ) + 1).re = 0 := by rw [h]; simp
    simp only [Complex.add_re, Complex.natCast_re, Complex.one_re] at this
    have : (0:ℝ) ≤ (n : ℝ) := n.cast_nonneg
    linarith
  have hns : ((n : ℂ) + s) ≠ 0 := by
    intro h
    have hz : ((n : ℂ) + s).re = 0 := by rw [h]; simp
    simp only [Complex.add_re, Complex.natCast_re] at hz
    have : (0:ℝ) ≤ (n : ℝ) := n.cast_nonneg
    linarith
  field_simp
  ring

/-- The uniform bound on the terms of the expansion, on a region `Re w ≥ a`, `‖w‖ ≤ R`. -/
theorem norm_partialFractionC_le {w : ℂ} {a R : ℝ} (ha : 0 < a) (haw : a ≤ w.re) (hR : ‖w‖ ≤ R)
    (n : ℕ) :
    ‖1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + w)‖ ≤ (R + 1) / min a 1 * (1 / ((n : ℝ) + 1) ^ 2) := by
  have hn : (0:ℝ) ≤ (n : ℝ) := n.cast_nonneg
  have hwre : 0 < w.re := lt_of_lt_of_le ha haw
  have hmin : 0 < min a 1 := lt_min ha one_pos
  have h1 : min a 1 ≤ a := min_le_left _ _
  have h2 : min a 1 ≤ 1 := min_le_right _ _
  have hlow : min a 1 * ((n : ℝ) + 1) ≤ ‖(n : ℂ) + w‖ := by
    have hre : ((n : ℂ) + w).re = (n : ℝ) + w.re := by simp
    have := Complex.re_le_norm ((n : ℂ) + w)
    nlinarith [this, hre]
  have hnum : ‖w - 1‖ ≤ R + 1 := by
    have := norm_sub_le w 1
    simp only [norm_one] at this
    linarith
  have hR0 : 0 ≤ R := le_trans (norm_nonneg w) hR
  rw [partialFractionC_eq w hwre n, norm_div, norm_mul]
  have hn1 : ‖(n : ℂ) + 1‖ = (n : ℝ) + 1 := by
    rw [show ((n : ℂ) + 1) = (((n : ℝ) + 1 : ℝ) : ℂ) by push_cast; ring, Complex.norm_real,
      Real.norm_eq_abs, abs_of_nonneg (by linarith)]
  rw [hn1]
  have hden : min a 1 * ((n : ℝ) + 1) ^ 2 ≤ ((n : ℝ) + 1) * ‖(n : ℂ) + w‖ := by
    nlinarith [mul_le_mul_of_nonneg_left hlow (show (0:ℝ) ≤ (n : ℝ) + 1 by linarith)]
  have heq : (R + 1) / min a 1 * (1 / ((n : ℝ) + 1) ^ 2)
      = (R + 1) / (min a 1 * ((n : ℝ) + 1) ^ 2) := by field_simp
  rw [heq]
  have hnw : 0 < ‖(n : ℂ) + w‖ := lt_of_lt_of_le (by positivity) hlow
  rw [div_le_div_iff₀ (by positivity) (by positivity)]
  exact mul_le_mul hnum hden (by positivity) (by linarith)

theorem summable_partialFractionC {s : ℂ} (hs : 0 < s.re) :
    Summable (fun n : ℕ => 1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + s)) := by
  refine Summable.of_norm_bounded ((summable_one_div_sq).mul_left ((‖s‖ + 1) / min s.re 1))
    fun n => ?_
  exact norm_partialFractionC_le hs le_rfl le_rfl n

theorem differentiableOn_digammaSum :
    DifferentiableOn ℂ digammaSum {s : ℂ | 0 < s.re} := by
  intro s₀ hs₀
  have h0 : 0 < s₀.re := hs₀
  set r : ℝ := s₀.re / 2 with hr_def
  have hr : 0 < r := by positivity
  set R : ℝ := ‖s₀‖ + r with hR_def
  have hballmem : ∀ w ∈ Metric.ball s₀ r, r ≤ w.re ∧ ‖w‖ ≤ R := by
    intro w hw
    have hw' : ‖w - s₀‖ < r := by simpa [Complex.dist_eq] using hw
    refine ⟨?_, ?_⟩
    · have h1 : |(w - s₀).re| ≤ ‖w - s₀‖ := Complex.abs_re_le_norm _
      have h2 : (w - s₀).re = w.re - s₀.re := by simp
      have h3 := abs_le.1 h1
      rw [h2] at h3
      have h4 := h3.1
      rw [hr_def]
      rw [hr_def] at hw'
      linarith
    · calc ‖w‖ ≤ ‖s₀‖ + ‖w - s₀‖ := by
            have := norm_add_le s₀ (w - s₀)
            simpa using this
        _ ≤ R := by rw [hR_def]; linarith
  have hdiff : DifferentiableOn ℂ digammaSum (Metric.ball s₀ r) := by
    refine Complex.differentiableOn_tsum_of_summable_norm
      (u := fun n : ℕ => (R + 1) / min r 1 * (1 / ((n : ℝ) + 1) ^ 2))
      ((summable_one_div_sq).mul_left _) (fun n => ?_) Metric.isOpen_ball (fun n w hw => ?_)
    · intro w hw
      obtain ⟨hre, _⟩ := hballmem w hw
      have hwre : 0 < w.re := lt_of_lt_of_le hr hre
      have hns : ((n : ℂ) + w) ≠ 0 := by
        intro h
        have hz : ((n : ℂ) + w).re = 0 := by rw [h]; simp
        simp only [Complex.add_re, Complex.natCast_re] at hz
        have : (0:ℝ) ≤ (n : ℝ) := n.cast_nonneg
        linarith
      exact (differentiableAt_const _).differentiableWithinAt.sub
        (((differentiableAt_const _).div (by fun_prop) hns)).differentiableWithinAt
    · obtain ⟨hre, hnorm⟩ := hballmem w hw
      exact norm_partialFractionC_le hr hre hnorm n
  exact (hdiff.differentiableAt (Metric.ball_mem_nhds s₀ hr)).differentiableWithinAt

theorem differentiableOn_digamma :
    DifferentiableOn ℂ Complex.digamma {s : ℂ | 0 < s.re} := by
  have hU : IsOpen {s : ℂ | 0 < s.re} := isOpen_lt continuous_const Complex.continuous_re
  have hΓ : DifferentiableOn ℂ Complex.Gamma {s : ℂ | 0 < s.re} := fun z hz =>
    (differentiableAt_Gamma_of_re_pos hz).differentiableWithinAt
  have hA : AnalyticOnNhd ℂ Complex.Gamma {s : ℂ | 0 < s.re} := hΓ.analyticOnNhd hU
  have h : DifferentiableOn ℂ (fun z => deriv Complex.Gamma z / Complex.Gamma z)
      {s : ℂ | 0 < s.re} :=
    hA.deriv.differentiableOn.div hA.differentiableOn fun z hz => Gamma_ne_zero_of_re_pos hz
  simpa [Complex.digamma, logDeriv_apply] using h

/-- **Gauss' partial-fraction expansion of the digamma function.** -/
theorem hasSum_digamma {s : ℂ} (hs : 0 < s.re) :
    HasSum (fun n : ℕ => 1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + s))
      (Complex.digamma s + (γ : ℂ)) := by
  have key : ∀ z : ℂ, 0 < z.re → digammaSum z = Complex.digamma z + (γ : ℂ) := by
    set U : Set ℂ := {z : ℂ | 0 < z.re} with hU_def
    have hUopen : IsOpen U := isOpen_lt continuous_const Complex.continuous_re
    have hUconv : Convex ℝ U := convex_halfSpace_re_gt 0
    set h : ℂ → ℂ := fun z => digammaSum z - (Complex.digamma z + (γ : ℂ)) with hh_def
    have hdiff : DifferentiableOn ℂ h U :=
      differentiableOn_digammaSum.sub (differentiableOn_digamma.add_const _)
    have hana : AnalyticOnNhd ℂ h U := hdiff.analyticOnNhd hUopen
    have hreal : ∀ x : ℝ, 0 < x → h (x : ℂ) = 0 := by
      intro x hx
      have hsum : HasSum (fun n : ℕ => 1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + (x : ℂ)))
          ((psiR x + γ : ℝ) : ℂ) := by
        have hfun : (fun n : ℕ => 1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + (x : ℂ)))
            = fun n : ℕ => ((1 / ((n : ℝ) + 1) - 1 / (x + n) : ℝ) : ℂ) := by
          funext n
          push_cast
          ring
        rw [hfun]
        exact Complex.hasSum_ofReal.2 (hasSum_psiR hx)
      have h2 : digammaSum (x : ℂ) = ((psiR x + γ : ℝ) : ℂ) := hsum.tsum_eq
      rw [hh_def]
      simp only
      rw [h2, digamma_ofReal hx]
      push_cast
      ring
    have hfreq : ∃ᶠ z in 𝓝[≠] (1 : ℂ), h z = 0 := by
      have hmap : Tendsto (fun x : ℝ => (x : ℂ)) (𝓝[≠] (1:ℝ)) (𝓝[≠] (1:ℂ)) := by
        refine tendsto_nhdsWithin_of_tendsto_nhds_of_eventually_within _
          ((Complex.continuous_ofReal.tendsto 1).mono_left nhdsWithin_le_nhds) ?_
        filter_upwards [self_mem_nhdsWithin] with x hx
        simp only [Set.mem_compl_iff, Set.mem_singleton_iff]
        intro hc
        exact hx (by exact_mod_cast hc)
      have hev : ∀ᶠ x : ℝ in 𝓝[≠] (1:ℝ), h (x : ℂ) = 0 := by
        filter_upwards [nhdsWithin_le_nhds (eventually_gt_nhds (by norm_num : (0:ℝ) < 1))]
          with x hx using hreal x hx
      exact hmap.frequently hev.frequently
    have hzero : Set.EqOn h 0 U :=
      hana.eqOn_zero_of_preconnected_of_frequently_eq_zero hUconv.isPreconnected
        (by simp [hU_def]) hfreq
    intro z hz
    have := hzero (show z ∈ U from hz)
    simpa [hh_def, sub_eq_zero] using this
  have hsum := (summable_partialFractionC hs).hasSum
  rw [← key s hs]
  exact hsum

/-! ## The value at `1/4` -/

theorem logDeriv_Gamma_add_const {c x : ℂ} (h : 0 < (x + c).re) :
    logDeriv (fun z => Complex.Gamma (z + c)) x = Complex.digamma (x + c) := by
  have hd : DifferentiableAt ℂ Complex.Gamma (x + c) := differentiableAt_Gamma_of_re_pos h
  have hg : DifferentiableAt ℂ (fun z : ℂ => z + c) x := by fun_prop
  have hcomp := logDeriv_comp (f := Complex.Gamma) (g := fun z : ℂ => z + c) hd hg
  rw [Complex.digamma_def]
  simpa [Function.comp_def] using hcomp

theorem logDeriv_Gamma_two_mul {x : ℂ} (h : 0 < (2 * x).re) :
    logDeriv (fun z => Complex.Gamma (2 * z)) x = 2 * Complex.digamma (2 * x) := by
  have hd : DifferentiableAt ℂ Complex.Gamma (2 * x) := differentiableAt_Gamma_of_re_pos h
  have hg : DifferentiableAt ℂ (fun z : ℂ => 2 * z) x := by fun_prop
  have hcomp := logDeriv_comp (f := Complex.Gamma) (g := fun z : ℂ => 2 * z) hd hg
  have hderiv : deriv (fun z : ℂ => 2 * z) x = 2 := by
    simpa using ((hasDerivAt_id x).const_mul (2 : ℂ)).deriv
  rw [Complex.digamma_def]
  simp only [Function.comp_def] at hcomp
  rw [hcomp, hderiv, mul_comm]

theorem logDeriv_Gamma_one_sub {x : ℂ} (h : 0 < (1 - x).re) :
    logDeriv (fun z => Complex.Gamma (1 - z)) x = -Complex.digamma (1 - x) := by
  have hd : DifferentiableAt ℂ Complex.Gamma (1 - x) := differentiableAt_Gamma_of_re_pos h
  have hg : DifferentiableAt ℂ (fun z : ℂ => 1 - z) x := by fun_prop
  have hcomp := logDeriv_comp (f := Complex.Gamma) (g := fun z : ℂ => 1 - z) hd hg
  have hderiv : deriv (fun z : ℂ => 1 - z) x = -1 := by
    simpa using ((hasDerivAt_id x).const_sub (1 : ℂ)).deriv
  rw [Complex.digamma_def]
  simp only [Function.comp_def] at hcomp
  rw [hcomp, hderiv]
  ring

theorem logDeriv_two_cpow (x : ℂ) :
    logDeriv (fun z : ℂ => (2 : ℂ) ^ (1 - 2 * z)) x = -2 * Complex.log 2 := by
  have hinner : HasDerivAt (fun z : ℂ => 1 - 2 * z) (-2) x := by
    simpa using ((hasDerivAt_id x).const_mul (2 : ℂ)).const_sub 1
  have h := hinner.const_cpow (c := (2 : ℂ)) (Or.inl two_ne_zero)
  have hne : (2 : ℂ) ^ (1 - 2 * x) ≠ 0 :=
    Complex.cpow_ne_zero_iff.2 (Or.inl two_ne_zero)
  rw [logDeriv_apply, h.deriv]
  field_simp

/-- The logarithmic derivative of the duplication formula: `ψ(s) + ψ(s+1/2) = 2ψ(2s) - 2 log 2`. -/
theorem digamma_add_digamma_add_half {s : ℂ} (hs : 0 < s.re) :
    Complex.digamma s + Complex.digamma (s + 1 / 2)
      = 2 * Complex.digamma (2 * s) - 2 * Complex.log 2 := by
  have hhalf : 0 < (s + 1 / 2).re := by
    have : (s + 1 / 2 : ℂ).re = s.re + 1 / 2 := by simp
    rw [this]; linarith
  have h2s : 0 < (2 * s).re := by
    have : (2 * s : ℂ).re = 2 * s.re := by simp
    rw [this]; linarith
  have hsqrt : ((√π : ℝ) : ℂ) ≠ 0 := by
    simp only [ne_eq, Complex.ofReal_eq_zero]
    positivity
  have hdG : DifferentiableAt ℂ Complex.Gamma s := differentiableAt_Gamma_of_re_pos hs
  have hdGh : DifferentiableAt ℂ (fun z : ℂ => Complex.Gamma (z + 1 / 2)) s :=
    (differentiableAt_Gamma_of_re_pos hhalf).comp s (by fun_prop)
  have hdG2 : DifferentiableAt ℂ (fun z : ℂ => Complex.Gamma (2 * z)) s :=
    (differentiableAt_Gamma_of_re_pos h2s).comp s (by fun_prop)
  have hdc : DifferentiableAt ℂ (fun z : ℂ => (2 : ℂ) ^ (1 - 2 * z)) s := by
    have hinner : HasDerivAt (fun z : ℂ => 1 - 2 * z) (-2) s := by
      simpa using ((hasDerivAt_id s).const_mul (2 : ℂ)).const_sub 1
    exact (hinner.const_cpow (c := (2 : ℂ)) (Or.inl two_ne_zero)).differentiableAt
  have hcne : (2 : ℂ) ^ (1 - 2 * s) ≠ 0 := Complex.cpow_ne_zero_iff.2 (by norm_num)
  have hL : logDeriv (fun z => Complex.Gamma z * Complex.Gamma (z + 1 / 2)) s
      = Complex.digamma s + Complex.digamma (s + 1 / 2) := by
    rw [logDeriv_mul (f := Complex.Gamma) (g := fun z : ℂ => Complex.Gamma (z + 1 / 2)) s
        (Gamma_ne_zero_of_re_pos hs) (Gamma_ne_zero_of_re_pos hhalf) hdG hdGh,
      logDeriv_Gamma_add_const hhalf, Complex.digamma_def]
  have hR : logDeriv (fun z => Complex.Gamma (2 * z) * (2 : ℂ) ^ (1 - 2 * z) * ((√π : ℝ) : ℂ)) s
      = 2 * Complex.digamma (2 * s) - 2 * Complex.log 2 := by
    rw [logDeriv_mul_const s _ hsqrt,
      logDeriv_mul (f := fun z : ℂ => Complex.Gamma (2 * z))
        (g := fun z : ℂ => (2 : ℂ) ^ (1 - 2 * z)) s (Gamma_ne_zero_of_re_pos h2s) hcne hdG2 hdc,
      logDeriv_Gamma_two_mul h2s, logDeriv_two_cpow]
    ring
  have hfun : (fun z => Complex.Gamma z * Complex.Gamma (z + 1 / 2))
      = fun z => Complex.Gamma (2 * z) * (2 : ℂ) ^ (1 - 2 * z) * ((√π : ℝ) : ℂ) :=
    funext Complex.Gamma_mul_Gamma_add_half
  rw [← hL, hfun, hR]

/-- The logarithmic derivative of the reflection formula:
`ψ(s) - ψ(1-s) = -π cos(πs)/sin(πs)`. -/
theorem digamma_sub_digamma_one_sub {s : ℂ} (hs : 0 < s.re) (hs1 : 0 < (1 - s).re)
    (hsin : Complex.sin ((π : ℂ) * s) ≠ 0) :
    Complex.digamma s - Complex.digamma (1 - s)
      = -((π : ℂ) * Complex.cos ((π : ℂ) * s) / Complex.sin ((π : ℂ) * s)) := by
  have hpi : ((π : ℝ) : ℂ) ≠ 0 := by
    simp only [ne_eq, Complex.ofReal_eq_zero]
    exact Real.pi_ne_zero
  have hdG : DifferentiableAt ℂ Complex.Gamma s := differentiableAt_Gamma_of_re_pos hs
  have hdG1 : DifferentiableAt ℂ (fun z : ℂ => Complex.Gamma (1 - z)) s :=
    (differentiableAt_Gamma_of_re_pos hs1).comp s (by fun_prop)
  have hsinderiv : HasDerivAt (fun z : ℂ => Complex.sin ((π : ℂ) * z))
      (Complex.cos ((π : ℂ) * s) * (π : ℂ)) s := by
    have h := (Complex.hasDerivAt_sin ((π : ℂ) * s)).comp s
      ((hasDerivAt_id s).const_mul ((π : ℂ)))
    simpa [Function.comp_def] using h
  have hL : logDeriv (fun z => Complex.Gamma z * Complex.Gamma (1 - z)) s
      = Complex.digamma s - Complex.digamma (1 - s) := by
    rw [logDeriv_mul (f := Complex.Gamma) (g := fun z : ℂ => Complex.Gamma (1 - z)) s
        (Gamma_ne_zero_of_re_pos hs) (Gamma_ne_zero_of_re_pos hs1) hdG hdG1,
      logDeriv_Gamma_one_sub hs1, Complex.digamma_def]
    ring
  have hR : logDeriv (fun z => ((π : ℝ) : ℂ) / Complex.sin ((π : ℂ) * z)) s
      = -((π : ℂ) * Complex.cos ((π : ℂ) * s) / Complex.sin ((π : ℂ) * s)) := by
    rw [logDeriv_div (f := fun _ : ℂ => ((π : ℝ) : ℂ))
        (g := fun z : ℂ => Complex.sin ((π : ℂ) * z)) s hpi hsin (by fun_prop)
        hsinderiv.differentiableAt,
      logDeriv_apply, logDeriv_apply, hsinderiv.deriv]
    simp only [deriv_const]
    field_simp
    ring
  have hfun : (fun z => Complex.Gamma z * Complex.Gamma (1 - z))
      = fun z => ((π : ℝ) : ℂ) / Complex.sin ((π : ℂ) * z) :=
    funext Complex.Gamma_mul_Gamma_one_sub
  rw [← hL, hfun, hR]

/-- **Gauss' digamma theorem at `1/4`**: `ψ(1/4) = -γ - 3 log 2 - π/2`. -/
theorem digamma_quarter :
    Complex.digamma (1 / 4 : ℂ) = -(γ : ℂ) - 3 * Complex.log 2 - (π : ℂ) / 2 := by
  have hq : (0:ℝ) < ((1 / 4 : ℂ)).re := by norm_num
  have hdup := digamma_add_digamma_add_half hq
  have hone : (1 : ℂ) / 4 + 1 / 2 = 3 / 4 := by ring
  have htwo : (2 : ℂ) * (1 / 4) = 1 / 2 := by ring
  rw [hone, htwo] at hdup
  have h1s : (1 : ℂ) - 1 / 4 = 3 / 4 := by ring
  have hsin : Complex.sin ((π : ℂ) * (1 / 4)) ≠ 0 := by
    have : ((π : ℂ) * (1 / 4)) = (((π / 4 : ℝ)) : ℂ) := by push_cast; ring
    rw [this, ← Complex.ofReal_sin]
    simp only [ne_eq, Complex.ofReal_eq_zero]
    have : Real.sin (π / 4) = √2 / 2 := Real.sin_pi_div_four
    rw [this]
    positivity
  have hrefl := digamma_sub_digamma_one_sub hq (by rw [h1s]; norm_num) hsin
  rw [h1s] at hrefl
  have hcos : (π : ℂ) * Complex.cos ((π : ℂ) * (1 / 4)) / Complex.sin ((π : ℂ) * (1 / 4))
      = (π : ℂ) := by
    have hc : ((π : ℂ) * (1 / 4)) = (((π / 4 : ℝ)) : ℂ) := by push_cast; ring
    rw [hc, ← Complex.ofReal_sin, ← Complex.ofReal_cos, Real.sin_pi_div_four,
      Real.cos_pi_div_four]
    have h2 : ((√2 / 2 : ℝ) : ℂ) ≠ 0 := by
      simp only [ne_eq, Complex.ofReal_eq_zero]
      positivity
    field_simp
  rw [hcos] at hrefl
  have hhalf : Complex.digamma (1 / 2 : ℂ) = -2 * Complex.log 2 - (γ : ℂ) :=
    Complex.digamma_one_half
  rw [hhalf] at hdup
  have := hdup
  linear_combination (hdup + hrefl) / 2

end ConnesConsani.WeilPositivity
