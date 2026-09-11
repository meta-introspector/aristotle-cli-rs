/-
Original to this repository (not part of the upstream ZetaZeros development).
-/

import ZetaZeros.Zeta.Kernel

/-! # The pair-correlation input, in the standard asymptotic idioms

`ZetaZeros.PairCorrelation` states the Baluyot–Goldston–Suriajaya–Turnage-Butterbaugh formula in
the `C / √log T` form of the source. This file plays for that input the role
`RequestProject/ExternalInputs.lean` plays for the Riemann–von Mangoldt input: it identifies the
hypothesis with the same statement written in Mathlib's asymptotic idioms, so a proof produced in
any of them discharges the hypothesis without restatement.

* `PairCorrelationBigO` — the error is `O(1 / √log T)` in Mathlib's `Asymptotics.IsBigO` sense;
  `pairCorrelation_iff_isBigO` proves this is *the same statement*.
* `PairCorrelationLimit` — the qualitative form, convergence of the normalised pair-correlation
  sum to its main term. `PairCorrelation.toLimit` derives it, and
  `pairCorrelationLimit_of_isBigO` derives it from the `IsBigO` form.

The qualitative form is worth isolating because it is the only consequence of the pair-correlation
input that the development actually consumes: every use of `hPC` in `ZetaZeros/Zeta/Kernel.lean`
goes through `ZetaZeros.PairCorrelation.tendsto`.

Nothing here proves the pair-correlation formula; it only restates the assumption.
-/

open Filter Topology Asymptotics

namespace ZetaZeros

/-- **The pair-correlation input in Mathlib's `IsBigO` idiom.** -/
def PairCorrelationBigO : Prop :=
  ∀ f : ℝ → ℝ, IsPairTestFunction f →
    (fun T : ℝ => pairCorrelationSum f T / ((zeroScale T : ℝ) : ℂ) - ((pairMainTerm f : ℝ) : ℂ))
      =O[atTop] fun T : ℝ => (1 : ℝ) / Real.sqrt (Real.log T)

/-- **The qualitative pair-correlation input**: the normalised pair-correlation sum converges to
its main term, with no rate. -/
def PairCorrelationLimit : Prop :=
  ∀ f : ℝ → ℝ, IsPairTestFunction f →
    Tendsto (fun T : ℝ => pairCorrelationSum f T / ((zeroScale T : ℝ) : ℂ)) atTop
      (𝓝 ((pairMainTerm f : ℝ) : ℂ))

/-- The `C / √log T` form of the pair-correlation input and its `IsBigO` form are the same
statement. -/
theorem pairCorrelation_iff_isBigO : PairCorrelation ↔ PairCorrelationBigO := by
  constructor
  · intro h f hf
    obtain ⟨C, hC, T₀, hb⟩ := h f hf
    refine isBigO_iff.mpr ⟨C, ?_⟩
    filter_upwards [eventually_ge_atTop T₀, eventually_ge_atTop (2 : ℝ)] with T hT hT2
    have hlog : 0 < Real.log T := Real.log_pos (by linarith)
    have hsqrt : 0 < Real.sqrt (Real.log T) := Real.sqrt_pos.mpr hlog
    have hnorm : ‖(1 : ℝ) / Real.sqrt (Real.log T)‖ = 1 / Real.sqrt (Real.log T) := by
      rw [Real.norm_eq_abs, abs_of_nonneg (by positivity)]
    rw [hnorm]
    have := hb T hT
    simpa [zeroScale, div_eq_mul_inv, mul_comm] using this
  · intro h f hf
    obtain ⟨C, hev⟩ := isBigO_iff.mp (h f hf)
    obtain ⟨T₀, hT₀⟩ := eventually_atTop.mp (hev.and (eventually_ge_atTop (2 : ℝ)))
    refine ⟨max C 1, lt_of_lt_of_le one_pos (le_max_right _ _), T₀, fun T hT => ?_⟩
    obtain ⟨hb, hT2⟩ := hT₀ T hT
    have hlog : 0 < Real.log T := Real.log_pos (by linarith)
    have hsqrt : 0 < Real.sqrt (Real.log T) := Real.sqrt_pos.mpr hlog
    have hnorm : ‖(1 : ℝ) / Real.sqrt (Real.log T)‖ = 1 / Real.sqrt (Real.log T) := by
      rw [Real.norm_eq_abs, abs_of_nonneg (by positivity)]
    rw [hnorm] at hb
    calc ‖pairCorrelationSum f T / ((T / (2 * Real.pi) * Real.log T : ℝ) : ℂ) -
            ((pairMainTerm f : ℝ) : ℂ)‖
        ≤ C * (1 / Real.sqrt (Real.log T)) := by simpa [zeroScale] using hb
      _ ≤ max C 1 * (1 / Real.sqrt (Real.log T)) :=
          mul_le_mul_of_nonneg_right (le_max_left _ _) (by positivity)
      _ = max C 1 / Real.sqrt (Real.log T) := by ring

/-- The quantitative pair-correlation input implies its qualitative form. -/
theorem PairCorrelation.toLimit (h : PairCorrelation) : PairCorrelationLimit :=
  fun _ hf => h.tendsto hf

/-- The `IsBigO` form of the pair-correlation input implies its qualitative form. -/
theorem pairCorrelationLimit_of_isBigO (h : PairCorrelationBigO) : PairCorrelationLimit :=
  (pairCorrelation_iff_isBigO.mpr h).toLimit

end ZetaZeros
