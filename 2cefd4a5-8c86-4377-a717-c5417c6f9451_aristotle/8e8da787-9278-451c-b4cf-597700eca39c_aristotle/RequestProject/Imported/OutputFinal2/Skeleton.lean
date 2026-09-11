/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal2.WeilDistribution

/-!
# Weil positivity – archimedean place: status of the formalization

This file records the original informal skeleton of arXiv:2006.13771 that this project
started from, and maps each of its items to what is now actually formalized (and proved)
in the other files of the project.

## What is formalized and proved

* `RequestProject/Basic.lean`
  - `Rplus`, the multiplicative group `ℝ⋆₊ = (0,∞)`, with its topological group,
    measurable and locally compact structures;
  - `Rplus.expHomeo`, the homeomorphism `ℝ ≃ₜ ℝ⋆₊`, and `Rplus.expMulEquiv`;
  - `Rplus.haar`, the Haar measure `d*ρ = dρ/ρ`, with proofs that it is left invariant,
    σ-finite and a Haar measure, the integration formula
    `∫ f(ρ) d*ρ = ∫ f(e^t) dt` and the inversion invariance `∫ f(ρ⁻¹) d*ρ = ∫ f(ρ) d*ρ`.

* `RequestProject/SineIntegral.lean`
  - `Si`, the sine integral, its oddness, differentiability and continuity;
  - `siDiv`, the normalized sine integral `a ↦ Si(a)/a` (extended by `1` at `0`), its
    integral representation, its continuity and its differentiability (including at `0`,
    where the derivative vanishes);
  - `integral_cos_mul_neg_log`: `∫₀¹ cos(a t)(-log t) dt = Si(a)/a`, the analytic
    identity behind formula (49) of the paper.

* `RequestProject/SiPositivity.lean`
  - `Si_pos`: the sine integral is strictly positive on `(0,∞)` (proved through the
    alternating half-arch decomposition `Si((k+1)π) - Si(kπ) = (-1)^k ∫₀^π sin u/(kπ+u) du`),
    together with `Si_nonneg` and `siDiv_pos`.

* `RequestProject/TraceRemainder.lean`
  - `delta`, the trace-remainder function `δ` of §2, defined by the integral formula (48)
    on `[1,∞)` and extended by the symmetry `δ(ρ) = δ(ρ⁻¹)`;
  - `delta_symmetric` (Proposition 2.2 (ii)), `delta_explicit` (formula (49)),
    `delta_one` (the constant term of the expansion (50)) and `delta_continuous`;
  - `delta_pos`: `δ(ρ) > 0` for every `ρ`, the positivity asserted in §2 of the paper as a
    consequence of the positivity of the sine integral;
  - `deltaReal_hasDerivWithinAt_Ici_one` and `deltaReal_hasDerivWithinAt_Iic_one`: the
    one-sided derivatives of `δ` at `ρ = 1` are `+1` and `-1`, so that `δ'` jumps by `2`
    there — the linear term of the expansion (50) and the source of the negativity
    statements of §4;
  - `D`, the functional `D(f) = ∫ f(ρ⁻¹) δ(ρ) d*ρ` of (9), and `D_eq`.

* `RequestProject/Sonin.lean`
  - `cutoff`, multiplication by the indicator function of a measurable set, as a bounded
    operator of `L²(ℝ)`, with proofs that it is an idempotent self-adjoint operator;
  - `P1` and `P1hat`, the cutoff projections in space and in frequency (the latter is the
    conjugate of the former by the `L²` Fourier transform);
  - `SoninSpace`, Sonin's space, with `mem_SoninSpace_iff` identifying it with the space
    of `ξ` such that `ξ` and its Fourier transform vanish a.e. on `[-1,1]`, and
    `SoninSpace_eq_orthogonal`, the identity `S = 1 - (P₁ ∨ P̂₁)` in the form
    `SoninSpace = (range P₁ ⊔ range P̂₁)ᗮ`;
  - `SoninProjection`, the orthogonal projection `S`, shown to be self-adjoint,
    idempotent and positive.

* `RequestProject/Scaling.lean`
  - `scaling`, the unitary scaling representation `ϑ` of `ℝ⋆₊`, realized as the regular
    representation on `L²(ℝ⋆₊, d*ρ)`, with the representation law `ϑ(ab) = ϑ(a)ϑ(b)`;
  - `logCoordinates`, the isometry onto `L²(ℝ, dt)` given by `ρ = e^t`.

* `RequestProject/WeilDistribution.lean`
  - `sharp`, the involution `f♯(x) = x⁻¹f(x⁻¹)`, and `sharp_sharp`;
  - `WeilR`, the archimedean Weil distribution of formula (150), and `Winfty = -WeilR`;
  - `WeilR_explicit`, the locally rational form of the distribution away from `ρ = 1`:
    for a test function vanishing at `1` (and with the resulting integrals absolutely
    convergent) `W_ℝ` is the integral of `f` against the rational weight `x/(x²-1)` on
    `(1,∞)` and `1/(1-x²)` on `(0,1)`, together with the change of variables `u = x⁻¹`
    `integral_Ioo_zero_one_eq_integral_Ioi_one` used to prove it;
  - `deltaHalfInv_starInvolution`, the compatibility of the `∆^{1/2}` normalization with
    the two involutions.

* `RequestProject/Mellin.lean`
  - `mellinMul` and `mellinLog`, the Fourier–Mellin transform of a test function on
    `ℝ⋆₊` in multiplicative and in logarithmic coordinates, and their agreement;
  - `Qlog`, the operator `Q = -(ρ∂_ρ)² + 1/4` in logarithmic coordinates, with
    `support_Qlog_subset` (it preserves the support), `mellinLog_Qlog`
    (`Q` multiplies the transform by `1/4 - z²`) and `mellinLog_Qlog_half` (the image of
    `Q` lies in the ideal of functions whose transform vanishes at `±i/2`);
  - `convLog` and `starLog`, the convolution product and the involution, with
    `convLog_comm`, `convLog_assoc` and `starLog_convLog` (the `*`-algebra laws),
    `mellinLog_convLog`, `mellinLog_starLog`, and the positive definiteness
    `mellinLog_convLog_starLog_self` (the transform of `f ∗ f*` is `|f̂|²`);
  - `mellinLog_Qlog_convLog_starLog`, i.e. `Q` preserves positive definiteness.

* `RequestProject/JumpFormula.lean`
  - `corner`, the function built from two smooth pieces glued at `t = 0`;
  - `integral_deriv2_mul_corner` and `integral_Qlog_mul_corner`, integration by parts
    against a function with a corner, the extra term being the jump of the derivative;
  - `integral_Qlog_convLog_starLog_mul_corner`, the elementary form of the essential
    negativity: pairing `Q(ξ ∗ ξ*)` with a corner function whose derivative jumps by `2`
    gives `-2‖ξ‖²` plus the pairing of `ξ ∗ ξ*` with the smooth kernel `Qg`.

* `RequestProject/SiSmooth.lean`
  - `contDiff_siDiv`, the smoothness of the normalized sine integral, obtained by
    differentiating under the integral sign in the representation of `siDiv`.

* `RequestProject/DeltaSmooth.lean`
  - `deltaPieceR`, `deltaPieceL`, the two smooth pieces of `δ` in the logarithmic
    coordinate, with `contDiff_deltaPieceR`/`contDiff_deltaPieceL`, `deltaPiece_jump`
    (the derivative jumps by `2` at `ρ = 1`) and `corner_deltaPiece`;
  - `essential_negativity_delta` and `essential_negativity_delta_haar`, the essential
    negativity identity `D(Q(ξ ∗ ξ*)) = -2‖ξ‖² + ⟨ξ ∗ ξ*, Qδ⟩` of §4 and §6.

* `RequestProject/RemainderBound.lean`
  - `norm_convLog_starLog_self_le`, the bound `‖(ξ ∗ ξ*)(t)‖ ≤ ‖ξ‖²`, and
    `convLog_starLog_self_eq_zero`, the support bound for `ξ ∗ ξ*`;
  - `essential_negativity_quantitative`: for test functions supported in a fixed compact
    subset of `ℝ⋆₊`, the remainder in the identity above is bounded by a constant
    multiple of `‖ξ‖²`, so `D ∘ Q` is `-2‖ξ‖²` up to a bounded term;
  - `essential_negativity_strict`: consequently there is an `a > 0` such that
    `Re D(Q(ξ ∗ ξ*)) ≤ -‖ξ‖²` for every test function supported in `|log ρ| ≤ a`.

* `RequestProject/Positivity.lean`
  - `L2sq`, `SupportedIn` and the support/smoothness bookkeeping for test functions,
    including `supportedIn_Qlog_convLog_starLog` (`Q(ξ ∗ ξ*)` is supported in `[-2a,2a]`
    when `ξ` is supported in `[-a,a]`);
  - `D_Q_pairing`, the real part of the logarithmic pairing that realizes
    `D(Q(ξ ∗ ξ*))`, `Dcomplex`, the functional `D` for complex valued test functions,
    `ofLog` (reading a function of `t = log ρ` as a function of `ρ`) and
    `Dcomplex_ofLog`, `D_Q_pairing_eq` identifying the two;
  - `Lfun = Dcomplex + Winfty` and `L_real`, the functional `L = D + W_∞` of (9), with
    `L_real_eq`;
  - `PositiveDefiniteLog`, positive definiteness read on the Fourier–Mellin transform,
    with `positiveDefiniteLog_convLog_starLog` and `positiveDefiniteLog_Qlog`;
  - `vanishesAtHalf`, the vanishing ideal `J` (transform vanishing at `±i/2`), and
    `vanishesAtHalf_Qlog`: `Q` implements the vanishing conditions; the package
    `Qlog_convLog_starLog_mem_vanishingIdeal` collects the three properties of
    `Q(ξ ∗ ξ*)` used in §3–§4;
  - `LPositivity` and `L_positive`, the positivity of `L`, which is the single analytic
    input **left as `sorry`**: it requires the operator trace identity
    `L(f) = Tr(ϑ(f) P P̂ P)`.  Every statement below takes it as an explicit hypothesis
    instead of using it;
  - `QDivision` and `Winfty_nonneg_of_D_Qlog_nonpos`, the abstract implication of
    Proposition 3.5 / formula (57): `D ∘ Q ≤ 0` on positive-definite functions supported
    in `I` implies `W_∞ ≥ 0` on `C_c^∞(I) ∩ J`;
  - `Qinv`, the Green potential of `Q` (convolution with the fundamental solution
    `e^{-|t|/2}`), with `Qlog_Qinv` (`Q` is inverted by it), `contDiff_Qinv` (it gains two
    derivatives) and `supportedIn_Qinv` (the support is preserved *exactly* when the
    transform vanishes at `±i/2`, the two boundary values of the potential being the
    values of the transform at those two points).  This yields
    `exists_Qlog_eq_of_vanishesAtHalf`, i.e. **Lemma 3.3 (iii)–(iv) / Proposition 3.5**
    (division by `1/4 - z²` inside the test functions with the same support, preserving
    positive definiteness — `positiveDefiniteLog_of_Qlog`), the division property
    `QDivision_Icc` on every interval `[-a,a]`, and
    `Winfty_nonneg_of_D_Qlog_nonpos_Icc`, the implication (57) with the positivity of `L`
    as its only remaining hypothesis;
  - `small_support_DQ_negative` and `small_support_D_Qlog_nonpos`, the small-support
    corollary of `essential_negativity_strict` (`D(Q(ξ ∗ ξ*)) ≤ -‖ξ‖²`), and
    `small_support_Winfty_ge` / `small_support_Winfty_nonneg`, the corresponding lower
    bounds `W_∞(Q(ξ ∗ ξ*)) ≥ ‖ξ‖² ≥ 0` granted the positivity of `L`;
  - the dictionary between the additive coordinate `t = log ρ` and the multiplicative
    formulation of the paper: `ofLog_comp_exp`, `ofLog_starLog` (the involution `F ↦ F*`
    is `f*(ρ) = conj f(ρ⁻¹)`), `Dcomplex_ofLog_haar` and `Dcomplex_ofLog_eq_D` (`D` as an
    integral against `d*ρ`, and its agreement with the real functional `D`), `L2sq_haar`,
    `supportedIn_comp_expHomeo` and `D_Q_pairing_haar`; with them
    `small_support_D_Qlog_nonpos_mul` and `small_support_Winfty_ge_mul` state Corollary
    3.8 directly in the multiplicative language of the paper.

* `RequestProject/FourierSide.lean`
  - `thetaDeriv`, the derivative `θ'` of the Riemann–Siegel angular function, defined
    through Mathlib's digamma function by `2θ'(t) = -log π + Re ψ(1/4 + it/2)`
    (formula (154) and Appendix B), with `digamma_conj` (Schwarz reflection for `Γ`),
    `thetaDeriv_even` and `continuous_thetaDeriv`;
  - `deltaFourier`, the Fourier transform `δ̂(t) = ∫ δ(ρ) ρ^{-it} d*ρ` of the trace
    remainder, written as the cosine transform of `δ` in the logarithmic coordinate, with
    the integrability lemmas coming from the decay of `δ`, `deltaFourier_even`,
    `deltaFourier_zero_pos`, and `mellinLog_delta_eq_deltaFourier` identifying it with the
    Fourier–Mellin transform of `δ` on the unitary characters;
  - `deltaFourier_zero_le` and `deltaFourier_zero_le_pi`, the explicit bounds
    `δ̂(0) ≤ 16 Si π + 16 ≤ 16π + 16`, from the decay `δ(e^u) ≤ (4 Si π + 4) e^{-|u|/2}`;
  - `abs_deltaFourier_le`, the bound `|δ̂(t)| ≤ δ̂(0)` (the maximum of the transform of the
    positive function `δ` is at the origin), `fourierSide`, the function `2θ' + δ̂` of
    Corollary 2.3, with `fourierSide_even` and `continuous_fourierSide`, and
    `fourierSide_nonneg_of_monotoneOn`, which reduces the Fourier-side inequality to a
    *single-point* bound at the origin as soon as `2θ' + δ̂` is monotone on `[0,∞)`;
  - `thetaDeriv_zero`, `fourierSide_zero` and `fourierSide_zero_nonneg_iff`, which make
    that single-point bound explicit: `2θ'(0) + δ̂(0) = δ̂(0) - (log π - Re ψ(1/4))`, so
    the inequality at the origin *is* the real-number comparison
    `δ̂(0) ≥ log π - Re ψ(1/4)`; `fourierSide_nonneg_of_monotoneOn_of_deltaFourier_zero`
    combines the two reductions;
  - `thetaDeriv_asymptotic`, the classical asymptotic `θ'(t) ~ (1/2) log(t/2π)`, **proved**
    from the vertical-line formula of `RequestProject/DigammaAsymptotic.lean`;
  - `two_thetaDeriv_add_deltaFourier_nonneg`, the inequality `2θ'(t) + δ̂(t) ≥ 0` of
    Corollary 2.3 (ii), and `LPositivity_of_fourierSide_nonneg`, which records that this
    inequality gives the positivity of `L`.  Both are **stated but left as `sorry`**: they
    need, respectively, the trace identity of §2 and the Bochner-type integrability of the
    transform of a positive definite test function.  (The inequality *is* proved outside a
    bounded interval — explicitly, for `|t| ≥ 60` — in `RequestProject/ThetaGrowth.lean`;
    see `RequestProject/DeltaDecay.lean` for the decay of `δ̂` that makes the threshold
    small.)

* `RequestProject/KernelBound.lean` — an *explicit* bound for the kernel `Qδ`
  - `integral_sq_neg_log`, `abs_cosMoment_two_le`, `abs_sinMoment_one_le` and the sharper
    large-argument bounds `abs_sinMoment_one_le_of_twelve_le`,
    `abs_cosMoment_two_le_of_twelve_le`, obtained from the closed forms
    `sinMoment_one_eq`, `cosMoment_two_eq` of the moments through the sine integral;
  - `Qdel` and `Qlog_deltaPieceR_apply` / `Qlog_deltaPieceL_apply`: the closed form
    `Qδ(e^t) = 2 e^{t/2}(2c e^t (S₁(u₊)+S₁(u₋)) + c² e^{2t}(C₂(u₊)+C₂(u₋)))`,
    `c = 2π`, `u± = c(e^t ± 1)`;
  - `norm_Qdelta_le`: **`|Qδ(e^t)| ≤ 14` for `|t| ≤ 1/15`**, the proved replacement of the
    numerical verification behind Figure 8 of the paper.

* `RequestProject/Effective.lean` — Corollary 3.8 with explicit constants
  - `measurable_Qdelta`, `integrableOn_norm_Qdelta` and
    `norm_integral_mul_Qdelta_le_of_kernel_integral`, the remainder bound in terms of the
    paper's criterion `∫₀ˢ |Qδ(e^x)| dx ≤ M/2`;
  - `DQ_nonpos_of_kernel_integral`: **`Re D(Q f) ≤ -(2 - M) f(1)`** for every `C²` test
    function supported in `{|log ρ| ≤ s}` with `|f| ≤ f(1)`, whenever
    `∫_{-s}^{s} |Qδ| ≤ M`.  This is Corollary 3.8 with *no* existential quantifier and no
    hidden numerics: the criterion is an explicit hypothesis.  `DQ_nonpos_of_paper_criterion`
    is the case `M = 2`, i.e. exactly the paper's numerical input; with the paper's values
    `u = 1.10246` (Corollary 3.8) and `u = 1.15077` (Remark 3.9, Boas–Kac) it returns the
    paper's statements;
  - `integral_norm_Qdelta_le`, the criterion **proved unconditionally for `s = 1/15`**
    (`∫_{-1/15}^{1/15}|Qδ| ≤ 28/15 < 2`), and hence `DQ_nonpos_effective`:
    `Re D(Q f) ≤ -(2/15) f(1)` for `f` supported in `[u⁻¹,u]` with `u = e^{1/15} = 1.0689…`;
  - `DQ_convLog_starLog_effective`, `Dcomplex_Qlog_convLog_effective`,
    `Winfty_ge_effective` and `DQ_effective_mul`: the same statements for convolution
    squares `ξ ∗ ξ*` with `ξ` supported in `{|log ρ| ≤ 1/30}` (`D(Q(ξ ∗ ξ*)) ≤ -(2/15)‖ξ‖²`,
    and `W_∞(Q(ξ ∗ ξ*)) ≥ (2/15)‖ξ‖²` granted the positivity of `L`).  The existential
    `∃ a > 0` of `small_support_DQ_negative` is thus replaced by the explicit `a = 1/30`.

* `RequestProject/Parseval.lean` — the Parseval computation (52)
  - `fourierLog`, the transform `f̂(t) = ∫ f(u) e^{itu} du` in the logarithmic coordinate,
    with the dictionary `fourierLog_eq_fourier` to Mathlib's `𝓕` and the inversion formula
    `fourierLog_inversion` in the normalization of the paper;
  - `fourierLog_delta`, the transform of `δ` computed as `δ̂`, and
    **`Dcomplex_parseval`: `D(f) = (2π)⁻¹ ∫ f̂(t) δ̂(t) dt`** — the `D`-half of (52), proved
    by Fourier inversion and Fubini;
  - `WinftyParseval`, a first attempt at the `W_∞`-half of (52), carried as an explicit
    `Prop`-valued hypothesis.  It is **not** the archimedean explicit formula: it pairs
    `W_∞(ofLog F)` with `2θ'`, whereas the paper applies the distribution (150) to
    `∆^{-1/2} f` (§1, after formula (39)).  The two differ by a nonzero functional, so
    `WinftyParseval` is superseded by `WinftyParsevalNorm` of
    `RequestProject/ArchimedeanExplicit.lean`, which is *proved* there;
  - **`L_parseval`: identity (52), `L(f) = (2π)⁻¹ ∫ f̂(t)(2θ'(t) + δ̂(t)) dt`**, granting
    `WinftyParseval`, and `L_real_nonneg_of_fourierSide_nonneg`, the positivity of `L`
    deduced from the pointwise inequality `2θ' + δ̂ ≥ 0` — for test functions whose
    transform is integrable.  The unconditional statement `LPositivity` quantifies over
    all continuous compactly supported positive definite test functions, for which the
    integrability of `f̂` is a theorem of Bochner type that is not formalized here; so
    `LPositivity_of_fourierSide_nonneg` remains a `sorry`, and the small-support results
    that take `LPositivity` as a hypothesis are **not** unconditional.

* `RequestProject/ArchimedeanKernel.lean` — the analysis behind the explicit formula
  - `poleA`, `poleB`, the poles `n + 1/4` of `Γ` on the line and the exponents
    `bₙ = 2n + 1/2`;
  - `sinhKernel`, the kernel `κ(u) = e^{|u|/2}/(e^{|u|} - e^{-|u|})` of the explicit
    formula in the logarithmic coordinate, with `sinhKernel_even`, `sinhKernel_nonneg`
    and `hasSum_sinhKernel`, the expansion `κ(u) = ∑_{n≥0} e^{-bₙ|u|}`;
  - `fourierLog_expNegAbs`, the Fourier transform `∫ e^{-b|v|} e^{itv} dv = 2b/(b²+t²)` of
    the Poisson kernel, and `integral_fourierLog_mul_poisson`, the multiplication formula
    `(2π)⁻¹ ∫ Ĝ(t)·2b/(b²+t²) dt = ∫ G(u) e^{-b|u|} du`;
  - `integral_sinhKernel_const`, the elementary constant
    `∫₀^∞ (e^{u/2}-1)/(e^u - e^{-u}) du = (log 2)/2 + π/4`, proved through the explicit
    antiderivative `sinhKernelPrimitive`.

* `RequestProject/ArchimedeanExplicit.lean` — **the archimedean explicit formula**
  - `digammaDiff`, `digammaTerm`, and the two classical facts about the digamma function
    that Mathlib does not have, stated as `Prop`s (not as axioms): `DigammaPartialFractions`
    (Gauss' partial-fraction expansion of `ψ` read on the line `1/4 + it/2`) and
    `DigammaQuarter` (`ψ(1/4) = -γ - 3 log 2 - π/2`).  Both are **theorems** here
    (`digammaPartialFractions`, `digammaQuarter`), proved in
    `RequestProject/Digamma.lean`, so nothing in this file is conditional;
  - `integral_fourierLog_mul_digammaTerm` and
    **`integral_fourierLog_mul_digammaDiff`**, the spectral side:
    `(2π)⁻¹ ∫ Ĝ(t)(Re ψ(1/4+it/2) - ψ(1/4)) dt = ∫ (G(0) - G(u)) κ(u) du`, obtained by
    summing the Poisson multiplication formula over the poles — the interchange of the
    sum and the integral is proved, not assumed (`summable_integral_norm_digammaTerm`,
    `summable_integral_norm_expNegAbs`, and the kernel estimate
    `abs_mul_sinhKernel_le`: `|u| κ(u) ≤ 5 e^{-|u|/4}`);
  - **`WeilR_deltaHalfInv_ofLog`**, the geometric side: formula (150) applied to
    `∆^{-1/2}(G ∘ log)`, rewritten by the change of variables `x = e^u` as
    `(log 4π + γ) G(0) + ∫₀^∞ (e^{u/2}(G(u)+G(-u)) - 2G(0)) du/(e^u - e^{-u})`;
  - **`Winfty_deltaHalfInv_ofLog` / `WinftyParsevalNorm_of_digamma`**: the archimedean
    explicit formula `W_∞(∆^{-1/2}f) = (2π)⁻¹ ∫ f̂(t) 2θ'(t) dt`, proved unconditionally.
    All the Fourier analysis it needs is proved in the project;
  - **`LfunNorm`, `LfunNorm_parseval`**: identity (52) in the normalization of the paper,
    `L(f) = (2π)⁻¹ ∫ f̂(t)(2θ'(t) + δ̂(t)) dt`, with *both* halves proved, and
    `LfunNorm_re_nonneg_of_fourierSide_nonneg`, the positivity of `L` on positive definite
    test functions with integrable transform, granted the Fourier-side inequality;
  - `fourierSide_threshold_eq` and `fourierSide_zero_eq`: with Gauss' value of `ψ(1/4)`,
    the inequality at the origin reads `δ̂(0) ≥ log π + γ + 3 log 2 + π/2`.

* `RequestProject/Digamma.lean` — **the digamma function**, developed from scratch
  - the real side: `psiR = (log Γ)'`, with `psiR_add_one`, `psiR_one`, `psiR_monotoneOn`,
    `tendsto_psiR_shift` and **`hasSum_psiR`**, Gauss' partial fractions on `(0,∞)`;
  - the complex side: `digamma_ofReal`, `differentiableOn_digamma`, and
    **`hasSum_digamma`**: `ψ(s) = -γ + ∑_{n≥0} (1/(n+1) - 1/(n+s))` on `Re s > 0`, obtained
    from the real case by the identity theorem;
  - the reflection and duplication formulas for the logarithmic derivative of `Γ`
    (`digamma_add_digamma_add_half`, `digamma_sub_digamma_one_sub`) and, from them,
    **`digamma_quarter`: `ψ(1/4) = -γ - 3 log 2 - π/2`** (Gauss' digamma theorem).

* `RequestProject/DigammaAsymptotic.lean` — **`ψ` on a vertical line**
  - `poleTerm`, `logTerm`, `errTerm`, the summand `(x+a)/((x+a)²+b²)`, its primitive
    `(1/2) log((x+a)²+b²)`, and the error in the resulting telescoping;
  - `abs_errTerm_le` (mean value theorem) and `sum_inv_poleDen_le`
    (`∑_n 1/((n+a)²+b²) ≤ 1/(a²+b²) + π/(2b)`, by telescoping against `arctan`);
  - **`digamma_re_eq`**: the exact formula
    `Re ψ(a+ib) = (1/2) log(a²+b²) - E(a,b)` with `|E(a,b)| ≤ 1/(a²+b²) + π/(2b)`
    (`abs_tsum_errTerm_le`), and **`tendsto_digamma_re_sub_log`**:
    `Re ψ(a+ib) - log b → 0`.  This is the Stirling input the paper uses, in the only form
    it is needed.

* `RequestProject/ThetaGrowth.lean` — the shape of the Fourier side `2θ' + δ̂`
  - `two_thetaDeriv_eq`, `thetaDeriv_monotoneOn` and `thetaDeriv_le_of_abs_le`: `2θ'` is
    **increasing in `|t|`**, every term of the partial-fraction expansion being increasing
    in `t²`;
  - `tendsto_thetaDeriv_atTop` and `tendsto_fourierSide_atTop`: `2θ'(t) → ∞`, the limits
    `1/(n+1/4)` of the individual terms being non-summable, hence `2θ' + δ̂ → ∞`
    (`fourierSide_ge`: `2θ' + δ̂ ≥ 2θ' - δ̂(0)`);
  - **`fourierSide_nonneg_of_le_abs`, `exists_fourierSide_nonneg_of_le_abs`**: the
    inequality of Corollary 2.3 (ii) holds outside a bounded interval, and holds for
    `|t| ≥ T` as soon as `δ̂(0) ≤ 2θ'(T)`;
  - the effective form: `abs_two_thetaDeriv_sub_log_le`
    (`|2θ'(t) + log π - (1/2) log(1/16+t²/4)| ≤ 1/(1/16+t²/4) + π/t`), `two_thetaDeriv_ge`
    (`2θ'(t) ≥ log(t/2π) - 4/t² - π/t`) and `fourierSide_nonneg_of_exp_le_abs`: the
    inequality holds whenever `|t| ≥ max 1 (2π exp(δ̂(0) + 4 + π))`.  With the explicit
    bound `δ̂(0) ≤ 16π + 16` this becomes
    **`fourierSide_nonneg_of_explicit_le_abs`: `2θ'(t) + δ̂(t) ≥ 0` for every `t` with
    `|t| ≥ 2π exp(17π + 20)`**, unconditionally.  What remains of Corollary 2.3 (ii) is
    thus a statement on an explicit compact interval;
  - **the practical threshold**: feeding in the *decaying* bound `|δ̂(t)| ≤ 104/|t|` of
    `RequestProject/DeltaDecay.lean` instead of `|δ̂(t)| ≤ δ̂(0)` gives
    **`fourierSide_nonneg_of_sixty_le_abs`: `2θ'(t) + δ̂(t) ≥ 0` for every `t` with
    `|t| ≥ 60`** (auxiliary `two_le_log_div_two_pi`, `thetaDeriv_abs`).  Together with the
    neighbourhood of the origin settled in `RequestProject/NearOrigin.lean`
    (`fourierSide_nonneg_of_abs_le`, valid for `|t| ≤ 0.18`), Corollary 2.3 (ii) is
    therefore proved for `|t| ≤ 0.18` and for every `|t| ≥ 60`, and is open exactly on
    `0.18 < |t| < 60`.  See
    `RequestProject/CompactInterval.lean` for the reduction of the compact case to explicit
    numerical statements and for a quantitative account of why the elementary routes to the
    remaining interval fail.

* `RequestProject/DeltaDecay.lean` — **the decay of `δ̂`**
  - `abs_sinMoment_one_le_inv_sq` (`|S₁(y)| ≤ (π+1)/y²`), `exp_mul_hMom_le` and
    `two_mul_exp_mul_abs_hMom1_le`, the two halves of the pointwise derivative bound
    **`abs_dl1_le`: `|(d/du) δ(e^u)| ≤ 16 e^{-u/2}` for `u ≥ 0`**, obtained from the
    closed form of `δ` in terms of the cosine/sine moments;
  - `delta_expHomeo_eq_deltaLogAux`, `abs_deltaLogAux_sub_le` (mean value theorem) and
    **`abs_delta_expHomeo_shift_sub_le`**, the modulus of continuity
    `|δ(e^{u+h}) - δ(e^u)| ≤ 16 h e^{h/2} e^{-|u|/2}` (`h ≥ 0`), valid across the corner
    at `u = 0`;
  - **`two_mul_deltaFourier_eq`**, the half-period shift identity
    `2 δ̂(t) = ∫ (δ(e^u) - δ(e^{u+π/t})) cos(t u) du`, from the translation invariance of
    the Lebesgue measure and `cos(x+π) = -cos x`;
  - **`abs_deltaFourier_le_decay`: `|δ̂(t)| ≤ 32 π e^{π/(2|t|)}/|t|`**, and its numerical
    form `abs_deltaFourier_le_of_sixty_le`: `|δ̂(t)| ≤ 104/|t|` for `|t| ≥ 60`.  This
    replaces the crude `|δ̂(t)| ≤ δ̂(0)` by a bound that decays like `1/|t|`.

* `RequestProject/FourierSideAnalysis.lean` — **the shape of `f = 2θ' + δ̂`**
  - `hasSum_thetaDeriv_sub`, the exact series `2θ'(t) - 2θ'(0) = ∑_n (t²/4)/(a_n(a_n²+t²/4))`
    with `a_n = n + 1/4`, all of whose terms are nonnegative and increasing in `|t|`;
    hence `thetaDeriv_zero_le` (`2θ'` is minimal at the origin) and
    `thetaDeriv_monotoneOn`;
  - `deltaSpread` (`Δ(t) = ∫ δ(e^u)(1 - cos tu) du`), `deltaSpread_eq` (`Δ = δ̂(0) - δ̂`),
    `deltaSpread_nonneg`, and the **exact decomposition** `fourierSide_eq_add_sub`:
    `f(t) = f(0) + Θ(t) - Δ(t)` with `Θ = 2θ' - 2θ'(0)`.  `fourierSide_nonneg_iff` records
    that the Fourier-side inequality at `t` is exactly the comparison `Δ(t) ≤ Θ(t) + f(0)`.

* `RequestProject/SiAsymptotic.lean` — **the Dirichlet integral and the asymptotics of
  `Si`** (both missing from Mathlib)
  - `siAuxCos`, `siAuxSin`, the two auxiliary Laplace integrals
    `f(x) = ∫_0^∞ e^{-xy}/(1+y²) dy` and `g(x) = ∫_0^∞ y e^{-xy}/(1+y²) dy`, with
    `siAuxCos_nonneg`, `siAuxSin_nonneg`, `siAuxCos_le` (`f ≤ 1/x`) and `siAuxSin_le`
    (`g ≤ 1/x²`);
  - **`Si_eq_pi_div_two_sub`: `Si x = π/2 - f(x) cos x - g(x) sin x`** for `x > 0`, proved
    by substituting `1/x = ∫_0^∞ e^{-xy} dy` into `Si` and exchanging the two integrations
    (`integrable_uncurry_sin_exp`, `integral_sin_mul_exp`);
  - **`abs_Si_sub_pi_div_two_le`: `|Si x - π/2| ≤ 1/x + 1/x²`**, with the one-sided forms
    `Si_ge` and `Si_le_of_pos`, and **`tendsto_Si_atTop`**, the Dirichlet integral
    `∫_0^∞ sin t/t dt = π/2`.

* `RequestProject/CompactInterval.lean` — **the status of `|t| ≤ 60`**
  - `eulerMascheroniConstant_lt_d4` (`γ < 0.5812`, sharper than Mathlib's `γ < 2/3`, which
    is *not* good enough here) and `log_pi_lt` (`log π < 1.145`), hence
    **`fourierSide_threshold_lt`: `log π + γ + 3 log 2 + π/2 < 5.3765`**;
  - **`fourierSide_zero_nonneg_of_deltaFourier_zero_ge`**: the Fourier-side inequality at
    the origin follows from the single explicit numerical statement `δ̂(0) ≥ 5.3765`
    (numerically `δ̂(0) = 5.4212541…`, so the required margin is `0.045`).  That statement
    is now **proved**, in `RequestProject/DeltaFourierZero.lean`; the inequality at the
    origin is therefore unconditional;
  - `fourierSide_nonneg_of_zero_and_spread` and `spread_comparison_iff`, the reduction of
    the whole inequality to that numerical statement plus `Δ ≤ Θ`.
  The file's header documents, quantitatively, why neither a monotonicity argument nor an
  interval-arithmetic argument closes `0 < |t| < 60` with the tools available: the second
  moments of `Θ` and `Δ` agree to four digits (`32.32` against `32.32`, difference
  `0.0021`), so no sign-blind estimate can separate them, and a grid argument would need
  some two thousand certified evaluations of an oscillatory integral to accuracy `0.02`.

* `RequestProject/TaylorBounds.lean` — **alternating Taylor bounds**
  - `sinPart`, `cosPart`, `sincPart`, `siPart`, `siDivPart`, the partial sums of the Taylor
    series of `sin`, `cos`, `sinc`, `Si` and `Si x / x`, their derivatives, and
    **`taylor_sign`**, the classical statement that for `t ≥ 0` the Taylor remainder of
    `sin` and `cos` has the sign of the first omitted term (simultaneous induction, each
    step integrating the previous one);
  - hence `sinPart_le_sin`, `sincPart_le_sinc`, `siPart_le_Si` and
    **`siDivPart_le_siDiv`: `Si x / x ≥ ∑_{k<n} (-1)^k x^{2k}/((2k+1)(2k+1)!)`** for even
    `n` and `x ≥ 0`, the minorant used by the quadrature of `δ̂(0)`.

* `RequestProject/DeltaFourierZero.lean` — **`δ̂(0) ≥ 5.3765`, hence `f(0) ≥ 0`**
  - the substitution `r = e^u` (`deltaFourier_zero_eq_add`) turns the defining integral into
    `δ̂(0) = 4 ∫_1^∞ (σ(2π(1+r)) + σ(2π(r-1))) r^{-1/2} dr`, `σ = Si(·)/·`, whose two
    summands `gPlus`, `gMinus` are estimated separately;
  - on the tails the exact expansion `Si x = π/2 - f(x) cos x - g(x) sin x` of
    `RequestProject/SiAsymptotic.lean` splits the integrand into an elementary main term
    (`integral_Ioi_main_plus`: `π/8`, `integral_Ioi_main_minus`: `(log 6)/4`) and two
    oscillating terms, bounded by **`abs_integral_mul_halfAntiperiodic_le`**: for `u ≥ 0`
    antitone and integrable and `|c| ≤ 1` with `c(r+1/2) = -c(r)`,
    `|∫_R^∞ u c| ≤ ∫_R^{R+1/2} u`.  This gives `integral_gPlus_ge` (`≥ π/8 - 0.0028`) and
    `integral_gMinus_tail_ge` (`≥ (log 6)/4 - 0.0074`);
  - on the head interval `[1, 49/25]`, **`integral_gMinus_head_ge`** (`≥ 0.5145`) is a
    certified quadrature: four subintervals, on each of which `σ` is replaced by its
    degree-14 Taylor minorant (`siDivPart_le_siDiv`) and `1/√r` by the tangent line at a
    rational square (`tangent_inv_sqrt_le`), the resulting polynomial integrals being
    evaluated exactly (`hasDerivAt_siDivIntPart`) and estimated with `pi_pow_bounds`;
  - adding the three estimates gives **`deltaFourier_zero_ge_d4`: `δ̂(0) ≥ 5.3795`** (the true
    value is `5.42125…`) and hence **`fourierSide_zero_nonneg`: `2θ'(0) + δ̂(0) ≥ 0`**,
    unconditionally.  This settles the origin, the smallest-margin point of the whole
    inequality (`f(0) = 0.0490707…`).

* `RequestProject/GammaBound.lean` — **a quantitative margin at the origin**
  - `gammaSeqMid` (`H_n - log (n + 1/2)`), its monotonicity (`antitone_gammaSeqMid`, from
    the third-order estimate `two_mul_le_log_sub_log`) and its limit
    (`tendsto_gammaSeqMid`), hence `eulerMascheroniConstant_lt_d6` (`γ < 0.5772287`, an
    `O(1/n²)` refinement of Mathlib's `O(1/n)` bounds), `log_pi_lt_d5` and
    **`fourierSide_threshold_lt_d5`: `log π + γ + 3 log 2 + π/2 < 5.37221`**;
  - with `δ̂(0) ≥ 5.3795` this gives **`fourierSide_zero_ge`: `f(0) ≥ 0.0072`** (the true
    value is `0.0490707…`), the margin that the near-origin argument spends.

* `RequestProject/NearOrigin.lean` — **the Fourier-side inequality for `|t| ≤ 0.18`**
  - the truncated kernel `thetaTruncKernel` (the first eight terms of
    `k_Θ(v) = 2 e^{-v/2}/(1-e^{-2v})`), its elementary Laplace transform
    (`integral_Ioi_exp_one_sub_cos`) and `integral_thetaTruncKernel`, which identifies
    `∫_0^∞ k_{Θ,8}(v)(1-cos tv) dv` with the corresponding partial sum of the digamma
    series for `Θ`;
  - the comparison of `2δ(e^v)` with that kernel: `two_delta_le_thetaTruncKernel` on
    `[0,1/5]` (where the kernel already dominates), and, on `[1/5,∞)`, the elementary
    majorant `nearMajorant` for `v²(2δ(e^v) - k_{Θ,8}(v))`
    (`two_delta_sub_smooth_le`, `smooth_sub_thetaTruncKernel_le`,
    `two_delta_sub_le_nearMajorant`);
  - the explicit antiderivative `nearAnti` of the majorant, whence
    `integrableOn_nearMajorantInd` and **`integral_nearMajorantInd_le`: its total mass is
    at most `2/5`** (true value `0.3571…`);
  - integrating the pointwise bound `pointwise_delta_bound` (which uses `1 - cos tv ≤
    t²v²/2` away from the origin) gives **`deltaSpread_le_thetaSpread_add`:
    `Δ(t) ≤ Θ(t) + t²/5`**, a quantitative form of the spread comparison, and hence
    `fourierSide_nonneg_of_sq_le` (`f(t) ≥ 0` whenever `t² ≤ 5 f(0)`) and
    **`fourierSide_nonneg_of_abs_le`: `2θ'(t) + δ̂(t) ≥ 0` for `|t| ≤ 0.18`**.  The width of
    the interval is limited only by the certified value of `f(0)`: the true `f(0)` would
    give `|t| ≤ 0.49`.

* `RequestProject/BandEnergy.lean`, `RequestProject/TailEnergy.lean` — **an operator-free
  route to the Fourier-side inequality**
  - `truncTransform`, `bandEnergy` and the two hypotheses `BandEnergyBound` (Plancherel for
    the truncated character `|x|^{-1/2+it} 1_{1≤|x|≤X}`) and `TraceLimitIdentity`
    (`2 log X - A(t,X) → 2 f(t)`), from which `fourierSide_nonneg_of_bandEnergy` derives
    the inequality for *all* `t`; `weilCut` and `weilCut_abs_eq_two_delta` identify the
    lower limit of the inner integration with `2δ` (formula (49) read backwards);
  - carrying out both limits by hand collapses the pair into one identity,
    **`TailEnergyIdentity`: `f(t) = (2/π) ∫_{2π}^∞ |∫_a^∞ y^{-1/2+it} cos y dy|² da/a`**,
    whose right-hand side (`tailEnergy`) is nonnegative by inspection
    (`tailEnergy_nonneg`), so that `fourierSide_nonneg_of_tailEnergy` gives the inequality
    for every real `t`.  The identity is the archimedean explicit formula; it is *not*
    proved here, but it contains no inequality, only an equality — all of the positivity
    has been isolated in a triviality.

## Numerics (not verified in Lean)

The following observations come from floating-point computation only; they are recorded
here because they say where the remaining gaps are, not as proved statements.

* The Fourier-side function `f(t) = 2θ'(t) + δ̂(t)` of Corollary 2.3 is numerically
  *increasing in `|t|`* on `[0,8]` (sampled at step `0.1`, no decrease), so its minimum is
  at the origin, where
  `f(0) = δ̂(0) + ψ(1/4) - log π ≈ 5.421285 - 5.372183 ≈ 0.0491`.
  This is the **measured margin `m ≈ 0.0491`**: the inequality `2θ' + δ̂ ≥ 0` holds, but
  only just, at `t = 0`.  Together with `fourierSide_nonneg_of_monotoneOn` this reduces a
  future proof of Corollary 2.3 (ii) to (a) monotonicity of `f` on `[0,∞)` and (b) the
  single numerical inequality `δ̂(0) ≥ log π - ψ(1/4)` at the origin — and (b) is now
  proved (`deltaFourier_zero_ge`).  No simpler closed
  form of `f` was found.  (The `2θ'` half of that monotonicity is now *proved*,
  `thetaDeriv_monotoneOn`; what is numerical is the behaviour of `δ̂` on the compact
  interval and the value of `δ̂(0)`.)
* More of the profile of `f` on `[0,60]`: `f(1) = 0.05010`, `f(2) = 0.05337`,
  `f(3) = 0.05938`, `f(5) = 0.08474`, `f(10) = 0.3576`, `f(20) = 1.1605`,
  `f(60) = 2.2551`.  On the whole of `[0,6]` the quantity to be shown nonnegative is below
  `0.11`, while the two summands are of size `5`.  The second moments of `Θ` and `Δ`
  (the coefficients of `t²/2` in their expansions at the origin) are
  `∑_n 2/(n+1/4)³ ≈ 32.32` and `∫ δ(e^u) u² du ≈ 32.32`, differing by only `0.0021`; the
  difference kernel `k(v) = 2 e^{3v/2}/(e^{2v}-1) - 2δ(e^v)`, for which
  `f(t) - f(0) = ∫_0^∞ k(v)(1 - cos tv) dv`, has a negative part of `L¹`-mass `≈ 0.111`,
  more than twice the whole budget `f(0) ≈ 0.049`.  This is why no sign-blind estimate
  closes the compact case.
* The tail-energy identity `f(t) = (2/π) ∫_{2π}^∞ |∫_a^∞ y^{-1/2+it} cos y dy|² da/a`
  (`TailEnergyIdentity` of `RequestProject/TailEnergy.lean`) was checked numerically at
  `t = 0, 1, 2, 3, 5, 10, 30`, the two sides agreeing to eight significant digits at
  `t = 30`; at `t = 0` it specializes, through the Fresnel integral
  `C(θ) = ∫_0^θ cos(πx²/2) dx`, to `δ̂(0) = 8 ∫_0^2 C(1-C) dθ/θ` and
  `f(0) = 8 ∫_2^∞ (C - 1/2)² dθ/θ`.
* The kernel satisfies `|Qδ(e^0)| ≈ 8.39`, rising to `≈ 12.0` at `t = 0.0975` and
  `≈ 14.5` at `t = 0.2`, and `∫₀^{0.097542}|Qδ(e^x)| dx ≈ 0.985`: the paper's value
  `u = 1.10246` is essentially the exact threshold of its own criterion (margin `< 2%`).
  The elementary, sign-blind moment bounds used in `RequestProject/KernelBound.lean`
  overestimate `|Qδ|` by about 25% (they give `10.6` at `t = 0` against the true `8.39`),
  which is why the constant proved here is `u = e^{1/15} = 1.0689` rather than `1.10246`;
  closing that gap needs rigorous quadrature (interval arithmetic on `Si` near `4π`),
  not a sharper elementary estimate.

## What is *not* formalized

The deep statements of the paper (the local trace formula, the essential negativity of
`E ∘ Q`, the prolate spheroidal expansion of the remainder `ε`, the Toeplitz argument of
§6, Theorem 1, Theorem 6.11 and Corollary 2) are *not* formalized: they are not stated
here even as `sorry`, because a faithful statement of any of them requires
infrastructure that neither Mathlib nor this project currently provides, namely

* the integrated representation `f ↦ ϑ(f) = ∫ f(λ) ϑ(λ) d*λ` of the convolution algebra
  (a strongly, but not norm, continuous integral), and with it the trace identity
  `L(f) = Tr(ϑ(f) P P̂ P)` that would prove `L_positive`;
* the Bochner-type integrability of `f̂` for a positive definite `f`; without it the
  Parseval computation (52) — both halves of which are now proved, in
  `RequestProject/Parseval.lean` and `RequestProject/ArchimedeanExplicit.lean` — does not
  give the *unconditional* positivity of `L` from the Fourier-side inequality of
  `RequestProject/FourierSide.lean`;
* trace-class operators and the operator trace `Tr` on a Hilbert space;
* prolate spheroidal wave functions and the associated differential operator;
* the spectral theory of a pair of projections, and the *compactness* (as opposed to the
  boundedness proved here) of the integral operators with the kernels `Qδ` of §3–§4;
* Toeplitz operators on `ℓ²(ℤ)` and their continuous analogues.

Stating those results with placeholder definitions would produce statements that do not
say what the paper says, so the honest record is the list above: the objects that could
be defined faithfully have been defined, and the results about them that could be proved
have been proved.

## The original skeleton

The informal skeleton that this project started from is reproduced verbatim below, inside
a comment (it is pseudo-Lean and does not elaborate).

/-
import Mathlib.Analysis.Fourier.FourierTransform
import Mathlib.Analysis.SpecialFunctions.Gaussian
import Mathlib.MeasureTheory.Integral.Bochner
import Mathlib.MeasureTheory.Group.Convolution
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.InnerProductSpace.l2Space
import Mathlib.Topology.ContinuousFunction.CompactlySupported
import Mathlib.Analysis.Distribution.SchwartzSpace

noncomputable section

open scoped Real InnerProductSpace
open MeasureTheory Filter Topology

namespace ConnesConsani.WeilPositivity

/-! ## 0. Basic multiplicative group and convolution algebra -/

/-- The multiplicative group \(\mathbb{R}_+^*\). -/
abbrev Rplus := {x : ℝ // 0 < x}

instance : CommGroup Rplus := by
  -- standard instance via `Units` or explicit construction
  sorry

/-- Haar measure \(d^*\rho = d\rho/\rho\). -/
def haar : Measure Rplus := sorry

instance : IsHaarMeasure haar := sorry
instance : SigmaFinite haar := sorry

/-- Smooth compactly supported functions on \(\mathbb{R}_+^*\). -/
def Cc∞ (U : Set Rplus := Set.univ) : Type :=
  {f : C(Rplus, ℂ) // HasCompactSupport f ∧ ContDiff ℝ ⊤ f ∧ support f ⊆ U}

instance : AddCommGroup (Cc∞ U) := sorry
instance : Module ℂ (Cc∞ U) := sorry

/-- Convolution product making \(C_c^\infty(\mathbb{R}_+^*)\) into a *-algebra. -/
def conv (f g : Cc∞) : Cc∞ := sorry

infixr:70 " ∗ " => conv

/-- Involution \(f^*(\rho) = \overline{f(\rho^{-1})}\). -/
def involution (f : Cc∞) : Cc∞ := sorry
postfix:max "^*" => involution

/-- The ideal of functions whose Fourier/Mellin transform vanishes at \(\pm i/2\). -/
def vanishingIdeal : Ideal (Cc∞) := sorry

/-! ## 1. Scaling representation and Sonin projection -/

/-- Hilbert space \(L^2(\mathbb{R})_{\mathrm{ev}}\) of even square-integrable functions. -/
def L2ev : Type :=
  {ξ : ℝ → ℂ // (∀ x, ξ (-x) = ξ x) ∧ Memℒp ξ 2 volume}
  -- better: closed subspace of L²(ℝ)

instance : NormedAddCommGroup L2ev := sorry
instance : InnerProductSpace ℂ L2ev := sorry
instance : CompleteSpace L2ev := sorry

/-- Unitary scaling representation \(\vartheta : \mathbb{R}_+^* \to U(L^2_{\mathrm{ev}})\). -/
def scaling (λ : Rplus) : L2ev ≃ₗᵢ[ℂ] L2ev := sorry

/-- Integrated form \(\vartheta(f) = \int f(\lambda)\,\vartheta(\lambda)\,d^*\lambda\). -/
def scalingOp (f : Cc∞) : L2ev →L[ℂ] L2ev := sorry

/-- Orthogonal projection onto the Sonin space
    (functions that, together with their Fourier transform, vanish on \([-1,1]\)). -/
def SoninProjection : L2ev →L[ℂ] L2ev := sorry

lemma SoninProjection_isProjection : IsProjection SoninProjection := sorry
lemma SoninProjection_selfAdjoint : IsSelfAdjoint SoninProjection := sorry

/-! ## 2. The Weil distribution at the archimedean place -/

/-- The distribution \(W_\infty\) (principal-value form of the local archimedean term). -/
def WeilDistribution (f : Cc∞) : ℂ := sorry

/-- Explicit formula for the distribution outside \(\{1\}\) (locally rational). -/
lemma WeilDistribution_explicit (f : Cc∞)
    (hf : 1 ∉ support f) :
    WeilDistribution f =
      ∫ ρ, f ρ * (ρ^{1/2} / |1 - ρ|) ∂haar := sorry

/-! ## 3. Geometric side – Schwartz kernels and the two squares Δ, Σ -/

/-- Schwartz kernel of an operator on \(L^2(\mathbb{R}_+^*)\). -/
def SchwartzKernel (T : (ℝ → ℂ) →L[ℂ] (ℝ → ℂ)) : Rplus → Rplus → ℂ := sorry

/-- The unitary \(u_\infty\) associated with the Fourier transform composed with inversion. -/
def u∞ : L2ev ≃ₗᵢ[ℂ] L2ev := sorry

/-- Quantized differential \(\overline{d}u_\infty\). -/
def quantizedDifferential : L2ev →L[ℂ] L2ev := sorry

/-- Geometric identity (local trace formula at ∞). -/
theorem geometric_trace_formula (f : Cc∞) :
    WeilDistribution f =
      (1/2 : ℂ) * Trace (scalingOp f * (u∞⁻¹ * quantizedDifferential)) := sorry

/-! ## 4. Trace-remainder δ(ρ) and the positive functional L -/

/-- The trace-remainder function δ(ρ). -/
def delta (ρ : Rplus) : ℝ := sorry

lemma delta_symmetric (ρ : Rplus) : delta ρ = delta (ρ⁻¹) := sorry

lemma delta_explicit (ρ : Rplus) (h : 1 ≤ ρ) :
    delta ρ = 2 * ρ^{1/2} *
      (Si (2 * π * (1 + ρ)) / (2 * π * (1 + ρ)) +
       Si (2 * π * (ρ - 1)) / (2 * π * (ρ - 1))) := sorry

/-- The positive functional \(L(f) = D(f) + W_\infty(f)\). -/
def L (f : Cc∞) : ℂ :=
  ∫ ρ, f (ρ⁻¹) * (delta ρ - WeilDistribution (dirac ρ)) ∂haar  -- schematic
  -- more precisely: L(f) := Tr(ϑ(f) P P̂ P)

theorem L_positive (f : Cc∞) (hf : ∃ g, f = g ∗ g^*) :
    0 ≤ (L f).re := sorry

/-! ## 5. Differential operator Q implementing the vanishing conditions -/

/-- The operator \(Q = -(\rho\partial_\rho)^2 + 1/4\). -/
def Q : Cc∞ → Cc∞ := sorry

lemma Q_preserves_support (f : Cc∞) (I : Set Rplus) :
    support f ⊆ I → support (Q f) ⊆ I := sorry

lemma Q_implements_vanishing (f : Cc∞) :
    Q f ∈ vanishingIdeal ↔ True := sorry   -- always lands in the ideal

lemma Q_and_positive_definiteness (f : Cc∞) :
    (∀ χ, 0 ≤ (f ∗ f^*).Fourier χ) ↔
    (∀ χ, 0 ≤ ((Q f) ∗ (Q f)^*).Fourier χ) := sorry

/-! ## 6. Essential negativity of D ∘ Q -/

/-- Compact operator arising from the jump of δ' at 1. -/
def K_I (I : Set Rplus) : (L2 (√I) haar) →L[ℂ] (L2 (√I) haar) := sorry

theorem essential_negativity (I : Set Rplus) (hI : IsCompact I) :
    ∃ K : (L2 (√I) haar) →L[ℂ] (L2 (√I) haar),
      IsCompactOperator K ∧
      ∀ ξ, D (Q (ξ ∗ ξ^*)) = -2 * ‖ξ‖^2 + ⟪ξ, K ξ⟫ := sorry

/-! ## 7. Moving Δ inside Σ via pairs of projections and prolate functions -/

/-- Cut-off projections \(P_1,\widehat{P}_1\). -/
def P1 : L2ev →L[ℂ] L2ev := sorry
def P1hat : L2ev →L[ℂ] L2ev := sorry

lemma P1_and_P1hat_relation :
    SoninProjection = 1 - (P1 ⊔ P1hat) := sorry

/-- Prolate spheroidal wave functions (eigenvectors of the prolate differential operator). -/
def prolate (n : ℕ) : L2ev := sorry

/-- Coefficient appearing in the expansion of the remainder ε(ρ). -/
def epsilon (ρ : Rplus) : ℝ := sorry

lemma epsilon_expansion (ρ : Rplus) (h : 1 ≤ ρ) :
    epsilon ρ =
      ∑' n, (λ n / √(1 - (λ n)^2)) * ⟪prolate n, scaling ρ⁻¹ (prolate n)⟫ := sorry

/-! ## 8. The refined decomposition W_∞ = S – E -/

/-- The positive Sonin trace functional. -/
def SoninTrace (f : Cc∞) : ℂ :=
  Trace (scalingOp f * SoninProjection)

theorem SoninTrace_positive (f : Cc∞) (hf : ∃ g, f = g ∗ g^*) :
    0 ≤ (SoninTrace f).re := sorry

/-- Remainder functional E. -/
def E (f : Cc∞) : ℂ := sorry

theorem refined_decomposition (f : Cc∞) :
    WeilDistribution f = SoninTrace f - E f := sorry

/-! ## 9. Essential negativity of E ∘ Q on the interval [1/2,2] -/

/-- The critical compact operator on L²([2^{-1/2},2^{1/2}]). -/
def K_half : (L2 ({ρ // 2⁻¹ ≤ ρ ∧ ρ ≤ 2}) haar) →L[ℂ] _ := sorry

theorem spectrum_of_K_half :
    ∃ (λ_max : ℝ) (v : _),
      λ_max > 1 ∧
      IsEigenvalue K_half λ_max v ∧
      (∀ μ ∈ spectrum K_half, μ ≠ λ_max → μ ≤ 1) := sorry

/-- After conditioning on the single dangerous eigenvector one obtains strict negativity. -/
theorem conditioned_negativity :
    ∃ (c : ℝ) (h : 13 < c ∧ c < 17),
      ∀ g : Cc∞,
        support g ⊆ {ρ // 2⁻¹ ≤ ρ ∧ ρ ≤ 2} →
        (Q g).Fourier (I/2) = 0 →
        WeilDistribution (g ∗ g^*) ≥
          SoninTrace (g ∗ g^*) - c * |g.Fourier 0|^2 := sorry

/-! ## 10. Main theorems -/

/-- Theorem 1 of the paper (support in [2^{-1/2},2^{1/2}], vanishing at i/2 and 0). -/
theorem main_positivity
    (g : Cc∞)
    (hsupp : support g ⊆ {ρ // 2⁻¹ ≤ ρ ∧ ρ ≤ 2})
    (hvan : g.Fourier (I/2) = 0 ∧ g.Fourier 0 = 0) :
    WeilDistribution (g ∗ g^*) ≥ SoninTrace (g ∗ g^*) := by
  sorry

/-- Stronger quantitative form (Theorem 6.11). -/
theorem main_positivity_quantitative
    (g : Cc∞)
    (hsupp : support g ⊆ {ρ // 2⁻¹ ≤ ρ ∧ ρ ≤ 2})
    (hvan : g.Fourier (I/2) = 0) :
    ∃ (c : ℝ), 13 < c ∧ c < 17 ∧
      WeilDistribution (g ∗ g^*) ≥
        SoninTrace (g ∗ g^*) - c * |g.Fourier 0|^2 := by
  sorry

/-- Corollary relating the inequality to the zeros of ζ. -/
theorem corollary_zeros
    (g : Cc∞)
    (hsupp : support g ⊆ {ρ // 2⁻¹ ≤ ρ ∧ ρ ≤ 2})
    (hvan : g.Fourier (I/2) = 0) :
    ∃ (c : ℝ), 13 < c ∧ c < 17 ∧
      c * |g.Fourier 0|^2 +
        ∑' ρ : nontrivialZeros,
          g.Fourier (ρ - 1/2) * (starRingEnd ℂ (g.Fourier (ρ - 1/2))) ≥
      SoninTrace (g ∗ g^*) := by
  sorry

end ConnesConsani.WeilPositivity
-/
-/
