/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**The exact diagonal density: `d(Λ) = 4Λ²`.**

`RequestProject/DiagonalQuadraticGrowth.lean` proves the two-sided bound
`(8/π²)Λ² − 4/π² ≤ d(Λ) ≤ 4Λ²` for the diagonal value

  `d(Λ) = κ_Λ(1) = Tr(S^{(Λ)}) = ‖B_Λ‖²_{HS}`,  `B_Λ = P̂^{(Λ)} P^{(Λ)}`,

of the semi-local kernel, and deduces that the hypothesis `DiagLogUpperBound` is false.
Here the upper bound is upgraded to an **equality**, so the phase-space heuristic is
confirmed exactly: the trace of the cut-off Sonin sandwich is the area of the box
`[-Λ,Λ] × [-Λ,Λ]`.

The mechanism is the equality case of the Hilbert–Schmidt kernel bound of
`RequestProject/HilbertSchmidtKernel.lean`.  For an operator presented by a kernel,
`(T ξ)(x) = ⟪k x, ξ⟫`, Bessel's inequality in the `y` variable is in fact Parseval's
identity, so the inequality `‖T‖²_{HS} ≤ ∫ ‖k x‖² dx` is an equality as soon as the index
set of the Hilbert basis is countable (which is automatic on the separable space `L²(ℝ)`):

* `hsNormSq_eq_of_kernel` — `‖T‖²_{HS} = ∫⁻ x, ‖k x‖²`;
* `enorm_cutoffKernelVecOn_sq` — the kernel vector of `1_s 𝓕 1_s` at `x ∈ s` is the
  character `1_s(v) e^{-2πixv}`, of squared `L²` mass `|s|`;
* `hsNormSq_cutFourierCutOn_eq` — hence `‖1_s 𝓕 1_s‖²_{HS} = |s|²`;
* `hsNormSq_PcutHat_comp_Pcut_eq`, `diagDensity_eq_four_mul_sq` — hence
  `‖B_Λ‖²_{HS} = |[-Λ,Λ]|² = 4Λ²`, i.e. `d(Λ) = 4Λ²`.

Two immediate consequences are recorded: `tendsto_diagDensity_div_sq`, the exact growth
rate `d(Λ)/Λ² → 4`, and `not_isBigO_diagDensity_log`, the quantitative failure of any
logarithmic bound (`d(Λ)` is not `O(log Λ)`).
-/
import RequestProject.Imported.OutputFinal.RequestProject.DiagonalQuadraticGrowth

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory Real Set FourierTransform Filter Topology ContinuousLinearMap

open scoped ENNReal NNReal CompactlySupported

namespace ConnesConsani.WeilPositivity

/-! ## 1. The equality case of the Hilbert–Schmidt kernel bound -/

section KernelEquality

variable {α : Type*} [MeasurableSpace α] {μ : Measure α} {ι : Type*}

/-- **The Hilbert–Schmidt norm of an operator given by a kernel**, as an equality.  This is
the equality case of `hsNormSq_le_of_kernel`: Bessel's inequality used there is Parseval's
identity, and the interchange of the sum and the integral is legitimate for a countable
index set. -/
theorem hsNormSq_eq_of_kernel [Countable ι] (b : HilbertBasis ι ℂ (Lp ℂ 2 μ))
    (T : Lp ℂ 2 μ →L[ℂ] Lp ℂ 2 μ) (k : α → Lp ℂ 2 μ)
    (hk : ∀ xi : Lp ℂ 2 μ, (T xi : α → ℂ) =ᵐ[μ] fun x => inner ℂ (k x) xi) :
    hsNormSq b T = ∫⁻ x, ‖k x‖ₑ ^ 2 ∂μ := by
  have hmeas : ∀ i : ι, AEMeasurable (fun x => ‖inner ℂ (k x) (b i)‖ₑ ^ 2) μ := by
    intro i
    refine AEMeasurable.pow_const ?_ 2
    exact (AEStronglyMeasurable.enorm ((Lp.aestronglyMeasurable (T (b i))).congr (hk (b i))))
  have hterm : ∀ i : ι, ‖T (b i)‖ₑ ^ 2 = ∫⁻ x, ‖inner ℂ (k x) (b i)‖ₑ ^ 2 ∂μ := by
    intro i
    rw [enorm_sq_eq_lintegral]
    exact lintegral_congr_ae ((hk (b i)).mono fun x hx => by dsimp only; rw [hx])
  have hsq : hsNormSq b T = ∑' i, ‖T (b i)‖ₑ ^ 2 := by
    simp [hsNormSq, enorm_eq_nnnorm]
  rw [hsq]
  calc ∑' i, ‖T (b i)‖ₑ ^ 2
      = ∑' i, ∫⁻ x, ‖inner ℂ (k x) (b i)‖ₑ ^ 2 ∂μ := tsum_congr hterm
    _ = ∫⁻ x, ∑' i, ‖inner ℂ (k x) (b i)‖ₑ ^ 2 ∂μ := (lintegral_tsum hmeas).symm
    _ = ∫⁻ x, ‖k x‖ₑ ^ 2 ∂μ := by
        refine lintegral_congr fun x => ?_
        have hsymm : ∀ i : ι, ‖inner ℂ (k x) (b i)‖ₑ ^ 2 = ‖inner ℂ (b i) (k x)‖ₑ ^ 2 := by
          intro i
          congr 1
          simp only [enorm_eq_nnnorm]
          exact congrArg _ (NNReal.coe_injective (by
            simpa using norm_inner_symm (𝕜 := ℂ) (k x) (b i)))
        calc ∑' i, ‖inner ℂ (k x) (b i)‖ₑ ^ 2
            = ∑' i, ‖inner ℂ (b i) (k x)‖ₑ ^ 2 := tsum_congr hsymm
          _ = ‖k x‖ₑ ^ 2 := by
              simpa [enorm_eq_nnnorm] using tsum_enorm_sq_inner b (k x)

end KernelEquality

/-! ## 2. The kernel vectors of `1_s 𝓕 1_s` -/

/-- **The squared `L²` mass of the kernel vector** of `1_s 𝓕 1_s` at the point `x`: it is
`|s|` for `x ∈ s` and `0` otherwise, the kernel being a unimodular character cut off by
`s`. -/
theorem enorm_cutoffKernelVecOn_sq {s : Set ℝ} (hs : MeasurableSet s) (hfin : volume s ≠ ⊤)
    (x : ℝ) :
    ‖cutoffKernelVecOn hs hfin x‖ₑ ^ 2 = s.indicator (fun _ => volume s) x := by
  classical
  by_cases hx : x ∈ s
  · rw [Set.indicator_of_mem hx]
    simp only [cutoffKernelVecOn, if_pos hx]
    have hae : ((memLp_indicator_unitChar_set hs hfin x).toLp _ : ℝ → ℂ)
        =ᵐ[volume] s.indicator (unitChar x) := MemLp.coeFn_toLp _
    rw [enorm_sq_eq_lintegral, lintegral_congr_ae (hae.mono fun v hv => by rw [hv])]
    have hpt : ∀ v, ‖s.indicator (unitChar x) v‖ₑ ^ 2
        = s.indicator (fun _ => (1 : ℝ≥0∞)) v := by
      intro v
      by_cases hv : v ∈ s <;> simp [hv, norm_unitChar, ← enorm_norm (unitChar x v)]
    rw [lintegral_congr hpt, lintegral_indicator_const hs, one_mul]
  · rw [Set.indicator_of_notMem hx]
    simp only [cutoffKernelVecOn, if_neg hx]
    simp

/-- **The exact Hilbert–Schmidt norm of the doubly cut Fourier transform**:
`‖1_s 𝓕 1_s‖²_{HS} = |s|²`.  This sharpens `hsNormSq_cutFourierCutOn_le`. -/
theorem hsNormSq_cutFourierCutOn_eq {ι : Type*} [Countable ι] {s : Set ℝ}
    (hs : MeasurableSet s) (hfin : volume s ≠ ⊤) (b : HilbertBasis ι ℂ L2R) :
    hsNormSq b (cutoff hs ∘L fourierCLM ∘L cutoff hs) = volume s * volume s := by
  rw [hsNormSq_eq_of_kernel b (cutoff hs ∘L fourierCLM ∘L cutoff hs)
    (cutoffKernelVecOn hs hfin) (coeFn_cutFourierCutOn hs hfin)]
  rw [lintegral_congr (enorm_cutoffKernelVecOn_sq hs hfin), lintegral_indicator_const hs]

/-- **`‖B_Λ‖²_{HS} = |[-Λ,Λ]|²`.** -/
theorem hsNormSq_PcutHat_comp_Pcut_eq {ι : Type*} [Countable ι] (b : HilbertBasis ι ℂ L2R)
    (cut : ℝ) :
    hsNormSq b (PcutHat cut ∘L Pcut cut)
      = volume (cutoffSet cut) * volume (cutoffSet cut) := by
  have hcomp : PcutHat cut ∘L Pcut cut
      = (fourierL2.symm.toContinuousLinearEquiv : L2R →L[ℂ] L2R) ∘L
        (Pcut cut ∘L fourierCLM ∘L Pcut cut) := by
    ext xi
    simp [PcutHat, Pcut, fourierConj_apply, fourierCLM]
  rw [hcomp, hsNormSq_isometry_comp b fourierL2.symm]
  exact hsNormSq_cutFourierCutOn_eq _ (volume_cutoffSet_ne_top cut) b

/-! ## 3. The diagonal density -/

variable {ι : Type*} (U : L2Rplus ≃ₗᵢ[ℂ] L2R)

/-- **The diagonal density is exactly the phase-space area**: `d(Λ) = 4Λ²`.

This is the equality behind the two-sided bound of
`RequestProject/DiagonalQuadraticGrowth.lean`: the trace of the cut-off Sonin sandwich
`S^{(Λ)} = P^{(Λ)} P̂^{(Λ)} P^{(Λ)}` is the area `4Λ²` of the box `[-Λ,Λ] × [-Λ,Λ]`. -/
theorem diagDensity_eq_four_mul_sq [Countable ι] (b : HilbertBasis ι ℂ L2R) {cut : ℝ}
    (hcut : 0 ≤ cut) :
    diagDensity U b cut = 4 * cut ^ 2 := by
  have hvol : volume (cutoffSet cut) = ENNReal.ofReal (2 * cut) := by
    rw [cutoffSet, Real.volume_Icc]; ring_nf
  rw [diagDensity, re_traceDensityCut_one_eq_toReal, hsNormSq_PcutHat_comp_Pcut_eq b cut, hvol,
    ← ENNReal.ofReal_mul (by positivity), ENNReal.toReal_ofReal (by positivity)]
  ring

/-- The trace of the cut-off Sonin sandwich, `Tr(S^{(Λ)}) = 4Λ²`. -/
theorem traceAlongRe_soninSandwichCut_eq [Countable ι] (U : L2Rplus ≃ₗᵢ[ℂ] L2R)
    (b : HilbertBasis ι ℂ L2R) {cut : ℝ} (hcut : 0 ≤ cut) :
    traceAlongRe b (soninSandwichCut cut) = 4 * cut ^ 2 := by
  rw [← diagDensity_eq_traceAlongRe U b cut]
  exact diagDensity_eq_four_mul_sq U b hcut

/-! ## 4. Consequences -/

/-- **The exact growth rate**: `d(Λ)/Λ² → 4` as `Λ → ∞`. -/
theorem tendsto_diagDensity_div_sq [Countable ι] (b : HilbertBasis ι ℂ L2R) :
    Tendsto (fun cut : ℝ => diagDensity U b cut / cut ^ 2) atTop (𝓝 4) := by
  refine Tendsto.congr' ?_ tendsto_const_nhds
  filter_upwards [eventually_gt_atTop (0 : ℝ)] with cut hcut
  rw [diagDensity_eq_four_mul_sq U b hcut.le, mul_div_assoc, div_self (by positivity), mul_one]

/-- **No logarithmic bound is possible**, in the strongest form: `d(Λ)` is not `O(log Λ)`.
This strengthens `not_hasDiagLogUpperBound`, which only rules out the bound
`d(Λ) ≤ 2 log Λ + C`. -/
theorem not_isBigO_diagDensity_log [Countable ι] (b : HilbertBasis ι ℂ L2R) :
    ¬ (fun cut : ℝ => diagDensity U b cut) =O[atTop] fun cut : ℝ => Real.log cut := by
  intro hO
  obtain ⟨C, hC⟩ := hO.isBigOWith
  rw [Asymptotics.isBigOWith_iff] at hC
  have hev : ∀ᶠ cut : ℝ in atTop, False := by
    filter_upwards [hC, eventually_ge_atTop (1 : ℝ), eventually_ge_atTop (|C| + 1)] with
      cut hbound hcut1 hcutC
    have hcut0 : (0 : ℝ) < cut := lt_of_lt_of_le zero_lt_one hcut1
    rw [diagDensity_eq_four_mul_sq U b hcut0.le] at hbound
    have hlognn : 0 ≤ Real.log cut := Real.log_nonneg hcut1
    have hlogle : Real.log cut ≤ cut := (Real.log_le_sub_one_of_pos hcut0).trans (by linarith)
    have h3 : 4 * cut ^ 2 ≤ |C| * Real.log cut := by
      calc 4 * cut ^ 2 ≤ ‖4 * cut ^ 2‖ := le_abs_self _
        _ ≤ C * ‖Real.log cut‖ := hbound
        _ = C * Real.log cut := by
            rw [Real.norm_eq_abs (Real.log cut), abs_of_nonneg hlognn]
        _ ≤ |C| * Real.log cut :=
            mul_le_mul_of_nonneg_right (le_abs_self C) hlognn
    have habs : (0 : ℝ) ≤ |C| := abs_nonneg C
    nlinarith
  obtain ⟨_, h⟩ := hev.exists
  exact h

end ConnesConsani.WeilPositivity
