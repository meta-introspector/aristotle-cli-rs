/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Companion effort: arithmetic holonomy certificate for `ζ_5(3)`.
-/
import Mathlib

/-!
# The 41-coefficient template and its admissibility

The *template* of the certificate is the polynomial of degree `40`

`ψ(z) = 5⁻⁴⁵ · Σ_{k=0}^{40} (-1)^k C(40,k) C(40+k,k) z^k`,

i.e. the degree-40 Legendre-type (Apéry) polynomial `Σ_k (-1)^k C(40,k)C(40+k,k) z^k`
normalised by the `5`-power `5^45` allowed by the arithmetic bookkeeping
(see `Zeta5/Denominator.lean`: the denominator type is `τ = 45/16`, so at level
`16` the admissible `5`-power is `5^45`).

**Admissibility** of the template is the statement

`max_{|z| = 1} log |ψ(z)| < 0`.

Here it is proved in the strongest possible form: the maximum of `|ψ|` on the
unit circle is *computed exactly*.  Because all coefficients of `ψ(-z)` are
non-negative, the maximum is attained at `z = -1` and equals the `ℓ¹`-norm of
the coefficient vector,

`max_{|z|=1} |ψ(z)| = |ψ(-1)| = Σ_k C(40,k)C(40+k,k) / 5^45
                    = 378150244155138145169182750209 / 5^45 ≈ 0.0133`,

so `max_{|z|=1} log|ψ(z)| = log(0.0133…) ≈ -4.32 < 0` with a large margin.

All numerical facts here are exact rational computations.
-/

namespace Zeta5

open Finset

/-- The absolute values of the 41 template coefficients:
`tmplNum k = C(40,k) · C(40+k,k)` for `0 ≤ k ≤ 40`. -/
def tmplNum : List ℕ :=
  [1, 1640, 671580, 121929080, 12406283890, 803927196072, 35953410713220,
   1172521435096440, 29019905518636890, 561768047570649920, 8707404737345073760,
   110101894612710436800, 1153011507471995407600, 10124669095197876833600,
   75315140514278083792800, 478669559712967376994240, 2617724154680290342937250,
   12391164856756530066222000, 51017944194176577494877000, 183438480786817721851386000,
   577831214478475823831865900, 1598535332570840147562078000, 3890650044976135731049851000,
   8340259264655837276012346000, 15753823055461025965801098000, 26214361564287147207093027072,
   38390854953615792507429137280, 49397286620701801607638588160, 55697960934566827322898612160,
   54836993643069361502211713280, 46916094561292675951892243584, 34662255086907179943645674240,
   21934708297183449808088278230, 11762965698397736168892152880, 5270948297378916380178317640,
   1936266721486132547820606480, 567732526361674666799251900, 127729450781151057249210800,
   20698539808025863847863800, 2150144174666723529232400, 107507208733336176461620]

/-- The template list really is the list of Apéry–Legendre coefficients
`C(40,k)·C(40+k,k)`, `k = 0, …, 40`. -/
theorem tmplNum_eq (k : ℕ) (hk : k ≤ 40) :
    tmplNum.getD k 0 = Nat.choose 40 k * Nat.choose (40 + k) k := by
  interval_cases k <;> rfl

theorem tmplNum_length : tmplNum.length = 41 := rfl

/-- The normalising denominator `5^45`. -/
def tmplDen : ℕ := 5 ^ 45

/-- The `k`-th template coefficient, `(-1)^k C(40,k) C(40+k,k) / 5^45`. -/
def tmplCoeff (k : ℕ) : ℚ := (-1) ^ k * (tmplNum.getD k 0 : ℚ) / (tmplDen : ℚ)

/-- The template `ψ`, a polynomial of degree `40` with `41` rational coefficients,
viewed as a function on `ℂ`. -/
noncomputable def psi (z : ℂ) : ℂ := ∑ k ∈ range 41, (tmplCoeff k : ℂ) * z ^ k

/-- The `ℓ¹`-norm of the template coefficient vector. -/
def tmplL1 : ℚ := (tmplNum.sum : ℚ) / (tmplDen : ℚ)

theorem tmplNum_sum : tmplNum.sum = 378150244155138145169182750209 := by
  simp [tmplNum]

/-- The exact value of the maximum of `|ψ|` on the unit circle, as a rational number. -/
theorem tmplL1_eq : tmplL1 = 378150244155138145169182750209 / 28421709430404007434844970703125 := by
  rw [tmplL1, tmplNum_sum]
  norm_num [tmplDen]

theorem tmplL1_pos : 0 < tmplL1 := by rw [tmplL1_eq]; norm_num

/-- The template is *admissible*: its `ℓ¹`-norm — which is the exact maximum of
`|ψ|` on the unit circle, see `psi_norm_isGreatest` — is `< 1`. -/
theorem tmplL1_lt_one : tmplL1 < 1 := by rw [tmplL1_eq]; norm_num

theorem tmplL1_lt : tmplL1 < 14 / 1000 := by rw [tmplL1_eq]; norm_num

theorem tmplL1_gt : 13 / 1000 < tmplL1 := by rw [tmplL1_eq]; norm_num

theorem abs_tmplCoeff (k : ℕ) : |tmplCoeff k| = (tmplNum.getD k 0 : ℚ) / (tmplDen : ℚ) := by
  rw [tmplCoeff, abs_div, abs_mul, abs_pow, abs_neg, abs_one, one_pow, one_mul]
  simp [tmplDen, abs_of_nonneg]

/-- The rational sum of the 41 coefficient absolute values (numerators). -/
theorem sum_range_tmplNum :
    ∑ k ∈ range 41, ((tmplNum.getD k 0 : ℚ)) = 378150244155138145169182750209 := by
  simp [Finset.sum_range_succ, tmplNum]
  norm_num

theorem sum_abs_tmplCoeff : ∑ k ∈ range 41, |tmplCoeff k| = tmplL1 := by
  simp only [abs_tmplCoeff, ← Finset.sum_div]
  rw [tmplL1, sum_range_tmplNum, tmplNum_sum]
  norm_num

/-- Upper bound: on the unit circle, `|ψ(z)|` is at most the `ℓ¹`-norm of the
coefficient vector. -/
theorem norm_psi_le {z : ℂ} (hz : ‖z‖ = 1) : ‖psi z‖ ≤ (tmplL1 : ℝ) := by
  have h : ‖psi z‖ ≤ ∑ k ∈ range 41, ‖(tmplCoeff k : ℂ) * z ^ k‖ :=
    norm_sum_le _ _
  have h2 : ∀ k ∈ range 41, ‖(tmplCoeff k : ℂ) * z ^ k‖ = ((|tmplCoeff k| : ℚ) : ℝ) := by
    intro k _
    rw [norm_mul, norm_pow, hz, one_pow, mul_one]
    push_cast
    simp [Complex.norm_ratCast]
  rw [Finset.sum_congr rfl h2] at h
  have h3 : ∑ k ∈ range 41, ((|tmplCoeff k| : ℚ) : ℝ) = ((tmplL1 : ℚ) : ℝ) := by
    rw [← Rat.cast_sum, sum_abs_tmplCoeff]
  rwa [h3] at h

/-- The bound is attained at `z = -1`. -/
theorem psi_neg_one : psi (-1) = (tmplL1 : ℂ) := by
  rw [psi]
  have : ∀ k ∈ range 41, (tmplCoeff k : ℂ) * (-1 : ℂ) ^ k
      = (((tmplNum.getD k 0 : ℚ) / (tmplDen : ℚ) : ℚ) : ℂ) := by
    intro k _
    rw [tmplCoeff]
    push_cast
    rw [div_mul_eq_mul_div, mul_comm ((-1 : ℂ) ^ k), mul_assoc, ← mul_pow]
    norm_num
  rw [Finset.sum_congr rfl this, ← Rat.cast_sum, tmplL1]
  congr 1
  rw [← Finset.sum_div, sum_range_tmplNum, tmplNum_sum]
  norm_num

theorem norm_psi_neg_one : ‖psi (-1)‖ = (tmplL1 : ℝ) := by
  rw [psi_neg_one, Complex.norm_ratCast, abs_of_pos (by exact_mod_cast tmplL1_pos)]

/-- **Task 1 (template admissibility), exact form.**  The maximum of `|ψ(z)|`
over the unit circle is exactly the rational number `tmplL1`, attained at `z = -1`. -/
theorem psi_norm_isGreatest :
    IsGreatest {r : ℝ | ∃ z : ℂ, ‖z‖ = 1 ∧ r = ‖psi z‖} (tmplL1 : ℝ) := by
  constructor
  · exact ⟨-1, by simp, norm_psi_neg_one.symm⟩
  · rintro r ⟨z, hz, rfl⟩
    exact norm_psi_le hz

/-- **Task 1 (template admissibility).**  `max_{|z|=1} log |ψ(z)| < 0`: the
maximal value `log tmplL1` of `log |ψ|` on the unit circle is negative. -/
theorem template_log_max_neg : Real.log (tmplL1 : ℝ) < 0 := by
  apply Real.log_neg
  · exact_mod_cast tmplL1_pos
  · exact_mod_cast tmplL1_lt_one

/-- The maximal value of `log |ψ|` on the unit circle is below `-4`. -/
theorem template_log_max_lt : Real.log (tmplL1 : ℝ) < -4 := by
  have hpos : (0 : ℝ) < (tmplL1 : ℝ) := by exact_mod_cast tmplL1_pos
  have h1 : (tmplL1 : ℝ) < 14 / 1000 := by
    have h := tmplL1_lt
    rw [show ((14 : ℝ) / 1000) = (((14 : ℚ) / 1000 : ℚ) : ℝ) by norm_num]
    exact_mod_cast h
  have he4 : Real.exp 4 < 54.6 := by
    have h : Real.exp (4 : ℝ) = Real.exp 1 ^ 4 := by
      rw [← Real.exp_nat_mul]; norm_num
    have hb := Real.exp_one_lt_d9
    have h0 : (0 : ℝ) < Real.exp 1 := Real.exp_pos 1
    have hp : Real.exp 1 ^ 4 < (2.7182818286 : ℝ) ^ 4 := by gcongr
    rw [h]
    calc Real.exp 1 ^ 4 < (2.7182818286 : ℝ) ^ 4 := hp
      _ < 54.6 := by norm_num
  have hmul : (tmplL1 : ℝ) * Real.exp 4 < 1 := by
    have := mul_lt_mul'' h1 he4 hpos.le (Real.exp_pos 4).le
    calc (tmplL1 : ℝ) * Real.exp 4 < (14 / 1000) * 54.6 := this
      _ < 1 := by norm_num
  have hlt : (tmplL1 : ℝ) < Real.exp (-4) := by
    rw [Real.exp_neg, ← one_div, lt_div_iff₀ (Real.exp_pos 4)]
    exact hmul
  exact (Real.log_lt_iff_lt_exp hpos).2 hlt

/-- Quantitative form: at every point of the unit circle at which `ψ` does not
vanish, `log |ψ(z)| ≤ log tmplL1 < -4`. -/
theorem template_log_le {z : ℂ} (hz : ‖z‖ = 1) (hnz : psi z ≠ 0) :
    Real.log ‖psi z‖ ≤ Real.log (tmplL1 : ℝ) :=
  Real.log_le_log (norm_pos_iff.2 hnz) (norm_psi_le hz)

end Zeta5
