/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.WeilDistribution

/-!
# Weil positivity – archimedean place: status of the formalization

This file records the original informal skeleton of arXiv:2006.13771 that this project
started from, and maps each of its items to what is now actually formalized (and proved)
in the other files of the project.

## Headline

Corollary 2.3 of the paper is **proved**, unconditionally:

* `fourierSide_nonneg` / `two_thetaDeriv_add_deltaFourier_nonneg`
  (`RequestProject/PolyaLowThreshold.lean`): `2θ'(t) + δ̂(t) ≥ 0` for **every** real `t`;
* `LfunNorm_re_nonneg_convLog_starLog`
  (`RequestProject/ArchimedeanPositivity.lean`): the functional `L = D + W_∞`, in the
  `∆^{1/2}` normalization of the paper, is nonnegative on every convolution square
  `F ⋆ F*` with `F` of class `C²` and compactly supported — no hypothesis is left, the
  archimedean explicit formula and the analytic side conditions being theorems of the
  project;
* `LfunNorm_re_nonneg_contDiff_four` / `LPositivityNorm_holds`
  (`RequestProject/NormalizedPositivity.lean`): the same positivity for *every* positive
  definite test function of class `C⁴` with compact support, again with no hypothesis.

On the geometric (operator) side the renormalized cut-off trace is now computed,
unconditionally:

* `exists_universal_finitePart_unconditional` / `exists_universal_finitePart_LfunNorm`
  (`RequestProject/CutoffLogProfile.lean`): there is a universal constant `z₁` such that
  for *every* continuous compactly supported test function `f` on `ℝ⋆₊` that is Lipschitz
  at `λ = 1`,

      `Tr(ϑ(f) S^{(Λ)}) - 4 f(1) log Λ  ⟶  D(F) - L_Norm(F) + E(F) + f(1) z₁`,
      `F = logTest f`,   `Λ → ∞`,

  the `f`-dependence of the finite part being exactly the pairing against the recovered
  off-diagonal kernel `λ^{1/2}/|1-λ|`, i.e. `W_ℝ(∆^{-1/2}F) = D(F) - L_Norm(F)`, plus the
  odd-part term `E(F)`.  The coefficient of `log Λ` in this full-line model is `4 f(1)`
  (phase-space scale `Λ²`, `4 log Λ = 2 log Λ²`).

* `exists_universal_even_finitePart` / `exists_universal_even_finitePart_LfunNorm`
  (`RequestProject/EvenCutoffTrace.lean`): the same asymptotic **restricted to the even
  (Sonin) subspace**, where the paper's normalisation is recovered exactly.  With
  `P_ev = (1 + R)/2` the orthogonal projection onto even functions and
  `Tr(ϑ(f) S^{(Λ)} P_ev) = ½ [Tr(ϑ(f) S^{(Λ)}) + Tr(ϑ(f) S^{(Λ)} R)]`
  (`evenModelCutTrace_eq_half`), there is a universal constant `z_ev` such that for every
  test function `f` Lipschitz at `λ = 1`

      `Tr(ϑ(f) S^{(Λ)} P_ev) - 2 f(1) log Λ  ⟶  W_ℝ(∆^{-1/2}F) + f(1) z_ev`
                                             `= D(F) - L_Norm(F) + f(1) z_ev`.

  Two things improve simultaneously: the logarithmic coefficient is **exactly `2 f(1)`**,
  the paper's normalisation, because the reflected density
  `κ^{refl}_Λ(λ) = √a·(2/(π(a+1)))·Si(2π(a+1)Λ²/max(1,a))`, `a = λ⁻¹`, is bounded
  uniformly in `Λ` (`abs_reflDensityVal_le`) and so contributes no divergence; and the
  odd-part term `E(F)` **cancels exactly**, because in the logarithmic coordinate the even
  limiting kernel is `½(1/(2 sinh(|u|/2)) + 1/(2 cosh(u/2))) = sinhKernel u`, the kernel of
  `W_ℝ`.  The remaining scalar `z_ev` multiplies only the local value `f(1)`; it is
  evaluated in `RequestProject/EvenConstant.lean` as `z_ev = 2K/π - γ`
  (`even_finitePart_value`, `zEvenVal`), with `γ` Euler's constant and `K = siLogConst`
  the finite part of `∫_0^X Si(s) ds/s` relative to `(π/2) log X`.  See the section "The
  off-diagonal limit, and the finite part of the renormalized cut-off trace" below.

The project now contains **no `sorry`**.  The statement that was left open, `L_positive`
(the positivity of `L` in the *unnormalized* pairing `Lfun = Dcomplex + Winfty`), has been
**disproved**: see `not_LPositivity` in
`RequestProject/UnnormalizedCounterexample.lean`.  `LPositivity` is not the pairing of
Corollary 2.3 (see the warning in the docstring of `LPositivity`), and the unnormalized
pairing is not a positive functional.

## Global status: what is proved, what remains

A one-screen summary of the present state of the repository; every item below is
substantiated in the sections that follow, and the corresponding module/declaration names
are given there.

**Proved (`sorry`-free, axioms `propext`, `Classical.choice`, `Quot.sound`).**

1. *Corollary 2.3 of the paper*, in both of its forms: the Fourier-side inequality
   `2θ'(t) + δ̂(t) ≥ 0` for every real `t`, and the positivity of the normalised
   archimedean functional `L_Norm = D + W_∞(∆^{-1/2}·)` on convolution squares `F ⋆ F*`
   with `F ∈ C²_c`, and on every positive definite `C⁴` compactly supported test function.
   This part is **finished and frozen** (analytic Fourier side, Pólya-model bands,
   thresholds).
2. *The unnormalized statement `LPositivity` is false* (explicit counterexample).
3. *The fixed-cut-off trace identity* `L_Norm(f) = Tr(ϑ(f) P₁P̂₁P₁)` *is false*, for every
   unitary identification of the two pictures.
4. *The renormalized (cut-off) trace formula on the full line*: with
   `S^{(Λ)} = P^{(Λ)} P̂^{(Λ)} P^{(Λ)}`, the semi-local density is computed in closed form
   as a sine integral; its off-diagonal limit is the archimedean Weil kernel
   `λ^{1/2}/|1-λ|`; the renormalized trace `Tr(ϑ(f) S^{(Λ)}) - 4 f(1) log Λ` converges for
   every test function Lipschitz at `λ = 1`, and its limit is `D(F) - L_Norm(F) + E(F) +
   f(1) z₁` with a universal constant `z₁`.  On the **even (Sonin) subspace** the same
   holds with the paper's coefficient and without the odd-part term:
   `Tr(ϑ(f) S^{(Λ)} P_ev) - 2 f(1) log Λ ⟶ D(F) - L_Norm(F) + f(1) z_ev`, and
   `z_ev = 2 siLogConst/π - γ`.
5. *Two negative structural results on the renormalized programme*: the diagonal density
   grows like `Λ²` (`d(Λ) = Θ(Λ²)`), so the pure-diagonal logarithmic hypothesis
   `DiagLogUpperBound` — and with it `HasDiagLogUpperBound`, `HasDiagLogAsymptotics` — is
   refuted; and no *fixed* cut-off scale can compute `L_Norm`.

**What remains (nothing of it is assumed anywhere; no axiom is declared in the project).**

* The value of the scalar `z₁` of the *full-line* statement (it multiplies only `f(1)`;
  its even counterpart `z_ev` is computed).
* The deep statements of §§4–6 of the paper (prolate functions, Toeplitz argument,
  Theorem 1, Theorem 6.11, Corollary 2): not formalized, and not stated even as `sorry`,
  for the reasons listed in "What is *not* formalized" below.

## Status: the analytic part is finished and frozen

Two verification checks were carried out on the results above and are recorded, with the
verbatim evidence, in `RequestProject/VERIFICATION.md`.

1. **Axiom audit** (reproducible as `RequestProject/AxiomAudit.lean`, which elaborates the
   five `#print axioms` commands on every build).  Each of
   `fourierSide_nonneg`, `two_thetaDeriv_add_deltaFourier_nonneg`,
   `LfunNorm_re_nonneg_convLog_starLog`, `LfunNorm_re_nonneg_contDiff_four` and
   `LPositivityNorm_holds` depends on exactly
   `[propext, Classical.choice, Quot.sound]`.  No `sorryAx`, no `Lean.ofReduceBool`, no
   project-specific axiom (the project declares none); in particular none of these results
   depends, directly or transitively, on `L_positive` (a statement since disproved and
   removed; the audit now also covers `not_LPositivity`).
2. **Normalization check.**  `LfunNorm G = Dcomplex (ofLog G) + Winfty (deltaHalfInv
   (ofLog G))`, with `WeilR` transcribing formula (150) of the paper and
   `deltaHalfInv f x = x^{-1/2} f(x)`, applies the archimedean distribution to `∆^{-1/2}f`
   exactly as the introduction of the paper prescribes (`W_v(f) := W_v(∆^{-1/2} f)`,
   `∆^{1/2}f(x) := x^{1/2}f(x)`), while the trace-remainder term pairs `δ` with `f`
   itself, as in (51).  The paper's own coherence computation (§1, after (39):
   `∫₁^∞ τ(ρ)f(ρ) d*ρ = ∫₁^∞ k(x) dx/(x - x^{-1})` with `k = ∆^{-1/2}f`) is matched by
   `WeilR_explicit` and `WeilR_deltaHalfInv_ofLog`, and the Parseval identity (52) by
   `LfunNorm_parseval`.  The conventions **agree**: `LPositivityNorm` is Corollary 2.3 (i)
   of the paper.

With both checks passed, the analytic part of the archimedean place is finished and
frozen.

## The unnormalized statement `LPositivity` is **false**

`RequestProject/UnnormalizedCounterexample.lean` settles the last open item of the
project, negatively.

* `WeilR_ofLog` puts the distribution (150) applied to `f = G ∘ log` itself in the
  logarithmic coordinate, next to the existing `WeilR_deltaHalfInv_ofLog` for the
  `∆^{-1/2}`-normalized pairing of the paper.
* `WeilR_ofLog_eq_add_deficit`: for an even test function the two differ exactly by

    `∫₀^∞ F(u) (e^{u/2}-1)²/(e^u - e^{-u}) du ≥ 0`   (for `F ≥ 0`),

  a quantity that grows linearly in the width of the support of `F`, whereas the
  normalized functional stays bounded: `Dcomplex_ofLog_re_le` bounds `D` by
  `16 Si π + 16` on test functions with values in `[0,1]`, and
  `WeilR_deltaHalfInv_ofLog_value` together with `norm_integral_sub_mul_sinhKernel_le`
  bounds the normalized archimedean term by `weilConst + 40 C` for a `C`-Lipschitz test
  function.
* The counterexample is the triangular (Fejér) bump `triC w` of half width `w`, which is
  continuous, compactly supported and positive definite (`positiveDefiniteLog_triC`, from
  the Fejér computation `integral_triReal_mul_cos_eq`).  For the explicit width `wBad`,
  `L_real_triC_neg` shows `L_real (ofLog (triC wBad)) < 0`, whence
  `not_LPositivity : ¬ LPositivity`.

Numerically the phenomenon is much stronger than these crude bounds show: on convolution
squares of triangular bumps of half width `w` the unnormalized functional is already
negative at `w ≈ 1` and behaves like `-w²/2`, while the normalized functional stays
positive (`scripts/unnormalized_check.py`, values for `w = 0.25 … 8`).

This does not affect anything else in the project: the unnormalized pairing is not the
statement of the paper and is not required by the paper's subsequent arguments; the
consequences of §3 are available unconditionally in the normalized form
(`Winfty_deltaHalfInv_nonneg_of_D_Qlog_nonpos_Icc`, `small_support_Winfty_deltaHalfInv_ge`,
`Winfty_deltaHalfInv_ge_effective`).  The results of `RequestProject/Positivity.lean` that
carry `LPositivity` as an explicit hypothesis are now known to be vacuous as stated, and
each has an unconditional counterpart in `RequestProject/NormalizedPositivity.lean`.

## Status: the renormalized-trace programme

The fixed-cut-off trace identity `L_Norm(f) = Tr(ϑ(f) P₁ P̂₁ P₁)` is **false**
(`not_normalizedTraceIdentity`, `RequestProject/TraceIdentityObstruction.lean`), so the
local trace formula at the archimedean place can only hold in a *renormalized* form.  That
programme is now carried out, in the full-line model, up to two explicitly identified
items (the scalar `z₁` and the passage to the even subspace).

**Read this section as follows.**  The bullets immediately below, and the subsections
"State of the renormalized-trace programme: the exact boundary" and "Correction:
`DiagLogUpperBound` is false", record the operator-theoretic infrastructure and the
*diagonal* route, which turned out to be a dead end: the diagonal density is of order `Λ²`,
not `log Λ`.  The subsection "The off-diagonal limit, and the finite part of the
renormalized cut-off trace" records the route that succeeded, and is the current state of
the art in this repository:

* the off-diagonal limit of the semi-local density is the archimedean Weil kernel
  `λ^{1/2}/|1-λ|` (`SemiLocalKernel.lean`, `SemiLocalSi.lean`);
* the renormalized trace `Tr(ϑ(f) S^{(Λ)}) - 4 f(1) log Λ` converges for every test
  function Lipschitz at `λ = 1`, **unconditionally** (`CutoffLogProfileAux.lean`,
  `CutoffLogProfile.lean`);
* its limit is `D(F) - L_Norm(F) + E(F) + f(1) z₁`, i.e. the normalised archimedean
  functional `L_Norm` up to the local term `E(F)` of the odd part and the universal
  constant `z₁` (`WeilKernelComparison.lean`, `RenormalizedAsymptotics.lean`,
  `CutoffLogProfile.lean`);
* the coefficient is `4`, not the paper's `2`, because the computation is done on the
  full line rather than on the even (Sonin) subspace.

Nothing in the diagonal material below is retracted — all of it consists of proved
theorems or of clearly marked `Prop`-valued hypotheses — but the hypothesis
`DiagLogUpperBound` appearing there is now known to be false, and the identification of
the finite part that it was meant to serve has been obtained by the off-diagonal route
instead.

The infrastructure, in order:

* `RequestProject/CutoffFamily.lean` — the one-parameter family of cut-offs.
  `Pcut Λ` is multiplication by `1_{[-Λ,Λ]}`, `PcutHat Λ = 𝓕⁻¹ (Pcut Λ) 𝓕`, and
  `soninSandwichCut Λ = Pcut Λ ∘ PcutHat Λ ∘ Pcut Λ` is the renormalized sandwich
  `S^{(Λ)} = P^{(Λ)} P̂^{(Λ)} P^{(Λ)}`.  At `Λ = 1` these are exactly `P₁`, `P̂₁` and the
  Sonin sandwich (`Pcut_one`, `PcutHat_one`, `soninSandwichCut_one`).  Each `P^{(Λ)}`,
  `P̂^{(Λ)}` is a self-adjoint idempotent contraction, the family increases with `Λ`
  (`Pcut_comp_Pcut_of_le`, `range_Pcut_mono`), and `S^{(Λ)} = B_Λ^* B_Λ` with
  `B_Λ = P̂^{(Λ)} P^{(Λ)}`, hence `S^{(Λ)}` is positive, self-adjoint and a contraction.
* `RequestProject/CutoffFamilyHS.lean` — `B_Λ` is Hilbert–Schmidt at every scale (the
  kernel argument of `RequestProject/CutoffHilbertSchmidt.lean`, redone for an arbitrary
  measurable set of finite measure), so `S^{(Λ)}` and `ϑ(f) S^{(Λ)}` are trace class, with
  an absolutely convergent, basis-independent trace which is nonnegative on the convolution
  squares `f = g ∗ g^♯`.
* `RequestProject/CutoffExhaustion.lean` — the family exhausts `L²(ℝ)`:
  `P^{(Λ)} ξ → ξ`, `P̂^{(Λ)} ξ → ξ` and `S^{(Λ)} ξ → ξ` as `Λ → ∞`, and consequently every
  diagonal matrix element `⟪ξ, S^{(Λ)} ξ⟫` tends to `‖ξ‖²`.
* `RequestProject/TraceDivergence.lean` — **the renormalization is unavoidable**:
  `Tr(S^{(Λ)}) → ∞` (`tendsto_traceAlongRe_soninSandwichCut_atTop`).  On the way,
  `L²(ℝ)` is shown to be infinite dimensional, by exhibiting the orthonormal family of
  indicator functions of the unit blocks `[n, n+1)`.
* `RequestProject/RenormalizedTrace.lean` — the renormalized trace functional
  `cutTrace b U Λ f = Tr(ϑ(f) S^{(Λ)})`, the logarithmic counter-term
  `logCounterTerm f = 2 f(1)` (the coefficient expected from a cut-off in space *and* in
  frequency), the regularized trace
  `regularizedCutTrace b U Λ f = Tr(ϑ(f) S^{(Λ)}) - 2 f(1) log Λ`, and the finite part
  `HasRenormalizedTrace b U f z`.  Proved: the finite part is unique, independent of the
  Hilbert basis and linear in `f`; the counter-term is linear and equals `2‖g‖²_{L²(d*λ)}`
  on a convolution square `g ∗ g^♯` (so it vanishes only for `g = 0`); at every finite
  scale `Re Tr(ϑ(g ∗ g^♯) S^{(Λ)}) ≥ 0` and hence
  `Re regularizedCutTrace ≥ -2‖g‖² log Λ`; and at the scale `Λ = 1` the regularized trace
  is the fixed-cut-off trace of the refuted identity, so no *fixed* scale can compute
  `L_Norm` (`not_fixedScale_renormalizedTraceIdentity`).  (The coefficient `2 f(1)` fixed
  in `logCounterTerm` is the paper's normalization, i.e. the one expected in the even
  picture; in the concrete full-line model the coefficient actually proved is `4 f(1)`,
  see the subsection on the finite part below.  The uniqueness statements of
  `RenormalizedTraceUniqueness.lean` are conditional on the existence of the finite part
  with the given coefficient, so there is no conflict.)

* `RequestProject/RenormalizedTraceDensity.lean` — the trace at a finite scale in kernel
  form: `Tr(ϑ(f) S^{(Λ)}) = ∫ f(λ) κ_Λ(λ) d*λ` with the semi-local density
  `κ_Λ(λ) = Tr(ϑ(λ) S^{(Λ)})` (bounded, at each scale, by the Hilbert–Schmidt norm of
  `B_Λ`), hence `regularizedCutTrace = ∫ f κ_Λ d*λ - 2 f(1) log Λ`, and the *equivalence*
  `renormalizedTraceIdentity_iff_density`: the conjectural limit identity is precisely the
  convergence of these regularized integrals.  The remaining problem is thus one about the
  family of functions `κ_Λ`, not about a family of functionals.

* `RequestProject/RenormalizedDensitySymmetry.lean` — the structure of the semi-local
  densities: the Hilbert–Schmidt formula `κ_Λ(λ) = ⟪B_Λ^*, ϑ(λ) B_Λ^*⟫_HS` (so `κ_Λ` is a
  matrix coefficient of the scaling representation, hence positive definite), the symmetry
  `κ_Λ(λ⁻¹) = conj κ_Λ(λ)`, the continuity of `κ_Λ`, and `κ_Λ(1) = ‖B_Λ‖²_{HS} =
  Tr(S^{(Λ)})` — so the whole divergence sits in the behaviour of `κ_Λ` at `λ = 1`.

* `RequestProject/RenormalizedDensityBound.lean` — consequences of that description:
  `|κ_Λ(λ)| ≤ κ_Λ(1)` for every `λ` (`norm_traceDensityCut_le_one`), so at each scale the
  whole family is controlled by its value at the unit; `κ_Λ(1) = ‖B_Λ‖²_{HS}` is monotone
  in `Λ` (`re_traceDensityCut_one_mono`), so the divergence of `Tr(S^{(Λ)})` is monotone;
  `κ_Λ` is a **positive-definite function** on `ℝ⋆₊` uniformly in `Λ`
  (`traceDensityCut_posSemidef`); and for test functions vanishing at `1` there is no
  counter-term, so the renormalized trace is simply the limit of the cut-off traces
  (`hasRenormalizedTrace_iff_tendsto_cutTrace`) — the analytic problem is concentrated at
  `λ = 1`.

* `RequestProject/RenormalizedTraceUniqueness.lean` — the renormalization scheme is
  canonical.  `HasRenormalizedTraceWith b U c f z` allows an arbitrary counter-term
  coefficient `c`; `HasRenormalizedTraceWith.coeff_unique` shows that both `c` and the
  finite part `z` are determined by the family `Λ ↦ Tr(ϑ(f) S^{(Λ)})`, so once the
  renormalized trace exists no coefficient other than `2 f(1)` can be used
  (`HasRenormalizedTraceWith.eq_logCounterTerm`).  Quantitatively, existence of the finite
  part forces the divergence rate `Tr(ϑ(f) S^{(Λ)}) / log Λ → 2 f(1)`
  (`tendsto_cutTrace_div_log`), which on a convolution square reads
  `Tr(ϑ(g ∗ g^♯) S^{(Λ)}) / log Λ → 2‖g‖²_{L²(d*λ)}`
  (`tendsto_cutTrace_convSquare_div_log`); in particular the unrenormalized traces have no
  finite limit whenever `f(1) ≠ 0` (`not_tendsto_cutTrace_of_apply_one_ne_zero`,
  `not_tendsto_cutTrace_convSquare`).

* `RequestProject/SemiLocalDiagonal.lean` — the diagonal of the semi-local kernel and the
  expected asymptotics.  The diagonal value `d(Λ) = κ_Λ(1) = Tr(S^{(Λ)}) = ‖B_Λ‖²_{HS}` is
  isolated as `diagDensity U b Λ` and shown to be a nonnegative (`diagDensity_nonneg`),
  basis-independent (`diagDensity_basis_indep`), monotone (`diagDensity_mono`) and
  divergent (`tendsto_diagDensity_atTop`) real function of the cut-off scale, equal to the
  trace of the cut-off sandwich (`diagDensity_eq_traceAlongRe`); the whole cut-off trace is
  dominated by it, `|Tr(ϑ(f) S^{(Λ)})| ≤ ‖f‖_{L¹(d*λ)} d(Λ)`
  (`norm_cutTrace_le_l1Norm_mul_diagDensity`), which is the precise sense in which the
  logarithmic divergence is a *diagonal* phenomenon.  The expected asymptotic

      `Tr(ϑ(f) S^{(Λ)}) = 2 f(1) log Λ + L_Norm(f) + o(1)`,   `Λ → ∞`,

  is stated in the `o(1)` form as `HasLogAsymptotics` / `SemiLocalTraceAsymptotics U`, with
  `hasLogAsymptotics_iff_hasRenormalizedTrace` and
  `semiLocalTraceAsymptotics_iff_renormalizedTraceIdentity` identifying it with the
  renormalized trace identity above (again a `Prop`, never an axiom; still unproved), and
  its diagonal shadow `d(Λ) = 2 log Λ + c + o(1)` as `HasDiagLogAsymptotics`, whose finite
  part is unique and which forces the rate `d(Λ)/log Λ → 2`
  (`tendsto_diagDensity_div_log`).  One quantitative estimate is proved outright, with no
  Fourier analysis: if the finite part of a *single* test function `f` exists, with value
  `z`, then eventually

      `2‖f(1)‖ log Λ - (‖z‖ + 1) ≤ ‖f‖_{L¹(d*λ)} d(Λ)`

  (`eventually_diagDensity_lower_bound`), hence `(2‖f(1)‖ - ε) log Λ ≤ ‖f‖_{L¹} d(Λ)` for
  every `ε > 0` (`eventually_diagDensity_lower_bound_eps`): the diagonal kernel must
  diverge at least at the logarithmic rate `2|f(1)|/‖f‖_{L¹}`.

* `RequestProject/NearDiagonalKernel.lean` — the near-diagonal kernel and the two missing
  estimates.  The two-variable kernel `K_Λ(μ, ν) = κ_Λ(μ⁻¹ν)` (`semiLocalKernel`) is
  introduced in the form that accepts a short-distance expansion: it is invariant under the
  diagonal action (`semiLocalKernel_smul`), Hermitian (`semiLocalKernel_conj_symm`), maximal
  on the diagonal (`norm_semiLocalKernel_le_diag`), with diagonal value `d(Λ)`
  (`semiLocalKernel_diag`).  Its *near-diagonal defect* `ε_Λ(λ) = d(Λ) - Re κ_Λ(λ)`
  (`kernelDefect`) is nonnegative, vanishes at `λ = 1`, is invariant under `λ ↦ λ⁻¹` and
  continuous, and is controlled by the modulus of continuity of the translation
  representation on the Hilbert–Schmidt operator `B_Λ^*`,

      `ε_Λ(λ) ≤ ∑ᵢ ‖B_Λ^* eᵢ‖ ‖(1 - ϑ(λ)) B_Λ^* eᵢ‖`   (`kernelDefect_le_tsum`).

  The two estimates that are still missing are stated precisely, as `Prop`s and never as
  axioms: `DiagLogUpperBound U b C`, i.e. `d(Λ) ≤ 2 log Λ + C` eventually (and its
  existential form `HasDiagLogUpperBound`), and `ShortDistanceModulus U b M`, i.e.
  `ε_Λ(λ) ≤ M Λ · |log λ|` for `Λ ≥ 1` (and `HasShortDistanceModulus`), with `Rplus.logSize`
  the invariant distance `|log λ|` to the diagonal.  Proved about them: the conjectural
  diagonal asymptotics implies the upper bound (`HasDiagLogAsymptotics.diagLogUpperBound`);
  with a matching lower bound it pins the rate `d(Λ)/log Λ → 2`
  (`tendsto_diagDensity_div_log_of_bounds`); and it bounds the cut-off trace,
  `|Tr(ϑ(f) S^{(Λ)})| ≤ ‖f‖_{L¹}(2 log Λ + C)`
  (`eventually_norm_cutTrace_le_of_diagLogUpperBound`).  Finally the elementary averaging
  inequality linking the diagonal density to an integral of the near-diagonal kernel is
  proved outright with the existing Hilbert–Schmidt/trace machinery: for a nonnegative real
  test function `g` (`IsNonnegReal`),

      `Re Tr(ϑ(g) S^{(Λ)}) = ‖g‖_{L¹} d(Λ) - ∫ g(λ) ε_Λ(λ) d*λ`
      (`re_cutTrace_eq_diagDensity_sub_integral_defect`),

  whence `d(Λ) ≤ Re Tr(ϑ(g) S^{(Λ)}) + w` when `‖g‖_{L¹} = 1` and `ε_Λ ≤ w` on the support
  of `g` (`diagDensity_le_re_cutTrace_add`), and the reduction of the missing upper bound to
  the two estimates above (`diagLogUpperBound_of_modulus_of_traceBound`).

* `RequestProject/DiagonalQuadraticGrowth.lean` — **the diagonal density grows
  quadratically, so `DiagLogUpperBound` is false**.  The Fourier transform of a box is
  computed exactly, `|𝓕 1_{[a, a+h]}(ξ)| = |sin(π h ξ)|/(π|ξ|)`
  (`norm_fourierIntegral_box`), and Jordan's inequality gives, for the normalized box
  `boxVec a h` of width `h = 1/(2Λ)`, the energy retention `‖P̂^{(Λ)} v‖² ≥ 4/π²`
  (`enorm_PcutHat_boxVec_sq_ge`).  The `⌊2Λ²⌋` disjoint translates of such a box inside
  `[-Λ, Λ]` are orthonormal (`orthonormal_boxFamily`) and an orthonormal family bounds a
  Hilbert–Schmidt norm from below (`sum_enorm_sq_le_hsNormSq`), whence
  `d(Λ) ≥ (4/π²)⌊2Λ²⌋ ≥ (8/π²)Λ² − 4/π²` (`diagDensity_ge_quadratic`).  Keeping track of
  the constant in the kernel bound of `CutoffFamilyHS.lean` gives the matching upper bound
  `d(Λ) ≤ 4Λ²` (`diagDensity_le_four_mul_sq`), so `d(Λ) = Θ(Λ²)`.  Consequently
  `¬ DiagLogUpperBound U b C` for every `C` (`not_diagLogUpperBound`), and a fortiori
  `¬ HasDiagLogUpperBound`, `¬ HasDiagLogAsymptotics`; reading the transfer theorem of
  `NearDiagonalKernel.lean` contrapositively, a short-distance modulus with a balanced
  bump family excludes the logarithmic trace asymptotics
  (`not_traceAsymptotics_of_modulus`).

**Status of the limit identity itself.**  The predicate `RenormalizedTraceIdentity U`,

    `L_Norm(f) = lim_{Λ→∞} (Tr(ϑ(f) S^{(Λ)}) - 2 f(1) log Λ)`,

is stated in the abstract setting (an arbitrary unitary identification `U` of the two
pictures) and is *not* proved in that form; it is a `Prop`, never an axiom.  What **is**
proved, in the concrete full-line model — which is the setting in which the semi-local
density can be computed, no `U` matching the model exactly — is the corresponding
asymptotic with the coefficient `4 f(1)` and with the two local terms `E(F)`, `f(1) z₁`
made explicit; see "The off-diagonal limit, and the finite part of the renormalized
cut-off trace" below.

The original plan for that proof went through the *diagonal* of the semi-local kernel, and
this is where it failed.  The plan reduced the divergence, by
`RequestProject/SemiLocalDiagonal.lean`, to the single real function `d(Λ) = Tr(S^{(Λ)})`
and required a *matching upper bound* `d(Λ) ≤ 2 log Λ + O(1)` (`DiagLogUpperBound`)
together with a two-variable estimate for `κ_Λ(λ)` near `λ = 1` (`ShortDistanceModulus`),
both stated precisely in `RequestProject/NearDiagonalKernel.lean`.  **`DiagLogUpperBound`
is false**: the true order is `d(Λ) = Θ(Λ²)`, see the subsection "Correction:
`DiagLogUpperBound` is false" below.  The logarithmic divergence is not a diagonal
phenomenon but an *averaged* one, and the successful route computes the semi-local density
in closed form and integrates it against the test function.  The conditional statements of
the next subsection remain valid as stated; they are recorded because they delimit exactly
what the operator-theoretic side alone can give.

### State of the renormalized-trace programme: the exact boundary

A compact summary of where the operator-theoretic side stops and Fourier-side input
begins.  All names below are `sorry`-free theorems of the project unless explicitly marked
as a hypothesis.

**(A) Fully proved, with no analytic input.**

1. *The cut-off family and its trace.*  `S^{(Λ)} = P^{(Λ)} P̂^{(Λ)} P^{(Λ)} = B_Λ^* B_Λ` is
   positive, self-adjoint, trace class at every scale, exhausts the identity, and its
   trace diverges (`RequestProject/CutoffFamily.lean`, `CutoffFamilyHS.lean`,
   `CutoffExhaustion.lean`, `TraceDivergence.lean`).
2. *Kernel form.*  `Tr(ϑ(f) S^{(Λ)}) = ∫ f(λ) κ_Λ(λ) d*λ` with
   `κ_Λ(λ) = Tr(ϑ(λ) S^{(Λ)}) = ⟪B_Λ^*, ϑ(λ) B_Λ^*⟫_HS` continuous, positive definite,
   maximal at `λ = 1`, `κ_Λ(λ⁻¹) = conj κ_Λ(λ)`
   (`RenormalizedTraceDensity.lean`, `RenormalizedDensitySymmetry.lean`,
   `RenormalizedDensityBound.lean`).
3. *Canonicity of the renormalization.*  The counter-term coefficient and the finite part
   are both determined by the family `Λ ↦ Tr(ϑ(f) S^{(Λ)})`; no coefficient other than
   `2 f(1)` can work; without renormalization there is no limit as soon as `f(1) ≠ 0`
   (`RenormalizedTraceUniqueness.lean`).
4. *Reduction to one scalar function.*  `d(Λ) = κ_Λ(1) = Tr(S^{(Λ)}) = ‖B_Λ‖²_{HS}` is
   nonnegative, monotone, divergent, dominates the whole trace
   (`|Tr(ϑ(f) S^{(Λ)})| ≤ ‖f‖_{L¹} d(Λ)`), and diverges at least logarithmically at rate
   `2|f(1)|/‖f‖_{L¹}` (`SemiLocalDiagonal.lean`).
5. *Equivalences of the target statement.*  `HasLogAsymptotics ↔ HasRenormalizedTrace` and
   `SemiLocalTraceAsymptotics U ↔ RenormalizedTraceIdentity U`
   (`SemiLocalDiagonal.lean`): the `o(1)` formulation and the limit formulation are the
   same statement.
6. *Near-diagonal machinery.*  `ε_Λ(λ) = d(Λ) - Re κ_Λ(λ) ≥ 0`, symmetric, continuous,
   with the Hilbert–Schmidt bound `ε_Λ(λ) ≤ ∑ᵢ ‖B_Λ^* eᵢ‖ ‖(1 - ϑ(λ)) B_Λ^* eᵢ‖`, and the
   averaging identity `Re Tr(ϑ(g) S^{(Λ)}) = ‖g‖_{L¹} d(Λ) - ∫ g ε_Λ d*λ` for nonnegative
   real `g` (`NearDiagonalKernel.lean`).

**(B) The two analytic hypotheses of the diagonal route** (both `Prop`s in
`RequestProject/NearDiagonalKernel.lean`, never axioms; the first is now *refuted*, the
second is neither proved nor used by any live result):

* `DiagLogUpperBound U b C` : `d(Λ) ≤ 2 log Λ + C` for all large `Λ`
  (existential form `HasDiagLogUpperBound U b`).  Fourier-side content: an upper bound for
  `‖B_Λ‖²_{HS}`, i.e. for the `L²` mass of the doubly truncated Fourier kernel.
* `ShortDistanceModulus U b M` : `ε_Λ(λ) ≤ M Λ · |log λ|` for `Λ ≥ 1` and all `λ`
  (existential form `HasShortDistanceModulus U b`).  Fourier-side content: an `L²`
  derivative estimate `‖(1 - ϑ(λ)) B_Λ^*‖_{HS} ≤ c(Λ)|log λ|` in the logarithmic variable.

**(C) The exact implication.**  What the two hypotheses give, and what they do not.

Proved, in `NearDiagonalKernel.lean`:

* `abs_diagDensity_sub_re_cutTrace_le` — `ShortDistanceModulus U b M` alone implies, for a
  nonnegative real test function `g` of mass `1` whose support has invariant log-width at
  most `r`, and every `Λ ≥ 1`,

      `|d(Λ) - Re Tr(ϑ(g) S^{(Λ)})| ≤ M Λ · r`;

  the upper half is the elementary `Re Tr(ϑ(g) S^{(Λ)}) ≤ ‖g‖_{L¹} d(Λ)`
  (`re_cutTrace_le_l1Norm_mul_diagDensity`), the lower half is
  `diagDensity_le_re_cutTrace_add`.
* `diagLogUpperBound_of_modulus_of_traceBound` — `ShortDistanceModulus` plus a trace bound
  `Re Tr(ϑ(g) S^{(Λ)}) ≤ 2 log Λ + C₀` on one balanced bump implies
  `DiagLogUpperBound U b (C₀ + C₁)` whenever `M Λ · r ≤ C₁`.
* `hasDiagLogAsymptotics_of_modulus_of_traceAsymptotics` — `ShortDistanceModulus` plus a
  *family* of mass-one bumps `G Λ` of log-width `r Λ` with `M Λ · r Λ ≤ w Λ → 0` (the
  balance: the modulus degrades with `Λ`, so the bump must be narrowed) converts the trace
  asymptotics `Re Tr(ϑ(G Λ) S^{(Λ)}) - 2 log Λ → c` into the diagonal asymptotics
  `d(Λ) = 2 log Λ + c + o(1)` (`HasDiagLogAsymptotics U b c`), hence into
  `HasDiagLogUpperBound U b` (`hasDiagLogUpperBound_of_modulus_of_traceAsymptotics`).
* `eventually_norm_cutTrace_le_of_diagLogUpperBound` — conversely, `DiagLogUpperBound U b C`
  gives the uniform bound `|Tr(ϑ(f) S^{(Λ)})| ≤ ‖f‖_{L¹}(2 log Λ + C)` for every test
  function, and together with the lower bound of (A4) it pins the rate
  `d(Λ)/log Λ → 2` (`tendsto_diagDensity_div_log_of_bounds`).

So the honest form of the implication is:

    DiagLogUpperBound + ShortDistanceModulus
      ⟹ the family `Λ ↦ Tr(ϑ(f) S^{(Λ)}) - 2 f(1) log Λ` is bounded, uniformly in `f` in
        the above quantitative sense, and the whole question is reduced to the single
        scalar family `d(Λ) - 2 log Λ`;

    HasDiagLogAsymptotics (i.e. that scalar family *converges*, not merely stays bounded)
      + ShortDistanceModulus with the balance `M Λ · r Λ → 0`
      ⟹ the diagonal part of `SemiLocalTraceAsymptotics`.

Two ingredients are therefore still missing beyond the two hypotheses, and this is exactly
the boundary of the operator-theoretic side:

1. *Convergence, not just boundedness*: `DiagLogUpperBound` is an `O(1)` statement, while
   `HasDiagLogAsymptotics` is an `o(1)` statement.  `HasDiagLogAsymptotics.diagLogUpperBound`
   proves one direction; the converse is false in general and is not claimed.
2. *Identification of the finite part*: for a general test function `f` the limit must be
   shown to be `L_Norm(f)`, which requires the off-diagonal limit `κ_Λ → κ_∞` (locally
   uniformly away from `λ = 1`) and the comparison of `κ_∞` with the explicit-formula
   kernel.  (**Since done**, and not through the diagonal: `κ_∞(λ) = λ^{1/2}/|1-λ|` is
   computed in `SemiLocalKernel.lean` / `SemiLocalSi.lean`, compared with the
   explicit-formula kernel in `WeilKernelComparison.lean`, and the finite part is obtained
   unconditionally in `CutoffLogProfile.lean`; see the subsection after next.)

Once both are supplied, `semiLocalTraceAsymptotics_iff_renormalizedTraceIdentity` turns the
result into `RenormalizedTraceIdentity U` with no further work.

### Correction: `DiagLogUpperBound` is false (`DiagonalQuadraticGrowth.lean`)

The first of the two hypotheses of (B) has since been **disproved**, by an explicit
Fourier-side computation with the sharp cut-offs actually used here.  For a normalized box
`v` of width `1/(2Λ)` inside `[-Λ, Λ]` the Fourier transform is a sinc profile,
`|𝓕 1_{[a, a+h]}(ξ)| = |sin(π h ξ)|/(π|ξ|)`, and Jordan's inequality gives
`‖P̂^{(Λ)} v‖² ≥ 4/π²`; the `⌊2Λ²⌋` translates of such a box are orthonormal, so
`‖B_Λ‖²_{HS} ≥ (4/π²)⌊2Λ²⌋`.  The elementary kernel bound gives the matching upper
bound.  Hence

    `(8/π²) Λ² − 4/π² ≤ d(Λ) ≤ 4 Λ²`   for `Λ ≥ 1`

(`diagDensity_ge_quadratic`, `diagDensity_le_four_mul_sq`): the diagonal density is of the
order of the *phase-space area* `4Λ²` of the box `[-Λ,Λ] × [-Λ,Λ]`, not logarithmic.
Consequently:

* `not_diagLogUpperBound` : `¬ DiagLogUpperBound U b C` for every `C`, and
  `not_hasDiagLogUpperBound`, `not_hasDiagLogAsymptotics`;
* `not_traceAsymptotics_of_modulus` : reading the transfer theorem
  `hasDiagLogAsymptotics_of_modulus_of_traceAsymptotics` contrapositively, a short-distance
  modulus `M` together with a balanced bump family (`M Λ · r Λ → 0`) *excludes* the
  logarithmic trace asymptotics.  The two hypotheses of (B) are therefore not merely
  unproved: in the balanced regime they are incompatible with the expected asymptotics.

Nothing above contradicts the trace asymptotics `Tr(ϑ(f) S^{(Λ)}) = 2 f(1) log Λ + O(1)`
itself: `κ_Λ` is a positive-definite function of `λ` of height `Θ(Λ²)` concentrated in a
window of width `~Λ⁻²` about the diagonal, so its *average* against a fixed test function
is of size `log Λ` while its value at `λ = 1` is not.  What is refuted is the reduction of
the logarithmic divergence to the diagonal value `d(Λ)`; the statements of (A) and (C),
being conditional, all remain valid.  A correct route to the counter-term must use either
a modulus that is *not* balanced (so that the bump cannot be narrowed below the
diagonal window `~Λ⁻²`), or a smoothed cut-off family whose diagonal value is genuinely
logarithmic.

### The off-diagonal limit, and the finite part of the renormalized cut-off trace (proved)

This subsection records the part of the renormalized-trace programme that is **done**.  It
replaces the diagonal route of the previous two subsections; all names below are
`sorry`-free theorems, depending only on the three standard axioms.  In one paragraph:

* *off-diagonal recovery of the Weil kernel*: the semi-local density `κ_Λ` has a closed
  form as a sine integral and converges, as `Λ → ∞`, to `λ^{1/2}/|1-λ|`, the kernel of
  the archimedean explicit formula (plus its reflection, the odd-part contribution of the
  full line);
* *unconditional finite-part asymptotic*: `Tr(ϑ(f) S^{(Λ)}) - 4 f(1) log Λ` converges for
  every continuous compactly supported `f` that is Lipschitz at `λ = 1`;
* *identification of the limit*: it equals `D(F) - L_Norm(F) + E(F) + f(1) z₁`, i.e. the
  normalised archimedean functional `L_Norm` up to the local term `E(F)` (the odd part)
  and the universal constant `z₁` (which multiplies only `f(1)` and is not evaluated
  here);
* *the coefficient is `4`, not the paper's `2`*, because the model is the full line
  `L²(ℝ)` and not the even (Sonin) subspace; see "On the coefficient" at the end of the
  subsection.

In detail, module by module:

* `RequestProject/SemiLocalKernel.lean`, `RequestProject/SemiLocalSi.lean` — **the
  off-diagonal limit is the archimedean Weil kernel.**  The semi-local density is evaluated
  in closed form as a sine-integral,

      `κ_Λ(a) = √a · (2/(π(a-1))) · Si(2π(a-1)Λ²/max(1,a))`   (`semiLocalDensity_eq_Si`),

  whence `κ_Λ(a) → √a/|a-1|` (`tendsto_semiLocalDensity_atTop`), i.e., in the scaling
  variable, `Tr(ϑ(λ) S^{(Λ)}) → λ^{1/2}/|1-λ|` (`tendsto_semiLocalDensity_scaling`), with
  the uniform domination `|κ_Λ(a)| ≤ (2 Si(π)/π)·√a/|a-1|` (`norm_semiLocalDensity_le`) and
  the diagonal bound `|κ_Λ| ≤ 4Λ²`.  This is the function `κ_∞` that the paragraph (C2)
  above declared missing.

* `RequestProject/RenormalizedFinitePart.lean` — **the finite part exists, for test
  functions vanishing at the singularity.**  Because the abstract `cutTrace b U Λ f` is
  parameterized by an arbitrary unitary `U` of the two pictures, and no such `U` matches
  the concrete dilation model (`weilMap` is an isometry onto the *even* subspace only), the
  concrete model trace is used directly:

      `modelCutTrace b Λ f = ∫ f(λ) κ_Λ(λ⁻¹) d*λ`,   `weilPairing f = ∫ f(λ) λ^{1/2}/|1-λ| d*λ`.

  Proved by dominated convergence, with the Si-bound above as dominating function: if
  `‖f(λ)‖ ≤ C|1-λ|` (Lipschitz at the singularity) then

      `Tr(ϑ(f) S^{(Λ)}) = modelCutTrace b Λ f ⟶ weilPairing f`
      (`tendsto_modelCutTrace_of_lipschitz_at_one`),

  the pairing being absolutely convergent (`integrable_weilPairing`).  For such `f` there
  is no counter-term, so this *is* the finite part.  `modelCutTrace` is linear in `f`
  (`modelCutTrace_add`, `modelCutTrace_smul`), which reduces the general case to one
  reference function: `HasCutoffLogProfile b h c z₀` (a `Prop`, never an axiom) says that a
  single `h` has the profile `Tr(ϑ(h) S^{(Λ)}) = c log Λ + z₀ + o(1)`, and
  `hasFinitePart_of_reference` then gives the expansion for every admissible `f`.

* `RequestProject/WeilKernelComparison.lean` — **the limiting kernel is the kernel of the
  explicit formula.**  In the logarithmic coordinate `λ = e^u`,

      `√λ/|1-λ| = 1/(2 sinh(|u|/2)) = sinhKernel u + sinhKernelRefl u`
      (`weilKernelLog_eq_sinhKernel_add`),

  where `sinhKernel u = e^{|u|/2}/(e^{|u|}-e^{-|u|})` is *exactly* the kernel of the
  archimedean Weil distribution already formalized in
  `RequestProject/ArchimedeanExplicit.lean`, and `sinhKernelRefl u = e^{-|u|/2}/(e^{|u|}-e^{-|u|})`
  is the reflected kernel, i.e. the contribution of the **odd** part of `L²(ℝ)` (the paper
  works on the even part `L²(ℝ)_ev`; the model here is the full line).  Hence, for `f`
  Lipschitz at `1`,

      `weilPairing f = W_ℝ(∆^{-1/2} F) + E(F)`,  `F = logTest f`
      (`weilPairing_eq_weilR_add_reflectionPairing`),

  and therefore

      `Tr(ϑ(f) S^{(Λ)}) ⟶ W_ℝ(∆^{-1/2} F) + E(F) = D(F) - L_Norm(F) + E(F)`
      (`tendsto_modelCutTrace_weilR`, `weilR_eq_sub_LfunNorm`,
      `tendsto_modelCutTrace_LfunNorm`).

* `RequestProject/RenormalizedAsymptotics.lean` — **the full expansion, for all test
  functions, modulo two scalars.**  The regularized pairing with the reflected kernel,
  `reflectionPairingReg`, is defined by the same subtraction that regularizes `W_ℝ`, and
  both regularized pairings are linear
  (`weilR_ofLog_sub_smul`, `reflectionPairingReg_sub_smul`).  Combining this with
  `hasFinitePart_of_reference` gives `exists_universal_finitePart`: if *one* reference
  function `h` with `h(1) = 1`, Lipschitz at `1`, has the logarithmic profile `(c, z₀)`,
  then there is a **universal** constant `z₁` such that **every** test function `f` which
  is Lipschitz at `1` satisfies

      `Tr(ϑ(f) S^{(Λ)}) - f(1)·c·log Λ  ⟶  W_ℝ(∆^{-1/2} F) + E(F) + f(1)·z₁`.

  So the whole `f`-dependence of the finite part is the archimedean Weil distribution,
  i.e. `D(F) - L_Norm(F)`, plus the explicitly identified odd-part term; only the two
  scalars `c, z₁` are not computed here.

* `RequestProject/CutoffLogProfileAux.lean`, `RequestProject/CutoffLogProfile.lean` —
  **the logarithmic profile of a reference function, hence the unconditional asymptotic.**
  This removes the hypothesis `HasCutoffLogProfile` from the previous bullet.  In the
  logarithmic coordinate `λ = e^u`, and with `T = 2πΛ²`, the closed form of the semi-local
  density reads

      `κ_Λ(e^u) = Si(T ψ(u)) / (π sinh(u/2))`,   `ψ(u) = (e^u - 1)/max(1, e^u)`
      (`logDens`, `semiLocal_formula_eq`, `modelCutTrace_eq_integral_logDens`).

  Pairing it with the triangular bump `refBump(λ) = max(0, 1 - |log λ|)` and splitting

      `Si(Tψ(u))/(π sinh(u/2)) = Si(Tψ(u))·w(u) + (Si(Tψ(u)) - Si(Tu))·2/(πu)
                                    + Si(Tu)·2/(πu)`,

  with `w(u) = 1/(π sinh(u/2)) - 2/(πu)` bounded by `1/π` on `|u| ≤ 1` (`abs_wKer_le`),
  gives `theta = thetaA + thetaB + thetaC` (`theta_eq_add`).  The first piece converges by
  dominated convergence (`exists_tendsto_thetaA`); the second tends to `0`, by the uniform
  estimate `|Si(Tψ(u)) - Si(Tu)| ≤ 2|u|` (`abs_Si_psi_sub_Si_le_two_abs`, proved from
  `|Si x - Si y| ≤ |x-y|/min(x,y)` and `|ψ(u) - u| ≤ u²`), giving `tendsto_thetaB`; the
  third is computed exactly,

      `thetaC(T) = (4/π)·(∫_0^T Si(s)/s ds - ∫_0^1 Si(Tu) du)`   (`thetaC_eq`),

  and `∫_0^T Si(s)/s ds - (π/2) log T` converges (`exists_tendsto_siDivInt`, from
  `|Si s - π/2| ≤ 1/s + 1/s²`) while `∫_0^1 Si(Tu) du → π/2` (`tendsto_integral_Si_mul`).
  Hence `theta(T) - 2 log T` converges (`exists_tendsto_theta`) and, since `T = 2πΛ²`,

      `Tr(ϑ(refBump) S^{(Λ)}) = 4 log Λ + z₀ + o(1)`
      (`exists_hasCutoffLogProfile_refBump`: the profile holds with `c = 4`).

  Feeding this into `exists_universal_finitePart` yields the unconditional statements

      `∃ z₁, ∀ f Lipschitz at 1:
         Tr(ϑ(f) S^{(Λ)}) - 4 f(1) log Λ ⟶ W_ℝ(∆^{-1/2}F) + E(F) + f(1) z₁`
      (`exists_universal_finitePart_unconditional`), equivalently
      `⟶ D(F) - L_Norm(F) + E(F) + f(1) z₁`
      (`exists_universal_finitePart_LfunNorm`).

  So the renormalized cut-off trace converges after subtraction of the logarithmic
  counter-term, and its finite part is the normalised archimedean functional `L_Norm`
  (through `W_ℝ = D - L_Norm`, i.e. the pairing against the recovered kernel
  `λ^{1/2}/|1-λ|`), plus the odd-part term `E` and the local multiple `f(1) z₁`.  No
  `sorry` is used, and only the three standard axioms are involved.

  **On the coefficient.**  The coefficient of `log Λ` in this full-line statement is
  `4 f(1)`, not the paper's `2 f(1)`: the model computes on the *full* line `L²(ℝ)`, whose
  limiting density is `sinhKernel + sinhKernelRefl`, and where the natural phase-space
  scale is `Λ²` (`4 log Λ = 2 log Λ²`).  The paper's `2 f(1) log Λ` refers to the even
  (Sonin) subspace, and is obtained by the restriction described in the next bullet.

* `RequestProject/EvenSemiLocalKernel.lean`, `RequestProject/EvenCutoffTrace.lean`,
  `RequestProject/EvenConstantAux.lean`, `RequestProject/EvenConstant.lean` —
  **the restriction to the even (Sonin) subspace: coefficient exactly `2 f(1)`.**
  With `reflCLM` the reflection `(R ξ)(x) = ξ(-x)` and `evenProjCLM = (1 + R)/2` the
  orthogonal projection onto even functions (both self-adjoint, `adjoint_reflCLM`,
  `adjoint_evenProjCLM`), the even semi-local density `κ^{ev}_Λ(a) = Tr(D_a S^{(Λ)} P_ev)`
  is computed by exactly the same route as in the full-line case: the reflection sends the
  kernel vector `k_x` of the doubly truncated Fourier transform to `k_{-x}`
  (`reflCLM_cutKernelVec`), so `κ^{ev}_Λ(a) = ∫ ⟪P_ev k_x, D_a k_x⟫ dx`
  (`evenSemiLocalDensity_eq_integral_inner`), and the new pairing is the same phase
  integral with `a - 1` replaced by `a + 1`
  (`inner_cutKernelVec_neg_dil_of_mem`).  This gives the closed form

      `κ^{ev}_Λ(a) = ½ √a [ (2/(π(a-1))) Si(2π(a-1)Λ²/max(1,a))
                             + (2/(π(a+1))) Si(2π(a+1)Λ²/max(1,a)) ]`
      (`evenSemiLocalDensity_eq_Si`), hence `evenModelCutTrace_eq_half`.

  The second summand — the reflected density `reflDensityVal` — is regular at `a = 1` and
  bounded uniformly in the cut-off by `Si π/π` (`abs_reflDensityVal_le`), so it converges
  by dominated convergence to the pairing against `√λ/(1+λ)` (`tendsto_reflModelCutTrace`)
  and carries **no** logarithmic divergence.  Halving the full-line divergence therefore
  yields exactly `2 f(1) log Λ`.  Moreover, in the logarithmic coordinate

      `½ (1/(2 sinh(|u|/2)) + 1/(2 cosh(u/2))) = sinhKernel u`
      (`coshKernelLog_eq_sub`),

  so the odd-part term `E(F) = reflectionPairingReg F` of the full-line statement cancels
  exactly against the reflected contribution (`coshPairing_eq_weilR_sub`).  The result is

      `∃ z_ev, ∀ f Lipschitz at 1:
         Tr(ϑ(f) S^{(Λ)} P_ev) - 2 f(1) log Λ ⟶ W_ℝ(∆^{-1/2}F) + f(1) z_ev`
      (`exists_universal_even_finitePart`), equivalently
      `⟶ D(F) - L_Norm(F) + f(1) z_ev`
      (`exists_universal_even_finitePart_LfunNorm`),

  i.e. the finite part is the normalised archimedean functional `L_Norm` up to the purely
  local constant `f(1) z_ev`.  Finally `RequestProject/EvenConstant.lean` evaluates that
  constant, `z_ev = 2 siLogConst/π - γ` (`zEvenVal`, `even_finitePart_value`,
  `even_finitePart_value_LfunNorm`), all elementary contributions cancelling through
  `thetaAVal + triJVal = 4 log 2 + 2` (`RequestProject/EvenConstantAux.lean`).  No `sorry`
  is used, and only the three standard axioms are involved.

**What is still missing, precisely.**

1. *The constant `z₁`.*  It exists unconditionally (`exists_universal_finitePart_LfunNorm`)
   but is not evaluated in closed form: it is `z₀ + (the regularized pairings of the
   reference bump)`, with `z₀ = lim (theta(2πΛ²) - 4 log Λ)`.  Its value is not needed for
   the convergence statement, only for a numerical normalization.  (The coefficient `c`,
   by contrast, is now computed: `c = 4` in this model.)
2. *The odd part.*  Settled: in the full-line model the limiting density is
   `sinhKernel + sinhKernelRefl`, not `sinhKernel` alone, but on the even subspace
   `L²(ℝ)_ev` the reflected phase integral (the same computation with `(a-1)` replaced by
   `(a+1)`) has been carried out and averaged in
   `RequestProject/EvenSemiLocalKernel.lean` / `RequestProject/EvenCutoffTrace.lean`, and
   the odd-part term `E(F)` cancels exactly.
3. *The value of the coefficient.*  Settled in both pictures: on the full line the
   divergence is `4 f(1) log Λ = 2 f(1) log(Λ²)` (the phase-space scale is `Λ²`, cf.
   `diagDensity = Θ(Λ²)` above), proved in `exists_hasCutoffLogProfile_refBump`; on the
   even (Sonin) subspace it is exactly the `2 f(1) log Λ` of `logCounterTerm`, the paper's
   normalisation (`exists_universal_even_finitePart`).


## What is formalized and proved

Module-by-module list of the *analytic* side and of the operator groundwork.  The modules
of the renormalized-trace programme (`CutoffFamily`, `CutoffFamilyHS`, `CutoffExhaustion`,
`TraceDivergence`, `RenormalizedTrace*`, `RenormalizedDensity*`, `SemiLocalDiagonal`,
`NearDiagonalKernel`, `DiagonalQuadraticGrowth`, `SemiLocalKernel`, `SemiLocalSi`,
`RenormalizedFinitePart`, `WeilKernelComparison`, `RenormalizedAsymptotics`,
`CutoffLogProfileAux`, `CutoffLogProfile`, `EvenSemiLocalKernel`, `EvenCutoffTrace`,
`EvenConstantAux`, `EvenConstant`) are described in the section "Status: the
renormalized-trace programme" above and are not repeated here; the modules
`HilbertSchmidtKernel`, `FourierL2Integral`, `CutoffHilbertSchmidt`, `LogPicture`,
`TraceIdentityNorm`, `EvenPicture`, `TraceDensity`, `TraceDensitySymmetry`,
`TraceIdentityObstruction` are described in "Operator-theoretic progress" and "The trace
identity with a fixed cutoff" below.  The modules `RequestProject/A5Artin.lean`,
`RequestProject/A5ArtinPerm.lean`, `RequestProject/A5ArtinConductor.lean`,
`RequestProject/A5ArtinSubgroup.lean`, `RequestProject/A5ArtinDecomposition.lean` and
`RequestProject/A5AxiomAudit.lean` belong to a separate, self-contained development (the
`A₅` Artin material backing `docs/A5_even_Artin.md` and `scripts/a5`) and are unrelated to
the Weil-positivity chain.

Status of that `A₅` development (all of it `sorry`-free, only the standard axioms):

* `A5Artin.lean` — the local Euler factors of the five irreducible representations of `A₅`
  class by class, and the four factorisation identities `ζ_K = ζ·L(ρ₄)`, `ζ_{K₆} = ζ·L(ρ₅)`,
  `ζ_{K₁₂} = ζ·L(ρ₃)L(ρ₃′)L(ρ₅)`, `ζ_N = ζ·L(ρ₃)³L(ρ₃′)³L(ρ₄)⁴L(ρ₅)⁵`; plus the character
  table with the orthogonality relations used, and the total reality of two explicit quintics.
* `A5ArtinPerm.lean` — identification of the two main left-hand sides with the determinants
  `det(1 − T·ρ(g))` of the 5-point permutation representation and of the regular
  representation, via explicit conjugacy-class representatives in `Equiv.Perm (Fin 5)`.
* `A5ArtinConductor.lean` — the Artin conductors.  The conductor exponent
  `a(ρ) = Σ_{i ≥ 0} (|G_i|/|G₀|)·codim V^{G_i}` of a higher ramification filtration
  (`condExp`) and the global conductor `N(ρ) = ∏_p p^{a(ρ,p)}` (`artinConductor`) are
  defined; the invariant dimensions entering the formula are proved to be the character
  averages (`fixedDim_mul_card_eq_charSum`).  Proved: `d_K = N(ρ₄)` (conductor–discriminant,
  `discK_eq_artinConductor_r4`), `N(ρ₃) = N(ρ₃′) = N(ρ₄) = d_K` when no inertia group has
  order 5 (`artinConductor_three_eq_discK`; the hypothesis is necessary, `codim_r3_C5`),
  `N(ρ₅) = d_K · excess` with `d_K ∣ N(ρ₅)` (`artinConductor_r5_eq_discK_mul_excess`), and
  the conductor counterparts of the zeta factorisations above
  (`artinConductor_perm6_eq_r5`, `artinConductor_perm12_eq`, `artinConductor_reg_eq`).
  Also `N(ρ₅) = d_{K₆}` (`discK6_eq_artinConductor_r5`) and the unconditional
  `C₅`-deficit comparison `d_K = N(ρ₃)·deficit` (`discK_eq_artinConductor_r3_mul_deficit`,
  `artinConductor_r3_dvd_discK`, `deficit_eq_one`).  `table_conductors` verifies the
  conductors of the fifteen smallest totally real `A₅` quintic fields against the numbers
  used in `docs/A5_even_Artin.md`; that verification is conditional on the ramification
  filtrations listed in `table`, whose wild entries were inferred from `v_p(d_K)`.  Note
  that `condExp` divides each term of the conductor sum by `|G₀|` separately, so it agrees
  with the true Artin exponent under the hypothesis `IntegralAt` (`condExp_cast`); Artin's
  integrality theorem itself is not formalised.
* `A5ArtinSubgroup.lean` — the table of subgroup types `Subgp` is grounded in genuine
  subgroups of `Equiv.Perm (Fin 5)` generated by the class representatives of
  `A5ArtinPerm.lean`: `Subgp.closure_gens`, `Subgp.toSubgroup_le_alternatingGroup`,
  `Subgp.card_toSubgroup`, and `Subgp.count_eq_card_filter`, which turns the hand-written
  count table into a theorem about `A₅`-conjugacy classes.
* `A5ArtinDecomposition.lean` — one decomposition datum `decompose : IRep → List (ℕ × IRep)`
  yields the character identity (`chi_eq_decompose`), the conductor factorisation
  `N(R) = ∏ N(Rᵢ)^{mᵢ}` (`artinConductor_eq_decompose`) and the Euler-factor identity
  `L_R = ∏ L_{Rᵢ}^{mᵢ}` (`euler_eq_decompose`), from which `permPoly5_eq` … `regPoly_eq`
  are recovered.
* `A5AxiomAudit.lean` — the `#print axioms` audit of the `A₅` results; it imports only the
  `A5Artin*` modules, so it is independent of the Weil chain.

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

* `RequestProject/SoninJoin.lean` — **the operator form of `S = 1 - (P₁ ∨ P̂₁)`**
  - `cutoffJoin`, the join `P₁ ∨ P̂₁` in the lattice of closed subspaces (the closure of
    the sum of the two ranges), and `cutoffJoinProjection`, the orthogonal projection onto
    it, with `soninSpace_eq_orthogonal_cutoffJoin` and
    `cutoffJoin_eq_orthogonal_soninSpace`;
  - **`soninProjection_eq_one_sub_cutoffJoinProjection`**: the identity
    `S = 1 - (P₁ ∨ P̂₁)` between operators, and its dual form;
  - the elementary identities `soninProjection_sq`, `soninProjection_star`,
    `soninProjection_nonneg` (`S² = S = S* ≥ 0`), `norm_soninProjection_apply_le`, and
    `soninProjection_comp_P1` / `soninProjection_comp_P1hat` (`S P₁ = S P̂₁ = 0`);
  - **`P1_P1hat_P1_isPositive`**: `P₁ P̂₁ P₁ ≥ 0`, the positivity of the operator occurring
    in `L(f) = Tr(ϑ(f) P P̂ P)`, and `soninProjection_conj_isPositive` (`S A S ≥ 0` for
    `A ≥ 0`).

* `RequestProject/Scaling.lean`
  - `scaling`, the unitary scaling representation `ϑ` of `ℝ⋆₊`, realized as the regular
    representation on `L²(ℝ⋆₊, d*ρ)`, with the representation law `ϑ(ab) = ϑ(a)ϑ(b)`;
  - `logCoordinates`, the isometry onto `L²(ℝ, dt)` given by `ρ = e^t`.

* `RequestProject/ScalingIntegrated.lean` — **the integrated representation `ϑ(f)`**
  - **`continuous_scaling_apply`**: the scaling representation is *strongly continuous*
    (`λ ↦ ϑ(λ)ξ` is continuous for every `ξ ∈ L²`), obtained from the continuity of the
    domain action of a locally compact group on `Lᵖ` of its Haar measure;
  - `integrable_smul_scaling`: for `f ∈ C_c(ℝ⋆₊)` the integrand `λ ↦ f(λ) ϑ(λ)ξ` is a
    continuous compactly supported `L²`-valued map, hence Bochner integrable;
  - **`scalingOp`**, the integrated operator `ϑ(f)ξ = ∫ f(λ) ϑ(λ)ξ d*λ`, with the
    `L¹`-bounds `norm_scalingOp_apply_le` and `norm_scalingOp_le` (`‖ϑ(f)‖ ≤ ‖f‖₁`),
    linearity in `f` (`scalingOp_add`, `scalingOp_smul`, `scalingOp_zero`) and the matrix
    coefficients `inner_scalingOp_apply`;
  - `starTest`, the involution `f^♯(λ) = conj (f(λ⁻¹))` of the convolution algebra, and
    **`adjoint_scalingOp`**: `ϑ(f)* = ϑ(f^♯)`.

* `RequestProject/TraceClass.lean` — **minimal trace-class groundwork** (Mathlib has none
  at the pinned version)
  - `hsNormSq b T = ∑ᵢ ‖T bᵢ‖²`, the Hilbert–Schmidt norm squared along a Hilbert basis,
    with Parseval's identity `tsum_norm_sq_inner` / `tsum_enorm_sq_inner`;
  - **`hsNormSq_adjoint`** and **`hsNormSq_basis_indep`**: the Hilbert–Schmidt norm is
    unchanged by passing to the adjoint and *does not depend on the Hilbert basis*;
  - `IsHilbertSchmidt`, `IsTraceClass` (a product of two Hilbert–Schmidt operators),
    `IsHilbertSchmidt.summable_norm_sq`, `isHilbertSchmidt_basis_indep`;
  - `traceAlong b T = ∑ᵢ ⟪bᵢ, T bᵢ⟫` and `traceAlongRe`, with
    **`summable_norm_inner_of_isTraceClass`** (absolute convergence of the trace series of
    a trace-class operator), **`traceAlongRe_nonneg`** (`Tr T ≥ 0` for `T ≥ 0`),
    **`traceAlongRe_conj_nonneg`** (`Tr(B* A B) ≥ 0` for `A ≥ 0`) and
    `traceAlong_eq_traceAlongRe`.

* `RequestProject/TestConvolution.lean` — **the convolution algebra `C_c(ℝ⋆₊)` and
  multiplicativity of `ϑ`**
  - `logTest`, a test function read in logarithmic coordinates, with
    `continuous_logTest` / `hasCompactSupport_logTest`;
  - `convFun f g ρ = ∫ f(α) g(α⁻¹ρ) d*α` and `convFun_expHomeo`, the identification of the
    multiplicative convolution with Mathlib's convolution on `ℝ`, whence
    `continuous_convFun` and `hasCompactSupport_convFun`;
  - `testConv`, **the convolution product on `C_c(ℝ⋆₊)`**;
  - `convIntegrand` and its integrability on the product measure, and
    **`scalingOp_testConv`**: `ϑ(f ∗ g) = ϑ(f) ϑ(g)`;
  - **`scalingOp_testConv_starTest`** (`ϑ(g ∗ g^♯) = ϑ(g) ϑ(g)*`) and
    **`scalingOp_testConv_starTest_isPositive`**.

* `RequestProject/TraceProperty.lean` — **the trace property**
  - `summable_sq_matrix`, `summable_matrix_prod`, `inner_comp_eq_tsum`, the absolute
    summability of the matrix family `⟪bᵢ, A bⱼ⟫ ⟪bⱼ, B bᵢ⟫` for Hilbert–Schmidt `A, B`;
  - **`traceAlong_comm`**: `Tr(AB) = Tr(BA)` for `A, B` Hilbert–Schmidt, by the classical
    double-sum exchange.

* `RequestProject/TraceBasisIndep.lean` — **basis independence of the trace**
  - `hsInner b A B = ∑ᵢ ⟪A bᵢ, B bᵢ⟫`, the Hilbert–Schmidt inner product, with
    `summable_hsInner_matrix`, `hsInner_eq_hsInner_adjoint` and
    **`hsInner_basis_indep`**;
  - `traceAlong_comp_eq_hsInner`, **`traceAlong_comp_basis_indep`**,
    `isTraceClass_basis_indep` and **`traceAlong_basis_indep_of_isTraceClass`**: the trace
    of a trace-class operator is the same along any Hilbert basis.

* `RequestProject/TraceScaling.lean` — *not on any live proof path* (superseded by
  `RequestProject/TracePositivity.lean`, which proves the same mechanism in the picture
  actually used; kept as a self-contained record, and imported by
  `RequestProject/Main.lean` so that it is elaborated)
  - **`traceAlongRe_scalingOp_conj_nonneg`** and
    **`traceAlongRe_scalingOp_starTest_nonneg`**: `Tr(ϑ(f)* A ϑ(f)) = Tr(ϑ(f^♯) A ϑ(f)) ≥ 0`
    for every positive `A`, the positivity mechanism of `L(f) = Tr(ϑ(f) P P̂ P)`;
  - `summable_norm_inner_scalingOp_conj`, the absolute convergence of that trace when the
    conjugated operator is trace class.

* `RequestProject/TracePositivity.lean` — **the positivity mechanism of `L`**
  - `hsNormSq_comp_le`, `IsHilbertSchmidt.comp_left`, `IsHilbertSchmidt.comp_right`: the
    Hilbert–Schmidt operators form a two-sided ideal;
  - **`traceAlong_selfAdjointSandwich`**: `Tr((T T*)(B* B)) = Tr((B T)(B T)*)` for `B`
    Hilbert–Schmidt, and **`re_traceAlong_selfAdjointSandwich_nonneg`**, its consequence
    `Re Tr((T T*)(B* B)) ≥ 0`;
  - **`re_traceAlong_scalingOp_testConv_starTest_nonneg`**:
    `Re Tr(ϑ(g ∗ g^♯) B* B) ≥ 0` for every Hilbert–Schmidt `B`.  With `B = P̂ P` the
    operator `B* B` is the Sonin sandwich `P P̂ P`, so this is the operator-theoretic
    content of the positivity of `L`, waiting only for the identification of `L(f)` with
    the trace.

* `RequestProject/SoninSandwich.lean` — **the Sonin sandwich as a square**
  - `adjoint_P1hat` and **`P1_P1hat_P1_eq_adjoint_comp`**: `P₁ P̂₁ P₁ = (P̂₁ P₁)* (P̂₁ P₁)`;
  - **`re_traceAlong_soninSandwich_nonneg`**: `Re Tr((T T*) P₁ P̂₁ P₁) ≥ 0` whenever `P̂₁ P₁`
    is Hilbert–Schmidt — the positivity of `L` in the exact operator shape in which it is
    used, still on `L²(ℝ, dx)`.

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
  - `LPositivity`, the positivity of `L` in the unnormalized pairing, which is **false**
    (`not_LPositivity`, `RequestProject/UnnormalizedCounterexample.lean`): `Lfun` pairs
    `W_ℝ` with `f` where the paper pairs it with `∆^{-1/2} f`, and the discrepancy is a
    nonnegative deficit growing with the width of the support.  The statement
    `L_positive` of the original skeleton has been withdrawn (it is kept, commented out
    and documented, in `RequestProject/Positivity.lean`).  Every statement below takes
    `LPositivity` as an explicit hypothesis instead of using it, so each of them is now
    vacuous as stated, and each has an unconditional counterpart, in the normalization of
    the paper, in `RequestProject/NormalizedPositivity.lean`;
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
  - the inequality `2θ'(t) + δ̂(t) ≥ 0` of Corollary 2.3 (ii) is **proved**, for every real
    `t`, in `RequestProject/PolyaLowThreshold.lean` (`fourierSide_nonneg`,
    `two_thetaDeriv_add_deltaFourier_nonneg`); the statement used to be recorded in this
    file as a `sorry`, and is kept here only as a comment.  The proof combines the
    near-origin range `|t| ≤ 0.18` of `RequestProject/NearOrigin.lean`, the low-frequency
    bands `0.18 ≤ |t| ≤ 1.8` of `RequestProject/PolyaLowBand0.lean`–`PolyaLowBand10.lean`,
    and the large-frequency range `|t| ≥ 1.8` of
    `RequestProject/PolyaLinThreshold.lean`;
  - the file contains **no `sorry`**.  The implication `LPositivity_of_fourierSide_nonneg`,
    which used to record that this inequality gives the positivity of `L` in the
    *unnormalized* pairing of `LPositivity`, is kept only as a comment: that pairing is
    not the one of Corollary 2.3 (the normalization mismatch discussed in
    `RequestProject/ArchimedeanExplicit.lean`), so the implication is not provable as
    stated.  Its two defects are settled in `RequestProject/NormalizedPositivity.lean`:
    `LPositivityNorm_holds` proves the positivity of `L` in the normalization of the paper
    on all `C⁴` test functions, and `LPositivityC4_of_WinftyParseval` proves the
    unnormalized implication on the same class, the Bochner-type integrability gap having
    been removed by the quartic decay estimates of `RequestProject/QuarticDecay.lean`.

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
    and `W_∞(Q(ξ ∗ ξ*)) ≥ (2/15)‖ξ‖²` granted the positivity of `L`; that last one is
    unconditional, for `ξ` of class `C⁶`, in
    `RequestProject/NormalizedPositivity.lean`).  The existential `∃ a > 0` of
    `small_support_DQ_negative` is thus replaced by the explicit `a = 1/30`.

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
    transform is integrable.  The predicate `LPositivity` quantifies over all continuous
    compactly supported positive definite test functions, for which the integrability of
    `f̂` is a theorem of Bochner type that is not formalized here; on the class of `C⁴`
    test functions the integrability *is* proved
    (`RequestProject/QuarticDecay.lean`), which turns
    `L_real_nonneg_of_fourierSide_nonneg` into `LPositivityC4_of_WinftyParseval`
    (`RequestProject/NormalizedPositivity.lean`), and the small-support results acquire
    unconditional counterparts there, in the normalization of the paper.

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
    (`fourierSide_nonneg_of_abs_le`, valid for `|t| ≤ 0.18`) and the successively improved
    thresholds `|t| ≥ 23`
    (`RequestProject/DeltaVariation.lean`), `|t| ≥ 8`
    (`RequestProject/PolyaThreshold.lean`), `|t| ≥ 5.5`
    (`RequestProject/PolyaOscThreshold.lean`) and `|t| ≥ 1.8`
    (`RequestProject/PolyaLinThreshold.lean`), and with the low-frequency bands covering
    `0.18 ≤ |t| ≤ 1.8` (`RequestProject/PolyaLowThreshold.lean`), Corollary 2.3 (ii) is
    now proved for **every** real `t`.  See
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

* `RequestProject/MidThreshold.lean` — **the Fourier-side inequality for `|t| ≥ 34`**
  - the alternating *upper* Taylor bound for the sine integral (`Si_le_siPart`,
    `Si_le_quintic`: `Si x ≤ x - x³/18 + x⁵/600`), complementing the lower bounds of
    `RequestProject/TaylorBounds.lean`;
  - the exact form of the two sine-integral abscissae (`two_delta_eq_si`,
    `smoothKernel_eq_si`), whence **`two_delta_le_smoothKernel`: the kernel
    `k_Θ(v) = 2 e^{-v/2}/(1-e^{-2v})` already dominates `2δ(e^v)` for `1/5 ≤ v ≤ 1/4`**
    and **`two_delta_le_smooth_add`: `2δ(e^v) - k_Θ(v) ≤ tailMajorant v` for all `v > 0`**,
    with the *unweighted* majorant
    `tailMajorant v = u³(1 + (1-u²)^{-2})/π² + u⁵(1 + (1-u²)^{-3})/(2π³)`, `u = e^{-v/2}`;
  - the explicit antiderivative `midAntiU` of that majorant (a rational function of `u`
    plus an `artanh`), giving `integral_tailMajorant_Ioi` and
    **`integral_tailMajorant_le`: `∫_{1/4}^∞ tailMajorant ≤ 0.4`** (true value `0.39536…`);
  - the truncation gap `gapMajorant` (`smooth_sub_trunc_le_gap`, mass at most `0.015`),
    the combined majorant `midMajorant` and **`integral_midMajorant_le`: total mass at most
    `0.415`**, whence, using only `1 - cos tv ≤ 2`,
    **`deltaSpread_le_truncSum_add`: `Δ(t) ≤ ∑_{n<8} Θₙ(t) + 0.83`**;
  - since the terms `8 ≤ n < 80` of the series for `Θ` already contribute more than
    `0.8228` when `|t| ≥ 34` (`sum_thetaSeriesTerm_ge_of_thirtyfour`), this yields
    **`fourierSide_nonneg_of_thirtyfour_le_abs`: `2θ'(t) + δ̂(t) ≥ 0` for `|t| ≥ 34`**,
    improving the threshold `60` of `RequestProject/ThetaGrowth.lean`.

* `RequestProject/PolyaModel.lean`, `RequestProject/PolyaError.lean`,
  `RequestProject/PolyaPartition1.lean`–`RequestProject/PolyaPartition3.lean`,
  `RequestProject/PolyaThreshold.lean` — **the Fourier-side inequality for `|t| ≥ 8`**
  - the Pólya-type model `h(v) = e^{-v/2} + 2.11 e^{-3v}` for `g(v) = δ(e^v)` (`expModel`),
    with `errFun = g - h`; every summand of `h` is a decaying exponential with a positive
    coefficient, so the exact cosine transform
    **`integral_Ioi_expModel_cos`: `∫₀^∞ h(v) cos(tv) dv = (1/2)/((1/2)²+t²) + 2.11·3/(3²+t²)`**
    is nonnegative at every frequency (`integral_Ioi_expModel_cos_nonneg`), the underlying
    computation being `integral_Ioi_exp_neg_mul_cos`;
  - hence the two lower bounds for `δ̂`, **uniform in `t`**:
    **`deltaFourier_ge_of_l1_bound`: `δ̂(t) ≥ -2ε`** and, keeping the model term,
    **`deltaFourier_ge_of_l1_bound'`: `δ̂(t) ≥ 2ĥ(t) - 2ε`**, where
    `ε = ∫₀^∞ |δ(e^v) - h(v)| dv`.  Unlike the decay bounds `|δ̂(t)| ≤ C/|t|`, these lose
    nothing as `|t|` grows;
  - `RequestProject/PolyaError.lean` brackets the rescaled error
    `Φ(v) = e^{v/2}(δ(e^v) - h(v))` on an interval of the variable `q = e^{v/2}`, using the
    Taylor brackets of `Si(x)/x` near `x = 0` and the asymptotic bracket
    `|Si(x) - π/2| ≤ 1/x + 1/x²` for large `x`, and integrates the resulting piecewise
    bound (`integral_piece_taylor_le`, `integral_piece_asymp_le`, `integral_tail_le`);
  - the three `PolyaPartition` files carry out a 601-breakpoint partition, giving
    **`integral_Ioi_abs_errFun_le`: `ε ≤ 0.21088`** (the true value is `≈ 0.1741`);
  - `RequestProject/PolyaThreshold.lean` combines this with the series lower bound
    **`two_thetaDeriv_ge_series`: `2θ'(a) ≥ ∑_{n<80} Θₙ(a) - 5.37221`**, the monotonicity of
    `2θ'` in `|t|` and the antitonicity of `ĥ` in `|t|` (`fourierSide_nonneg_band`), band by
    band on `8 ≤ |t| ≤ 12`, to give
    **`fourierSide_nonneg_of_eight_le_abs`: `2θ'(t) + δ̂(t) ≥ 0` for `|t| ≥ 8`**;
    discarding the model term already gives the simpler
    **`fourierSide_nonneg_of_twelve_le_abs`** for `|t| ≥ 12`.

* `RequestProject/PolyaOscBase.lean`, `RequestProject/PolyaOscBlocks1.lean`–`PolyaOscBlocks4.lean`,
  `RequestProject/PolyaOscTail.lean`, `RequestProject/PolyaOscBand0.lean`–`PolyaOscBand26.lean`,
  `RequestProject/PolyaOscThreshold.lean` — **the Fourier-side inequality for `|t| ≥ 5.5`**
  - the bound `|∫₀^∞ err(v) cos(tv) dv| ≤ ∫₀^∞ |err(v)| dv ≤ 0.21088` used above discards all
    cancellation in the oscillatory integral.  Keeping it requires *signed* information on
    each piece of the partition, packaged as
    **`errIntBracket a b P₀ P₁ S`: `P₀ ≤ ∫ₐᵇ err ≤ P₁` and `∫ₐᵇ |err| ≤ S`**, and produced
    piece by piece by `errPiece_taylor` / `errPiece_asymp` (the two-sided versions of the
    pointwise brackets of `RequestProject/PolyaError.lean`);
  - on a block on which `C - h ≤ cos(tv) ≤ C + h`, **`errCos_block_ge`** gives
    `∫ₐᵇ err(v) cos(tv) dv ≥ min(C·P₀, C·P₁) - h·S`; the constants are made rational by the
    Taylor minorants/majorants `cosLoP`, `cosHiP`, `sinLoP`, `sinHiP` together with the
    quadrant reduction `cos_bracket_case0`–`cos_bracket_case3`, by the Lipschitz transfer
    `abs_cos_sub_le_of_bracket`, and by the rational bracket
    **`vBP_bracket`** for the breakpoints `vBP q = 2 log q`;
  - the 560 pieces of the existing partition lying in the `q`-range `[1, 2.094]` are grouped
    into 73 blocks (`oscBlock0`–`oscBlock72`), the mass beyond the cut being estimated in
    absolute value by **`integral_Ioi_abs_errFun_tail_cut`: `∫_{v ≥ 2 log 2.094} |err| ≤
    0.013709`**;
  - summing the signed block contributions on twenty-seven frequency bands covering
    `5.5 ≤ t ≤ 8` gives `oscBandLower0`–`oscBandLower26`; e.g. on `7 ≤ t ≤ 7.25`,
    **`∫₀^∞ err(v) cos(tv) dv ≥ -0.16014`** instead of the crude `-0.21088`;
  - combined with `two_thetaDeriv_ge_series` through `fourierSide_nonneg_band_osc`, this
    yields **`fourierSide_nonneg_of_seven_le_abs`**,
    **`fourierSide_nonneg_of_six_and_half_le_abs`**, **`fourierSide_nonneg_of_six_le_abs`**
    and finally
    **`fourierSide_nonneg_of_five_and_half_le_abs`: `2θ'(t) + δ̂(t) ≥ 0` for `|t| ≥ 5.5`**;
    note that `6.29`, where the series minorant for `2θ'` changes sign, is passed on the way;
  - `5.5` is the limit of *this* form of the method, in which `cos(tv)` is replaced by a
    constant on each block.  Writing the pointwise
    criterion of `fourierSide_nonneg_band_osc` at a single frequency,
    `∑_{n<80} termₙ(t) - 5.37221 + 2ĥ(t) + 2E(t) ≥ 0` with
    `2ĥ(t) = 1/(1/4+t²) + 12.66/(9+t²)`, the deficit between what the signed block bound gives
    for `E(t)` and what the criterion demands is `-0.0316` at `t = 0.18`, `-0.0157` at `t = 1`,
    `-0.0146` at `t = 3`, `-0.0040` at `t = 4.5`, and turns positive at `t ≈ 5.0`; finite band
    widths cost the remaining `0.5`.  Closing the gap below `5` would require narrowing the
    pointwise brackets of `RequestProject/PolyaError.lean` (whose slack comes from the
    asymptotic estimate `|Si(x) - π/2| ≤ 1/x + 1/x²`), not a finer partition or finer bands.
    In particular the second-moment refinement `|cos(tv) - 1| ≤ t²v²/2` near the origin cannot
    extend the range `|t| ≤ 0.18` of `RequestProject/NearOrigin.lean`, since already the
    deficit `-0.0316` at `t = 0.18` exceeds what an exact evaluation of `E` could recover
    there (`E(0.18) ≈ 0.0073`, against a required `E ≥ -0.0174`, a gain of only `0.025`).
  - What did close the range below `5.5` was not a narrowing of the pointwise brackets of
    `RequestProject/PolyaError.lean` but two changes of the *bracketing scheme*, described
    in the two items below: linearising the phase on each block, so that the block error
    becomes quadratic rather than linear in the block width
    (`RequestProject/PolyaLinThreshold.lean`, `|t| ≥ 1.8`), and cancelling the first
    digamma pole against the first pole of the Pólya model together with an extension of
    the resolved partition from `q = 2.094` to `q = 5`
    (`RequestProject/PolyaLowThreshold.lean`, `0.18 ≤ |t| ≤ 1.8`).  So the deficits quoted
    above measure the constant-cosine scheme only, and the `Si` brackets never became the
    binding constraint.

* `RequestProject/PolyaOscLin.lean`, `RequestProject/PolyaLinVbp1.lean`–`PolyaLinVbp4.lean`,
  `RequestProject/PolyaLinPieces1.lean`–`PolyaLinPieces8.lean`,
  `RequestProject/PolyaLinBlocks1.lean`–`PolyaLinBlocks4.lean`,
  `RequestProject/PolyaLinBand0.lean`–`PolyaLinBand127.lean`,
  `RequestProject/PolyaLinThreshold.lean` — **the Fourier-side inequality for `|t| ≥ 1.8`**
  - the block bound `errCos_block_ge` of the previous item replaces `cos(tv)` by a constant
    on each block, so its error is *linear* in the block width.  Linearising the phase
    instead — `cos(tv) = cos(tm) cos(t(v-m)) - sin(tm) sin(t(v-m))` with `cos g = 1+O(g²/2)`
    and `sin g = g + O(|g|³/6)` — makes it *quadratic*, at the cost of a first signed
    moment `∫ₐᵇ (v-m) err(v) dv` for every piece;
  - with those moments the 128 bands covering `1.8 ≤ |t| ≤ 5.5` give
    `oscLinBand0`–`oscLinBand127`, and hence
    **`fourierSide_nonneg_of_lin_threshold`: `2θ'(t) + δ̂(t) ≥ 0` for `|t| ≥ 1.8`**.

* `RequestProject/PolyaLowBase.lean`, `RequestProject/PolyaLowVbp1.lean`–`PolyaLowVbp2.lean`,
  `RequestProject/PolyaLowPieces1.lean`–`PolyaLowPieces4.lean`,
  `RequestProject/PolyaLowTail.lean`, `RequestProject/PolyaLowBlocks1.lean`–`PolyaLowBlocks4.lean`,
  `RequestProject/PolyaLowBand0.lean`–`PolyaLowBand10.lean`,
  `RequestProject/PolyaLowThreshold.lean` — **the Fourier-side inequality for every `t`**
  - at small frequency the band criterion of the previous items loses too much, because the
    first term of the digamma series varies fast in `|t|`.  **`fourierSide_nonneg_band_sharp`**
    removes that loss: the `n = 0` digamma term and the first term of the Pólya model cancel
    *exactly*, `thetaSeriesTerm t 0 + 1/(1/4+t²) = 4` (`thetaSeriesTerm_zero_add_model`), and
    the remaining pair `P(t) = 4/5 - 5/(25/4+t²) + 12.66/(9+t²)` is antitone
    (`modelPair_antitone`), so a band costs `P(a) - P(b)` instead of the much larger
    `M(a) - M(b)`;
  - the resolved partition is extended from `q = 2.094` to `q = 5`, which lowers the
    unresolved tail to **`integral_Ioi_abs_errFun_tail_five`: `∫_{v ≥ 2 log 5} |err| ≤ 0.0022`**;
    the 166 new pieces are grouped into 26 blocks `blkLo0`–`blkLo25`;
  - the eleven bands covering `0.18 ≤ |t| ≤ 1.8` give `oscLowBand0`–`oscLowBand10`, hence
    **`fourierSide_nonneg_of_low_threshold`** for `|t| ≥ 0.18` and, with
    `fourierSide_nonneg_of_abs_le`, **`fourierSide_nonneg`: `2θ'(t) + δ̂(t) ≥ 0` for every
    real `t`**, i.e. Corollary 2.3 (ii) — recorded also as
    `two_thetaDeriv_add_deltaFourier_nonneg`.

* `RequestProject/FourierDecay.lean` — **decay of the transform and the analytic side
  conditions**
  - `norm_fourierLog_le`, `continuous_fourierLog` and `fourierLog_deriv`
    (`ℱ(F') = -it ℱF`), from which
    **`sq_mul_norm_fourierLog_le`** and **`exists_norm_fourierLog_le_div`**: the transform
    of a `C²` compactly supported function is `O(1/(1+t²))`;
  - `norm_fourierLog_convLog_starLog_self` (`|ℱ(F ⋆ F*)| = |ℱF|²`) and hence
    **`integrable_fourierLog_convLog_starLog_self`**, the Bochner-type integrability for
    convolution squares;
  - `summable_one_div_poleA_cube` and **`exists_digammaDiff_le`**
    (`Re ψ(1/4+it/2) - ψ(1/4) ≤ C t²`), giving
    `integrable_fourierLog_convLog_starLog_self_mul_digammaDiff`;
  - `exists_lipschitz_at_zero`, the Lipschitz bound at the origin for a `C¹` compactly
    supported function; with these three,
    **`LfunNorm_re_nonneg_convLog_starLog_self`**: Corollary 2.3 (i) for convolution
    squares, with the Fourier-side inequality as its only hypothesis.

* `RequestProject/ArchimedeanPositivity.lean` — **the two halves combined**
  - **`LfunNorm_re_nonneg_convLog_starLog`**: `0 ≤ Re L(F ⋆ F*)` for every `C²` compactly
    supported `F`, with no hypothesis at all, and `LfunNorm_re_nonneg`, the same for a
    general positive definite test function satisfying the integrability conditions of the
    Parseval identity.

* `RequestProject/QuarticDecay.lean` — **the integrability of the transform on `C⁴` test
  functions**
  - **`quartic_mul_norm_fourierLog_le`** and **`exists_norm_fourierLog_le_div_quartic`**:
    the transform of a `C⁴` compactly supported function is `O(1/(1+t⁴))`, by transforming
    the fourth derivative;
  - `inv_one_add_pow_four_le`, `sq_div_one_add_pow_four_le`,
    `integrable_inv_one_add_pow_four`, and hence
    **`integrable_fourierLog_of_contDiff_four`** and
    **`integrable_norm_fourierLog_mul_digammaDiff_of_contDiff_four`**: both analytic side
    conditions of the Parseval identity hold for every `C⁴` compactly supported test
    function — the quartic decay beats the quadratic growth `digammaDiff t ≤ C t²`;
  - **`LfunNorm_re_nonneg_of_contDiff_four_of_fourierSide_nonneg`**: Corollary 2.3 (i) for
    all `C⁴` positive definite test functions, with the Fourier-side inequality as its
    only hypothesis.

* `RequestProject/NormalizedPositivity.lean` — **positivity of `L`, and §3, without
  hypotheses**
  - **`LfunNorm_re_nonneg_contDiff_four`**, `LPositivityNorm` and
    **`LPositivityNorm_holds`**: `0 ≤ Re L(G)` for every `C⁴` compactly supported positive
    definite `G`, in the `∆^{1/2}` normalization of the paper, with no hypothesis;
  - `LPositivityC4` and **`LPositivityC4_of_WinftyParseval`**: the same statement for the
    unnormalized pairing of `LPositivity`, restricted to `C⁴` test functions, from the
    hypothesis `WinftyParseval` alone (the integrability gap being closed);
  - the smoothness bookkeeping `contDiff_Qlog_of_six`,
    `contDiff_convLog_starLog_self_six`, `contDiff_four_Qlog_convLog_starLog`, which puts
    `Q(ξ ∗ ξ*)` in the `C⁴` class as soon as `ξ` is `C⁶`;
  - the consequences of §3 with **no positivity hypothesis**:
    **`Winfty_deltaHalfInv_nonneg_of_D_Qlog_nonpos_Icc`** (the implication (57)),
    **`small_support_Winfty_deltaHalfInv_ge`** / `small_support_Winfty_deltaHalfInv_nonneg`
    (`W_∞(Q(ξ ∗ ξ*)) ≥ ‖ξ‖² ≥ 0` for small support), and the effective forms
    **`Winfty_deltaHalfInv_ge_effective`** and `Winfty_deltaHalfInv_ge_effective_mul`
    (`W_∞(Q(ξ ∗ ξ*)) ≥ (2/15)‖ξ‖²` for `ξ` supported in `{|log ρ| ≤ 1/30}`).  These are the
    unconditional counterparts of `Winfty_nonneg_of_D_Qlog_nonpos_Icc`,
    `small_support_Winfty_ge` and `Winfty_ge_effective`.

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
  was checked numerically at
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

* the local trace formula of the paper in the *even* (Sonin) picture.  With a **fixed**
  cut-off the identity `L_Norm(f) = Tr(ϑ(f) P₁ P̂₁ P₁)` is false
  (`not_normalizedTraceIdentity`), and in the unnormalized pairing there is no identity
  either (`not_LPositivity`).  In the **renormalized** form, on the full line, the
  asymptotic identity *is* proved here
  (`exists_universal_finitePart_LfunNorm`), with the coefficient `4 f(1) log Λ` and up to
  the odd-part term `E(F)` and the universal constant `f(1) z₁`.  What is missing is the
  same computation on `evenSubspace`, which is what would remove `E(F)` and restore the
  paper's coefficient `2 f(1)`, and the evaluation of `z₁`;
* the Bochner-type integrability of `f̂` for an *arbitrary* positive definite `f`; for the
  convolution squares `F ⋆ F*` with `F` of class `C²` and compactly supported — the test
  functions the paper works with — it is proved in `RequestProject/FourierDecay.lean`,
  and for every `C⁴` compactly supported test function in
  `RequestProject/QuarticDecay.lean`; with it the positivity of `L` is unconditional on
  both classes (`RequestProject/ArchimedeanPositivity.lean`,
  `RequestProject/NormalizedPositivity.lean`).  What is missing is only the general
  statement, for a merely continuous positive definite `f`, which is what the `Prop`
  `LPositivity` of `RequestProject/Positivity.lean` quantifies over;
* the *analytic* part of trace-class theory: the basis independence of the value of the
  trace on trace-class operators and the trace property `Tr(AB) = Tr(BA)` (the language
  itself, the Hilbert–Schmidt norm and its basis independence, and the positivity of the
  trace of a positive operator, are in `RequestProject/TraceClass.lean`);
* prolate spheroidal wave functions and the associated differential operator;
* the spectral theory of a pair of projections, and the *compactness* (as opposed to the
  boundedness proved here) of the integral operators with the kernels `Qδ` of §3–§4;
* Toeplitz operators on `ℓ²(ℤ)` and their continuous analogues.

Stating those results with placeholder definitions would produce statements that do not
say what the paper says, so the honest record is the list above: the objects that could
be defined faithfully have been defined, and the results about them that could be proved
have been proved.

## Operator-theoretic progress: the normalized trace identity

The analytic part above is frozen.  The operator side has since been advanced, aimed
squarely at the *normalized* positivity (`LPositivityNorm`, the statement that is true);
no part of it revives the disproved unnormalized statement, and none of it is assumed:
every declaration listed here is proved from the three standard axioms (the audit in
`RequestProject/AxiomAudit.lean` now covers them as well).

* `RequestProject/HilbertSchmidtKernel.lean` — a **Hilbert–Schmidt criterion for kernel
  operators**: if `(T ξ)(x) = ⟪k x, ξ⟫` almost everywhere for a measurable family of
  vectors `k x ∈ L²(μ)`, then `hsNormSq b T ≤ ∫⁻ ‖k x‖ₑ² dμ` (`hsNormSq_le_of_kernel`).
  Mathlib has no Hilbert–Schmidt/Schatten theory, so this is proved from Bessel's
  inequality and the monotone convergence of the trace series.
* `RequestProject/FourierL2Integral.lean` — **`coeFn_fourierL2_of_integrable`**: the `L²`
  (Plancherel) Fourier transform of an integrable `L²` function agrees almost everywhere
  with its Fourier integral.  This dictionary between the two Fourier transforms is what
  allows a kernel to be read off from `P̂₁`.
* `RequestProject/CutoffHilbertSchmidt.lean` — **`isHilbertSchmidt_P1hat_comp_P1`**: the
  operator `B = P̂₁ P₁` is Hilbert–Schmidt.  The proof computes the kernel of `P₁ 𝓕 P₁`
  (`coeFn_cutFourierCut`), whose kernel is the bounded character `e(-x y)` on the compact
  square `[-1,1]²`, and transports the Hilbert–Schmidt norm along the Fourier unitary.
* `RequestProject/LogPicture.lean` — the **integrated scaling representation on `L²(ℝ)`**.
  The unitary `logEquiv : L²(ℝ⋆₊, d*ρ) ≃ L²(ℝ)` of the additive picture is constructed,
  and the operators `ϑ(f)` are transported to `L²(ℝ)` along an *arbitrary* unitary
  identification `U` of the two spaces (`thetaOpOf U f`), with all the expected
  properties: the `L¹`-bound `‖ϑ(f)‖ ≤ ‖f‖₁` (`norm_thetaOpOf_le`), linearity in `f`,
  multiplicativity `ϑ(f ∗ g) = ϑ(f) ϑ(g)` (`thetaOpOf_testConv`), compatibility with the
  involutions `ϑ(f)* = ϑ(f^♯)` (`adjoint_thetaOpOf`), and positivity on the positive
  elements of the convolution algebra, `ϑ(g ∗ g^♯) = ϑ(g) ϑ(g)* ≥ 0`
  (`thetaOpOf_testConv_starTest_isPositive`).  Keeping `U` general is deliberate: the
  unitary of the paper is step 2 below, and no statement here depends on which unitary is
  used.  The dictionary lemmas `logTest_testConv` and `logTest_starTest` connect the
  convolution algebra to the logarithmic coordinates of the analytic modules.
* `RequestProject/TraceIdentityNorm.lean` — the **Sonin sandwich as a trace-class
  operator** and the statement of the trace identity.  `soninSandwich = P₁ P̂₁ P₁` is
  positive and self-adjoint (`soninSandwich_isPositive`, `soninSandwich_isSelfAdjoint`), a
  contraction (`norm_soninSandwich_le_one`), equal to `B* B` with `B = P̂₁ P₁`, hence
  **trace class** (`isTraceClass_soninSandwich`); consequently `A ∘ S` is trace class for
  every bounded `A`, in particular the sandwich `ϑ(f) P P̂ P`
  (`isTraceClass_thetaOp_soninSandwich`), whose trace series converges absolutely and is
  independent of the Hilbert basis (`traceAlong_thetaOp_soninSandwich_basis_indep`).  The
  functional `f ↦ Tr(ϑ(f) P P̂ P)` is linear (`traceAlong_thetaOp_soninSandwich_add`,
  `_smul`) and **nonnegative on convolution squares**
  (`re_traceAlong_thetaOp_convSquare_soninSandwich_nonneg`).  Finally the trace identity
  `L_Norm(f) = Tr(ϑ(f) P P̂ P)` is stated as the predicate `NormalizedTraceIdentity U` —
  a hypothesis, never an axiom — and `LfunNorm_re_nonneg_of_normalizedTraceIdentity` shows
  that it recovers, by the operator route, the normalized positivity already proved
  analytically.  The identity itself is not claimed; it is the local trace formula, and it
  is the one remaining step (step 5 below, of which the trace-class half is now done).

## Remaining steps towards the trace identity (historical: all steps are settled)

*This section is kept as a record of how the operator side was built; every step in it is
now marked "done", the last one in the negative (the fixed-cut-off identity is false).
The live continuation of this line of work is the renormalized programme described in the
section "Status: the renormalized-trace programme" above.*

With the projections (`RequestProject/SoninJoin.lean`), the integrated representation
(`RequestProject/ScalingIntegrated.lean`) and the trace language
(`RequestProject/TraceClass.lean`, `RequestProject/TraceProperty.lean`,
`RequestProject/TraceBasisIndep.lean`) in place, the concrete lemmas still needed before
the trace identity `L(f) = Tr(ϑ(f) P P̂ P)` — and hence the positivity of `L` — can be
stated and proved are, in dependency order:

1. *(done)* **Multiplicativity of the integrated representation**: `ϑ(f ∗ g) = ϑ(f) ϑ(g)`
   for `f, g ∈ C_c(ℝ⋆₊)`, where `∗` is the convolution of the multiplicative group, proved
   as `scalingOp_testConv` in `RequestProject/TestConvolution.lean` (together with the
   convolution product `testConv` on `C_c(ℝ⋆₊)` itself).  Combined with
   `adjoint_scalingOp` it gives `ϑ(g ∗ g^♯) = ϑ(g) ϑ(g)*`
   (`scalingOp_testConv_starTest`).
2. *(done)* **A unitary identification of the two pictures**: the scaling representation is
   defined on `L²(ℝ⋆₊, d*ρ)` while the cutoff projections `P₁, P̂₁` live on `L²(ℝ, dx)`.
   The unitary of the paper, `ξ ↦ (x ↦ (2|x|)^{-1/2} ξ(|x|))`, is constructed in
   `RequestProject/EvenPicture.lean` as `weilMap : L²(ℝ⋆₊, d*ρ) →ₗᵢ L²(ℝ)`; its range is
   exactly the even part of `L²(ℝ, dx)` (`range_weilMap`, the closed subspace
   `evenSubspace`), so it is the unitary `weilUnitary : L²(ℝ⋆₊, d*ρ) ≃ₗᵢ evenSubspace`, and
   it intertwines the two scaling actions: `(w (ϑ(λ)ξ))(x) = λ^{-1/2} (w ξ)(λ^{-1} x)`
   (`coeFn_weilMap_scaling`).  The change of variables is carried out at the level of
   `lintegral`s (`lintegral_enorm_sq_evenLift`), which avoids the missing `L²` analogue of
   Mathlib's `L¹` isometry for `withDensity`.  Note that `logCoordinates` is *not* this
   map: it is the passage to the additive picture of the group, in which the Fourier
   transform of `L²(ℝ, dx)` has no meaning.  (`P₁` preserves the even subspace,
   `P1_mem_evenSubspace`; the corresponding statement for `P̂₁`, which needs the commutation
   of the `L²` Fourier transform with `x ↦ -x`, is not proved.)
3. *(done)* **The trace is well defined on trace-class operators**: independence of
   `traceAlong b T` of the Hilbert basis `b`, proved as
   `traceAlong_basis_indep_of_isTraceClass` in `RequestProject/TraceBasisIndep.lean`
   (through the basis independence of the Hilbert–Schmidt inner product, avoiding the
   square root of a positive operator).
4. *(done)* **The trace property** `Tr(AB) = Tr(BA)` for `A, B` Hilbert–Schmidt, needed to
   move `ϑ(g)` from one side of `P P̂ P` to the other and to reduce the positivity of
   `Tr(ϑ(g ∗ g^♯) P P̂ P)` to `traceAlongRe_scalingOp_conj_nonneg`; proved as
   `traceAlong_comm` in `RequestProject/TraceProperty.lean`.
4'. *(done)* **The positivity mechanism itself**: `Re Tr(ϑ(g ∗ g^♯) B* B) ≥ 0` for any
   Hilbert–Schmidt `B`, proved as `re_traceAlong_scalingOp_testConv_starTest_nonneg` in
   `RequestProject/TracePositivity.lean`.  Only step 2 (the unitary identification of the
   two pictures, which is what makes `B = P̂ P` an operator on the same Hilbert space as
   `ϑ(f)`) and step 5 below separate this from `L_positive`.
5. *(done, in the negative)* **The Schwartz kernel of `ϑ(f) P P̂ P`** and the computation
   of its trace as `∫ f(ρ) k(ρ) d*ρ`: this is what would identify the operator trace with
   the functional `L`.  Both halves are now proved.  `P̂₁ P₁` is Hilbert–Schmidt
   (`isHilbertSchmidt_P1hat_comp_P1`), so `P P̂ P = (P̂ P)* (P̂ P)` is trace class and so is
   `ϑ(f) P P̂ P` (`isTraceClass_thetaOp_soninSandwich`), with a basis-independent trace
   that is nonnegative on convolution squares; and the trace functional *is* integration
   against a kernel, `Tr(ϑ(f) P₁P̂₁P₁) = ∫ f(λ) κ(λ) d*λ`
   (`traceAlong_thetaOpOf_soninSandwich_eq_integral`), with `κ` bounded and continuous.
   That is precisely what makes the identity with `L_Norm` impossible with a *fixed*
   cutoff; see the next section.

## The trace identity with a fixed cutoff: resolution

The identity `L_Norm(f) = Tr(ϑ(f) P₁P̂₁P₁)` (`NormalizedTraceIdentity U`, a hypothesis in
`RequestProject/TraceIdentityNorm.lean`, never an axiom) is now **settled: it is false**,
for every unitary identification `U` of the two pictures
(`not_normalizedTraceIdentity`, `RequestProject/TraceIdentityObstruction.lean`).  The route
to that conclusion is the reduction of the identity to a statement about *functions*:

* `RequestProject/TraceDensity.lean` — **the local trace formula in kernel form**.  The
  trace series and the Bochner integral defining `ϑ(f)` may be interchanged, because the
  trace series is dominated uniformly in `λ` by the Hilbert–Schmidt norm of `B = P̂₁P₁`
  (`tsum_enorm_inner_comp_soninSandwich_le`), whence
  `Tr(ϑ(f) P₁P̂₁P₁) = ∫ f(λ) κ(λ) d*λ` with `κ(λ) = Tr(ϑ(λ) P₁P̂₁P₁)` the **trace density**
  (`traceAlong_thetaOpOf_soninSandwich_eq_integral`), a function bounded by `‖B‖²_HS`
  (`enorm_traceDensity_le`) and independent of the Hilbert basis used to compute it
  (`traceDensity_basis_indep`).  Consequently `NormalizedTraceIdentity U` is *equivalent*
  to the identity of functionals `L_Norm(f) = ∫ f(λ) κ(λ) d*λ`
  (`normalizedTraceIdentity_iff_traceDensity`; `L²(ℝ)` is separable, so it has a countable
  Hilbert basis `stdBasis`, along which the trace density is normalized).
* `RequestProject/TraceDensitySymmetry.lean` — **the structure of the trace density**.
  Removing the trace in favour of a Hilbert–Schmidt pairing gives
  `κ(λ) = ⟪B, ϑ(λ) B⟫_HS` with `B = P₁P̂₁` (`traceDensity_eq_hsInner`): `κ` is a matrix
  coefficient of the scaling representation on the Hilbert–Schmidt operators.  It follows
  that `κ(λ⁻¹) = conj κ(λ)` (`conj_traceDensity`, the operator-side counterpart of the
  symmetry `δ(ρ) = δ(ρ⁻¹)`), that `κ` is continuous, the Hilbert–Schmidt series converging
  uniformly (`continuous_traceDensity`), and that `κ(1) = ‖B‖²_HS`
  (`traceDensity_one_eq_hsNormSq`).
* `RequestProject/TraceIdentityObstruction.lean` — **the obstruction**.  A functional of
  the form `f ↦ ∫ f κ d*λ` with `κ` bounded is continuous for the `L¹(d*λ)` norm
  (`norm_integral_mul_traceDensityStd_le`).  The archimedean functional `L_Norm` is not:
  it is a distribution of order one.  On the triangular bump `tri_w` of half width `w`,
  read as a test function on `ℝ⋆₊` (`logBump`), the closed form of the normalized
  archimedean term gives
  `Re L_Norm(tri_w) = Re D(tri_w) - c₀ + ∫ (1 - tri_w(u)) κ_∞(u) du` (`LfunNorm_triC_re`),
  and the singularity `κ_∞(u) ≈ 1/(2|u|)` of the kernel of the explicit formula at the
  origin makes the last term at least `(1/6) log(1/w)` (`sinhDeficit_ge`), while
  `Re D(tri_w) ∈ [0, 16 Si π + 16]` and `‖tri_w‖_{L¹(d*λ)} ≤ 2w`.  Letting `w → 0` the
  analytic side diverges and the trace side tends to `0`: the identity fails.

What this says about the paper is not that its trace formula is wrong, but that the
formula is a *renormalized* one: with the cutoff at `1` frozen, `P₁P̂₁P₁` is trace class and
its trace is an `L¹`-continuous functional, whereas the archimedean distribution `W_∞` sees
`f(1)` and the principal value at `ρ = 1`.  The correct statement is Connes' local trace
formula with a cutoff `Λ → ∞` and the `log Λ` subtraction, i.e. an asymptotic identity for
`Tr(ϑ(f) P_Λ P̂_Λ P_Λ) - c f(1) log Λ`.  That family of projections, the asymptotics of the
trace density in `Λ`, and the identification of the finite part **are** now part of this
project: see the section "Status: the renormalized-trace programme" above, and in
particular its last subsection, where the asymptotic is proved unconditionally in the
full-line model with `c = 4`.  In particular the conditional theorem
`LfunNorm_re_nonneg_of_normalizedTraceIdentity` is vacuous; the positivity of `L_Norm` is
proved unconditionally by the analytic route
(`RequestProject/ArchimedeanPositivity.lean`, `RequestProject/NormalizedPositivity.lean`).

## Clean-up of the repository (module inventory)

The repository was audited at the level of *constants*, not of imports: for the live
results

* `fourierSide_nonneg` / `two_thetaDeriv_add_deltaFourier_nonneg`
  (`RequestProject/PolyaLowThreshold.lean`),
* `LfunNorm_re_nonneg_convLog_starLog` (`RequestProject/ArchimedeanPositivity.lean`),
* `LfunNorm_re_nonneg_contDiff_four` / `LPositivityNorm_holds`
  (`RequestProject/NormalizedPositivity.lean`),

the transitive closure of the constants occurring in their statements and proofs was
computed and mapped back to the modules that declare them.  The outcome, and the actions
taken, are:

* **Removed — superseded intermediate threshold.**  `RequestProject/MidThreshold25.lean`
  (the Fourier-side inequality for `|t| ≥ 25`).  Its threshold lies strictly between the
  `34` of `RequestProject/MidThreshold.lean` and the `23` of
  `RequestProject/DeltaVariation.lean`, and no constant of the module occurs in any other
  module: the only trace of it was an import in `RequestProject/PolyaThreshold.lean`, which
  reaches `RequestProject/MidThreshold.lean` through `RequestProject/SiDivMono.lean`
  anyway.  That import line was deleted; nothing else changed.
* **Removed — unused sharpening.**  `RequestProject/NearOriginSharp.lean` (the near-origin
  range `|t| ≤ 0.28` from a twelve-piece quadrature giving `δ̂(0) ≥ 5.3879`).  The proof of
  `fourierSide_nonneg` uses the range `|t| ≤ 0.18` of `RequestProject/NearOrigin.lean`,
  which is what the low-frequency bands are matched to; no declaration of the sharpened
  module was referenced anywhere.
* **Removed — conditional routes that are no longer needed.**
  `RequestProject/BandEnergy.lean` and `RequestProject/TailEnergy.lean`, the operator-free
  routes to the Fourier-side inequality, each resting on an unproved `Prop`-valued
  hypothesis (`BandEnergyBound`, `TraceLimitIdentity`, `TailEnergyIdentity`).  The
  inequality is now proved unconditionally, and no other module referred to them.  The
  numerical discussion of the tail-energy identity is kept in the *Numerics* section above
  and in `RequestProject/CompactInterval.lean`.
* **Kept — everything else.**  In particular:
  - the whole Pólya-model machinery, including the families
    `PolyaLinVbp*`, `PolyaLinPieces*`, `PolyaLinBlocks*`, `PolyaLinBand0`–`PolyaLinBand127`,
    `PolyaOscBand0`–`PolyaOscBand26`, `PolyaLowBand0`–`PolyaLowBand10`,
    `PolyaLowVbp*`, `PolyaLowPieces*`, `PolyaLowBlocks*`, `PolyaOscBlocks*` and
    `PolyaPartition1`–`PolyaPartition3`.  These are *not* historical scaffolding: every one
    of these modules contributes constants to the proof of `fourierSide_nonneg`, each band
    file certifying one frequency band of the covering of `0.18 ≤ |t| ≤ 5.5`
    (`PolyaOscBand*`, `PolyaLowBand*`) or of `1.8 ≤ |t| ≤ 5.5` (`PolyaLinBand*`).  Removing
    any of them would remove a band from the covering.
  - the historical chain of thresholds `2π e^{17π+20}`, `60` (`ThetaGrowth.lean`), `38`
    (`DeltaDecaySharp.lean`), `34` (`MidThreshold.lean`), `23` (`DeltaVariation.lean`),
    `12`/`8` (`PolyaThreshold.lean`), `7`–`5.5` (`PolyaOscThreshold.lean`), `1.8`
    (`PolyaLinThreshold.lean`): each step is *used* by the next one, which only covers a
    band and then defers to its predecessor, so the chain is load-bearing in full.
  - `RequestProject/CompactInterval.lean`, whose constants are used by
    `RequestProject/DeltaFourierZero.lean`.
  - the operator-theoretic infrastructure originally intended for `L_positive`
    (a statement now disproved): `Sonin.lean`, `Scaling.lean`, `ScalingIntegrated.lean`,
    `TestConvolution.lean`, `SoninJoin.lean`, `SoninSandwich.lean`, `TraceClass.lean`,
    `TraceProperty.lean`, `TraceBasisIndep.lean`, `TraceScaling.lean`,
    `TracePositivity.lean`.  The nine of them that come after `Scaling.lean` in this list
    were not reachable from `RequestProject/Main.lean`; they are now imported there, so that
    the top-level module really does cover the whole project.

### Second audit (documentation and hygiene pass)

The audit above was repeated after the renormalized-trace work, this time at the level of
*module imports*: the transitive import closure of the modules that declare the live
results (`PolyaLowThreshold`, `ArchimedeanPositivity`, `NormalizedPositivity`,
`UnnormalizedCounterexample`, `TraceIdentityObstruction`, `DiagonalQuadraticGrowth`,
`CutoffLogProfile`, `A5Artin`, `AxiomAudit`, and this file) was computed and compared with
the list of modules on disk.  Findings, and the action taken:

* every module of the project except one lies in that closure — in particular all the
  Pólya-model band, block, piece and partition families, and the whole threshold chain,
  are load-bearing and were left untouched;
* the single exception is `RequestProject/TraceScaling.lean` (three theorems: the
  positivity mechanism `Tr(ϑ(f)* A ϑ(f)) ≥ 0` on `L²(ℝ⋆₊)`).  It is superseded by
  `RequestProject/TracePositivity.lean`, which proves the same mechanism in the picture
  that the live results actually use.  **It was *not* removed**: it is `sorry`-free,
  self-contained and cheap to elaborate, and removing it would delete proved statements.
  It is instead marked, in its own header and in the module list above, as being off the
  live proof path;
* `RequestProject/AxiomAudit.lean` (the `#print axioms` commands) and
  `RequestProject/A5Artin.lean` (the separate `A₅` Artin development) are deliberately not
  imported by `RequestProject/Main.lean`; both are built by the library glob
  `RequestProject.+`, so a plain `lake build` elaborates them;
* the token `sorry` occurs in the sources only inside comment blocks that record
  withdrawn or historical statements (`RequestProject/Positivity.lean`,
  `RequestProject/FourierSide.lean`, and the transcription of the informal skeleton at the
  end of this file).  There is no live `sorry`.

In the same pass `RequestProject/AxiomAudit.lean` was extended to the headline results of
the renormalized-trace programme; it now elaborates 55 `#print axioms` commands, each of
which reports exactly `[propext, Classical.choice, Quot.sound]`.  A full `lake build` of
the library reports `Build completed successfully (8321 jobs)`, with no error and no
`declaration uses 'sorry'` warning (the only warning is Lake's `manifest out of date`
notice about the local checkout of Mathlib).

The per-file figures (lines, declarations, sorries) are in
`RequestProject/REPO_INVENTORY.md`, which was regenerated in the same pass by
`scripts/inventory.py`; the verification evidence is in `RequestProject/VERIFICATION.md`.

*Consolidation.*  Grouping consecutive band files into fewer, larger modules was
considered and rejected: the band files are independent of each other and are elaborated in
parallel, so merging them would not reduce the total work, would serialize it, and would
make the certified numerical data harder to regenerate.  The one-band-per-module layout is
kept deliberately.

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
