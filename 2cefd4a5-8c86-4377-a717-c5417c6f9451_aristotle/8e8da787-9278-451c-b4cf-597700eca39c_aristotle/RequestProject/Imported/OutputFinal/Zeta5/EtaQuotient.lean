/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Companion effort: arithmetic holonomy certificate for `ζ_5(3)`.
-/
import Mathlib
import RequestProject.Imported.OutputFinal.Zeta5.Hauptmodul

/-!
# `t = (η(τ)/η(5τ))^6`

Mathlib has no Dedekind eta function, so it is defined here by its product
expansion,

`η(τ) = e^{πiτ/12} ∏_{n ≥ 1} (1 − qⁿ)`,  `q = e^{2πiτ}`,

which converges and is zero-free on the upper half plane.  The main result,
`etaQuotient_eq_hauptmodul`, is the identity

`(η(τ)/η(5τ))^6 = t(q)`,  `t(q) = q⁻¹ ∏_{n ≥ 1} (1 − qⁿ)^6/(1 − q^{5n})^6`,

which identifies the function whose Bost–Charles integral is computed in
`Zeta5/HauptmodulBC.lean` with the Hauptmodul of `X₀(5)`.
-/

namespace Zeta5.Hauptmodul

open Complex Real

/-! ### The infinite product `∏ (1 − qⁿ)` -/

/-- `Σ_{n ≥ 1} log(1 − qⁿ)`. -/
noncomputable def etaProdLog (q : ℂ) : ℂ := ∑' n : ℕ, Complex.log (1 - q ^ (n + 1))

/-- `∏_{n ≥ 1} (1 − qⁿ)`. -/
noncomputable def etaProd (q : ℂ) : ℂ := ∏' n : ℕ, (1 - q ^ (n + 1))

theorem etaProd_eq_exp {q : ℂ} (hq : ‖q‖ < 1) : etaProd q = Complex.exp (etaProdLog q) := by
  have hfun : (Complex.exp ∘ fun n : ℕ => Complex.log (1 - q ^ (n + 1)))
      = fun n : ℕ => 1 - q ^ (n + 1) := by
    funext n
    exact Complex.exp_log (one_sub_pow_ne_zero hq (by omega))
  have h := (summable_clog_one_sub_pow hq).hasSum.cexp
  rw [hfun] at h
  exact h.tprod_eq

theorem etaProd_ne_zero {q : ℂ} (hq : ‖q‖ < 1) : etaProd q ≠ 0 := by
  rw [etaProd_eq_exp hq]
  exact Complex.exp_ne_zero _

theorem tsum_etaFactorCLog {q : ℂ} (hq : ‖q‖ < 1) :
    ∑' n, etaFactorCLog q n = 6 * etaProdLog q - 6 * etaProdLog (q ^ 5) := by
  have h5 : ‖q ^ 5‖ < 1 := norm_pow_lt_one hq (by omega)
  rw [tsum_congr (etaFactorCLog_eq q),
    Summable.tsum_sub ((summable_clog_one_sub_pow hq).mul_left 6)
      ((summable_clog_one_sub_pow h5).mul_left 6),
    tsum_mul_left, tsum_mul_left, etaProdLog, etaProdLog]

theorem exp_six_mul (w : ℂ) : Complex.exp (6 * w) = (Complex.exp w) ^ 6 := by
  rw [show ((6 : ℂ)) = ((6 : ℕ) : ℂ) by norm_num, Complex.exp_nat_mul]

/-- The Hauptmodul in terms of the two eta products. -/
theorem hauptmodul_eq_etaProd {q : ℂ} (hq : ‖q‖ < 1) :
    hauptmodul q = q⁻¹ * (etaProd q / etaProd (q ^ 5)) ^ 6 := by
  have h5 : ‖q ^ 5‖ < 1 := norm_pow_lt_one hq (by omega)
  rw [hauptmodul, tprod_etaFactor hq, tsum_etaFactorCLog hq, Complex.exp_sub,
    exp_six_mul, exp_six_mul, ← etaProd_eq_exp hq, ← etaProd_eq_exp h5, div_pow]

/-! ### The nome and the Dedekind eta function -/

/-- The nome `q = e^{2πiτ}`. -/
noncomputable def nome (τ : ℂ) : ℂ := Complex.exp (2 * (π : ℂ) * Complex.I * τ)

theorem nome_ne_zero (τ : ℂ) : nome τ ≠ 0 := Complex.exp_ne_zero _

theorem norm_nome (τ : ℂ) : ‖nome τ‖ = Real.exp (-(2 * π * τ.im)) := by
  rw [nome, Complex.norm_exp]
  congr 1
  simp [Complex.mul_re, Complex.mul_im]

theorem norm_nome_lt_one {τ : ℂ} (hτ : 0 < τ.im) : ‖nome τ‖ < 1 := by
  rw [norm_nome, Real.exp_lt_one_iff]
  have : 0 < 2 * π * τ.im := by positivity
  linarith

theorem nome_five (τ : ℂ) : nome (5 * τ) = (nome τ) ^ 5 := by
  rw [nome, nome, ← Complex.exp_nat_mul]
  congr 1
  push_cast
  ring

/-- The Dedekind eta function `η(τ) = e^{πiτ/12} ∏_{n ≥ 1}(1 − qⁿ)`, defined by
its product expansion (Mathlib does not have it). -/
noncomputable def dedekindEta (τ : ℂ) : ℂ :=
  Complex.exp ((π : ℂ) * Complex.I * τ / 12) * etaProd (nome τ)

theorem dedekindEta_ne_zero {τ : ℂ} (hτ : 0 < τ.im) : dedekindEta τ ≠ 0 :=
  mul_ne_zero (Complex.exp_ne_zero _) (etaProd_ne_zero (norm_nome_lt_one hτ))

/-- **The Hauptmodul is the eta quotient.**  On the upper half plane,
`(η(τ)/η(5τ))^6 = t(q)` with `q = e^{2πiτ}`. -/
theorem etaQuotient_eq_hauptmodul {τ : ℂ} (hτ : 0 < τ.im) :
    (dedekindEta τ / dedekindEta (5 * τ)) ^ 6 = hauptmodul (nome τ) := by
  have hq : ‖nome τ‖ < 1 := norm_nome_lt_one hτ
  have h5 : ‖(nome τ) ^ 5‖ < 1 := norm_pow_lt_one hq (by omega)
  have hquot : dedekindEta τ / dedekindEta (5 * τ)
      = Complex.exp (-((π : ℂ) * Complex.I * τ / 3))
        * (etaProd (nome τ) / etaProd ((nome τ) ^ 5)) := by
    rw [dedekindEta, dedekindEta, nome_five, mul_div_mul_comm, ← Complex.exp_sub]
    congr 2
    ring
  rw [hquot, mul_pow, ← Complex.exp_nat_mul, hauptmodul_eq_etaProd hq]
  congr 2
  rw [nome, ← Complex.exp_neg]
  congr 1
  ring

end Zeta5.Hauptmodul
