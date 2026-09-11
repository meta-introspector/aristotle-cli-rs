/-
Original to this repository (not part of the upstream ZetaZeros development).
-/

import RequestProject.ExternalInputs

/-! # Experiment track 1: interface-preserving formulations of the Riemann–von Mangoldt input

The repository takes the Riemann–von Mangoldt formula as an external hypothesis
(`ZetaZeros.RiemannVonMangoldt`) and `RequestProject/ExternalInputs.lean` already identifies it
with Mathlib's `Asymptotics.IsEquivalent atTop (fun T => (zeroCount T : ℝ)) rvmMain`.

This file adds the other formulations a contributor is likely to arrive at, and proves them all
equivalent, so that a proof written in *any* of these idioms discharges the hypothesis without
restating it:

* `riemannVonMangoldt_iff_isLittleO` — the little-o form `N(T) - (T/2π) log T = o((T/2π) log T)`;
* `riemannVonMangoldt_iff_eventually_le` — the "relative error at most `ε`" form;
* `riemannVonMangoldt_iff_isEquivalent_sharp` — the sharper main term
  `(T/2π) log (T/2π) - T/2π`, which is *equivalent* to `(T/2π) log T` even though it is a strictly
  better approximation at finite height. This is exactly the distinction the error dashboard in
  `web/experiments.html` is meant to make visible: two formulas can be indistinguishable
  asymptotically and very different numerically.

Nothing here proves the Riemann–von Mangoldt formula.
-/

open Filter Topology Asymptotics

namespace ZetaZeros.Experiments

/-- The sharper main term of the Riemann–von Mangoldt formula,
`T/(2π) · log (T/(2π)) - T/(2π)`. -/
noncomputable def rvmSharp (T : ℝ) : ℝ :=
  T / (2 * Real.pi) * Real.log (T / (2 * Real.pi)) - T / (2 * Real.pi)

lemma rvmSharp_div_rvmMain_eventually_eq :
    (fun T : ℝ => rvmSharp T / rvmMain T)
      =ᶠ[atTop] fun T : ℝ => 1 - (Real.log (2 * Real.pi) + 1) * (Real.log T)⁻¹ := by
  filter_upwards [eventually_gt_atTop (max 1 (2 * Real.pi))] with T hT
  have hpi : (0 : ℝ) < 2 * Real.pi := by positivity
  have hT1 : 1 < T := lt_of_le_of_lt (le_max_left _ _) hT
  have hTpos : 0 < T := lt_trans one_pos hT1
  have hlog : Real.log T ≠ 0 := (Real.log_pos hT1).ne'
  have hTne : T / (2 * Real.pi) ≠ 0 := (div_pos hTpos hpi).ne'
  have hsplit : Real.log (T / (2 * Real.pi)) = Real.log T - Real.log (2 * Real.pi) :=
    Real.log_div hTpos.ne' hpi.ne'
  rw [rvmSharp, rvmMain, hsplit]
  field_simp
  ring

lemma rvmSharp_isEquivalent_rvmMain : IsEquivalent atTop rvmSharp rvmMain := by
  rw [Asymptotics.isEquivalent_iff_tendsto_one eventually_rvmMain_ne_zero]
  have h : Tendsto (fun T : ℝ => 1 - (Real.log (2 * Real.pi) + 1) * (Real.log T)⁻¹) atTop
      (𝓝 (1 - (Real.log (2 * Real.pi) + 1) * 0)) :=
    tendsto_const_nhds.sub (tendsto_const_nhds.mul
      (Real.tendsto_log_atTop.inv_tendsto_atTop))
  rw [mul_zero, sub_zero] at h
  exact Tendsto.congr' rvmSharp_div_rvmMain_eventually_eq.symm h

/-- **Track 1, reference solution.** The assumed Riemann–von Mangoldt input is equally well
expressed with the sharper main term `T/(2π) log (T/(2π)) - T/(2π)`. -/
theorem riemannVonMangoldt_iff_isEquivalent_sharp :
    RiemannVonMangoldt ↔
      Asymptotics.IsEquivalent atTop (fun T : ℝ => (zeroCount T : ℝ)) rvmSharp := by
  rw [riemannVonMangoldt_iff_isEquivalent]
  exact ⟨fun h => h.trans rvmSharp_isEquivalent_rvmMain.symm,
    fun h => h.trans rvmSharp_isEquivalent_rvmMain⟩

/-- **Track 1, reference solution.** The little-o formulation of the input. -/
theorem riemannVonMangoldt_iff_isLittleO :
    RiemannVonMangoldt ↔
      (fun T : ℝ => (zeroCount T : ℝ) - rvmMain T) =o[atTop] rvmMain :=
  riemannVonMangoldt_iff_isEquivalent

/-- **Track 1, reference solution.** The "relative error eventually at most `ε`" formulation of
the input. -/
theorem riemannVonMangoldt_iff_eventually_le :
    RiemannVonMangoldt ↔
      ∀ ε > 0, ∀ᶠ T in atTop, |(zeroCount T : ℝ) - rvmMain T| ≤ ε * |rvmMain T| := by
  rw [riemannVonMangoldt_iff_isLittleO, Asymptotics.isLittleO_iff_forall_isBigOWith]
  constructor
  · intro h ε hε
    simpa [Asymptotics.IsBigOWith, Real.norm_eq_abs] using (h hε).bound
  · intro h ε hε
    exact Asymptotics.isBigOWith_iff.2 (by simpa [Real.norm_eq_abs] using h ε hε)

end ZetaZeros.Experiments
