/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The unconditional archimedean Weil positivity of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771.

This file contains no new mathematics: it combines the two halves that are proved
elsewhere in this project into the statement of Corollary 2.3 (i) of the paper, with no
hypotheses left.

* `RequestProject/PolyaLowThreshold.lean` proves the Fourier-side inequality
  `2θ'(t) + δ̂(t) ≥ 0` for **every** real `t` (`two_thetaDeriv_add_deltaFourier_nonneg`).
* `RequestProject/ArchimedeanExplicit.lean` proves the Parseval identity (52)
  `L(f) = (2π)⁻¹ ∫ f̂(t) (2θ'(t) + δ̂(t)) dt` in the `∆^{1/2}` normalization of the paper,
  the `W_∞`-half being the archimedean explicit formula, itself proved there from the
  Gauss partial-fraction expansion of `ψ` and the value `ψ(1/4)`.
* `RequestProject/FourierDecay.lean` discharges the analytic side conditions of that
  identity for a convolution square `F ⋆ F*` with `F` of class `C²` and compactly
  supported.
-/
import RequestProject.Imported.OutputFinal.RequestProject.FourierDecay
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowThreshold

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

/-- **Weil positivity at the archimedean place, unconditionally** (Corollary 2.3 (i) of the
paper, in the `∆^{1/2}` normalization).  For every test function `F` of class `C²` with
compact support, the functional `L = D + W_∞` is nonnegative on the convolution square
`F ⋆ F*`.

No hypothesis is left: the Fourier-side inequality `2θ' + δ̂ ≥ 0`, the archimedean explicit
formula, and the analytic side conditions on the transform of `F ⋆ F*` are all theorems of
this project. -/
theorem LfunNorm_re_nonneg_convLog_starLog {F : ℝ → ℂ} (hF : ContDiff ℝ 2 F)
    (hsF : HasCompactSupport F) :
    0 ≤ (LfunNorm (convLog F (starLog F))).re :=
  LfunNorm_re_nonneg_convLog_starLog_self two_thetaDeriv_add_deltaFourier_nonneg hF hsF

/-- **Weil positivity at the archimedean place** for a general positive definite test
function whose Fourier–Mellin transform satisfies the integrability conditions of the
Parseval identity.  This is the same statement as
`LfunNorm_re_nonneg_of_fourierSide_nonneg`, with the Fourier-side inequality discharged. -/
theorem LfunNorm_re_nonneg {G : ℝ → ℂ} (hGc : Continuous G) (hGs : HasCompactSupport G)
    (hG : Integrable (fourierLog G))
    (hGP : Integrable (fun t : ℝ => ‖fourierLog G t‖ * digammaDiff t))
    {C : ℝ} (hLip : ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u|) (hpd : PositiveDefiniteLog G) :
    0 ≤ (LfunNorm G).re :=
  LfunNorm_re_nonneg_of_fourierSide_nonneg two_thetaDeriv_add_deltaFourier_nonneg
    hGc hGs hG hGP hLip hpd

end ConnesConsani.WeilPositivity
