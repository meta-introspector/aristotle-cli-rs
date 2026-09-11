/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Companion effort: arithmetic holonomy certificate for `ζ_5(3)`.
-/
import Mathlib
import RequestProject.Imported.OutputFinal.Zeta5.BostCharlesEnergy

/-!
# How lossy is a supremum bound for the pairwise energy?

The live quantity of the draft is the pairwise (Bost–Charles) energy of the
**reciprocal** normalisation of the Hauptmodul composition,

```
BC(x ∘ ψ),    x = 1/t = (η(5τ)/η(τ))^6 ,
```

for which the budget comparison of `Zeta5/BostCharlesEnergy.lean`
(`paperCostInv_lt_paperBudget_of_energy_bound`) needs a certified bound
`BC(x ∘ ψ) ≤ 1.10944`.

Writing `F = x ∘ ψ` and factoring the divided difference

```
F(z) − F(w) = (z − w)·g(z, w) ,
```

`pairwiseEnergy_id` (the diagonal `log‖z − w‖` carries no mass) turns the energy
into the mean of `log‖g‖` over the torus (`pairwiseEnergy_eq_of_factor` below),
so that any uniform majorant `‖g‖ ≤ M` gives `BC(F) ≤ log M`; and, even more
cheaply, any uniform majorant `‖F‖ ≤ M_F` on the circle gives
`BC(F) ≤ log 2 + log M_F` (`pairwiseEnergy_le_of_le_of_nonneg`).

This module measures how lossy those supremum routes are.

## What is proved

* `pairwiseEnergy_le_of_le_of_nonneg`: a *hypothesis-free* version of
  `pairwiseEnergy_le_of_le` — for a nonnegative bound no integrability
  assumption is needed, because a non-integrable Bochner integral is `0`.
* `pairwiseEnergy_eq_of_factor`: `BC(F) = (1/4π²)∬ log‖g‖` for any
  factorisation `F(z) − F(w) = (z − w) g(z, w)` of the boundary values.
* `log_norm_hauptmodul_inv_le`: the crude certified majorant for the reciprocal
  Hauptmodul, `log‖1/t(q)‖ ≤ log ρ + 12ρ/(1 − ρ)²` for `‖q‖ ≤ ρ < 1`.
* `log_norm_phi_inv_le_crude`: with the certified template radius
  `ρ = psiRadius = 0.953` this gives `log‖F(z)‖ ≤ 5177` on the punctured closed
  unit disc, hence
* `pairwiseEnergy_phi_inv_le_crude`: **`BC(x ∘ ψ) ≤ 5178`**, unconditionally.

## The measurement, and its consequence

The certified crude majorant gives `log M ≈ 5.18·10³`, against the target
`1.109` and the (uncertified) quadrature value `≈ 1.0355`: three orders of
magnitude too large.  The loss is *not* an artefact of the particular crude
majorant:

* the crude modulus bound `∏‖1 − q^n‖^{-6} ≤ ∏(1 − ρ^n)^{-6}` is attained only
  when every power `q^n` is positive real, which never happens along the image
  of `ψ`; sharpening it to the exact product at `ρ = 0.953` still gives
  `log M ≈ 2.1·10²`, and even pretending the certified template radius could be
  pushed down to the true `max‖ψ‖ ≈ 0.836` only gives `log M ≈ 48`;
* the true suprema themselves are far above the mean.  Numerically (not a
  proof) `max_{|z|=1}‖F‖ ≈ 52.4`, so the *best possible* bound of the form
  `BC ≤ log sup‖F(z) − F(w)‖` is `≈ 3.96`, and the *best possible* bound of the
  form `BC ≤ log sup‖g‖` is `≈ 7.29`, since `sup‖g‖ = sup|F'| ≈ 1.47·10³`.
  Both exceed the budget threshold `1.10944` by a factor of `3.6` to `6.6`.
* nor does passing to the sharpest bound that depends only on the image curve
  `K = F(∂D)`.  `BC(F)` is the logarithmic energy of the push-forward measure
  `μ = F_*(uniform)`, and the equilibrium measure maximises that energy, so
  `BC(F) ≤ log cap(K)`; but `K` is a continuum of diameter `≥ 52.3`, whence
  `cap(K) ≥ diam(K)/4 ≥ 13` and `log cap(K) ≥ 2.57`.
* refining the supremum to an `L^p` mean does not rescue it either: Jensen's
  inequality gives `BC ≤ M(p) := (1/p)·log(mean‖g‖^p)`, whose (numerical) values
  are `4.35` at `p = 2` (the Parseval/Dirichlet-energy route, `mean‖g‖² =
  Σ n|f_n|²`), `3.45` at `p = 1`, `2.65` at `p = 1/2` and `1.98` at `p = 1/4`.
  `M` decreases to `BC` as `p → 0`, so the family *does* clear `1.109`, but only
  near `p ≈ 0.015` (measured crossing `p* ≈ 0.0179`,
  `scripts/zeta5/bc_moment_crossing.py`).  There `‖g‖^p` is within a few percent
  of `1` over essentially the whole torus, so certifying the moment is as hard
  as certifying the mean.

**Conclusion.** Sup-norm and moderate-`p` moment bounds do not usefully reach
`1.10944`: the obstruction is quantitative, not structural.  The mean itself has
to be evaluated, i.e. a certified
quadrature of a two-dimensional logarithmically singular integral to an absolute
accuracy of about `0.07`.  That is not attempted here, and accordingly **no
`cost < budget` inequality is asserted**: `paperCostInv_lt_paperBudget_of_energy_bound`
keeps its energy bound as an open hypothesis, and nothing here bears on
`ζ_5(3) ∉ ℚ`.  The numerical values quoted above come from a floating-point
quadrature (`scripts/zeta5/bc_energy.py`, `scripts/zeta5/bc_sup.py`) and are
*not* proofs; the only certified statement of this module is
`BC(x ∘ ψ) ≤ 5178`.
-/

namespace Zeta5.Hauptmodul

open Real MeasureTheory Set

/-! ## Two general facts about the pairwise energy -/

/-- A uniform *nonnegative* bound on the integrand bounds the pairwise energy,
with no integrability hypothesis: when the integrand fails to be integrable the
Bochner integral is `0`, which already satisfies the bound. -/
theorem pairwiseEnergy_le_of_le_of_nonneg {F : ℂ → ℂ} {M : ℝ} (hM : 0 ≤ M)
    (hbound : ∀ θ ψ : ℝ, Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖ ≤ M) :
    pairwiseEnergy F ≤ M := by
  have hpi : (0 : ℝ) < π := Real.pi_pos
  set μ : Measure ℝ := volume.restrict (Icc (0 : ℝ) (2 * π)) with hμdef
  have hμuniv : μ.real Set.univ = 2 * π := by
    rw [hμdef, measureReal_def, Measure.restrict_apply_univ, Real.volume_Icc]
    simp [hpi.le]
  haveI : IsFiniteMeasure μ := by
    constructor
    rw [hμdef, Measure.restrict_apply_univ, Real.volume_Icc]
    exact ENNReal.ofReal_lt_top
  have h2piM : 0 ≤ 2 * π * M := by positivity
  have hinner : ∀ θ : ℝ,
      (∫ ψ : ℝ, Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖ ∂μ) ≤ 2 * π * M := by
    intro θ
    by_cases hint : Integrable
        (fun ψ : ℝ => Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖) μ
    · have := integral_mono hint (integrable_const M) (fun ψ => hbound θ ψ)
      rwa [integral_const, hμuniv, smul_eq_mul] at this
    · rw [integral_undef hint]; exact h2piM
  have houter : (∫ θ : ℝ, ∫ ψ : ℝ,
        Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖ ∂μ ∂μ)
      ≤ 2 * π * (2 * π * M) := by
    by_cases hI : Integrable
        (fun θ : ℝ => ∫ ψ : ℝ, Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖ ∂μ) μ
    · have := integral_mono hI (integrable_const (2 * π * M)) hinner
      rwa [integral_const, hμuniv, smul_eq_mul] at this
    · rw [integral_undef hI]; positivity
  rw [pairwiseEnergy, ← hμdef, div_le_iff₀ (by positivity)]
  nlinarith [houter, Real.pi_pos]

/-- **The divided-difference form of the energy.**  If the boundary values of
`F` factor as `F(z) − F(w) = (z − w)·g(z, w)`, with `g` nonvanishing off the
diagonal (a.e.) and `log‖g‖` integrable in the second variable, then

`BC(F) = (1/4π²) ∬ log‖g(e^{iθ}, e^{iψ})‖ dθ dψ`,

because the diagonal factor contributes nothing
(`integral_log_norm_circleMap_sub_eq_zero`). -/
theorem pairwiseEnergy_eq_of_factor (F : ℂ → ℂ) (g : ℂ → ℂ → ℂ)
    (hfac : ∀ θ ψ : ℝ, F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)
      = (circleMap 0 1 θ - circleMap 0 1 ψ) * g (circleMap 0 1 θ) (circleMap 0 1 ψ))
    (hne : ∀ θ : ℝ, ∀ᵐ ψ ∂(volume.restrict (Icc (0 : ℝ) (2 * π))),
      circleMap 0 1 θ ≠ circleMap 0 1 ψ ∧ g (circleMap 0 1 θ) (circleMap 0 1 ψ) ≠ 0)
    (hgint : ∀ θ : ℝ, IntegrableOn
      (fun ψ : ℝ => Real.log ‖g (circleMap 0 1 θ) (circleMap 0 1 ψ)‖) (Icc 0 (2 * π))) :
    pairwiseEnergy F
      = (∫ θ : ℝ, (∫ ψ : ℝ, Real.log ‖g (circleMap 0 1 θ) (circleMap 0 1 ψ)‖
          ∂(volume.restrict (Icc (0 : ℝ) (2 * π))))
        ∂(volume.restrict (Icc (0 : ℝ) (2 * π)))) / (4 * π ^ 2) := by
  have hpi : (0 : ℝ) < π := Real.pi_pos
  set μ : Measure ℝ := volume.restrict (Icc (0 : ℝ) (2 * π)) with hμdef
  -- integrability of the diagonal factor, for each fixed `θ`
  have hdiag : ∀ θ : ℝ, IntegrableOn
      (fun ψ : ℝ => Real.log ‖circleMap 0 1 θ - circleMap 0 1 ψ‖) (Icc 0 (2 * π)) := by
    intro θ
    have h := circleIntegrable_log_norm_sub_const (a := circleMap 0 1 θ) (c := 0) (r := 1)
    have h' : IntegrableOn
        (fun ψ : ℝ => Real.log ‖circleMap 0 1 ψ - circleMap 0 1 θ‖) (Ioc 0 (2 * π)) := h.1
    rw [integrableOn_Icc_iff_integrableOn_Ioc]
    exact h'.congr_fun (fun ψ _ => by rw [norm_sub_rev]) measurableSet_Ioc
  have hinner : ∀ θ : ℝ,
      (∫ ψ : ℝ, Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖ ∂μ)
        = ∫ ψ : ℝ, Real.log ‖g (circleMap 0 1 θ) (circleMap 0 1 ψ)‖ ∂μ := by
    intro θ
    have hcongr : (∫ ψ : ℝ, Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖ ∂μ)
        = ∫ ψ : ℝ, (Real.log ‖circleMap 0 1 θ - circleMap 0 1 ψ‖
            + Real.log ‖g (circleMap 0 1 θ) (circleMap 0 1 ψ)‖) ∂μ := by
      refine integral_congr_ae ?_
      filter_upwards [hne θ] with ψ hψ
      have h1 : ‖circleMap 0 1 θ - circleMap 0 1 ψ‖ ≠ 0 := by
        simpa [sub_eq_zero] using hψ.1
      have h2 : ‖g (circleMap 0 1 θ) (circleMap 0 1 ψ)‖ ≠ 0 := by simpa using hψ.2
      rw [hfac θ ψ, norm_mul, Real.log_mul h1 h2]
    rw [hcongr, integral_add (hdiag θ) (hgint θ), integral_log_norm_circleMap_sub_eq_zero θ,
      zero_add]
  rw [pairwiseEnergy, ← hμdef]
  simp only [hinner]

/-! ## The crude certified majorant for the reciprocal Hauptmodul -/

/-- The sum of the uniform majorants of `Zeta5/Hauptmodul.lean`:
`Σₙ etaBound ρ n = 12ρ/(1 − ρ)²`. -/
theorem tsum_etaBound {ρ : ℝ} (hρ0 : 0 ≤ ρ) (hρ1 : ρ < 1) :
    ∑' n, etaBound ρ n = 12 * ρ / (1 - ρ) ^ 2 := by
  have hpos : (0 : ℝ) < 1 - ρ := by linarith
  have hgeom : ∑' n : ℕ, ρ ^ n = (1 - ρ)⁻¹ := tsum_geometric_of_lt_one hρ0 hρ1
  have hcongr : ∀ n : ℕ, etaBound ρ n = (12 * ρ / (1 - ρ)) * ρ ^ n := by
    intro n; unfold etaBound; rw [pow_succ]; ring
  rw [tsum_congr hcongr, tsum_mul_left, hgeom]
  field_simp

/-- **The crude certified majorant.**  For `0 < ‖q‖ ≤ ρ < 1`,

`log‖1/t(q)‖ = log‖q‖ − Σₙ etaFactorLog q n ≤ log ρ + 12ρ/(1 − ρ)²`.

The bound is attained only when every power `q^n` is positive real, which is why
it is so lossy along the image of the template. -/
theorem log_norm_hauptmodul_inv_le {ρ : ℝ} (hρ1 : ρ < 1) {q : ℂ} (hq0 : q ≠ 0) (hq : ‖q‖ ≤ ρ) :
    Real.log ‖(hauptmodul q)⁻¹‖ ≤ Real.log ρ + 12 * ρ / (1 - ρ) ^ 2 := by
  have hρ0 : 0 ≤ ρ := le_trans (norm_nonneg q) hq
  have hqnorm : (0 : ℝ) < ‖q‖ := norm_pos_iff.2 hq0
  have hq1 : ‖q‖ < 1 := lt_of_le_of_lt hq hρ1
  have hsum := summable_etaFactorLog hρ1 hq
  have hbound := summable_etaBound hρ0 hρ1
  have habsum : Summable (fun n => |etaFactorLog q n|) := hsum.abs
  have habs : |∑' n, etaFactorLog q n| ≤ ∑' n, etaBound ρ n := by
    have hnorm : |∑' n, etaFactorLog q n| ≤ ∑' n, |etaFactorLog q n| := by
      simpa [Real.norm_eq_abs] using
        norm_tsum_le_tsum_norm (f := etaFactorLog q)
          (by simpa [Real.norm_eq_abs] using habsum)
    have h2 : ∑' n, |etaFactorLog q n| ≤ ∑' n, etaBound ρ n :=
      habsum.tsum_mono hbound (fun n => abs_etaFactorLog_le hρ1 hq n)
    exact hnorm.trans h2
  rw [tsum_etaBound hρ0 hρ1] at habs
  have hlogq : Real.log ‖q‖ ≤ Real.log ρ := Real.log_le_log hqnorm hq
  rw [norm_inv, Real.log_inv, log_norm_hauptmodul hq0 hq1, hauptLog]
  have := (abs_le.1 habs).1
  linarith

/-- The template radius makes the crude majorant explicit: `log‖F(z)‖ ≤ 5177`
for `F = x ∘ ψ = 1/(t ∘ ψ)` on the punctured closed unit disc. -/
theorem log_norm_phi_inv_le_crude {a : ℕ → ℝ} (h : Published.Approximates a) {z : ℂ}
    (hz0 : z ≠ 0) (hz : ‖z‖ ≤ 1) : Real.log ‖(phi a z)⁻¹‖ ≤ 5177 := by
  have hq0 : Published.psi a z ≠ 0 := psi_ne_zero a hz0
  have hq : ‖Published.psi a z‖ ≤ (psiRadius : ℝ) := norm_psi_le_psiRadius h hz
  have hmain := log_norm_hauptmodul_inv_le (ρ := (psiRadius : ℝ)) psiRadius_lt_one hq0 hq
  have hlog : Real.log (psiRadius : ℝ) ≤ -(47 / 1000) := by
    have := Real.log_le_sub_one_of_pos (x := (psiRadius : ℝ)) psiRadius_pos
    rw [show ((psiRadius : ℚ) : ℝ) = 953 / 1000 by norm_num [psiRadius]] at this ⊢
    linarith
  have harith : 12 * (psiRadius : ℝ) / (1 - (psiRadius : ℝ)) ^ 2 ≤ 5177 + 47 / 1000 := by
    rw [show ((psiRadius : ℚ) : ℝ) = 953 / 1000 by norm_num [psiRadius]]
    norm_num
  have hrw : (phi a z)⁻¹ = (hauptmodul (Published.psi a z))⁻¹ := rfl
  rw [hrw]
  linarith

/-! ## The certified (but hopelessly lossy) energy bound -/

/-- **The certified crude bound on the live quantity.**  Unconditionally,

`BC((1/t) ∘ ψ) ≤ 5178`.

The threshold that `paperCostInv_lt_paperBudget_of_energy_bound` needs is
`1.10944`, and (uncertified) quadrature puts the true value at `≈ 1.0355`, so
this certified bound is three orders of magnitude too weak; see the module
docstring for why supremum-type bounds do not do better than `≈ 4`. -/
theorem pairwiseEnergy_phi_inv_le_crude {a : ℕ → ℝ} (h : Published.Approximates a) :
    pairwiseEnergy (fun z => (phi a z)⁻¹) ≤ 5178 := by
  refine pairwiseEnergy_le_of_le_of_nonneg (by norm_num) (fun θ ψ => ?_)
  have hb : ∀ ω : ℝ, ‖(phi a (circleMap 0 1 ω))⁻¹‖ ≤ Real.exp 5177 := by
    intro ω
    have hz0 : circleMap 0 1 ω ≠ 0 := circleMap_one_ne_zero ω
    have hz : ‖circleMap 0 1 ω‖ ≤ 1 := le_of_eq (norm_circleMap_one ω)
    have hne : (phi a (circleMap 0 1 ω))⁻¹ ≠ 0 := by
      simpa using (phi_ne_zero_circle h ω)
    have hpos : (0 : ℝ) < ‖(phi a (circleMap 0 1 ω))⁻¹‖ := norm_pos_iff.2 hne
    have := log_norm_phi_inv_le_crude h hz0 hz
    calc ‖(phi a (circleMap 0 1 ω))⁻¹‖
        = Real.exp (Real.log ‖(phi a (circleMap 0 1 ω))⁻¹‖) := (Real.exp_log hpos).symm
      _ ≤ Real.exp 5177 := Real.exp_le_exp.2 this
  have hsub : ‖(phi a (circleMap 0 1 θ))⁻¹ - (phi a (circleMap 0 1 ψ))⁻¹‖
      ≤ 2 * Real.exp 5177 := by
    calc ‖(phi a (circleMap 0 1 θ))⁻¹ - (phi a (circleMap 0 1 ψ))⁻¹‖
        ≤ ‖(phi a (circleMap 0 1 θ))⁻¹‖ + ‖(phi a (circleMap 0 1 ψ))⁻¹‖ := norm_sub_le _ _
      _ ≤ Real.exp 5177 + Real.exp 5177 := add_le_add (hb θ) (hb ψ)
      _ = 2 * Real.exp 5177 := by ring
  have hlog2 : Real.log 2 ≤ 1 := by
    have := Real.log_le_sub_one_of_pos (x := (2 : ℝ)) (by norm_num)
    linarith
  rcases eq_or_lt_of_le (norm_nonneg ((phi a (circleMap 0 1 θ))⁻¹
      - (phi a (circleMap 0 1 ψ))⁻¹)) with hzero | hpos
  · rw [← hzero]; norm_num
  · have := Real.log_le_log hpos hsub
    rw [Real.log_mul (by norm_num) (Real.exp_ne_zero _), Real.log_exp] at this
    linarith

end Zeta5.Hauptmodul
