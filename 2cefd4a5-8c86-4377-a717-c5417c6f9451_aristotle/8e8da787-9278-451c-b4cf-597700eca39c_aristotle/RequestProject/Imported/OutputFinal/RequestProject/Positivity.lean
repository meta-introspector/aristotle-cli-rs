/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The functional `L = D + W_∞`, the vanishing conditions at `±i/2`, and the transfer of the
essential negativity of `D ∘ Q` into positivity of `W_∞`, following §3 (Proposition 3.5,
formula (57)) and §4 of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771.

Everything is written in the logarithmic coordinate `ρ = e^t` used in the rest of the
project, in which the convolution algebra of `ℝ⋆₊` becomes the convolution algebra of the
additive line (`convLog`, `starLog`) and the operator `Q = -(ρ∂_ρ)² + 1/4` becomes
`Qlog`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.RemainderBound
import RequestProject.Imported.OutputFinal.RequestProject.WeilDistribution

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

/-! ## Test functions with prescribed support -/

/-- `SupportedIn a F` says that `F` vanishes outside `[-a, a]`, i.e. that the corresponding
function on `ℝ⋆₊` is supported in `{ρ : |log ρ| ≤ a}`. -/
def SupportedIn (a : ℝ) (F : ℝ → ℂ) : Prop := ∀ s : ℝ, a < |s| → F s = 0

theorem hasCompactSupport_of_supportedIn {a : ℝ} {F : ℝ → ℂ} (h : SupportedIn a F) :
    HasCompactSupport F :=
  HasCompactSupport.intro (isCompact_Icc (a := -a) (b := a)) fun x hx =>
    h x (by
      by_contra hcon
      push_neg at hcon
      exact hx (mem_Icc.2 ⟨(abs_le.1 hcon).1, (abs_le.1 hcon).2⟩))

theorem support_subset_of_supportedIn {a : ℝ} {F : ℝ → ℂ} (h : SupportedIn a F) :
    Function.support F ⊆ Icc (-a) a := by
  intro x hx
  by_contra hmem
  refine hx (h x ?_)
  by_contra hcon
  push_neg at hcon
  exact hmem (mem_Icc.2 ⟨(abs_le.1 hcon).1, (abs_le.1 hcon).2⟩)

/-- The convolution square of a function supported in `[-a,a]` is supported in `[-2a,2a]`,
and so is its image under `Q`, which is a differential operator. -/
theorem supportedIn_Qlog_convLog_starLog {a : ℝ} {F : ℝ → ℂ} (h : SupportedIn a F) :
    SupportedIn (2 * a) (Qlog (convLog F (starLog F))) := by
  intro t ht
  have hsub : Function.support (convLog F (starLog F)) ⊆ Icc (-(2 * a)) (2 * a) := by
    intro s hs
    by_contra hmem
    refine hs (convLog_starLog_self_eq_zero h ?_)
    by_contra hcon
    push_neg at hcon
    exact hmem (mem_Icc.2 ⟨by linarith [neg_abs_le s], le_trans (le_abs_self s) hcon⟩)
  have htsub : tsupport (convLog F (starLog F)) ⊆ Icc (-(2 * a)) (2 * a) :=
    closure_minimal hsub isClosed_Icc
  by_contra hne
  have hmem := htsub (support_Qlog_subset _ hne)
  rw [mem_Icc] at hmem
  have := abs_le.2 hmem
  linarith

/-! ## Smoothness of `Q` applied to a `C²` function -/

/-- `Q` applied to a `C²` function is continuous. -/
theorem continuous_Qlog {G : ℝ → ℂ} (hG : ContDiff ℝ 2 G) : Continuous (Qlog G) :=
  ((hG.deriv' : ContDiff ℝ 1 (deriv G)).continuous_deriv le_rfl).neg.add
    (hG.continuous.div_const 4)

/-- The convolution square of a `C²` compactly supported function is `C²`. -/
theorem contDiff_convLog_starLog_self {F : ℝ → ℂ} (hF : ContDiff ℝ 2 F)
    (hsF : HasCompactSupport F) : ContDiff ℝ 2 (convLog F (starLog F)) := by
  have hstar : ContDiff ℝ 2 (starLog F) := by
    have h : starLog F = (fun z => starRingEnd ℂ z) ∘ (F ∘ fun t : ℝ => -t) := rfl
    rw [h]
    exact (Complex.conjLIE.toLinearIsometry.toContinuousLinearMap.contDiff).comp
      (hF.comp contDiff_neg)
  exact HasCompactSupport.contDiff_convolution_left (n := 2) _ hsF hF
    hstar.continuous.locallyIntegrable

/-! ## The `L²` norm and the pairing realising `D ∘ Q` -/

/-- The square of the `L²`-norm of a test function, `‖ξ‖²`. -/
def L2sq (F : ℝ → ℂ) : ℝ := ∫ s : ℝ, ‖F s‖ ^ 2

theorem L2sq_nonneg (F : ℝ → ℂ) : 0 ≤ L2sq F := integral_nonneg fun s => by positivity

/-- **The pairing realising `D(Q(ξ ∗ ξ*))`.**  In the logarithmic coordinate the functional
`D(f) = ∫ f(ρ⁻¹) δ(ρ) d*ρ` applied to `Q(ξ ∗ ξ*)` is the real part of the integral of
`Q(ξ ∗ ξ*)` against the trace remainder `δ`.  (The two coincide because `δ` is symmetric
under `ρ ↦ ρ⁻¹`; see `Dcomplex_ofLog` and `D_Q_pairing_eq`.) -/
def D_Q_pairing (F : ℝ → ℂ) : ℝ :=
  (∫ t : ℝ, Qlog (convLog F (starLog F)) t * ((delta (Rplus.expHomeo t) : ℝ) : ℂ)).re

/-! ## From the logarithmic coordinate back to `ℝ⋆₊` -/

/-- A function of the logarithmic variable `t`, read as a function of `ρ = e^t` on
`(0,∞)` (and extended by zero to the rest of the line). -/
def ofLog (G : ℝ → ℂ) : ℝ → ℂ := fun x => if 0 < x then G (Real.log x) else 0

@[simp] theorem ofLog_exp (G : ℝ → ℂ) (t : ℝ) : ofLog G (Real.exp t) = G t := by
  simp [ofLog, Real.exp_pos t, Real.log_exp]

theorem delta_expHomeo_neg (t : ℝ) :
    delta (Rplus.expHomeo (-t)) = delta (Rplus.expHomeo t) := by
  have h : Rplus.expHomeo (-t) = (Rplus.expHomeo t)⁻¹ := by
    apply Subtype.ext
    show Real.exp (-t) = ((Rplus.expHomeo t : Rplus) : ℝ)⁻¹
    rw [Real.exp_neg]
    rfl
  rw [h, delta_symmetric]

/-- The functional `D` of the paper, `D(f) = ∫ f(ρ⁻¹) δ(ρ) d*ρ`, for complex valued test
functions on `ℝ⋆₊`. -/
def Dcomplex (f : ℝ → ℂ) : ℂ :=
  ∫ ρ : Rplus, f ((ρ : ℝ)⁻¹) * ((delta ρ : ℝ) : ℂ) ∂(Rplus.haar)

/-- In logarithmic coordinates `D` is simply the pairing with `δ`: the inversion
`ρ ↦ ρ⁻¹` is absorbed by the symmetry `δ(ρ⁻¹) = δ(ρ)`. -/
theorem Dcomplex_ofLog (G : ℝ → ℂ) :
    Dcomplex (ofLog G) = ∫ t : ℝ, G t * ((delta (Rplus.expHomeo t) : ℝ) : ℂ) := by
  rw [Dcomplex, Rplus.integral_haar]
  have hpt : ∀ t : ℝ, ofLog G (((Rplus.expHomeo t : Rplus) : ℝ)⁻¹) * ((delta (Rplus.expHomeo t) :
      ℝ) : ℂ) = (fun u : ℝ => G u * ((delta (Rplus.expHomeo u) : ℝ) : ℂ)) (-t) := by
    intro t
    have hval : ((Rplus.expHomeo t : Rplus) : ℝ)⁻¹ = Real.exp (-t) := by
      show (Real.exp t)⁻¹ = Real.exp (-t)
      rw [Real.exp_neg]
    rw [hval, ofLog_exp]
    show G (-t) * ((delta (Rplus.expHomeo t) : ℝ) : ℂ)
      = G (-t) * ((delta (Rplus.expHomeo (-t)) : ℝ) : ℂ)
    rw [delta_expHomeo_neg]
  rw [integral_congr_ae (Filter.Eventually.of_forall hpt)]
  exact integral_neg_eq_self (fun u : ℝ => G u * ((delta (Rplus.expHomeo u) : ℝ) : ℂ)) volume

/-- `D_Q_pairing` is the value of `D` at `Q(ξ ∗ ξ*)`. -/
theorem D_Q_pairing_eq (F : ℝ → ℂ) :
    D_Q_pairing F = (Dcomplex (ofLog (Qlog (convLog F (starLog F))))).re := by
  rw [D_Q_pairing, Dcomplex_ofLog]

/-! ## The functional `L = D + W_∞` -/

/-- **The functional `L = D + W_∞`** of §2 of the paper (formula (9)), for a complex valued
test function on `ℝ⋆₊`.  Conjecturally (and this is the content of the trace identity
`L(f) = Tr(ϑ(f) P P̂ P)`) it is a positive functional on the convolution algebra. -/
def Lfun (f : ℝ → ℂ) : ℂ := Dcomplex f + Winfty f

/-- The real part of `L`, which is the quantity the positivity statements refer to. -/
def L_real (f : ℝ → ℂ) : ℝ := (Lfun f).re

theorem L_real_eq (f : ℝ → ℂ) : L_real f = (Dcomplex f).re + (Winfty f).re := by
  simp [L_real, Lfun, Complex.add_re]

/-! ## Positive definiteness in the Fourier–Mellin picture -/

/-- A test function on `ℝ⋆₊` is *positive definite* when its Fourier–Mellin transform is
nonnegative on the unitary characters `z = ix`. -/
def PositiveDefiniteLog (F : ℝ → ℂ) : Prop :=
  ∀ x : ℝ, 0 ≤ (mellinLog F (Complex.I * x)).re

/-- Convolution squares are positive definite. -/
theorem positiveDefiniteLog_convLog_starLog {F : ℝ → ℂ} (hF : Continuous F)
    (hsF : HasCompactSupport F) : PositiveDefiniteLog (convLog F (starLog F)) :=
  fun x => mellinLog_convLog_starLog_self_nonneg hF hsF x

/-- `Q` preserves positive definiteness: it multiplies the transform by `1/4 + x² > 0` on
the unitary characters. -/
theorem positiveDefiniteLog_Qlog {F : ℝ → ℂ} (hF : ContDiff ℝ 2 F)
    (hsF : HasCompactSupport F) (h : PositiveDefiniteLog F) : PositiveDefiniteLog (Qlog F) := by
  intro x
  have hz : (1 : ℂ) / 4 - (Complex.I * x) ^ 2 = ((1 / 4 + x ^ 2 : ℝ) : ℂ) := by
    push_cast
    rw [mul_pow, Complex.I_sq]
    ring
  rw [mellinLog_Qlog hF hsF, hz, Complex.re_ofReal_mul]
  have hx : (0 : ℝ) ≤ 1 / 4 + x ^ 2 := by positivity
  exact mul_nonneg hx (h x)

/-! ## The vanishing conditions at `±i/2` -/

/-- **The vanishing ideal `J`.**  A test function belongs to it when its Fourier–Mellin
transform vanishes at the two points `z = ±1/2` (that is, at `±i/2` in the dual variable of
the paper). -/
def vanishesAtHalf (F : ℝ → ℂ) : Prop :=
  mellinLog F (1 / 2) = 0 ∧ mellinLog F (-(1 / 2)) = 0

/-- **`Q` implements the vanishing conditions** (§3 of the paper): the image of `Q` lies in
the vanishing ideal. -/
theorem vanishesAtHalf_Qlog {F : ℝ → ℂ} (hF : ContDiff ℝ 2 F) (hsF : HasCompactSupport F) :
    vanishesAtHalf (Qlog F) := mellinLog_Qlog_half hF hsF

/-- In particular `Q(ξ ∗ ξ*)` lies in the vanishing ideal, is positive definite, and is
supported in `[-2a, 2a]` when `ξ` is supported in `[-a, a]`.  This is the package of
properties used in §3–§4 of the paper. -/
theorem Qlog_convLog_starLog_mem_vanishingIdeal {a : ℝ} {F : ℝ → ℂ} (hF : ContDiff ℝ 2 F)
    (hsupp : SupportedIn a F) :
    vanishesAtHalf (Qlog (convLog F (starLog F)))
      ∧ PositiveDefiniteLog (Qlog (convLog F (starLog F)))
      ∧ SupportedIn (2 * a) (Qlog (convLog F (starLog F))) := by
  have hsF : HasCompactSupport F := hasCompactSupport_of_supportedIn hsupp
  have hconv : ContDiff ℝ 2 (convLog F (starLog F)) := contDiff_convLog_starLog_self hF hsF
  have hsconv : HasCompactSupport (convLog F (starLog F)) :=
    hasCompactSupport_convLog hsF (hasCompactSupport_starLog hsF)
  exact ⟨vanishesAtHalf_Qlog hconv hsconv,
    positiveDefiniteLog_Qlog hconv hsconv
      (positiveDefiniteLog_convLog_starLog hF.continuous hsF),
    supportedIn_Qlog_convLog_starLog hsupp⟩

/-! ## Positivity of `L` -/

/-- **Positivity of the functional `L = D + W_∞`** on positive-definite test functions.
In the paper this is the consequence of the trace identity `L(f) = Tr(ϑ(f) P P̂ P)`, the
right-hand side being manifestly positive for `f = g ∗ g*` because `P P̂ P` is a positive
operator.

*Warning on the normalization.*  Here both `D` and `W_∞` are paired with the same test
function `f`, whereas the paper applies the archimedean distribution to `∆^{-1/2} f`.  The
two pairings differ (see the top of `RequestProject/ArchimedeanExplicit.lean`), and it is
the second one, `LfunNorm` of that file, for which Corollary 2.3 (i) holds; the positivity
of `LfunNorm` on `C⁴` compactly supported positive definite test functions is *proved*,
with no hypothesis, in `RequestProject/NormalizedPositivity.lean`
(`LPositivityNorm_holds`).  The statements below that take `LPositivity` as a hypothesis
have unconditional counterparts there. -/
def LPositivity : Prop :=
  ∀ f : ℝ → ℂ, Continuous f → HasCompactSupport f → PositiveDefiniteLog f →
    0 ≤ L_real (ofLog f)

/-!
**`LPositivity` is false, and the statement below is therefore withdrawn.**

The original skeleton contained

```
/-- **`L` is a positive functional.** -/
theorem L_positive : LPositivity := by
  sorry
```

It is *not* a theorem.  `LPositivity` pairs both `D` and `W_∞` with the same test
function `f`, whereas the paper applies the archimedean distribution to `∆^{-1/2} f`; in
the logarithmic coordinate the two pairings differ by the nonnegative deficit

  `W_ℝ(f) - W_ℝ(∆^{-1/2} f) = ∫₀^∞ F(u) (e^{u/2}-1)²/(e^u - e^{-u}) du`,

which grows linearly in the width of the support of `F`, while the normalized functional
stays bounded.  A fully explicit counterexample (the triangular, i.e. Fejér, bump of
large half width, which is continuous, compactly supported and positive definite) is
constructed and verified in `RequestProject/UnnormalizedCounterexample.lean`:

* `not_LPositivity : ¬ LPositivity`,
* `L_real_triC_neg`, the strict negativity of `L` on that bump,
* `WeilR_ofLog_eq_add_deficit`, the exact discrepancy between the two pairings.

The statement of the paper (Corollary 2.3 (i)) is the positivity of the *normalized*
functional `LfunNorm`, which is proved with no hypothesis in
`RequestProject/NormalizedPositivity.lean` (`LPositivityNorm_holds`).  The results below
that take `LPositivity` as an explicit hypothesis are therefore vacuous as stated; each of
them has an unconditional counterpart, in the normalization of the paper, in
`RequestProject/NormalizedPositivity.lean`.
-/

/-! ## Division by `1/4 - z²`: the Green potential of `Q`

This section proves Lemma 3.3 (iii)–(iv) / Proposition 3.5 of the paper: a compactly
supported test function whose Fourier–Mellin transform vanishes at `±i/2` is `Q G` for a
`C²` test function `G` *with the same support*, and `G` is positive definite whenever `F`
is.

In the logarithmic coordinate `Q = -(d/dt)² + 1/4`, whose fundamental solution is the
Green kernel `e^{-|t|/2}`.  Convolving `F` with it produces the potential

  `G(t) = e^{-t/2} ∫_{-c}^{t} e^{s/2} F(s) ds + e^{t/2} ∫_{t}^{c} e^{-s/2} F(s) ds`,

which always satisfies `Q G = F`.  Outside the support of `F` the two integrals become the
values `mellinLog F (1/2)` and `mellinLog F (-(1/2))` of the transform at the two points
`±i/2`, so that `G` again has compact support *exactly* when `F` lies in the vanishing
ideal.  This is the elementary form of the division of an entire function of exponential
type by `1/4 - z²`. -/

/-- The left half of the Green potential, `∫_{-c}^{t} e^{s/2} F(s) ds`. -/
def QinvA (c : ℝ) (F : ℝ → ℂ) (t : ℝ) : ℂ := ∫ s in (-c)..t, ((Real.exp (s / 2) : ℝ) : ℂ) * F s

/-- The right half of the Green potential, `∫_{t}^{c} e^{-s/2} F(s) ds`. -/
def QinvB (c : ℝ) (F : ℝ → ℂ) (t : ℝ) : ℂ := ∫ s in t..c, ((Real.exp (-s / 2) : ℝ) : ℂ) * F s

/-- **The Green potential of `Q`**: the convolution of `F` with the fundamental solution
`e^{-|t|/2}` of `Q = -(d/dt)² + 1/4`, computed with the cut-off `c` (which is immaterial as
soon as `c` exceeds the support of `F`). -/
def Qinv (c : ℝ) (F : ℝ → ℂ) (t : ℝ) : ℂ :=
  ((Real.exp (-t / 2) : ℝ) : ℂ) * QinvA c F t + ((Real.exp (t / 2) : ℝ) : ℂ) * QinvB c F t

/-- The derivative of the Green potential. -/
def QinvDeriv (c : ℝ) (F : ℝ → ℂ) (t : ℝ) : ℂ :=
  -(1 / 2) * (((Real.exp (-t / 2) : ℝ) : ℂ) * QinvA c F t)
    + (1 / 2) * (((Real.exp (t / 2) : ℝ) : ℂ) * QinvB c F t)

theorem hasDerivAt_QinvA {F : ℝ → ℂ} (hF : Continuous F) (c t : ℝ) :
    HasDerivAt (QinvA c F) (((Real.exp (t / 2) : ℝ) : ℂ) * F t) t := by
  have hk : Continuous (fun s : ℝ => ((Real.exp (s / 2) : ℝ) : ℂ) * F s) := by fun_prop
  exact intervalIntegral.integral_hasDerivAt_right (hk.intervalIntegrable _ _)
    (hk.stronglyMeasurableAtFilter _ _) hk.continuousAt

theorem hasDerivAt_QinvB {F : ℝ → ℂ} (hF : Continuous F) (c t : ℝ) :
    HasDerivAt (QinvB c F) (-(((Real.exp (-t / 2) : ℝ) : ℂ) * F t)) t := by
  have hk : Continuous (fun s : ℝ => ((Real.exp (-s / 2) : ℝ) : ℂ) * F s) := by fun_prop
  exact intervalIntegral.integral_hasDerivAt_left (hk.intervalIntegrable _ _)
    (hk.stronglyMeasurableAtFilter _ _) hk.continuousAt

theorem hasDerivAt_expHalfNeg (t : ℝ) :
    HasDerivAt (fun u : ℝ => ((Real.exp (-u / 2) : ℝ) : ℂ))
      (((-(1 / 2) * Real.exp (-t / 2) : ℝ) : ℂ)) t := by
  have h : HasDerivAt (fun u : ℝ => Real.exp (-u / 2)) (-(1 / 2) * Real.exp (-t / 2)) t := by
    have := (Real.hasDerivAt_exp (-t / 2)).comp t (((hasDerivAt_id t).neg).div_const 2)
    simpa [Function.comp_def, mul_comm, neg_div] using this
  exact h.ofReal_comp

theorem hasDerivAt_expHalf (t : ℝ) :
    HasDerivAt (fun u : ℝ => ((Real.exp (u / 2) : ℝ) : ℂ))
      (((1 / 2) * Real.exp (t / 2) : ℝ) : ℂ) t := by
  have h : HasDerivAt (fun u : ℝ => Real.exp (u / 2)) ((1 / 2) * Real.exp (t / 2)) t := by
    have := (Real.hasDerivAt_exp (t / 2)).comp t ((hasDerivAt_id t).div_const 2)
    simpa [Function.comp_def, mul_comm] using this
  exact h.ofReal_comp

theorem cexp_half_mul (t : ℝ) : Complex.exp (-(t : ℂ) / 2) * Complex.exp ((t : ℂ) / 2) = 1 := by
  rw [← Complex.exp_add, show -(t : ℂ) / 2 + (t : ℂ) / 2 = 0 by ring, Complex.exp_zero]

theorem hasDerivAt_Qinv {F : ℝ → ℂ} (hF : Continuous F) (c t : ℝ) :
    HasDerivAt (Qinv c F) (QinvDeriv c F t) t := by
  refine (((hasDerivAt_expHalfNeg t).mul (hasDerivAt_QinvA hF c t)).add
    ((hasDerivAt_expHalf t).mul (hasDerivAt_QinvB hF c t))).congr_deriv ?_
  simp only [QinvDeriv]
  push_cast
  ring

theorem hasDerivAt_QinvDeriv {F : ℝ → ℂ} (hF : Continuous F) (c t : ℝ) :
    HasDerivAt (QinvDeriv c F) (Qinv c F t / 4 - F t) t := by
  refine ((((hasDerivAt_expHalfNeg t).mul (hasDerivAt_QinvA hF c t)).const_mul (-(1 / 2) : ℂ)).add
    (((hasDerivAt_expHalf t).mul (hasDerivAt_QinvB hF c t)).const_mul ((1 / 2) : ℂ))).congr_deriv ?_
  simp only [Qinv]
  push_cast
  linear_combination (-(F t)) * (cexp_half_mul t)

/-- **The Green potential inverts `Q`**: `Q (Qinv c F) = F` for every continuous `F`. -/
theorem Qlog_Qinv {F : ℝ → ℂ} (hF : Continuous F) (c : ℝ) : Qlog (Qinv c F) = F := by
  have hd1 : deriv (Qinv c F) = QinvDeriv c F := funext fun t => (hasDerivAt_Qinv hF c t).deriv
  funext t
  simp only [Qlog, hd1, (hasDerivAt_QinvDeriv hF c t).deriv]
  ring

/-- The Green potential of a continuous function is `C²` (it gains two derivatives). -/
theorem contDiff_Qinv {F : ℝ → ℂ} (hF : Continuous F) (c : ℝ) : ContDiff ℝ 2 (Qinv c F) := by
  have hdiff : Differentiable ℝ (Qinv c F) := fun t => (hasDerivAt_Qinv hF c t).differentiableAt
  have hd1 : deriv (Qinv c F) = QinvDeriv c F := funext fun t => (hasDerivAt_Qinv hF c t).deriv
  have hd2 : deriv (QinvDeriv c F) = fun t => Qinv c F t / 4 - F t :=
    funext fun t => (hasDerivAt_QinvDeriv hF c t).deriv
  rw [show (2 : WithTop ℕ∞) = 1 + 1 by norm_num, contDiff_succ_iff_deriv]
  refine ⟨hdiff, by simp, ?_⟩
  rw [hd1, contDiff_one_iff_deriv]
  exact ⟨fun t => (hasDerivAt_QinvDeriv hF c t).differentiableAt, by
    rw [hd2]; exact (hdiff.continuous.div_const 4).sub hF⟩

theorem kernel_plus_eq (F : ℝ → ℂ) (s : ℝ) :
    ((Real.exp (s / 2) : ℝ) : ℂ) * F s = F s * Complex.exp ((1 / 2 : ℂ) * s) := by
  rw [Complex.ofReal_exp]
  push_cast
  ring_nf

theorem kernel_minus_eq (F : ℝ → ℂ) (s : ℝ) :
    ((Real.exp (-s / 2) : ℝ) : ℂ) * F s = F s * Complex.exp ((-(1 / 2) : ℂ) * s) := by
  rw [Complex.ofReal_exp]
  push_cast
  ring_nf

/-- To the right of the support of `F` the left half of the potential is the value of the
transform at `z = 1/2`. -/
theorem QinvA_eq_mellin {a c t : ℝ} {F : ℝ → ℂ} (hs : SupportedIn a F) (hac : a < c) (ht : a < t) :
    QinvA c F t = mellinLog F (1 / 2) := by
  have hsub : Function.support (fun s : ℝ => ((Real.exp (s / 2) : ℝ) : ℂ) * F s) ⊆ Ioc (-c) t := by
    intro s hsmem
    have hFs : F s ≠ 0 := fun h => hsmem (by simp [h])
    have habs : |s| ≤ a := by
      by_contra hc
      exact hFs (hs s (lt_of_not_ge hc))
    exact ⟨by linarith [(abs_le.1 habs).1], by linarith [(abs_le.1 habs).2]⟩
  rw [QinvA, intervalIntegral.integral_eq_integral_of_support_subset hsub, mellinLog]
  exact integral_congr_ae (Filter.Eventually.of_forall (kernel_plus_eq F))

/-- To the left of the support of `F` the right half of the potential is the value of the
transform at `z = -1/2`. -/
theorem QinvB_eq_mellin {a c t : ℝ} {F : ℝ → ℂ} (hs : SupportedIn a F) (hac : a < c)
    (ht : t < -a) : QinvB c F t = mellinLog F (-(1 / 2)) := by
  have hsub : Function.support (fun s : ℝ => ((Real.exp (-s / 2) : ℝ) : ℂ) * F s) ⊆ Ioc t c := by
    intro s hsmem
    have hFs : F s ≠ 0 := fun h => hsmem (by simp [h])
    have habs : |s| ≤ a := by
      by_contra hc
      exact hFs (hs s (lt_of_not_ge hc))
    exact ⟨by linarith [(abs_le.1 habs).1], by linarith [(abs_le.1 habs).2]⟩
  rw [QinvB, intervalIntegral.integral_eq_integral_of_support_subset hsub, mellinLog]
  exact integral_congr_ae (Filter.Eventually.of_forall (kernel_minus_eq F))

theorem QinvB_eq_zero {a c t : ℝ} {F : ℝ → ℂ} (hs : SupportedIn a F) (hac : a < c) (ht : a < t) :
    QinvB c F t = 0 := by
  have h : EqOn (fun s : ℝ => ((Real.exp (-s / 2) : ℝ) : ℂ) * F s) (fun _ => 0) (uIcc t c) := by
    intro s hsmem
    have hmin : min t c ≤ s := by
      rcases mem_uIcc.1 hsmem with h | h
      · exact le_trans (min_le_left _ _) h.1
      · exact le_trans (min_le_right _ _) h.1
    have has : a < s := lt_of_lt_of_le (lt_min ht hac) hmin
    have hF0 : F s = 0 := hs s (lt_of_lt_of_le has (le_abs_self s))
    simp [hF0]
  rw [QinvB, intervalIntegral.integral_congr h]
  simp

theorem QinvA_eq_zero {a c t : ℝ} {F : ℝ → ℂ} (hs : SupportedIn a F) (hac : a < c) (ht : t < -a) :
    QinvA c F t = 0 := by
  have h : EqOn (fun s : ℝ => ((Real.exp (s / 2) : ℝ) : ℂ) * F s) (fun _ => 0) (uIcc (-c) t) := by
    intro s hsmem
    have hmax : s ≤ max (-c) t := by
      rcases mem_uIcc.1 hsmem with h | h
      · exact le_trans h.2 (le_max_right _ _)
      · exact le_trans h.2 (le_max_left _ _)
    have has : s < -a := lt_of_le_of_lt hmax (max_lt (by linarith) ht)
    have hF0 : F s = 0 := hs s (lt_of_lt_of_le (by linarith : a < -s) (neg_le_abs s))
    simp [hF0]
  rw [QinvA, intervalIntegral.integral_congr h]
  simp

/-- **The support is preserved**: if `F` is supported in `[-a,a]` and its transform
vanishes at `±i/2`, then the Green potential is again supported in `[-a,a]`. -/
theorem supportedIn_Qinv {a c : ℝ} {F : ℝ → ℂ} (hs : SupportedIn a F) (hac : a < c)
    (hvan : vanishesAtHalf F) : SupportedIn a (Qinv c F) := by
  intro t ht
  rcases lt_or_ge 0 t with h | h
  · have hta : a < t := by rwa [abs_of_pos h] at ht
    rw [Qinv, QinvA_eq_mellin hs hac hta, QinvB_eq_zero hs hac hta, hvan.1]
    simp
  · have hta : t < -a := by rw [abs_of_nonpos h] at ht; linarith
    rw [Qinv, QinvA_eq_zero hs hac hta, QinvB_eq_mellin hs hac hta, hvan.2]
    simp

/-- `Q` reflects positive definiteness: it multiplies the transform by `1/4 + x² > 0` on
the unitary characters, so `Q G` is positive definite only if `G` is. -/
theorem positiveDefiniteLog_of_Qlog {G : ℝ → ℂ} (hG : ContDiff ℝ 2 G)
    (hsG : HasCompactSupport G) (h : PositiveDefiniteLog (Qlog G)) : PositiveDefiniteLog G := by
  intro x
  have hz : (1 : ℂ) / 4 - (Complex.I * x) ^ 2 = ((1 / 4 + x ^ 2 : ℝ) : ℂ) := by
    push_cast
    rw [mul_pow, Complex.I_sq]
    ring
  have hmel := mellinLog_Qlog hG hsG (Complex.I * x)
  rw [hz] at hmel
  have hx : (0 : ℝ) < 1 / 4 + x ^ 2 := by positivity
  have hkey := h x
  rw [hmel, Complex.re_ofReal_mul] at hkey
  exact nonneg_of_mul_nonneg_right hkey hx

/-- **Lemma 3.3 (iii)–(iv) / Proposition 3.5.**  A continuous test function `F` supported in
`[-a,a]` whose Fourier–Mellin transform vanishes at `±i/2` is of the form `Q G`, with `G`
a `C²` test function supported in the *same* interval `[-a,a]`, and `G` is positive
definite as soon as `F` is. -/
theorem exists_Qlog_eq_of_vanishesAtHalf {a : ℝ} {F : ℝ → ℂ} (hF : Continuous F)
    (hs : SupportedIn a F) (hvan : vanishesAtHalf F) :
    ∃ G : ℝ → ℂ, ContDiff ℝ 2 G ∧ SupportedIn a G ∧ HasCompactSupport G ∧
      (PositiveDefiniteLog F → PositiveDefiniteLog G) ∧ F = Qlog G := by
  have hac : a < a + 1 := by linarith
  have hsG : SupportedIn a (Qinv (a + 1) F) := supportedIn_Qinv hs hac hvan
  have hcG : HasCompactSupport (Qinv (a + 1) F) := hasCompactSupport_of_supportedIn hsG
  refine ⟨Qinv (a + 1) F, contDiff_Qinv hF _, hsG, hcG, ?_, (Qlog_Qinv hF _).symm⟩
  intro hpd
  refine positiveDefiniteLog_of_Qlog (contDiff_Qinv hF _) hcG ?_
  rwa [Qlog_Qinv hF]

/-! ## The abstract implication of Proposition 3.5 / formula (57) -/

/-- **The division property of Proposition 3.5.**  A test function supported in `I` whose
Fourier–Mellin transform vanishes at `±1/2` is of the form `Q g` with `g` again a test
function supported in `I`, positive definite whenever `f` is.  (Analytically this is the
division of an entire function of exponential type by `1/4 - z²`, which has simple zeros at
the two points where the transform vanishes.  For an interval `I = [-a,a]` it is *proved*
in `QDivision_Icc` below, through the Green potential `Qinv`.) -/
def QDivision (I : Set ℝ) : Prop :=
  ∀ f : ℝ → ℂ, Continuous f → HasCompactSupport f → Function.support f ⊆ I →
    vanishesAtHalf f →
      ∃ g : ℝ → ℂ, ContDiff ℝ 2 g ∧ HasCompactSupport g ∧ Function.support g ⊆ I ∧
        (PositiveDefiniteLog f → PositiveDefiniteLog g) ∧ f = Qlog g

/-- A function supported in `[-a,a]` in the sense of `Function.support` is `SupportedIn a`. -/
theorem supportedIn_of_support_subset {a : ℝ} {F : ℝ → ℂ} (h : Function.support F ⊆ Icc (-a) a) :
    SupportedIn a F := by
  intro s hs
  by_contra hne
  exact absurd (abs_le.2 (mem_Icc.1 (h hne))) (not_le.2 hs)

/-- **The division property holds on every interval `[-a,a]`.**  This is Proposition 3.5 of
the paper for the intervals in which the paper uses it; it is a consequence of the
construction of the Green potential `Qinv` above. -/
theorem QDivision_Icc (a : ℝ) : QDivision (Icc (-a) a) := by
  intro f hf _ hsupp hvan
  obtain ⟨G, hG, hsG, hcG, hpd, heq⟩ :=
    exists_Qlog_eq_of_vanishesAtHalf hf (supportedIn_of_support_subset hsupp) hvan
  exact ⟨G, hG, hcG, support_subset_of_supportedIn hsG, hpd, heq⟩

/-- **The abstract implication (57) of the paper.**  If `D ∘ Q` is nonpositive on the
positive-definite test functions supported in `I`, then — granting the positivity of
`L = D + W_∞` and the division property of Proposition 3.5 — the archimedean Weil
functional `W_∞` is nonnegative on the positive-definite test functions supported in `I`
which lie in the vanishing ideal. -/
theorem Winfty_nonneg_of_D_Qlog_nonpos {I : Set ℝ} (hL : LPositivity) (hdiv : QDivision I)
    (hDQ : ∀ g : ℝ → ℂ, ContDiff ℝ 2 g → HasCompactSupport g → PositiveDefiniteLog g →
      Function.support g ⊆ I → (Dcomplex (ofLog (Qlog g))).re ≤ 0) :
    ∀ f : ℝ → ℂ, Continuous f → HasCompactSupport f → PositiveDefiniteLog f →
      Function.support f ⊆ I → vanishesAtHalf f → 0 ≤ (Winfty (ofLog f)).re := by
  intro f hf hsf hpd hsupp hvan
  obtain ⟨g, hg, hsg, hgsupp, hpdg, rfl⟩ := hdiv f hf hsf hsupp hvan
  have h1 : (Dcomplex (ofLog (Qlog g))).re ≤ 0 := hDQ g hg hsg (hpdg hpd) hgsupp
  have h2 : 0 ≤ L_real (ofLog (Qlog g)) := hL _ hf hsf hpd
  rw [L_real_eq] at h2
  linarith

/-- **The implication (57) on an interval `[-a,a]`, with no division hypothesis.**  Since
the division property is now proved (`QDivision_Icc`), the positivity of `L` is the only
remaining input: if `D ∘ Q` is nonpositive on the positive-definite test functions
supported in `[-a,a]`, then `W_∞` is nonnegative on the positive-definite test functions
supported in `[-a,a]` whose Fourier–Mellin transform vanishes at `±i/2`. -/
theorem Winfty_nonneg_of_D_Qlog_nonpos_Icc {a : ℝ} (hL : LPositivity)
    (hDQ : ∀ g : ℝ → ℂ, ContDiff ℝ 2 g → HasCompactSupport g → PositiveDefiniteLog g →
      Function.support g ⊆ Icc (-a) a → (Dcomplex (ofLog (Qlog g))).re ≤ 0) :
    ∀ f : ℝ → ℂ, Continuous f → HasCompactSupport f → PositiveDefiniteLog f →
      Function.support f ⊆ Icc (-a) a → vanishesAtHalf f → 0 ≤ (Winfty (ofLog f)).re :=
  Winfty_nonneg_of_D_Qlog_nonpos hL (QDivision_Icc a) hDQ

/-! ## The small-support corollary -/

/-- **`D ∘ Q` is strictly negative on test functions with small support.**  There is an
`a > 0` such that every `C²` test function `ξ` supported in `|log ρ| ≤ a` satisfies
`D(Q(ξ ∗ ξ*)) ≤ -‖ξ‖²`.  This is `essential_negativity_strict` restated in terms of the
pairing `D_Q_pairing`. -/
theorem small_support_DQ_negative :
    ∃ a : ℝ, 0 < a ∧ ∀ F : ℝ → ℂ, ContDiff ℝ 2 F → SupportedIn a F →
      D_Q_pairing F ≤ -L2sq F := by
  obtain ⟨a, ha, h⟩ := essential_negativity_strict
  exact ⟨a, ha, fun F hF hsupp => h F hF hsupp⟩

/-- The same statement for the functional `D` written on `ℝ⋆₊`. -/
theorem small_support_D_Qlog_nonpos :
    ∃ a : ℝ, 0 < a ∧ ∀ F : ℝ → ℂ, ContDiff ℝ 2 F → SupportedIn a F →
      (Dcomplex (ofLog (Qlog (convLog F (starLog F))))).re ≤ -L2sq F := by
  obtain ⟨a, ha, h⟩ := small_support_DQ_negative
  refine ⟨a, ha, fun F hF hsupp => ?_⟩
  rw [← D_Q_pairing_eq]
  exact h F hF hsupp

/-- **The corresponding statement for `W_∞` on the vanishing ideal.**  Granting the
positivity of `L = D + W_∞`, the archimedean Weil functional is not merely nonnegative but
bounded below by `‖ξ‖²` on the elements `Q(ξ ∗ ξ*)` of the vanishing ideal whose support is
small enough.  (The passage from `Q(ξ ∗ ξ*)` to a general positive-definite element of the
vanishing ideal supported in the same interval is the division property `QDivision`, cf.
`Winfty_nonneg_of_D_Qlog_nonpos`.) -/
theorem small_support_Winfty_ge (hL : LPositivity) :
    ∃ a : ℝ, 0 < a ∧ ∀ F : ℝ → ℂ, ContDiff ℝ 2 F → SupportedIn a F →
      L2sq F ≤ (Winfty (ofLog (Qlog (convLog F (starLog F))))).re := by
  obtain ⟨a, ha, h⟩ := small_support_D_Qlog_nonpos
  refine ⟨a, ha, fun F hF hsupp => ?_⟩
  have hsF : HasCompactSupport F := hasCompactSupport_of_supportedIn hsupp
  have hconv : ContDiff ℝ 2 (convLog F (starLog F)) := contDiff_convLog_starLog_self hF hsF
  have hsconv : HasCompactSupport (convLog F (starLog F)) :=
    hasCompactSupport_convLog hsF (hasCompactSupport_starLog hsF)
  have hcont : Continuous (Qlog (convLog F (starLog F))) := continuous_Qlog hconv
  have hscomp : HasCompactSupport (Qlog (convLog F (starLog F))) :=
    hasCompactSupport_Qlog hsconv
  have hpd : PositiveDefiniteLog (Qlog (convLog F (starLog F))) :=
    positiveDefiniteLog_Qlog hconv hsconv
      (positiveDefiniteLog_convLog_starLog hF.continuous hsF)
  have h2 : 0 ≤ L_real (ofLog (Qlog (convLog F (starLog F)))) := hL _ hcont hscomp hpd
  rw [L_real_eq] at h2
  have h1 := h F hF hsupp
  linarith

/-- In particular, on test functions with small enough support `W_∞` is nonnegative on the
elements `Q(ξ ∗ ξ*)` of the vanishing ideal. -/
theorem small_support_Winfty_nonneg (hL : LPositivity) :
    ∃ a : ℝ, 0 < a ∧ ∀ F : ℝ → ℂ, ContDiff ℝ 2 F → SupportedIn a F →
      0 ≤ (Winfty (ofLog (Qlog (convLog F (starLog F))))).re := by
  obtain ⟨a, ha, h⟩ := small_support_Winfty_ge hL
  exact ⟨a, ha, fun F hF hsupp => le_trans (L2sq_nonneg F) (h F hF hsupp)⟩

/-! ## From the additive coordinate `t = log ρ` to the multiplicative formulation

The whole file is written in the additive coordinate `t = log ρ`.  The lemmas of this
section are the dictionary with the multiplicative objects of the paper (`D`, `delta`,
`Rplus.haar`, `starInvolution`, …).  The only bridges needed are `ofLog` together with
`Dcomplex_ofLog` and `D_Q_pairing_eq`: everything below is deduced from them, no new
object is introduced. -/

/-- A function on `ℝ⋆₊`, read in the logarithmic coordinate and back, is itself (a function
vanishing off `ℝ⋆₊` being determined by its restriction). -/
theorem ofLog_comp_exp {f : ℝ → ℂ} (hf : ∀ x ≤ (0 : ℝ), f x = 0) :
    ofLog (fun t => f (Real.exp t)) = f := by
  funext x
  rcases lt_or_ge 0 x with h | h
  · simp only [ofLog, if_pos h, Real.exp_log h]
  · simp only [ofLog, if_neg (not_lt.2 h), (hf x h).symm]

/-- The involution `F ↦ F*` of the additive coordinate is the involution
`f*(ρ) = conj (f (ρ⁻¹))` of the paper. -/
theorem ofLog_starLog {F : ℝ → ℂ} {x : ℝ} (hx : 0 < x) :
    ofLog (starLog F) x = starInvolution (ofLog F) x := by
  have hxi : (0 : ℝ) < x⁻¹ := inv_pos.2 hx
  simp only [ofLog, starInvolution, if_pos hx, if_pos hxi, starLog]
  rw [Real.log_inv]

/-- `D` written on `ℝ⋆₊`: the pairing of a test function with the trace remainder `δ`
against the multiplicative Haar measure. -/
theorem Dcomplex_ofLog_haar (G : ℝ → ℂ) :
    Dcomplex (ofLog G) = ∫ ρ : Rplus, G (Real.log (ρ : ℝ)) * ((delta ρ : ℝ) : ℂ) ∂(Rplus.haar) := by
  rw [Dcomplex_ofLog, Rplus.integral_haar]
  refine integral_congr_ae (Filter.Eventually.of_forall fun t => ?_)
  show G t * _ = G (Real.log (Real.exp t)) * _
  rw [Real.log_exp]

/-- For a real valued test function, `Dcomplex` is the functional `D` of
`RequestProject/TraceRemainder.lean`. -/
theorem Dcomplex_ofLog_eq_D (g : Rplus → ℝ) :
    (Dcomplex (ofLog (fun t => ((g (Rplus.expHomeo t) : ℝ) : ℂ)))).re = D g := by
  rw [Dcomplex_ofLog_haar, D_eq]
  have h : ∀ ρ : Rplus, ((g (Rplus.expHomeo (Real.log (ρ : ℝ))) : ℝ) : ℂ) * ((delta ρ : ℝ) : ℂ)
      = ((g ρ * delta ρ : ℝ) : ℂ) := by
    intro ρ
    rw [show Rplus.expHomeo (Real.log (ρ : ℝ)) = ρ from Subtype.ext (Real.exp_log ρ.2),
      Complex.ofReal_mul]
  rw [integral_congr_ae (Filter.Eventually.of_forall h), integral_complex_ofReal,
    Complex.ofReal_re]

/-- The `L²` norm in the two coordinates: `∫ |ξ(t)|² dt = ∫ |ξ(ρ)|² d*ρ`. -/
theorem L2sq_haar (f : Rplus → ℂ) :
    L2sq (fun t => f (Rplus.expHomeo t)) = ∫ ρ : Rplus, ‖f ρ‖ ^ 2 ∂(Rplus.haar) := by
  rw [L2sq, Rplus.integral_haar]

/-- A test function on `ℝ⋆₊` supported in `{ρ : |log ρ| ≤ a}` is `SupportedIn a` in the
logarithmic coordinate. -/
theorem supportedIn_comp_expHomeo {a : ℝ} {f : Rplus → ℂ}
    (h : ∀ ρ : Rplus, a < |Real.log (ρ : ℝ)| → f ρ = 0) :
    SupportedIn a (fun t => f (Rplus.expHomeo t)) := by
  intro t ht
  exact h (Rplus.expHomeo t) (by rwa [Rplus.expHomeo_apply, Real.log_exp])

/-- The pairing realising `D ∘ Q`, written on `ℝ⋆₊`. -/
theorem D_Q_pairing_haar (F : ℝ → ℂ) :
    D_Q_pairing F = (∫ ρ : Rplus, Qlog (convLog F (starLog F)) (Real.log (ρ : ℝ))
      * ((delta ρ : ℝ) : ℂ) ∂(Rplus.haar)).re := by
  rw [D_Q_pairing_eq, Dcomplex_ofLog_haar]

/-- **Corollary 3.8 in the multiplicative language.**  There is an `a > 0` such that every
test function `ξ` on `ℝ⋆₊` supported in `{ρ : |log ρ| ≤ a}` (and `C²` in the logarithmic
coordinate) satisfies `D(Q(ξ ∗ ξ*)) ≤ -‖ξ‖²`, all integrals being taken against the
multiplicative Haar measure `d*ρ`. -/
theorem small_support_D_Qlog_nonpos_mul :
    ∃ a : ℝ, 0 < a ∧ ∀ f : Rplus → ℂ, ContDiff ℝ 2 (fun t => f (Rplus.expHomeo t)) →
      (∀ ρ : Rplus, a < |Real.log (ρ : ℝ)| → f ρ = 0) →
      (∫ ρ : Rplus, Qlog (convLog (fun t => f (Rplus.expHomeo t))
            (starLog (fun t => f (Rplus.expHomeo t)))) (Real.log (ρ : ℝ)) * ((delta ρ : ℝ) : ℂ)
          ∂(Rplus.haar)).re
        ≤ -(∫ ρ : Rplus, ‖f ρ‖ ^ 2 ∂(Rplus.haar)) := by
  obtain ⟨a, ha, h⟩ := small_support_D_Qlog_nonpos
  refine ⟨a, ha, fun f hf hsupp => ?_⟩
  have hkey := h _ hf (supportedIn_comp_expHomeo hsupp)
  rwa [Dcomplex_ofLog_haar, L2sq_haar] at hkey

/-- **The same corollary for `W_∞`, in the multiplicative language.**  Granting the
positivity of `L = D + W_∞`, the archimedean Weil functional satisfies
`W_∞(Q(ξ ∗ ξ*)) ≥ ‖ξ‖²` for every test function `ξ` on `ℝ⋆₊` supported in
`{ρ : |log ρ| ≤ a}`. -/
theorem small_support_Winfty_ge_mul (hL : LPositivity) :
    ∃ a : ℝ, 0 < a ∧ ∀ f : Rplus → ℂ, ContDiff ℝ 2 (fun t => f (Rplus.expHomeo t)) →
      (∀ ρ : Rplus, a < |Real.log (ρ : ℝ)| → f ρ = 0) →
      (∫ ρ : Rplus, ‖f ρ‖ ^ 2 ∂(Rplus.haar))
        ≤ (Winfty (ofLog (Qlog (convLog (fun t => f (Rplus.expHomeo t))
            (starLog (fun t => f (Rplus.expHomeo t))))))).re := by
  obtain ⟨a, ha, h⟩ := small_support_Winfty_ge hL
  refine ⟨a, ha, fun f hf hsupp => ?_⟩
  have hkey := h _ hf (supportedIn_comp_expHomeo hsupp)
  rwa [L2sq_haar] at hkey

end ConnesConsani.WeilPositivity
