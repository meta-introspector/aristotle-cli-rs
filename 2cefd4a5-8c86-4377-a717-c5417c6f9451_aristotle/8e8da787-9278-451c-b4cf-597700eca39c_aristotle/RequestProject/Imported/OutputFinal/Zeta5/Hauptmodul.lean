/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Companion effort: arithmetic holonomy certificate for `ζ_5(3)`.
-/
import Mathlib
import RequestProject.Imported.OutputFinal.Zeta5.PublishedTemplate
import RequestProject.Imported.OutputFinal.Zeta5.LogBounds

/-!
# The Hauptmodul of `X₀(5)` as a convergent product, and its composition with `ψ`

The Hauptmodul of `X₀(5)` is the eta quotient

`t(τ) = (η(τ)/η(5τ))^6 = q⁻¹ ∏_{n ≥ 1} (1 - qⁿ)^6 / (1 - q^{5n})^6`,  `q = e^{2πiτ}`,

which we treat here purely as a function of the nome `q` on the punctured unit
disc.  Everything is done with the *product*, never with the `q`-expansion
`Σ aₙ qⁿ`.

## Contents

* `etaFactorLog`, `hauptLog`: the logarithm of the modulus of the product,
  term by term.  Absolute convergence for `‖q‖ ≤ ρ < 1` is proved from the
  elementary majorant `|log‖1 − w‖| ≤ ρ/(1−ρ)` for `‖w‖ ≤ ρ`.
* `hauptmodul`: the actual product, and `log_norm_hauptmodul`:
  `log ‖hauptmodul q‖ = hauptLog q` for `0 < ‖q‖ < 1`.
-/

namespace Zeta5.Hauptmodul

open Complex Real

/-! ### Elementary logarithmic majorants -/

/-- `−log(1 − x) ≤ x/(1 − x)` for `0 ≤ x < 1`. -/
theorem neg_log_one_sub_le {x : ℝ} (hx1 : x < 1) :
    -Real.log (1 - x) ≤ x / (1 - x) := by
  have hpos : (0 : ℝ) < 1 - x := by linarith
  have h := Real.log_le_sub_one_of_pos (x := (1 - x)⁻¹) (by positivity)
  rw [Real.log_inv] at h
  have key : (1 - x)⁻¹ - 1 = x / (1 - x) := by field_simp; ring
  rw [← key]; exact h

/-- `log(1 + x) ≤ x` for `0 ≤ x`. -/
theorem log_one_add_le {x : ℝ} (hx0 : 0 ≤ x) : Real.log (1 + x) ≤ x := by
  have h := Real.log_le_sub_one_of_pos (x := 1 + x) (by linarith)
  linarith

/-- The basic majorant: if `‖w‖ ≤ ρ < 1` then `|log‖1 − w‖| ≤ ρ/(1 − ρ)`. -/
theorem abs_log_norm_one_sub_le {ρ : ℝ} (hρ1 : ρ < 1) {w : ℂ} (hw : ‖w‖ ≤ ρ) :
    |Real.log ‖1 - w‖| ≤ ρ / (1 - ρ) := by
  have hρ0 : 0 ≤ ρ := le_trans (norm_nonneg w) hw
  have hpos : (0 : ℝ) < 1 - ρ := by linarith
  have hlow : 1 - ρ ≤ ‖1 - w‖ := by
    have h := norm_sub_norm_le (1 : ℂ) w
    simp only [norm_one] at h
    linarith
  have hhigh : ‖1 - w‖ ≤ 1 + ρ := by
    calc ‖1 - w‖ ≤ ‖(1 : ℂ)‖ + ‖w‖ := norm_sub_le _ _
      _ ≤ 1 + ρ := by simp only [norm_one]; linarith
  have h1 : Real.log (1 - ρ) ≤ Real.log ‖1 - w‖ := Real.log_le_log hpos hlow
  have h2 : Real.log ‖1 - w‖ ≤ Real.log (1 + ρ) :=
    Real.log_le_log (by linarith) hhigh
  have h3 : -Real.log (1 - ρ) ≤ ρ / (1 - ρ) := neg_log_one_sub_le hρ1
  have h4 : Real.log (1 + ρ) ≤ ρ := log_one_add_le hρ0
  have h5 : ρ ≤ ρ / (1 - ρ) := by
    rw [le_div_iff₀ hpos]; nlinarith
  rw [abs_le]
  constructor <;> linarith

/-! ### The logarithmic eta quotient -/

/-- The logarithm of the modulus of the `n`-th factor
`((1 − q^{n+1})/(1 − q^{5(n+1)}))^6` of the eta quotient. -/
noncomputable def etaFactorLog (q : ℂ) : ℕ → ℝ := fun n =>
  6 * Real.log ‖1 - q ^ (n + 1)‖ - 6 * Real.log ‖1 - q ^ (5 * (n + 1))‖

/-- `log ‖t(q)‖` for the eta quotient `t = (η(τ)/η(5τ))^6`, written as the
convergent series `−log‖q‖ + Σₙ etaFactorLog q n`. -/
noncomputable def hauptLog (q : ℂ) : ℝ := -Real.log ‖q‖ + ∑' n, etaFactorLog q n

/-- The uniform majorant for the terms of `etaFactorLog` on `‖q‖ ≤ ρ`. -/
noncomputable def etaBound (ρ : ℝ) (n : ℕ) : ℝ := 12 * (ρ ^ (n + 1) / (1 - ρ))

theorem abs_etaFactorLog_le {ρ : ℝ} (hρ1 : ρ < 1) {q : ℂ} (hq : ‖q‖ ≤ ρ) (n : ℕ) :
    |etaFactorLog q n| ≤ etaBound ρ n := by
  have hρ0 : 0 ≤ ρ := le_trans (norm_nonneg q) hq
  have hpos : (0 : ℝ) < 1 - ρ := by linarith
  have hp1 : ρ ^ (n + 1) ≤ ρ := by
    calc ρ ^ (n + 1) ≤ ρ ^ 1 := pow_le_pow_of_le_one hρ0 (le_of_lt hρ1) (by omega)
      _ = ρ := pow_one ρ
  have hp5 : ρ ^ (5 * (n + 1)) ≤ ρ ^ (n + 1) :=
    pow_le_pow_of_le_one hρ0 (le_of_lt hρ1) (by omega)
  have hpn0 : (0 : ℝ) ≤ ρ ^ (n + 1) := by positivity
  -- bound for the first factor
  have hb1 : |Real.log ‖1 - q ^ (n + 1)‖| ≤ ρ ^ (n + 1) / (1 - ρ) := by
    have hw : ‖q ^ (n + 1)‖ ≤ ρ ^ (n + 1) := by
      rw [norm_pow]; exact pow_le_pow_left₀ (norm_nonneg q) hq _
    have := abs_log_norm_one_sub_le (ρ := ρ ^ (n + 1)) (by linarith) hw
    refine this.trans ?_
    apply div_le_div_of_nonneg_left hpn0 hpos
    linarith
  have hb2 : |Real.log ‖1 - q ^ (5 * (n + 1))‖| ≤ ρ ^ (n + 1) / (1 - ρ) := by
    have hw : ‖q ^ (5 * (n + 1))‖ ≤ ρ ^ (5 * (n + 1)) := by
      rw [norm_pow]; exact pow_le_pow_left₀ (norm_nonneg q) hq _
    have h50 : (0 : ℝ) ≤ ρ ^ (5 * (n + 1)) := by positivity
    have := abs_log_norm_one_sub_le (ρ := ρ ^ (5 * (n + 1))) (by linarith) hw
    refine this.trans ?_
    apply div_le_div₀ hpn0 hp5 (by linarith) (by linarith)
  have := abs_sub (6 * Real.log ‖1 - q ^ (n + 1)‖) (6 * Real.log ‖1 - q ^ (5 * (n + 1))‖)
  unfold etaFactorLog etaBound
  rw [abs_sub_le_iff]
  rw [abs_le] at hb1 hb2
  constructor <;> nlinarith [hb1.1, hb1.2, hb2.1, hb2.2]

theorem summable_etaBound {ρ : ℝ} (hρ0 : 0 ≤ ρ) (hρ1 : ρ < 1) : Summable (etaBound ρ) := by
  have hgeom : Summable (fun n : ℕ => ρ ^ n) := summable_geometric_of_lt_one hρ0 hρ1
  have : Summable (fun n : ℕ => (12 * ρ / (1 - ρ)) * ρ ^ n) := hgeom.mul_left _
  refine this.congr fun n => ?_
  unfold etaBound
  rw [pow_succ]
  ring

theorem summable_etaFactorLog {ρ : ℝ} (hρ1 : ρ < 1) {q : ℂ} (hq : ‖q‖ ≤ ρ) :
    Summable (etaFactorLog q) := by
  have hρ0 : 0 ≤ ρ := le_trans (norm_nonneg q) hq
  refine Summable.of_norm_bounded (summable_etaBound hρ0 hρ1) ?_
  intro n
  rw [Real.norm_eq_abs]
  exact abs_etaFactorLog_le hρ1 hq n

/-! ### The product itself -/

theorem one_sub_pow_ne_zero {q : ℂ} (hq : ‖q‖ < 1) {m : ℕ} (hm : 1 ≤ m) :
    1 - q ^ m ≠ 0 := by
  intro h
  have : q ^ m = 1 := by linear_combination -h
  have h1 : ‖q‖ ^ m = 1 := by rw [← norm_pow, this, norm_one]
  have h2 : ‖q‖ ^ m < 1 := pow_lt_one₀ (norm_nonneg q) hq (by omega)
  linarith

/-- The `n`-th factor of the eta quotient. -/
noncomputable def etaFactor (q : ℂ) (n : ℕ) : ℂ :=
  (1 - q ^ (n + 1)) ^ 6 / (1 - q ^ (5 * (n + 1))) ^ 6

/-- The complex logarithm of the `n`-th factor. -/
noncomputable def etaFactorCLog (q : ℂ) (n : ℕ) : ℂ :=
  6 * Complex.log (1 - q ^ (n + 1)) - 6 * Complex.log (1 - q ^ (5 * (n + 1)))

theorem re_etaFactorCLog (q : ℂ) (n : ℕ) :
    (etaFactorCLog q n).re = etaFactorLog q n := by
  simp [etaFactorCLog, etaFactorLog, Complex.log_re]

theorem exp_etaFactorCLog {q : ℂ} (hq : ‖q‖ < 1) (n : ℕ) :
    Complex.exp (etaFactorCLog q n) = etaFactor q n := by
  have h1 : (1 : ℂ) - q ^ (n + 1) ≠ 0 := one_sub_pow_ne_zero hq (by omega)
  have h2 : (1 : ℂ) - q ^ (5 * (n + 1)) ≠ 0 := one_sub_pow_ne_zero hq (by omega)
  rw [etaFactorCLog, Complex.exp_sub]
  have e1 : Complex.exp (6 * Complex.log (1 - q ^ (n + 1))) = (1 - q ^ (n + 1)) ^ 6 := by
    rw [show ((6 : ℂ)) = ((6 : ℕ) : ℂ) by norm_num, Complex.exp_nat_mul, Complex.exp_log h1]
  have e2 : Complex.exp (6 * Complex.log (1 - q ^ (5 * (n + 1))))
      = (1 - q ^ (5 * (n + 1))) ^ 6 := by
    rw [show ((6 : ℂ)) = ((6 : ℕ) : ℂ) by norm_num, Complex.exp_nat_mul, Complex.exp_log h2]
  rw [e1, e2, etaFactor]

theorem norm_pow_lt_one {q : ℂ} (hq : ‖q‖ < 1) {m : ℕ} (hm : 1 ≤ m) : ‖q ^ m‖ < 1 := by
  rw [norm_pow]
  exact pow_lt_one₀ (norm_nonneg q) hq (by omega)

/-- The complex logarithms of the factors `1 − q^{n+1}` form a summable family
for `‖q‖ < 1`: eventually `‖q‖^{n+1} ≤ 1/2`, where `‖log(1+z)‖ ≤ (3/2)‖z‖`. -/
theorem summable_clog_one_sub_pow {q : ℂ} (hq : ‖q‖ < 1) :
    Summable fun n : ℕ => Complex.log (1 - q ^ (n + 1)) := by
  have hq0 : 0 ≤ ‖q‖ := norm_nonneg q
  have hgeom : Summable (fun n : ℕ => (3 / 2 : ℝ) * ‖q‖ ^ (n + 1)) := by
    have := (summable_geometric_of_lt_one hq0 hq).mul_left (3 / 2 * ‖q‖)
    refine this.congr fun n => ?_
    rw [pow_succ]; ring
  refine Summable.of_norm_bounded_eventually_nat hgeom ?_
  have htend : Filter.Tendsto (fun n : ℕ => ‖q‖ ^ (n + 1)) Filter.atTop (nhds 0) := by
    have := tendsto_pow_atTop_nhds_zero_of_lt_one hq0 hq
    exact this.comp (Filter.tendsto_add_atTop_nat 1)
  have hev : ∀ᶠ n in Filter.atTop, ‖q‖ ^ (n + 1) ≤ 1 / 2 := by
    filter_upwards [htend.eventually (gt_mem_nhds (by norm_num : (0 : ℝ) < 1 / 2))] with n hn
    exact hn.le
  refine Filter.Eventually.mono hev ?_
  intro n hn
  have := Complex.norm_log_one_add_half_le_self (z := -q ^ (n + 1)) (by
    rw [norm_neg, norm_pow]; exact hn)
  simpa [norm_neg, norm_pow, sub_eq_add_neg] using this

/-- The `n`-th exponent, with the second factor written in the nome `q⁵`. -/
theorem etaFactorCLog_eq (q : ℂ) (n : ℕ) :
    etaFactorCLog q n
      = 6 * Complex.log (1 - q ^ (n + 1)) - 6 * Complex.log (1 - (q ^ 5) ^ (n + 1)) := by
  rw [etaFactorCLog, ← pow_mul]

theorem summable_etaFactorCLog {q : ℂ} (hq : ‖q‖ < 1) : Summable (etaFactorCLog q) := by
  have h5 : ‖q ^ 5‖ < 1 := norm_pow_lt_one hq (by omega)
  have h := ((summable_clog_one_sub_pow hq).mul_left 6).sub
    ((summable_clog_one_sub_pow h5).mul_left 6)
  exact h.congr fun n => (etaFactorCLog_eq q n).symm

/-- The eta quotient `t(q) = q⁻¹ ∏ₙ ((1 − q^{n+1})/(1 − q^{5(n+1)}))^6`. -/
noncomputable def hauptmodul (q : ℂ) : ℂ := q⁻¹ * ∏' n, etaFactor q n

theorem hasProd_etaFactor {q : ℂ} (hq : ‖q‖ < 1) :
    HasProd (etaFactor q) (Complex.exp (∑' n, etaFactorCLog q n)) := by
  have hfun : (Complex.exp ∘ etaFactorCLog q) = etaFactor q :=
    funext (exp_etaFactorCLog hq)
  have h := (summable_etaFactorCLog hq).hasSum.cexp
  rwa [hfun] at h

theorem tprod_etaFactor {q : ℂ} (hq : ‖q‖ < 1) :
    ∏' n, etaFactor q n = Complex.exp (∑' n, etaFactorCLog q n) :=
  (hasProd_etaFactor hq).tprod_eq

/-- **The product form matches the logarithmic series.**  For `0 < ‖q‖ < 1`,
`log ‖hauptmodul q‖ = hauptLog q`. -/
theorem log_norm_hauptmodul {q : ℂ} (hq0 : q ≠ 0) (hq : ‖q‖ < 1) :
    Real.log ‖hauptmodul q‖ = hauptLog q := by
  have hsum := summable_etaFactorCLog hq
  have hre : (∑' n, etaFactorCLog q n).re = ∑' n, etaFactorLog q n := by
    rw [Complex.re_tsum hsum]
    exact tsum_congr fun n => re_etaFactorCLog q n
  rw [hauptmodul, tprod_etaFactor hq, norm_mul, Complex.norm_exp, norm_inv,
    Real.log_mul (by simpa using hq0) (Real.exp_ne_zero _), Real.log_inv, Real.log_exp, hre,
    hauptLog]

/-! ### The composition `φ = t ∘ ψ` with the published template

The published template `ψ(z) = z·exp(Σ_{k ≤ 40} c_k z^k)` of
`Zeta5/PublishedTemplate.lean` satisfies `log‖ψ‖ ≤ −0.0482` on the unit circle,
hence — by the maximum modulus principle, `ψ` being entire — `‖ψ(z)‖ ≤ 0.9530`
on the whole closed unit disc.  Since moreover `ψ(0) = 0`, the composition
`φ = t ∘ ψ` with the eta quotient is well defined on the punctured closed disc,
and its logarithm is `logPhi = hauptLog ∘ ψ`. -/

/-- A rational radius with `exp(−0.0482) ≤ psiRadius < 1`. -/
def psiRadius : ℚ := 953 / 1000

theorem psiRadius_pos : (0 : ℝ) < (psiRadius : ℝ) := by norm_num [psiRadius]

theorem psiRadius_lt_one : (psiRadius : ℝ) < 1 := by norm_num [psiRadius]

theorem differentiable_psi (a : ℕ → ℝ) : Differentiable ℂ (Published.psi a) := by
  unfold Published.psi Published.logPsi
  fun_prop

/-- `ψ(0) = 0`. -/
theorem psi_zero (a : ℕ → ℝ) : Published.psi a 0 = 0 := by simp [Published.psi]

theorem psi_ne_zero (a : ℕ → ℝ) {z : ℂ} (hz : z ≠ 0) : Published.psi a z ≠ 0 := by
  simp only [Published.psi, ne_eq, mul_eq_zero, not_or]
  exact ⟨hz, Complex.exp_ne_zero _⟩

/-- `exp(−0.0482) ≤ 0.9530`, from four terms of the exponential series. -/
theorem exp_bound_le_psiRadius : Real.exp (-(482 / 10000)) ≤ (psiRadius : ℝ) := by
  have hpos : (0 : ℝ) < Real.exp (482 / 10000) := Real.exp_pos _
  have h := Real.sum_le_exp_of_nonneg (x := (482 / 10000 : ℝ)) (by norm_num) 4
  have hnum : (1 : ℝ) ≤ 953 / 1000 * Real.exp (482 / 10000) := by
    simp only [Finset.sum_range_succ, Finset.sum_range_zero, Nat.factorial] at h
    norm_num at h
    nlinarith
  show Real.exp (-(482 / 10000)) ≤ ((953 / 1000 : ℚ) : ℝ)
  rw [Real.exp_neg, ← one_div, div_le_iff₀ hpos]
  push_cast
  linarith

/-- **The composition is well defined**: `‖ψ(z)‖ ≤ psiRadius < 1` on the whole
closed unit disc, by the maximum modulus principle applied to the entire
function `ψ` and the circle bound of `Zeta5/PublishedTemplate.lean`. -/
theorem norm_psi_le_psiRadius {a : ℕ → ℝ} (h : Published.Approximates a) {z : ℂ}
    (hz : ‖z‖ ≤ 1) : ‖Published.psi a z‖ ≤ (psiRadius : ℝ) := by
  have hbd : ∀ w ∈ frontier (Metric.ball (0 : ℂ) 1), ‖Published.psi a w‖ ≤ (psiRadius : ℝ) := by
    intro w hw
    rw [frontier_ball _ (one_ne_zero), Metric.mem_sphere, dist_zero_right] at hw
    exact le_trans (Published.norm_psi_le h hw) exp_bound_le_psiRadius
  have hmem : z ∈ closure (Metric.ball (0 : ℂ) 1) := by
    rw [closure_ball _ (one_ne_zero)]
    simpa [Metric.mem_closedBall, dist_zero_right] using hz
  exact Complex.norm_le_of_forall_mem_frontier_norm_le Metric.isBounded_ball
    (differentiable_psi a).diffContOnCl hbd hmem

theorem norm_psi_lt_one_of_le_one {a : ℕ → ℝ} (h : Published.Approximates a) {z : ℂ}
    (hz : ‖z‖ ≤ 1) : ‖Published.psi a z‖ < 1 :=
  lt_of_le_of_lt (norm_psi_le_psiRadius h hz) psiRadius_lt_one

/-- The composed auxiliary function `φ = t ∘ ψ`. -/
noncomputable def phi (a : ℕ → ℝ) (z : ℂ) : ℂ := hauptmodul (Published.psi a z)

/-- Its logarithm, as a convergent series. -/
noncomputable def logPhi (a : ℕ → ℝ) (z : ℂ) : ℝ := hauptLog (Published.psi a z)

theorem log_norm_phi {a : ℕ → ℝ} (h : Published.Approximates a) {z : ℂ} (hz0 : z ≠ 0)
    (hz : ‖z‖ ≤ 1) : Real.log ‖phi a z‖ = logPhi a z :=
  log_norm_hauptmodul (psi_ne_zero a hz0) (norm_psi_lt_one_of_le_one h hz)

/-! #### The published data itself -/

/-- The published template, with the printed decimals taken as the coefficients. -/
noncomputable def psiPub : ℂ → ℂ := Published.psi (fun k => (Published.pubC k : ℝ))

/-- `φ = t ∘ ψ` for the published data. -/
noncomputable def phiPub : ℂ → ℂ := phi (fun k => (Published.pubC k : ℝ))

/-- `log‖φ‖` for the published data. -/
noncomputable def logPhiPub : ℂ → ℝ := logPhi (fun k => (Published.pubC k : ℝ))

theorem psiPub_zero : psiPub 0 = 0 := psi_zero _

theorem norm_psiPub_le {z : ℂ} (hz : ‖z‖ ≤ 1) : ‖psiPub z‖ ≤ (psiRadius : ℝ) :=
  norm_psi_le_psiRadius Published.approximates_pubC hz

theorem norm_psiPub_lt_one {z : ℂ} (hz : ‖z‖ ≤ 1) : ‖psiPub z‖ < 1 :=
  norm_psi_lt_one_of_le_one Published.approximates_pubC hz

theorem log_norm_phiPub {z : ℂ} (hz0 : z ≠ 0) (hz : ‖z‖ ≤ 1) :
    Real.log ‖phiPub z‖ = logPhiPub z :=
  log_norm_phi Published.approximates_pubC hz0 hz

end Zeta5.Hauptmodul
