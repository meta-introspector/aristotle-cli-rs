/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Companion effort: arithmetic holonomy certificate for `ζ_5(3)`.
-/
import Mathlib
import RequestProject.Imported.OutputFinal.Zeta5.Template
import RequestProject.Imported.OutputFinal.Zeta5.BostCharles
import RequestProject.Imported.OutputFinal.Zeta5.Radius
import RequestProject.Imported.OutputFinal.Zeta5.DenomType
import RequestProject.Imported.OutputFinal.Zeta5.HauptmodulBC

/-!
# The assembled certificate

This file collects the ingredients that are actually established in `Zeta5/`.

* **Task 1** (`Zeta5.psi_norm_isGreatest`, `Zeta5.template_log_max_lt`): for the
  *internal* template `ψ` of `Zeta5/Template.lean`, the max-modulus on the unit
  circle is computed exactly,
  `max_{|z|=1} |ψ(z)| = 378150244155138145169182750209 / 5^45`, hence
  `max_{|z|=1} log|ψ(z)| < -4 < 0`.
* **Task 2** (`Zeta5.BC_eq_log_25`, `Zeta5.BC_gt`, `Zeta5.BC_lt`): the Jensen
  evaluation of the Bost–Charles integral of `φ(z) = (5 − z)²`,
  `BC(φ) = log 25 = 2 log 5`, certified to lie in `(3.2188, 3.219)`.
* **Task 3** (`Zeta5.denomType_bseq`): the denominator type of the coefficient
  sequence is `τ(b) = 45/16`, conditional on the Chebyshev/PNT hypothesis
  `ChebyshevPNT` (carried as an explicit hypothesis, never as an axiom).
* **Task 4** (`Zeta5.overconv_radius_bseq`): the `5`-adic overconvergence radius
  is exactly `R₅ = 5³`, unconditionally.
* **Task 5** (`Zeta5.Hauptmodul.BC_phi_eq`): the Bost–Charles integral of the
  *genuine* auxiliary map `φ = t ∘ ψ`, where `t = (η(τ)/η(5τ))^6` is the
  Hauptmodul of `X₀(5)` in the nome and `ψ` is the published template,
  `0.53128915 < BC(φ) < 0.53128917`.  This too is an exact evaluation (Jensen
  for each product factor, plus term-by-term integration), uniform over all
  coefficient data agreeing with the printed decimals to within `10⁻⁹`.

These five are what `zeta5_certificate` asserts.  Conjunct 5 is an *evaluated
integral*, not a comparison: no cost/budget inequality is claimed anywhere.

## Honesty note: `archCostGuess` is *not* the published cost functional

An earlier version of this file defined

`cost = BC(φ) + max_{|z|=1} log‖ψ‖`

and compared it with the number `3.23494`, presenting the comparison as if it
were the criterion of the paper.  **It is not**, and the quantity has been
renamed `archCostGuess` to make that plain.  Two independent reasons:

* the denominator type `τ` never enters this combination, whereas the published
  arithmetic-holonomy criterion weighs the archimedean data against the
  denominator type (and the `p`-adic radius); a "criterion" in which `τ = 45/16`
  plays no role cannot be the published one;
* the template contribution has the wrong scaling.  `max log‖ψ‖` for the
  internal `ψ` is `≈ −4.32` purely because of the normalising factor `5^{-45}`;
  rescaling `ψ` by a constant shifts this term by an arbitrary amount while
  changing nothing arithmetically.  A genuine cost functional is invariant under
  the corresponding renormalisations; this sum is not.

Accordingly `archCostGuess_lt_budgetInput` below is retained only as a record of
the comparison that was previously made; **no criterion is claimed of it**, and
it is deliberately not part of `zeta5_certificate`.

`budgetInput = 3.23494` is likewise an external number, quoted, not derived.

For the *published* 41-coefficient template `ψ(z) = z·exp(Σ_{k≤40} c_k z^k)` see
the separate module `Zeta5/PublishedTemplate.lean`, which proves a certified
admissibility bound for it (with the rounding of the printed decimals propagated
through), and claims nothing else.
-/

namespace Zeta5

open Filter Topology

/-- The number `3.23494` quoted for the `p = 5` argument.  **External input**:
it is not derived here, and (see the module docstring) the quantity compared
with it below is *not* the published cost functional. -/
def budgetInput : ℝ := 3.23494

/-- A *guess* at an archimedean cost: the Bost–Charles integral of `φ` plus the
maximum of `log |ψ|` on the unit circle, for the internal template `ψ`.

**This is not the published cost functional.**  The denominator type never
enters it, and the template term has the wrong scaling (see the module
docstring).  The definition is kept only so that the comparison recorded in
`archCostGuess_lt_budgetInput` remains reproducible. -/
noncomputable def archCostGuess : ℝ := BC + Real.log (tmplL1 : ℝ)

/-- The certified Bost–Charles integral is smaller than the external number
`budgetInput`, with a margin of more than `0.015`.  A comparison of two numbers,
not a criterion. -/
theorem BC_lt_budgetInput : BC < budgetInput := by
  have := BC_lt
  rw [budgetInput]
  linarith

theorem BC_budgetInput_margin : (0.015 : ℝ) < budgetInput - BC := by
  have := BC_lt
  rw [budgetInput]
  linarith

/-- The demoted comparison: `archCostGuess < budgetInput`, with margin `> 4`.

**Not a criterion.**  See the module docstring: the combination
`BC + log‖ψ‖_∞` is not the published cost functional. -/
theorem archCostGuess_lt_budgetInput : archCostGuess < budgetInput := by
  have h1 := BC_lt
  have h2 := template_log_max_lt
  rw [archCostGuess, budgetInput]
  linarith

theorem archCostGuess_budgetInput_margin : (4 : ℝ) < budgetInput - archCostGuess := by
  have h1 := BC_lt
  have h2 := template_log_max_lt
  rw [archCostGuess, budgetInput]
  linarith

/-- **The certificate.**  The five ingredients that are actually established:

1. exact template max-modulus for the internal `ψ`;
2. Jensen evaluation of `BC(φ)` for `φ(z) = (5 − z)²`;
3. denominator type `τ = 45/16`, conditional on the PNT hypothesis;
4. exact `5`-adic radius `R₅ = 5³`;
5. the exact Bost–Charles integral of the genuine Hauptmodul composition
   `φ = t ∘ ψ`.

The only hypothesis is the Chebyshev/prime-number-theorem asymptotic used for
the denominator type; conjuncts 1, 2, 4 and 5 are unconditional.

No comparison with an arithmetic budget is asserted here, and nothing about
`ζ_5(3)` is claimed: the arithmetic holonomicity theorem is not formalised. -/
theorem zeta5_certificate (hPNT : ChebyshevPNT) :
    -- 1. exact template max-modulus (internal `ψ`): the maximum of `|ψ|` on the
    --    unit circle is attained, and `log` of it is `< -4 < 0`
    IsGreatest {r : ℝ | ∃ z : ℂ, ‖z‖ = 1 ∧ r = ‖psi z‖} (tmplL1 : ℝ) ∧
      Real.log (tmplL1 : ℝ) < -4 ∧
    -- 2. Jensen evaluation of the Bost–Charles integral of `φ(z) = (5 − z)²`
    BC = Real.log 25 ∧ (3.2188 : ℝ) < BC ∧ BC < 3.219 ∧
    -- 3. denominator type, conditional on `hPNT`
    DenomType bseq (45 / 16) ∧
    -- 4. exact 5-adic overconvergence radius
    IsOverconvRadius5 bseq (5 ^ 3) ∧
    -- 5. the Bost–Charles integral of the Hauptmodul composition `φ = t ∘ ψ`
    (∀ a : ℕ → ℝ, Published.Approximates a →
      (0.53128915 : ℝ) < Real.circleAverage (Hauptmodul.logPhi a) 0 1 ∧
        Real.circleAverage (Hauptmodul.logPhi a) 0 1 < (0.53128917 : ℝ)) :=
  ⟨psi_norm_isGreatest, template_log_max_lt, BC_eq_log_25, BC_gt, BC_lt,
    denomType_bseq hPNT, overconv_radius_bseq, fun _a ha => Hauptmodul.BC_phi_eq ha⟩

end Zeta5
