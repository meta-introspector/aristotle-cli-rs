/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

A Hilbert–Schmidt criterion for operators on an `L²` space given by a kernel, continuing
the trace-class groundwork of `RequestProject/TraceClass.lean` needed for the operator side
of arXiv:2006.13771 (Connes–Consani, *Weil positivity and Trace formula – the archimedean
place*).

If an operator `T` on `L²(μ)` is given by a measurable kernel `K`, i.e.

  `(T ξ)(x) = ∫ K x y * ξ y ∂μ = ⟪k x, ξ⟫`  with  `k x = conj (K x ·)`,

then its Hilbert–Schmidt norm is at most the `L²`-norm of the kernel:

  `∑ᵢ ‖T bᵢ‖² ≤ ∫⁻ x, ‖k x‖² ∂μ`.

The proof is the classical one — Bessel's inequality in the variable `y` followed by
integration in `x` — organised so that no countability assumption on the index set of the
Hilbert basis is needed: the sum defining the Hilbert–Schmidt norm is the supremum of its
finite partial sums, and each partial sum is handled by `lintegral_finset_sum`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.TraceClass

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open scoped ENNReal NNReal

open MeasureTheory

namespace ConnesConsani.WeilPositivity

variable {α : Type*} [MeasurableSpace α] {μ : Measure α} {ι : Type*}

/-- The square of the `L²`-norm as a lower Lebesgue integral. -/
theorem enorm_sq_eq_lintegral (g : Lp ℂ 2 μ) :
    ‖g‖ₑ ^ 2 = ∫⁻ x, ‖(g : α → ℂ) x‖ₑ ^ 2 ∂μ := by
  rw [Lp.enorm_def, MeasureTheory.eLpNorm_eq_lintegral_rpow_enorm_toReal (by simp) (by simp)]
  simp only [ENNReal.toReal_ofNat, one_div]
  rw [← ENNReal.rpow_natCast _ 2, ← ENNReal.rpow_mul]
  norm_num

/-- Bessel's inequality for a finite partial sum, in `ℝ≥0∞`. -/
theorem finset_sum_enorm_sq_inner_le (b : HilbertBasis ι ℂ (Lp ℂ 2 μ)) (x : Lp ℂ 2 μ)
    (s : Finset ι) :
    ∑ i ∈ s, ‖inner ℂ x (b i)‖ₑ ^ 2 ≤ ‖x‖ₑ ^ 2 := by
  have hsymm : ∀ i : ι, ‖inner ℂ x (b i)‖ₑ ^ 2 = ‖inner ℂ (b i) x‖ₑ ^ 2 := by
    intro i
    rw [show ‖(inner ℂ x (b i) : ℂ)‖ₑ = ‖(inner ℂ (b i) x : ℂ)‖ₑ from by
      simp only [enorm_eq_nnnorm]
      exact congrArg _ (NNReal.coe_injective (by
        simpa using norm_inner_symm (𝕜 := ℂ) x (b i)))]
  simp only [hsymm]
  have hle : ∑ i ∈ s, ‖inner ℂ (b i) x‖ₑ ^ 2 ≤ ∑' i, ‖inner ℂ (b i) x‖ₑ ^ 2 :=
    ENNReal.sum_le_tsum s
  refine hle.trans ?_
  have := tsum_enorm_sq_inner b x
  simp only [enorm_eq_nnnorm]
  exact le_of_eq this

/-- **The Hilbert–Schmidt bound for an operator with a kernel.**  If `T ξ` is almost
everywhere given by the inner products `x ↦ ⟪k x, ξ⟫` of `ξ` with a family `k` of vectors,
then the Hilbert–Schmidt norm of `T` is at most the `L²`-norm of the family. -/
theorem hsNormSq_le_of_kernel (b : HilbertBasis ι ℂ (Lp ℂ 2 μ)) (T : Lp ℂ 2 μ →L[ℂ] Lp ℂ 2 μ)
    (k : α → Lp ℂ 2 μ)
    (hk : ∀ xi : Lp ℂ 2 μ, (T xi : α → ℂ) =ᵐ[μ] fun x => inner ℂ (k x) xi) :
    hsNormSq b T ≤ ∫⁻ x, ‖k x‖ₑ ^ 2 ∂μ := by
  have hterm : ∀ i : ι, ‖T (b i)‖ₑ ^ 2 = ∫⁻ x, ‖inner ℂ (k x) (b i)‖ₑ ^ 2 ∂μ := by
    intro i
    rw [enorm_sq_eq_lintegral]
    exact lintegral_congr_ae ((hk (b i)).mono fun x hx => by dsimp only; rw [hx])
  have hsq : hsNormSq b T = ∑' i, ‖T (b i)‖ₑ ^ 2 := by
    simp [hsNormSq, enorm_eq_nnnorm]
  rw [hsq, ENNReal.tsum_eq_iSup_sum]
  refine iSup_le fun s => ?_
  calc ∑ i ∈ s, ‖T (b i)‖ₑ ^ 2
      = ∑ i ∈ s, ∫⁻ x, ‖inner ℂ (k x) (b i)‖ₑ ^ 2 ∂μ := by
        exact Finset.sum_congr rfl fun i _ => hterm i
    _ = ∫⁻ x, ∑ i ∈ s, ‖inner ℂ (k x) (b i)‖ₑ ^ 2 ∂μ := by
        rw [lintegral_finset_sum']
        intro i _
        refine AEMeasurable.pow_const ?_ 2
        refine (AEStronglyMeasurable.enorm ?_)
        exact ((Lp.aestronglyMeasurable (T (b i))).congr (hk (b i)))
    _ ≤ ∫⁻ x, ‖k x‖ₑ ^ 2 ∂μ :=
        lintegral_mono fun x => finset_sum_enorm_sq_inner_le b (k x) s

end ConnesConsani.WeilPositivity
