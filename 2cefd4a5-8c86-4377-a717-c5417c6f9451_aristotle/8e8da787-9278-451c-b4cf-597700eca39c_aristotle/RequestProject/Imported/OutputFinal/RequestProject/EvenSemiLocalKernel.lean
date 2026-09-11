/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**The semi-local trace density on the even (Sonin) subspace**, for arXiv:2006.13771
(Connes–Consani, *Weil positivity and Trace formula – the archimedean place*).

`RequestProject/SemiLocalKernel.lean` and `RequestProject/SemiLocalSi.lean` compute the
semi-local trace density of the cut-off Sonin sandwich on the *whole* of `L²(ℝ)`,

  `κ_Λ(a) = Tr(D_a S^{(Λ)}) = √a · (2/(π(a-1))) · Si(2π(a-1) Λ²/max(1,a))`.

The Hilbert space of the paper is however the **even** part `L²(ℝ)_ev` (the range of the
unitary `weilMap` of `RequestProject/EvenPicture.lean`), on which the cut-off projections and
the dilations all act.  This file computes the corresponding density

  `κ^{ev}_Λ(a) = Tr(D_a S^{(Λ)} P_ev)`,   `P_ev = (1 + R)/2`,  `(R ξ)(x) = ξ(-x)`,

exactly, by the same route as in the full-line case:

* `reflCLM`, `evenProjCLM` — the reflection and the orthogonal projection onto even
  functions, both self-adjoint (`adjoint_reflCLM`, `adjoint_evenProjCLM`);
* `reflCLM_cutKernelVec` — the reflection maps the kernel vector `k_x` of the doubly
  truncated Fourier transform `G_Λ` to `k_{-x}`;
* `evenSemiLocalDensity_eq_integral_inner` — hence, exactly as in the full-line case,
  `κ^{ev}_Λ(a) = ∫ ⟪P_ev k_x, D_a k_x⟫ dx`;
* `inner_cutKernelVec_neg_dil_of_mem` — the new kernel pairing is the phase integral with
  `a - 1` replaced by `a + 1`;
* `evenSemiLocalDensity_eq_Si` — the closed form

    `κ^{ev}_Λ(a) = ½ √a [ (2/(π(a-1))) Si(2π(a-1) Λ²/max(1,a))
                          + (2/(π(a+1))) Si(2π(a+1) Λ²/max(1,a)) ]`.

The second summand is *regular at `a = 1`*: the whole logarithmic divergence of the trace
comes from the first one, and it is halved by the projection.  This is the mechanism by
which the coefficient of `log Λ` becomes `2 f(1)` in the even picture of the paper, instead
of the `4 f(1)` of the full line.
-/
import RequestProject.Imported.OutputFinal.RequestProject.SemiLocalSi
import RequestProject.Imported.OutputFinal.RequestProject.EvenPicture

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory Real Set Filter Topology FourierTransform ContinuousLinearMap

namespace ConnesConsani.WeilPositivity

variable {ι : Type*}

/-! ## 1. The reflection and the projection onto even functions -/

/-- The reflection `(R ξ)(x) = ξ(-x)`, as a continuous linear map of `L²(ℝ)`. -/
def reflCLM : L2R →L[ℂ] L2R := reflectₗᵢ.toContinuousLinearMap

@[simp] theorem reflCLM_apply (f : L2R) : reflCLM f = reflectₗᵢ f := rfl

theorem coeFn_reflCLM (f : L2R) :
    (reflCLM f : ℝ → ℂ) =ᵐ[volume] fun x => (f : ℝ → ℂ) (-x) := coeFn_reflectₗᵢ f

theorem norm_reflCLM (f : L2R) : ‖reflCLM f‖ = ‖f‖ := reflectₗᵢ.norm_map f

/-- The reflection is self-adjoint. -/
theorem inner_reflCLM_left (f g : L2R) :
    inner ℂ (reflCLM f) g = inner ℂ f (reflCLM g) := by
  rw [L2.inner_def, L2.inner_def]
  have h1 : (fun x => inner ℂ ((reflCLM f : ℝ → ℂ) x) ((g : ℝ → ℂ) x))
      =ᵐ[volume] fun x => inner ℂ ((f : ℝ → ℂ) (-x)) ((g : ℝ → ℂ) x) := by
    filter_upwards [coeFn_reflCLM f] with x hx
    rw [hx]
  have h2 : (fun x => inner ℂ ((f : ℝ → ℂ) x) ((reflCLM g : ℝ → ℂ) x))
      =ᵐ[volume] fun x => inner ℂ ((f : ℝ → ℂ) x) ((g : ℝ → ℂ) (-x)) := by
    filter_upwards [coeFn_reflCLM g] with x hx
    rw [hx]
  rw [integral_congr_ae h1, integral_congr_ae h2,
    ← integral_neg_eq_self (fun x => inner ℂ ((f : ℝ → ℂ) x) ((g : ℝ → ℂ) (-x))) volume]
  simp

theorem adjoint_reflCLM : adjoint reflCLM = reflCLM := by
  refine ContinuousLinearMap.ext fun f => ?_
  refine ext_inner_left ℂ fun g => ?_
  rw [ContinuousLinearMap.adjoint_inner_right]
  exact inner_reflCLM_left g f

/-- **The orthogonal projection onto the even subspace** `P_ev = (1 + R)/2`. -/
def evenProjCLM : L2R →L[ℂ] L2R := (2⁻¹ : ℂ) • (ContinuousLinearMap.id ℂ L2R + reflCLM)

theorem evenProjCLM_apply (f : L2R) : evenProjCLM f = (2⁻¹ : ℂ) • (f + reflCLM f) := rfl

theorem conj_two_complex : (starRingEnd ℂ) (2 : ℂ) = 2 := Complex.conj_eq_iff_re.mpr rfl

theorem inner_evenProjCLM_left (f g : L2R) :
    inner ℂ (evenProjCLM f) g = inner ℂ f (evenProjCLM g) := by
  rw [evenProjCLM_apply, evenProjCLM_apply, inner_smul_left, inner_smul_right, inner_add_left,
    inner_add_right, inner_reflCLM_left, map_inv₀, conj_two_complex]

theorem adjoint_evenProjCLM : adjoint evenProjCLM = evenProjCLM := by
  refine ContinuousLinearMap.ext fun f => ?_
  refine ext_inner_left ℂ fun g => ?_
  rw [ContinuousLinearMap.adjoint_inner_right]
  exact inner_evenProjCLM_left g f

theorem norm_evenProjCLM_apply_le (f : L2R) : ‖evenProjCLM f‖ ≤ ‖f‖ := by
  rw [evenProjCLM_apply, norm_smul]
  have h1 : ‖f + reflCLM f‖ ≤ ‖f‖ + ‖f‖ := by
    refine le_trans (norm_add_le _ _) ?_
    rw [norm_reflCLM]
  have h2 : ‖(2⁻¹ : ℂ)‖ = 2⁻¹ := by norm_num
  rw [h2]
  nlinarith [norm_nonneg f]

/-- The range of `P_ev` is the even subspace: `P_ev` is the projection of the paper's
picture. -/
theorem evenProjCLM_mem_evenSubspace (f : L2R) : evenProjCLM f ∈ evenSubspace := by
  refine mem_evenSubspace_of_ae ?_
  have hcoe : ((evenProjCLM f : L2R) : ℝ → ℂ)
      =ᵐ[volume] fun x => (2⁻¹ : ℂ) * ((f : ℝ → ℂ) x + (f : ℝ → ℂ) (-x)) := by
    have h1 : ((evenProjCLM f : L2R) : ℝ → ℂ)
        =ᵐ[volume] fun x => (2⁻¹ : ℂ) * ((f + reflCLM f : L2R) : ℝ → ℂ) x := by
      rw [evenProjCLM_apply]
      filter_upwards [Lp.coeFn_smul (2⁻¹ : ℂ) (f + reflCLM f)] with x hx
      simpa using hx
    refine h1.trans ?_
    filter_upwards [Lp.coeFn_add f (reflCLM f), coeFn_reflCLM f] with x h2 h3
    rw [h2]
    show (2⁻¹ : ℂ) * ((f : ℝ → ℂ) x + ((reflCLM f : L2R) : ℝ → ℂ) x) = _
    rw [h3]
  have hneg : (fun x : ℝ => ((evenProjCLM f : L2R) : ℝ → ℂ) (-x))
      =ᵐ[volume] fun x => (2⁻¹ : ℂ) * ((f : ℝ → ℂ) (-x) + (f : ℝ → ℂ) x) := by
    have := hcoe.comp_tendsto
      (Measure.measurePreserving_neg volume).quasiMeasurePreserving.tendsto_ae
    filter_upwards [this] with x hx
    simpa [neg_neg] using hx
  refine hcoe.trans (EventuallyEq.symm (hneg.trans ?_))
  filter_upwards with x
  ring

/-! ## 2. The reflection on the kernel vectors -/

theorem neg_mem_cutoffSet {cut x : ℝ} (hx : x ∈ cutoffSet cut) : -x ∈ cutoffSet cut := by
  simp only [cutoffSet, Set.mem_Icc] at hx ⊢
  constructor <;> linarith [hx.1, hx.2]

theorem mem_cutoffSet_neg_iff {cut x : ℝ} : -x ∈ cutoffSet cut ↔ x ∈ cutoffSet cut :=
  ⟨fun h => by simpa using neg_mem_cutoffSet h, neg_mem_cutoffSet⟩

/-- **The reflection maps the kernel vectors of `G_Λ` onto each other**: `R k_x = k_{-x}`. -/
theorem reflCLM_cutKernelVec (cut x : ℝ) :
    reflCLM (cutKernelVec cut x) = cutKernelVec cut (-x) := by
  classical
  by_cases hx : x ∈ cutoffSet cut
  · have hnx : -x ∈ cutoffSet cut := neg_mem_cutoffSet hx
    rw [Lp.ext_iff]
    have h1 : ((cutKernelVec cut x : L2R) : ℝ → ℂ)
        =ᵐ[volume] (cutoffSet cut).indicator (unitChar x) := by
      simp only [cutKernelVec, cutoffKernelVecOn, if_pos hx]
      exact MemLp.coeFn_toLp _
    have h2 : ((cutKernelVec cut (-x) : L2R) : ℝ → ℂ)
        =ᵐ[volume] (cutoffSet cut).indicator (unitChar (-x)) := by
      simp only [cutKernelVec, cutoffKernelVecOn, if_pos hnx]
      exact MemLp.coeFn_toLp _
    have h3 : (fun v : ℝ => ((cutKernelVec cut x : L2R) : ℝ → ℂ) (-v))
        =ᵐ[volume] fun v => (cutoffSet cut).indicator (unitChar x) (-v) :=
      h1.comp_tendsto (Measure.measurePreserving_neg volume).quasiMeasurePreserving.tendsto_ae
    filter_upwards [coeFn_reflCLM (cutKernelVec cut x), h2, h3] with v hv h2v h3v
    rw [hv, h3v, h2v]
    by_cases hvs : v ∈ cutoffSet cut
    · have hnvs : -v ∈ cutoffSet cut := neg_mem_cutoffSet hvs
      rw [Set.indicator_of_mem hnvs, Set.indicator_of_mem hvs, unitChar, unitChar]
      congr 2
      ring
    · have hnvs : -v ∉ cutoffSet cut := fun h => hvs (by simpa using neg_mem_cutoffSet h)
      rw [Set.indicator_of_notMem hnvs, Set.indicator_of_notMem hvs]
  · have hnx : -x ∉ cutoffSet cut := fun h => hx (by simpa using neg_mem_cutoffSet h)
    simp only [cutKernelVec, cutoffKernelVecOn, if_neg hx, if_neg hnx, map_zero]

/-! ## 3. The trace density on the even subspace -/

/-- The kernel vectors of `G_Λ T` for a self-adjoint `T`. -/
theorem coeFn_cutFourierCut_comp_selfAdjoint (cut : ℝ) {T : L2R →L[ℂ] L2R}
    (hT : adjoint T = T) (xi : L2R) :
    ((cutFourierCut cut ∘L T) xi : ℝ → ℂ)
      =ᵐ[volume] fun x => inner ℂ (T (cutKernelVec cut x)) xi := by
  filter_upwards [coeFn_cutFourierCutFam cut (T xi)] with x hx
  rw [ContinuousLinearMap.comp_apply, hx]
  conv_rhs => rw [← hT]
  rw [ContinuousLinearMap.adjoint_inner_left]

theorem lintegral_enorm_evenProj_cutKernelVec_sq_ne_top (cut : ℝ) :
    ∫⁻ x, ‖evenProjCLM (cutKernelVec cut x)‖ₑ ^ 2 ≠ ⊤ := by
  refine ne_top_of_le_ne_top (lintegral_enorm_cutKernelVec_sq_ne_top cut) (lintegral_mono ?_)
  intro x
  have h : ‖evenProjCLM (cutKernelVec cut x)‖ₑ ≤ ‖cutKernelVec cut x‖ₑ := by
    simpa [enorm_eq_nnnorm, ← NNReal.coe_le_coe] using norm_evenProjCLM_apply_le (cutKernelVec cut x)
  exact pow_le_pow_left' h 2

/-- **The semi-local trace density on the even subspace**
`κ^{ev}_Λ(a) = Tr(D_a S^{(Λ)} P_ev)`. -/
def evenSemiLocalDensity (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (a : Rplus) : ℂ :=
  traceAlong b (dilCLM a ∘L (soninSandwichCut cut ∘L evenProjCLM))

/-- **The even semi-local trace density is an integral of kernel pairings.** -/
theorem evenSemiLocalDensity_eq_integral_inner [Countable ι] (b : HilbertBasis ι ℂ L2R)
    (cut : ℝ) (a : Rplus) :
    evenSemiLocalDensity b cut a
      = ∫ x, inner ℂ (evenProjCLM (cutKernelVec cut x)) (dil a (cutKernelVec cut x)) := by
  have hassoc : dilCLM a ∘L (soninSandwichCut cut ∘L evenProjCLM)
      = (dilCLM a ∘L adjoint (cutFourierCut cut)) ∘L (cutFourierCut cut ∘L evenProjCLM) := by
    rw [soninSandwichCut_eq_adjoint_cutFourierCut]
    simp only [ContinuousLinearMap.comp_assoc]
  have hadj : adjoint (dilCLM a ∘L adjoint (cutFourierCut cut))
      = cutFourierCut cut ∘L dilCLM a⁻¹ := by
    rw [ContinuousLinearMap.adjoint_comp, ContinuousLinearMap.adjoint_adjoint, adjoint_dilCLM]
  rw [evenSemiLocalDensity, hassoc, traceAlong_comp_eq_hsInner, hadj]
  exact hsInner_eq_integral_of_kernel b _ _ (fun x => dil a (cutKernelVec cut x))
    (fun x => evenProjCLM (cutKernelVec cut x)) (coeFn_cutFourierCut_comp_dil cut a)
    (coeFn_cutFourierCut_comp_selfAdjoint cut adjoint_evenProjCLM)
    (lintegral_enorm_dil_cutKernelVec_sq_ne_top cut a)
    (lintegral_enorm_evenProj_cutKernelVec_sq_ne_top cut)

/-! ## 4. The reflected kernel pairing -/

/-- **The reflected kernel pairing is the phase integral with `a - 1` replaced by `a + 1`**:
`⟪k_{-x}, D_a k_x⟫ = √a ∫_{v ∈ s ∩ a⁻¹ s} e^{2πi (a+1) v x} dv`. -/
theorem inner_cutKernelVec_neg_dil_of_mem (cut : ℝ) (a : Rplus) {x : ℝ}
    (hx : x ∈ cutoffSet cut) :
    inner ℂ (cutKernelVec cut (-x)) (dil a (cutKernelVec cut x))
      = (Real.sqrt (a : ℝ) : ℂ) *
        ∫ v in dilBand cut (a : ℝ), ((𝐞 (((a : ℝ) + 1) * (v * x)) : Circle) : ℂ) := by
  classical
  have hnx : -x ∈ cutoffSet cut := neg_mem_cutoffSet hx
  have hk : ((cutKernelVec cut (-x) : L2R) : ℝ → ℂ)
      =ᵐ[volume] (cutoffSet cut).indicator (unitChar (-x)) := by
    simp only [cutKernelVec, cutoffKernelVecOn, if_pos hnx]
    exact MemLp.coeFn_toLp _
  have hkx : ((cutKernelVec cut x : L2R) : ℝ → ℂ)
      =ᵐ[volume] (cutoffSet cut).indicator (unitChar x) := by
    simp only [cutKernelVec, cutoffKernelVecOn, if_pos hx]
    exact MemLp.coeFn_toLp _
  have hdil : ((dil a (cutKernelVec cut x) : L2R) : ℝ → ℂ)
      =ᵐ[volume] dilFun (a : ℝ) ((cutoffSet cut).indicator (unitChar x)) :=
    (coeFn_dilLp a _).trans (dilFun_congr_ae a.2 hkx)
  have hpt : ∀ᵐ v : ℝ ∂volume,
      (inner ℂ (((cutKernelVec cut (-x) : L2R) : ℝ → ℂ) v)
        (((dil a (cutKernelVec cut x) : L2R) : ℝ → ℂ) v) : ℂ)
        = (dilBand cut (a : ℝ)).indicator
            (fun v => (Real.sqrt (a : ℝ) : ℂ) *
              ((𝐞 (((a : ℝ) + 1) * (v * x)) : Circle) : ℂ)) v := by
    filter_upwards [hk, hdil] with v h1 h2
    rw [RCLike.inner_apply, h1, h2]
    by_cases hv : v ∈ cutoffSet cut
    · by_cases hav : (a : ℝ) * v ∈ cutoffSet cut
      · rw [Set.indicator_of_mem (show v ∈ dilBand cut (a : ℝ) from ⟨hv, hav⟩),
          Set.indicator_of_mem hv, dilFun, Set.indicator_of_mem hav]
        simp only [unitChar, starRingEnd_apply]
        have hstar : star ((𝐞 (v * -x) : Circle) : ℂ) = ((𝐞 (-(v * -x)) : Circle) : ℂ) :=
          conj_fourierChar (v * -x)
        have hsplit : ((𝐞 (((a : ℝ) + 1) * (v * x)) : Circle) : ℂ)
            = ((𝐞 ((a : ℝ) * v * x) : Circle) : ℂ) * ((𝐞 (-(v * -x)) : Circle) : ℂ) := by
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
  rw [L2.inner_def, integral_congr_ae hpt,
    integral_indicator (measurableSet_dilBand cut (a : ℝ)), integral_const_mul]

/-- Off the cut-off window the reflected pairing vanishes as well. -/
theorem inner_cutKernelVec_neg_dil_of_notMem (cut : ℝ) (a : Rplus) {x : ℝ}
    (hx : x ∉ cutoffSet cut) :
    inner ℂ (cutKernelVec cut (-x)) (dil a (cutKernelVec cut x)) = 0 := by
  classical
  have hnx : -x ∉ cutoffSet cut := fun h => hx (by simpa using neg_mem_cutoffSet h)
  simp [cutKernelVec, cutoffKernelVecOn, if_neg hnx]

/-! ## 5. The phase integral in the `x`-variable -/

/-- The `x`-section of the phase integral over the dilation band. -/
def phaseX (m c x : ℝ) : ℂ := ∫ v in Set.Icc (-m) m, ((𝐞 ((c * x) * v) : Circle) : ℂ)

theorem phaseX_eq {m c x : ℝ} (hm : 0 ≤ m) (hc : c ≠ 0) (hx : x ≠ 0) :
    phaseX m c x = ((Real.sin (2 * π * c * m * x) / (π * c) / x : ℝ) : ℂ) := by
  rw [phaseX, integral_fourierChar_symm (mul_ne_zero hc hx) hm]
  congr 1
  have h1 : 2 * π * (c * x) * m = 2 * π * c * m * x := by ring
  rw [h1]
  field_simp

theorem integrableOn_sin_div_Icc (K cut : ℝ) :
    IntegrableOn (fun x : ℝ => Real.sin (K * x) / x) (Set.Icc (-cut) cut) volume := by
  have hcont : Continuous fun x : ℝ => K * Real.sinc (K * x) :=
    continuous_const.mul (Real.continuous_sinc.comp (continuous_const.mul continuous_id))
  have hint : IntegrableOn (fun x : ℝ => K * Real.sinc (K * x)) (Set.Icc (-cut) cut) volume :=
    hcont.continuousOn.integrableOn_compact isCompact_Icc
  refine hint.congr_fun_ae ?_
  have h0 : ∀ᵐ x : ℝ, x ≠ 0 := by rw [MeasureTheory.ae_iff]; simp
  filter_upwards [ae_restrict_of_ae h0] with x hx
  rcases eq_or_ne K 0 with rfl | hK
  · simp
  · rw [Real.sinc_of_ne_zero (mul_ne_zero hK hx)]
    field_simp

/-- **The phase integral over the truncated box, in closed form.** -/
theorem integral_phaseX {cut m c : ℝ} (hcut : 0 ≤ cut) (hm : 0 ≤ m) (hc : c ≠ 0) :
    (∫ x in cutoffSet cut, phaseX m c x)
      = ((2 / (π * c) * Si (2 * π * c * m * cut) : ℝ) : ℂ) := by
  have hpi : (π : ℝ) ≠ 0 := Real.pi_ne_zero
  have hcongr : ∫ x in cutoffSet cut, phaseX m c x
      = ∫ x in cutoffSet cut,
          (((π * c)⁻¹ * (Real.sin (2 * π * c * m * x) / x) : ℝ) : ℂ) := by
    refine setIntegral_congr_ae (measurableSet_cutoffSet cut) ?_
    have h0 : ∀ᵐ x : ℝ, x ≠ 0 := by rw [MeasureTheory.ae_iff]; simp
    filter_upwards [h0] with x hx _
    rw [phaseX_eq hm hc hx]
    congr 1
    field_simp
  rw [hcongr, integral_complex_ofReal]
  have hset : cutoffSet cut = Set.Icc (-cut) cut := rfl
  rw [hset, MeasureTheory.integral_const_mul, integral_sin_div_symm _ hcut]
  congr 1
  field_simp

theorem integrableOn_phaseX {cut m c : ℝ} (hm : 0 ≤ m) (hc : c ≠ 0) :
    IntegrableOn (phaseX m c) (cutoffSet cut) volume := by
  have hreal : IntegrableOn
      (fun x : ℝ => (π * c)⁻¹ * (Real.sin (2 * π * c * m * x) / x)) (cutoffSet cut) volume :=
    (integrableOn_sin_div_Icc (2 * π * c * m) cut).const_mul _
  have hbase : IntegrableOn
      (fun x : ℝ => (((π * c)⁻¹ * (Real.sin (2 * π * c * m * x) / x) : ℝ) : ℂ))
      (cutoffSet cut) volume := hreal.ofReal
  refine hbase.congr_fun_ae ?_
  have h0 : ∀ᵐ x : ℝ, x ≠ 0 := by rw [MeasureTheory.ae_iff]; simp
  filter_upwards [ae_restrict_of_ae h0] with x hx
  rw [phaseX_eq hm hc hx]
  congr 1
  field_simp

/-! ## 6. The closed form of the even semi-local density -/

theorem dilBand_phase_eq_phaseX {cut : ℝ} (hcut : 0 ≤ cut) {a : ℝ} (ha : 0 < a) (c x : ℝ) :
    (∫ v in dilBand cut a, ((𝐞 (c * (v * x)) : Circle) : ℂ))
      = phaseX (cut / max 1 a) c x := by
  rw [dilBand_eq_Icc hcut ha, phaseX]
  refine setIntegral_congr_fun measurableSet_Icc fun v _ => ?_
  congr 2
  ring

/-- The even semi-local density as a single integral of the two phase sections. -/
theorem evenSemiLocalDensity_eq_integral_phaseX [Countable ι] (b : HilbertBasis ι ℂ L2R)
    {cut : ℝ} (hcut : 0 ≤ cut) (a : Rplus) :
    evenSemiLocalDensity b cut a
      = ∫ x in cutoffSet cut, (2⁻¹ : ℂ) * (Real.sqrt (a : ℝ) : ℂ) *
          (phaseX (cut / max 1 (a : ℝ)) ((a : ℝ) - 1) x
            + phaseX (cut / max 1 (a : ℝ)) ((a : ℝ) + 1) x) := by
  classical
  have ha0 : (0:ℝ) < (a : ℝ) := a.2
  rw [evenSemiLocalDensity_eq_integral_inner b cut a]
  have hcongr : ∀ x : ℝ,
      inner ℂ (evenProjCLM (cutKernelVec cut x)) (dil a (cutKernelVec cut x))
        = (cutoffSet cut).indicator (fun x : ℝ => (2⁻¹ : ℂ) * (Real.sqrt (a : ℝ) : ℂ) *
            (phaseX (cut / max 1 (a : ℝ)) ((a : ℝ) - 1) x
              + phaseX (cut / max 1 (a : ℝ)) ((a : ℝ) + 1) x)) x := by
    intro x
    have hsplit : inner ℂ (evenProjCLM (cutKernelVec cut x)) (dil a (cutKernelVec cut x))
        = (2⁻¹ : ℂ) * (inner ℂ (cutKernelVec cut x) (dil a (cutKernelVec cut x))
            + inner ℂ (cutKernelVec cut (-x)) (dil a (cutKernelVec cut x))) := by
      rw [evenProjCLM_apply, inner_smul_left, inner_add_left, reflCLM_cutKernelVec, map_inv₀,
        conj_two_complex]
    by_cases hx : x ∈ cutoffSet cut
    · rw [Set.indicator_of_mem hx, hsplit, inner_cutKernelVec_dil_of_mem cut a hx,
        inner_cutKernelVec_neg_dil_of_mem cut a hx,
        dilBand_phase_eq_phaseX hcut ha0, dilBand_phase_eq_phaseX hcut ha0]
      ring
    · rw [Set.indicator_of_notMem hx, hsplit, inner_cutKernelVec_dil_of_notMem cut a hx,
        inner_cutKernelVec_neg_dil_of_notMem cut a hx]
      ring
  rw [funext hcongr, integral_indicator (measurableSet_cutoffSet cut)]

/-- **Closed form of the even semi-local trace density.**

  `Tr(D_a S^{(Λ)} P_ev) = ½ √a [ (2/(π(a-1))) Si(2π(a-1) Λ²/max(1,a))
                                 + (2/(π(a+1))) Si(2π(a+1) Λ²/max(1,a)) ]`  (`a ≠ 1`).

The first summand is the full-line density `semiLocalDensity`; the second one is regular at
`a = 1`. -/
theorem evenSemiLocalDensity_eq_Si [Countable ι] (b : HilbertBasis ι ℂ L2R)
    {cut : ℝ} (hcut : 0 ≤ cut) (a : Rplus) (ha : (a : ℝ) ≠ 1) :
    evenSemiLocalDensity b cut a
      = ((2⁻¹ * (Real.sqrt (a : ℝ) * (2 / (π * ((a : ℝ) - 1))) *
            Si (2 * π * ((a : ℝ) - 1) * (cut / max 1 (a : ℝ)) * cut)
          + Real.sqrt (a : ℝ) * (2 / (π * ((a : ℝ) + 1))) *
            Si (2 * π * ((a : ℝ) + 1) * (cut / max 1 (a : ℝ)) * cut)) : ℝ) : ℂ) := by
  have ha0 : (0:ℝ) < (a : ℝ) := a.2
  have hmax : (0:ℝ) < max 1 (a : ℝ) := lt_of_lt_of_le zero_lt_one (le_max_left _ _)
  have hm : 0 ≤ cut / max 1 (a : ℝ) := div_nonneg hcut hmax.le
  have hc1 : ((a : ℝ) - 1) ≠ 0 := sub_ne_zero.2 ha
  have hc2 : ((a : ℝ) + 1) ≠ 0 := by positivity
  set m : ℝ := cut / max 1 (a : ℝ) with hmdef
  have hsplit : (∫ x in cutoffSet cut, (2⁻¹ : ℂ) * (Real.sqrt (a : ℝ) : ℂ) *
        (phaseX m ((a : ℝ) - 1) x + phaseX m ((a : ℝ) + 1) x))
      = (2⁻¹ : ℂ) * (Real.sqrt (a : ℝ) : ℂ) *
          ((∫ x in cutoffSet cut, phaseX m ((a : ℝ) - 1) x)
            + ∫ x in cutoffSet cut, phaseX m ((a : ℝ) + 1) x) := by
    rw [← MeasureTheory.integral_add (integrableOn_phaseX hm hc1)
      (integrableOn_phaseX hm hc2), ← MeasureTheory.integral_const_mul]
  rw [evenSemiLocalDensity_eq_integral_phaseX b hcut a, hsplit,
    integral_phaseX hcut hm hc1, integral_phaseX hcut hm hc2]
  push_cast
  ring

end ConnesConsani.WeilPositivity
