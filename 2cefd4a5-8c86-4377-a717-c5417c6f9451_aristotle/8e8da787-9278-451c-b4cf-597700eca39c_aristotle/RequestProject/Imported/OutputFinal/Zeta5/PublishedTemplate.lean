/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Companion effort: arithmetic holonomy certificate for `ζ_5(3)`.
-/
import Mathlib

/-!
# The published 41-coefficient template, and a certified admissibility bound

This module encodes the template of the draft,

`ψ(z) = z · exp( Σ_{k=0}^{40} c_k z^k )`,

from the 41 published decimal coefficients `c_0, …, c_40`.

## How the data is treated

The published numbers are **decimal approximations of unknown exact rationals**.
They are therefore encoded here as the exact rationals `pubC k` obtained by
reading the printed nine decimal digits, together with the explicit rounding
bound

`|c_k − pubC k| ≤ 10⁻⁹`  (`Approximates`),

and *every* statement below is proved for an arbitrary real coefficient
sequence satisfying that bound; the rounding error is propagated through the
max-modulus estimate (it contributes at most `41 · 10⁻⁹`).

## What is proved

`re_logPsi_le` / `log_norm_psi_le`: for every admissible coefficient sequence
and every `z` on the unit circle,

`log ‖ψ(z)‖ = Re Σ_k c_k z^k ≤ −0.0482 < 0`,

equivalently `‖ψ(z)‖ ≤ exp(−0.0482) < 0.954`.  This is a *certified
admissibility bound for the published template*, obtained from an exact
rational argument: the terms `k = 0, 1, 2` are treated exactly (on the unit
circle `Re z² = 2 (Re z)² − 1`, and the resulting quadratic in `u = Re z` is
maximised in closed form), and the 38 remaining terms are bounded by the
`ℓ¹`-norm of their coefficients.  Note that the plain `ℓ¹` bound on *all* 41
terms is **not** negative (it is `≈ +0.127`); the exact treatment of the first
three terms is what makes the estimate work.

`circleAverage_log_norm_psi`: the circle average ("energy") of `log ‖ψ‖` over
the unit circle is *exactly* the constant term `c₀`, by the same Jensen
abstraction as in `Zeta5/BostCharles.lean` (the factor `exp∘g` is entire and
zero-free, and `log‖z‖ = 0` on the circle).

## What is *not* done here

The genuine auxiliary map of the draft is `φ = x ∘ ψ` with `x` the Hauptmodul
of `X₀(5)`.  That composition is not formalised, and no cost functional is
evaluated for it.  Accordingly this module claims **only** the admissibility
bound and the energy identity above, both for `ψ` itself, and nothing about any
comparison with an arithmetic budget.  See `Zeta5/Certificate.lean` and `docs/zeta5_holonomy.md` for the
status of the other ingredients.
-/

namespace Zeta5.Published

open Finset

/-- The published coefficients, read as exact rationals from the printed nine
decimal digits.  `pubC k = 0` for `k > 40`. -/
def pubC : ℕ → ℚ
  | 0 => -531289158 / 1000000000
  | 1 => -225379074 / 1000000000
  | 2 => -127598877 / 1000000000
  | 3 => -1824369 / 1000000000
  | 4 => -27735780 / 1000000000
  | 5 => -41418343 / 1000000000
  | 6 => 51444137 / 1000000000
  | 7 => 26087140 / 1000000000
  | 8 => -10853938 / 1000000000
  | 9 => 1314954 / 1000000000
  | 10 => -3547849 / 1000000000
  | 11 => -23294126 / 1000000000
  | 12 => 125751 / 1000000000
  | 13 => 20158067 / 1000000000
  | 14 => -1454440 / 1000000000
  | 15 => -4262361 / 1000000000
  | 16 => 7019143 / 1000000000
  | 17 => -198726 / 1000000000
  | 18 => -7684408 / 1000000000
  | 19 => -6339902 / 1000000000
  | 20 => 5397468 / 1000000000
  | 21 => 1260337 / 1000000000
  | 22 => 134428 / 1000000000
  | 23 => 14051878 / 1000000000
  | 24 => -11391873 / 1000000000
  | 25 => -5386029 / 1000000000
  | 26 => -202917 / 1000000000
  | 27 => 1464054 / 1000000000
  | 28 => -123972 / 1000000000
  | 29 => 8670335 / 1000000000
  | 30 => -51833 / 1000000000
  | 31 => -6877094 / 1000000000
  | 32 => -1450246 / 1000000000
  | 33 => -1060183 / 1000000000
  | 34 => 2930635 / 1000000000
  | 35 => 2103211 / 1000000000
  | 36 => 1750273 / 1000000000
  | 37 => -2516914 / 1000000000
  | 38 => -2244428 / 1000000000
  | 39 => 524421 / 1000000000
  | 40 => 1281738 / 1000000000
  | _ => 0

/-- The rounding bound attached to the published decimals: `10⁻⁹`. -/
def roundErr : ℚ := 1 / 1000000000

/-- A real coefficient sequence is *admissible data* for the published template
if each entry agrees with the printed decimal to within `roundErr`.  The true
(unknown, exact) coefficients of the draft are assumed to satisfy this. -/
def Approximates (a : ℕ → ℝ) : Prop := ∀ k, |a k - (pubC k : ℝ)| ≤ (roundErr : ℝ)

/-- The rounded data itself is admissible. -/
theorem approximates_pubC : Approximates (fun k => (pubC k : ℝ)) := by
  intro k
  simp [roundErr]

/-- The exponent `Σ_{k=0}^{40} c_k z^k` of the published template. -/
noncomputable def logPsi (a : ℕ → ℝ) (z : ℂ) : ℂ := ∑ k ∈ range 41, (a k : ℂ) * z ^ k

/-- The published template `ψ(z) = z · exp(Σ_{k=0}^{40} c_k z^k)`. -/
noncomputable def psi (a : ℕ → ℝ) (z : ℂ) : ℂ := z * Complex.exp (logPsi a z)

theorem re_logPsi (a : ℕ → ℝ) (z : ℂ) :
    (logPsi a z).re = ∑ k ∈ range 41, a k * (z ^ k).re := by
  simp [logPsi, Complex.re_sum]

/-- `‖ψ(z)‖ = exp (Re logPsi z)` on the unit circle. -/
theorem norm_psi (a : ℕ → ℝ) {z : ℂ} (hz : ‖z‖ = 1) :
    ‖psi a z‖ = Real.exp ((logPsi a z).re) := by
  rw [psi, norm_mul, hz, one_mul, Complex.norm_exp]

/-! ### The estimate -/

theorem abs_coeff_le {a : ℕ → ℝ} (h : Approximates a) (k : ℕ) :
    |a k| ≤ |(pubC k : ℝ)| + (roundErr : ℝ) := by
  have := h k
  have := abs_sub_abs_le_abs_sub (a k) ((pubC k : ℝ))
  linarith

theorem abs_re_pow_le {z : ℂ} (hz : ‖z‖ = 1) (k : ℕ) : |(z ^ k).re| ≤ 1 := by
  have := Complex.abs_re_le_norm (z ^ k)
  simpa [norm_pow, hz] using this

theorem term_le {a : ℕ → ℝ} (h : Approximates a) {z : ℂ} (hz : ‖z‖ = 1) (k : ℕ) :
    a k * (z ^ k).re ≤ |(pubC k : ℝ)| + (roundErr : ℝ) := by
  have h1 : a k * (z ^ k).re ≤ |a k * (z ^ k).re| := le_abs_self _
  have h2 : |a k * (z ^ k).re| = |a k| * |(z ^ k).re| := abs_mul _ _
  have h3 : |a k| * |(z ^ k).re| ≤ |a k| * 1 :=
    mul_le_mul_of_nonneg_left (abs_re_pow_le hz k) (abs_nonneg _)
  have h4 := abs_coeff_le h k
  linarith

/-- On the unit circle, `Re (z²) = 2 (Re z)² − 1`. -/
theorem re_sq {z : ℂ} (hz : ‖z‖ = 1) : (z ^ 2).re = 2 * z.re ^ 2 - 1 := by
  have h : ‖z‖ ^ 2 = 1 := by rw [hz]; norm_num
  rw [Complex.sq_norm, Complex.normSq_apply] at h
  simp only [pow_two, Complex.mul_re]
  nlinarith [h]

theorem abs_re_le_one {z : ℂ} (hz : ‖z‖ = 1) : |z.re| ≤ 1 := by
  have := Complex.abs_re_le_norm z
  simpa [hz] using this

/-- The closed-form maximum of the exact quadratic head `c₁ u + c₂ (2u² − 1)`
over `u ∈ [−1,1]`: it is `< 0.17737`.  (The true maximum is `0.1773600…`.) -/
theorem head_quadratic_le {u : ℝ} (hu : |u| ≤ 1) :
    ((pubC 1 : ℝ)) * u + ((pubC 2 : ℝ)) * (2 * u ^ 2 - 1) ≤ 17737 / 100000 := by
  have hu1 : u ^ 2 ≤ 1 := by nlinarith [abs_le.1 hu]
  show ((-225379074 / 1000000000 : ℚ) : ℝ) * u
      + ((-127598877 / 1000000000 : ℚ) : ℝ) * (2 * u ^ 2 - 1) ≤ 17737 / 100000
  push_cast
  nlinarith [sq_nonneg (510395508 * u / 1000000000 + 225379074 / 1000000000), hu1]

/-- The tail `ℓ¹`-norm `Σ_{k=3}^{40} |pubC k|`. -/
theorem tail_abs_sum : ∑ k ∈ Finset.Ico 3 41, |pubC k| = 305637701 / 1000000000 := by
  norm_num [Finset.sum_Ico_succ_top, pubC]

/-- **Certified admissibility bound for the published template.**  For every
coefficient sequence agreeing with the published decimals to within `10⁻⁹`, and
every `z` on the unit circle,
`Re Σ_k c_k z^k ≤ −0.0482`.  The rounding error is included. -/
theorem re_logPsi_le {a : ℕ → ℝ} (h : Approximates a) {z : ℂ} (hz : ‖z‖ = 1) :
    (logPsi a z).re ≤ -(482 / 10000) := by
  classical
  have hsplit : ∑ k ∈ range 41, a k * (z ^ k).re
      = (∑ k ∈ Finset.Ico 0 3, a k * (z ^ k).re)
        + ∑ k ∈ Finset.Ico 3 41, a k * (z ^ k).re := by
    rw [Finset.range_eq_Ico, ← Finset.sum_Ico_consecutive _ (by norm_num : (0:ℕ) ≤ 3)
      (by norm_num : (3:ℕ) ≤ 41)]
  -- the head, treated exactly
  have hhead : ∑ k ∈ Finset.Ico 0 3, a k * (z ^ k).re
      = a 0 + (a 1 * z.re + a 2 * (2 * z.re ^ 2 - 1)) := by
    rw [show Finset.Ico 0 3 = Finset.range 3 by rw [Finset.range_eq_Ico]]
    simp [Finset.sum_range_succ, re_sq hz]
    ring
  have h0 : a 0 ≤ (pubC 0 : ℝ) + (roundErr : ℝ) := by
    have := h 0; have := abs_le.1 this; linarith [this.1, this.2]
  have h1 := h 1
  have h2 := h 2
  have hu : |z.re| ≤ 1 := abs_re_le_one hz
  have habs1 : |2 * z.re ^ 2 - 1| ≤ 1 := by
    have : z.re ^ 2 ≤ 1 := by nlinarith [abs_le.1 hu]
    rw [abs_le]; constructor <;> nlinarith [sq_nonneg z.re]
  have hq : a 1 * z.re + a 2 * (2 * z.re ^ 2 - 1)
      ≤ ((pubC 1 : ℝ)) * z.re + ((pubC 2 : ℝ)) * (2 * z.re ^ 2 - 1) + 2 * (roundErr : ℝ) := by
    have herr : (0 : ℝ) ≤ (roundErr : ℝ) := by norm_num [roundErr]
    have e1 : (a 1 - (pubC 1 : ℝ)) * z.re ≤ (roundErr : ℝ) := by
      have hb : |(a 1 - (pubC 1 : ℝ)) * z.re| ≤ (roundErr : ℝ) := by
        rw [abs_mul]
        calc |a 1 - (pubC 1 : ℝ)| * |z.re| ≤ (roundErr : ℝ) * 1 :=
              mul_le_mul h1 hu (abs_nonneg _) herr
          _ = (roundErr : ℝ) := by ring
      exact (abs_le.1 hb).2
    have e2 : (a 2 - (pubC 2 : ℝ)) * (2 * z.re ^ 2 - 1) ≤ (roundErr : ℝ) := by
      have hb : |(a 2 - (pubC 2 : ℝ)) * (2 * z.re ^ 2 - 1)| ≤ (roundErr : ℝ) := by
        rw [abs_mul]
        calc |a 2 - (pubC 2 : ℝ)| * |2 * z.re ^ 2 - 1| ≤ (roundErr : ℝ) * 1 :=
              mul_le_mul h2 habs1 (abs_nonneg _) herr
          _ = (roundErr : ℝ) := by ring
      exact (abs_le.1 hb).2
    nlinarith [e1, e2]
  have hqmax := head_quadratic_le hu
  -- the tail, bounded by its ℓ¹-norm
  have htail : ∑ k ∈ Finset.Ico 3 41, a k * (z ^ k).re
      ≤ ∑ k ∈ Finset.Ico 3 41, (|(pubC k : ℝ)| + (roundErr : ℝ)) :=
    Finset.sum_le_sum fun k _ => term_le h hz k
  have htailval : ∑ k ∈ Finset.Ico 3 41, (|(pubC k : ℝ)| + (roundErr : ℝ))
      = ((305637701 / 1000000000 : ℚ) : ℝ) + 38 * (roundErr : ℝ) := by
    rw [Finset.sum_add_distrib]
    have : ∑ k ∈ Finset.Ico 3 41, |(pubC k : ℝ)|
        = ((∑ k ∈ Finset.Ico 3 41, |pubC k| : ℚ) : ℝ) := by
      push_cast
      rfl
    rw [this, tail_abs_sum, Finset.sum_const, Nat.card_Ico]
    norm_num [roundErr]
  rw [re_logPsi, hsplit, hhead]
  have hpub0 : ((pubC 0 : ℚ) : ℝ) = -531289158 / 1000000000 := by norm_num [pubC]
  rw [htailval] at htail
  have hround : (roundErr : ℝ) = 1 / 1000000000 := by norm_num [roundErr]
  rw [hround] at h0 htail hq
  rw [hpub0] at h0
  norm_num at h0 htail hq ⊢
  linarith [h0, hq, hqmax, htail]

/-- **Admissibility of the published template**, multiplicative form:
`‖ψ(z)‖ ≤ exp(−0.0482) < 1` on the unit circle. -/
theorem norm_psi_le {a : ℕ → ℝ} (h : Approximates a) {z : ℂ} (hz : ‖z‖ = 1) :
    ‖psi a z‖ ≤ Real.exp (-(482 / 10000)) := by
  rw [norm_psi a hz]
  exact Real.exp_le_exp.2 (re_logPsi_le h hz)

theorem norm_psi_lt_one {a : ℕ → ℝ} (h : Approximates a) {z : ℂ} (hz : ‖z‖ = 1) :
    ‖psi a z‖ < 1 := by
  refine lt_of_le_of_lt (norm_psi_le h hz) ?_
  exact Real.exp_lt_one_iff.2 (by norm_num)

/-- **Admissibility, logarithmic form.**  `max_{|z|=1} log ‖ψ(z)‖ ≤ −0.0482 < 0`
for the published template, uniformly over all coefficient data agreeing with
the printed decimals to within `10⁻⁹`. -/
theorem log_norm_psi_le {a : ℕ → ℝ} (h : Approximates a) {z : ℂ} (hz : ‖z‖ = 1) :
    Real.log ‖psi a z‖ ≤ -(482 / 10000) := by
  rw [norm_psi a hz, Real.log_exp]
  exact re_logPsi_le h hz


/-! ### The exact circle average ("energy") of the published template

The Jensen-type abstraction of `Zeta5/BostCharles.lean` — *no zeros in the
closed disc, hence the circle average of `log|·|` is exactly the value at the
centre* — applies to `ψ(z) = z·exp(g(z))` after the zero-free factor `exp∘g` is
split off: on the unit circle `log‖ψ‖ = log‖exp g‖`, and `exp∘g` never vanishes.
The circle average is therefore the constant term, *exactly*. -/

theorem analyticOnNhd_logPsi (a : ℕ → ℝ) (s : Set ℂ) : AnalyticOnNhd ℂ (logPsi a) s := by
  unfold logPsi
  apply Finset.analyticOnNhd_fun_sum
  intro k _
  exact analyticOnNhd_const.mul (analyticOnNhd_id.pow k)

theorem logPsi_zero (a : ℕ → ℝ) : logPsi a 0 = (a 0 : ℂ) := by
  rw [logPsi, Finset.sum_eq_single 0] <;> simp +contextual

/-- **Exact energy of the published template.**  The circle average of
`log ‖ψ‖` over the unit circle is exactly the constant term `c₀`. -/
theorem circleAverage_log_norm_psi (a : ℕ → ℝ) :
    Real.circleAverage (fun z => Real.log ‖psi a z‖) 0 1 = a 0 := by
  have hexp : Real.circleAverage (fun z => Real.log ‖Complex.exp (logPsi a z)‖) 0 1
      = Real.log ‖Complex.exp (logPsi a 0)‖ := by
    refine AnalyticOnNhd.circleAverage_log_norm_of_ne_zero ?_ ?_
    · exact fun z _ => AnalyticAt.cexp' (analyticOnNhd_logPsi a Set.univ z (Set.mem_univ z))
    · exact fun u _ => Complex.exp_ne_zero _
  have hcirc : ∀ θ : ℝ, Real.log ‖psi a (circleMap 0 1 θ)‖
      = Real.log ‖Complex.exp (logPsi a (circleMap 0 1 θ))‖ := by
    intro θ
    rw [psi, norm_mul, norm_circleMap_zero]
    simp
  have : Real.circleAverage (fun z => Real.log ‖psi a z‖) 0 1
      = Real.circleAverage (fun z => Real.log ‖Complex.exp (logPsi a z)‖) 0 1 := by
    unfold Real.circleAverage
    simp only [hcirc]
  rw [this, hexp, Complex.norm_exp, Real.log_exp, logPsi_zero]
  simp

/-- With the published data, the energy is the printed constant term to within
the stated rounding bound. -/
theorem circleAverage_log_norm_psi_approx {a : ℕ → ℝ} (h : Approximates a) :
    |Real.circleAverage (fun z => Real.log ‖psi a z‖) 0 1 - (pubC 0 : ℝ)|
      ≤ (roundErr : ℝ) := by
  rw [circleAverage_log_norm_psi]
  exact h 0

/-- The naive `ℓ¹` estimate does **not** prove admissibility: bounding every
term `k ≥ 1` by `|c_k|` leaves `c_0 + Σ_{k≥1} |c_k| = +0.1273… > 0`.  This
records why the exact treatment of the head `k = 0, 1, 2` is necessary. -/
theorem naive_l1_bound_fails :
    (0 : ℚ) < pubC 0 + ∑ k ∈ Finset.Ico 1 41, |pubC k| := by
  norm_num [Finset.sum_Ico_succ_top, pubC]

end Zeta5.Published
