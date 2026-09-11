/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The cut-off family of `RequestProject/CutoffFamily.lean` **exhausts** `L²(ℝ)` as the scale
goes to infinity:

  `P^{(Λ)} ξ → ξ`,  `P̂^{(Λ)} ξ → ξ`,  `S^{(Λ)} ξ = P^{(Λ)} P̂^{(Λ)} P^{(Λ)} ξ → ξ`

in `L²(ℝ)`, for every `ξ`.  This is the precise sense in which the family "grows with `Λ`"
in the renormalization of the local trace formula of arXiv:2006.13771 (Connes–Consani,
*Weil positivity and Trace formula – the archimedean place*): the cut-off sandwich
converges strongly to the identity, so the trace `Tr(ϑ(f) S^{(Λ)})` is a regularization of
the (divergent) trace of `ϑ(f)`, and a counter-term is unavoidable.

The proof is the usual tail estimate: `‖ξ - P^{(Λ)} ξ‖²` is the mass of `‖ξ‖²` outside
`[-Λ, Λ]`, i.e. the value on `[-Λ,Λ]ᶜ` of the finite measure `‖ξ(x)‖² dx`, and these sets
decrease to the empty set.
-/
import RequestProject.Imported.OutputFinal.RequestProject.CutoffFamily

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory Filter Topology Set

open scoped ENNReal

namespace ConnesConsani.WeilPositivity

/-! ## The tail mass of an `L²` function -/

/-- The mass of `‖ξ‖²` outside the cut-off interval `[-Λ, Λ]`. -/
def tailMass (xi : L2R) (lam : ℝ) : ℝ≥0∞ :=
  ∫⁻ x in (cutoffSet lam)ᶜ, ‖(xi : ℝ → ℂ) x‖ₑ ^ (2 : ℝ)

theorem lintegral_enorm_sq_ne_top (xi : L2R) :
    (∫⁻ x, ‖(xi : ℝ → ℂ) x‖ₑ ^ (2 : ℝ) ∂volume) ≠ ⊤ := by
  have h := (Lp.memLp xi).eLpNorm_lt_top
  rw [eLpNorm_lt_top_iff_lintegral_rpow_enorm_lt_top (by norm_num) (by norm_num)] at h
  simpa using h.ne

theorem tailMass_eq_withDensity (xi : L2R) (lam : ℝ) :
    tailMass xi lam
      = (volume.withDensity fun x => ‖(xi : ℝ → ℂ) x‖ₑ ^ (2 : ℝ)) ((cutoffSet lam)ᶜ) :=
  (withDensity_apply _ (measurableSet_cutoffSet lam).compl).symm

/-- **The tail mass vanishes as the cut-off scale goes to infinity.** -/
theorem tendsto_tailMass (xi : L2R) : Tendsto (tailMass xi) atTop (𝓝 0) := by
  set nu := volume.withDensity (fun x => ‖(xi : ℝ → ℂ) x‖ₑ ^ (2 : ℝ)) with hnu
  have hanti : Antitone fun lam : ℝ => ((cutoffSet lam)ᶜ) := fun a b hab =>
    Set.compl_subset_compl.2 (cutoffSet_subset hab)
  have hmeas : ∀ lam : ℝ, NullMeasurableSet ((cutoffSet lam)ᶜ) nu := fun lam =>
    ((measurableSet_cutoffSet lam).compl).nullMeasurableSet
  have huniv : nu Set.univ ≠ ⊤ := by
    rw [hnu, withDensity_apply _ MeasurableSet.univ, Measure.restrict_univ]
    exact lintegral_enorm_sq_ne_top xi
  have hfin : ∃ lam : ℝ, nu ((cutoffSet lam)ᶜ) ≠ ⊤ :=
    ⟨0, ne_top_of_le_ne_top huniv (measure_mono (Set.subset_univ _))⟩
  have hInter : (⋂ lam : ℝ, ((cutoffSet lam)ᶜ)) = ∅ := by
    ext x
    simp only [Set.mem_iInter, Set.mem_compl_iff, Set.mem_empty_iff_false, iff_false, not_forall,
      not_not]
    exact ⟨|x|, by simpa [cutoffSet, abs_le] using ⟨neg_abs_le x, le_abs_self x⟩⟩
  have h := tendsto_measure_iInter_atTop (μ := nu) hmeas hanti hfin
  rw [hInter, measure_empty] at h
  exact h.congr fun lam => (tailMass_eq_withDensity xi lam).symm

/-! ## Strong convergence of the cut-offs to the identity -/

/-- The `L²` distance from `ξ` to its cut-off is the square root of the tail mass. -/
theorem norm_Pcut_sub_self (lam : ℝ) (xi : L2R) :
    ‖Pcut lam xi - xi‖ = Real.sqrt ((tailMass xi lam).toReal) := by
  have hae : ((Pcut lam xi - xi : L2R) : ℝ → ℂ)
      =ᵐ[volume] -(((cutoffSet lam)ᶜ).indicator ((xi : L2R) : ℝ → ℂ)) := by
    filter_upwards [Lp.coeFn_sub (Pcut lam xi) xi,
      coeFn_cutoff (measurableSet_cutoffSet lam) xi] with x h1 h2
    rw [h1]
    simp only [Pi.sub_apply, Pi.neg_apply]
    rw [show (Pcut lam xi : ℝ → ℂ) x = (cutoffSet lam).indicator ((xi : L2R) : ℝ → ℂ) x from h2]
    by_cases hx : x ∈ cutoffSet lam <;> simp [hx]
  rw [Lp.norm_def, eLpNorm_congr_ae hae, eLpNorm_neg,
    eLpNorm_indicator_eq_eLpNorm_restrict (measurableSet_cutoffSet lam).compl,
    eLpNorm_eq_lintegral_rpow_enorm_toReal (by norm_num) (by norm_num), Real.sqrt_eq_rpow,
    ← ENNReal.toReal_rpow]
  norm_num [tailMass]

/-- **`P^{(Λ)} ξ → ξ`**: the cut-offs in space converge strongly to the identity. -/
theorem tendsto_Pcut_apply (xi : L2R) :
    Tendsto (fun lam : ℝ => Pcut lam xi) atTop (𝓝 xi) := by
  rw [tendsto_iff_norm_sub_tendsto_zero]
  have h1 : Tendsto (fun lam : ℝ => (tailMass xi lam).toReal) atTop (𝓝 0) := by
    simpa using (ENNReal.tendsto_toReal (a := 0) (by simp)).comp (tendsto_tailMass xi)
  have h2 : Tendsto (fun lam : ℝ => Real.sqrt ((tailMass xi lam).toReal)) atTop (𝓝 0) := by
    simpa using (Real.continuous_sqrt.tendsto 0).comp h1
  exact h2.congr fun lam => (norm_Pcut_sub_self lam xi).symm

/-- **`P̂^{(Λ)} ξ → ξ`**: the cut-offs in frequency converge strongly to the identity. -/
theorem tendsto_PcutHat_apply (xi : L2R) :
    Tendsto (fun lam : ℝ => PcutHat lam xi) atTop (𝓝 xi) := by
  rw [tendsto_iff_norm_sub_tendsto_zero]
  have hnorm : ∀ lam : ℝ, ‖PcutHat lam xi - xi‖ = ‖Pcut lam (fourierL2 xi) - fourierL2 xi‖ := by
    intro lam
    rw [PcutHat, fourierConj_apply,
      show fourierL2.symm (Pcut lam (fourierL2 xi)) - xi
        = fourierL2.symm (Pcut lam (fourierL2 xi) - fourierL2 xi) by
          rw [map_sub, LinearIsometryEquiv.symm_apply_apply],
      fourierL2.symm.norm_map]
  have h := (tendsto_iff_norm_sub_tendsto_zero.1 (tendsto_Pcut_apply (fourierL2 xi)))
  exact h.congr fun lam => (hnorm lam).symm

/-- **`S^{(Λ)} ξ → ξ`**: the renormalized Sonin sandwich converges strongly to the
identity. -/
theorem tendsto_soninSandwichCut_apply (xi : L2R) :
    Tendsto (fun lam : ℝ => soninSandwichCut lam xi) atTop (𝓝 xi) := by
  rw [tendsto_iff_norm_sub_tendsto_zero]
  have hbound : ∀ lam : ℝ, ‖soninSandwichCut lam xi - xi‖
      ≤ 2 * ‖Pcut lam xi - xi‖ + ‖PcutHat lam xi - xi‖ := by
    intro lam
    have e1 : soninSandwichCut lam xi = Pcut lam (PcutHat lam (Pcut lam xi)) := rfl
    have t1 : ‖Pcut lam (PcutHat lam (Pcut lam xi)) - Pcut lam (PcutHat lam xi)‖
        ≤ ‖Pcut lam xi - xi‖ := by
      rw [← map_sub, ← map_sub]
      exact (norm_Pcut_apply_le lam _).trans (norm_PcutHat_apply_le lam _)
    have t2 : ‖Pcut lam (PcutHat lam xi) - Pcut lam xi‖ ≤ ‖PcutHat lam xi - xi‖ := by
      rw [← map_sub]
      exact norm_Pcut_apply_le lam _
    calc ‖soninSandwichCut lam xi - xi‖
        = ‖(Pcut lam (PcutHat lam (Pcut lam xi)) - Pcut lam (PcutHat lam xi))
            + ((Pcut lam (PcutHat lam xi) - Pcut lam xi) + (Pcut lam xi - xi))‖ := by
          rw [e1]; congr 1; abel
      _ ≤ ‖Pcut lam (PcutHat lam (Pcut lam xi)) - Pcut lam (PcutHat lam xi)‖
            + (‖Pcut lam (PcutHat lam xi) - Pcut lam xi‖ + ‖Pcut lam xi - xi‖) :=
          (norm_add_le _ _).trans (by gcongr; exact norm_add_le _ _)
      _ ≤ ‖Pcut lam xi - xi‖ + (‖PcutHat lam xi - xi‖ + ‖Pcut lam xi - xi‖) := by
          gcongr
      _ = 2 * ‖Pcut lam xi - xi‖ + ‖PcutHat lam xi - xi‖ := by ring
  have hP := tendsto_iff_norm_sub_tendsto_zero.1 (tendsto_Pcut_apply xi)
  have hPh := tendsto_iff_norm_sub_tendsto_zero.1 (tendsto_PcutHat_apply xi)
  have hsum : Tendsto (fun lam : ℝ => 2 * ‖Pcut lam xi - xi‖ + ‖PcutHat lam xi - xi‖)
      atTop (𝓝 0) := by
    simpa using (hP.const_mul 2).add hPh
  exact squeeze_zero (fun lam => norm_nonneg _) hbound hsum

/-- **The diagonal matrix elements of `S^{(Λ)}` converge to `‖ξ‖²`.**  Equivalently, the
cut-off sandwich converges to `1` in the weak operator topology on each vector; this is the
source of the divergence of `Tr(S^{(Λ)})`, and hence of the necessity of a counter-term. -/
theorem tendsto_inner_soninSandwichCut (xi : L2R) :
    Tendsto (fun lam : ℝ => (inner ℂ xi (soninSandwichCut lam xi) : ℂ)) atTop
      (𝓝 ((‖xi‖ : ℂ) ^ 2)) := by
  have h := Filter.Tendsto.inner (𝕜 := ℂ)
    (tendsto_const_nhds (x := xi) (f := (atTop : Filter ℝ)))
    (tendsto_soninSandwichCut_apply xi)
  simpa [inner_self_eq_norm_sq_to_K] using h

end ConnesConsani.WeilPositivity
