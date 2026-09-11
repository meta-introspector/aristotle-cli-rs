/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Companion effort: arithmetic holonomy certificate for `ζ_5(3)`.
-/
import Mathlib
import RequestProject.Imported.OutputFinal.Zeta5.Hauptmodul

/-!
# The Bost–Charles integral of the Hauptmodul composition, exactly

Let `ψ(z) = z·exp(Σ_{k ≤ 40} c_k z^k)` be the published template and let

`t(q) = q⁻¹ ∏_{n ≥ 1} (1 − qⁿ)^6/(1 − q^{5n})^6`

be the Hauptmodul of `X₀(5)` written in the nome.  Because `‖ψ‖ ≤ 0.9530 < 1`
on the closed unit disc (`Zeta5.Hauptmodul.norm_psi_le_psiRadius`), the
composition `φ = t ∘ ψ` is defined on the punctured closed disc and

`log‖φ(z)‖ = −log‖ψ(z)‖ + Σ_{n ≥ 1} (6 log‖1 − ψ(z)ⁿ‖ − 6 log‖1 − ψ(z)^{5n}‖)`.

Each factor `1 − ψⁿ` is holomorphic and zero-free on a neighbourhood of the
closed disc and equals `1` at the origin, so by Jensen's formula its circle
average vanishes; the series may be integrated term by term because it is
dominated by the summable majorant `etaBound psiRadius`.  Hence

`BC(φ) = (1/2π) ∫_0^{2π} log‖φ(e^{iθ})‖ dθ = −c₀`,

*exactly*: no quadrature, no coefficient estimates of a `q`-expansion.  With
`c₀ = −0.531289158` (printed to nine decimals, with the `10⁻⁹` rounding carried
through) this gives

`0.53128915 < BC(φ) < 0.53128917`  (`Zeta5.Hauptmodul.BC_phi_eq`).

The reciprocal composition `1/φ` has `BC(1/φ) = +c₀`, so both signs are
available; see `docs/zeta5_holonomy.md` for the resulting normalisation
discrepancy with the quoted budget `3.23494`.
-/

namespace Zeta5.Hauptmodul

open Real MeasureTheory Metric

variable {a : ℕ → ℝ}

/-! ### Continuity along the circle -/

theorem norm_circleMap_one (θ : ℝ) : ‖circleMap 0 1 θ‖ = 1 := by
  rw [norm_circleMap_zero, abs_one]

theorem circleMap_one_ne_zero (θ : ℝ) : circleMap (0 : ℂ) 1 θ ≠ 0 := by
  intro hz
  have := norm_circleMap_one θ
  rw [hz, norm_zero] at this
  norm_num at this

theorem continuous_psi_circle (a : ℕ → ℝ) :
    Continuous fun θ : ℝ => Published.psi a (circleMap 0 1 θ) :=
  (differentiable_psi a).continuous.comp (continuous_circleMap 0 1)

/-- Circle integrability follows from continuity of the parametrised function. -/
theorem circleIntegrable_of_continuous {f : ℂ → ℝ}
    (hf : Continuous fun θ : ℝ => f (circleMap 0 1 θ)) : CircleIntegrable f 0 1 :=
  hf.intervalIntegrable _ _

theorem norm_one_sub_psi_pow_ne_zero (h : Published.Approximates a) {m : ℕ} (hm : 1 ≤ m)
    (θ : ℝ) : ‖1 - Published.psi a (circleMap 0 1 θ) ^ m‖ ≠ 0 := by
  rw [norm_ne_zero_iff]
  exact one_sub_pow_ne_zero
    (norm_psi_lt_one_of_le_one h (le_of_eq (norm_circleMap_one θ))) hm

theorem continuous_log_norm_one_sub_psi_pow (h : Published.Approximates a) {m : ℕ}
    (hm : 1 ≤ m) :
    Continuous fun θ : ℝ => Real.log ‖1 - Published.psi a (circleMap 0 1 θ) ^ m‖ := by
  refine Continuous.log ?_ (norm_one_sub_psi_pow_ne_zero h hm)
  exact continuous_norm.comp (continuous_const.sub ((continuous_psi_circle a).pow m))

theorem continuous_log_norm_psi_circle (a : ℕ → ℝ) :
    Continuous fun θ : ℝ => Real.log ‖Published.psi a (circleMap 0 1 θ)‖ := by
  refine Continuous.log (continuous_norm.comp (continuous_psi_circle a)) ?_
  intro θ
  rw [norm_ne_zero_iff]
  exact psi_ne_zero a (circleMap_one_ne_zero θ)

theorem continuous_etaFactorLog_circle (h : Published.Approximates a) (n : ℕ) :
    Continuous fun θ : ℝ => etaFactorLog (Published.psi a (circleMap 0 1 θ)) n := by
  unfold etaFactorLog
  exact ((continuous_log_norm_one_sub_psi_pow h (m := n + 1) (by omega)).const_smul
      (6 : ℝ)).sub
    ((continuous_log_norm_one_sub_psi_pow h (m := 5 * (n + 1)) (by omega)).const_smul (6 : ℝ))

/-! ### Each factor has vanishing circle average (Jensen) -/

/-- **Jensen for the factors.**  `1 − ψ^m` is holomorphic and zero-free on a
neighbourhood of the closed unit disc, and equals `1` at the origin, so the
circle average of `log‖1 − ψ^m‖` vanishes. -/
theorem circleAverage_log_norm_one_sub_psi_pow (h : Published.Approximates a) {m : ℕ}
    (hm : 1 ≤ m) :
    circleAverage (fun z => Real.log ‖1 - Published.psi a z ^ m‖) 0 1 = 0 := by
  have hAn : AnalyticOnNhd ℂ (fun z => 1 - Published.psi a z ^ m) (closedBall 0 |(1 : ℝ)|) :=
    fun z _ => analyticAt_const.sub (((differentiable_psi a).analyticAt z).pow m)
  have hne : ∀ u ∈ closedBall (0 : ℂ) |(1 : ℝ)|, (1 - Published.psi a u ^ m) ≠ 0 := by
    intro u hu
    rw [abs_one, mem_closedBall, dist_zero_right] at hu
    exact one_sub_pow_ne_zero (norm_psi_lt_one_of_le_one h hu) hm
  have hJ := hAn.circleAverage_log_norm_of_ne_zero hne
  rw [hJ, psi_zero, zero_pow (by omega : m ≠ 0)]
  norm_num

/-- Consequently the circle average of each term of the eta series vanishes. -/
theorem circleAverage_etaFactorLog (h : Published.Approximates a) (n : ℕ) :
    circleAverage (fun z => etaFactorLog (Published.psi a z) n) 0 1 = 0 := by
  have key : (fun z => etaFactorLog (Published.psi a z) n)
      = fun z => (6 : ℝ) • Real.log ‖1 - Published.psi a z ^ (n + 1)‖
          - (6 : ℝ) • Real.log ‖1 - Published.psi a z ^ (5 * (n + 1))‖ := by
    funext z; simp [etaFactorLog, smul_eq_mul]
  have hI1 : CircleIntegrable
      (fun z => (6 : ℝ) • Real.log ‖1 - Published.psi a z ^ (n + 1)‖) 0 1 :=
    circleIntegrable_of_continuous
      ((continuous_log_norm_one_sub_psi_pow h (m := n + 1) (by omega)).const_smul (6 : ℝ))
  have hI2 : CircleIntegrable
      (fun z => (6 : ℝ) • Real.log ‖1 - Published.psi a z ^ (5 * (n + 1))‖) 0 1 :=
    circleIntegrable_of_continuous
      ((continuous_log_norm_one_sub_psi_pow h (m := 5 * (n + 1)) (by omega)).const_smul (6 : ℝ))
  rw [key, circleAverage_fun_sub hI1 hI2, circleAverage_fun_smul, circleAverage_fun_smul,
    circleAverage_log_norm_one_sub_psi_pow h (m := n + 1) (by omega),
    circleAverage_log_norm_one_sub_psi_pow h (m := 5 * (n + 1)) (by omega)]
  simp

theorem intervalIntegral_etaFactorLog (h : Published.Approximates a) (n : ℕ) :
    ∫ θ in (0 : ℝ)..(2 * π), etaFactorLog (Published.psi a (circleMap 0 1 θ)) n = 0 := by
  have hca := circleAverage_etaFactorLog h n
  rw [circleAverage_def, smul_eq_mul, mul_eq_zero] at hca
  rcases hca with hc | hc
  · exfalso
    simp only [inv_eq_zero] at hc
    have : (0 : ℝ) < 2 * π := by positivity
    linarith
  · exact hc

/-! ### The uniform majorant and the interchange of `Σ'` and `∫` -/

theorem abs_etaFactorLog_circle_le (h : Published.Approximates a) (n : ℕ) (θ : ℝ) :
    |etaFactorLog (Published.psi a (circleMap 0 1 θ)) n| ≤ etaBound (psiRadius : ℝ) n :=
  abs_etaFactorLog_le psiRadius_lt_one
    (norm_psi_le_psiRadius h (le_of_eq (norm_circleMap_one θ))) n

theorem summable_etaBound_psiRadius : Summable (etaBound (psiRadius : ℝ)) :=
  summable_etaBound (le_of_lt psiRadius_pos) psiRadius_lt_one

/-- The series converges uniformly along the circle, hence its sum is
continuous there. -/
theorem continuous_tsum_etaFactorLog (h : Published.Approximates a) :
    Continuous fun θ : ℝ => ∑' n, etaFactorLog (Published.psi a (circleMap 0 1 θ)) n := by
  refine continuous_tsum (fun n => continuous_etaFactorLog_circle h n)
    summable_etaBound_psiRadius ?_
  intro n θ
  rw [Real.norm_eq_abs]
  exact abs_etaFactorLog_circle_le h n θ

private theorem integrableOn_etaFactorLog (h : Published.Approximates a) (n : ℕ) :
    IntegrableOn (fun θ : ℝ => etaFactorLog (Published.psi a (circleMap 0 1 θ)) n)
      (Set.Ioc (0 : ℝ) (2 * π)) volume :=
  (continuous_etaFactorLog_circle h n).integrableOn_Ioc

private theorem summable_integral_norm_etaFactorLog (h : Published.Approximates a) :
    Summable fun n => ∫ θ in Set.Ioc (0 : ℝ) (2 * π),
      ‖etaFactorLog (Published.psi a (circleMap 0 1 θ)) n‖ := by
  refine Summable.of_nonneg_of_le (fun n => integral_nonneg fun θ => norm_nonneg _) ?_
    (summable_etaBound_psiRadius.mul_left (2 * π))
  intro n
  have hle : ∫ θ in Set.Ioc (0 : ℝ) (2 * π),
      ‖etaFactorLog (Published.psi a (circleMap 0 1 θ)) n‖
      ≤ ∫ _θ in Set.Ioc (0 : ℝ) (2 * π), etaBound (psiRadius : ℝ) n := by
    refine integral_mono ((integrableOn_etaFactorLog h n).norm) ?_ ?_
    · exact integrableOn_const (measure_Ioc_lt_top.ne) (by simp)
    · intro θ
      simp only [Real.norm_eq_abs]
      exact abs_etaFactorLog_circle_le h n θ
  refine hle.trans (le_of_eq ?_)
  rw [setIntegral_const, measureReal_def, Real.volume_Ioc]
  have : (0 : ℝ) ≤ 2 * π := by positivity
  rw [ENNReal.toReal_ofReal (by linarith)]
  simp [smul_eq_mul]

/-- **Term-by-term integration.**  The circle integral of the eta series is the
sum of the (vanishing) circle integrals of its terms. -/
theorem intervalIntegral_tsum_etaFactorLog (h : Published.Approximates a) :
    ∫ θ in (0 : ℝ)..(2 * π),
      (∑' n, etaFactorLog (Published.psi a (circleMap 0 1 θ)) n) = 0 := by
  have hπ : (0 : ℝ) ≤ 2 * π := by positivity
  rw [intervalIntegral.integral_of_le hπ,
    ← integral_tsum_of_summable_integral_norm (integrableOn_etaFactorLog h)
      (summable_integral_norm_etaFactorLog h)]
  have hzero : ∀ n, ∫ θ in Set.Ioc (0 : ℝ) (2 * π),
      etaFactorLog (Published.psi a (circleMap 0 1 θ)) n = 0 := by
    intro n
    have := intervalIntegral_etaFactorLog h n
    rwa [intervalIntegral.integral_of_le hπ] at this
  simp [hzero]

theorem circleAverage_tsum_etaFactorLog (h : Published.Approximates a) :
    circleAverage (fun z => ∑' n, etaFactorLog (Published.psi a z) n) 0 1 = 0 := by
  rw [circleAverage_def, intervalIntegral_tsum_etaFactorLog h, smul_zero]

/-! ### The Bost–Charles integral of `φ = t ∘ ψ` -/

/-- **The Bost–Charles integral of the Hauptmodul composition.**  It is exactly
`−c₀`, the negative of the constant term of the template exponent. -/
theorem circleAverage_logPhi (h : Published.Approximates a) :
    circleAverage (logPhi a) 0 1 = -(a 0) := by
  have hsplit : logPhi a = fun z => (-Real.log ‖Published.psi a z‖)
      + ∑' n, etaFactorLog (Published.psi a z) n := rfl
  have hI1 : CircleIntegrable (fun z => -Real.log ‖Published.psi a z‖) 0 1 :=
    circleIntegrable_of_continuous (continuous_log_norm_psi_circle a).neg
  have hI2 : CircleIntegrable (fun z => ∑' n, etaFactorLog (Published.psi a z) n) 0 1 :=
    circleIntegrable_of_continuous (continuous_tsum_etaFactorLog h)
  have hneg : circleAverage (fun z => -Real.log ‖Published.psi a z‖) 0 1 = -(a 0) := by
    have hfun : (fun z => -Real.log ‖Published.psi a z‖)
        = fun z => (-1 : ℝ) • Real.log ‖Published.psi a z‖ := by
      funext z; simp
    rw [hfun, circleAverage_fun_smul, Published.circleAverage_log_norm_psi a]
    simp
  rw [hsplit, circleAverage_fun_add hI1 hI2, hneg, circleAverage_tsum_etaFactorLog h, add_zero]

/-- **The deliverable.**  For every coefficient sequence agreeing with the
published decimals to within `10⁻⁹`, the Bost–Charles integral of the Hauptmodul
composition `φ = t ∘ ψ` satisfies

`0.53128915 < BC(φ) < 0.53128917`. -/
theorem BC_phi_eq (h : Published.Approximates a) :
    (0.53128915 : ℝ) < circleAverage (logPhi a) 0 1 ∧
      circleAverage (logPhi a) 0 1 < (0.53128917 : ℝ) := by
  rw [circleAverage_logPhi h]
  have h0 := abs_le.1 (h 0)
  have hpub : ((Published.pubC 0 : ℚ) : ℝ) = -531289158 / 1000000000 := by
    norm_num [Published.pubC]
  have hround : ((Published.roundErr : ℚ) : ℝ) = 1 / 1000000000 := by
    norm_num [Published.roundErr]
  rw [hpub, hround] at h0
  constructor <;> [linarith [h0.2]; linarith [h0.1]]

/-- For the published data, read as exact rationals, the value is exactly
`0.531289158`. -/
theorem circleAverage_logPhiPub :
    circleAverage logPhiPub 0 1 = 531289158 / 1000000000 := by
  rw [logPhiPub, circleAverage_logPhi Published.approximates_pubC]
  norm_num [Published.pubC]

/-! ### The reciprocal composition `1/φ`

`1/t` is the other natural normalisation of the Hauptmodul (the eta quotient
`(η(5τ)/η(τ))^6`), and its Bost–Charles integral is `+c₀`; both signs are
therefore available, and neither is close to the quoted budget `3.23494`. -/

theorem log_norm_phi_inv {a : ℕ → ℝ} (h : Published.Approximates a) {z : ℂ} (hz0 : z ≠ 0)
    (hz : ‖z‖ ≤ 1) : Real.log ‖(phi a z)⁻¹‖ = -logPhi a z := by
  rw [norm_inv, Real.log_inv, log_norm_phi h hz0 hz]

/-- `BC(1/φ) = +c₀`. -/
theorem circleAverage_logPhi_inv (h : Published.Approximates a) :
    circleAverage (fun z => -logPhi a z) 0 1 = a 0 := by
  have hfun : (fun z => -logPhi a z) = fun z => (-1 : ℝ) • logPhi a z := by
    funext z; simp
  rw [hfun, circleAverage_fun_smul, circleAverage_logPhi h]
  simp

theorem BC_phi_inv_eq (h : Published.Approximates a) :
    (-0.53128917 : ℝ) < circleAverage (fun z => -logPhi a z) 0 1 ∧
      circleAverage (fun z => -logPhi a z) 0 1 < (-0.53128915 : ℝ) := by
  rw [circleAverage_logPhi_inv h]
  have h0 := abs_le.1 (h 0)
  have hpub : ((Published.pubC 0 : ℚ) : ℝ) = -531289158 / 1000000000 := by
    norm_num [Published.pubC]
  have hround : ((Published.roundErr : ℚ) : ℝ) = 1 / 1000000000 := by
    norm_num [Published.roundErr]
  rw [hpub, hround] at h0
  constructor <;> [linarith [h0.1]; linarith [h0.2]]

end Zeta5.Hauptmodul
