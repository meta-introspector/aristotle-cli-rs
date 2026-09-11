/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Compatibility of the `L²` (Plancherel) Fourier transform with the Fourier integral, for the
operator side of arXiv:2006.13771 (Connes–Consani, *Weil positivity and Trace formula –
the archimedean place*).

The Fourier transform used in `RequestProject/Sonin.lean` to define the frequency cutoff
`P̂₁` is the `L²` one, `MeasureTheory.Lp.fourierTransformₗᵢ`, obtained by extending the
Fourier transform of Schwartz functions.  In order to compute with the operators built from
it — in particular to exhibit the Schwartz kernel of `P₁ 𝓕 P₁` — one needs to know that on
an `L²` function which is moreover integrable the `L²` transform is given by the usual
Fourier integral

  `𝓕 f (w) = ∫ e^{-2πi x w} f(x) dx`.

This is the content of `coeFn_fourierL2_of_integrable` below.  The proof is the classical
duality argument: for a real valued test function `φ`

  `∫ φ · 𝓕₂ f = ⟪φ, 𝓕₂ f⟫ = ⟪𝓕⁻φ, f⟫ = ∫ 𝓕φ · f = ∫ φ · 𝓕₁ f`,

the middle equality being unitarity of the `L²` transform (together with the fact that on
Schwartz functions it *is* the Fourier integral), and the last one the multiplication
formula `∫ 𝓕g · h = ∫ g · 𝓕h`.  Since a locally integrable function is determined by its
integrals against smooth compactly supported functions, the two transforms agree almost
everywhere.
-/
import RequestProject.Imported.OutputFinal.RequestProject.Sonin

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory SchwartzMap FourierTransform Real

open scoped RealInnerProductSpace

namespace ConnesConsani.WeilPositivity

/-! ## Two elementary identities for the Fourier character -/

/-- Complex conjugation turns the Fourier character into its inverse. -/
theorem conj_fourierChar (t : ℝ) :
    (starRingEnd ℂ) ((𝐞 t : Circle) : ℂ) = ((𝐞 (-t) : Circle) : ℂ) := by
  simp [Real.fourierChar_apply, ← Complex.exp_conj, Complex.conj_ofNat]

/-- For a *real valued* function the conjugate of the inverse Fourier integral is the
Fourier integral. -/
theorem conj_fourierInv_of_real {psi : ℝ → ℂ}
    (hre : ∀ x, (starRingEnd ℂ) (psi x) = psi x) (w : ℝ) :
    (starRingEnd ℂ) (𝓕⁻ psi w) = 𝓕 psi w := by
  rw [Real.fourierInv_eq, Real.fourier_eq, ← integral_conj]
  refine integral_congr_ae (.of_forall fun v => ?_)
  simp only [Circle.smul_def, smul_eq_mul, map_mul, hre, conj_fourierChar]

/-- **The multiplication formula** `∫ 𝓕g · h = ∫ g · 𝓕h` on the real line. -/
theorem integral_fourier_mul_eq_mul_fourier {psi fv : ℝ → ℂ} (hpsi : Integrable psi)
    (hf : Integrable fv) :
    ∫ x, 𝓕 psi x * fv x = ∫ x, psi x * 𝓕 fv x := by
  have hflip : (innerₗ ℝ).flip = (innerₗ ℝ) := by
    ext
    simp
  have h := VectorFourier.integral_fourierIntegral_smul_eq_flip (e := 𝐞)
    (μ := (volume : Measure ℝ)) (ν := (volume : Measure ℝ)) (L := innerₗ ℝ) (f := psi) (g := fv)
    Real.continuous_fourierChar continuous_inner hpsi hf
  simpa [hflip, smul_eq_mul, Real.fourier_eq] using h

/-- Continuity of the Fourier integral of an integrable function. -/
theorem continuous_fourier_of_integrable {fv : ℝ → ℂ} (hf : Integrable fv) :
    Continuous (𝓕 fv) :=
  VectorFourier.fourierIntegral_continuous Real.continuous_fourierChar continuous_inner hf

/-! ## The duality identity -/

/-- Unitarity of the `L²` Fourier transform, paired with a Schwartz function. -/
theorem inner_toLp_fourierL2 (psi : 𝓢(ℝ, ℂ)) (f : L2R) :
    inner ℂ (psi.toLp 2 volume) (fourierL2 f) = inner ℂ ((𝓕⁻ psi).toLp 2 volume) f := by
  have h1 : (𝓕 ((𝓕⁻ psi).toLp 2 volume) : Lp ℂ 2 volume) = psi.toLp 2 volume := by
    rw [SchwartzMap.toLp_fourier_eq]
    congr 1
    exact fourier_fourierInv_eq psi
  have h2 := MeasureTheory.Lp.inner_fourier_eq ((𝓕⁻ psi).toLp 2 volume) f
  rw [h1] at h2
  rw [← h2]
  rfl

/-- **The `L²` Fourier transform is given by the Fourier integral on integrable
functions.** -/
theorem coeFn_fourierL2_of_integrable (f : L2R) (hf : Integrable (f : ℝ → ℂ) volume) :
    (fourierL2 f : ℝ → ℂ) =ᵐ[volume] 𝓕 (f : ℝ → ℂ) := by
  set g : ℝ → ℂ := (fourierL2 f : ℝ → ℂ) with hg
  set h : ℝ → ℂ := 𝓕 (f : ℝ → ℂ) with hh
  have hgloc : LocallyIntegrable g volume := (Lp.memLp (fourierL2 f)).locallyIntegrable (by norm_num)
  have hhcont : Continuous h := continuous_fourier_of_integrable hf
  have hhloc : LocallyIntegrable h volume := hhcont.locallyIntegrable
  have key : ∀ᵐ x ∂(volume : Measure ℝ), (g - h) x = 0 := by
    refine ae_eq_zero_of_integral_contDiff_smul_eq_zero (hgloc.sub hhloc) ?_
    intro phi hphi hphis
    -- the complex valued test function
    set psi : ℝ → ℂ := fun x => (phi x : ℂ) with hpsi
    have hpsic : ContDiff ℝ (⊤ : ℕ∞) psi := Complex.ofRealCLM.contDiff.comp hphi
    have hpsis : HasCompactSupport psi := by
      refine hphis.comp_left (g := fun r : ℝ => (r : ℂ)) (by simp)
    set Psi : 𝓢(ℝ, ℂ) := hpsis.toSchwartzMap hpsic with hPsi
    have hPsiapp : ∀ x, Psi x = psi x := fun _ => rfl
    have hpsire : ∀ x, (starRingEnd ℂ) (psi x) = psi x := by
      intro x; simp [hpsi]
    have hpsiint : Integrable psi volume :=
      (hpsic.continuous).integrable_of_hasCompactSupport hpsis
    -- the two pairings
    have hLHS : inner ℂ (Psi.toLp 2 volume) (fourierL2 f) = ∫ x, psi x * g x := by
      rw [L2.inner_def]
      refine integral_congr_ae ?_
      filter_upwards [Psi.coeFn_toLp 2 volume] with x hx
      rw [hx]
      simp only [RCLike.inner_apply, hPsiapp, hpsire]
      exact mul_comm _ _
    have hRHS : inner ℂ ((𝓕⁻ Psi).toLp 2 volume) f = ∫ x, 𝓕 psi x * (f : ℝ → ℂ) x := by
      rw [L2.inner_def]
      refine integral_congr_ae ?_
      filter_upwards [(𝓕⁻ Psi).coeFn_toLp 2 volume] with x hx
      rw [hx]
      simp only [RCLike.inner_apply]
      have hconj : (starRingEnd ℂ) ((𝓕⁻ Psi : 𝓢(ℝ, ℂ)) x) = 𝓕 psi x := by
        have hco : ((𝓕⁻ Psi : 𝓢(ℝ, ℂ)) : ℝ → ℂ) = 𝓕⁻ (Psi : ℝ → ℂ) :=
          SchwartzMap.fourierInv_coe Psi
        rw [show ((𝓕⁻ Psi : 𝓢(ℝ, ℂ)) x) = 𝓕⁻ (Psi : ℝ → ℂ) x from congrFun hco x]
        exact conj_fourierInv_of_real hpsire x
      rw [hconj]
      exact mul_comm _ _
    have hmul : ∫ x, 𝓕 psi x * (f : ℝ → ℂ) x = ∫ x, psi x * h x :=
      integral_fourier_mul_eq_mul_fourier hpsiint hf
    have hpair : ∫ x, psi x * g x = ∫ x, psi x * h x := by
      rw [← hLHS, inner_toLp_fourierL2, hRHS, hmul]
    have hgint : Integrable (fun x => psi x * g x) volume := by
      have := hgloc.integrable_smul_left_of_hasCompactSupport (g := psi) hpsic.continuous hpsis
      simpa [smul_eq_mul] using this
    have hhint : Integrable (fun x => psi x * h x) volume := by
      have := hhloc.integrable_smul_left_of_hasCompactSupport (g := psi) hpsic.continuous hpsis
      simpa [smul_eq_mul] using this
    have hsplit : ∫ x, phi x • (g - h) x = (∫ x, psi x * g x) - ∫ x, psi x * h x := by
      rw [← integral_sub hgint hhint]
      refine integral_congr_ae (.of_forall fun x => ?_)
      simp [hpsi, Pi.sub_apply, mul_sub, Complex.real_smul]
    rw [hsplit, hpair, sub_self]
  filter_upwards [key] with x hx
  have := hx
  simp only [Pi.sub_apply, sub_eq_zero] at this
  exact this

end ConnesConsani.WeilPositivity
