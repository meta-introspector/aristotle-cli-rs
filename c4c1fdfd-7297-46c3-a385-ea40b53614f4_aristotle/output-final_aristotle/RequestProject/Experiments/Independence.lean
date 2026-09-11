/-
Original to this repository (not part of the upstream ZetaZeros development).
-/

import RequestProject.Experiments.Counting

/-! # What the counting data cannot decide

The laboratory's batches measure a *counting* function: how many zeros lie below a height. The
headline results of the repository are about something else — how many of those zeros are simple
and on the critical line, and how many are distinct — and they use a second analytic input, the
pair-correlation formula, to get there.

This file proves, at the level of models, that the second input is not optional: the Riemann–von
Mangoldt shape of the counting function is compatible with *every* value of the simplicity
proportion.

`exists_model_of_any_proportion` — for each `c ∈ [0, 1]` there are counting functions `S ≤ N` with
`N(T) ∼ (T/2π) log T` and `S(T)/N(T) → c`.

So no amount of counting data, however many users pool their batches, can push the proportion in
the headline theorems above `0`: a positive proportion is exactly the content the pair-correlation
input adds. This is a statement about the models, not about the zeta function itself; it says that
the counting asymptotics *alone* do not entail anything about simplicity, which is why the
repository's theorems carry both hypotheses.
-/

open Filter Topology Asymptotics

namespace ZetaZeros.Experiments

/-- Rescaled floors: if `R` tends to infinity then `⌊c·R⌋₊ / R → c` for every `c ≥ 0`. -/
lemma tendsto_floor_mul_div {R : ℝ → ℝ} (hR : Tendsto R atTop atTop) {c : ℝ} (hc : 0 ≤ c) :
    Tendsto (fun T => (⌊c * R T⌋₊ : ℝ) / R T) atTop (𝓝 c) := by
  have hlow : Tendsto (fun T => c - (R T)⁻¹) atTop (𝓝 c) := by
    simpa using tendsto_const_nhds.sub hR.inv_tendsto_atTop
  refine tendsto_of_tendsto_of_tendsto_of_le_of_le' hlow tendsto_const_nhds ?_ ?_
  · filter_upwards [hR.eventually_gt_atTop 0] with T hT
    have h2 : c * R T - 1 < (⌊c * R T⌋₊ : ℝ) := Nat.sub_one_lt_floor _
    rw [le_div_iff₀ hT]
    have hmul : (c - (R T)⁻¹) * R T = c * R T - 1 := by field_simp
    rw [hmul]
    linarith
  · filter_upwards [hR.eventually_gt_atTop 0] with T hT
    have h1 : (⌊c * R T⌋₊ : ℝ) ≤ c * R T := Nat.floor_le (by positivity)
    rw [div_le_iff₀ hT]
    linarith

/-- **The counting asymptotics decide nothing about simplicity.** For every proportion
`c ∈ [0, 1]` there is a model in which the counting function has the Riemann–von Mangoldt shape
and yet the "good" sub-count makes up a proportion tending to exactly `c`. In particular `c = 0`
is possible: counting data alone can never produce a positive proportion, which is precisely the
work done by the second analytic input. -/
theorem exists_model_of_any_proportion {c : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) :
    ∃ N S : ℝ → ℕ,
      (∀ T, S T ≤ N T) ∧
      Asymptotics.IsEquivalent atTop (fun T => (N T : ℝ)) rvmMain ∧
      Tendsto (fun T => (S T : ℝ) / (N T : ℝ)) atTop (𝓝 c) := by
  refine ⟨fun T => ⌊rvmMain T⌋₊, fun T => ⌊c * rvmMain T⌋₊, ?_, isEquivalent_nat_floor_rvmMain, ?_⟩
  · intro T
    by_cases h : rvmMain T ≤ 0
    · have : c * rvmMain T ≤ 0 := mul_nonpos_of_nonneg_of_nonpos hc0 h
      simp [Nat.floor_eq_zero.2 (lt_of_le_of_lt this zero_lt_one)]
    · push_neg at h
      exact Nat.floor_le_floor (by nlinarith)
  · have hnum : Tendsto (fun T => (⌊c * rvmMain T⌋₊ : ℝ) / rvmMain T) atTop (𝓝 c) :=
      tendsto_floor_mul_div tendsto_rvmMain_atTop hc0
    have hden : Tendsto (fun T => (⌊rvmMain T⌋₊ : ℝ) / rvmMain T) atTop (𝓝 1) :=
      (Asymptotics.isEquivalent_iff_tendsto_one eventually_rvmMain_ne_zero).1
        isEquivalent_nat_floor_rvmMain
    have hquot := hnum.div hden one_ne_zero
    rw [div_one] at hquot
    refine hquot.congr' ?_
    filter_upwards [tendsto_rvmMain_atTop.eventually_ge_atTop 1] with T hT
    have hR : rvmMain T ≠ 0 := by linarith
    have hB1 : 1 ≤ ⌊rvmMain T⌋₊ := Nat.le_floor (by exact_mod_cast hT)
    have hB : (⌊rvmMain T⌋₊ : ℝ) ≠ 0 := by
      have : (1 : ℝ) ≤ (⌊rvmMain T⌋₊ : ℝ) := by exact_mod_cast hB1
      linarith
    simp only [Pi.div_apply]
    field_simp

end ZetaZeros.Experiments
