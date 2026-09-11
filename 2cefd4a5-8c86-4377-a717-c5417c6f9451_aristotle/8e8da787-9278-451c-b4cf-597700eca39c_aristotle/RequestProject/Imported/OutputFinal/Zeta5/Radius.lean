/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Companion effort: arithmetic holonomy certificate for `ζ_5(3)`.
-/
import Mathlib
import RequestProject.Imported.OutputFinal.Zeta5.Coefficients

/-!
# The `5`-adic overconvergence radius `R₅ = 5³`

For the coefficient sequence `bₙ = 5^{3n}/Dₙ` of `Zeta5/Coefficients.lean`
(`Dₙ` prime to `5`) the `5`-adic absolute value of the general term of
`Σ bₙ zⁿ` is computed exactly:

`|bₙ zⁿ|₅ = (|z|₅ / 125)ⁿ`.

Hence the series converges `5`-adically exactly for `|z|₅ < 125 = 5³` and its
general term blows up for `|z|₅ > 5³`: the overconvergence radius is `R₅ = 5³`.
This is an unconditional theorem: no analytic input is used.
-/

namespace Zeta5

open Filter Topology

/-- The distinguished prime of the certificate. -/
instance : Fact (Nat.Prime 5) := ⟨by norm_num⟩

private theorem padicNorm_pow (q : ℚ) (n : ℕ) :
    padicNorm 5 (q ^ n) = (padicNorm 5 q) ^ n := by
  induction n with
  | zero => simp
  | succ n ih => rw [pow_succ, padicNorm.mul, ih, pow_succ]

/-- The `5`-adic size of the `n`-th coefficient: `|bₙ|₅ = 5^{-3n}`. -/
theorem padicNorm_bseq (n : ℕ) : padicNorm 5 (bseq n) = (1 / 125 : ℚ) ^ n := by
  rw [bseq, padicNorm.div]
  have h1 : padicNorm 5 ((5 : ℚ) ^ (3 * n)) = ((5 : ℚ)⁻¹) ^ (3 * n) := by
    rw [padicNorm_pow]
    congr 1
    simpa using padicNorm.padicNorm_p (p := 5) (by norm_num)
  have h2 : padicNorm 5 ((bDen n : ℚ)) = 1 :=
    (padicNorm.nat_eq_one_iff (p := 5) (bDen n)).2 (five_not_dvd_bDen n)
  rw [h1, h2, div_one, pow_mul]
  norm_num

/-- The `5`-adic size of the general term of the series: `|bₙ zⁿ|₅ = (|z|₅/125)ⁿ`. -/
theorem padicNorm_bseq_mul (n : ℕ) (z : ℚ) :
    padicNorm 5 (bseq n * z ^ n) = (padicNorm 5 z / 125) ^ n := by
  rw [padicNorm.mul, padicNorm_bseq, padicNorm_pow, ← mul_pow]
  congr 1
  ring

/-- `R` is the `5`-adic overconvergence radius of the coefficient sequence `b`:
the general term of `Σ bₙ zⁿ` tends to `0` for `|z|₅ < R` and is unbounded for
`|z|₅ > R`. -/
def IsOverconvRadius5 (b : ℕ → ℚ) (R : ℝ) : Prop :=
  (∀ z : ℚ, (padicNorm 5 z : ℝ) < R →
      Tendsto (fun n => ((padicNorm 5 (b n * z ^ n) : ℚ) : ℝ)) atTop (𝓝 0)) ∧
  (∀ z : ℚ, R < (padicNorm 5 z : ℝ) →
      Tendsto (fun n => ((padicNorm 5 (b n * z ^ n) : ℚ) : ℝ)) atTop atTop)

/-- **Task 4 (5-adic radius).**  The `5`-adic overconvergence radius of the
coefficient sequence is exactly `R₅ = 5³ = 125`. -/
theorem overconv_radius_bseq : IsOverconvRadius5 bseq (5 ^ 3) := by
  constructor
  · intro z hz
    have hnn : (0 : ℝ) ≤ (padicNorm 5 z : ℝ) := by
      exact_mod_cast padicNorm.nonneg z
    have hratio : ((padicNorm 5 z : ℝ) / 125) < 1 := by
      rw [div_lt_one (by norm_num)]
      calc (padicNorm 5 z : ℝ) < 5 ^ 3 := hz
        _ = 125 := by norm_num
    have h := tendsto_pow_atTop_nhds_zero_of_lt_one
      (r := (padicNorm 5 z : ℝ) / 125) (by positivity) hratio
    refine h.congr fun n ↦ ?_
    rw [padicNorm_bseq_mul]
    push_cast
    ring
  · intro z hz
    have hratio : (1 : ℝ) < ((padicNorm 5 z : ℝ) / 125) := by
      rw [lt_div_iff₀ (by norm_num)]
      calc (1 : ℝ) * 125 = 5 ^ 3 := by norm_num
        _ < (padicNorm 5 z : ℝ) := hz
    have h := tendsto_pow_atTop_atTop_of_one_lt hratio
    refine h.congr fun n ↦ ?_
    rw [padicNorm_bseq_mul]
    push_cast
    ring

end Zeta5
