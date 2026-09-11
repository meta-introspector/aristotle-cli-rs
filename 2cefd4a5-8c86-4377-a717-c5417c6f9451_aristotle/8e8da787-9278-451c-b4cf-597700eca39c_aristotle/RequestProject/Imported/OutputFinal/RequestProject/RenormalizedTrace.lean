/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The renormalized trace functional

  `Tr_Λ(ϑ(f) S^{(Λ)}) - c(f) log Λ`,   `S^{(Λ)} = P^{(Λ)} P̂^{(Λ)} P^{(Λ)}`,

and the conjectural limit identity

  `L_Norm(f) = lim_{Λ→∞} (Tr_Λ(ϑ(f) S^{(Λ)}) - c(f) log Λ)`

of arXiv:2006.13771 (Connes–Consani, *Weil positivity and Trace formula – the archimedean
place*).

Background.  `RequestProject/TraceIdentityObstruction.lean` proves that the **fixed** cut-off
identity `L_Norm(f) = Tr(ϑ(f) P₁ P̂₁ P₁)` is false, for every unitary identification `U` of
the two pictures (`not_normalizedTraceIdentity`): the right-hand side is continuous for the
`L¹(d*λ)` norm, whereas `L_Norm` is a distribution of order one.  The trace formula of
Connes–Consani is therefore necessarily a *renormalized* statement: the cut-off scale `Λ`
has to go to infinity, and the divergence — which for a cut-off in space **and** in
frequency at the scale `Λ` is `2 f(1) log Λ` — has to be subtracted.  This file sets up
that statement:

* `cutTrace b U Λ f = Tr(ϑ(f) S^{(Λ)})`, well defined by `RequestProject/CutoffFamilyHS.lean`
  (trace class, absolutely convergent series, independent of the basis);
* `logCounterTerm f = 2 f(1)`, the expected coefficient of the logarithmic divergence;
* `regularizedCutTrace b U Λ f = cutTrace b U Λ f - logCounterTerm f * log Λ`;
* `HasRenormalizedTrace b U f z`: the finite part exists and equals `z`;
* `RenormalizedTraceIdentity U`: the conjectural identity, for every test function.

The identity itself is **not** proved: it is a `Prop`, never an axiom.  What is proved here
is the structural theory that surrounds it: the finite part is unique when it exists, it is
independent of the Hilbert basis used to compute the trace, it is linear in the test
function, the counter-term is linear and, on a convolution square `g ∗ g^♯`, equals
`2‖g‖²_{L²(d*λ)} ≥ 0` — so the divergence is genuinely present unless `g = 0`, which is the
precise reason why the fixed-scale identity had to fail.  Finally, at the scale `Λ = 1` the
regularized trace is exactly the fixed-cut-off trace of the refuted identity, so the frozen
negative result reappears here as the statement that no *fixed* scale can work
(`not_fixedScale_renormalizedTraceIdentity`).
-/
import RequestProject.Imported.OutputFinal.RequestProject.CutoffFamilyHS
import RequestProject.Imported.OutputFinal.RequestProject.TraceIdentityNorm
import RequestProject.Imported.OutputFinal.RequestProject.TraceIdentityObstruction

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory Filter Topology ContinuousLinearMap

open scoped CompactlySupported

namespace ConnesConsani.WeilPositivity

variable {ι : Type*}

/-! ## The trace at a finite cut-off scale -/

/-- **The trace at the cut-off scale `Λ`**, `Tr_Λ(ϑ(f) S^{(Λ)})`, with
`S^{(Λ)} = P^{(Λ)} P̂^{(Λ)} P^{(Λ)}`.  It is well defined: the operator is trace class
(`isTraceClass_thetaOp_soninSandwichCut`) and the value does not depend on the basis
(`cutTrace_basis_indep`). -/
def cutTrace (b : HilbertBasis ι ℂ L2R) (U : L2Rplus ≃ₗᵢ[ℂ] L2R) (lam : ℝ)
    (g : C_c(Rplus, ℂ)) : ℂ :=
  traceAlong b (thetaOpOf U g ∘L soninSandwichCut lam)

/-- At the scale `Λ = 1` the cut-off sandwich is the Sonin sandwich `P₁ P̂₁ P₁`. -/
@[simp] theorem soninSandwichCut_one : soninSandwichCut 1 = soninSandwich := rfl

/-- At `Λ = 1` the renormalized trace is the fixed-cut-off trace of
`RequestProject/TraceIdentityNorm.lean`. -/
theorem cutTrace_one (b : HilbertBasis ι ℂ L2R) (U : L2Rplus ≃ₗᵢ[ℂ] L2R)
    (g : C_c(Rplus, ℂ)) :
    cutTrace b U 1 g = traceAlong b (thetaOpOf U g ∘L soninSandwich) := rfl

/-- The trace at scale `Λ` does not depend on the chosen Hilbert basis. -/
theorem cutTrace_basis_indep {κ : Type*} (b : HilbertBasis ι ℂ L2R) (c : HilbertBasis κ ℂ L2R)
    (U : L2Rplus ≃ₗᵢ[ℂ] L2R) (lam : ℝ) (g : C_c(Rplus, ℂ)) :
    cutTrace b U lam g = cutTrace c U lam g :=
  traceAlong_thetaOp_soninSandwichCut_basis_indep lam b c U g

/-- The trace at scale `Λ` is additive in the test function. -/
theorem cutTrace_add (b : HilbertBasis ι ℂ L2R) (U : L2Rplus ≃ₗᵢ[ℂ] L2R) (lam : ℝ)
    (g₁ g₂ : C_c(Rplus, ℂ)) :
    cutTrace b U lam (g₁ + g₂) = cutTrace b U lam g₁ + cutTrace b U lam g₂ := by
  rw [cutTrace, cutTrace, cutTrace, thetaOpOf_add, ContinuousLinearMap.add_comp]
  exact traceAlong_add_of_isTraceClass (isTraceClass_thetaOp_soninSandwichCut lam b U g₁)
    (isTraceClass_thetaOp_soninSandwichCut lam b U g₂)

/-- The trace at scale `Λ` is homogeneous in the test function. -/
theorem cutTrace_smul (b : HilbertBasis ι ℂ L2R) (U : L2Rplus ≃ₗᵢ[ℂ] L2R) (lam : ℝ) (c : ℂ)
    (g : C_c(Rplus, ℂ)) :
    cutTrace b U lam (c • g) = c * cutTrace b U lam g := by
  rw [cutTrace, cutTrace, thetaOpOf_smul, ContinuousLinearMap.smul_comp, traceAlong_smul]

/-- **Positivity at every finite scale**: `Tr_Λ(ϑ(g ∗ g^♯) S^{(Λ)}) ≥ 0`. -/
theorem re_cutTrace_convSquare_nonneg (b : HilbertBasis ι ℂ L2R) (U : L2Rplus ≃ₗᵢ[ℂ] L2R)
    (lam : ℝ) (g : C_c(Rplus, ℂ)) :
    0 ≤ (cutTrace b U lam (testConv g (starTest g))).re :=
  re_traceAlong_thetaOp_convSquare_soninSandwichCut_nonneg lam b U g

/-! ## The logarithmic counter-term -/

/-- **The counter-term** `c(f) = 2 f(1)`: the expected coefficient of the divergent
`log Λ` in `Tr_Λ(ϑ(f) S^{(Λ)})`.  The factor `2` is the number of cut-offs (one in space,
one in frequency), each contributing `f(1) log Λ`. -/
def logCounterTerm (g : C_c(Rplus, ℂ)) : ℂ := 2 * g 1

@[simp] theorem logCounterTerm_add (g₁ g₂ : C_c(Rplus, ℂ)) :
    logCounterTerm (g₁ + g₂) = logCounterTerm g₁ + logCounterTerm g₂ := by
  simp [logCounterTerm, mul_add]

@[simp] theorem logCounterTerm_smul (c : ℂ) (g : C_c(Rplus, ℂ)) :
    logCounterTerm (c • g) = c * logCounterTerm g := by
  simp [logCounterTerm]
  ring

/-- **The counter-term on a convolution square** is `2‖g‖²_{L²(ℝ⋆₊, d*λ)}`: the divergence
is present for every nonzero `g`. -/
theorem logCounterTerm_convSquare (g : C_c(Rplus, ℂ)) :
    logCounterTerm (testConv g (starTest g)) = 2 * ((∫ lam, ‖g lam‖ ^ 2 ∂(Rplus.haar) : ℝ) : ℂ) := by
  rw [logCounterTerm, testConv_apply]
  congr 1
  rw [← integral_complex_ofReal]
  refine integral_congr_ae (.of_forall fun a => ?_)
  simp only [mul_one, starTest_apply, inv_inv, Complex.mul_conj']
  push_cast
  ring

/-- The counter-term of a convolution square is a nonnegative real number. -/
theorem re_logCounterTerm_convSquare_nonneg (g : C_c(Rplus, ℂ)) :
    0 ≤ (logCounterTerm (testConv g (starTest g))).re := by
  rw [logCounterTerm_convSquare]
  have : (0 : ℝ) ≤ ∫ lam, ‖g lam‖ ^ 2 ∂(Rplus.haar) :=
    integral_nonneg fun a => by positivity
  simpa using this

/-! ## The regularized trace and its finite part -/

/-- **The regularized trace** `Tr_Λ(ϑ(f) S^{(Λ)}) - c(f) log Λ`. -/
def regularizedCutTrace (b : HilbertBasis ι ℂ L2R) (U : L2Rplus ≃ₗᵢ[ℂ] L2R) (lam : ℝ)
    (g : C_c(Rplus, ℂ)) : ℂ :=
  cutTrace b U lam g - logCounterTerm g * (Real.log lam : ℂ)

/-- At `Λ = 1` no subtraction takes place: the regularized trace is the fixed-cut-off trace
of the refuted identity. -/
theorem regularizedCutTrace_one (b : HilbertBasis ι ℂ L2R) (U : L2Rplus ≃ₗᵢ[ℂ] L2R)
    (g : C_c(Rplus, ℂ)) :
    regularizedCutTrace b U 1 g = traceAlong b (thetaOpOf U g ∘L soninSandwich) := by
  simp [regularizedCutTrace, cutTrace_one]

theorem regularizedCutTrace_basis_indep {κ : Type*} (b : HilbertBasis ι ℂ L2R)
    (c : HilbertBasis κ ℂ L2R) (U : L2Rplus ≃ₗᵢ[ℂ] L2R) (lam : ℝ) (g : C_c(Rplus, ℂ)) :
    regularizedCutTrace b U lam g = regularizedCutTrace c U lam g := by
  rw [regularizedCutTrace, regularizedCutTrace, cutTrace_basis_indep b c]

theorem regularizedCutTrace_add (b : HilbertBasis ι ℂ L2R) (U : L2Rplus ≃ₗᵢ[ℂ] L2R) (lam : ℝ)
    (g₁ g₂ : C_c(Rplus, ℂ)) :
    regularizedCutTrace b U lam (g₁ + g₂)
      = regularizedCutTrace b U lam g₁ + regularizedCutTrace b U lam g₂ := by
  rw [regularizedCutTrace, regularizedCutTrace, regularizedCutTrace, cutTrace_add,
    logCounterTerm_add]
  ring

theorem regularizedCutTrace_smul (b : HilbertBasis ι ℂ L2R) (U : L2Rplus ≃ₗᵢ[ℂ] L2R) (lam : ℝ)
    (c : ℂ) (g : C_c(Rplus, ℂ)) :
    regularizedCutTrace b U lam (c • g) = c * regularizedCutTrace b U lam g := by
  rw [regularizedCutTrace, regularizedCutTrace, cutTrace_smul, logCounterTerm_smul]
  ring

/-- **The finite part exists and equals `z`**: the regularized trace converges to `z` as the
cut-off scale goes to infinity. -/
def HasRenormalizedTrace (b : HilbertBasis ι ℂ L2R) (U : L2Rplus ≃ₗᵢ[ℂ] L2R)
    (g : C_c(Rplus, ℂ)) (z : ℂ) : Prop :=
  Tendsto (fun lam : ℝ => regularizedCutTrace b U lam g) atTop (𝓝 z)

/-- **The finite part is unique** when it exists. -/
theorem HasRenormalizedTrace.unique {b : HilbertBasis ι ℂ L2R} {U : L2Rplus ≃ₗᵢ[ℂ] L2R}
    {g : C_c(Rplus, ℂ)} {z w : ℂ} (hz : HasRenormalizedTrace b U g z)
    (hw : HasRenormalizedTrace b U g w) : z = w :=
  tendsto_nhds_unique hz hw

/-- The finite part does not depend on the Hilbert basis used to compute the traces. -/
theorem HasRenormalizedTrace.basis_indep {κ : Type*} {b : HilbertBasis ι ℂ L2R}
    (c : HilbertBasis κ ℂ L2R) {U : L2Rplus ≃ₗᵢ[ℂ] L2R} {g : C_c(Rplus, ℂ)} {z : ℂ}
    (hz : HasRenormalizedTrace b U g z) : HasRenormalizedTrace c U g z := by
  exact Filter.Tendsto.congr (fun lam => regularizedCutTrace_basis_indep b c U lam g) hz

/-- **The finite part is additive.** -/
theorem HasRenormalizedTrace.add {b : HilbertBasis ι ℂ L2R} {U : L2Rplus ≃ₗᵢ[ℂ] L2R}
    {g₁ g₂ : C_c(Rplus, ℂ)} {z₁ z₂ : ℂ} (h₁ : HasRenormalizedTrace b U g₁ z₁)
    (h₂ : HasRenormalizedTrace b U g₂ z₂) :
    HasRenormalizedTrace b U (g₁ + g₂) (z₁ + z₂) := by
  exact Filter.Tendsto.congr (fun lam => (regularizedCutTrace_add b U lam g₁ g₂).symm)
    (Filter.Tendsto.add h₁ h₂)

/-- **The finite part is homogeneous.** -/
theorem HasRenormalizedTrace.smul {b : HilbertBasis ι ℂ L2R} {U : L2Rplus ≃ₗᵢ[ℂ] L2R}
    {g : C_c(Rplus, ℂ)} {z : ℂ} (c : ℂ) (h : HasRenormalizedTrace b U g z) :
    HasRenormalizedTrace b U (c • g) (c * z) := by
  exact Filter.Tendsto.congr (fun lam => (regularizedCutTrace_smul b U lam c g).symm)
    (Filter.Tendsto.const_mul c h)

/-- **A lower bound at every finite scale on convolution squares**: the regularized trace of
`g ∗ g^♯` is bounded below by `-2‖g‖² log Λ`.  (The trace itself is nonnegative; the
counter-term is what may make the regularized value negative — the analytic counterpart of
the failure of the *unnormalized* positivity refuted in
`RequestProject/UnnormalizedCounterexample.lean`.) -/
theorem re_regularizedCutTrace_convSquare_ge (b : HilbertBasis ι ℂ L2R)
    (U : L2Rplus ≃ₗᵢ[ℂ] L2R) (lam : ℝ) (g : C_c(Rplus, ℂ)) :
    -(2 * (∫ t, ‖g t‖ ^ 2 ∂(Rplus.haar)) * Real.log lam)
      ≤ (regularizedCutTrace b U lam (testConv g (starTest g))).re := by
  have h0 := re_cutTrace_convSquare_nonneg b U lam g
  have hc : (logCounterTerm (testConv g (starTest g)) * (Real.log lam : ℂ)).re
      = 2 * (∫ t, ‖g t‖ ^ 2 ∂(Rplus.haar)) * Real.log lam := by
    rw [logCounterTerm_convSquare]
    simp
  rw [regularizedCutTrace, Complex.sub_re, hc]
  linarith

/-! ## The conjectural renormalized trace identity -/

/-- **The renormalized trace identity**

  `L_Norm(f) = lim_{Λ→∞} (Tr_Λ(ϑ(f) S^{(Λ)}) - 2 f(1) log Λ)`,

as a predicate on the unitary identification `U` of `L²(ℝ⋆₊, d*ρ)` with `L²(ℝ)`.  This is
the renormalized form of the local trace formula at the archimedean place; the fixed-scale
form (`NormalizedTraceIdentity`) is *false* by `not_normalizedTraceIdentity`, which is why
the limit is taken.  The identity is not proved here: it is an explicit hypothesis, never an
axiom. -/
def RenormalizedTraceIdentity (U : L2Rplus ≃ₗᵢ[ℂ] L2R) : Prop :=
  ∀ {ι : Type} (b : HilbertBasis ι ℂ L2R) (g : C_c(Rplus, ℂ)),
    HasRenormalizedTrace b U g (LfunNorm (logTest g))

/-- Granted the renormalized identity, the finite part — whenever it exists — *is* the
archimedean functional `L_Norm`. -/
theorem eq_LfunNorm_of_renormalizedTraceIdentity {U : L2Rplus ≃ₗᵢ[ℂ] L2R}
    (h : RenormalizedTraceIdentity U) {b : HilbertBasis ℕ ℂ L2R} {g : C_c(Rplus, ℂ)} {z : ℂ}
    (hz : HasRenormalizedTrace b U g z) : z = LfunNorm (logTest g) :=
  hz.unique (h b g)

/-- **No fixed cut-off scale can work.**  The frozen refutation of the fixed-cut-off trace
identity says exactly that the regularized trace at the scale `Λ = 1` does not compute
`L_Norm`; the renormalized identity above is therefore a statement about the limit
`Λ → ∞`, not about any single scale. -/
theorem not_fixedScale_renormalizedTraceIdentity (U : L2Rplus ≃ₗᵢ[ℂ] L2R) :
    ¬ ∀ {ι : Type} (b : HilbertBasis ι ℂ L2R) (g : C_c(Rplus, ℂ)),
        LfunNorm (logTest g) = regularizedCutTrace b U 1 g := by
  intro h
  refine not_normalizedTraceIdentity U ?_
  intro ι b g
  rw [← regularizedCutTrace_one b U g]
  exact h b g

end ConnesConsani.WeilPositivity
