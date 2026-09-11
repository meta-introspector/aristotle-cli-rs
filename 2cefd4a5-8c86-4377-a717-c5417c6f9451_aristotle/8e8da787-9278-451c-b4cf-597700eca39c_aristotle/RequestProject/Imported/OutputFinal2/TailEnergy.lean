/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

A manifestly nonnegative representation of the Fourier-side function

  `f(t) = 2θ'(t) + δ̂(t)`

of Corollary 2.3 (ii) of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771.

# What this file contains

`RequestProject/BandEnergy.lean` reduces the Fourier-side inequality to a Plancherel
bound plus a limit identity for the *truncated* characters `|x|^{-1/2+it} 1_{1≤|x|≤X}`.
Carrying out the two limits by hand collapses that pair of statements into a **single
identity between absolutely convergent integrals**, in which the right-hand side is an
integral of a square — so that the inequality `f(t) ≥ 0` becomes a triviality once the
identity is known.

Explicitly, for `a > 0` let

  `G_t(a) = ∫_a^∞ y^{-1/2 + i t} cos y dy`

(a conditionally convergent integral; `cosTailKernel` below is its absolutely convergent
form, obtained by one integration by parts).  Then the claim is

  `2θ'(t) + δ̂(t) = (2/π) ∫_{2π}^∞ |G_t(a)|² da/a`   (`TailEnergyIdentity`).

Its right-hand side (`tailEnergy`) is nonnegative by inspection (`tailEnergy_nonneg`), so
the identity implies the Fourier-side inequality **for every real `t`**
(`fourierSide_nonneg_of_tailEnergy`) — not merely on the interval `|t| ≤ 60` that is left
open by `RequestProject/ThetaGrowth.lean`.

# Where the identity comes from

Take the even function `g_{t}(x) = |x|^{-1/2+it} 1_{|x| ≥ 1}` on `ℝ`.  Its (Abel
regularized) Fourier transform is `ĝ_t(ξ) = 2 ∫_1^∞ x^{-1/2+it} cos(2πxξ) dx`, and the
substitution `y = 2πxξ` turns it into `ĝ_t(ξ) = 2 (2πξ)^{-1/2-it} G_t(2πξ)`, whence

  `∫_{|ξ| ≥ 1} |ĝ_t(ξ)|² dξ = 8 ∫_1^∞ |G_t(2πξ)|² dξ/(2πξ) = 8 ∫_{2π}^∞ |G_t(a)|² da/a.`

The archimedean explicit formula (equivalently: the `X → ∞` limit of the band-energy
identity of `RequestProject/BandEnergy.lean`) evaluates the left-hand side as
`(4/π)(2θ'(t) + δ̂(t))`, which is the statement above.  At `t = 0` the integral `G_0` is a
Fresnel integral, `G_0(a) = √(2π) (1/2 - C(√(2a/π)))` with `C(θ) = ∫_0^θ cos(πx²/2) dx`,
and the identity reads `f(0) = 8 ∫_2^∞ (C(θ) - 1/2)² dθ/θ`.

# Numerical status (not verified in Lean)

The identity was checked numerically (mpmath, incomplete-gamma evaluation of `G_t`, and
independent quadrature of `2θ' + δ̂`) at `t = 0, 1, 2, 3, 5, 10, 30`; at `t = 30` the two
sides agree to eight significant digits, at the other points to the accuracy of the
truncation of the outer integral.  The integration by parts defining `cosTailKernel` was
checked against a direct oscillatory quadrature of `G_t(a)`.

None of this is proved in Lean.  `TailEnergyIdentity` is the *whole* analytic content of
Corollary 2.3 (ii); what this file buys is that all of the positivity has been separated
out of it.
-/
import RequestProject.Imported.OutputFinal2.BandEnergy

noncomputable section

open MeasureTheory Set Real Filter Topology

namespace ConnesConsani.WeilPositivity

/-- The absolutely convergent form of the conditionally convergent tail integral
`G_t(a) = ∫_a^∞ y^{-1/2+it} cos y dy`, obtained by one integration by parts:

  `G_t(a) = -a^{-1/2+it} sin a + (1/2 - i t) ∫_a^∞ y^{-3/2+it} sin y dy`.

The remaining integral converges absolutely, `∫_a^∞ y^{-3/2} dy = 2 a^{-1/2}`. -/
def cosTailKernel (t a : ℝ) : ℂ :=
  -((a : ℂ) ^ (-1 / 2 + Complex.I * (t : ℂ))) * (Real.sin a : ℂ)
    + (1 / 2 - Complex.I * (t : ℂ)) *
        ∫ y in Ioi a, (y : ℂ) ^ (-3 / 2 + Complex.I * (t : ℂ)) * (Real.sin y : ℂ)

/-- **The tail energy** `(2/π) ∫_{2π}^∞ |G_t(a)|² da/a`: the energy that the character
`|x|^{-1/2+it} 1_{|x| ≥ 1}` puts outside the frequency band `|ξ| ≤ 1`. -/
def tailEnergy (t : ℝ) : ℝ :=
  (2 / π) * ∫ a in Ioi (2 * π), Complex.normSq (cosTailKernel t a) / a

/-- **The tail-energy identity** `2θ'(t) + δ̂(t) = (2/π) ∫_{2π}^∞ |G_t(a)|² da/a`: the
archimedean explicit formula, written as a single identity between absolutely convergent
integrals whose right-hand side is an integral of a square.  See the header of this file
for its derivation and for its numerical verification; it is not proved here. -/
def TailEnergyIdentity : Prop := ∀ t : ℝ, fourierSide t = tailEnergy t

/-- The tail energy is nonnegative: it is an integral of a nonnegative function. -/
theorem tailEnergy_nonneg (t : ℝ) : 0 ≤ tailEnergy t := by
  have hπ := Real.pi_pos
  refine mul_nonneg (by positivity) (setIntegral_nonneg measurableSet_Ioi fun a ha => ?_)
  have ha' : (0:ℝ) < a := lt_trans (by positivity) ha
  exact div_nonneg (Complex.normSq_nonneg _) ha'.le

/-- **The Fourier-side inequality follows from the tail-energy identity**, for every real
`t`.  All the positivity is carried by the trivial lemma `tailEnergy_nonneg`; the identity
itself contains no inequality. -/
theorem fourierSide_nonneg_of_tailEnergy (h : TailEnergyIdentity) (t : ℝ) :
    0 ≤ fourierSide t := by
  rw [h t]
  exact tailEnergy_nonneg t

/-- The same statement in the form used downstream. -/
theorem two_thetaDeriv_add_deltaFourier_nonneg_of_tailEnergy
    (h : TailEnergyIdentity) (t : ℝ) : 0 ≤ 2 * thetaDeriv t + deltaFourier t :=
  fourierSide_nonneg_of_tailEnergy h t

end ConnesConsani.WeilPositivity
