/-
Original to this repository (not part of the upstream ZetaZeros development).
-/

import RequestProject.Experiments.Counting

/-! # The synthetic zero sequence `γ_n ∼ 2π n / log n`

`RequestProject/Experiments/Counting.lean` inverts a zero sequence into a counting asymptotic, but
its hypothesis is stated in terms of the comparison function: `M (g n) ∼ n`. The way the model is
usually presented instead fixes the *height of the `n`-th zero*,

`γ_n ∼ 2π n / log n`,

which is the shape the Riemann–von Mangoldt formula predicts. This file closes that gap: it shows
that a sequence with that asymptotic satisfies `rvmMain (γ_n) ∼ n`
(`tendsto_rvmMain_div_natCast`), and hence that its counting function satisfies
`N(T) ∼ (T/2π) log T` (`isEquivalent_rvmMain_of_gamma_asymptotic`).

The heart of it is `tendsto_log_div_log_natCast`: from `γ_n ∼ 2π n / log n` one gets
`log γ_n ∼ log n`, because `log log n / log n → 0`.
-/

open Filter Topology Asymptotics

namespace ZetaZeros.Experiments

/-- `log log n / log n → 0`. -/
lemma tendsto_log_log_div_log_natCast :
    Tendsto (fun n : ℕ => Real.log (Real.log n) / Real.log n) atTop (𝓝 0) :=
  Real.isLittleO_log_id_atTop.tendsto_div_nhds_zero.comp
    (Real.tendsto_log_atTop.comp tendsto_natCast_atTop_atTop)

/-- `c / log n → 0`. -/
lemma tendsto_const_div_log_natCast (c : ℝ) :
    Tendsto (fun n : ℕ => c / Real.log n) atTop (𝓝 0) :=
  tendsto_const_nhds.div_atTop (Real.tendsto_log_atTop.comp tendsto_natCast_atTop_atTop)

/-- If `γ_n ∼ 2π n / log n` then `log γ_n ∼ log n`. -/
theorem tendsto_log_div_log_natCast {g : ℕ → ℝ} (hgpos : ∀ n, 0 < g n)
    (hgamma : Tendsto (fun n : ℕ => g n * Real.log n / (2 * Real.pi * n)) atTop (𝓝 1)) :
    Tendsto (fun n : ℕ => Real.log (g n) / Real.log n) atTop (𝓝 1) := by
  set u : ℕ → ℝ := fun n => g n * Real.log n / (2 * Real.pi * n) with hu
  have hlogu : Tendsto (fun n : ℕ => Real.log (u n)) atTop (𝓝 0) := by
    have := (Real.continuousAt_log (by norm_num : (1 : ℝ) ≠ 0)).tendsto.comp hgamma
    simpa using this
  have hlogu' : Tendsto (fun n : ℕ => Real.log (u n) / Real.log n) atTop (𝓝 0) :=
    hlogu.div_atTop (Real.tendsto_log_atTop.comp tendsto_natCast_atTop_atTop)
  have hlim : Tendsto (fun n : ℕ => Real.log (u n) / Real.log n
      + Real.log (2 * Real.pi) / Real.log n + 1
      - Real.log (Real.log n) / Real.log n) atTop (𝓝 (0 + 0 + 1 - 0)) :=
    ((hlogu'.add (tendsto_const_div_log_natCast (Real.log (2 * Real.pi)))).add
      tendsto_const_nhds).sub tendsto_log_log_div_log_natCast
  simp only [zero_add, add_zero, sub_zero] at hlim
  refine hlim.congr' ?_
  filter_upwards [eventually_ge_atTop 2] with n hn
  have hn0 : (0 : ℝ) < n := by exact_mod_cast Nat.lt_of_lt_of_le (by norm_num) hn
  have hn1 : (1 : ℝ) < n := by exact_mod_cast Nat.lt_of_lt_of_le (by norm_num) hn
  have hlogn : 0 < Real.log n := Real.log_pos hn1
  have hpi : (0 : ℝ) < 2 * Real.pi := by positivity
  have hgn := hgpos n
  have hlogun : Real.log (u n)
      = Real.log (g n) + Real.log (Real.log n) - (Real.log (2 * Real.pi) + Real.log n) := by
    rw [hu]
    dsimp only
    rw [Real.log_div (by positivity) (by positivity), Real.log_mul hgn.ne' hlogn.ne',
      Real.log_mul hpi.ne' hn0.ne']
  rw [hlogun]
  field_simp
  ring

/-- If the `n`-th zero of a model sits at height `γ_n ∼ 2π n / log n`, then
`rvmMain γ_n ∼ n`: the main term evaluated at the `n`-th zero counts the zeros below it. -/
theorem tendsto_rvmMain_div_natCast {g : ℕ → ℝ} (hgpos : ∀ n, 0 < g n)
    (hgamma : Tendsto (fun n : ℕ => g n * Real.log n / (2 * Real.pi * n)) atTop (𝓝 1)) :
    Tendsto (fun n : ℕ => rvmMain (g n) / n) atTop (𝓝 1) := by
  have hprod : Tendsto (fun n : ℕ => (g n * Real.log n / (2 * Real.pi * n))
      * (Real.log (g n) / Real.log n)) atTop (𝓝 (1 * 1)) :=
    hgamma.mul (tendsto_log_div_log_natCast hgpos hgamma)
  rw [one_mul] at hprod
  refine hprod.congr' ?_
  filter_upwards [eventually_ge_atTop 2] with n hn
  have hn0 : (0 : ℝ) < n := by exact_mod_cast Nat.lt_of_lt_of_le (by norm_num) hn
  have hn1 : (1 : ℝ) < n := by exact_mod_cast Nat.lt_of_lt_of_le (by norm_num) hn
  have hlogn : 0 < Real.log n := Real.log_pos hn1
  have hpi : (0 : ℝ) < 2 * Real.pi := by positivity
  simp only [rvmMain]
  field_simp

/-- **The model problem, solved.** A monotone counting function whose `n`-th jump sits at height
`γ_n ∼ 2π n / log n` satisfies `N(T) ∼ (T/2π) log T`. -/
theorem isEquivalent_rvmMain_of_gamma_asymptotic {N : ℝ → ℝ} {g : ℕ → ℝ}
    (hN : MonotoneOn N (Set.Ici 1)) (hg : Monotone g) (hg1 : ∀ n, 1 ≤ g n)
    (hgtop : Tendsto g atTop atTop) (hNg : ∀ n, N (g n) = n)
    (hgamma : Tendsto (fun n : ℕ => g n * Real.log n / (2 * Real.pi * n)) atTop (𝓝 1)) :
    Asymptotics.IsEquivalent atTop N rvmMain :=
  isEquivalent_rvmMain_of_sample_points hN hg hg1 hgtop hNg
    (tendsto_rvmMain_div_natCast (fun n => lt_of_lt_of_le zero_lt_one (hg1 n)) hgamma)

end ZetaZeros.Experiments
