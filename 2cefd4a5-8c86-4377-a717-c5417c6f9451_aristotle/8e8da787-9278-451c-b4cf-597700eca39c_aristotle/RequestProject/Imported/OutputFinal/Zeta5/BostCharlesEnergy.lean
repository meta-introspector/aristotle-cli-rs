/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Companion effort: arithmetic holonomy certificate for `ζ_5(3)`.
-/
import Mathlib
import RequestProject.Imported.OutputFinal.Zeta5.HauptmodulBC
import RequestProject.Imported.OutputFinal.Zeta5.EtaQuotient
import RequestProject.Imported.OutputFinal.Zeta5.LogBounds

/-!
# The paper's functionals: pairwise energy `BC`, `cost` and `budget`

The quantity evaluated in `Zeta5/HauptmodulBC.lean` is the **Jensen mean**

```
(1/2π) ∫₀^{2π} log‖φ(e^{iθ})‖ dθ = circleAverage (logPhi a) 0 1 = −c₀ ≈ 0.5313 .
```

The draft's `BC(φ)` is a *different* functional: the **pairwise (logarithmic)
energy** of the boundary curve,

```
BC(φ) = (1/4π²) ∫₀^{2π} ∫₀^{2π} log‖φ(e^{iθ}) − φ(e^{iψ})‖ dψ dθ ,
```

a double integral over the circle against itself.  This module records the two
paper-side definitions

```
cost(φ)  = BC(φ) − 4 c₀ ,        budget = 3 (3 log 5 − 4 + 1/4) ,
```

and proves the elementary facts about them that need no quadrature:

* `paperBudget_eq`, `paperBudget_gt`, `paperBudget_lt`: `budget = 9 log 5 − 45/4`
  lies in `(3.2346, 3.2355)`, from the certified `log 5` enclosure of
  `Zeta5/LogBounds.lean`;
* `paperCost_eq`, `paperCost_eq_add_jensenMean`: the cost is the pairwise energy
  corrected by `−4c₀ = +4·(Jensen mean of log‖φ‖)`;
* `phi_eq_etaQuotient` / `inv_phi_eq_etaQuotient_inv`: the composed map
  `φ = t ∘ ψ` and its reciprocal are the eta quotients `(η(τ)/η(5τ))^6` and
  `(η(5τ)/η(τ))^6` evaluated at any `τ` in the upper half plane whose nome is
  `ψ(z)`.

It also proves the exact **reciprocal relation**
`BC(1/F) = BC(F) − 2·(Jensen mean of log‖F‖)` (`pairwiseEnergy_inv`, under
explicit integrability hypotheses), which distinguishes the two normalisations
`t ∘ ψ` and `(1/t) ∘ ψ` of the Hauptmodul composition: their pairwise energies
differ by `2c₀ ≈ 1.0626`, whereas their Jensen means merely change sign.

## What is *not* claimed here

Neither `pairwiseEnergy (phi a)` nor `pairwiseEnergy (1/phi a)` is evaluated or
bounded.  Uncertified quadrature suggests `BC(φ) ≈ 2.0981` and hence
`BC(1/φ) ≈ 1.0355` — the latter being the number printed in the draft, which
therefore refers to the reciprocal normalisation; with `−4c₀ ≈ 2.1252` this
would give `cost ≈ 3.1607`, below `budget ≈ 3.2349`.  **No such inequality is
asserted**: no certified bound for either double integral exists in this
development, a floating-point quadrature is not a proof, and nothing here bears
on `ζ_5(3) ∉ ℚ`.  The conjuncts of `Zeta5.zeta5_certificate` are untouched by
this module.
-/

namespace Zeta5.Hauptmodul

open Real MeasureTheory Set

/-! ## The pairwise energy -/

/-- The **pairwise logarithmic energy** of the boundary values of `f` on the unit
circle,

`BC(f) = (1/4π²) ∫∫ log‖f(e^{iθ}) − f(e^{iψ})‖ dθ dψ`.

This is the draft's `BC`, and it differs from the Jensen mean
`(1/2π) ∫ log‖f‖` computed in `Zeta5/HauptmodulBC.lean`. -/
noncomputable def pairwiseEnergy (f : ℂ → ℂ) : ℝ :=
  (∫ θ : ℝ, (∫ ψ : ℝ,
      Real.log ‖f (circleMap 0 1 θ) - f (circleMap 0 1 ψ)‖
      ∂(volume.restrict (Icc 0 (2 * π))))
    ∂(volume.restrict (Icc 0 (2 * π)))) / (4 * π ^ 2)

/-- The draft's archimedean cost, `cost(φ) = BC(φ) − 4c₀`, where `c₀ = a 0` is
the constant coefficient of `log(ψ(z)/z)` — equivalently (see
`paperCost_eq_add_jensenMean`) the *negative* of the Jensen mean of `log‖φ‖`. -/
noncomputable def paperCost (a : ℕ → ℝ) : ℝ :=
  pairwiseEnergy (phi a) - 4 * (a 0)

/-- The draft's budget, `3 (3 log 5 − 4 + 1/4)`. -/
noncomputable def paperBudget : ℝ := 3 * (3 * Real.log 5 - 4 + 1 / 4)

/-! ## Elementary identities and enclosures -/

theorem paperCost_eq (a : ℕ → ℝ) :
    paperCost a = pairwiseEnergy (phi a) - 4 * a 0 := rfl

/-- The Jensen mean of `log‖φ‖` is `−c₀` (`circleAverage_logPhi`), so the cost is
the pairwise energy *plus* four times the Jensen mean. -/
theorem paperCost_eq_add_jensenMean {a : ℕ → ℝ} (h : Published.Approximates a) :
    paperCost a = pairwiseEnergy (phi a) + 4 * circleAverage (logPhi a) 0 1 := by
  rw [paperCost, circleAverage_logPhi h]; ring

/-- For the published data the correction term is pinned down: `−4c₀` lies in
`(2.12515, 2.12516)`. -/
theorem four_c_zero_enclosure {a : ℕ → ℝ} (h : Published.Approximates a) :
    (2.12515 : ℝ) < -4 * a 0 ∧ -4 * a 0 < (2.12516 : ℝ) := by
  have h0 := abs_le.1 (h 0)
  have hpub : ((Published.pubC 0 : ℚ) : ℝ) = -531289158 / 1000000000 := by
    norm_num [Published.pubC]
  have hround : ((Published.roundErr : ℚ) : ℝ) = 1 / 1000000000 := by
    norm_num [Published.roundErr]
  rw [hpub, hround] at h0
  constructor <;> [linarith [h0.2]; linarith [h0.1]]

theorem paperBudget_eq : paperBudget = 9 * Real.log 5 - 45 / 4 := by
  rw [paperBudget]; ring

theorem paperBudget_gt : (3.2346 : ℝ) < paperBudget := by
  have := log_five_gt
  rw [paperBudget_eq]; linarith

theorem paperBudget_lt : paperBudget < (3.2355 : ℝ) := by
  have := log_five_lt
  rw [paperBudget_eq]; linarith

/-- The quoted number `3.23494` is the budget, to five decimals: this is where
that external constant comes from. -/
theorem abs_paperBudget_sub_quoted_lt : |paperBudget - 3.23494| < (0.0006 : ℝ) := by
  have h1 := paperBudget_gt
  have h2 := paperBudget_lt
  rw [abs_lt]
  constructor <;> linarith

/-! ## `φ` and the eta quotient

`Zeta5/EtaQuotient.lean` proves `(η(τ)/η(5τ))^6 = t(q)` with `q = e^{2πiτ}`.
Composing with the template gives the two normalisations of `φ`. -/

/-- If `τ` lies in the upper half plane and its nome is `ψ(z)`, then
`φ(z) = (η(τ)/η(5τ))^6`. -/
theorem phi_eq_etaQuotient (a : ℕ → ℝ) {z τ : ℂ} (hτ : 0 < τ.im)
    (hnome : nome τ = Published.psi a z) :
    phi a z = (dedekindEta τ / dedekindEta (5 * τ)) ^ 6 := by
  rw [etaQuotient_eq_hauptmodul hτ, hnome, phi]

/-- The reciprocal normalisation: `1/φ(z) = (η(5τ)/η(τ))^6`. -/
theorem inv_phi_eq_etaQuotient_inv (a : ℕ → ℝ) {z τ : ℂ} (hτ : 0 < τ.im)
    (hnome : nome τ = Published.psi a z) :
    (phi a z)⁻¹ = (dedekindEta (5 * τ) / dedekindEta τ) ^ 6 := by
  have h5 : (0 : ℝ) < (5 * τ).im := by
    simp only [Complex.mul_im, Complex.re_ofNat, Complex.im_ofNat]
    nlinarith
  rw [phi_eq_etaQuotient a hτ hnome, ← inv_pow, inv_div]

/-- The two normalisations have opposite pairwise-energy-relevant Jensen means:
`BC_jensen(1/φ) = +c₀ = −BC_jensen(φ)`. -/
theorem jensenMean_phi_inv_eq_neg {a : ℕ → ℝ} (h : Published.Approximates a) :
    circleAverage (fun z => -logPhi a z) 0 1 = -circleAverage (logPhi a) 0 1 := by
  rw [circleAverage_logPhi h, circleAverage_logPhi_inv h]; ring

/-! ## The reciprocal normalisation, and where the draft's `1.0355` comes from

`log‖A⁻¹ − B⁻¹‖ = log‖A − B‖ − log‖A‖ − log‖B‖`, so the pairwise energies of a
function and of its reciprocal differ by twice the Jensen mean.  This is the
precise sense in which the two normalisations `t ∘ ψ` and `(1/t) ∘ ψ` of the
Hauptmodul composition have *different* pairwise energies (unlike their Jensen
means, which merely change sign). -/

/-- Pointwise: `log‖A⁻¹ − B⁻¹‖ = log‖A − B‖ − log‖A‖ − log‖B‖` for nonzero,
distinct `A`, `B`. -/
theorem log_norm_inv_sub_inv {A B : ℂ} (hA : A ≠ 0) (hB : B ≠ 0) (hAB : A ≠ B) :
    Real.log ‖A⁻¹ - B⁻¹‖ = Real.log ‖A - B‖ - Real.log ‖A‖ - Real.log ‖B‖ := by
  have hkey : A⁻¹ - B⁻¹ = (B - A) / (A * B) := by
    field_simp
  rw [hkey, norm_div, norm_mul, Real.log_div (by simpa [sub_eq_zero] using (Ne.symm hAB))
      (by positivity), Real.log_mul (by positivity) (by positivity), norm_sub_rev]
  ring

/-- **The reciprocal relation.**  `BC(1/F) = BC(F) − 2·(Jensen mean of log‖F‖)`.

The hypotheses are exactly what makes the splitting legitimate: `F` is nonzero
along the circle, its boundary values are a.e. pairwise distinct, the double
integrand is integrable on the torus and `log‖F‖` is integrable on the circle. -/
theorem pairwiseEnergy_inv (F : ℂ → ℂ)
    (hne : ∀ θ : ℝ, F (circleMap 0 1 θ) ≠ 0)
    (hlevel : ∀ θ : ℝ, ∀ᵐ ψ ∂(volume.restrict (Icc 0 (2 * π))),
      F (circleMap 0 1 θ) ≠ F (circleMap 0 1 ψ))
    (hA : Integrable
      (fun p : ℝ × ℝ => Real.log ‖F (circleMap 0 1 p.1) - F (circleMap 0 1 p.2)‖)
      ((volume.restrict (Icc 0 (2 * π))).prod (volume.restrict (Icc 0 (2 * π)))))
    (hB : IntegrableOn (fun θ : ℝ => Real.log ‖F (circleMap 0 1 θ)‖) (Icc 0 (2 * π))) :
    pairwiseEnergy (fun z => (F z)⁻¹)
      = pairwiseEnergy F - 2 * circleAverage (fun z => Real.log ‖F z‖) 0 1 := by
  have hpi : (0 : ℝ) < π := Real.pi_pos
  set μ : Measure ℝ := volume.restrict (Icc (0 : ℝ) (2 * π)) with hμdef
  have hμuniv : μ.real Set.univ = 2 * π := by
    rw [hμdef, measureReal_def, Measure.restrict_apply_univ, Real.volume_Icc]
    simp [hpi.le]
  haveI : IsFiniteMeasure μ := by
    constructor
    rw [hμdef, Measure.restrict_apply_univ, Real.volume_Icc]
    exact ENNReal.ofReal_lt_top
  set J : ℝ := ∫ ψ : ℝ, Real.log ‖F (circleMap 0 1 ψ)‖ ∂μ with hJdef
  -- the inner integral, for a.e. `θ`
  have hinner : ∀ᵐ θ ∂μ,
      (∫ ψ : ℝ, Real.log ‖(F (circleMap 0 1 θ))⁻¹ - (F (circleMap 0 1 ψ))⁻¹‖ ∂μ)
        = (∫ ψ : ℝ, Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖ ∂μ)
          - (2 * π) * Real.log ‖F (circleMap 0 1 θ)‖ - J := by
    filter_upwards [hA.prod_right_ae] with θ hθ
    have hcongr : (∫ ψ : ℝ, Real.log ‖(F (circleMap 0 1 θ))⁻¹ - (F (circleMap 0 1 ψ))⁻¹‖ ∂μ)
        = ∫ ψ : ℝ, (Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖
            - Real.log ‖F (circleMap 0 1 θ)‖ - Real.log ‖F (circleMap 0 1 ψ)‖) ∂μ := by
      refine integral_congr_ae ?_
      filter_upwards [hlevel θ] with ψ hψ
      exact log_norm_inv_sub_inv (hne θ) (hne ψ) hψ
    have e1 : (∫ ψ : ℝ, (Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖
          - Real.log ‖F (circleMap 0 1 θ)‖ - Real.log ‖F (circleMap 0 1 ψ)‖) ∂μ)
        = (∫ ψ : ℝ, (Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖
            - Real.log ‖F (circleMap 0 1 θ)‖) ∂μ)
          - ∫ ψ : ℝ, Real.log ‖F (circleMap 0 1 ψ)‖ ∂μ :=
      integral_sub (hθ.sub (integrable_const _)) hB
    have e2 : (∫ ψ : ℝ, (Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖
          - Real.log ‖F (circleMap 0 1 θ)‖) ∂μ)
        = (∫ ψ : ℝ, Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖ ∂μ)
          - ∫ _ψ : ℝ, Real.log ‖F (circleMap 0 1 θ)‖ ∂μ :=
      integral_sub hθ (integrable_const _)
    rw [hcongr, e1, e2, integral_const, hμuniv, ← hJdef]
    simp [smul_eq_mul]
  have houter : (∫ θ : ℝ, ∫ ψ : ℝ,
        Real.log ‖(F (circleMap 0 1 θ))⁻¹ - (F (circleMap 0 1 ψ))⁻¹‖ ∂μ ∂μ)
      = (∫ θ : ℝ, ∫ ψ : ℝ, Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖ ∂μ ∂μ)
        - 4 * π * J := by
    have hI : Integrable
        (fun θ : ℝ => ∫ ψ : ℝ, Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖ ∂μ) μ :=
      hA.integral_prod_left
    have e1 : (∫ θ : ℝ, ((∫ ψ : ℝ, Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖ ∂μ)
          - (2 * π) * Real.log ‖F (circleMap 0 1 θ)‖ - J) ∂μ)
        = (∫ θ : ℝ, ((∫ ψ : ℝ, Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖ ∂μ)
            - (2 * π) * Real.log ‖F (circleMap 0 1 θ)‖) ∂μ) - ∫ _θ : ℝ, J ∂μ :=
      integral_sub (hI.sub (hB.const_mul (2 * π))) (integrable_const _)
    have e2 : (∫ θ : ℝ, ((∫ ψ : ℝ, Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖ ∂μ)
          - (2 * π) * Real.log ‖F (circleMap 0 1 θ)‖) ∂μ)
        = (∫ θ : ℝ, (∫ ψ : ℝ, Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖ ∂μ) ∂μ)
          - ∫ θ : ℝ, (2 * π) * Real.log ‖F (circleMap 0 1 θ)‖ ∂μ :=
      integral_sub hI (hB.const_mul (2 * π))
    rw [integral_congr_ae hinner, e1, e2, integral_const, hμuniv, integral_const_mul, ← hJdef]
    simp only [smul_eq_mul]
    ring
  -- the Jensen mean
  have hcircle : circleAverage (fun z => Real.log ‖F z‖) 0 1 = (2 * π)⁻¹ * J := by
    rw [Real.circleAverage_def, hJdef, hμdef, integral_Icc_eq_integral_Ioc,
      intervalIntegral.integral_of_le (by positivity)]
    simp [smul_eq_mul]
  rw [pairwiseEnergy, pairwiseEnergy, ← hμdef, houter, hcircle]
  field_simp

/-- `t(q) ≠ 0` on the punctured disc, so the reciprocal composition is defined. -/
theorem hauptmodul_ne_zero {q : ℂ} (hq0 : q ≠ 0) (hq : ‖q‖ < 1) : hauptmodul q ≠ 0 := by
  rw [hauptmodul, tprod_etaFactor hq]
  exact mul_ne_zero (inv_ne_zero hq0) (Complex.exp_ne_zero _)

theorem phi_ne_zero_circle {a : ℕ → ℝ} (h : Published.Approximates a) (θ : ℝ) :
    phi a (circleMap 0 1 θ) ≠ 0 :=
  hauptmodul_ne_zero (psi_ne_zero a (circleMap_one_ne_zero θ))
    (norm_psi_lt_one_of_le_one h (le_of_eq (norm_circleMap_one θ)))

/-- The Jensen mean of `log‖φ‖` along the circle, in the form needed above. -/
theorem circleAverage_log_norm_phi {a : ℕ → ℝ} (h : Published.Approximates a) :
    circleAverage (fun z => Real.log ‖phi a z‖) 0 1 = -a 0 := by
  have hpt : ∀ θ : ℝ, Real.log ‖phi a (circleMap 0 1 θ)‖ = logPhi a (circleMap 0 1 θ) := by
    intro θ
    exact log_norm_phi h (circleMap_one_ne_zero θ) (le_of_eq (norm_circleMap_one θ))
  rw [Real.circleAverage_def]
  simp only [hpt]
  rw [← Real.circleAverage_def, circleAverage_logPhi h]

/-- **The two normalisations of the Hauptmodul composition.**  The reciprocal
composition `(1/t) ∘ ψ` — the eta quotient `(η(5τ)/η(τ))^6` composed with the
template — has pairwise energy `BC(φ) + 2c₀`, i.e. smaller by `2·0.53128…`.

This is where the draft's numerical value comes from: an (uncertified) quadrature
gives `BC(t ∘ ψ) ≈ 2.0981`, hence `BC((1/t) ∘ ψ) ≈ 2.0981 − 1.0626 = 1.0355`,
the number printed in the draft.  Neither value is proved here. -/
theorem pairwiseEnergy_phi_inv {a : ℕ → ℝ} (h : Published.Approximates a)
    (hlevel : ∀ θ : ℝ, ∀ᵐ ψ ∂(volume.restrict (Icc 0 (2 * π))),
      phi a (circleMap 0 1 θ) ≠ phi a (circleMap 0 1 ψ))
    (hA : Integrable
      (fun p : ℝ × ℝ => Real.log ‖phi a (circleMap 0 1 p.1) - phi a (circleMap 0 1 p.2)‖)
      ((volume.restrict (Icc 0 (2 * π))).prod (volume.restrict (Icc 0 (2 * π)))))
    (hB : IntegrableOn (fun θ : ℝ => Real.log ‖phi a (circleMap 0 1 θ)‖) (Icc 0 (2 * π))) :
    pairwiseEnergy (fun z => (phi a z)⁻¹) = pairwiseEnergy (phi a) + 2 * a 0 := by
  rw [pairwiseEnergy_inv (phi a) (phi_ne_zero_circle h) hlevel hA hB,
    circleAverage_log_norm_phi h]
  ring

/-- The cost of the **reciprocal** normalisation, `cost((1/t) ∘ ψ) = BC(1/φ) − 4c₀`.
Uncertified quadrature identifies this, rather than `paperCost`, as the quantity
of the draft: `BC(1/φ) ≈ 1.0355`, `−4c₀ ≈ 2.1252`, total `≈ 3.1607`. -/
noncomputable def paperCostInv (a : ℕ → ℝ) : ℝ :=
  pairwiseEnergy (fun z => (phi a z)⁻¹) - 4 * (a 0)

/-- The two costs differ by `2c₀`. -/
theorem paperCostInv_eq {a : ℕ → ℝ} (h : Published.Approximates a)
    (hlevel : ∀ θ : ℝ, ∀ᵐ ψ ∂(volume.restrict (Icc 0 (2 * π))),
      phi a (circleMap 0 1 θ) ≠ phi a (circleMap 0 1 ψ))
    (hA : Integrable
      (fun p : ℝ × ℝ => Real.log ‖phi a (circleMap 0 1 p.1) - phi a (circleMap 0 1 p.2)‖)
      ((volume.restrict (Icc 0 (2 * π))).prod (volume.restrict (Icc 0 (2 * π)))))
    (hB : IntegrableOn (fun θ : ℝ => Real.log ‖phi a (circleMap 0 1 θ)‖) (Icc 0 (2 * π))) :
    paperCostInv a = paperCost a + 2 * a 0 := by
  rw [paperCostInv, paperCost, pairwiseEnergy_phi_inv h hlevel hA hB]
  ring

/-! ## First steps towards a certified bound

Two ingredients of the route sketched for a rigorous enclosure: the diagonal
singularity carries no mass (the pairwise energy of the identity vanishes), and
the energy is bounded by any uniform bound on the integrand. -/

/-- The inner integral of the diagonal singularity vanishes identically: for
every `θ`, `∫ log‖e^{iθ} − e^{iψ}‖ dψ = 0` over `[0, 2π]`. -/
theorem integral_log_norm_circleMap_sub_eq_zero (θ : ℝ) :
    (∫ ψ : ℝ, Real.log ‖circleMap 0 1 θ - circleMap 0 1 ψ‖
      ∂(volume.restrict (Icc (0 : ℝ) (2 * π)))) = 0 := by
  have hpi : (0 : ℝ) < π := Real.pi_pos
  have h := circleAverage_log_norm_sub_const₁ (a := circleMap 0 1 θ) (norm_circleMap_one θ)
  rw [Real.circleAverage_def, smul_eq_zero] at h
  have h2 : (∫ ψ : ℝ in (0 : ℝ)..(2 * π), Real.log ‖circleMap 0 1 ψ - circleMap 0 1 θ‖) = 0 := by
    rcases h with h | h
    · exact absurd h (by positivity)
    · exact h
  rw [integral_Icc_eq_integral_Ioc, ← intervalIntegral.integral_of_le (by positivity)]
  simpa [norm_sub_rev] using h2

/-- **The diagonal singularity is harmless**: the pairwise energy of the
identity map is `0`, i.e. `(1/4π²)∫∫ log‖e^{iθ} − e^{iψ}‖ = 0`.  This is the
fact that lets one factor `φ(z) − φ(w) = (z − w)·φ[z, w]` and work with the
regular divided difference. -/
theorem pairwiseEnergy_id : pairwiseEnergy (fun z => z) = 0 := by
  simp [pairwiseEnergy, integral_log_norm_circleMap_sub_eq_zero]

/-- A uniform bound on the integrand bounds the pairwise energy. -/
theorem pairwiseEnergy_le_of_le {F : ℂ → ℂ} {M : ℝ}
    (hA : Integrable
      (fun p : ℝ × ℝ => Real.log ‖F (circleMap 0 1 p.1) - F (circleMap 0 1 p.2)‖)
      ((volume.restrict (Icc 0 (2 * π))).prod (volume.restrict (Icc 0 (2 * π)))))
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
  have hI : Integrable
      (fun θ : ℝ => ∫ ψ : ℝ, Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖ ∂μ) μ :=
    hA.integral_prod_left
  have hinner : ∀ᵐ θ ∂μ,
      (∫ ψ : ℝ, Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖ ∂μ) ≤ (2 * π) * M := by
    filter_upwards [hA.prod_right_ae] with θ hθ
    have := integral_mono hθ (integrable_const M) (fun ψ => hbound θ ψ)
    rwa [integral_const, hμuniv, smul_eq_mul] at this
  have houter : (∫ θ : ℝ, ∫ ψ : ℝ, Real.log ‖F (circleMap 0 1 θ) - F (circleMap 0 1 ψ)‖ ∂μ ∂μ)
      ≤ (2 * π) * ((2 * π) * M) := by
    have := integral_mono_ae hI (integrable_const ((2 * π) * M)) hinner
    rwa [integral_const, hμuniv, smul_eq_mul] at this
  rw [pairwiseEnergy, ← hμdef, div_le_iff₀ (by positivity)]
  nlinarith [houter, Real.pi_pos]

/-! ## The numerical target, recorded but not proved

The draft's value is `1.0355`, which uncertified quadrature matches to four
decimals for the **reciprocal** normalisation, `BC(1/φ)` (for `BC(φ)` itself the
same quadrature gives `≈ 2.0981`).  Were a certified enclosure available, the
cost bound would follow at once from `four_c_zero_enclosure`; the two lemmas
below record exactly that implication, with the enclosure left as a hypothesis.
They assert nothing about the actual value of either double integral. -/
/-- **Dead branch.**  The numerical hypothesis `B ≤ 1.109` implicit in `hBbudget`
is *false* for the non-reciprocal normalisation, where `BC(t ∘ ψ) ≈ 2.098`; only
the reciprocal (`Inv`) variant below can meet the budget. -/
theorem paperCost_lt_paperBudget_of_energy_bound {a : ℕ → ℝ}
    (h : Published.Approximates a) (B : ℝ) (hB : pairwiseEnergy (phi a) ≤ B)
    (hBbudget : B + 2.12516 ≤ 3.2346) :
    paperCost a < paperBudget := by
  have hc := four_c_zero_enclosure h
  have := paperBudget_gt
  rw [paperCost]
  linarith [hc.2]

theorem paperCostInv_lt_paperBudget_of_energy_bound {a : ℕ → ℝ}
    (h : Published.Approximates a) (B : ℝ)
    (hB : pairwiseEnergy (fun z => (phi a z)⁻¹) ≤ B)
    (hBbudget : B + 2.12516 ≤ 3.2346) :
    paperCostInv a < paperBudget := by
  have hc := four_c_zero_enclosure h
  have := paperBudget_gt
  rw [paperCostInv]
  linarith [hc.2]

end Zeta5.Hauptmodul
