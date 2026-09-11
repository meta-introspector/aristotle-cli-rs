/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Analysis of the Fourier-side function `f(t) = 2θ'(t) + δ̂(t)` of Corollary 2.3 (ii) of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771,

on the *compact* interval that is left open by `RequestProject/ThetaGrowth.lean`.
-/
import RequestProject.Imported.OutputFinal2.FourierSide

noncomputable section

open MeasureTheory Set Real Filter Topology

namespace ConnesConsani.WeilPositivity

local notation "γ" => Real.eulerMascheroniConstant

/-! ## The exact series for `2θ'(t) - 2θ'(0)`

Gauss' partial fraction expansion `hasSum_digamma` gives, on the vertical line
`s = 1/4 + i t/2`,

  `2θ'(t) - 2θ'(0) = Re ψ(1/4 + it/2) - Re ψ(1/4) = ∑_{n ≥ 0} (t²/4) / (aₙ (aₙ² + t²/4))`,
  `aₙ = n + 1/4`,

a series of nonnegative terms, each increasing in `|t|`.  In particular `2θ'` is even,
increasing on `[0,∞)`, and `2θ'(t) ≥ 2θ'(0)` for every `t`. -/

/-- The `n`-th pole abscissa `aₙ = n + 1/4` of the digamma function on the line `Re s = 1/4`. -/
def poleAbscissa (n : ℕ) : ℝ := n + 1 / 4

theorem poleAbscissa_pos (n : ℕ) : 0 < poleAbscissa n := by
  have : (0:ℝ) ≤ n := Nat.cast_nonneg n
  simp only [poleAbscissa]; linarith

/-- The `n`-th term of the series for `2θ'(t) - 2θ'(0)`. -/
def thetaSeriesTerm (t : ℝ) (n : ℕ) : ℝ :=
  (t ^ 2 / 4) / (poleAbscissa n * (poleAbscissa n ^ 2 + t ^ 2 / 4))

theorem thetaSeriesTerm_nonneg (t : ℝ) (n : ℕ) : 0 ≤ thetaSeriesTerm t n := by
  have h := poleAbscissa_pos n
  unfold thetaSeriesTerm
  positivity

/-- Each term of the series is monotone in `t²`, hence in `|t|`. -/
theorem thetaSeriesTerm_mono {s t : ℝ} (hs : 0 ≤ s) (hst : s ≤ t) (n : ℕ) :
    thetaSeriesTerm s n ≤ thetaSeriesTerm t n := by
  have ha := poleAbscissa_pos n
  have hs2 : s ^ 2 ≤ t ^ 2 := by nlinarith
  unfold thetaSeriesTerm
  rw [div_le_div_iff₀ (by positivity) (by positivity)]
  nlinarith [mul_nonneg (mul_nonneg ha.le (pow_nonneg ha.le 2)) (sub_nonneg.2 hs2)]

/-- The real part of `1/(n + 1/4 + i t/2)`. -/
theorem re_inv_line (t : ℝ) (n : ℕ) :
    (1 / ((n : ℂ) + (1 / 4 + Complex.I * (t : ℂ) / 2))).re
      = poleAbscissa n / (poleAbscissa n ^ 2 + t ^ 2 / 4) := by
  have hz : ((n : ℂ) + (1 / 4 + Complex.I * (t : ℂ) / 2))
      = Complex.mk (poleAbscissa n) (t / 2) := by
      apply Complex.ext <;> simp [poleAbscissa, Complex.add_re, Complex.add_im]
  rw [hz, one_div, Complex.inv_re, Complex.normSq_mk]
  congr 1
  ring

/-- **The series for `2θ'(t) - 2θ'(0)`.** -/
theorem hasSum_thetaDeriv_sub (t : ℝ) :
    HasSum (thetaSeriesTerm t) (2 * thetaDeriv t - 2 * thetaDeriv 0) := by
  have hre : ∀ s : ℂ, 0 < s.re →
      HasSum (fun n : ℕ => (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + s)).re)
        ((Complex.digamma s).re + γ) := by
    intro s hs
    have h := (hasSum_digamma hs).mapL Complex.reCLM
    simpa using h
  have h1 : (0:ℝ) < ((1 / 4 + Complex.I * (t : ℂ) / 2) : ℂ).re := by simp
  have h0 : (0:ℝ) < ((1 / 4 : ℂ)).re := by norm_num
  have H1 := hre _ h1
  have H0 := hre _ h0
  have hsub := H1.sub H0
  have hfun : (fun n : ℕ => (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + (1 / 4 + Complex.I * (t:ℂ) / 2))).re
      - (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + (1 / 4 : ℂ))).re) = thetaSeriesTerm t := by
    funext n
    have ha := poleAbscissa_pos n
    have hA := re_inv_line t n
    have hB := re_inv_line 0 n
    simp only [Complex.ofReal_zero, mul_zero, zero_div, add_zero] at hB
    simp only [Complex.sub_re] at *
    rw [hA, hB]
    have : poleAbscissa n / (poleAbscissa n ^ 2 + 0 ^ 2 / 4) = 1 / poleAbscissa n := by
      rw [show poleAbscissa n ^ 2 + 0 ^ 2 / 4 = poleAbscissa n ^ 2 by ring]
      field_simp
    rw [this, thetaSeriesTerm]
    field_simp
    ring
  rw [hfun] at hsub
  have hval : (Complex.digamma (1 / 4 + Complex.I * (t : ℂ) / 2)).re + γ
      - ((Complex.digamma (1 / 4 : ℂ)).re + γ) = 2 * thetaDeriv t - 2 * thetaDeriv 0 := by
    rw [thetaDeriv, thetaDeriv]
    simp only [Complex.ofReal_zero, mul_zero, zero_div, add_zero]
    ring
  rwa [hval] at hsub

/-- **`2θ'(t) ≥ 2θ'(0)` for every `t`**: the Riemann–Siegel angular function has its minimal
derivative at the origin. -/
theorem thetaDeriv_zero_le (t : ℝ) : thetaDeriv 0 ≤ thetaDeriv t := by
  have h := (hasSum_thetaDeriv_sub t).nonneg (thetaSeriesTerm_nonneg t)
  linarith

/-- **`2θ'` is increasing on `[0,∞)`.** -/
theorem thetaDeriv_monotoneOn : MonotoneOn thetaDeriv (Ici 0) := by
  intro s hs t ht hst
  have hs0 : (0:ℝ) ≤ s := hs
  have H1 := hasSum_thetaDeriv_sub s
  have H2 := hasSum_thetaDeriv_sub t
  have hle : 2 * thetaDeriv s - 2 * thetaDeriv 0 ≤ 2 * thetaDeriv t - 2 * thetaDeriv 0 :=
    H1.tsum_eq ▸ H2.tsum_eq ▸
      H1.summable.tsum_le_tsum (fun n => thetaSeriesTerm_mono hs0 hst n) H2.summable
  linarith

/-! ## The spread of `δ̂` and the exact decomposition of the Fourier side

Writing `Θ(t) = 2θ'(t) - 2θ'(0)` (the nonnegative series above) and
`Δ(t) = δ̂(0) - δ̂(t) = ∫ δ(e^u)(1 - cos(tu)) du ≥ 0`, one has the exact decomposition

  `f(t) = f(0) + Θ(t) - Δ(t)`,   `f = 2θ' + δ̂`.

Both `Θ` and `Δ` are nonnegative and grow like `log|t|`; the content of Corollary 2.3 (ii)
is that their difference never exceeds `f(0)`.  Numerically `f(0) ≈ 0.049` and `f` is
increasing, i.e. `Δ ≤ Θ`, but neither is proved here. -/

/-- `Δ(t) = ∫ δ(e^u)(1 - cos(tu)) du`, the *spread* of the trace remainder at frequency
`t`. -/
def deltaSpread (t : ℝ) : ℝ := ∫ u : ℝ, delta (Rplus.expHomeo u) * (1 - Real.cos (t * u))

/-- `Δ(t) = δ̂(0) - δ̂(t)`. -/
theorem deltaSpread_eq (t : ℝ) : deltaSpread t = deltaFourier 0 - deltaFourier t := by
  have hcos : Integrable (fun u : ℝ => delta (Rplus.expHomeo u) * Real.cos (t * u)) volume :=
    integrable_delta_log_mul (by fun_prop) fun u => Real.abs_cos_le_one _
  have h0 : deltaFourier 0 = ∫ u : ℝ, delta (Rplus.expHomeo u) := by simp [deltaFourier]
  have hsplit : ∀ u : ℝ, delta (Rplus.expHomeo u) * (1 - Real.cos (t * u))
      = delta (Rplus.expHomeo u) - delta (Rplus.expHomeo u) * Real.cos (t * u) := by
    intro u; ring
  rw [deltaSpread, integral_congr_ae (Filter.Eventually.of_forall hsplit),
    integral_sub integrable_delta_log hcos, h0, deltaFourier]

/-- `Δ(t) ≥ 0`, `δ` being positive. -/
theorem deltaSpread_nonneg (t : ℝ) : 0 ≤ deltaSpread t := by
  refine integral_nonneg fun u => ?_
  show (0:ℝ) ≤ delta (Rplus.expHomeo u) * (1 - Real.cos (t * u))
  have h1 : Real.cos (t * u) ≤ 1 := Real.cos_le_one _
  have h2 := (delta_pos (Rplus.expHomeo u)).le
  nlinarith

/-- **The exact decomposition `f(t) = f(0) + Θ(t) - Δ(t)`.** -/
theorem fourierSide_eq_add_sub (t : ℝ) :
    fourierSide t = fourierSide 0 + (2 * thetaDeriv t - 2 * thetaDeriv 0) - deltaSpread t := by
  rw [deltaSpread_eq, fourierSide, fourierSide]
  ring

/-- **The Fourier-side inequality is exactly the comparison `Δ(t) ≤ Θ(t) + f(0)`.** -/
theorem fourierSide_nonneg_iff (t : ℝ) :
    0 ≤ fourierSide t ↔ deltaSpread t ≤ (2 * thetaDeriv t - 2 * thetaDeriv 0) + fourierSide 0 := by
  rw [fourierSide_eq_add_sub, sub_nonneg]
  constructor <;> intro h <;> linarith

/-- Since `Θ ≥ 0`, the inequality at `t` follows from `Δ(t) ≤ f(0)`. -/
theorem fourierSide_nonneg_of_deltaSpread_le {t : ℝ} (h : deltaSpread t ≤ fourierSide 0) :
    0 ≤ fourierSide t := by
  have hΘ : 0 ≤ 2 * thetaDeriv t - 2 * thetaDeriv 0 := by
    have := thetaDeriv_zero_le t; linarith
  rw [fourierSide_nonneg_iff]
  linarith

/-- The crude consequence of the monotonicity of `2θ'`: `f(t) ≥ 2θ'(0) + δ̂(t)`. -/
theorem fourierSide_ge_thetaDeriv_zero_add (t : ℝ) :
    2 * thetaDeriv 0 + deltaFourier t ≤ fourierSide t := by
  have := thetaDeriv_zero_le t
  rw [fourierSide]
  linarith

end ConnesConsani.WeilPositivity
