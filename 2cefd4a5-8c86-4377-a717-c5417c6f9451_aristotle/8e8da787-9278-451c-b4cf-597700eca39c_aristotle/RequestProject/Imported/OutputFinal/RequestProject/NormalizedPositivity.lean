/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Positivity of the functional `L = D + W_∞` of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771,

in the `∆^{1/2}` normalization of the paper, *unconditionally*, on the class of `C⁴`
compactly supported positive definite test functions, together with the consequences of
§3 of the paper that were previously stated with the positivity of `L` as a hypothesis.

Two remarks on what is and what is not proved.

* The predicate `LPositivity` of `RequestProject/Positivity.lean` pairs the trace remainder
  `δ` with the test function `f` and the Weil distribution `W_ℝ` with the *same* `f`.  As
  explained at the top of `RequestProject/ArchimedeanExplicit.lean`, the paper applies
  `W_ℝ` to `∆^{-1/2} f`, and in the logarithmic coordinate the two pairings differ (the
  first pairs `W_ℝ` with the transform on the line `Re z = 1/2`, the second with the
  transform on the unitary line, which is where positive definiteness lives).  So
  `LPositivity` is *not* the statement of Corollary 2.3 (i), and it cannot be obtained
  from the Fourier-side inequality; the coherent statement is the one proved here, with
  `LfunNorm` in place of `Lfun`.

* Inside that normalization the only remaining analytic input was the integrability of the
  Fourier transform of the test function (a Bochner-type statement for a general positive
  definite function).  `RequestProject/QuarticDecay.lean` supplies it for every `C⁴`
  compactly supported test function, which covers all the test functions used downstream:
  the elements `Q(ξ ⋆ ξ*)` of the vanishing ideal, and the general positive definite
  elements of the vanishing ideal produced by the division property `QDivision_Icc`.

Consequently the small-support lower bounds for `W_∞` of §3 of the paper
(`small_support_Winfty_ge`, `Winfty_ge_effective`), which are stated in
`RequestProject/Positivity.lean` and `RequestProject/Effective.lean` with the hypothesis
`LPositivity`, are obtained here with **no hypothesis at all**.
-/
import RequestProject.Imported.OutputFinal.RequestProject.ArchimedeanPositivity
import RequestProject.Imported.OutputFinal.RequestProject.QuarticDecay
import RequestProject.Imported.OutputFinal.RequestProject.Effective

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

/-! ## Positivity of `L` on `C⁴` test functions -/

/-- The real part of `L` in the `∆^{1/2}` normalization splits as the `D`-term plus the
`W_∞`-term. -/
theorem LfunNorm_re_eq (G : ℝ → ℂ) :
    (LfunNorm G).re = (Dcomplex (ofLog G)).re + (Winfty (deltaHalfInv (ofLog G))).re := by
  simp [LfunNorm, Complex.add_re]

/-- **Weil positivity at the archimedean place for `C⁴` test functions, unconditionally**
(Corollary 2.3 (i) of the paper, in the `∆^{1/2}` normalization).  The functional
`L = D + W_∞` is nonnegative on every positive definite test function of class `C⁴` with
compact support. -/
theorem LfunNorm_re_nonneg_contDiff_four {G : ℝ → ℂ} (hG : ContDiff ℝ 4 G)
    (hsG : HasCompactSupport G) (hpd : PositiveDefiniteLog G) :
    0 ≤ (LfunNorm G).re :=
  LfunNorm_re_nonneg_of_contDiff_four_of_fourierSide_nonneg
    two_thetaDeriv_add_deltaFourier_nonneg hG hsG hpd

/-- **Positivity of `L` in the normalization of the paper**, as a predicate on the class of
`C⁴` compactly supported test functions.  This is the corrected and usable form of
`LPositivity`. -/
def LPositivityNorm : Prop :=
  ∀ G : ℝ → ℂ, ContDiff ℝ 4 G → HasCompactSupport G → PositiveDefiniteLog G →
    0 ≤ (LfunNorm G).re

/-- **`L` is a positive functional** on the `C⁴` test functions, unconditionally. -/
theorem LPositivityNorm_holds : LPositivityNorm :=
  fun _ hG hsG hpd => LfunNorm_re_nonneg_contDiff_four hG hsG hpd

/-! ## The unnormalized pairing, on `C⁴` test functions -/

/-- `LPositivity` restricted to the test functions of class `C⁴`: the class on which the
integrability of the Fourier transform is elementary. -/
def LPositivityC4 : Prop :=
  ∀ f : ℝ → ℂ, ContDiff ℝ 4 f → HasCompactSupport f → PositiveDefiniteLog f →
    0 ≤ L_real (ofLog f)

/-- **The implication of Corollary 2.3 in the unnormalized pairing, on `C⁴` test
functions.**  This is the statement that used to be recorded as
`LPositivity_of_fourierSide_nonneg` in `RequestProject/FourierSide.lean`, with the two
defects of that statement removed: the Fourier-side inequality is now a theorem, and the
integrability of the transform is supplied by the quartic decay estimates.  What remains
is the hypothesis `WinftyParseval`, i.e. the explicit formula *for the unnormalized
pairing* — which, as explained in `RequestProject/ArchimedeanExplicit.lean`, is not the
archimedean explicit formula (that one is `WinftyParsevalNorm`, a theorem).  For the
normalization of the paper no hypothesis at all is needed: see `LPositivityNorm_holds`. -/
theorem LPositivityC4_of_WinftyParseval (hW : WinftyParseval) : LPositivityC4 := by
  intro f hf hsf hpd
  have hint : Integrable (fourierLog f) := integrable_fourierLog_of_contDiff_four hf hsf
  exact L_real_nonneg_of_fourierSide_nonneg hW two_thetaDeriv_add_deltaFourier_nonneg
    hf.continuous hsf hint
    (integrable_fourierLog_mul_thetaDeriv hint
      (integrable_norm_fourierLog_mul_digammaDiff_of_contDiff_four hf hsf)) hpd

/-! ## Smoothness bookkeeping -/

theorem contDiff_Qlog_of_six {F : ℝ → ℂ} (hF : ContDiff ℝ 6 F) : ContDiff ℝ 4 (Qlog F) := by
  have h1 : ContDiff ℝ 5 (deriv F) := by
    have h : ContDiff ℝ ((5 : WithTop ℕ∞) + 1) F := by convert hF using 2
    exact h.deriv'
  have h2 : ContDiff ℝ 4 (deriv (deriv F)) := by
    have h : ContDiff ℝ ((4 : WithTop ℕ∞) + 1) (deriv F) := by convert h1 using 2
    exact h.deriv'
  exact h2.neg.add ((hF.of_le (by norm_num)).div_const 4)

theorem contDiff_starLog_of_six {F : ℝ → ℂ} (hF : ContDiff ℝ 6 F) : ContDiff ℝ 6 (starLog F) := by
  have h : starLog F = (fun z => starRingEnd ℂ z) ∘ (F ∘ fun t : ℝ => -t) := rfl
  rw [h]
  exact (Complex.conjLIE.toLinearIsometry.toContinuousLinearMap.contDiff).comp
    (hF.comp contDiff_neg)

theorem contDiff_convLog_starLog_self_six {F : ℝ → ℂ} (hF : ContDiff ℝ 6 F)
    (hsF : HasCompactSupport F) : ContDiff ℝ 6 (convLog F (starLog F)) :=
  HasCompactSupport.contDiff_convolution_left (n := 6) _ hsF hF
    (contDiff_starLog_of_six hF).continuous.locallyIntegrable

/-- `Q(ξ ⋆ ξ*)` is a `C⁴` compactly supported positive definite test function as soon as
`ξ` is `C⁶` with compact support. -/
theorem contDiff_four_Qlog_convLog_starLog {F : ℝ → ℂ} (hF : ContDiff ℝ 6 F)
    (hsF : HasCompactSupport F) : ContDiff ℝ 4 (Qlog (convLog F (starLog F))) :=
  contDiff_Qlog_of_six (contDiff_convLog_starLog_self_six hF hsF)

theorem positiveDefiniteLog_Qlog_convLog_starLog {F : ℝ → ℂ} (hF : ContDiff ℝ 2 F)
    (hsF : HasCompactSupport F) : PositiveDefiniteLog (Qlog (convLog F (starLog F))) := by
  have hconv : ContDiff ℝ 2 (convLog F (starLog F)) := contDiff_convLog_starLog_self hF hsF
  have hsconv : HasCompactSupport (convLog F (starLog F)) :=
    hasCompactSupport_convLog hsF (hasCompactSupport_starLog hsF)
  exact positiveDefiniteLog_Qlog hconv hsconv
    (positiveDefiniteLog_convLog_starLog hF.continuous hsF)

/-- Positivity of `L` at `Q(ξ ⋆ ξ*)`, unconditionally. -/
theorem LfunNorm_re_nonneg_Qlog_convLog_starLog {F : ℝ → ℂ} (hF : ContDiff ℝ 6 F)
    (hsF : HasCompactSupport F) :
    0 ≤ (LfunNorm (Qlog (convLog F (starLog F)))).re := by
  have hsconv : HasCompactSupport (convLog F (starLog F)) :=
    hasCompactSupport_convLog hsF (hasCompactSupport_starLog hsF)
  exact LfunNorm_re_nonneg_contDiff_four (contDiff_four_Qlog_convLog_starLog hF hsF)
    (hasCompactSupport_Qlog hsconv)
    (positiveDefiniteLog_Qlog_convLog_starLog (hF.of_le (by norm_num)) hsF)

/-! ## The consequences of §3, with no positivity hypothesis -/

/-- **The abstract implication (57) of the paper, unconditionally.**  If `D ∘ Q` is
nonpositive on the positive definite test functions supported in `[-a,a]`, then the
archimedean Weil functional `W_∞` (in the `∆^{1/2}` normalization) is nonnegative on the
`C⁴` positive definite test functions supported in `[-a,a]` which lie in the vanishing
ideal.  This is `Winfty_nonneg_of_D_Qlog_nonpos_Icc` with the hypothesis `LPositivity`
discharged. -/
theorem Winfty_deltaHalfInv_nonneg_of_D_Qlog_nonpos_Icc {a : ℝ}
    (hDQ : ∀ g : ℝ → ℂ, ContDiff ℝ 2 g → HasCompactSupport g → PositiveDefiniteLog g →
      Function.support g ⊆ Icc (-a) a → (Dcomplex (ofLog (Qlog g))).re ≤ 0) :
    ∀ f : ℝ → ℂ, ContDiff ℝ 4 f → HasCompactSupport f → PositiveDefiniteLog f →
      Function.support f ⊆ Icc (-a) a → vanishesAtHalf f →
      0 ≤ (Winfty (deltaHalfInv (ofLog f))).re := by
  intro f hf hsf hpd hsupp hvan
  obtain ⟨g, hg, hsg, hgsupp, hpdg, hfg⟩ := QDivision_Icc a f hf.continuous hsf hsupp hvan
  have h1 : (Dcomplex (ofLog (Qlog g))).re ≤ 0 := hDQ g hg hsg (hpdg hpd) hgsupp
  rw [← hfg] at h1
  have h2 := LfunNorm_re_nonneg_contDiff_four hf hsf hpd
  rw [LfunNorm_re_eq] at h2
  linarith

/-- **The small-support lower bound for `W_∞`, unconditionally.**  There is an `a > 0` such
that every `C⁶` test function `ξ` supported in `|log ρ| ≤ a` satisfies
`W_∞(Q(ξ ⋆ ξ*)) ≥ ‖ξ‖²`.  This is `small_support_Winfty_ge` with the hypothesis
`LPositivity` discharged (and in the `∆^{1/2}` normalization of the paper). -/
theorem small_support_Winfty_deltaHalfInv_ge :
    ∃ a : ℝ, 0 < a ∧ ∀ F : ℝ → ℂ, ContDiff ℝ 6 F → SupportedIn a F →
      L2sq F ≤ (Winfty (deltaHalfInv (ofLog (Qlog (convLog F (starLog F)))))).re := by
  obtain ⟨a, ha, h⟩ := small_support_D_Qlog_nonpos
  refine ⟨a, ha, fun F hF hsupp => ?_⟩
  have hsF : HasCompactSupport F := hasCompactSupport_of_supportedIn hsupp
  have h2 := LfunNorm_re_nonneg_Qlog_convLog_starLog hF hsF
  rw [LfunNorm_re_eq] at h2
  have h1 := h F (hF.of_le (by norm_num)) hsupp
  linarith

/-- In particular `W_∞` is nonnegative on those elements of the vanishing ideal. -/
theorem small_support_Winfty_deltaHalfInv_nonneg :
    ∃ a : ℝ, 0 < a ∧ ∀ F : ℝ → ℂ, ContDiff ℝ 6 F → SupportedIn a F →
      0 ≤ (Winfty (deltaHalfInv (ofLog (Qlog (convLog F (starLog F)))))).re := by
  obtain ⟨a, ha, h⟩ := small_support_Winfty_deltaHalfInv_ge
  exact ⟨a, ha, fun F hF hsupp => le_trans (L2sq_nonneg F) (h F hF hsupp)⟩

/-- **The effective form, unconditionally.**  Every `C⁶` test function `ξ` supported in
`{ρ : |log ρ| ≤ 1/30}` satisfies `W_∞(Q(ξ ⋆ ξ*)) ≥ (2/15)‖ξ‖²`.  This is
`Winfty_ge_effective` with the hypothesis `LPositivity` discharged. -/
theorem Winfty_deltaHalfInv_ge_effective {F : ℝ → ℂ} (hF : ContDiff ℝ 6 F)
    (hsupp : SupportedIn (1 / 30) F) :
    (2 / 15) * L2sq F
      ≤ (Winfty (deltaHalfInv (ofLog (Qlog (convLog F (starLog F)))))).re := by
  have hsF : HasCompactSupport F := hasCompactSupport_of_supportedIn hsupp
  have h2 := LfunNorm_re_nonneg_Qlog_convLog_starLog hF hsF
  rw [LfunNorm_re_eq] at h2
  have h1 := Dcomplex_Qlog_convLog_effective (hF.of_le (by norm_num)) hsupp
  linarith

/-- **Corollary 3.8 in the multiplicative language, unconditionally.**  Every test function
`ξ` on `ℝ⋆₊` supported in `{ρ : |log ρ| ≤ 1/30}` satisfies `W_∞(Q(ξ ⋆ ξ*)) ≥ (2/15)‖ξ‖²`,
the `L²` norm being taken against the multiplicative Haar measure `d*ρ`. -/
theorem Winfty_deltaHalfInv_ge_effective_mul {f : Rplus → ℂ}
    (hf : ContDiff ℝ 6 (fun t => f (Rplus.expHomeo t)))
    (hsupp : ∀ ρ : Rplus, 1 / 30 < |Real.log (ρ : ℝ)| → f ρ = 0) :
    (2 / 15) * (∫ ρ : Rplus, ‖f ρ‖ ^ 2 ∂(Rplus.haar))
      ≤ (Winfty (deltaHalfInv (ofLog (Qlog (convLog (fun t => f (Rplus.expHomeo t))
          (starLog (fun t => f (Rplus.expHomeo t)))))))).re := by
  have hkey := Winfty_deltaHalfInv_ge_effective hf (supportedIn_comp_expHomeo hsupp)
  rwa [L2sq_haar] at hkey

end ConnesConsani.WeilPositivity
