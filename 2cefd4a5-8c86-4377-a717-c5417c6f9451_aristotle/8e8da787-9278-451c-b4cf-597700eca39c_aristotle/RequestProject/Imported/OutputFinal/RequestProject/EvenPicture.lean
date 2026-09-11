/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**The unitary of the paper's log-picture identification**, for arXiv:2006.13771
(Connes–Consani, *Weil positivity and Trace formula – the archimedean place*).

The paper identifies `L²(ℝ⋆₊, d*ρ)` with the *even* part of `L²(ℝ, dx)` by

  `(w ξ)(x) = (2|x|)^{-1/2} ξ(|x|)`,

and it is in this picture that the two cutoff projections `P₁` (cutoff of `[-1,1]` in
space) and `P̂₁` (the same in frequency) of `RequestProject/Sonin.lean` act, and in which
the scaling representation `ϑ(λ)ξ(x) = λ^{-1/2} ξ(λ^{-1}x)` is the transported regular
representation of `ℝ⋆₊`.

This file constructs `w` and proves that it is a unitary of `L²(ℝ⋆₊, d*ρ)` onto the even
subspace of `L²(ℝ)`:

* `evenLift`/`evenLiftₗᵢ`: the map in the logarithmic coordinate `t = log|x|`, a linear
  isometry of `L²(ℝ)`;
* `weilMap : L²(ℝ⋆₊, d*ρ) →ₗᵢ[ℂ] L²(ℝ)`, the composition with the passage `logEquiv` to
  logarithmic coordinates: this is the map `w` above (`coeFn_weilMap`);
* `evenSubspace`, the fixed subspace of the reflection `x ↦ -x`, and
  `range_weilMap`, the statement that the range of `w` is exactly `evenSubspace`, whence
  the unitary `weilUnitary : L²(ℝ⋆₊, d*ρ) ≃ₗᵢ[ℂ] evenSubspace`;
* `weilMap_scaling`: the intertwining relation
  `w (ϑ(λ) ξ)(x) = λ^{-1/2} (w ξ)(λ^{-1} x)`, i.e. `w` transports the regular
  representation of `ℝ⋆₊` into the scaling representation of the paper;
* `P1_mem_evenSubspace`, `P1hat_mem_evenSubspace`: the two cutoff projections preserve the
  even subspace, so that the whole Sonin sandwich lives in the picture defined by `w`.

Everything rests on one change-of-variables computation, `lintegral_enorm_sq_evenLift`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.LogPicture

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory Set

open scoped ENNReal

namespace ConnesConsani.WeilPositivity

/-! ## Two change-of-variables lemmas for the Lebesgue integral -/

/-- The multiplicative Haar integral on `(0,∞)` in the exponential coordinate:
`∫₀^∞ h(x) dx/x = ∫_ℝ h(e^t) dt`. -/
theorem lintegral_Ioi_inv_mul_eq (h : ℝ → ℝ≥0∞) :
    ∫⁻ x in Ioi (0:ℝ), ENNReal.ofReal x⁻¹ * h x = ∫⁻ t : ℝ, h (Real.exp t) := by
  have himg : Real.exp '' univ = Ioi (0:ℝ) := by rw [Set.image_univ, Real.range_exp]
  have hchange := lintegral_image_eq_lintegral_abs_deriv_mul (f := Real.exp) (f' := Real.exp)
    (s := univ) MeasurableSet.univ (fun x _ => (Real.hasDerivAt_exp x).hasDerivWithinAt)
    Real.exp_injective.injOn (fun x => ENNReal.ofReal x⁻¹ * h x)
  rw [himg] at hchange
  rw [hchange, Measure.restrict_univ]
  refine lintegral_congr fun t => ?_
  rw [abs_of_pos (Real.exp_pos t), ← mul_assoc, ← ENNReal.ofReal_mul (Real.exp_pos t).le,
    mul_inv_cancel₀ (Real.exp_pos t).ne']
  simp

/-- The integral of an even function is twice its integral over the positive half-line. -/
theorem lintegral_of_even (g : ℝ → ℝ≥0∞) (hmeas : Measurable g) (heven : ∀ x, g (-x) = g x) :
    ∫⁻ x, g x = 2 * ∫⁻ x in Ioi (0:ℝ), g x := by
  have hsplit := lintegral_add_compl (μ := (volume : Measure ℝ)) g (measurableSet_Ioi (a := (0:ℝ)))
  have hcompl : (Ioi (0:ℝ))ᶜ = Iic 0 := by simp
  have hneg : ∫⁻ x in Iic (0:ℝ), g x = ∫⁻ x in Ici (0:ℝ), g x := by
    have hmp : MeasurePreserving (fun x : ℝ => -x) volume volume :=
      Measure.measurePreserving_neg volume
    have hcomp := hmp.lintegral_comp (f := (Iic (0:ℝ)).indicator g)
      (hmeas.indicator measurableSet_Iic)
    rw [← lintegral_indicator measurableSet_Iic, ← lintegral_indicator measurableSet_Ici, ← hcomp]
    refine lintegral_congr fun x => ?_
    by_cases hx : 0 ≤ x
    · rw [Set.indicator_of_mem (by simpa using hx : -x ∈ Iic (0:ℝ)),
        Set.indicator_of_mem (by simpa using hx : x ∈ Ici (0:ℝ)), heven]
    · push_neg at hx
      rw [Set.indicator_of_notMem (by simp; linarith),
        Set.indicator_of_notMem (by simp; linarith)]
  have hIci : ∫⁻ x in Ici (0:ℝ), g x = ∫⁻ x in Ioi (0:ℝ), g x := by
    rw [Measure.restrict_congr_set Ioi_ae_eq_Ici.symm]
  rw [← hsplit, hcompl, hneg, hIci, two_mul]

/-! ## The lift `F ↦ (x ↦ (2|x|)^{-1/2} F(log|x|))` -/

/-- The paper's identification, written in the logarithmic coordinate `t = log |x|`:
`(evenLift F)(x) = (2|x|)^{-1/2} F(log|x|)`.  It sends `L²(ℝ, dt)` isometrically onto the
even part of `L²(ℝ, dx)`. -/
def evenLift (F : ℝ → ℂ) (x : ℝ) : ℂ :=
  ((Real.sqrt (2 * |x|))⁻¹ : ℝ) • F (Real.log |x|)

theorem evenLift_neg (F : ℝ → ℂ) (x : ℝ) : evenLift F (-x) = evenLift F x := by
  simp [evenLift]

theorem measurable_evenLift {F : ℝ → ℂ} (hF : Measurable F) : Measurable (evenLift F) := by
  unfold evenLift
  exact Measurable.smul (by fun_prop) (hF.comp (Real.measurable_log.comp measurable_abs))

theorem evenLift_add (F G : ℝ → ℂ) : evenLift (F + G) = evenLift F + evenLift G := by
  funext x; simp [evenLift, smul_add]

theorem evenLift_smul (c : ℂ) (F : ℝ → ℂ) : evenLift (c • F) = c • evenLift F := by
  funext x
  show ((Real.sqrt (2 * |x|))⁻¹ : ℝ) • (c • F (Real.log |x|))
      = c • (((Real.sqrt (2 * |x|))⁻¹ : ℝ) • F (Real.log |x|))
  rw [smul_comm]

theorem enorm_sq_evenLift (F : ℝ → ℂ) {x : ℝ} (hx : x ≠ 0) :
    ‖evenLift F x‖ₑ ^ 2 = ENNReal.ofReal (2 * |x|)⁻¹ * ‖F (Real.log |x|)‖ₑ ^ 2 := by
  have hpos : 0 < 2 * |x| := by positivity
  have hr : 0 ≤ (Real.sqrt (2 * |x|))⁻¹ := by positivity
  rw [evenLift, enorm_smul, mul_pow]
  congr 1
  rw [Real.enorm_eq_ofReal hr, ← ENNReal.ofReal_pow hr]
  congr 1
  rw [← Real.sqrt_inv, Real.sq_sqrt (by positivity)]

/-- **The change of variables underlying the paper's identification**: the lift preserves
the `L²` norm. -/
theorem lintegral_enorm_sq_evenLift (F : ℝ → ℂ) (hF : Measurable F) :
    ∫⁻ x, ‖evenLift F x‖ₑ ^ 2 = ∫⁻ t, ‖F t‖ₑ ^ 2 := by
  have hmeas : Measurable fun x : ℝ => ‖evenLift F x‖ₑ ^ 2 :=
    ((measurable_evenLift hF).enorm).pow_const 2
  rw [lintegral_of_even _ hmeas (fun x => by rw [evenLift_neg])]
  have hcongr : ∫⁻ x in Ioi (0:ℝ), ‖evenLift F x‖ₑ ^ 2
      = ∫⁻ x in Ioi (0:ℝ), ENNReal.ofReal (2 * x)⁻¹ * ‖F (Real.log x)‖ₑ ^ 2 := by
    refine setLIntegral_congr_fun measurableSet_Ioi fun x hx => ?_
    rw [enorm_sq_evenLift F (ne_of_gt hx), abs_of_pos hx]
  rw [hcongr, ← lintegral_const_mul' _ _ (by norm_num : (2:ℝ≥0∞) ≠ ⊤)]
  have hstep : ∫⁻ x in Ioi (0:ℝ), 2 * (ENNReal.ofReal (2 * x)⁻¹ * ‖F (Real.log x)‖ₑ ^ 2)
      = ∫⁻ x in Ioi (0:ℝ), ENNReal.ofReal x⁻¹ * ‖F (Real.log x)‖ₑ ^ 2 := by
    refine setLIntegral_congr_fun measurableSet_Ioi fun x _ => ?_
    rw [← mul_assoc]
    congr 1
    rw [mul_inv, ENNReal.ofReal_mul (by norm_num : (0:ℝ) ≤ 2⁻¹), ← mul_assoc,
      ENNReal.ofReal_inv_of_pos (by norm_num : (0:ℝ) < 2)]
    rw [show ENNReal.ofReal (2:ℝ) = 2 by simp, ENNReal.mul_inv_cancel (by norm_num) (by norm_num),
      one_mul]
  rw [hstep, lintegral_Ioi_inv_mul_eq (fun x => ‖F (Real.log x)‖ₑ ^ 2)]
  simp

theorem eLpNorm_evenLift {F : ℝ → ℂ} (hF : Measurable F) :
    eLpNorm (evenLift F) 2 volume = eLpNorm F 2 volume := by
  rw [eLpNorm_eq_lintegral_rpow_enorm_toReal (by norm_num) (by norm_num),
    eLpNorm_eq_lintegral_rpow_enorm_toReal (by norm_num) (by norm_num)]
  congr 1
  have h2 : (2:ℝ≥0∞).toReal = ((2:ℕ):ℝ) := by norm_num
  simp_rw [h2, ENNReal.rpow_natCast]
  exact lintegral_enorm_sq_evenLift F hF

theorem memLp_evenLift {F : ℝ → ℂ} (hF : Measurable F) (h : MemLp F 2 volume) :
    MemLp (evenLift F) 2 volume :=
  ⟨(measurable_evenLift hF).aestronglyMeasurable, by rw [eLpNorm_evenLift hF]; exact h.2⟩

/-- The lift respects almost-everywhere equality: a null set pulls back to a null set under
`x ↦ log|x|`. -/
theorem evenLift_congr_ae {F G : ℝ → ℂ} (hF : Measurable F) (hG : Measurable G)
    (h : F =ᵐ[volume] G) : evenLift F =ᵐ[volume] evenLift G := by
  set H : ℝ → ℂ := F - G with hH
  have hHmeas : Measurable H := hF.sub hG
  have hH0 : H =ᵐ[volume] 0 := by
    filter_upwards [h] with x hx
    simp [hH, hx]
  have hzero : ∫⁻ t, ‖H t‖ₑ ^ 2 = 0 := by
    rw [lintegral_eq_zero_iff ((hHmeas.enorm).pow_const 2)]
    filter_upwards [hH0] with x hx
    simp [hx]
  have hlift : ∫⁻ x, ‖evenLift H x‖ₑ ^ 2 = 0 := by
    rw [lintegral_enorm_sq_evenLift H hHmeas]; exact hzero
  have hae : ∀ᵐ x : ℝ, evenLift H x = 0 := by
    have := (lintegral_eq_zero_iff (((measurable_evenLift hHmeas).enorm).pow_const 2)).1 hlift
    filter_upwards [this] with x hx
    simpa using hx
  filter_upwards [hae] with x hx
  have hsub : evenLift H x = evenLift F x - evenLift G x := by
    simp [evenLift, hH, smul_sub]
  rw [hsub] at hx
  linear_combination (norm := module) hx

/-! ## The lift as a linear isometry of `L²(ℝ)` -/

/-- The paper's identification in logarithmic coordinates, on `L²(ℝ)`. -/
def evenLiftLp (xi : L2R) : L2R :=
  (memLp_evenLift (Lp.stronglyMeasurable xi).measurable (Lp.memLp xi)).toLp _

theorem coeFn_evenLiftLp (xi : L2R) :
    (evenLiftLp xi : ℝ → ℂ) =ᵐ[volume] evenLift (xi : ℝ → ℂ) :=
  MemLp.coeFn_toLp _

theorem norm_evenLiftLp (xi : L2R) : ‖evenLiftLp xi‖ = ‖xi‖ := by
  rw [evenLiftLp, Lp.norm_toLp, eLpNorm_evenLift (Lp.stronglyMeasurable xi).measurable,
    ← Lp.norm_def]

theorem evenLiftLp_add (xi eta : L2R) :
    evenLiftLp (xi + eta) = evenLiftLp xi + evenLiftLp eta := by
  rw [Lp.ext_iff]
  filter_upwards [coeFn_evenLiftLp (xi + eta), Lp.coeFn_add (evenLiftLp xi) (evenLiftLp eta),
    coeFn_evenLiftLp xi, coeFn_evenLiftLp eta,
    evenLift_congr_ae (Lp.stronglyMeasurable (xi + eta)).measurable
      (((Lp.stronglyMeasurable xi).measurable.add (Lp.stronglyMeasurable eta).measurable))
      (Lp.coeFn_add xi eta)] with x h1 h2 h3 h4 h5
  rw [h1, h5, h2, Pi.add_apply, h3, h4]
  simp [evenLift, smul_add]

theorem evenLiftLp_smul (c : ℂ) (xi : L2R) : evenLiftLp (c • xi) = c • evenLiftLp xi := by
  rw [Lp.ext_iff]
  filter_upwards [coeFn_evenLiftLp (c • xi), Lp.coeFn_smul c (evenLiftLp xi),
    coeFn_evenLiftLp xi,
    evenLift_congr_ae (Lp.stronglyMeasurable (c • xi)).measurable
      ((Lp.stronglyMeasurable xi).measurable.const_smul c) (Lp.coeFn_smul c xi)] with x h1 h2 h3 h4
  rw [h1, h4, h2, Pi.smul_apply, h3]
  show ((Real.sqrt (2 * |x|))⁻¹ : ℝ) • (c • (xi : ℝ → ℂ) (Real.log |x|))
      = c • (((Real.sqrt (2 * |x|))⁻¹ : ℝ) • (xi : ℝ → ℂ) (Real.log |x|))
  rw [smul_comm]

/-- **The paper's identification, in logarithmic coordinates**, as a linear isometry of
`L²(ℝ)`. -/
def evenLiftₗᵢ : L2R →ₗᵢ[ℂ] L2R where
  toFun := evenLiftLp
  map_add' := evenLiftLp_add
  map_smul' := evenLiftLp_smul
  norm_map' := norm_evenLiftLp

@[simp] theorem evenLiftₗᵢ_apply (xi : L2R) : evenLiftₗᵢ xi = evenLiftLp xi := rfl

/-! ## The paper's unitary `w : L²(ℝ⋆₊, d*ρ) → L²(ℝ)` -/

/-- **The unitary of the paper**: `(w ξ)(x) = (2|x|)^{-1/2} ξ(|x|)`, obtained by composing
the passage to logarithmic coordinates with the lift. -/
def weilMap : L2Rplus →ₗᵢ[ℂ] L2R := evenLiftₗᵢ.comp logEquiv.toLinearIsometry

theorem weilMap_apply (xi : L2Rplus) : weilMap xi = evenLiftLp (logEquiv xi) := rfl

/-- The explicit formula `(w ξ)(x) = (2|x|)^{-1/2} ξ(|x|)`, in the form
`(w ξ)(x) = (2|x|)^{-1/2} ξ(e^{log|x|})`. -/
theorem coeFn_weilMap (xi : L2Rplus) :
    (weilMap xi : ℝ → ℂ) =ᵐ[volume] fun x =>
      ((Real.sqrt (2 * |x|))⁻¹ : ℝ) • (xi : Rplus → ℂ) (Rplus.expHomeo (Real.log |x|)) := by
  have h1 : (weilMap xi : ℝ → ℂ) =ᵐ[volume] evenLift ((logEquiv xi : L2R) : ℝ → ℂ) :=
    coeFn_evenLiftLp (logEquiv xi)
  have h2 : evenLift ((logEquiv xi : L2R) : ℝ → ℂ)
      =ᵐ[volume] evenLift (fun t => (xi : Rplus → ℂ) (Rplus.expHomeo t)) := by
    refine evenLift_congr_ae (Lp.stronglyMeasurable _).measurable ?_ ?_
    · exact ((Lp.stronglyMeasurable xi).measurable).comp Rplus.expHomeo.continuous.measurable
    · exact coeFn_logCoordinates xi
  exact h1.trans h2

/-! ## The even subspace of `L²(ℝ)` and the range of `w` -/

/-- The reflection `x ↦ -x` of `L²(ℝ)`. -/
def reflectₗᵢ : L2R →ₗᵢ[ℂ] L2R :=
  Lp.compMeasurePreservingₗᵢ ℂ (fun x : ℝ => -x) (Measure.measurePreserving_neg volume)

theorem coeFn_reflectₗᵢ (f : L2R) :
    (reflectₗᵢ f : ℝ → ℂ) =ᵐ[volume] fun x => (f : ℝ → ℂ) (-x) :=
  Lp.coeFn_compMeasurePreserving f _

/-- **The even subspace of `L²(ℝ)`**: the fixed points of the reflection `x ↦ -x`.  This is
the space `L²(ℝ)_ev` of the paper. -/
def evenSubspace : Submodule ℂ L2R :=
  LinearMap.ker (reflectₗᵢ.toLinearMap - LinearMap.id)

theorem mem_evenSubspace_iff (f : L2R) : f ∈ evenSubspace ↔ reflectₗᵢ f = f := by
  simp [evenSubspace, LinearMap.mem_ker, sub_eq_zero]

theorem mem_evenSubspace_of_ae {f : L2R}
    (h : (f : ℝ → ℂ) =ᵐ[volume] fun x => (f : ℝ → ℂ) (-x)) : f ∈ evenSubspace := by
  rw [mem_evenSubspace_iff, Lp.ext_iff]
  filter_upwards [coeFn_reflectₗᵢ f, h] with x h1 h2
  rw [h1, ← h2]

theorem ae_neg_of_mem_evenSubspace {f : L2R} (hf : f ∈ evenSubspace) :
    (f : ℝ → ℂ) =ᵐ[volume] fun x => (f : ℝ → ℂ) (-x) := by
  rw [mem_evenSubspace_iff] at hf
  have := coeFn_reflectₗᵢ f
  rw [hf] at this
  exact this

/-- The image of `w` consists of even functions. -/
theorem weilMap_mem_evenSubspace (xi : L2Rplus) : weilMap xi ∈ evenSubspace := by
  refine mem_evenSubspace_of_ae ?_
  have h := coeFn_weilMap xi
  have hneg : (fun x : ℝ => (weilMap xi : ℝ → ℂ) (-x))
      =ᵐ[volume] fun x => ((Real.sqrt (2 * |x|))⁻¹ : ℝ) •
        (xi : Rplus → ℂ) (Rplus.expHomeo (Real.log |x|)) := by
    have := h.comp_tendsto (Measure.measurePreserving_neg volume).quasiMeasurePreserving.tendsto_ae
    filter_upwards [this] with x hx
    simpa using hx
  exact h.trans hneg.symm

/-- **The range of `w` is exactly the even subspace**: every even `L²` function is
`(2|x|)^{-1/2} ξ(|x|)` for a unique `ξ ∈ L²(ℝ⋆₊, d*ρ)`. -/
theorem exists_weilMap_eq_of_mem_evenSubspace {phi : L2R} (hphi : phi ∈ evenSubspace) :
    ∃ xi : L2Rplus, weilMap xi = phi := by
  classical
  set phi0 : ℝ → ℂ := (phi : ℝ → ℂ) with hphi0
  have hphi0meas : Measurable phi0 := (Lp.stronglyMeasurable phi).measurable
  set phi1 : ℝ → ℂ := fun x => if 0 ≤ x then phi0 x else phi0 (-x) with hphi1
  have hphi1meas : Measurable phi1 := by
    refine Measurable.ite measurableSet_Ici hphi0meas (hphi0meas.comp measurable_neg)
  have hphi1even : ∀ x, phi1 (-x) = phi1 x := by
    intro x
    rcases lt_trichotomy x 0 with hx | hx | hx
    · rw [hphi1]
      simp only []
      rw [if_pos (by linarith : (0:ℝ) ≤ -x), if_neg (by linarith : ¬ (0:ℝ) ≤ x)]
    · simp [hx]
    · rw [hphi1]
      simp only []
      rw [if_neg (by linarith : ¬ (0:ℝ) ≤ -x), if_pos (by linarith : (0:ℝ) ≤ x), neg_neg]
  have hphi1ae : phi1 =ᵐ[volume] phi0 := by
    filter_upwards [ae_neg_of_mem_evenSubspace hphi] with x hx
    rw [hphi1]
    simp only []
    by_cases h : 0 ≤ x
    · rw [if_pos h]
    · rw [if_neg h]
      exact (hx).symm
  -- the preimage, in logarithmic coordinates
  set G : ℝ → ℂ := fun t => (Real.sqrt (2 * Real.exp t) : ℝ) • phi1 (Real.exp t) with hG
  have hGmeas : Measurable G := by
    refine Measurable.smul ?_ (hphi1meas.comp Real.measurable_exp)
    fun_prop
  have hlift : ∀ x : ℝ, x ≠ 0 → evenLift G x = phi1 x := by
    intro x hx
    have habs : 0 < |x| := abs_pos.2 hx
    have hexp : Real.exp (Real.log |x|) = |x| := Real.exp_log habs
    rw [evenLift, hG]
    simp only []
    rw [hexp, smul_smul]
    rw [inv_mul_cancel₀ (by positivity : Real.sqrt (2 * |x|) ≠ 0), one_smul]
    by_cases h : 0 ≤ x
    · rw [abs_of_nonneg h]
    · push_neg at h
      rw [abs_of_neg h, hphi1even]
  have hliftae : evenLift G =ᵐ[volume] phi1 := by
    have hne : ∀ᵐ x : ℝ, x ≠ 0 := by
      rw [ae_iff]
      simp
    filter_upwards [hne] with x hx using hlift x hx
  have hGmemLp : MemLp G 2 volume := by
    refine ⟨hGmeas.aestronglyMeasurable, ?_⟩
    have hnorm : eLpNorm (evenLift G) 2 volume = eLpNorm G 2 volume := eLpNorm_evenLift hGmeas
    have h1 : eLpNorm (evenLift G) 2 volume = eLpNorm phi0 2 volume :=
      eLpNorm_congr_ae (hliftae.trans hphi1ae)
    rw [← hnorm, h1]
    exact (Lp.memLp phi).2
  refine ⟨logEquiv.symm (hGmemLp.toLp G), ?_⟩
  rw [Lp.ext_iff]
  have hcoe : ((logEquiv (logEquiv.symm (hGmemLp.toLp G)) : L2R) : ℝ → ℂ) =ᵐ[volume] G := by
    rw [LinearIsometryEquiv.apply_symm_apply]
    exact MemLp.coeFn_toLp _
  have h2 : (weilMap (logEquiv.symm (hGmemLp.toLp G)) : ℝ → ℂ) =ᵐ[volume] evenLift G := by
    refine (coeFn_evenLiftLp _).trans ?_
    exact evenLift_congr_ae (Lp.stronglyMeasurable _).measurable hGmeas hcoe
  exact h2.trans (hliftae.trans hphi1ae)

theorem range_weilMap : LinearMap.range weilMap.toLinearMap = evenSubspace := by
  apply le_antisymm
  · rintro f ⟨xi, rfl⟩
    exact weilMap_mem_evenSubspace xi
  · intro f hf
    obtain ⟨xi, hxi⟩ := exists_weilMap_eq_of_mem_evenSubspace hf
    exact ⟨xi, hxi⟩

/-- **The paper's identification as a unitary onto the even subspace**:
`L²(ℝ⋆₊, d*ρ) ≃ L²(ℝ)_ev`. -/
def weilUnitary : L2Rplus ≃ₗᵢ[ℂ] evenSubspace where
  toFun xi := ⟨weilMap xi, weilMap_mem_evenSubspace xi⟩
  map_add' xi eta := by
    apply Subtype.ext
    simp
  map_smul' c xi := by
    apply Subtype.ext
    simp
  norm_map' xi := weilMap.norm_map xi
  invFun := fun phi => Classical.choose (exists_weilMap_eq_of_mem_evenSubspace phi.2)
  left_inv := by
    intro xi
    have h := Classical.choose_spec
      (exists_weilMap_eq_of_mem_evenSubspace (weilMap_mem_evenSubspace xi))
    exact weilMap.injective h
  right_inv := by
    intro phi
    have h := Classical.choose_spec (exists_weilMap_eq_of_mem_evenSubspace phi.2)
    exact Subtype.ext h

/-! ## The intertwining with the scaling representation -/

/-- **`w` intertwines the regular representation of `ℝ⋆₊` with the scaling representation**
`(ϑ(λ)ξ)(x) = λ^{-1/2} ξ(λ^{-1}x)` of the paper. -/
theorem coeFn_weilMap_scaling (lam : Rplus) (xi : L2Rplus) :
    (weilMap (scaling lam xi) : ℝ → ℂ)
      =ᵐ[volume] fun x => ((Real.sqrt (lam : ℝ))⁻¹ : ℝ) • (weilMap xi : ℝ → ℂ)
        ((lam : ℝ)⁻¹ * x) := by
  have hlam : (0:ℝ) < (lam : ℝ) := lam.2
  -- the left-hand side
  have hL : (weilMap (scaling lam xi) : ℝ → ℂ) =ᵐ[volume] fun x =>
      ((Real.sqrt (2 * |x|))⁻¹ : ℝ) • (xi : Rplus → ℂ) (lam⁻¹ * Rplus.expHomeo (Real.log |x|)) := by
    refine (coeFn_weilMap (scaling lam xi)).trans ?_
    have hcoe : ((scaling lam xi : L2Rplus) : Rplus → ℂ)
        =ᵐ[Rplus.haar] fun rho => (xi : Rplus → ℂ) (lam⁻¹ * rho) := coeFn_scalingₗᵢ lam xi
    have hpull : (fun t : ℝ => ((scaling lam xi : L2Rplus) : Rplus → ℂ) (Rplus.expHomeo t))
        =ᵐ[volume] fun t => (xi : Rplus → ℂ) (lam⁻¹ * Rplus.expHomeo t) :=
      hcoe.comp_tendsto measurePreserving_expHomeo.quasiMeasurePreserving.tendsto_ae
    have hpull2 := evenLift_congr_ae
      (((Lp.stronglyMeasurable (scaling lam xi)).measurable).comp
        Rplus.expHomeo.continuous.measurable)
      (((Lp.stronglyMeasurable xi).measurable).comp
        ((continuous_const.mul Rplus.expHomeo.continuous).measurable)) hpull
    exact hpull2
  -- the right-hand side
  have hRae : (fun x : ℝ => (weilMap xi : ℝ → ℂ) ((lam : ℝ)⁻¹ * x))
      =ᵐ[volume] fun x => ((Real.sqrt (2 * |(lam : ℝ)⁻¹ * x|))⁻¹ : ℝ) •
        (xi : Rplus → ℂ) (Rplus.expHomeo (Real.log |(lam : ℝ)⁻¹ * x|)) := by
    have hqmp : Measure.QuasiMeasurePreserving (fun x : ℝ => (lam : ℝ)⁻¹ * x) volume volume := by
      refine ⟨measurable_const_mul _, ?_⟩
      rw [Real.map_volume_mul_left (by positivity : ((lam : ℝ)⁻¹) ≠ 0)]
      exact Measure.smul_absolutelyContinuous
    exact (coeFn_weilMap xi).comp_tendsto hqmp.tendsto_ae
  refine hL.trans ?_
  filter_upwards [hRae] with x hx
  rw [hx]
  by_cases hx0 : x = 0
  · subst hx0; simp
  · have habs : 0 < |x| := abs_pos.2 hx0
    have habs2 : |(lam : ℝ)⁻¹ * x| = (lam : ℝ)⁻¹ * |x| := by
      rw [abs_mul, abs_of_pos (by positivity : (0:ℝ) < (lam : ℝ)⁻¹)]
    have harg : Rplus.expHomeo (Real.log |(lam : ℝ)⁻¹ * x|)
        = lam⁻¹ * Rplus.expHomeo (Real.log |x|) := by
      apply Subtype.ext
      show Real.exp (Real.log |(lam : ℝ)⁻¹ * x|) = (lam : ℝ)⁻¹ * Real.exp (Real.log |x|)
      rw [Real.exp_log (by rw [habs2]; positivity), Real.exp_log habs, habs2]
    have hsq : Real.sqrt (2 * |(lam : ℝ)⁻¹ * x|)
        = (Real.sqrt (lam : ℝ))⁻¹ * Real.sqrt (2 * |x|) := by
      rw [habs2, show (2 : ℝ) * ((lam : ℝ)⁻¹ * |x|) = (lam : ℝ)⁻¹ * (2 * |x|) by ring,
        Real.sqrt_mul (by positivity), Real.sqrt_inv]
    have hlpos : 0 < Real.sqrt (lam : ℝ) := Real.sqrt_pos.2 hlam
    have hxpos : 0 < Real.sqrt (2 * |x|) := Real.sqrt_pos.2 (by positivity)
    rw [harg, smul_smul]
    congr 1
    rw [hsq]
    field_simp

/-! ## The cutoff projections preserve the even subspace -/

theorem P1_mem_evenSubspace {f : L2R} (hf : f ∈ evenSubspace) : P1 f ∈ evenSubspace := by
  refine mem_evenSubspace_of_ae ?_
  have h1 : ((P1 f : L2R) : ℝ → ℂ) =ᵐ[volume] cutoffInterval.indicator (f : ℝ → ℂ) :=
    coeFn_cutoff measurableSet_cutoffInterval f
  have hneg : (fun x : ℝ => (P1 f : ℝ → ℂ) (-x))
      =ᵐ[volume] fun x => cutoffInterval.indicator (f : ℝ → ℂ) (-x) :=
    h1.comp_tendsto (Measure.measurePreserving_neg volume).quasiMeasurePreserving.tendsto_ae
  have hfneg := ae_neg_of_mem_evenSubspace hf
  filter_upwards [h1, hneg, hfneg] with x h2 h3 h4
  rw [h2, h3]
  by_cases hx : x ∈ cutoffInterval
  · have hx' : -x ∈ cutoffInterval := by
      simp only [cutoffInterval, Set.mem_Icc] at hx ⊢
      constructor <;> linarith [hx.1, hx.2]
    rw [Set.indicator_of_mem hx, Set.indicator_of_mem hx', h4]
  · have hx' : -x ∉ cutoffInterval := by
      simp only [cutoffInterval, Set.mem_Icc] at hx ⊢
      intro h
      exact hx ⟨by linarith [h.2], by linarith [h.1]⟩
    rw [Set.indicator_of_notMem hx, Set.indicator_of_notMem hx']

end ConnesConsani.WeilPositivity
