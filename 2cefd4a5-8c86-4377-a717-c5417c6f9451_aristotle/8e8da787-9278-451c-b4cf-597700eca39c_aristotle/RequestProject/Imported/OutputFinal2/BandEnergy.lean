/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

A concrete, operator-free route to the Fourier-side inequality

  `f(t) = 2θ'(t) + δ̂(t) ≥ 0`

of Corollary 2.3 (ii) of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771.

# The idea

The paper obtains the inequality from the operator identity `L(f) = Tr(ϑ(f) P P̂ P)`, whose
formalization needs trace-class operators and the integrated scaling representation.  The
present file replaces that machinery by a completely explicit one-parameter family of
*ordinary Lebesgue integrals*.

For `X > 1` let `g_{t,X}` be the even function on `ℝ`

  `g_{t,X}(x) = |x|^{-1/2 + i t}` for `1 ≤ |x| ≤ X`,  `0` otherwise,

i.e. the truncation to the annulus `1 ≤ |x| ≤ X` of the character `|x|^{-1/2+it}` of the
scaling group.  Two elementary facts about it are:

* `‖g_{t,X}‖²_{L²(ℝ)} = 2 ∫₁^X dx/x = 2 log X`;
* its Fourier transform is the (proper) integral
  `ĝ_{t,X}(ξ) = 2 ∫₁^X x^{-1/2+it} cos(2πxξ) dx` (`truncTransform` below).

The *band energy* is the part of the energy of `ĝ` carried by the frequency band `|ξ| ≤ 1`:

  `A(t,X) = ∫_{-1}^{1} |ĝ_{t,X}(ξ)|² dξ`   (`bandEnergy`).

Plancherel's theorem gives at once the inequality

  `A(t,X) ≤ ‖ĝ‖²_{L²} = ‖g‖²_{L²} = 2 log X`   (`BandEnergyBound`),

i.e. the defect `2 log X - A(t,X)` — the energy left *outside* the band, which is the
Sonin/`(1-P)(1-P̂)(1-P)` part of the paper — is nonnegative.  The whole analytic content of
Corollary 2.3 (ii) is then the *identity*

  `lim_{X → ∞} (2 log X - A(t,X)) = 2 (2θ'(t) + δ̂(t))`   (`TraceLimitIdentity`),

and the inequality `f(t) ≥ 0` follows (`fourierSide_nonneg_of_bandEnergy`).

# Why the limit identity is the archimedean trace formula

Writing `x = e^{w+v/2}`, `y = e^{w-v/2}` and expanding `|ĝ|²` by Fubini (the frequency
domain `[-1,1]` is compact, so everything is absolutely convergent) one gets

  `A(t,X) = ∫_{-L}^{L} cos(tv) Λ(v,L) dv`,  `L = log X`,

with the *completely explicit* kernel (`Si` = sine integral)

  `Λ(v,L) = (1/π) [ (Si(4π sinh(v/2) e^{L-|v|/2}) - Si(2π(e^{|v|}-1))) / sinh(v/2)`
  `        + (Si(4π cosh(v/2) e^{L-|v|/2}) - Si(2π(e^{|v|}+1))) / cosh(v/2) ]`,

the `w`-integration having produced exactly a difference of two sine integrals.  Since
`2 sinh(v/2) = (ρ-1)/√ρ` and `2 cosh(v/2) = (ρ+1)/√ρ` for `ρ = e^{|v|}`, the two subtracted
terms are

  `(1/π) [ Si(2π(ρ-1)) 2√ρ/(ρ-1) + Si(2π(ρ+1)) 2√ρ/(ρ+1) ] = 2 δ(ρ)`

by formula (49) of the paper (`delta_explicit`).  So `Λ(v,L) = Ω(v,L) - 2 δ(e^{|v|})`, the
`δ`-part contributing `-2 δ̂(t)`, while the remaining part `Ω`, in which `Si(·) → π/2`,
contributes `2 log X - 4 θ'(t) + o(1)`: the principal value of the archimedean Weil kernel,
whose value is the digamma function.  This is the classical archimedean explicit formula,
here in a form that involves no operators at all.

# Numerical status (not verified in Lean)

At `t = 0` the two sides of the identity can be evaluated in closed form through the
Fresnel integral `C(θ) = ∫₀^θ cos(π x²/2) dx`:

  `δ̂(0) = 8 ∫₀² C(θ)(1 - C(θ)) dθ/θ = 5.42125408501616…`,
  `f(0) = 2θ'(0) + δ̂(0) = 8 ∫₂^∞ (C(θ) - 1/2)² dθ/θ = 0.04907066579…`,

the second being manifestly positive — it is the `t = 0` case of the identity above (the
Fresnel function appears because `ĝ_{0,∞}(ξ) = |ξ|^{-1/2} - 2 C(2√ξ)/√ξ`).  Both were
checked numerically to ten significant digits, together with the identity
`lim (2 log X - A(t,X)) = 2 f(t)` at `t = 0, 1, 2, 5`.  None of this is proved here.
-/
import RequestProject.Imported.OutputFinal2.FourierSideAnalysis

noncomputable section

open MeasureTheory Set Real Filter Topology

namespace ConnesConsani.WeilPositivity

/-- The Fourier transform of the truncated character
`g_{t,X}(x) = |x|^{-1/2+it} 1_{1 ≤ |x| ≤ X}`, namely
`ĝ_{t,X}(ξ) = 2 ∫₁^X x^{-1/2+it} cos(2πxξ) dx`. -/
def truncTransform (t X ξ : ℝ) : ℂ :=
  2 * ∫ x in (1:ℝ)..X,
    Complex.exp ((-1 / 2 + Complex.I * (t : ℂ)) * (Real.log x : ℂ)) * (Real.cos (2 * π * x * ξ) : ℂ)

/-- **The band energy** `A(t,X) = ∫_{-1}^{1} |ĝ_{t,X}(ξ)|² dξ`: the part of the energy of the
truncated character that is carried by the frequencies `|ξ| ≤ 1`. -/
def bandEnergy (t X : ℝ) : ℝ :=
  ∫ ξ in (-1:ℝ)..1, Complex.normSq (truncTransform t X ξ)

/-- **The Plancherel bound**: the energy inside the band `|ξ| ≤ 1` is at most the total
energy `‖g_{t,X}‖²_{L²} = 2 log X` of the truncated character.  This is Plancherel's theorem
for the explicit `L¹ ∩ L²` function `g_{t,X}`; equivalently, it says that convolution with
the Dirichlet kernel of `[-1,1]` is an orthogonal projection, hence a contraction. -/
def BandEnergyBound : Prop := ∀ t X : ℝ, 1 ≤ X → bandEnergy t X ≤ 2 * Real.log X

/-- **The trace limit identity**: the energy carried by the frequencies `|ξ| > 1` converges,
as the truncation is removed, to twice the Fourier-side function `f = 2θ' + δ̂`.  This is the
archimedean explicit formula (Corollary 2.3 of the paper) in an operator-free form: see the
header of this file for the derivation and for its numerical verification. -/
def TraceLimitIdentity : Prop := ∀ t : ℝ,
  Tendsto (fun X : ℝ => 2 * Real.log X - bandEnergy t X) atTop (𝓝 (2 * fourierSide t))

/-! ## The kernel of the band energy, and where `δ` comes from

The two-dimensional integral defining `A(t,X)`, written in the coordinates `v = log(x/y)`,
`w = (log x + log y)/2`, has an inner (`w`-) integral of the elementary form
`∫ sin(c e^w) dw = Si(c m₂) - Si(c m₁)`, with `m₁ = e^{|v|/2}` (the corner of the square)
and `m₂ = e^{L - |v|/2}`.  The resulting kernel splits as `Λ = Ω - 2δ`: the *lower* limits
of the two sine integrals reproduce **exactly twice the trace remainder** `δ` of formula
(49), while the upper limits give the principal-value archimedean kernel `Ω`. -/

/-- The kernel produced by the upper limit of the inner integration:
`Ω(v,L) = (1/π)[Si(4 sinh(v/2) π e^{L-|v|/2})/sinh(v/2) + Si(4 cosh(v/2) π e^{L-|v|/2})/cosh(v/2)]`.
As `L → ∞` each sine integral tends to `π/2` and `Ω` becomes the (principal value of the)
archimedean Weil kernel. -/
def weilCut (v L : ℝ) : ℝ :=
  (1 / π) * (Si (4 * π * Real.sinh (v / 2) * Real.exp (L - |v| / 2)) / Real.sinh (v / 2)
    + Si (4 * π * Real.cosh (v / 2) * Real.exp (L - |v| / 2)) / Real.cosh (v / 2))

/-- `Ω` is even in `v`. -/
theorem weilCut_neg (v L : ℝ) : weilCut (-v) L = weilCut v L := by
  simp only [weilCut, abs_neg, neg_div, Real.sinh_neg, Real.cosh_neg, mul_neg, neg_mul,
    Si_neg, div_neg, neg_neg]

/-- **The lower limit of the inner integration is exactly `2δ`.**  This is formula (49) of
the paper read backwards: `4π sinh(v/2) e^{|v|/2} = 2π(ρ-1)` and
`4π cosh(v/2) e^{|v|/2} = 2π(ρ+1)` for `ρ = e^{|v|}`, while `1/sinh(v/2) = 2√ρ/(ρ-1)` and
`1/cosh(v/2) = 2√ρ/(ρ+1)`. -/
theorem weilCut_abs_eq_two_delta {v : ℝ} (hv : v ≠ 0) :
    weilCut v |v| = 2 * delta (Rplus.expHomeo v) := by
  have key : ∀ u : ℝ, 0 < u → weilCut u |u| = 2 * delta (Rplus.expHomeo u) := by
    intro u hu
    have hπ := Real.pi_pos
    have habs : |u| = u := abs_of_pos hu
    have hexp : (0:ℝ) < Real.exp (u / 2) := Real.exp_pos _
    have hrho : 1 < Real.exp u := by simpa using Real.exp_lt_exp.mpr hu
    have hsq : Real.exp (u / 2) * Real.exp (u / 2) = Real.exp u := by
      rw [← Real.exp_add]; ring_nf
    have hs : Real.sinh (u / 2) = (Real.exp u - 1) / (2 * Real.exp (u / 2)) := by
      rw [Real.sinh_eq, Real.exp_neg]
      field_simp
      nlinarith [hsq]
    have hc : Real.cosh (u / 2) = (1 + Real.exp u) / (2 * Real.exp (u / 2)) := by
      rw [Real.cosh_eq, Real.exp_neg]
      field_simp
      nlinarith [hsq]
    have hsinh : 0 < Real.sinh (u / 2) := by
      rw [hs]; exact div_pos (by linarith) (by positivity)
    have harg1 : 4 * π * Real.sinh (u / 2) * Real.exp (|u| - |u| / 2)
        = 2 * π * (Real.exp u - 1) := by
      rw [habs, hs, show u - u / 2 = u / 2 by ring]
      field_simp
      ring
    have harg2 : 4 * π * Real.cosh (u / 2) * Real.exp (|u| - |u| / 2)
        = 2 * π * (1 + Real.exp u) := by
      rw [habs, hc, show u - u / 2 = u / 2 by ring]
      field_simp
      ring
    have hdel : delta (Rplus.expHomeo u) = 2 * Real.exp (u / 2) *
        (siDiv (2 * π * (1 + Real.exp u)) + siDiv (2 * π * (Real.exp u - 1))) := by
      have h1 : delta (Rplus.expHomeo u) = deltaAux (Real.exp u) :=
        delta_of_one_le (by simpa [Rplus.expHomeo_apply] using hrho.le)
      rw [h1, deltaAux_explicit, show Real.sqrt (Real.exp u) = Real.exp (u / 2) by
        rw [show u = u / 2 + u / 2 by ring, Real.exp_add, Real.sqrt_mul_self (Real.exp_pos _).le]
        ring_nf]
    have hpos1 : (0:ℝ) < Real.exp u - 1 := by linarith
    have hne1 : 2 * π * (Real.exp u - 1) ≠ 0 := by positivity
    have hne2 : 2 * π * (1 + Real.exp u) ≠ 0 := by positivity
    rw [weilCut, harg1, harg2, hdel, siDiv_of_ne_zero hne1, siDiv_of_ne_zero hne2, hs, hc]
    have h1 : Real.exp u - 1 ≠ 0 := by intro h; nlinarith
    have h2 : (1:ℝ) + Real.exp u ≠ 0 := by intro h; nlinarith
    field_simp
    ring
  rcases lt_trichotomy v 0 with h | h | h
  · have hflip : weilCut (-v) |(-v)| = weilCut v |v| := by rw [abs_neg, weilCut_neg]
    rw [← hflip, key (-v) (by linarith)]
    congr 1
    have hinv : Rplus.expHomeo (-v) = (Rplus.expHomeo v)⁻¹ := by
      ext; simp [Rplus.expHomeo, Real.exp_neg]
    rw [hinv, delta_symmetric]
  · exact absurd h hv
  · exact key v h

/-- **The kernel of the band energy**, `Λ(v,L) = Ω(v,L) - 2δ(e^{|v|})`. -/
def bandKernel (v L : ℝ) : ℝ := weilCut v L - weilCut v |v|

/-- **The Fourier-side inequality follows from the two statements above.**  Positivity is
carried entirely by the Plancherel bound; the trace limit identity only identifies the
limit. -/
theorem fourierSide_nonneg_of_bandEnergy
    (hbound : BandEnergyBound) (hlim : TraceLimitIdentity) (t : ℝ) : 0 ≤ fourierSide t := by
  have hev : ∀ᶠ X : ℝ in atTop, 0 ≤ 2 * Real.log X - bandEnergy t X := by
    filter_upwards [eventually_ge_atTop (1:ℝ)] with X hX
    have := hbound t X hX
    linarith
  have h := ge_of_tendsto (hlim t) hev
  linarith

/-- The same statement in the form used downstream. -/
theorem two_thetaDeriv_add_deltaFourier_nonneg_of_bandEnergy
    (hbound : BandEnergyBound) (hlim : TraceLimitIdentity) (t : ℝ) :
    0 ≤ 2 * thetaDeriv t + deltaFourier t :=
  fourierSide_nonneg_of_bandEnergy hbound hlim t

end ConnesConsani.WeilPositivity
