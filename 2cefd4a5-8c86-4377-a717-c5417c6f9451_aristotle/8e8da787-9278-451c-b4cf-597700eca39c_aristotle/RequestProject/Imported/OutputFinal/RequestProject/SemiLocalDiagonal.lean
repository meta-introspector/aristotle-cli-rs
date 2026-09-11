/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**The diagonal of the semi-local kernel, and the expected logarithmic asymptotics.**

`RequestProject/RenormalizedTraceDensity.lean` writes the trace at a finite cut-off scale in
kernel form,

  `Tr(ϑ(f) S^{(Λ)}) = ∫ f(λ) κ_Λ(λ) d*λ`,   `κ_Λ(λ) = Tr(ϑ(λ) S^{(Λ)})`,
  `S^{(Λ)} = P^{(Λ)} P̂^{(Λ)} P^{(Λ)}`.

This file isolates the **diagonal value** of that kernel,

  `d(Λ) := κ_Λ(1) = Tr(S^{(Λ)}) = ‖B_Λ‖²_{HS}`,   `B_Λ = P̂^{(Λ)} P^{(Λ)}`,

which is where the whole logarithmic divergence of the cut-off trace sits: `|κ_Λ(λ)| ≤ d(Λ)`
for every `λ` (`norm_traceDensityCut_le_diagDensity`), so

  `|Tr(ϑ(f) S^{(Λ)})| ≤ ‖f‖_{L¹(d*λ)} · d(Λ)`   (`norm_cutTrace_le_l1Norm_mul_diagDensity`).

Three groups of results.

* **The diagonal kernel.**  `diagDensity U b Λ = d(Λ)` is a nonnegative real number
  (`diagDensity_nonneg`), equal to the trace of the cut-off sandwich
  (`diagDensity_eq_traceAlongRe`), monotone in the cut-off scale (`diagDensity_mono`) and
  divergent (`tendsto_diagDensity_atTop`).  So the divergence is *visible* as a single real
  monotone divergent function of `Λ`, and the counter-term of
  `RequestProject/RenormalizedTrace.lean` is a subtraction against that function.

* **The expected asymptotic**, stated precisely and in the `o(1)` form requested by the
  paper:

    `Tr(ϑ(f) S^{(Λ)}) = 2 f(1) log Λ + L_Norm(f) + o(1)`   (`Λ → ∞`).

  `HasLogAsymptotics b U f z` says exactly that with `L_Norm(f)` replaced by `z`, and
  `hasLogAsymptotics_iff_hasRenormalizedTrace` identifies it with the finite-part statement
  already in the project; `SemiLocalTraceAsymptotics U` is the full identity, and
  `semiLocalTraceAsymptotics_iff_renormalizedTraceIdentity` shows it is the same `Prop` as
  `RenormalizedTraceIdentity U`.  As before, the identity is **not** proved: it is a `Prop`,
  never an axiom.  The corresponding statement for the diagonal kernel alone,
  `d(Λ) = 2 log Λ + O(1)`, is `HasDiagLogAsymptotics`, whose finite part is unique
  (`HasDiagLogAsymptotics.unique`) and which forces the rate `d(Λ)/log Λ → 2`
  (`tendsto_diagDensity_div_log`).

* **A self-contained lower bound on the divergence rate.**  Granted only that the finite
  part of *one* test function `f` exists, the diagonal kernel must already diverge at least
  logarithmically, at the explicit rate `2|f(1)|/‖f‖_{L¹}`:

    `2‖f(1)‖ log Λ - (‖z‖ + 1) ≤ ‖f‖_{L¹} · d(Λ)`   eventually
    (`eventually_diagDensity_lower_bound`),

  hence `(2‖f(1)‖ - ε) log Λ ≤ ‖f‖_{L¹} · d(Λ)` eventually, for every `ε > 0`
  (`eventually_diagDensity_lower_bound_eps`).  This is proved outright, with no Fourier
  analysis: it only uses the kernel form of the trace and the maximality of the kernel at
  the diagonal.
-/
import RequestProject.Imported.OutputFinal.RequestProject.RenormalizedDensityBound
import RequestProject.Imported.OutputFinal.RequestProject.RenormalizedTraceUniqueness
import RequestProject.Imported.OutputFinal.RequestProject.TraceDivergence

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory ContinuousLinearMap Filter Topology

open scoped CompactlySupported ENNReal

namespace ConnesConsani.WeilPositivity

variable {ι : Type*} (U : L2Rplus ≃ₗᵢ[ℂ] L2R)

/-! ## The diagonal of the semi-local kernel -/

/-- **The diagonal value of the semi-local kernel**,
`d(Λ) = κ_Λ(1) = Tr(S^{(Λ)}) = ‖B_Λ‖²_{HS}`.  All of the logarithmic divergence of the
cut-off trace is carried by this single real function of the cut-off scale. -/
def diagDensity (b : HilbertBasis ι ℂ L2R) (cut : ℝ) : ℝ := (traceDensityCut U b cut 1).re

/-- The semi-local kernel at `λ = 1` is the trace of the cut-off sandwich. -/
theorem traceDensityCut_one_eq_traceAlong (b : HilbertBasis ι ℂ L2R) (cut : ℝ) :
    traceDensityCut U b cut 1 = traceAlong b (soninSandwichCut cut) := by
  unfold traceDensityCut traceAlong
  exact tsum_congr fun i => by
    rw [ContinuousLinearMap.comp_apply, thetaUnitOf_one]

/-- `d(Λ) = Tr(S^{(Λ)})`. -/
theorem diagDensity_eq_traceAlongRe (b : HilbertBasis ι ℂ L2R) (cut : ℝ) :
    diagDensity U b cut = traceAlongRe b (soninSandwichCut cut) := by
  have hsum : Summable fun i => (inner ℂ (b i) (soninSandwichCut cut (b i)) : ℂ) :=
    (summable_norm_inner_of_isTraceClass (isTraceClass_soninSandwichCut cut b)).of_norm
  rw [diagDensity, traceDensityCut_one_eq_traceAlong, traceAlong, traceAlongRe,
    Complex.re_tsum hsum]
  rfl

/-- `d(Λ) ≥ 0`. -/
theorem diagDensity_nonneg (b : HilbertBasis ι ℂ L2R) (cut : ℝ) :
    0 ≤ diagDensity U b cut := by
  rw [diagDensity_eq_traceAlongRe]
  exact traceAlongRe_nonneg b (soninSandwichCut_isPositive cut)

/-- The diagonal kernel does not depend on the Hilbert basis. -/
theorem diagDensity_basis_indep {kappa : Type*} (b : HilbertBasis ι ℂ L2R)
    (c : HilbertBasis kappa ℂ L2R) (cut : ℝ) :
    diagDensity U b cut = diagDensity U c cut := by
  rw [diagDensity, diagDensity, traceDensityCut_basis_indep U b c cut 1]

/-- **The diagonal kernel is monotone in the cut-off scale.** -/
theorem diagDensity_mono (b : HilbertBasis ι ℂ L2R) {a a' : ℝ} (h : a ≤ a') :
    diagDensity U b a ≤ diagDensity U b a' :=
  re_traceDensityCut_one_mono U b h

/-- **The diagonal kernel diverges**: `d(Λ) → ∞`.  This is the divergence that the
`log Λ` counter-term is designed to cancel. -/
theorem tendsto_diagDensity_atTop (b : HilbertBasis ι ℂ L2R) :
    Tendsto (fun cut : ℝ => diagDensity U b cut) atTop atTop :=
  (tendsto_traceAlongRe_soninSandwichCut_atTop b).congr fun cut =>
    (diagDensity_eq_traceAlongRe U b cut).symm

/-- **The kernel is maximal on the diagonal**: `|κ_Λ(λ)| ≤ d(Λ)` for every `λ`. -/
theorem norm_traceDensityCut_le_diagDensity (b : HilbertBasis ι ℂ L2R) (cut : ℝ)
    (lam : Rplus) : ‖traceDensityCut U b cut lam‖ ≤ diagDensity U b cut :=
  norm_traceDensityCut_le_one U b cut lam

/-- **The cut-off trace is controlled by the diagonal kernel**:
`|Tr(ϑ(f) S^{(Λ)})| ≤ ‖f‖_{L¹(d*λ)} · d(Λ)`. -/
theorem norm_cutTrace_le_l1Norm_mul_diagDensity [Countable ι] (b : HilbertBasis ι ℂ L2R)
    (cut : ℝ) (g : C_c(Rplus, ℂ)) :
    ‖cutTrace b U cut g‖ ≤ l1Norm g * diagDensity U b cut := by
  rw [cutTrace_eq_integral U b cut g]
  have hbound : ∀ lam : Rplus,
      ‖g lam * traceDensityCut U b cut lam‖ ≤ ‖g lam‖ * diagDensity U b cut := by
    intro lam
    rw [norm_mul]
    exact mul_le_mul_of_nonneg_left (norm_traceDensityCut_le_diagDensity U b cut lam)
      (norm_nonneg _)
  calc ‖∫ lam, g lam * traceDensityCut U b cut lam ∂(Rplus.haar)‖
      ≤ ∫ lam, ‖g lam‖ * diagDensity U b cut ∂(Rplus.haar) :=
        norm_integral_le_of_norm_le ((integrable_norm g).mul_const _) (.of_forall hbound)
    _ = l1Norm g * diagDensity U b cut := by rw [integral_mul_const, l1Norm]

/-! ## The expected logarithmic asymptotics -/

/-- **The expected asymptotic expansion of the cut-off trace**,

  `Tr(ϑ(f) S^{(Λ)}) = 2 f(1) log Λ + z + o(1)`   (`Λ → ∞`),

written as the statement that the error tends to `0`. -/
def HasLogAsymptotics (b : HilbertBasis ι ℂ L2R) (g : C_c(Rplus, ℂ)) (z : ℂ) : Prop :=
  Tendsto (fun cut : ℝ =>
      cutTrace b U cut g - (2 * g 1 * (Real.log cut : ℂ) + z)) atTop (𝓝 0)

/-- The `o(1)` form of the asymptotic expansion is the finite-part statement of
`RequestProject/RenormalizedTrace.lean`. -/
theorem hasLogAsymptotics_iff_hasRenormalizedTrace (b : HilbertBasis ι ℂ L2R)
    (g : C_c(Rplus, ℂ)) (z : ℂ) :
    HasLogAsymptotics U b g z ↔ HasRenormalizedTrace b U g z := by
  rw [HasLogAsymptotics, HasRenormalizedTrace]
  constructor
  · intro h
    have h2 : Tendsto (fun cut : ℝ =>
        cutTrace b U cut g - (2 * g 1 * (Real.log cut : ℂ) + z) + z) atTop (𝓝 z) := by
      simpa using h.add_const z
    refine h2.congr fun cut => ?_
    rw [regularizedCutTrace, logCounterTerm, mul_assoc]
    ring
  · intro h
    have h2 : Tendsto (fun cut : ℝ => regularizedCutTrace b U cut g - z) atTop (𝓝 0) := by
      simpa using h.sub_const z
    refine h2.congr fun cut => ?_
    rw [regularizedCutTrace, logCounterTerm, mul_assoc]
    ring

/-- The finite part in the asymptotic expansion is unique. -/
theorem HasLogAsymptotics.unique {b : HilbertBasis ι ℂ L2R} {g : C_c(Rplus, ℂ)} {z w : ℂ}
    (hz : HasLogAsymptotics U b g z) (hw : HasLogAsymptotics U b g w) : z = w :=
  ((hasLogAsymptotics_iff_hasRenormalizedTrace U b g z).1 hz).unique
    ((hasLogAsymptotics_iff_hasRenormalizedTrace U b g w).1 hw)

/-- **The semi-local asymptotic trace formula at the archimedean place**:

  `Tr(ϑ(f) S^{(Λ)}) = 2 f(1) log Λ + L_Norm(f) + o(1)`,   `Λ → ∞`,

for every test function `f ∈ C_c(ℝ⋆₊)`.  This is the statement the paper's semi-local
analysis is aimed at; it is a `Prop` (a hypothesis), never an axiom, and it is not proved
here — see the discussion at the end of the file. -/
def SemiLocalTraceAsymptotics : Prop :=
  ∀ {ι : Type} (b : HilbertBasis ι ℂ L2R) (g : C_c(Rplus, ℂ)),
    HasLogAsymptotics U b g (LfunNorm (logTest g))

/-- The asymptotic formula is exactly the renormalized trace identity. -/
theorem semiLocalTraceAsymptotics_iff_renormalizedTraceIdentity :
    SemiLocalTraceAsymptotics U ↔ RenormalizedTraceIdentity U := by
  constructor
  · intro h ι b g
    exact (hasLogAsymptotics_iff_hasRenormalizedTrace U b g _).1 (h b g)
  · intro h ι b g
    exact (hasLogAsymptotics_iff_hasRenormalizedTrace U b g _).2 (h b g)

/-! ## The diagonal asymptotic and the divergence rate -/

/-- **The expected asymptotic of the diagonal kernel**: `d(Λ) = 2 log Λ + c + o(1)`.
(The coefficient `2` is the one of the counter-term `2 f(1) log Λ` at `f(1) = 1`: one
logarithm for the cut-off in space, one for the cut-off in frequency.) -/
def HasDiagLogAsymptotics (b : HilbertBasis ι ℂ L2R) (c : ℝ) : Prop :=
  Tendsto (fun cut : ℝ => diagDensity U b cut - 2 * Real.log cut) atTop (𝓝 c)

/-- The finite part of the diagonal asymptotic is unique. -/
theorem HasDiagLogAsymptotics.unique {b : HilbertBasis ι ℂ L2R} {c c' : ℝ}
    (h : HasDiagLogAsymptotics U b c) (h' : HasDiagLogAsymptotics U b c') : c = c' :=
  tendsto_nhds_unique h h'

/-- If the diagonal kernel has a finite part after subtracting `2 log Λ`, then its
divergence rate is exactly `2`: `d(Λ)/log Λ → 2`. -/
theorem tendsto_diagDensity_div_log {b : HilbertBasis ι ℂ L2R} {c : ℝ}
    (h : HasDiagLogAsymptotics U b c) :
    Tendsto (fun cut : ℝ => diagDensity U b cut / Real.log cut) atTop (𝓝 2) := by
  have hlog : Tendsto (fun cut : ℝ => Real.log cut) atTop atTop := Real.tendsto_log_atTop
  have hzero : Tendsto
      (fun cut : ℝ => (diagDensity U b cut - 2 * Real.log cut) / Real.log cut) atTop (𝓝 0) :=
    h.div_atTop hlog
  have h2 : Tendsto
      (fun cut : ℝ => (diagDensity U b cut - 2 * Real.log cut) / Real.log cut + 2) atTop
      (𝓝 2) := by simpa using hzero.add_const 2
  refine h2.congr' ?_
  filter_upwards [hlog.eventually_gt_atTop 0] with cut hcut
  field_simp
  ring

/-- **A lower bound on the divergence rate of the diagonal kernel.**  If the renormalized
trace of a single test function `f` exists, with finite part `z`, then the diagonal kernel
must already diverge at least like `(2|f(1)|/‖f‖_{L¹}) log Λ`:

  `2‖f(1)‖ log Λ - (‖z‖ + 1) ≤ ‖f‖_{L¹(d*λ)} · d(Λ)`   for all large `Λ`.

No Fourier analysis is used: only the kernel form of the cut-off trace and the maximality
of the kernel on the diagonal. -/
theorem eventually_diagDensity_lower_bound [Countable ι] {b : HilbertBasis ι ℂ L2R}
    {g : C_c(Rplus, ℂ)} {z : ℂ} (h : HasRenormalizedTrace b U g z) :
    ∀ᶠ cut : ℝ in atTop,
      2 * ‖g 1‖ * Real.log cut - (‖z‖ + 1) ≤ l1Norm g * diagDensity U b cut := by
  have hclose : ∀ᶠ cut : ℝ in atTop, ‖regularizedCutTrace b U cut g - z‖ ≤ 1 := by
    have := h.eventually (Metric.closedBall_mem_nhds z zero_lt_one)
    filter_upwards [this] with cut hcut
    rw [← dist_eq_norm]
    exact hcut
  filter_upwards [hclose, eventually_ge_atTop (1 : ℝ)] with cut hcut hcut1
  have hlog : 0 ≤ Real.log cut := Real.log_nonneg hcut1
  have hsplit : (2 : ℂ) * g 1 * (Real.log cut : ℂ)
      = cutTrace b U cut g - (regularizedCutTrace b U cut g - z) - z := by
    rw [regularizedCutTrace, logCounterTerm, mul_assoc]
    ring
  have hnorm : 2 * ‖g 1‖ * Real.log cut ≤ ‖cutTrace b U cut g‖ + 1 + ‖z‖ := by
    have hval : ‖(2 : ℂ) * g 1 * (Real.log cut : ℂ)‖ = 2 * ‖g 1‖ * Real.log cut := by
      rw [norm_mul, norm_mul]
      simp [Real.norm_eq_abs, abs_of_nonneg hlog]
    calc 2 * ‖g 1‖ * Real.log cut
        = ‖(2 : ℂ) * g 1 * (Real.log cut : ℂ)‖ := hval.symm
      _ = ‖cutTrace b U cut g - (regularizedCutTrace b U cut g - z) - z‖ := by rw [hsplit]
      _ ≤ ‖cutTrace b U cut g - (regularizedCutTrace b U cut g - z)‖ + ‖z‖ :=
          norm_sub_le _ _
      _ ≤ (‖cutTrace b U cut g‖ + ‖regularizedCutTrace b U cut g - z‖) + ‖z‖ := by
          gcongr
          exact norm_sub_le _ _
      _ ≤ ‖cutTrace b U cut g‖ + 1 + ‖z‖ := by gcongr
  have hbound := norm_cutTrace_le_l1Norm_mul_diagDensity U b cut g
  linarith

/-- The same lower bound in rate form: for every `ε > 0`, eventually
`(2‖f(1)‖ - ε) log Λ ≤ ‖f‖_{L¹} · d(Λ)`. -/
theorem eventually_diagDensity_lower_bound_eps [Countable ι] {b : HilbertBasis ι ℂ L2R}
    {g : C_c(Rplus, ℂ)} {z : ℂ} (h : HasRenormalizedTrace b U g z) {eps : ℝ}
    (heps : 0 < eps) :
    ∀ᶠ cut : ℝ in atTop,
      (2 * ‖g 1‖ - eps) * Real.log cut ≤ l1Norm g * diagDensity U b cut := by
  have hlog : Tendsto (fun cut : ℝ => eps * Real.log cut) atTop atTop :=
    Real.tendsto_log_atTop.const_mul_atTop heps
  filter_upwards [eventually_diagDensity_lower_bound U h,
    hlog.eventually_ge_atTop (‖z‖ + 1)] with cut hcut hcut'
  nlinarith [hcut, hcut']

end ConnesConsani.WeilPositivity
