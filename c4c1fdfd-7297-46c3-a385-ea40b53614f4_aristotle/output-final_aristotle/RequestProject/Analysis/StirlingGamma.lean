/-
Original to this repository (not part of the upstream ZetaZeros development).
-/
import Mathlib

/-!
# Stirling's asymptotic for the log-Gamma function

Mathlib contains Stirling's formula for factorials (`Stirling.tendsto_stirlingSeq_sqrt_pi`) but not
the asymptotic of `log Γ` along the real axis, which is one of the two ingredients the
Riemann–von Mangoldt formula needs (the other being the argument principle, proved in
`RequestProject/Analysis/ArgumentPrinciple.lean`).

This file proves

`log (Γ x) - ((x - 1/2) * log x - x + log (2π) / 2) → 0`  as `x → ∞`,

by combining Mathlib's Stirling formula for factorials — which gives the statement along the
integers — with the log-convexity of `Γ`, which controls the function between consecutive integers
through Wendel's inequality.
-/

namespace ZetaZeros.Analysis

open Real Filter Set
open scoped Topology

/-- The error term in Stirling's asymptotic for `log Γ`. -/
noncomputable def stirlingErr (x : ℝ) : ℝ :=
  Real.log (Real.Gamma x) - ((x - 1 / 2) * Real.log x - x + Real.log (2 * π) / 2)

/-! ## Stirling's asymptotic along the integers -/

/-- At a positive integer `n` the error term is expressed through `n !`, since `Γ n = (n-1)!`. -/
theorem stirlingErr_nat {n : ℕ} (hn : 1 ≤ n) :
    stirlingErr n
      = Real.log (n.factorial) - ((n + 1 / 2) * Real.log n - n + Real.log (2 * π) / 2) := by
  have hn0 : (0:ℝ) < n := by exact_mod_cast hn
  have hG : Real.Gamma (n : ℝ) = ((n - 1).factorial : ℝ) := by
    obtain ⟨m, rfl⟩ : ∃ m : ℕ, n = m + 1 := ⟨n - 1, by omega⟩
    push_cast
    simpa using Real.Gamma_nat_eq_factorial m
  have hfacn : (n.factorial : ℝ) = n * ((n - 1).factorial : ℝ) := by
    obtain ⟨m, rfl⟩ : ∃ m : ℕ, n = m + 1 := ⟨n - 1, by omega⟩
    simp [Nat.factorial_succ]
  have hfp : (0:ℝ) < ((n - 1).factorial : ℝ) := by exact_mod_cast (n - 1).factorial_pos
  unfold stirlingErr
  rw [hG, hfacn, Real.log_mul hn0.ne' hfp.ne']
  ring

/-- Stirling's formula for factorials, in logarithmic form. -/
theorem tendsto_log_factorial_sub :
    Tendsto (fun n : ℕ ↦
        Real.log (n.factorial) - ((n + 1 / 2) * Real.log n - n + Real.log (2 * π) / 2))
      atTop (𝓝 0) := by
  have hpi : (0:ℝ) < Real.sqrt π := Real.sqrt_pos.mpr Real.pi_pos
  have hlog : Tendsto (fun n : ℕ ↦ Real.log (Stirling.stirlingSeq n)) atTop
      (𝓝 (Real.log (Real.sqrt π))) :=
    (Real.continuousAt_log hpi.ne').tendsto.comp Stirling.tendsto_stirlingSeq_sqrt_pi
  rw [Real.log_sqrt Real.pi_pos.le] at hlog
  have key : ∀ n : ℕ, 1 ≤ n →
      Real.log (n.factorial) - ((n + 1 / 2) * Real.log n - n + Real.log (2 * π) / 2)
        = Real.log (Stirling.stirlingSeq n) - Real.log π / 2 := by
    intro n hn
    have hn0 : (0:ℝ) < n := by exact_mod_cast hn
    have hfac : (0:ℝ) < n.factorial := by exact_mod_cast n.factorial_pos
    have hs : Real.log (Stirling.stirlingSeq n)
        = Real.log (n.factorial) - ((n + 1 / 2) * Real.log n - n) - Real.log 2 / 2 := by
      unfold Stirling.stirlingSeq
      rw [Real.log_div (by positivity) (by positivity),
        Real.log_mul (by positivity) (by positivity), Real.log_sqrt (by positivity),
        Real.log_pow, Real.log_div (by positivity) (by positivity), Real.log_exp,
        Real.log_mul (by norm_num) (by positivity)]
      ring
    rw [hs, Real.log_mul (by norm_num) Real.pi_pos.ne']
    ring
  refine Tendsto.congr' ?_ (by simpa using hlog.sub_const (Real.log π / 2))
  filter_upwards [eventually_ge_atTop 1] with n hn
  exact (key n hn).symm

/-- Stirling's asymptotic for `log Γ` along the integers. -/
theorem tendsto_stirlingErr_nat : Tendsto (fun n : ℕ ↦ stirlingErr n) atTop (𝓝 0) := by
  refine Tendsto.congr' ?_ tendsto_log_factorial_sub
  filter_upwards [eventually_ge_atTop 1] with n hn
  exact (stirlingErr_nat hn).symm

/-! ## Interpolating between the integers: Wendel's inequality -/

/-- One half of Wendel's inequality, from the log-convexity of `Γ`. -/
theorem log_Gamma_add_le {x s : ℝ} (hx : 0 < x) (hs0 : 0 ≤ s) (hs1 : s ≤ 1) :
    Real.log (Real.Gamma (x + s)) ≤ Real.log (Real.Gamma x) + s * Real.log x := by
  have hx1 : (0:ℝ) < x + 1 := by linarith
  have h := Real.convexOn_log_Gamma.2 (Set.mem_Ioi.mpr hx) (Set.mem_Ioi.mpr hx1)
    (by linarith : (0:ℝ) ≤ 1 - s) hs0 (by ring)
  have hxs : (1 - s) • x + s • (x + 1) = x + s := by simp [smul_eq_mul]; ring
  rw [hxs] at h
  simp only [Function.comp_apply, smul_eq_mul] at h
  have hG1 : Real.log (Real.Gamma (x + 1)) = Real.log x + Real.log (Real.Gamma x) := by
    rw [Real.Gamma_add_one hx.ne', Real.log_mul hx.ne' (Real.Gamma_pos_of_pos hx).ne']
  rw [hG1] at h
  nlinarith [h]

/-- The other half of Wendel's inequality, from the log-convexity of `Γ`. -/
theorem le_log_Gamma_add {x s : ℝ} (hx : 0 < x) (hs0 : 0 ≤ s) (hs1 : s ≤ 1) :
    Real.log (Real.Gamma x) + s * Real.log x - (1 - s) * Real.log (1 + s / x)
      ≤ Real.log (Real.Gamma (x + s)) := by
  have hxs : (0:ℝ) < x + s := by linarith
  have hxs1 : (0:ℝ) < x + 1 + s := by linarith
  have h := Real.convexOn_log_Gamma.2 (Set.mem_Ioi.mpr hxs) (Set.mem_Ioi.mpr hxs1) hs0
    (by linarith : (0:ℝ) ≤ 1 - s) (by ring)
  have hcomb : s • (x + s) + (1 - s) • (x + 1 + s) = x + 1 := by
    simp only [smul_eq_mul]; ring
  rw [hcomb] at h
  simp only [Function.comp_apply, smul_eq_mul] at h
  have hG1 : Real.log (Real.Gamma (x + 1)) = Real.log x + Real.log (Real.Gamma x) := by
    rw [Real.Gamma_add_one hx.ne', Real.log_mul hx.ne' (Real.Gamma_pos_of_pos hx).ne']
  have hG2 : Real.log (Real.Gamma (x + 1 + s))
      = Real.log (x + s) + Real.log (Real.Gamma (x + s)) := by
    rw [show x + 1 + s = (x + s) + 1 by ring, Real.Gamma_add_one hxs.ne',
      Real.log_mul hxs.ne' (Real.Gamma_pos_of_pos hxs).ne']
  rw [hG1, hG2] at h
  have hlog : Real.log (1 + s / x) = Real.log (x + s) - Real.log x := by
    rw [← Real.log_div hxs.ne' hx.ne']
    congr 1
    field_simp
  rw [hlog]
  nlinarith [h]

/-- The error term changes by at most `2 / n` between an integer `n` and the next one. -/
theorem abs_stirlingErr_sub_le {x : ℝ} (hx : 2 ≤ x) :
    |stirlingErr x - stirlingErr (⌊x⌋₊ : ℝ)| ≤ 2 / (⌊x⌋₊ : ℝ) := by
  set n : ℕ := ⌊x⌋₊ with hn
  have hn2 : 2 ≤ n := Nat.le_floor (by exact_mod_cast hx)
  have hnR : (2:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn2
  have hn0 : (0:ℝ) < (n:ℝ) := by linarith
  set s : ℝ := x - n with hs
  have hs0 : 0 ≤ s := by
    have := Nat.floor_le (by linarith : (0:ℝ) ≤ x)
    simp only [hs, sub_nonneg]; exact_mod_cast this
  have hs1 : s < 1 := by
    have := Nat.lt_floor_add_one x
    simp only [hs]; linarith
  have hxns : x = (n:ℝ) + s := by simp [hs]
  have hns : (0:ℝ) < (n:ℝ) + s := by linarith
  have hpos : (0:ℝ) < 1 + s / n := by positivity
  -- elementary bounds on `log (1 + s / n)`
  have hL0 : 0 ≤ Real.log (1 + s / n) := Real.log_nonneg (by nlinarith [div_nonneg hs0 hn0.le])
  have hL1 : (n:ℝ) * Real.log (1 + s / n) ≤ s := by
    have h := Real.log_le_sub_one_of_pos hpos
    have hle : Real.log (1 + s / n) ≤ s / n := by linarith
    calc (n:ℝ) * Real.log (1 + s / n) ≤ (n:ℝ) * (s / n) := by nlinarith
      _ = s := by field_simp
  have hL2 : s ≤ ((n:ℝ) + s) * Real.log (1 + s / n) := by
    have hq : (0:ℝ) < (n:ℝ) / ((n:ℝ) + s) := by positivity
    have h := Real.log_le_sub_one_of_pos hq
    have heq : Real.log ((n:ℝ) / ((n:ℝ) + s)) = -Real.log (1 + s / n) := by
      rw [← Real.log_inv]; congr 1; field_simp
    rw [heq] at h
    have hrw : (n:ℝ) / ((n:ℝ) + s) - 1 = -(s / ((n:ℝ) + s)) := by field_simp; ring
    rw [hrw] at h
    have hle : s / ((n:ℝ) + s) ≤ Real.log (1 + s / n) := by linarith
    calc s = ((n:ℝ) + s) * (s / ((n:ℝ) + s)) := by field_simp
      _ ≤ ((n:ℝ) + s) * Real.log (1 + s / n) := by nlinarith
  -- Wendel's inequality at `n`
  have hA1 : Real.log (Real.Gamma x) ≤ Real.log (Real.Gamma (n:ℝ)) + s * Real.log n := by
    rw [hxns]; exact log_Gamma_add_le hn0 hs0 hs1.le
  have hA2 : Real.log (Real.Gamma (n:ℝ)) + s * Real.log n
      - (1 - s) * Real.log (1 + s / n) ≤ Real.log (Real.Gamma x) := by
    rw [hxns]; exact le_log_Gamma_add hn0 hs0 hs1.le
  have hlogx : Real.log x = Real.log n + Real.log (1 + s / n) := by
    rw [hxns, ← Real.log_mul hn0.ne' hpos.ne']
    congr 1
    field_simp
  have hdiff : stirlingErr x - stirlingErr (n:ℝ)
      = (Real.log (Real.Gamma x) - Real.log (Real.Gamma (n:ℝ)) - s * Real.log n)
        - (((n:ℝ) + s - 1 / 2) * Real.log (1 + s / n) - s) := by
    unfold stirlingErr
    rw [hlogx, hxns]
    ring
  rw [hdiff, abs_le]
  constructor
  · rw [neg_le, le_div_iff₀ hn0]
    nlinarith [mul_nonneg hn0.le hL0, mul_nonneg hs0 hL0]
  · rw [le_div_iff₀ hn0]
    nlinarith [mul_nonneg hn0.le hL0, mul_nonneg hs0 hL0]

/-! ## Stirling's asymptotic -/

/-- **Stirling's asymptotic for the log-Gamma function**: the error term tends to `0`. -/
theorem tendsto_stirlingErr_atTop : Tendsto stirlingErr atTop (𝓝 0) := by
  have h1 : Tendsto (fun x : ℝ ↦ stirlingErr (⌊x⌋₊ : ℝ)) atTop (𝓝 0) :=
    tendsto_stirlingErr_nat.comp tendsto_nat_floor_atTop
  have hbnd : Tendsto (fun x : ℝ ↦ 2 / (⌊x⌋₊ : ℝ)) atTop (𝓝 0) :=
    (tendsto_const_div_atTop_nhds_zero_nat 2).comp tendsto_nat_floor_atTop
  have h2 : Tendsto (fun x : ℝ ↦ stirlingErr x - stirlingErr (⌊x⌋₊ : ℝ)) atTop (𝓝 0) := by
    refine squeeze_zero_norm' ?_ hbnd
    filter_upwards [eventually_ge_atTop (2:ℝ)] with x hx using abs_stirlingErr_sub_le hx
  simpa using h2.add h1

/-- **Stirling's asymptotic for the log-Gamma function**, spelled out:
`log Γ x = (x - 1/2) log x - x + (1/2) log (2π) + o(1)`. -/
theorem tendsto_log_Gamma_sub_stirling :
    Tendsto (fun x : ℝ ↦
        Real.log (Real.Gamma x) - ((x - 1 / 2) * Real.log x - x + Real.log (2 * π) / 2))
      atTop (𝓝 0) :=
  tendsto_stirlingErr_atTop

end ZetaZeros.Analysis
