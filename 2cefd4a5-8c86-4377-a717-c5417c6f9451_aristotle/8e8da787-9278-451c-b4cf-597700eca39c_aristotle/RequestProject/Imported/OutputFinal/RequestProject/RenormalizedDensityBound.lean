/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**Bounds and positive-definiteness of the semi-local densities `κ_Λ`.**

`RequestProject/RenormalizedTraceDensity.lean` writes the trace at a finite cut-off scale as
an integral against `κ_Λ(λ) = Tr(ϑ(λ) S^{(Λ)})`, and
`RequestProject/RenormalizedDensitySymmetry.lean` exhibits `κ_Λ` as a matrix coefficient
`κ_Λ(λ) = ⟪B_Λ^*, ϑ(λ) B_Λ^*⟫_HS` of the scaling representation on Hilbert–Schmidt
operators.  The consequences of that description are drawn here:

* `norm_traceDensityCut_le_one`: `|κ_Λ(λ)| ≤ κ_Λ(1)` for every `λ`, so the whole family is
  controlled, at the scale `Λ`, by its value at the unit — the value which is proved to
  diverge in `RequestProject/TraceDivergence.lean`.  All of the divergence of the cut-off
  trace therefore sits in the single number `κ_Λ(1) = ‖B_Λ‖²_{HS}`;
* `traceDensityCut_posSemidef`: `κ_Λ` is a **positive-definite function** on `ℝ⋆₊`, i.e.
  `∑_{i,j} conj(c_i) c_j κ_Λ(μ_i⁻¹ μ_j) ≥ 0` for all finite families.  This is the
  pointwise counterpart of the positivity `Tr(ϑ(g ∗ g^♯) S^{(Λ)}) ≥ 0` at every finite
  scale, and it survives the renormalization in the sense that it holds uniformly in `Λ`;
* `hasRenormalizedTrace_iff_tendsto_cutTrace`: for test functions vanishing at `1` there is
  no counter-term, and the renormalized trace is simply the limit of the cut-off traces.
-/
import RequestProject.Imported.OutputFinal.RequestProject.RenormalizedDensitySymmetry

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory ContinuousLinearMap Filter Topology

open scoped CompactlySupported ENNReal

namespace ConnesConsani.WeilPositivity

variable {ι : Type*} (U : L2Rplus ≃ₗᵢ[ℂ] L2R)

/-! ## The scaling representation on `L²(ℝ)` -/

/-- `ϑ` is a representation of `ℝ⋆₊`: `ϑ(a b) = ϑ(a) ϑ(b)`. -/
theorem thetaUnitOf_mul (a c : Rplus) (x : L2R) :
    thetaUnitOf U (a * c) x = thetaUnitOf U a (thetaUnitOf U c x) := by
  simp only [thetaUnitOf_apply, LinearIsometryEquiv.symm_apply_apply, scaling_mul]

/-! ## The density as an absolutely convergent series -/

/-- The Hilbert–Schmidt description of `κ_Λ`, written as a series over the basis. -/
theorem traceDensityCut_eq_tsum (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (lam : Rplus) :
    traceDensityCut U b cut lam
      = ∑' i, (inner ℂ (soninHalfCut cut (b i))
          (thetaUnitOf U lam (soninHalfCut cut (b i))) : ℂ) := by
  rw [traceDensityCut_eq_hsInner, hsInner]
  rfl

theorem norm_inner_thetaUnitOf_self_le (lam : Rplus) (x : L2R) :
    ‖(inner ℂ x (thetaUnitOf U lam x) : ℂ)‖ ≤ ‖x‖ ^ 2 := by
  calc ‖(inner ℂ x (thetaUnitOf U lam x) : ℂ)‖ ≤ ‖x‖ * ‖thetaUnitOf U lam x‖ :=
        norm_inner_le_norm _ _
    _ = ‖x‖ ^ 2 := by rw [norm_thetaUnitOf_apply]; ring

/-- The series defining `κ_Λ(λ)` converges absolutely, uniformly in `λ`. -/
theorem summable_inner_thetaUnitOf_soninHalfCut (b : HilbertBasis ι ℂ L2R) (cut : ℝ)
    (lam : Rplus) :
    Summable fun i => (inner ℂ (soninHalfCut cut (b i))
      (thetaUnitOf U lam (soninHalfCut cut (b i))) : ℂ) := by
  refine Summable.of_norm (Summable.of_nonneg_of_le (fun i => norm_nonneg _)
    (fun i => norm_inner_thetaUnitOf_self_le U lam (soninHalfCut cut (b i))) ?_)
  exact (isHilbertSchmidt_soninHalfCut b cut).summable_norm_sq

/-! ## The density is maximal at the unit -/

/-- `κ_Λ(1) = ‖B_Λ‖²_{HS}`, as a real number. -/
theorem traceDensityCut_one_eq_ofReal (b : HilbertBasis ι ℂ L2R) (cut : ℝ) :
    traceDensityCut U b cut 1
      = ((∑' i, ‖soninHalfCut cut (b i)‖ ^ 2 : ℝ) : ℂ) := by
  have hsum : Summable fun i => ‖soninHalfCut cut (b i)‖ ^ 2 :=
    (isHilbertSchmidt_soninHalfCut b cut).summable_norm_sq
  rw [traceDensityCut_one_eq_hsNormSq, Complex.ofReal_tsum]
  refine tsum_congr fun i => ?_
  push_cast
  ring

theorem re_traceDensityCut_one (b : HilbertBasis ι ℂ L2R) (cut : ℝ) :
    (traceDensityCut U b cut 1).re = ∑' i, ‖soninHalfCut cut (b i)‖ ^ 2 := by
  rw [traceDensityCut_one_eq_ofReal]
  simp

/-- **The semi-local density is maximal at the unit**: `|κ_Λ(λ)| ≤ κ_Λ(1)` for every `λ`.
Together with the divergence of `κ_Λ(1)` this locates the whole divergence of the cut-off
trace in the behaviour of the densities at `λ = 1`. -/
theorem norm_traceDensityCut_le_one (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (lam : Rplus) :
    ‖traceDensityCut U b cut lam‖ ≤ (traceDensityCut U b cut 1).re := by
  have hsum : Summable fun i => ‖soninHalfCut cut (b i)‖ ^ 2 :=
    (isHilbertSchmidt_soninHalfCut b cut).summable_norm_sq
  have hnorm : Summable fun i => ‖(inner ℂ (soninHalfCut cut (b i))
      (thetaUnitOf U lam (soninHalfCut cut (b i))) : ℂ)‖ :=
    Summable.of_nonneg_of_le (fun i => norm_nonneg _)
      (fun i => norm_inner_thetaUnitOf_self_le U lam (soninHalfCut cut (b i))) hsum
  rw [traceDensityCut_eq_tsum, re_traceDensityCut_one]
  refine le_trans (norm_tsum_le_tsum_norm hnorm) ?_
  exact Summable.tsum_le_tsum
    (fun i => norm_inner_thetaUnitOf_self_le U lam (soninHalfCut cut (b i))) hnorm hsum

/-! ## Positive-definiteness of the semi-local densities -/

/-- A finite sum of summable families is summable. -/
theorem summable_finsetSum {n : Type*} {alpha : Type*} (s : Finset n) (f : n → alpha → ℂ)
    (h : ∀ i ∈ s, Summable (f i)) : Summable fun k => ∑ i ∈ s, f i k := by
  classical
  induction s using Finset.induction with
  | empty => simp
  | insert a t ha ih =>
      simp only [Finset.sum_insert ha]
      exact (h a (by simp)).add (ih fun i hi => h i (by simp [hi]))

/-- **`κ_Λ` is a positive-definite function on `ℝ⋆₊`**, at every cut-off scale:
`∑_{i,j} conj(c_i) c_j κ_Λ(μ_i⁻¹ μ_j) ≥ 0`.  This is the pointwise form of the positivity
`Tr(ϑ(g ∗ g^♯) S^{(Λ)}) ≥ 0` of the cut-off trace, and it is uniform in `Λ`. -/
theorem traceDensityCut_posSemidef {n : Type*} (b : HilbertBasis ι ℂ L2R) (cut : ℝ)
    (s : Finset n) (c : n → ℂ) (mu : n → Rplus) :
    0 ≤ (∑ i ∈ s, ∑ j ∈ s, (starRingEnd ℂ) (c i) * c j
          * traceDensityCut U b cut ((mu i)⁻¹ * mu j)).re := by
  classical
  set v : ι → L2R := fun k => soninHalfCut cut (b k) with hv
  set A : n → n → ι → ℂ := fun i j k =>
    (starRingEnd ℂ) (c i) * c j
      * inner ℂ (thetaUnitOf U (mu i) (v k)) (thetaUnitOf U (mu j) (v k)) with hA
  set w : ι → L2R := fun k => ∑ j ∈ s, c j • thetaUnitOf U (mu j) (v k) with hw
  -- the density evaluated at `μ_i⁻¹ μ_j` is a matrix coefficient
  have hdens : ∀ i j, (starRingEnd ℂ) (c i) * c j
      * traceDensityCut U b cut ((mu i)⁻¹ * mu j) = ∑' k, A i j k := by
    intro i j
    rw [traceDensityCut_eq_tsum, ← tsum_mul_left]
    refine tsum_congr fun k => ?_
    have hinner : (inner ℂ (thetaUnitOf U (mu i) (v k)) (thetaUnitOf U (mu j) (v k)) : ℂ)
        = inner ℂ (v k) (thetaUnitOf U ((mu i)⁻¹ * mu j) (v k)) := by
      rw [inner_thetaUnitOf_left U (mu i) (v k) (thetaUnitOf U (mu j) (v k)),
        ← thetaUnitOf_mul]
    rw [hA]
    exact congrArg (fun z => (starRingEnd ℂ) (c i) * c j * z) hinner.symm
  -- each of the finitely many series converges
  have hAsummable : ∀ i j, Summable (A i j) := by
    intro i j
    have hbase : Summable fun k =>
        (inner ℂ (thetaUnitOf U (mu i) (v k)) (thetaUnitOf U (mu j) (v k)) : ℂ) := by
      refine Summable.of_norm (Summable.of_nonneg_of_le (fun k => norm_nonneg _)
        (fun k => ?_) ((isHilbertSchmidt_soninHalfCut b cut).summable_norm_sq))
      calc ‖(inner ℂ (thetaUnitOf U (mu i) (v k)) (thetaUnitOf U (mu j) (v k)) : ℂ)‖
          ≤ ‖thetaUnitOf U (mu i) (v k)‖ * ‖thetaUnitOf U (mu j) (v k)‖ :=
            norm_inner_le_norm _ _
        _ = ‖v k‖ ^ 2 := by
            rw [norm_thetaUnitOf_apply, norm_thetaUnitOf_apply]; ring
    exact hbase.mul_left _
  -- the double finite sum of the series is the series of the squared norms of `w`
  have hpoint : ∀ k, (∑ i ∈ s, ∑ j ∈ s, A i j k) = ((‖w k‖ : ℂ)) ^ 2 := by
    intro k
    have : (inner ℂ (w k) (w k) : ℂ) = ∑ i ∈ s, ∑ j ∈ s, A i j k := by
      rw [hw]
      rw [sum_inner]
      refine Finset.sum_congr rfl fun i _ => ?_
      rw [inner_smul_left, inner_sum, Finset.mul_sum]
      refine Finset.sum_congr rfl fun j _ => ?_
      rw [inner_smul_right, hA]
      ring
    rw [← this, inner_self_eq_norm_sq_to_K]
    rfl
  have hswap_inner : ∀ i, Summable fun k => ∑ j ∈ s, A i j k := fun i =>
    summable_finsetSum s (A i) fun j _ => hAsummable i j
  have hsummable_total : Summable fun k => ∑ i ∈ s, ∑ j ∈ s, A i j k :=
    summable_finsetSum s (fun i k => ∑ j ∈ s, A i j k) fun i _ => hswap_inner i
  have htotal : (∑ i ∈ s, ∑ j ∈ s, (starRingEnd ℂ) (c i) * c j
      * traceDensityCut U b cut ((mu i)⁻¹ * mu j))
      = ∑' k, ∑ i ∈ s, ∑ j ∈ s, A i j k := by
    rw [Summable.tsum_finsetSum (fun i _ => hswap_inner i)]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [Summable.tsum_finsetSum (fun j _ => hAsummable i j)]
    exact Finset.sum_congr rfl fun j _ => hdens i j
  rw [htotal]
  have hsq : Summable fun k => ((‖w k‖ : ℂ)) ^ 2 := hsummable_total.congr fun k => hpoint k
  rw [tsum_congr hpoint, Complex.re_tsum hsq]
  refine tsum_nonneg fun k => ?_
  have hcast : ((‖w k‖ : ℂ)) ^ 2 = ((‖w k‖ ^ 2 : ℝ) : ℂ) := by push_cast; ring
  rw [hcast, Complex.ofReal_re]
  positivity

/-! ## Monotonicity of the divergent quantity -/

/-- Composing on the left with a contraction does not increase the Hilbert–Schmidt norm. -/
theorem hsNormSq_comp_left_le (b : HilbertBasis ι ℂ L2R) (T : L2R →L[ℂ] L2R)
    {C : L2R →L[ℂ] L2R} (hC : ∀ x, ‖C x‖ ≤ ‖x‖) :
    hsNormSq b (C ∘L T) ≤ hsNormSq b T := by
  refine ENNReal.tsum_le_tsum fun i => ?_
  have h : ((‖(C ∘L T) (b i)‖₊ : ℝ≥0∞)) ≤ ((‖T (b i)‖₊ : ℝ≥0∞)) := by
    exact_mod_cast hC (T (b i))
  gcongr

/-- Composing on the right with a self-adjoint contraction does not increase the
Hilbert–Schmidt norm. -/
theorem hsNormSq_comp_right_le (b : HilbertBasis ι ℂ L2R) (T : L2R →L[ℂ] L2R)
    {C : L2R →L[ℂ] L2R} (hCsa : ContinuousLinearMap.adjoint C = C)
    (hC : ∀ x, ‖C x‖ ≤ ‖x‖) : hsNormSq b (T ∘L C) ≤ hsNormSq b T := by
  rw [hsNormSq_adjoint b b (T ∘L C), ContinuousLinearMap.adjoint_comp, hCsa,
    hsNormSq_adjoint b b T]
  exact hsNormSq_comp_left_le b _ hC

/-- The larger space cut-off absorbs the smaller one, on either side. -/
theorem Pcut_comp_Pcut_of_le' {a a' : ℝ} (h : a ≤ a') : Pcut a' ∘L Pcut a = Pcut a := by
  have hmul : Pcut a ∘L Pcut a' = Pcut a := Pcut_comp_Pcut_of_le h
  have hsa : ContinuousLinearMap.adjoint (Pcut a ∘L Pcut a')
      = ContinuousLinearMap.adjoint (Pcut a) := by rw [hmul]
  rw [ContinuousLinearMap.adjoint_comp, adjoint_Pcut, adjoint_Pcut] at hsa
  exact hsa

/-- `B_Λ = P̂^{(Λ)} P^{(Λ)}` is obtained from `B_{Λ'}`, `Λ ≤ Λ'`, by compressing with the
two cut-offs at the smaller scale. -/
theorem soninHalfCut_factor {a a' : ℝ} (h : a ≤ a') :
    PcutHat a ∘L Pcut a = PcutHat a ∘L ((PcutHat a' ∘L Pcut a') ∘L Pcut a) := by
  rw [← ContinuousLinearMap.comp_assoc, ← ContinuousLinearMap.comp_assoc,
    PcutHat_comp_PcutHat_of_le h, ContinuousLinearMap.comp_assoc,
    Pcut_comp_Pcut_of_le' h]

/-- **The Hilbert–Schmidt norm of `B_Λ` grows with the cut-off scale.** -/
theorem hsNormSq_PcutHat_comp_Pcut_mono (b : HilbertBasis ι ℂ L2R) {a a' : ℝ} (h : a ≤ a') :
    hsNormSq b (PcutHat a ∘L Pcut a) ≤ hsNormSq b (PcutHat a' ∘L Pcut a') := by
  rw [soninHalfCut_factor h]
  refine le_trans (hsNormSq_comp_left_le b _ (norm_PcutHat_apply_le a)) ?_
  exact hsNormSq_comp_right_le b _ (adjoint_Pcut a) (norm_Pcut_apply_le a)

theorem toReal_hsNormSq (b : HilbertBasis ι ℂ L2R) (T : L2R →L[ℂ] L2R) :
    (hsNormSq b T).toReal = ∑' i, ‖T (b i)‖ ^ 2 := by
  rw [hsNormSq, ENNReal.tsum_toReal_eq (fun i => by finiteness)]
  refine tsum_congr fun i => ?_
  rw [← ENNReal.coe_pow, ENNReal.coe_toReal]
  push_cast
  ring

/-- `κ_Λ(1) = ‖B_Λ‖²_{HS}`, in the `ℝ≥0∞`-valued notation of the Hilbert–Schmidt norm. -/
theorem re_traceDensityCut_one_eq_toReal (b : HilbertBasis ι ℂ L2R) (cut : ℝ) :
    (traceDensityCut U b cut 1).re = (hsNormSq b (PcutHat cut ∘L Pcut cut)).toReal := by
  rw [re_traceDensityCut_one, ← toReal_hsNormSq b (soninHalfCut cut), soninHalfCut,
    ← hsNormSq_adjoint b b (PcutHat cut ∘L Pcut cut)]

/-- **The divergent quantity is monotone in the cut-off scale**: `κ_Λ(1) = Tr(S^{(Λ)})`
increases with `Λ`.  Combined with `tendsto_traceAlongRe_soninSandwichCut_atTop` this says
that the trace of the cut-off sandwich increases to `+∞`. -/
theorem re_traceDensityCut_one_mono (b : HilbertBasis ι ℂ L2R) {a a' : ℝ} (h : a ≤ a') :
    (traceDensityCut U b a 1).re ≤ (traceDensityCut U b a' 1).re := by
  rw [re_traceDensityCut_one_eq_toReal, re_traceDensityCut_one_eq_toReal]
  exact (ENNReal.toReal_le_toReal (isHilbertSchmidt_PcutHat_comp_Pcut a b)
    (isHilbertSchmidt_PcutHat_comp_Pcut a' b)).mpr (hsNormSq_PcutHat_comp_Pcut_mono b h)

/-! ## Test functions with no counter-term -/

/-- For a test function vanishing at `1` the logarithmic counter-term is absent, so the
renormalized trace is simply the limit of the cut-off traces.  Every test function differs
from such a one by a multiple of a fixed test function with value `1` at `1`, so the whole
analytic problem is concentrated at the unit. -/
theorem hasRenormalizedTrace_iff_tendsto_cutTrace (b : HilbertBasis ι ℂ L2R)
    (g : C_c(Rplus, ℂ)) (hg : g 1 = 0) (z : ℂ) :
    HasRenormalizedTrace b U g z ↔
      Tendsto (fun cut : ℝ => cutTrace b U cut g) atTop (𝓝 z) := by
  unfold HasRenormalizedTrace regularizedCutTrace logCounterTerm
  simp [hg]

end ConnesConsani.WeilPositivity
