/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The status of the Fourier-side inequality

  `f(t) = 2θ'(t) + δ̂(t) ≥ 0`

of Corollary 2.3 (ii) of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771,

on the compact interval `|t| ≤ 60` left open by `RequestProject/ThetaGrowth.lean`.

# What is proved here

The value of `f` at the origin is, by Gauss' value of `ψ(1/4)`
(`fourierSide_zero_eq` in `RequestProject/ArchimedeanExplicit.lean`),

  `f(0) = δ̂(0) - (log π + γ + 3 log 2 + π/2)`.

This file bounds the second term by an explicit rational number,

  `log π + γ + 3 log 2 + π/2 < 5.3765`   (`fourierSide_threshold_lt`),

so that the inequality at the origin is reduced to the single explicit numerical statement

  `δ̂(0) ≥ 5.3765`   (`fourierSide_zero_nonneg_of_deltaFourier_zero_ge`),

about the one convergent integral `δ̂(0) = ∫_ℝ δ(e^u) du`.  That statement is **proved** in
`RequestProject/DeltaFourierZero.lean` (`deltaFourier_zero_ge`), so the Fourier-side
inequality at the origin holds unconditionally (`fourierSide_zero_nonneg`).

# The obstruction on `0.18 < |t| < 60`

A neighbourhood of the origin has since been settled: `RequestProject/NearOrigin.lean`
proves the inequality for `|t| ≤ 0.18` (`fourierSide_nonneg_of_abs_le`), by the
quantitative spread comparison `Δ(t) ≤ Θ(t) + t²/5` together with the certified margin
`f(0) ≥ 0.0072`.  The interval it covers is proportional to the square root of that
margin, so it stops well short of `60`.

The inequality on the remaining interval `0.18 < |t| < 60` is **open in this project**.  What the analysis of
`RequestProject/FourierSideAnalysis.lean` and the numerical exploration recorded below
show is that neither of the two elementary routes can succeed with the tools available.

*The margin is extremely small.*  Numerically (mpmath; **not** verified in Lean)

  `δ̂(0) = 5.4212541…`,  `log π + γ + 3 log 2 + π/2 = 5.3721834…`,  `f(0) = 0.0490707…`,

and `f` is increasing on `[0,60]` with

  `f(1) = 0.05010`, `f(2) = 0.05337`, `f(3) = 0.05938`, `f(5) = 0.08474`,
  `f(10) = 0.3576`, `f(20) = 1.1605`, `f(60) = 2.2551`.

So on the whole of `[0,6]` the quantity to be shown nonnegative is smaller than `0.11`,
while the two terms `2θ'` and `δ̂` are of size `5`; the inequality is a cancellation to
within one part in a hundred.

*Route 1 (monotonicity) is not accessible.*  By `fourierSide_eq_add_sub`,

  `f(t) = f(0) + Θ(t) - Δ(t)`,  `Θ(t) = 2θ'(t) - 2θ'(0)`,  `Δ(t) = δ̂(0) - δ̂(t)`,

both `Θ` and `Δ` being nonnegative and increasing to `+∞` like `log|t|`.  Monotonicity of
`f` is `Θ' ≥ Δ'`.  Expanding both at the origin, `Θ(t) = (t²/2) c_Θ + O(t⁴)` and
`Δ(t) = (t²/2) c_Δ + O(t⁴)` with

  `c_Θ = ∑_n 2/(n+1/4)³ ≈ 32.32`,  `c_Δ = ∫ δ(e^u) u² du ≈ 32.32`,

and `c_Θ - c_Δ ≈ 0.0021`: the two second moments agree to four digits.  Any bound that
treats `Θ` and `Δ` separately loses a factor of ten thousand, so monotonicity cannot be
obtained from sign-blind estimates on the two summands.  The same phenomenon is visible in
the difference kernel `k(v) = 2 e^{3v/2}/(e^{2v}-1) - 2 δ(e^v)`, for which
`f(t) - f(0) = ∫_0^∞ k(v)(1 - cos tv) dv`: the negative part of `k` has `L¹`-mass `≈ 0.111`,
i.e. more than twice the whole budget `f(0) ≈ 0.049`, so `k ≥ 0` is false and the crude
bound `1 - cos ≤ 2` fails.

*Route 2 (interval arithmetic) is not accessible either.*  `|Δ'| ≤ ∫ δ(e^u)|u| du ≈ 18`, so
a grid argument on `[0,6]` with the available margin `0.049` needs mesh `≈ 0.0027`, i.e.
about two thousand grid points, at each of which `δ̂(t)` must be certified to absolute
accuracy `0.02` — an oscillatory integral whose integrand `δ(e^u) cos(tu)` involves
`Si(2π(e^u ± 1))` and oscillates with frequency `2π e^u`.

Even the *single* point `t = 0` is hard — it is the content of
`RequestProject/DeltaFourierZero.lean`, where the following scheme is carried out in a
different (and cheaper) set of coordinates.  Writing `δ̂(0)` in the variable `x = 2π(e^u ∓ 1)`
turns it into the two absolutely convergent, mildly oscillating integrals

  `δ̂(0) = (2/π) ∫_0^∞ (Si x/x) (1 + x/2π)^{-1/2} dx + (2/π) ∫_{4π}^∞ (Si x/x) (x/2π - 1)^{-1/2} dx`

(numerically `3.8516 + 1.5697`).  Replacing `Si x` by `π/2` for `x ≥ X₀` with the error
bound `|Si x - π/2| ≤ 1/x + 1/x²` — which **is** proved, in
`RequestProject/SiAsymptotic.lean` (`abs_Si_sub_pi_div_two_le`), together with the
Dirichlet integral `Si x → π/2` that it rests on — and keeping the exact integrand below
`X₀` gives a rigorous lower bound for `δ̂(0)`; the value of that bound is `5.3706` for
`X₀ = 4π`, `5.3943` for `X₀ = 6π` and `5.4039` for `X₀ = 8π`.  So the scheme does clear
the threshold `5.3765`, but only from `X₀ = 6π` on, and it then requires a rigorous
quadrature of `∫_0^{6π} (Si x/x)(1 + x/2π)^{-1/2} dx` to absolute accuracy `0.02`.  That
quadrature was the obstruction to this particular scheme: the integrand is smooth but not
monotone, its Lipschitz constant forces a mesh of about `10^{-2}` (some two thousand
certified evaluations of `Si`), and integrating a truncated Taylor series of `Si` term by
term runs into endpoints that are multiples of `π`.  (The three numbers above are numerical
explorations, not Lean-verified computations.)  The scheme that succeeded instead keeps the
multiplicative variable `r = e^u`, uses the *half-period* cancellation of the oscillating
part of `Si` on `[R,∞)` in place of a size bound, and only needs a certified quadrature on
the short interval `[1, 49/25]`, where a degree-14 Taylor minorant of `Si x / x` and four
tangent-line minorants of `1/√r` suffice.

*What does work.*  The route that removes the numerics altogether is the exact
representation of `RequestProject/TailEnergy.lean`,

  `f(t) = (2/π) ∫_{2π}^∞ |∫_a^∞ y^{-1/2+it} cos y dy|² da/a`,

whose right-hand side is manifestly nonnegative and which gives the inequality for *all*
`t`.  It is the archimedean explicit formula, and is not proved in this project either;
but it contains no inequality, only an identity.
-/
import RequestProject.Imported.OutputFinal2.ArchimedeanExplicit
import RequestProject.Imported.OutputFinal2.FourierSideAnalysis
import RequestProject.Imported.OutputFinal2.SiAsymptotic
import Mathlib.Analysis.Real.Pi.Bounds
import Mathlib.NumberTheory.Harmonic.EulerMascheroni

noncomputable section

open MeasureTheory Set Real Filter Topology

namespace ConnesConsani.WeilPositivity

local notation "γ" => Real.eulerMascheroniConstant

/-! ## An explicit rational bound for the threshold at the origin -/

/-- `γ < 0.5812`, from the classical bound `γ < H_n - log n` at `n = 128`.  (Mathlib's
`Real.eulerMascheroniConstant_lt_two_thirds` is too weak here: the whole margin of the
inequality at the origin is `0.049`, while `2/3 - γ ≈ 0.089`.) -/
theorem eulerMascheroniConstant_lt_d4 : γ < 0.5812 := by
  refine (Real.eulerMascheroniConstant_lt_eulerMascheroniSeq' 128).trans_le ?_
  rw [Real.eulerMascheroniSeq', if_neg (by norm_num)]
  have h2 : (0.6931471803 : ℝ) < Real.log 2 := Real.log_two_gt_d9
  have hl : Real.log ((128 : ℕ) : ℝ) = 7 * Real.log 2 := by
    rw [show ((128 : ℕ) : ℝ) = 2 ^ (7 : ℕ) by norm_num, Real.log_pow]
    norm_num
  rw [hl]
  have hH : (harmonic 128 : ℝ) < 5.43315 := by norm_num [harmonic]
  linarith

/-- `log π < 1.145`, from `π < 3.14159266 < exp 1.145` (the exponential being bounded below
by a partial sum of its series). -/
theorem log_pi_lt : Real.log π < 1.145 := by
  have hpi : π < 3.14159266 := by linarith [Real.pi_lt_d20]
  have hexp : (3.14159266 : ℝ) < Real.exp 1.145 := by
    have h := Real.sum_le_exp_of_nonneg (x := (1.145 : ℝ)) (by norm_num) 9
    refine lt_of_lt_of_le ?_ h
    norm_num [Finset.sum_range_succ, Nat.factorial]
  calc Real.log π < Real.log (Real.exp 1.145) := Real.log_lt_log Real.pi_pos (hpi.trans hexp)
    _ = 1.145 := Real.log_exp _

/-- **The threshold of the Fourier-side inequality at the origin is smaller than
`5.3765`.**  By `fourierSide_zero_eq` the inequality `f(0) ≥ 0` says exactly
`δ̂(0) ≥ log π + γ + 3 log 2 + π/2`; the true value of the right-hand side is
`5.3721834…`. -/
theorem fourierSide_threshold_lt :
    Real.log π + γ + 3 * Real.log 2 + π / 2 < 5.3765 := by
  have h2 : Real.log 2 < 0.6931471808 := Real.log_two_lt_d9
  have hpi : π < 3.14159266 := by linarith [Real.pi_lt_d20]
  linarith [eulerMascheroniConstant_lt_d4, log_pi_lt]

/-- **The Fourier-side inequality at the origin is the single numerical statement
`δ̂(0) ≥ 5.3765`.**  Numerically `δ̂(0) = 5.4212541…`, so the required margin is `0.045`,
i.e. eight parts in a thousand; the bound is not proved in this project. -/
theorem fourierSide_zero_nonneg_of_deltaFourier_zero_ge
    (h : (5.3765 : ℝ) ≤ deltaFourier 0) : 0 ≤ fourierSide 0 := by
  rw [fourierSide_zero_eq, sub_nonneg]
  exact le_trans fourierSide_threshold_lt.le h

/-- The same reduction, in the equivalent form used in `RequestProject/FourierSide.lean`. -/
theorem deltaFourier_zero_ge_threshold_of_ge
    (h : (5.3765 : ℝ) ≤ deltaFourier 0) :
    Real.log π - (Complex.digamma (1 / 4 : ℂ)).re ≤ deltaFourier 0 := by
  rw [fourierSide_threshold_eq]
  exact le_trans fourierSide_threshold_lt.le h

/-! ## The reduction of the whole compact interval

Combining the reduction at the origin with the exact decomposition
`f(t) = f(0) + Θ(t) - Δ(t)` of `RequestProject/FourierSideAnalysis.lean`, the inequality on
the whole real line follows from the two statements

* `δ̂(0) ≥ 5.3765` (the numerical statement at the origin), and
* `Δ(t) ≤ Θ(t)` for every `t` (the "spread comparison": the spread of `δ̂` never exceeds
  the increment of `2θ'`), which is exactly the statement that `f` is minimal at the
  origin.

Both are numerically true and neither is proved here. -/

/-- **The Fourier-side inequality follows from the value at the origin together with the
spread comparison `Δ ≤ Θ`.** -/
theorem fourierSide_nonneg_of_zero_and_spread
    (h0 : (5.3765 : ℝ) ≤ deltaFourier 0)
    (hsp : ∀ t : ℝ, deltaSpread t ≤ 2 * thetaDeriv t - 2 * thetaDeriv 0)
    (t : ℝ) : 0 ≤ fourierSide t := by
  have hzero : 0 ≤ fourierSide 0 := fourierSide_zero_nonneg_of_deltaFourier_zero_ge h0
  refine (fourierSide_nonneg_iff t).2 ?_
  linarith [hsp t]

/-- The spread comparison is *equivalent* to the Fourier-side inequality: no information is
lost in the reduction above.  (Recorded to make the shape of the remaining problem
explicit.) -/
theorem spread_comparison_iff (t : ℝ) :
    deltaSpread t ≤ (2 * thetaDeriv t - 2 * thetaDeriv 0) + fourierSide 0
      ↔ 0 ≤ fourierSide t :=
  (fourierSide_nonneg_iff t).symm

end ConnesConsani.WeilPositivity
