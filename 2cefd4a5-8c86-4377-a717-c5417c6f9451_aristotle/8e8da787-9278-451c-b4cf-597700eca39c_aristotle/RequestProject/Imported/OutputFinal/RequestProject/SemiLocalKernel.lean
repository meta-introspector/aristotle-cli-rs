/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**The semi-local trace density in kernel form**, for arXiv:2006.13771 (Connes–Consani,
*Weil positivity and Trace formula – the archimedean place*).

The semi-local trace of Connes' local trace formula at the archimedean place is

  `κ_Λ(a) = Tr(D_a S^{(Λ)})`,  `S^{(Λ)} = P^{(Λ)} P̂^{(Λ)} P^{(Λ)}`,

with `D_a` the dilation unitary of `RequestProject/Dilation.lean` (`ϑ(λ) = D_{λ⁻¹}` is the
scaling representation of the paper).  This file computes that trace *exactly*, as an
explicit phase integral over a truncated box:

  `κ_Λ(a) = √a ∫_{|x| ≤ Λ} ∫_{|v| ≤ Λ, |a v| ≤ Λ} e^{2πi (a-1) v x} dv dx`.

The route is entirely structural, and uses no analysis beyond the two kernel formulas of
`RequestProject/DiagonalExact.lean` and `RequestProject/HilbertSchmidtPairing.lean`:

* `soninSandwichCut_eq_adjoint_cutFourierCut` — `S^{(Λ)} = G_Λ^* G_Λ` with
  `G_Λ = 1_{[-Λ,Λ]} 𝓕 1_{[-Λ,Λ]}`, the doubly truncated Fourier transform (the Fourier
  unitary in `B_Λ = 𝓕^{-1} G_Λ` cancels);
* `coeFn_cutFourierCut_comp_dil` — the kernel vectors of `G_Λ D_{a⁻¹}` are the dilates
  `D_a k_x` of the kernel vectors `k_x = 1_{[-Λ,Λ]} e(· x)` of `G_Λ`;
* `semiLocalDensity_eq_integral_inner` — hence, by the trace property and the
  Hilbert–Schmidt pairing formula, `κ_Λ(a) = ∫ ⟪k_x, D_a k_x⟫ dx`;
* `inner_cutoffKernelVec_dil` — the inner product is the elementary phase integral
  `√a ∫_{v ∈ s ∩ a⁻¹ s} e((a-1) v x) dv`;
* `semiLocalDensity_eq_double_integral` — the closed form above.

At `a = 1` it returns the exact diagonal value `4Λ²` of
`RequestProject/DiagonalExact.lean`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.HilbertSchmidtPairing
import RequestProject.Imported.OutputFinal.RequestProject.Dilation

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory Real Set FourierTransform ContinuousLinearMap

open scoped ENNReal NNReal

namespace ConnesConsani.WeilPositivity

/-! ## 1. The dilation as a continuous linear map -/

/-- The dilation `D_a`, as a continuous linear map. -/
def dilCLM (a : Rplus) : L2R →L[ℂ] L2R := ((dil a).toContinuousLinearEquiv : L2R →L[ℂ] L2R)

@[simp] theorem dilCLM_apply (a : Rplus) (xi : L2R) : dilCLM a xi = dil a xi := rfl

theorem adjoint_dilCLM (a : Rplus) : adjoint (dilCLM a) = dilCLM a⁻¹ := adjoint_dil a

/-- For a unitary `V`, `V* V = 1`. -/
theorem adjoint_comp_self_of_isometryEquiv (V : L2R ≃ₗᵢ[ℂ] L2R) :
    adjoint ((V.toContinuousLinearEquiv : L2R →L[ℂ] L2R)) ∘L
      (V.toContinuousLinearEquiv : L2R →L[ℂ] L2R) = ContinuousLinearMap.id ℂ L2R := by
  refine ContinuousLinearMap.ext fun x => ?_
  refine ext_inner_left ℂ fun y => ?_
  rw [ContinuousLinearMap.comp_apply, ContinuousLinearMap.adjoint_inner_right]
  simp

/-! ## 2. The doubly truncated Fourier transform -/

variable {ι : Type*}

/-- `G_Λ = 1_{[-Λ,Λ]} 𝓕 1_{[-Λ,Λ]}`, the doubly truncated Fourier transform. -/
def cutFourierCut (cut : ℝ) : L2R →L[ℂ] L2R :=
  cutoff (measurableSet_cutoffSet cut) ∘L fourierCLM ∘L cutoff (measurableSet_cutoffSet cut)

theorem PcutHat_comp_Pcut_eq (cut : ℝ) :
    PcutHat cut ∘L Pcut cut
      = (fourierL2.symm.toContinuousLinearEquiv : L2R →L[ℂ] L2R) ∘L cutFourierCut cut := by
  ext xi
  simp [PcutHat, Pcut, cutFourierCut, fourierConj_apply, fourierCLM]

/-- **`S^{(Λ)} = G_Λ^* G_Λ`.**  The Fourier unitary in `B_Λ = 𝓕^{-1} G_Λ` cancels in the
sandwich. -/
theorem soninSandwichCut_eq_adjoint_cutFourierCut (cut : ℝ) :
    soninSandwichCut cut = adjoint (cutFourierCut cut) ∘L cutFourierCut cut := by
  rw [soninSandwichCut_eq_adjoint_comp, PcutHat_comp_Pcut_eq, ContinuousLinearMap.adjoint_comp,
    ContinuousLinearMap.comp_assoc, ← ContinuousLinearMap.comp_assoc
      (adjoint ((fourierL2.symm.toContinuousLinearEquiv : L2R →L[ℂ] L2R))),
    adjoint_comp_self_of_isometryEquiv fourierL2.symm]
  simp

/-- The kernel vectors of `G_Λ`. -/
def cutKernelVec (cut : ℝ) (x : ℝ) : L2R :=
  cutoffKernelVecOn (measurableSet_cutoffSet cut) (volume_cutoffSet_ne_top cut) x

theorem coeFn_cutFourierCutFam (cut : ℝ) (xi : L2R) :
    ((cutFourierCut cut) xi : ℝ → ℂ) =ᵐ[volume] fun x => inner ℂ (cutKernelVec cut x) xi :=
  coeFn_cutFourierCutOn (measurableSet_cutoffSet cut) (volume_cutoffSet_ne_top cut) xi

theorem lintegral_enorm_cutKernelVec_sq (cut : ℝ) :
    ∫⁻ x, ‖cutKernelVec cut x‖ₑ ^ 2 = volume (cutoffSet cut) * volume (cutoffSet cut) := by
  simp only [cutKernelVec]
  rw [lintegral_congr (enorm_cutoffKernelVecOn_sq (measurableSet_cutoffSet cut)
    (volume_cutoffSet_ne_top cut)), lintegral_indicator_const (measurableSet_cutoffSet cut)]

theorem lintegral_enorm_cutKernelVec_sq_ne_top (cut : ℝ) :
    ∫⁻ x, ‖cutKernelVec cut x‖ₑ ^ 2 ≠ ⊤ := by
  rw [lintegral_enorm_cutKernelVec_sq]
  have : volume (cutoffSet cut) ≠ ⊤ := volume_cutoffSet_ne_top cut
  finiteness

/-- **The kernel vectors of `G_Λ D_{a⁻¹}`** are the dilates of those of `G_Λ`. -/
theorem coeFn_cutFourierCut_comp_dil (cut : ℝ) (a : Rplus) (xi : L2R) :
    ((cutFourierCut cut ∘L dilCLM a⁻¹) xi : ℝ → ℂ)
      =ᵐ[volume] fun x => inner ℂ (dil a (cutKernelVec cut x)) xi := by
  filter_upwards [coeFn_cutFourierCutFam cut (dilCLM a⁻¹ xi)] with x hx
  rw [ContinuousLinearMap.comp_apply, hx]
  have h1 : dil a (dil a⁻¹ xi) = xi := by
    rw [← dil_mul, mul_inv_cancel, dil_one]; rfl
  calc inner ℂ (cutKernelVec cut x) (dil a⁻¹ xi)
      = inner ℂ (dil a (cutKernelVec cut x)) (dil a (dil a⁻¹ xi)) :=
        ((dil a).inner_map_map _ _).symm
    _ = inner ℂ (dil a (cutKernelVec cut x)) xi := by rw [h1]

theorem lintegral_enorm_dil_cutKernelVec_sq_ne_top (cut : ℝ) (a : Rplus) :
    ∫⁻ x, ‖dil a (cutKernelVec cut x)‖ₑ ^ 2 ≠ ⊤ := by
  have hcongr : ∀ x : ℝ, ‖dil a (cutKernelVec cut x)‖ₑ ^ 2 = ‖cutKernelVec cut x‖ₑ ^ 2 := by
    intro x
    rw [show ‖dil a (cutKernelVec cut x)‖ₑ = ‖cutKernelVec cut x‖ₑ from by
      simp only [enorm_eq_nnnorm]
      exact congrArg _ (NNReal.coe_injective (by
        simpa using norm_dilLp a (cutKernelVec cut x)))]
  rw [lintegral_congr hcongr]
  exact lintegral_enorm_cutKernelVec_sq_ne_top cut

/-! ## 3. The semi-local trace density -/

/-- **The semi-local trace density** `κ_Λ(a) = Tr(D_a S^{(Λ)})`, computed along a Hilbert
basis.  With `a = λ⁻¹` this is the paper's `Tr(ϑ(λ) S^{(Λ)})`. -/
def semiLocalDensity (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (a : Rplus) : ℂ :=
  traceAlong b (dilCLM a ∘L soninSandwichCut cut)

/-- **The semi-local trace density is an integral of kernel pairings.** -/
theorem semiLocalDensity_eq_integral_inner [Countable ι] (b : HilbertBasis ι ℂ L2R)
    (cut : ℝ) (a : Rplus) :
    semiLocalDensity b cut a
      = ∫ x, inner ℂ (cutKernelVec cut x) (dil a (cutKernelVec cut x)) := by
  have hassoc : dilCLM a ∘L soninSandwichCut cut
      = (dilCLM a ∘L adjoint (cutFourierCut cut)) ∘L cutFourierCut cut := by
    rw [soninSandwichCut_eq_adjoint_cutFourierCut, ContinuousLinearMap.comp_assoc]
  have hadj : adjoint (dilCLM a ∘L adjoint (cutFourierCut cut))
      = cutFourierCut cut ∘L dilCLM a⁻¹ := by
    rw [ContinuousLinearMap.adjoint_comp, ContinuousLinearMap.adjoint_adjoint, adjoint_dilCLM]
  rw [semiLocalDensity, hassoc, traceAlong_comp_eq_hsInner, hadj]
  exact hsInner_eq_integral_of_kernel b _ _ (fun x => dil a (cutKernelVec cut x))
    (cutKernelVec cut) (coeFn_cutFourierCut_comp_dil cut a) (coeFn_cutFourierCutFam cut)
    (lintegral_enorm_dil_cutKernelVec_sq_ne_top cut a)
    (lintegral_enorm_cutKernelVec_sq_ne_top cut)

/-! ## 4. The explicit phase integral -/

/-- The band over which the kernel pairing is taken: the points of the cut-off window whose
`a`-dilate is still in the window. -/
def dilBand (cut : ℝ) (a : ℝ) : Set ℝ :=
  cutoffSet cut ∩ (fun v : ℝ => a * v) ⁻¹' cutoffSet cut

theorem measurableSet_dilBand (cut a : ℝ) : MeasurableSet (dilBand cut a) :=
  (measurableSet_cutoffSet cut).inter
    ((measurable_const_mul a) (measurableSet_cutoffSet cut))

/-- **The kernel pairing is an elementary phase integral.**  For `x` in the cut-off window,
`⟪k_x, D_a k_x⟫ = √a ∫_{v ∈ s ∩ a⁻¹ s} e^{2πi (a-1) v x} dv`. -/
theorem inner_cutKernelVec_dil_of_mem (cut : ℝ) (a : Rplus) {x : ℝ}
    (hx : x ∈ cutoffSet cut) :
    inner ℂ (cutKernelVec cut x) (dil a (cutKernelVec cut x))
      = (Real.sqrt (a : ℝ) : ℂ) *
        ∫ v in dilBand cut (a : ℝ), ((𝐞 (((a : ℝ) - 1) * (v * x)) : Circle) : ℂ) := by
  classical
  have hk : ((cutKernelVec cut x : L2R) : ℝ → ℂ)
      =ᵐ[volume] (cutoffSet cut).indicator (unitChar x) := by
    simp only [cutKernelVec, cutoffKernelVecOn, if_pos hx]
    exact MemLp.coeFn_toLp _
  have hdil : ((dil a (cutKernelVec cut x) : L2R) : ℝ → ℂ)
      =ᵐ[volume] dilFun (a : ℝ) ((cutoffSet cut).indicator (unitChar x)) :=
    (coeFn_dilLp a _).trans (dilFun_congr_ae a.2 hk)
  have hpt : ∀ᵐ v : ℝ ∂volume,
      (inner ℂ (((cutKernelVec cut x : L2R) : ℝ → ℂ) v)
        (((dil a (cutKernelVec cut x) : L2R) : ℝ → ℂ) v) : ℂ)
        = (dilBand cut (a : ℝ)).indicator
            (fun v => (Real.sqrt (a : ℝ) : ℂ) * ((𝐞 (((a : ℝ) - 1) * (v * x)) : Circle) : ℂ)) v := by
    filter_upwards [hk, hdil] with v h1 h2
    rw [RCLike.inner_apply, h1, h2]
    by_cases hv : v ∈ cutoffSet cut
    · by_cases hav : (a : ℝ) * v ∈ cutoffSet cut
      · rw [Set.indicator_of_mem (show v ∈ dilBand cut (a : ℝ) from ⟨hv, hav⟩),
          Set.indicator_of_mem hv, dilFun, Set.indicator_of_mem hav]
        simp only [unitChar, starRingEnd_apply]
        have hstar : star ((𝐞 (v * x) : Circle) : ℂ) = ((𝐞 (-(v * x)) : Circle) : ℂ) :=
          conj_fourierChar (v * x)
        have hsplit : ((𝐞 (((a : ℝ) - 1) * (v * x)) : Circle) : ℂ)
            = ((𝐞 ((a : ℝ) * v * x) : Circle) : ℂ) * ((𝐞 (-(v * x)) : Circle) : ℂ) := by
          rw [← Circle.coe_mul, ← AddChar.map_add_eq_mul]
          congr 1
          ring_nf
        rw [hstar, hsplit, Complex.real_smul]
        ring
      · rw [Set.indicator_of_notMem (show v ∉ dilBand cut (a : ℝ) from fun h => hav h.2),
          dilFun, Set.indicator_of_notMem hav]
        simp
    · rw [Set.indicator_of_notMem (show v ∉ dilBand cut (a : ℝ) from fun h => hv h.1),
        Set.indicator_of_notMem hv]
      simp
  rw [L2.inner_def, integral_congr_ae hpt, integral_indicator (measurableSet_dilBand cut (a : ℝ)),
    integral_const_mul]

/-- Outside the cut-off window the kernel vector vanishes. -/
theorem inner_cutKernelVec_dil_of_notMem (cut : ℝ) (a : Rplus) {x : ℝ}
    (hx : x ∉ cutoffSet cut) :
    inner ℂ (cutKernelVec cut x) (dil a (cutKernelVec cut x)) = 0 := by
  classical
  simp [cutKernelVec, cutoffKernelVecOn, if_neg hx]

/-- **The semi-local trace density in closed form**:

  `Tr(D_a S^{(Λ)}) = √a ∫_{|x| ≤ Λ} ∫_{|v| ≤ Λ, |a v| ≤ Λ} e^{2πi (a-1) v x} dv dx`.

This is the semi-local kernel of Connes' local trace formula at the archimedean place,
with the sharp cut-offs, evaluated exactly. -/
theorem semiLocalDensity_eq_double_integral [Countable ι] (b : HilbertBasis ι ℂ L2R)
    (cut : ℝ) (a : Rplus) :
    semiLocalDensity b cut a
      = (Real.sqrt (a : ℝ) : ℂ) * ∫ x in cutoffSet cut,
          ∫ v in dilBand cut (a : ℝ), ((𝐞 (((a : ℝ) - 1) * (v * x)) : Circle) : ℂ) := by
  classical
  rw [semiLocalDensity_eq_integral_inner b cut a]
  have hcongr : ∀ x : ℝ, inner ℂ (cutKernelVec cut x) (dil a (cutKernelVec cut x))
      = (cutoffSet cut).indicator (fun x : ℝ => (Real.sqrt (a : ℝ) : ℂ) *
          ∫ v in dilBand cut (a : ℝ), ((𝐞 (((a : ℝ) - 1) * (v * x)) : Circle) : ℂ)) x := by
    intro x
    by_cases hx : x ∈ cutoffSet cut
    · rw [Set.indicator_of_mem hx, inner_cutKernelVec_dil_of_mem cut a hx]
    · rw [Set.indicator_of_notMem hx, inner_cutKernelVec_dil_of_notMem cut a hx]
  rw [funext hcongr, integral_indicator (measurableSet_cutoffSet cut), integral_const_mul]

/-- Sanity check: at `a = 1` the density is the exact diagonal value `4Λ²`. -/
theorem semiLocalDensity_one [Countable ι] (b : HilbertBasis ι ℂ L2R) {cut : ℝ}
    (hcut : 0 ≤ cut) :
    semiLocalDensity b cut 1 = 4 * (cut : ℂ) ^ 2 := by
  have hband : dilBand cut ((1 : Rplus) : ℝ) = cutoffSet cut := by
    ext v
    simp [dilBand]
  have hvol : (volume.restrict (cutoffSet cut)).real Set.univ = 2 * cut := by
    rw [measureReal_def, Measure.restrict_apply_univ, cutoffSet, Real.volume_Icc,
      ENNReal.toReal_ofReal (by linarith)]
    ring
  rw [semiLocalDensity_eq_double_integral b cut 1, hband]
  have hone : ∀ v x : ℝ, ((𝐞 ((((1 : Rplus) : ℝ) - 1) * (v * x)) : Circle) : ℂ) = 1 := by
    intro v x
    norm_num
  simp only [hone, integral_const]
  rw [hvol, Complex.real_smul, Complex.real_smul]
  have hsq : ((1 : Rplus) : ℝ) = 1 := rfl
  rw [hsq, Real.sqrt_one]
  push_cast
  ring

end ConnesConsani.WeilPositivity
