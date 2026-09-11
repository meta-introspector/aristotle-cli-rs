/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**The Hilbert–Schmidt pairing of two kernel operators**, for arXiv:2006.13771
(Connes–Consani, *Weil positivity and Trace formula – the archimedean place*).

`RequestProject/HilbertSchmidtKernel.lean` and `RequestProject/DiagonalExact.lean` compute
the Hilbert–Schmidt *norm* of an operator presented by a kernel,
`(T ξ)(x) = ⟪k x, ξ⟫`, as the `L²` mass `∫ ‖k x‖² dx` of the kernel family.  This file
proves the sesquilinear companion, which is what turns a trace into an explicit integral:

  `⟪A, C⟫_HS = ∫ ⟪k_C x, k_A x⟫ dx`   (`hsInner_eq_integral_of_kernel`).

The proof is the classical one: the pairing is expanded in the basis, the sum and the
integral are interchanged (legitimately, because the series is dominated by
`(‖k_A x‖² + ‖k_C x‖²)/2`, of finite integral), and the resulting sum over the basis is
Parseval's identity `∑ᵢ ⟪u, eᵢ⟫⟪eᵢ, v⟫ = ⟪u, v⟫`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.DiagonalExact

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory

open scoped ENNReal NNReal

namespace ConnesConsani.WeilPositivity

/-- Parseval's identity in `ℝ≥0∞`, with the vector in the first slot. -/
theorem tsum_enorm_sq_inner_left {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]
    [CompleteSpace E] {ι : Type*} (b : HilbertBasis ι ℂ E) (x : E) :
    ∑' i, ‖inner ℂ x (b i)‖ₑ ^ 2 = ‖x‖ₑ ^ 2 := by
  have hsymm : ∀ i : ι, ‖inner ℂ x (b i)‖ₑ ^ 2 = ‖inner ℂ (b i) x‖ₑ ^ 2 := by
    intro i
    congr 1
    simp only [enorm_eq_nnnorm]
    exact congrArg _ (NNReal.coe_injective (by simpa using norm_inner_symm (𝕜 := ℂ) x (b i)))
  calc ∑' i, ‖inner ℂ x (b i)‖ₑ ^ 2 = ∑' i, ‖inner ℂ (b i) x‖ₑ ^ 2 := tsum_congr hsymm
    _ = ‖x‖ₑ ^ 2 := by simpa [enorm_eq_nnnorm] using tsum_enorm_sq_inner b x

variable {α : Type*} [MeasurableSpace α] {μ : Measure α} {ι : Type*}

/-- The pointwise bound `|z w| ≤ (|z|² + |w|²)/2` in `ℝ≥0∞`. -/
theorem enorm_mul_le_half_add_sq (z w : ℂ) :
    ‖z * w‖ₑ ≤ ‖z‖ₑ ^ 2 * 2⁻¹ + ‖w‖ₑ ^ 2 * 2⁻¹ := by
  have hreal : ‖z * w‖ ≤ ‖z‖ ^ 2 / 2 + ‖w‖ ^ 2 / 2 := by
    rw [norm_mul]
    nlinarith [sq_nonneg (‖z‖ - ‖w‖), norm_nonneg z, norm_nonneg w]
  have key : ∀ y : ℂ, ENNReal.ofReal (‖y‖ ^ 2 / 2) = ‖y‖ₑ ^ 2 * 2⁻¹ := by
    intro y
    have h1 : ENNReal.ofReal (‖y‖ ^ 2) = ‖y‖ₑ ^ 2 := by
      rw [ENNReal.ofReal_pow (norm_nonneg y), ofReal_norm_eq_enorm]
    have h2 : ENNReal.ofReal ((2:ℝ)⁻¹) = (2:ℝ≥0∞)⁻¹ := by
      rw [ENNReal.ofReal_inv_of_pos (by norm_num : (0:ℝ) < 2)]
      norm_num
    rw [div_eq_mul_inv, ENNReal.ofReal_mul (by positivity), h1, h2]
  calc ‖z * w‖ₑ ≤ ENNReal.ofReal (‖z‖ ^ 2 / 2 + ‖w‖ ^ 2 / 2) := by
        rw [← ofReal_norm_eq_enorm]
        exact ENNReal.ofReal_le_ofReal hreal
    _ = ‖z‖ₑ ^ 2 * 2⁻¹ + ‖w‖ₑ ^ 2 * 2⁻¹ := by
        rw [ENNReal.ofReal_add (by positivity) (by positivity), key, key]

/-- The `L²` mass of a kernel family, summed against a Hilbert basis. -/
theorem tsum_lintegral_enorm_sq_inner [Countable ι] (b : HilbertBasis ι ℂ (Lp ℂ 2 μ))
    (k : α → Lp ℂ 2 μ) (hmeas : ∀ i : ι, AEStronglyMeasurable (fun x => inner ℂ (k x) (b i)) μ) :
    ∑' i, ∫⁻ x, ‖inner ℂ (k x) (b i)‖ₑ ^ 2 * 2⁻¹ ∂μ = (∫⁻ x, ‖k x‖ₑ ^ 2 ∂μ) * 2⁻¹ := by
  have hm : ∀ i : ι, AEMeasurable (fun x => ‖inner ℂ (k x) (b i)‖ₑ ^ 2) μ :=
    fun i => ((hmeas i).enorm).pow_const 2
  calc ∑' i, ∫⁻ x, ‖inner ℂ (k x) (b i)‖ₑ ^ 2 * 2⁻¹ ∂μ
      = ∑' i, (∫⁻ x, ‖inner ℂ (k x) (b i)‖ₑ ^ 2 ∂μ) * 2⁻¹ := by
        refine tsum_congr fun i => ?_
        rw [lintegral_mul_const' _ _ (by simp)]
    _ = (∑' i, ∫⁻ x, ‖inner ℂ (k x) (b i)‖ₑ ^ 2 ∂μ) * 2⁻¹ := ENNReal.tsum_mul_right
    _ = (∫⁻ x, ∑' i, ‖inner ℂ (k x) (b i)‖ₑ ^ 2 ∂μ) * 2⁻¹ := by rw [lintegral_tsum hm]
    _ = (∫⁻ x, ‖k x‖ₑ ^ 2 ∂μ) * 2⁻¹ := by
        rw [lintegral_congr fun x => tsum_enorm_sq_inner_left b (k x)]

/-- **The Hilbert–Schmidt pairing of two operators presented by kernels.**

If `(A ξ)(x) = ⟪k_A x, ξ⟫` and `(C ξ)(x) = ⟪k_C x, ξ⟫` almost everywhere, and the two
kernel families have finite `L²` mass, then the Hilbert–Schmidt pairing of `A` and `C` is
the integral of the pointwise pairing of the kernels. -/
theorem hsInner_eq_integral_of_kernel [Countable ι] (b : HilbertBasis ι ℂ (Lp ℂ 2 μ))
    (A C : Lp ℂ 2 μ →L[ℂ] Lp ℂ 2 μ) (kA kC : α → Lp ℂ 2 μ)
    (hA : ∀ xi : Lp ℂ 2 μ, (A xi : α → ℂ) =ᵐ[μ] fun x => inner ℂ (kA x) xi)
    (hC : ∀ xi : Lp ℂ 2 μ, (C xi : α → ℂ) =ᵐ[μ] fun x => inner ℂ (kC x) xi)
    (hfinA : ∫⁻ x, ‖kA x‖ₑ ^ 2 ∂μ ≠ ⊤) (hfinC : ∫⁻ x, ‖kC x‖ₑ ^ 2 ∂μ ≠ ⊤) :
    hsInner b A C = ∫ x, inner ℂ (kC x) (kA x) ∂μ := by
  classical
  set f : ι → α → ℂ := fun i x => (starRingEnd ℂ) (inner ℂ (kA x) (b i)) * inner ℂ (kC x) (b i)
    with hf
  have hmeasA : ∀ i : ι, AEStronglyMeasurable (fun x => inner ℂ (kA x) (b i)) μ :=
    fun i => (Lp.aestronglyMeasurable (A (b i))).congr (hA (b i))
  have hmeasC : ∀ i : ι, AEStronglyMeasurable (fun x => inner ℂ (kC x) (b i)) μ :=
    fun i => (Lp.aestronglyMeasurable (C (b i))).congr (hC (b i))
  have hmeasf : ∀ i : ι, AEStronglyMeasurable (f i) μ :=
    fun i => ((hmeasA i).star).mul (hmeasC i)
  have hterm : ∀ i : ι, inner ℂ (A (b i)) (C (b i)) = ∫ x, f i x ∂μ := by
    intro i
    rw [L2.inner_def]
    refine integral_congr_ae ?_
    filter_upwards [hA (b i), hC (b i)] with x h1 h2
    rw [RCLike.inner_apply, h1, h2]
    simp only [hf]
    ring
  have hdom : ∑' i, ∫⁻ x, ‖f i x‖ₑ ∂μ ≠ ⊤ := by
    have hbound : ∑' i, ∫⁻ x, ‖f i x‖ₑ ∂μ
        ≤ ∑' i, (∫⁻ x, ‖inner ℂ (kA x) (b i)‖ₑ ^ 2 * 2⁻¹ ∂μ
            + ∫⁻ x, ‖inner ℂ (kC x) (b i)‖ₑ ^ 2 * 2⁻¹ ∂μ) := by
      refine ENNReal.tsum_le_tsum fun i => ?_
      rw [← lintegral_add_left' (((hmeasA i).enorm.pow_const 2).mul_const _)]
      refine lintegral_mono fun x => ?_
      have hcj : ‖(starRingEnd ℂ) (inner ℂ (kA x) (b i))‖ₑ = ‖inner ℂ (kA x) (b i)‖ₑ := by
        rw [← ofReal_norm_eq_enorm, ← ofReal_norm_eq_enorm, RCLike.norm_conj]
      calc ‖f i x‖ₑ
          = ‖(starRingEnd ℂ) (inner ℂ (kA x) (b i)) * inner ℂ (kC x) (b i)‖ₑ := rfl
        _ ≤ ‖(starRingEnd ℂ) (inner ℂ (kA x) (b i))‖ₑ ^ 2 * 2⁻¹
              + ‖inner ℂ (kC x) (b i)‖ₑ ^ 2 * 2⁻¹ := enorm_mul_le_half_add_sq _ _
        _ = ‖inner ℂ (kA x) (b i)‖ₑ ^ 2 * 2⁻¹ + ‖inner ℂ (kC x) (b i)‖ₑ ^ 2 * 2⁻¹ := by
            rw [hcj]
    have heq : ∑' i, (∫⁻ x, ‖inner ℂ (kA x) (b i)‖ₑ ^ 2 * 2⁻¹ ∂μ
          + ∫⁻ x, ‖inner ℂ (kC x) (b i)‖ₑ ^ 2 * 2⁻¹ ∂μ)
        = (∫⁻ x, ‖kA x‖ₑ ^ 2 ∂μ) * 2⁻¹ + (∫⁻ x, ‖kC x‖ₑ ^ 2 ∂μ) * 2⁻¹ := by
      rw [ENNReal.tsum_add, tsum_lintegral_enorm_sq_inner b kA hmeasA,
        tsum_lintegral_enorm_sq_inner b kC hmeasC]
    refine ne_top_of_le_ne_top ?_ (hbound.trans (le_of_eq heq))
    exact ENNReal.add_ne_top.2 ⟨ENNReal.mul_ne_top hfinA (by simp),
      ENNReal.mul_ne_top hfinC (by simp)⟩
  have hpt : ∀ x : α, ∑' i, f i x = inner ℂ (kC x) (kA x) := by
    intro x
    have := b.tsum_inner_mul_inner (kC x) (kA x)
    rw [← this]
    refine tsum_congr fun i => ?_
    rw [hf]
    simp only
    rw [mul_comm]
    congr 1
    exact (inner_conj_symm (𝕜 := ℂ) (b i) (kA x))
  calc hsInner b A C = ∑' i, ∫ x, f i x ∂μ := tsum_congr hterm
    _ = ∫ x, ∑' i, f i x ∂μ := (integral_tsum hmeasf hdom).symm
    _ = ∫ x, inner ℂ (kC x) (kA x) ∂μ := by rw [funext hpt]

end ConnesConsani.WeilPositivity
