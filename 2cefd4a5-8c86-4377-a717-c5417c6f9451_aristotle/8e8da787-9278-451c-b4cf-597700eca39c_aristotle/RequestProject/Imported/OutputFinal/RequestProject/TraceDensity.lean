/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**The trace density of the Sonin sandwich**, for arXiv:2006.13771 (Connes–Consani,
*Weil positivity and Trace formula – the archimedean place*).

`RequestProject/TraceIdentityNorm.lean` shows that `ϑ(f) P₁ P̂₁ P₁` is trace class for
every test function `f ∈ C_c(ℝ⋆₊)`.  The functional `f ↦ Tr(ϑ(f) P₁P̂₁P₁)` is therefore
well defined, and the trace formula of the paper asserts that it equals the functional
`L_Norm` of the analytic part of the project.

Here we reduce that identity to a *pointwise* statement.  The main theorem,
`traceAlong_thetaOpOf_soninSandwich_eq_integral`, is the local trace formula in kernel
form:

  `Tr(ϑ(f) P₁P̂₁P₁) = ∫ f(λ) κ(λ) d*λ`,     `κ(λ) := Tr(ϑ(λ) P₁P̂₁P₁)`,

i.e. the trace functional is integration against the fixed *bounded* function `κ` on
`ℝ⋆₊`, the **trace density** (`traceDensity`).  The proof interchanges the trace series
with the Bochner integral defining `ϑ(f)`, which is legitimate because the trace series is
dominated uniformly in `λ` by the Hilbert–Schmidt norm of `B = P̂₁P₁`
(`tsum_enorm_inner_comp_soninSandwich_le`).

Consequently the remaining gap in the operator route is no longer the identification of a
*functional*, but of a *function*: `NormalizedTraceIdentity U` holds as soon as
`L_Norm(f) = ∫ f(λ) κ(λ) d*λ`, i.e. as soon as the trace density `κ` is identified with the
archimedean density of the analytic part of the project
(`normalizedTraceIdentity_of_traceDensity`).

The trace density is independent of the Hilbert basis used to compute it
(`traceDensity_eq_traceAlong`), and satisfies `|κ(λ)| ≤ ‖B‖²_{HS}` (`norm_traceDensity_le`).
-/
import RequestProject.Imported.OutputFinal.RequestProject.TraceIdentityNorm
import RequestProject.Imported.OutputFinal.RequestProject.EvenPicture

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory ContinuousLinearMap

open scoped CompactlySupported ENNReal

namespace ConnesConsani.WeilPositivity

variable {ι κ : Type*}

/-! ## A uniform bound for the trace series -/

section Bound

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E] [CompleteSpace E]

/-- The trace series of a product of two operators is dominated, in `ℝ≥0∞`, by the
Hilbert–Schmidt norms of the factors. -/
theorem tsum_enorm_inner_comp_le (b : HilbertBasis ι ℂ E) (A B : E →L[ℂ] E) :
    ∑' i, ‖inner ℂ (b i) ((A ∘L B) (b i))‖ₑ
      ≤ (hsNormSq b (ContinuousLinearMap.adjoint A) + hsNormSq b B) * 2⁻¹ := by
  have hpoint : ∀ i : ι, ‖inner ℂ (b i) ((A ∘L B) (b i))‖ₑ
      ≤ ((‖(ContinuousLinearMap.adjoint A) (b i)‖₊ : ℝ≥0∞)) ^ 2 * 2⁻¹
        + ((‖B (b i)‖₊ : ℝ≥0∞)) ^ 2 * 2⁻¹ := by
    intro i
    have h1 : inner ℂ (b i) ((A ∘L B) (b i))
        = inner ℂ ((ContinuousLinearMap.adjoint A) (b i)) (B (b i)) := by
      rw [ContinuousLinearMap.adjoint_inner_left]
      rfl
    have hreal : ‖inner ℂ ((ContinuousLinearMap.adjoint A) (b i)) (B (b i))‖
        ≤ ‖(ContinuousLinearMap.adjoint A) (b i)‖ ^ 2 / 2 + ‖B (b i)‖ ^ 2 / 2 := by
      refine (norm_inner_le_norm _ _).trans ?_
      nlinarith [sq_nonneg (‖(ContinuousLinearMap.adjoint A) (b i)‖ - ‖B (b i)‖)]
    have key : ∀ y : E, ENNReal.ofReal (‖y‖ ^ 2 / 2) = ((‖y‖₊ : ℝ≥0∞)) ^ 2 * 2⁻¹ := by
      intro y
      have h1 : ENNReal.ofReal (‖y‖ ^ 2) = ((‖y‖₊ : ℝ≥0∞)) ^ 2 := by
        rw [ENNReal.ofReal_pow (norm_nonneg y)]
        congr 1
        rw [ofReal_norm_eq_enorm, enorm_eq_nnnorm]
      have h2 : ENNReal.ofReal ((2:ℝ)⁻¹) = (2:ℝ≥0∞)⁻¹ := by
        rw [ENNReal.ofReal_inv_of_pos (by norm_num : (0:ℝ) < 2)]
        norm_num
      rw [div_eq_mul_inv, ENNReal.ofReal_mul (by positivity), h1, h2]
    rw [h1]
    calc ‖inner ℂ ((ContinuousLinearMap.adjoint A) (b i)) (B (b i))‖ₑ
        ≤ ENNReal.ofReal (‖(ContinuousLinearMap.adjoint A) (b i)‖ ^ 2 / 2
            + ‖B (b i)‖ ^ 2 / 2) := by
          rw [← ofReal_norm_eq_enorm]
          exact ENNReal.ofReal_le_ofReal hreal
      _ = ((‖(ContinuousLinearMap.adjoint A) (b i)‖₊ : ℝ≥0∞)) ^ 2 * 2⁻¹
            + ((‖B (b i)‖₊ : ℝ≥0∞)) ^ 2 * 2⁻¹ := by
          rw [ENNReal.ofReal_add (by positivity) (by positivity), key, key]
  calc ∑' i, ‖inner ℂ (b i) ((A ∘L B) (b i))‖ₑ
      ≤ ∑' i, (((‖(ContinuousLinearMap.adjoint A) (b i)‖₊ : ℝ≥0∞)) ^ 2 * 2⁻¹
          + ((‖B (b i)‖₊ : ℝ≥0∞)) ^ 2 * 2⁻¹) := ENNReal.tsum_le_tsum hpoint
    _ = (hsNormSq b (ContinuousLinearMap.adjoint A) + hsNormSq b B) * 2⁻¹ := by
        rw [ENNReal.tsum_add, ENNReal.tsum_mul_right, ENNReal.tsum_mul_right, hsNormSq, hsNormSq,
          add_mul]

end Bound

/-! ## A bound uniform over contractions -/

/-- **The uniform bound**: for a contraction `T` and any operator `B`, the trace series of
`T B* B` is absolutely bounded by the Hilbert–Schmidt norm of `B`. -/
theorem tsum_enorm_inner_comp_adjointSelf_le {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℂ E] [CompleteSpace E] (b : HilbertBasis ι ℂ E) (B : E →L[ℂ] E)
    {T : E →L[ℂ] E} (hT : ‖T‖ ≤ 1) :
    ∑' i, ‖inner ℂ (b i) ((T ∘L (ContinuousLinearMap.adjoint B ∘L B)) (b i))‖ₑ
      ≤ hsNormSq b B := by
  have hcomp : T ∘L (ContinuousLinearMap.adjoint B ∘L B)
      = (T ∘L ContinuousLinearMap.adjoint B) ∘L B := (ContinuousLinearMap.comp_assoc _ _ _).symm
  have hadj : ContinuousLinearMap.adjoint (T ∘L ContinuousLinearMap.adjoint B)
      = B ∘L ContinuousLinearMap.adjoint T := by
    rw [ContinuousLinearMap.adjoint_comp, ContinuousLinearMap.adjoint_adjoint]
  have hT2 : ((‖T‖₊ : ℝ≥0∞)) ^ 2 ≤ 1 := by
    have h : (‖T‖₊ : ℝ≥0∞) ≤ 1 := by
      rw [← ENNReal.coe_one]
      exact_mod_cast hT
    calc ((‖T‖₊ : ℝ≥0∞)) ^ 2 ≤ 1 ^ 2 := by gcongr
      _ = 1 := one_pow 2
  have hbound1 : hsNormSq b (B ∘L ContinuousLinearMap.adjoint T) ≤ hsNormSq b B := by
    have h1 : hsNormSq b (B ∘L ContinuousLinearMap.adjoint T)
        = hsNormSq b (T ∘L ContinuousLinearMap.adjoint B) := by
      rw [hsNormSq_adjoint b b (B ∘L ContinuousLinearMap.adjoint T),
        ContinuousLinearMap.adjoint_comp, ContinuousLinearMap.adjoint_adjoint]
    have h2 : hsNormSq b (T ∘L ContinuousLinearMap.adjoint B)
        ≤ ((‖T‖₊ : ℝ≥0∞)) ^ 2 * hsNormSq b (ContinuousLinearMap.adjoint B) :=
      hsNormSq_comp_le b T (ContinuousLinearMap.adjoint B)
    have h3 : hsNormSq b (ContinuousLinearMap.adjoint B) = hsNormSq b B :=
      (hsNormSq_adjoint b b B).symm
    rw [h1, ← h3]
    calc hsNormSq b (T ∘L ContinuousLinearMap.adjoint B)
        ≤ ((‖T‖₊ : ℝ≥0∞)) ^ 2 * hsNormSq b (ContinuousLinearMap.adjoint B) := h2
      _ ≤ 1 * hsNormSq b (ContinuousLinearMap.adjoint B) := by gcongr
      _ = hsNormSq b (ContinuousLinearMap.adjoint B) := one_mul _
  have hmain := tsum_enorm_inner_comp_le b (T ∘L ContinuousLinearMap.adjoint B) B
  rw [hadj] at hmain
  rw [hcomp]
  refine hmain.trans ?_
  calc (hsNormSq b (B ∘L ContinuousLinearMap.adjoint T) + hsNormSq b B) * 2⁻¹
      ≤ (hsNormSq b B + hsNormSq b B) * 2⁻¹ :=
        mul_le_mul' (add_le_add hbound1 le_rfl) le_rfl
    _ = hsNormSq b B := by
        rw [← two_mul, mul_comm, ← mul_assoc, ENNReal.inv_mul_cancel (by simp) (by simp), one_mul]

/-! ## The Sonin sandwich: a bound uniform over the unitaries `ϑ(λ)` -/

/-- The Hilbert-Schmidt norm (squared) of `B = P̂₁ P₁`, the natural bound for the trace of
`T P₁P̂₁P₁` when `T` is a contraction. -/
def soninHSNormSq (b : HilbertBasis ι ℂ L2R) : ℝ≥0∞ := hsNormSq b (P1hat ∘L P1)

theorem soninHSNormSq_ne_top (b : HilbertBasis ι ℂ L2R) : soninHSNormSq b ≠ ⊤ :=
  isHilbertSchmidt_P1hat_comp_P1 b

/-- **The uniform bound for the Sonin sandwich**: for every contraction `T`, the trace
series of `T P₁P̂₁P₁` is absolutely bounded by the Hilbert-Schmidt norm of `B = P̂₁P₁`. -/
theorem tsum_enorm_inner_comp_soninSandwich_le (b : HilbertBasis ι ℂ L2R)
    {T : L2R →L[ℂ] L2R} (hT : ‖T‖ ≤ 1) :
    ∑' i, ‖inner ℂ (b i) ((T ∘L soninSandwich) (b i))‖ₑ ≤ soninHSNormSq b := by
  rw [soninSandwich_eq_adjoint_comp, soninHSNormSq]
  exact tsum_enorm_inner_comp_adjointSelf_le b (P1hat ∘L P1) hT

/-! ## The unitaries `ϑ(λ)` transported to `L²(ℝ)` -/

variable (U : L2Rplus ≃ₗᵢ[ℂ] L2R)

/-- The scaling unitary `ϑ(λ)` of the paper, transported to `L²(ℝ)` along a unitary
identification `U` of `L²(ℝ⋆₊, d*ρ)` with `L²(ℝ)`. -/
def thetaUnitOf (lam : Rplus) : L2R →L[ℂ] L2R :=
  (U.toContinuousLinearEquiv : L2Rplus →L[ℂ] L2R) ∘L
    ((scaling lam).toContinuousLinearEquiv : L2Rplus →L[ℂ] L2Rplus) ∘L
    (U.symm.toContinuousLinearEquiv : L2R →L[ℂ] L2Rplus)

theorem thetaUnitOf_apply (lam : Rplus) (f : L2R) :
    thetaUnitOf U lam f = U (scaling lam (U.symm f)) := rfl

theorem norm_thetaUnitOf_apply (lam : Rplus) (f : L2R) : ‖thetaUnitOf U lam f‖ = ‖f‖ := by
  rw [thetaUnitOf_apply, LinearIsometryEquiv.norm_map, LinearIsometryEquiv.norm_map,
    LinearIsometryEquiv.norm_map]

theorem norm_thetaUnitOf_le_one (lam : Rplus) : ‖thetaUnitOf U lam‖ ≤ 1 :=
  ContinuousLinearMap.opNorm_le_bound _ zero_le_one fun f => by
    rw [norm_thetaUnitOf_apply, one_mul]

theorem continuous_thetaUnitOf_apply (f : L2R) :
    Continuous fun lam : Rplus => thetaUnitOf U lam f := by
  simp only [thetaUnitOf_apply]
  exact (LinearIsometryEquiv.continuous U).comp (continuous_scaling_apply (U.symm f))

/-! ## The trace density -/

/-- **The trace density** `κ(λ) = Tr(ϑ(λ) P₁P̂₁P₁)`, computed along a Hilbert basis `b`
(the value does not depend on `b`, see `traceDensity_basis_indep`). -/
def traceDensity (b : HilbertBasis ι ℂ L2R) (lam : Rplus) : ℂ :=
  traceAlong b (thetaUnitOf U lam ∘L soninSandwich)

theorem traceDensity_basis_indep (b : HilbertBasis ι ℂ L2R) (c : HilbertBasis κ ℂ L2R)
    (lam : Rplus) : traceDensity U b lam = traceDensity U c lam :=
  traceAlong_basis_indep_of_isTraceClass b c
    (isTraceClass_comp_soninSandwich b (thetaUnitOf U lam))

/-- The trace density is bounded by the Hilbert–Schmidt norm of `B = P̂₁P₁`. -/
theorem enorm_traceDensity_le (b : HilbertBasis ι ℂ L2R) (lam : Rplus) :
    ‖traceDensity U b lam‖ₑ ≤ soninHSNormSq b := by
  refine le_trans ?_ (tsum_enorm_inner_comp_soninSandwich_le b (norm_thetaUnitOf_le_one U lam))
  rw [traceDensity, traceAlong]
  exact enorm_tsum_le_tsum_enorm

theorem continuous_traceDensity_inner (b : HilbertBasis ι ℂ L2R) (i : ι) :
    Continuous fun lam : Rplus =>
      (inner ℂ (b i) ((thetaUnitOf U lam ∘L soninSandwich) (b i)) : ℂ) := by
  have h : Continuous fun lam : Rplus => thetaUnitOf U lam (soninSandwich (b i)) :=
    continuous_thetaUnitOf_apply U (soninSandwich (b i))
  exact (continuous_const.inner h)

/-! ## The local trace formula in kernel form -/

/-- The matrix elements of `ϑ(f) P₁P̂₁P₁` are the integrals of those of `ϑ(λ) P₁P̂₁P₁`. -/
theorem inner_thetaOpOf_soninSandwich_eq_integral (g : C_c(Rplus, ℂ)) (v : L2R) :
    (inner ℂ v ((thetaOpOf U g ∘L soninSandwich) v) : ℂ)
      = ∫ lam, g lam * inner ℂ v ((thetaUnitOf U lam ∘L soninSandwich) v) ∂(Rplus.haar) := by
  have hU : ∀ (a : L2R) (z : L2Rplus), (inner ℂ a (U z) : ℂ) = inner ℂ (U.symm a) z := by
    intro a z
    rw [← U.inner_map_map (U.symm a) z, LinearIsometryEquiv.apply_symm_apply]
  show (inner ℂ v (thetaOpOf U g (soninSandwich v)) : ℂ) = _
  rw [thetaOpOf_apply, hU, inner_scalingOp_apply]
  refine integral_congr_ae (.of_forall fun lam => ?_)
  simp only [ContinuousLinearMap.comp_apply, thetaUnitOf_apply, hU]

/-- **The local trace formula in kernel form**: the trace functional of the Sonin sandwich
is integration against the trace density,

  `Tr(ϑ(f) P₁P̂₁P₁) = ∫ f(λ) κ(λ) d*λ`,   `κ(λ) = Tr(ϑ(λ) P₁P̂₁P₁)`.

The trace series and the Bochner integral defining `ϑ(f)` may be interchanged because the
trace series is dominated, uniformly in `λ`, by the Hilbert–Schmidt norm of `B = P̂₁P₁`. -/
theorem traceAlong_thetaOpOf_soninSandwich_eq_integral [Countable ι] (b : HilbertBasis ι ℂ L2R)
    (g : C_c(Rplus, ℂ)) :
    traceAlong b (thetaOpOf U g ∘L soninSandwich)
      = ∫ lam, g lam * traceDensity U b lam ∂(Rplus.haar) := by
  classical
  set F : ι → Rplus → ℂ := fun i lam =>
    g lam * inner ℂ (b i) ((thetaUnitOf U lam ∘L soninSandwich) (b i)) with hF
  have hmeas : ∀ i, AEStronglyMeasurable (F i) Rplus.haar := fun i =>
    (((map_continuous g).mul (continuous_traceDensity_inner U b i))).aestronglyMeasurable
  have hgint : ∫⁻ lam, ‖g lam‖ₑ ∂(Rplus.haar) ≠ ⊤ := by
    have := (integrable_norm g).hasFiniteIntegral
    simpa [HasFiniteIntegral] using this.ne
  have hdom : ∑' i, ∫⁻ lam, ‖F i lam‖ₑ ∂(Rplus.haar) ≠ ⊤ := by
    have hswap : ∑' i, ∫⁻ lam, ‖F i lam‖ₑ ∂(Rplus.haar)
        = ∫⁻ lam, ∑' i, ‖F i lam‖ₑ ∂(Rplus.haar) :=
      (lintegral_tsum fun i => ((hmeas i).enorm)).symm
    have hpoint : ∀ lam : Rplus, ∑' i, ‖F i lam‖ₑ ≤ ‖g lam‖ₑ * soninHSNormSq b := by
      intro lam
      have h1 : ∀ i, ‖F i lam‖ₑ
          = ‖g lam‖ₑ * ‖inner ℂ (b i) ((thetaUnitOf U lam ∘L soninSandwich) (b i))‖ₑ := by
        intro i; rw [hF]; simp [enorm_mul]
      calc ∑' i, ‖F i lam‖ₑ
          = ∑' i, ‖g lam‖ₑ * ‖inner ℂ (b i)
              ((thetaUnitOf U lam ∘L soninSandwich) (b i))‖ₑ := tsum_congr h1
        _ = ‖g lam‖ₑ * ∑' i, ‖inner ℂ (b i)
              ((thetaUnitOf U lam ∘L soninSandwich) (b i))‖ₑ := ENNReal.tsum_mul_left
        _ ≤ ‖g lam‖ₑ * soninHSNormSq b := by
            gcongr
            exact tsum_enorm_inner_comp_soninSandwich_le b (norm_thetaUnitOf_le_one U lam)
    rw [hswap]
    refine ne_top_of_le_ne_top ?_ (lintegral_mono hpoint)
    rw [lintegral_mul_const' _ _ (soninHSNormSq_ne_top b)]
    exact ENNReal.mul_ne_top hgint (soninHSNormSq_ne_top b)
  have hsum : ∫ lam, (∑' i, F i lam) ∂(Rplus.haar) = ∑' i, ∫ lam, F i lam ∂(Rplus.haar) :=
    integral_tsum hmeas hdom
  have hfib : ∀ lam : Rplus, (∑' i, F i lam) = g lam * traceDensity U b lam := by
    intro lam
    rw [hF]
    simp only []
    rw [tsum_mul_left]
    rfl
  calc traceAlong b (thetaOpOf U g ∘L soninSandwich)
      = ∑' i, ∫ lam, F i lam ∂(Rplus.haar) := by
        refine tsum_congr fun i => ?_
        exact inner_thetaOpOf_soninSandwich_eq_integral U g (b i)
    _ = ∫ lam, (∑' i, F i lam) ∂(Rplus.haar) := hsum.symm
    _ = ∫ lam, g lam * traceDensity U b lam ∂(Rplus.haar) := by
        exact integral_congr_ae (.of_forall hfib)

/-! ## A countable Hilbert basis of `L²(ℝ)`, and the reduction of the trace identity -/

/-- In a separable inner product space every orthonormal family is countable. -/
theorem countable_of_orthonormal {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]
    [TopologicalSpace.SeparableSpace E] {v : ι → E} (hv : Orthonormal ℂ v) : Countable ι := by
  have hdist : ∀ i j : ι, i ≠ j → 1 ≤ dist (v i) (v j) := by
    intro i j hij
    have hinner : (inner ℂ (v i - v j) (v i) : ℂ) = 1 := by
      rw [inner_sub_left, hv.inner_eq_zero (Ne.symm hij), sub_zero]
      have := hv.1 i
      rw [inner_self_eq_norm_sq_to_K, this]
      norm_num
    have h1 : (1:ℝ) ≤ ‖v i - v j‖ * ‖v i‖ := by
      have := norm_inner_le_norm (𝕜 := ℂ) (v i - v j) (v i)
      rw [hinner] at this
      simpa using this
    rw [dist_eq_norm]
    rwa [hv.1 i, mul_one] at h1
  have hdisj : (Set.univ : Set ι).PairwiseDisjoint fun i => Metric.ball (v i) (1/2) := by
    intro i _ j _ hij
    refine Metric.ball_disjoint_ball ?_
    have := hdist i j hij
    linarith
  have hcount := hdisj.countable_of_isOpen (fun i _ => Metric.isOpen_ball)
    (fun i _ => ⟨v i, Metric.mem_ball_self (by norm_num)⟩)
  exact Set.countable_univ_iff.mp hcount

instance : Fact ((2 : ℝ≥0∞) ≠ ⊤) := ⟨by simp⟩

instance : TopologicalSpace.SeparableSpace L2R := by
  haveI : SecondCountableTopology L2R := MeasureTheory.Lp.SecondCountableTopology
  infer_instance

/-- `L²(ℝ)` has a countable Hilbert basis. -/
theorem exists_countable_hilbertBasis_L2R :
    ∃ (w : Set L2R) (b : HilbertBasis w ℂ L2R), Countable w ∧ ⇑b = ((↑) : w → L2R) := by
  obtain ⟨w, b, hb⟩ := exists_hilbertBasis ℂ L2R
  refine ⟨w, b, ?_, hb⟩
  have hortho : Orthonormal ℂ (fun x : w => (x : L2R)) := by
    have := b.orthonormal
    rwa [hb] at this
  exact countable_of_orthonormal hortho

/-- A fixed countable Hilbert basis of `L²(ℝ)`, used to normalize the trace density. -/
def stdBasisSet : Set L2R := (exists_countable_hilbertBasis_L2R).choose

def stdBasis : HilbertBasis stdBasisSet ℂ L2R :=
  (exists_countable_hilbertBasis_L2R).choose_spec.choose

instance : Countable stdBasisSet :=
  (exists_countable_hilbertBasis_L2R).choose_spec.choose_spec.1

/-- **The trace density** `κ(λ) = Tr(ϑ(λ) P₁P̂₁P₁)`, as a function on `ℝ⋆₊` (computed in a
fixed countable Hilbert basis; by `traceDensity_basis_indep` any other basis gives the same
function). -/
def traceDensityStd (lam : Rplus) : ℂ := traceDensity U stdBasis lam

theorem traceDensityStd_eq (b : HilbertBasis ι ℂ L2R) (lam : Rplus) :
    traceDensityStd U lam = traceDensity U b lam :=
  traceDensity_basis_indep U stdBasis b lam

/-- **The reduction of the normalized trace identity to an identity of functions.**
The operator-theoretic statement `L_Norm(f) = Tr(ϑ(f) P P̂ P)` holds as soon as the
functional `L_Norm` is integration against the trace density `κ`; by the kernel form of the
local trace formula the two statements are in fact equivalent. -/
theorem normalizedTraceIdentity_iff_traceDensity :
    NormalizedTraceIdentity U ↔
      ∀ g : C_c(Rplus, ℂ),
        LfunNorm (logTest g) = ∫ lam, g lam * traceDensityStd U lam ∂(Rplus.haar) := by
  constructor
  · intro h g
    rw [h stdBasis g]
    exact traceAlong_thetaOpOf_soninSandwich_eq_integral U stdBasis g
  · intro h ι b g
    rw [h g]
    simp only [traceDensityStd]
    rw [← traceAlong_thetaOpOf_soninSandwich_eq_integral U stdBasis g]
    exact traceAlong_basis_indep_of_isTraceClass stdBasis b
      (isTraceClass_thetaOp_soninSandwich stdBasis U g)

end ConnesConsani.WeilPositivity
