/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**The trace at a finite cut-off scale, in kernel form.**

`RequestProject/TraceDensity.lean` proves the local trace formula in kernel form for the
fixed cut-off `Λ = 1`,

  `Tr(ϑ(f) P₁P̂₁P₁) = ∫ f(λ) κ(λ) d*λ`,   `κ(λ) = Tr(ϑ(λ) P₁P̂₁P₁)`.

Here the same reduction is carried out at every cut-off scale `Λ`: with

  `κ_Λ(λ) := Tr(ϑ(λ) S^{(Λ)})`,   `S^{(Λ)} = P^{(Λ)} P̂^{(Λ)} P^{(Λ)}`,

one has

  `Tr(ϑ(f) S^{(Λ)}) = ∫ f(λ) κ_Λ(λ) d*λ`   (`cutTrace_eq_integral`),

and hence the regularized trace of `RequestProject/RenormalizedTrace.lean` is

  `∫ f(λ) κ_Λ(λ) d*λ - 2 f(1) log Λ`   (`regularizedCutTrace_eq_integral`).

This turns the conjectural renormalized identity into a statement about the *family of
functions* `κ_Λ` — the semi-local densities of the paper — rather than about a family of
functionals: the identity holds as soon as, for every test function,
`∫ f(λ) κ_Λ(λ) d*λ - 2 f(1) log Λ → L_Norm(f)` (`renormalizedTraceIdentity_of_density`).
The density is bounded at each scale by the Hilbert–Schmidt norm of `B_Λ = P̂^{(Λ)} P^{(Λ)}`
(`enorm_traceDensityCut_le`), a bound which necessarily blows up with `Λ` — this is the
divergence proved in `RequestProject/TraceDivergence.lean`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.RenormalizedTrace
import RequestProject.Imported.OutputFinal.RequestProject.TraceDensity

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory ContinuousLinearMap Filter Topology

open scoped CompactlySupported ENNReal

namespace ConnesConsani.WeilPositivity

variable {ι kappa : Type*}

/-! ## The uniform bound at the scale `Λ` -/

/-- The squared Hilbert–Schmidt norm of `B_Λ = P̂^{(Λ)} P^{(Λ)}`. -/
def soninCutHSNormSq (b : HilbertBasis ι ℂ L2R) (lam : ℝ) : ℝ≥0∞ :=
  hsNormSq b (PcutHat lam ∘L Pcut lam)

theorem soninCutHSNormSq_ne_top (b : HilbertBasis ι ℂ L2R) (lam : ℝ) :
    soninCutHSNormSq b lam ≠ ⊤ :=
  isHilbertSchmidt_PcutHat_comp_Pcut lam b

/-- For every contraction `T`, the trace series of `T S^{(Λ)}` is absolutely bounded by the
Hilbert–Schmidt norm of `B_Λ`. -/
theorem tsum_enorm_inner_comp_soninSandwichCut_le (b : HilbertBasis ι ℂ L2R) (lam : ℝ)
    {T : L2R →L[ℂ] L2R} (hT : ‖T‖ ≤ 1) :
    ∑' i, ‖inner ℂ (b i) ((T ∘L soninSandwichCut lam) (b i))‖ₑ ≤ soninCutHSNormSq b lam := by
  rw [soninSandwichCut_eq_adjoint_comp, soninCutHSNormSq]
  exact tsum_enorm_inner_comp_adjointSelf_le b (PcutHat lam ∘L Pcut lam) hT

/-! ## The trace density at the scale `Λ` -/

variable (U : L2Rplus ≃ₗᵢ[ℂ] L2R)

/-- **The semi-local trace density** `κ_Λ(λ) = Tr(ϑ(λ) S^{(Λ)})`. -/
def traceDensityCut (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (lam : Rplus) : ℂ :=
  traceAlong b (thetaUnitOf U lam ∘L soninSandwichCut cut)

theorem traceDensityCut_basis_indep (b : HilbertBasis ι ℂ L2R) (c : HilbertBasis kappa ℂ L2R)
    (cut : ℝ) (lam : Rplus) :
    traceDensityCut U b cut lam = traceDensityCut U c cut lam :=
  traceAlong_basis_indep_of_isTraceClass b c
    (isTraceClass_comp_soninSandwichCut cut b (thetaUnitOf U lam))

/-- At the scale `Λ = 1` the semi-local density is the trace density of
`RequestProject/TraceDensity.lean`. -/
theorem traceDensityCut_one (b : HilbertBasis ι ℂ L2R) (lam : Rplus) :
    traceDensityCut U b 1 lam = traceDensity U b lam := rfl

/-- The density is bounded by the Hilbert–Schmidt norm of `B_Λ`. -/
theorem enorm_traceDensityCut_le (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (lam : Rplus) :
    ‖traceDensityCut U b cut lam‖ₑ ≤ soninCutHSNormSq b cut := by
  refine le_trans ?_
    (tsum_enorm_inner_comp_soninSandwichCut_le b cut (norm_thetaUnitOf_le_one U lam))
  rw [traceDensityCut, traceAlong]
  exact enorm_tsum_le_tsum_enorm

theorem continuous_traceDensityCut_inner (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (i : ι) :
    Continuous fun lam : Rplus =>
      (inner ℂ (b i) ((thetaUnitOf U lam ∘L soninSandwichCut cut) (b i)) : ℂ) :=
  continuous_const.inner (continuous_thetaUnitOf_apply U (soninSandwichCut cut (b i)))

/-! ## The trace at a finite scale, in kernel form -/

/-- The matrix elements of `ϑ(f) S^{(Λ)}` are the integrals of those of `ϑ(λ) S^{(Λ)}`. -/
theorem inner_thetaOpOf_soninSandwichCut_eq_integral (cut : ℝ) (g : C_c(Rplus, ℂ)) (v : L2R) :
    (inner ℂ v ((thetaOpOf U g ∘L soninSandwichCut cut) v) : ℂ)
      = ∫ lam, g lam * inner ℂ v ((thetaUnitOf U lam ∘L soninSandwichCut cut) v)
          ∂(Rplus.haar) := by
  have hU : ∀ (a : L2R) (z : L2Rplus), (inner ℂ a (U z) : ℂ) = inner ℂ (U.symm a) z := by
    intro a z
    rw [← U.inner_map_map (U.symm a) z, LinearIsometryEquiv.apply_symm_apply]
  show (inner ℂ v (thetaOpOf U g (soninSandwichCut cut v)) : ℂ) = _
  rw [thetaOpOf_apply, hU, inner_scalingOp_apply]
  refine integral_congr_ae (.of_forall fun lam => ?_)
  simp only [ContinuousLinearMap.comp_apply, thetaUnitOf_apply, hU]

/-- **The trace at a finite cut-off scale, in kernel form**:

  `Tr(ϑ(f) S^{(Λ)}) = ∫ f(λ) κ_Λ(λ) d*λ`.

The trace series and the Bochner integral defining `ϑ(f)` may be interchanged because the
trace series is dominated, uniformly in `λ`, by the Hilbert–Schmidt norm of `B_Λ`. -/
theorem cutTrace_eq_integral [Countable ι] (b : HilbertBasis ι ℂ L2R) (cut : ℝ)
    (g : C_c(Rplus, ℂ)) :
    cutTrace b U cut g = ∫ lam, g lam * traceDensityCut U b cut lam ∂(Rplus.haar) := by
  classical
  set F : ι → Rplus → ℂ := fun i lam =>
    g lam * inner ℂ (b i) ((thetaUnitOf U lam ∘L soninSandwichCut cut) (b i)) with hF
  have hmeas : ∀ i, AEStronglyMeasurable (F i) Rplus.haar := fun i =>
    (((map_continuous g).mul (continuous_traceDensityCut_inner U b cut i))).aestronglyMeasurable
  have hgint : ∫⁻ lam, ‖g lam‖ₑ ∂(Rplus.haar) ≠ ⊤ := by
    have := (integrable_norm g).hasFiniteIntegral
    simpa [HasFiniteIntegral] using this.ne
  have hdom : ∑' i, ∫⁻ lam, ‖F i lam‖ₑ ∂(Rplus.haar) ≠ ⊤ := by
    have hswap : ∑' i, ∫⁻ lam, ‖F i lam‖ₑ ∂(Rplus.haar)
        = ∫⁻ lam, ∑' i, ‖F i lam‖ₑ ∂(Rplus.haar) :=
      (lintegral_tsum fun i => ((hmeas i).enorm)).symm
    have hpoint : ∀ lam : Rplus, ∑' i, ‖F i lam‖ₑ ≤ ‖g lam‖ₑ * soninCutHSNormSq b cut := by
      intro lam
      have h1 : ∀ i, ‖F i lam‖ₑ
          = ‖g lam‖ₑ * ‖inner ℂ (b i) ((thetaUnitOf U lam ∘L soninSandwichCut cut) (b i))‖ₑ := by
        intro i; rw [hF]; simp [enorm_mul]
      calc ∑' i, ‖F i lam‖ₑ
          = ∑' i, ‖g lam‖ₑ * ‖inner ℂ (b i)
              ((thetaUnitOf U lam ∘L soninSandwichCut cut) (b i))‖ₑ := tsum_congr h1
        _ = ‖g lam‖ₑ * ∑' i, ‖inner ℂ (b i)
              ((thetaUnitOf U lam ∘L soninSandwichCut cut) (b i))‖ₑ := ENNReal.tsum_mul_left
        _ ≤ ‖g lam‖ₑ * soninCutHSNormSq b cut := by
            gcongr
            exact tsum_enorm_inner_comp_soninSandwichCut_le b cut (norm_thetaUnitOf_le_one U lam)
    rw [hswap]
    refine ne_top_of_le_ne_top ?_ (lintegral_mono hpoint)
    rw [lintegral_mul_const' _ _ (soninCutHSNormSq_ne_top b cut)]
    exact ENNReal.mul_ne_top hgint (soninCutHSNormSq_ne_top b cut)
  have hsum : ∫ lam, (∑' i, F i lam) ∂(Rplus.haar) = ∑' i, ∫ lam, F i lam ∂(Rplus.haar) :=
    integral_tsum hmeas hdom
  have hfib : ∀ lam : Rplus, (∑' i, F i lam) = g lam * traceDensityCut U b cut lam := by
    intro lam
    rw [hF]
    simp only []
    rw [tsum_mul_left]
    rfl
  calc cutTrace b U cut g
      = ∑' i, ∫ lam, F i lam ∂(Rplus.haar) := by
        refine tsum_congr fun i => ?_
        exact inner_thetaOpOf_soninSandwichCut_eq_integral U cut g (b i)
    _ = ∫ lam, (∑' i, F i lam) ∂(Rplus.haar) := hsum.symm
    _ = ∫ lam, g lam * traceDensityCut U b cut lam ∂(Rplus.haar) :=
        integral_congr_ae (.of_forall hfib)

/-- **The regularized trace in kernel form**:
`Tr(ϑ(f) S^{(Λ)}) - 2 f(1) log Λ = ∫ f(λ) κ_Λ(λ) d*λ - 2 f(1) log Λ`. -/
theorem regularizedCutTrace_eq_integral [Countable ι] (b : HilbertBasis ι ℂ L2R) (cut : ℝ)
    (g : C_c(Rplus, ℂ)) :
    regularizedCutTrace b U cut g
      = (∫ lam, g lam * traceDensityCut U b cut lam ∂(Rplus.haar))
        - 2 * g 1 * (Real.log cut : ℂ) := by
  rw [regularizedCutTrace, cutTrace_eq_integral U b cut g, logCounterTerm, mul_assoc]

/-- The semi-local density computed in the fixed countable Hilbert basis of
`RequestProject/TraceDensity.lean`. -/
def traceDensityCutStd (cut : ℝ) (lam : Rplus) : ℂ := traceDensityCut U stdBasis cut lam

theorem traceDensityCutStd_eq (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (lam : Rplus) :
    traceDensityCutStd U cut lam = traceDensityCut U b cut lam :=
  traceDensityCut_basis_indep U stdBasis b cut lam

/-- **Reduction of the renormalized identity to the family of densities.**  The conjectural
identity `L_Norm(f) = lim_Λ (Tr(ϑ(f) S^{(Λ)}) - 2 f(1) log Λ)` is *equivalent* to the
convergence, for every test function, of the regularized integrals against the semi-local
densities `κ_Λ`.  The remaining analytic problem is therefore one about a family of
functions on `ℝ⋆₊`, not about a family of functionals. -/
theorem renormalizedTraceIdentity_iff_density :
    RenormalizedTraceIdentity U ↔
      ∀ g : C_c(Rplus, ℂ),
        Tendsto (fun cut : ℝ => (∫ lam, g lam * traceDensityCutStd U cut lam ∂(Rplus.haar))
          - 2 * g 1 * (Real.log cut : ℂ)) atTop (𝓝 (LfunNorm (logTest g))) := by
  constructor
  · intro h g
    refine Filter.Tendsto.congr (fun cut => ?_) (h stdBasis g)
    simpa [traceDensityCutStd] using regularizedCutTrace_eq_integral U stdBasis cut g
  · intro h ι b g
    refine Filter.Tendsto.congr (fun cut => ?_) (h g)
    rw [regularizedCutTrace_basis_indep b stdBasis U cut g]
    simpa [traceDensityCutStd] using (regularizedCutTrace_eq_integral U stdBasis cut g).symm

end ConnesConsani.WeilPositivity
