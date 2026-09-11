/-
Original to this repository (not part of the upstream ZetaZeros development).
-/

import ZetaZeros.Defs

/-! # The Riemann–von Mangoldt input, in the standard asymptotic idiom

`ZetaZeros.RiemannVonMangoldt` is the external input `N(T) ∼ (T / 2π) log T`, stated in the
`ε`-`T₀` form the source paper uses. Mathlib states asymptotic equivalences with
`Asymptotics.IsEquivalent`, so anyone who proves the formula in the Mathlib idiom — and that is
what `docs/ROADMAP.md` asks for — would have to translate before they could discharge the
hypothesis.

`riemannVonMangoldt_iff_isEquivalent` does that translation once and for all, and
`RiemannVonMangoldt.tendsto_zeroCount_atTop` records the consequence one reaches for most often.

Nothing here proves the Riemann–von Mangoldt formula; it only restates the assumption.
-/

open Filter Topology

namespace ZetaZeros

/-- The comparison function `T ↦ (T / 2π) log T` of the Riemann–von Mangoldt formula. -/
noncomputable def rvmMain (T : ℝ) : ℝ := T / (2 * Real.pi) * Real.log T

lemma rvmMain_pos {T : ℝ} (hT : 1 < T) : 0 < rvmMain T :=
  mul_pos (div_pos (by linarith) (by positivity)) (Real.log_pos hT)

lemma eventually_rvmMain_ne_zero : ∀ᶠ T : ℝ in atTop, rvmMain T ≠ 0 :=
  (eventually_gt_atTop 1).mono fun _ hT => (rvmMain_pos hT).ne'

lemma tendsto_rvmMain_atTop : Tendsto rvmMain atTop atTop :=
  Filter.Tendsto.atTop_mul_atTop₀
    (tendsto_id.atTop_div_const (by positivity)) Real.tendsto_log_atTop

/-- **The Riemann–von Mangoldt input, in Mathlib's idiom.** The hypothesis
`RiemannVonMangoldt` — stated as `|N(T) / ((T / 2π) log T) - 1| < ε` beyond a height depending on
`ε` — says exactly that `N(T)` is asymptotically equivalent to `(T / 2π) log T`. -/
theorem riemannVonMangoldt_iff_isEquivalent :
    RiemannVonMangoldt ↔
      Asymptotics.IsEquivalent atTop (fun T : ℝ => (zeroCount T : ℝ)) rvmMain := by
  rw [Asymptotics.isEquivalent_iff_tendsto_one eventually_rvmMain_ne_zero,
    Metric.tendsto_atTop]
  simp only [RiemannVonMangoldt, Pi.div_apply, Real.dist_eq, rvmMain, ge_iff_le]

/-- Under the Riemann–von Mangoldt input there are arbitrarily many non-trivial zeros below a
sufficiently large height. -/
theorem RiemannVonMangoldt.tendsto_zeroCount_atTop (h : RiemannVonMangoldt) :
    Tendsto (fun T : ℝ => (zeroCount T : ℝ)) atTop atTop :=
  (riemannVonMangoldt_iff_isEquivalent.mp h).symm.tendsto_atTop tendsto_rvmMain_atTop

end ZetaZeros
