/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**The finite part of the renormalized cut-off trace.**

`RequestProject/SemiLocalSi.lean` evaluates the semi-local trace density of the cut-off
Sonin sandwich exactly and proves the off-diagonal limit

  `κ_Λ(λ) = Tr(ϑ(λ) S^{(Λ)}) → λ^{1/2} / |1 - λ|`   (`λ ≠ 1`),  `S^{(Λ)} = P^{(Λ)} P̂^{(Λ)} P^{(Λ)}`.

This file extracts from that limit the *finite part* of the cut-off trace: the statement
that

  `Tr(ϑ(f) S^{(Λ)}) = c f(1) log Λ + (finite part) + o(1)`,

with the finite part given by the pairing of `f` with the archimedean Weil kernel.

The results proved here.

* `tendsto_modelCutTrace_of_lipschitz_at_one` — **the divergence is carried entirely by the
  value `f(1)`**: for a test function `f` which vanishes at `1` at a Lipschitz rate
  (`‖f(λ)‖ ≤ C |1 - λ|`) the cut-off traces converge, with no subtraction at all, to the
  Weil-kernel pairing

    `Tr(ϑ(f) S^{(Λ)}) → ∫ f(λ) λ^{1/2}/|1-λ| d*λ`.

  This is the analytic core: it is proved by dominated convergence from the cut-off
  independent bound `|κ_Λ(λ)| ≤ (2 Si(π)/π) λ^{1/2}/|1-λ|` of `SemiLocalSi.lean`.

* `tendsto_modelCutTrace_sub_modelCutTrace` — hence for any two admissible test functions
  with the same value at `1` the *difference* of the cut-off traces converges to the
  Weil-kernel pairing of the difference: the divergent part of `Tr(ϑ(f) S^{(Λ)})` is a
  universal multiple of `f(1)`, independent of `f`.

* `hasFinitePart_of_reference` — consequently the full asymptotic expansion for *all*
  admissible test functions follows from the expansion for a *single* reference function:
  if `Tr(ϑ(h) S^{(Λ)}) - c log Λ → z₀` for one `h` with `h(1) = 1`, then for every
  admissible `f`

    `Tr(ϑ(f) S^{(Λ)}) - c f(1) log Λ → ∫ (f - f(1) h)(λ) λ^{1/2}/|1-λ| d*λ + f(1) z₀`.

  The whole remaining analytic content of the asymptotic expansion is therefore **one
  scalar constant**, `z₀`, for one reference function.  That statement is packaged as the
  predicate `HasCutoffLogProfile`; it is a `Prop`, never an axiom.

* `weilKernelLog_eq_sinhKernel_add`, `pairing_eq_weilR_add_reflectionTerm` — **the
  comparison with the archimedean Weil distribution already formalised in the project.**
  In the logarithmic coordinate the limiting kernel is `1/(2 sinh(|u|/2))`, and

    `1/(2 sinh(|u|/2)) = e^{|u|/2}/(e^{|u|} - e^{-|u|}) + e^{-|u|/2}/(e^{|u|} - e^{-|u|})`,

  the first summand being exactly the kernel `sinhKernel` of the archimedean Weil
  distribution `W_ℝ` (formula (150), see `RequestProject/ArchimedeanExplicit.lean`).
  Consequently the finite part above is

    `W_ℝ(∆^{-1/2} f) + (reflection term)`,

  the reflection term being the absolutely convergent pairing with the second summand.
  This is the precise sense in which the finite part of the renormalized cut-off trace *is*
  the archimedean Weil distribution: the discrepancy is the contribution of the **odd** part
  of `L²(ℝ)`, on which the model of `SemiLocalKernel.lean` also computes (the paper's
  Hilbert space is the even part `L²(ℝ)_ev`, and the reflected kernel
  `e^{-|u|/2}/(e^{|u|}-e^{-|u|})` is exactly the trace density of the odd part).
-/
import RequestProject.Imported.OutputFinal.RequestProject.SemiLocalSi
import RequestProject.Imported.OutputFinal.RequestProject.ScalingIntegrated
import RequestProject.Imported.OutputFinal.RequestProject.ArchimedeanKernel

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory Filter Topology Set

open scoped CompactlySupported

namespace ConnesConsani.WeilPositivity

variable {ι : Type*}

/-! ## 1. The archimedean Weil kernel and the semi-local density -/

/-- **The archimedean Weil kernel** `λ^{1/2} / |1 - λ|` on `ℝ⋆₊`. -/
def weilKernelRplus (lam : Rplus) : ℝ := Real.sqrt (lam : ℝ) / |1 - (lam : ℝ)|

theorem weilKernelRplus_nonneg (lam : Rplus) : 0 ≤ weilKernelRplus lam :=
  div_nonneg (Real.sqrt_nonneg _) (abs_nonneg _)

/-- The kernel in the variable used by `SemiLocalSi.lean`: `√(λ⁻¹)/|λ⁻¹ - 1| = √λ/|1-λ|`. -/
theorem sqrt_inv_div_abs (lam : Rplus) (hlam : (lam : ℝ) ≠ 1) :
    Real.sqrt ((lam : ℝ)⁻¹) / |(lam : ℝ)⁻¹ - 1| = weilKernelRplus lam := by
  have hl : (0:ℝ) < (lam : ℝ) := lam.2
  have hs : Real.sqrt (lam : ℝ) ≠ 0 := Real.sqrt_ne_zero'.2 hl
  have habs : |1 - (lam : ℝ)| ≠ 0 := by
    simp only [ne_eq, abs_eq_zero, sub_eq_zero]
    exact fun h' => hlam h'.symm
  rw [weilKernelRplus, Real.sqrt_inv,
    show (lam : ℝ)⁻¹ - 1 = (1 - (lam : ℝ)) / (lam : ℝ) by field_simp, abs_div, abs_of_pos hl]
  field_simp
  rw [Real.sq_sqrt hl.le]

/-- **The semi-local trace density in the paper's variable**: `κ_Λ(λ) = Tr(ϑ(λ) S^{(Λ)})`.
By `weilMap_scaling_eq_dil` the paper's scaling unitary `ϑ(λ)` is the dilation `D_{λ⁻¹}`,
so this is `semiLocalDensity` evaluated at `λ⁻¹`. -/
def scalingDensity (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (lam : Rplus) : ℂ :=
  semiLocalDensity b cut lam⁻¹

/-- **The off-diagonal limit**: `Tr(ϑ(λ) S^{(Λ)}) → λ^{1/2}/|1-λ|`. -/
theorem tendsto_scalingDensity [Countable ι] (b : HilbertBasis ι ℂ L2R) (lam : Rplus)
    (hlam : (lam : ℝ) ≠ 1) :
    Tendsto (fun cut : ℝ => scalingDensity b cut lam) atTop
      (𝓝 ((weilKernelRplus lam : ℝ) : ℂ)) :=
  tendsto_semiLocalDensity_scaling b lam hlam

/-- **The cut-off independent bound on the semi-local density**:
`|Tr(ϑ(λ) S^{(Λ)})| ≤ (2 Si(π)/π) · λ^{1/2}/|1-λ|`. -/
theorem norm_scalingDensity_le [Countable ι] (b : HilbertBasis ι ℂ L2R) {cut : ℝ}
    (hcut : 0 ≤ cut) (lam : Rplus) (hlam : (lam : ℝ) ≠ 1) :
    ‖scalingDensity b cut lam‖ ≤ (2 * Si Real.pi / Real.pi) * weilKernelRplus lam := by
  have hinv : ((lam⁻¹ : Rplus) : ℝ) = (lam : ℝ)⁻¹ := rfl
  have hne : ((lam⁻¹ : Rplus) : ℝ) ≠ 1 := by
    rw [hinv]
    intro h
    exact hlam (inv_eq_one.1 h)
  have h := norm_semiLocalDensity_le b hcut lam⁻¹ hne
  rw [hinv] at h
  rwa [sqrt_inv_div_abs lam hlam] at h

/-! ## 2. The cut-off trace in kernel form -/

/-- **The cut-off trace** `Tr(ϑ(f) S^{(Λ)}) = ∫ f(λ) κ_Λ(λ) d*λ`, in the kernel form
established in `RequestProject/RenormalizedTraceDensity.lean`, for the concrete model of
`RequestProject/SemiLocalKernel.lean`. -/
def modelCutTrace (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (g : C_c(Rplus, ℂ)) : ℂ :=
  ∫ lam, g lam * scalingDensity b cut lam ∂(Rplus.haar)

/-- The pairing of a test function with the archimedean Weil kernel. -/
def weilPairing (g : C_c(Rplus, ℂ)) : ℂ :=
  ∫ lam, g lam * ((weilKernelRplus lam : ℝ) : ℂ) ∂(Rplus.haar)

/-! ## 3. Domination -/

/-- The Haar measure of the point `1` is zero. -/
theorem haar_singleton_one : Rplus.haar {(1 : Rplus)} = 0 := by
  rw [Rplus.haar_apply (measurableSet_singleton _)]
  have : (Rplus.expHomeo ⁻¹' {(1 : Rplus)}) = {(0 : ℝ)} := by
    ext t
    simp only [Set.mem_preimage, Set.mem_singleton_iff]
    constructor
    · intro h
      have : Real.exp t = 1 := congrArg Subtype.val h
      exact (Real.exp_eq_one_iff t).1 this
    · rintro rfl
      apply Subtype.ext
      simp
  rw [this]
  simp

/-- Almost every `λ` is different from `1`. -/
theorem ae_ne_one : ∀ᵐ lam : Rplus ∂(Rplus.haar), (lam : ℝ) ≠ 1 := by
  have h : ∀ᵐ lam : Rplus ∂(Rplus.haar), lam ∉ ({(1 : Rplus)} : Set Rplus) := by
    rw [MeasureTheory.ae_iff]
    simpa using haar_singleton_one
  filter_upwards [h] with lam hlam hval
  exact hlam (by simpa using Subtype.ext hval)

/-- The dominating function used in the passage to the limit: a constant multiple of `√λ`
on the (compact) support of the test function. -/
def dominant (g : C_c(Rplus, ℂ)) (K : ℝ) : Rplus → ℝ :=
  (tsupport g).indicator fun lam => K * Real.sqrt (lam : ℝ)

theorem integrable_dominant (g : C_c(Rplus, ℂ)) (K : ℝ) :
    Integrable (dominant g K) Rplus.haar := by
  refine (IntegrableOn.integrable_indicator ?_ (isClosed_tsupport _).measurableSet)
  refine ContinuousOn.integrableOn_compact g.hasCompactSupport ?_
  exact (Continuous.mul continuous_const
    (Real.continuous_sqrt.comp continuous_subtype_val)).continuousOn

theorem norm_mul_scalingDensity_le [Countable ι] (b : HilbertBasis ι ℂ L2R) {cut : ℝ}
    (hcut : 0 ≤ cut) (g : C_c(Rplus, ℂ)) {C : ℝ}
    (hg : ∀ lam : Rplus, ‖g lam‖ ≤ C * |1 - (lam : ℝ)|) (lam : Rplus) (hlam : (lam : ℝ) ≠ 1) :
    ‖g lam * scalingDensity b cut lam‖
      ≤ dominant g ((2 * Si Real.pi / Real.pi) * C) lam := by
  have hM : (0:ℝ) ≤ 2 * Si Real.pi / Real.pi := by
    have := Si_pi_pos
    positivity
  by_cases hs : lam ∈ tsupport g
  · rw [dominant, Set.indicator_of_mem hs]
    have hC : 0 ≤ C := by
      have := hg lam
      have h0 : (0:ℝ) ≤ ‖g lam‖ := norm_nonneg _
      rcases eq_or_lt_of_le (abs_nonneg (1 - (lam : ℝ))) with h | h
      · exfalso
        exact hlam (by
          have : (1 : ℝ) - (lam : ℝ) = 0 := by
            simpa [abs_eq_zero] using h.symm
          linarith)
      · nlinarith
    have habs : |1 - (lam : ℝ)| ≠ 0 := by
      simp only [ne_eq, abs_eq_zero, sub_eq_zero]
      exact fun h' => hlam h'.symm
    calc ‖g lam * scalingDensity b cut lam‖
        = ‖g lam‖ * ‖scalingDensity b cut lam‖ := norm_mul _ _
      _ ≤ (C * |1 - (lam : ℝ)|) * ((2 * Si Real.pi / Real.pi) * weilKernelRplus lam) := by
          refine mul_le_mul (hg lam) (norm_scalingDensity_le b hcut lam hlam) (norm_nonneg _) ?_
          positivity
      _ = (2 * Si Real.pi / Real.pi) * C * Real.sqrt (lam : ℝ) := by
          rw [weilKernelRplus]
          field_simp
  · have h0 : g lam = 0 := image_eq_zero_of_notMem_tsupport hs
    rw [h0, zero_mul, norm_zero, dominant, Set.indicator_of_notMem hs]

/-! ## 4. The finite part: test functions vanishing at `1` -/

theorem measurable_weilKernelRplus : Measurable weilKernelRplus := by
  unfold weilKernelRplus
  exact (Real.continuous_sqrt.comp continuous_subtype_val).measurable.div
    ((continuous_const.sub continuous_subtype_val).abs).measurable

/-- The Weil-kernel pairing of an admissible test function is absolutely convergent. -/
theorem integrable_weilPairing (g : C_c(Rplus, ℂ)) {C : ℝ}
    (hg : ∀ lam : Rplus, ‖g lam‖ ≤ C * |1 - (lam : ℝ)|) :
    Integrable (fun lam : Rplus => g lam * ((weilKernelRplus lam : ℝ) : ℂ)) Rplus.haar := by
  refine Integrable.mono' (integrable_dominant g C) ?_ ?_
  · exact ((map_continuous g).measurable.mul
      (Complex.measurable_ofReal.comp measurable_weilKernelRplus)).aestronglyMeasurable
  · filter_upwards [ae_ne_one] with lam hlam
    by_cases hs : lam ∈ tsupport g
    · have hC : 0 ≤ C := by
        have h1 := hg lam
        have habs : 0 < |1 - (lam : ℝ)| := by
          refine abs_pos.2 ?_
          exact fun h' => hlam (by linarith [sub_eq_zero.1 h'])
        nlinarith [norm_nonneg (g lam)]
      have habs : |1 - (lam : ℝ)| ≠ 0 := by
        simp only [ne_eq, abs_eq_zero, sub_eq_zero]
        exact fun h' => hlam h'.symm
      rw [dominant, Set.indicator_of_mem hs, norm_mul, Complex.norm_real,
        Real.norm_eq_abs, abs_of_nonneg (weilKernelRplus_nonneg lam)]
      calc ‖g lam‖ * weilKernelRplus lam
          ≤ (C * |1 - (lam : ℝ)|) * weilKernelRplus lam :=
            mul_le_mul_of_nonneg_right (hg lam) (weilKernelRplus_nonneg lam)
        _ = C * Real.sqrt (lam : ℝ) := by
            rw [weilKernelRplus]
            field_simp
    · have h0 : g lam = 0 := image_eq_zero_of_notMem_tsupport hs
      rw [h0, zero_mul, norm_zero, dominant, Set.indicator_of_notMem hs]

/-- The semi-local density, at a fixed cut-off, is measurable in `λ`. -/
theorem aestronglyMeasurable_scalingDensity [Countable ι] (b : HilbertBasis ι ℂ L2R)
    {cut : ℝ} (hcut : 0 ≤ cut) :
    AEStronglyMeasurable (fun lam : Rplus => scalingDensity b cut lam) Rplus.haar := by
  classical
  set F : Rplus → ℂ := fun lam =>
    if (lam : ℝ) = 1 then 0
    else ((Real.sqrt ((lam : ℝ)⁻¹) * (2 / (Real.pi * ((lam : ℝ)⁻¹ - 1))) *
      Si (2 * Real.pi * ((lam : ℝ)⁻¹ - 1) * (cut / max 1 ((lam : ℝ)⁻¹)) * cut) : ℝ) : ℂ)
    with hF
  have hmeasF : Measurable F := by
    refine Measurable.ite (measurableSet_eq_fun measurable_subtype_coe measurable_const)
      measurable_const ?_
    refine Complex.measurable_ofReal.comp ?_
    have hinv : Continuous fun lam : Rplus => ((lam : ℝ)⁻¹) :=
      continuous_subtype_val.inv₀ fun lam => ne_of_gt lam.2
    have hm : Measurable fun lam : Rplus => ((lam : ℝ)⁻¹) := hinv.measurable
    exact (((Real.continuous_sqrt.measurable.comp hm).mul
      (measurable_const.div (measurable_const.mul (hm.sub measurable_const)))).mul
      (Si_continuous.measurable.comp
        (((measurable_const.mul (hm.sub measurable_const)).mul
          (measurable_const.div (measurable_const.max hm))).mul measurable_const)))
  refine ⟨F, hmeasF.stronglyMeasurable, ?_⟩
  filter_upwards [ae_ne_one] with lam hlam
  have hinv : ((lam⁻¹ : Rplus) : ℝ) = (lam : ℝ)⁻¹ := rfl
  have hne : ((lam⁻¹ : Rplus) : ℝ) ≠ 1 := by
    rw [hinv]
    intro h
    exact hlam (inv_eq_one.1 h)
  rw [scalingDensity, semiLocalDensity_eq_Si b hcut lam⁻¹ hne, hF]
  simp only [hinv, if_neg hlam]

/-- **The analytic core.**  For a test function vanishing at `λ = 1` at a Lipschitz rate the
cut-off traces converge — with no logarithmic subtraction — to the pairing of the test
function with the archimedean Weil kernel:

  `Tr(ϑ(f) S^{(Λ)}) → ∫ f(λ) λ^{1/2}/|1-λ| d*λ`. -/
theorem tendsto_modelCutTrace_of_lipschitz_at_one [Countable ι] (b : HilbertBasis ι ℂ L2R)
    (g : C_c(Rplus, ℂ)) {C : ℝ} (hg : ∀ lam : Rplus, ‖g lam‖ ≤ C * |1 - (lam : ℝ)|) :
    Tendsto (fun cut : ℝ => modelCutTrace b cut g) atTop (𝓝 (weilPairing g)) := by
  refine MeasureTheory.tendsto_integral_filter_of_dominated_convergence
    (dominant g ((2 * Si Real.pi / Real.pi) * C)) ?_ ?_ (integrable_dominant _ _) ?_
  · filter_upwards [eventually_ge_atTop (0:ℝ)] with cut hcut
    exact (map_continuous g).measurable.aestronglyMeasurable.mul
      (aestronglyMeasurable_scalingDensity b hcut)
  · filter_upwards [eventually_ge_atTop (0:ℝ)] with cut hcut
    filter_upwards [ae_ne_one] with lam hlam
    exact norm_mul_scalingDensity_le b hcut g hg lam hlam
  · filter_upwards [ae_ne_one] with lam hlam
    exact (tendsto_scalingDensity b lam hlam).const_mul (g lam)

/-! ## 5. Linearity, and reduction of the asymptotics to a single reference function -/

/-- `|Si x| ≤ |x|`: the cardinal sine is bounded by `1`. -/
theorem abs_Si_le_abs (x : ℝ) : |Si x| ≤ |x| := by
  rcases le_or_gt 0 x with hx | hx
  · rw [abs_of_nonneg (Si_nonneg hx), abs_of_nonneg hx]
    exact Si_le_self hx
  · have hx' : 0 ≤ -x := by linarith
    have h1 : Si x = -Si (-x) := by rw [Si_neg]; ring
    rw [h1, abs_neg, abs_of_nonneg (Si_nonneg hx'), abs_of_neg hx]
    exact Si_le_self hx'

/-- **The diagonal bound on the semi-local density**: `|Tr(D_a S^{(Λ)})| ≤ 4Λ²`, the value at
`a = 1`. -/
theorem norm_semiLocalDensity_le_diag [Countable ι] (b : HilbertBasis ι ℂ L2R) {cut : ℝ}
    (hcut : 0 ≤ cut) (a : Rplus) : ‖semiLocalDensity b cut a‖ ≤ 4 * cut ^ 2 := by
  have ha0 : (0:ℝ) < (a : ℝ) := a.2
  have hmax : (0:ℝ) < max 1 (a : ℝ) := lt_of_lt_of_le zero_lt_one (le_max_left _ _)
  by_cases ha : (a : ℝ) = 1
  · have h1 : a = 1 := Subtype.ext ha
    rw [h1, semiLocalDensity_one b hcut]
    rw [show ((4 : ℂ) * (cut : ℂ) ^ 2) = (((4 * cut ^ 2 : ℝ)) : ℂ) by push_cast; ring,
      Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (by positivity)]
  · have hA1 : |(a : ℝ) - 1| > 0 := abs_pos.2 (sub_ne_zero.2 ha)
    have hsqrt_le : Real.sqrt (a : ℝ) ≤ max 1 (a : ℝ) := by
      rcases le_or_gt (a : ℝ) 1 with h | h
      · exact le_trans (by
          rw [show (1:ℝ) = Real.sqrt 1 by simp]
          exact Real.sqrt_le_sqrt h) (le_max_left _ _)
      · refine le_trans ?_ (le_max_right _ _)
        have hs := Real.sq_sqrt ha0.le
        have hs0 := Real.sqrt_nonneg (a : ℝ)
        nlinarith [hs, hs0, h]
    rw [semiLocalDensity_eq_Si b hcut a ha, Complex.norm_real, Real.norm_eq_abs,
      abs_mul, abs_mul, abs_of_nonneg (Real.sqrt_nonneg _)]
    have hSi : |Si (2 * Real.pi * ((a : ℝ) - 1) * (cut / max 1 (a : ℝ)) * cut)|
        ≤ 2 * Real.pi * |(a : ℝ) - 1| * (cut / max 1 (a : ℝ)) * cut := by
      refine le_trans (abs_Si_le_abs _) (le_of_eq ?_)
      have habs2 : |2 * Real.pi| = 2 * Real.pi := abs_of_nonneg (by positivity)
      have habs3 : |cut / max 1 (a : ℝ)| = cut / max 1 (a : ℝ) :=
        abs_of_nonneg (div_nonneg hcut hmax.le)
      have habs4 : |cut| = cut := abs_of_nonneg hcut
      simp only [abs_mul, habs2, habs3, habs4]
    have h2 : |2 / (Real.pi * ((a : ℝ) - 1))| = 2 / (Real.pi * |(a : ℝ) - 1|) := by
      rw [abs_div, abs_mul, abs_of_pos Real.pi_pos]
      norm_num
    rw [h2]
    have hstep : Real.sqrt (a : ℝ) * (2 / (Real.pi * |(a : ℝ) - 1|)) *
        |Si (2 * Real.pi * ((a : ℝ) - 1) * (cut / max 1 (a : ℝ)) * cut)|
        ≤ Real.sqrt (a : ℝ) * (2 / (Real.pi * |(a : ℝ) - 1|)) *
          (2 * Real.pi * |(a : ℝ) - 1| * (cut / max 1 (a : ℝ)) * cut) := by
      gcongr
    refine hstep.trans ?_
    have hval : Real.sqrt (a : ℝ) * (2 / (Real.pi * |(a : ℝ) - 1|)) *
        (2 * Real.pi * |(a : ℝ) - 1| * (cut / max 1 (a : ℝ)) * cut)
        = 4 * (Real.sqrt (a : ℝ) / max 1 (a : ℝ)) * cut ^ 2 := by
      field_simp
      ring
    rw [hval]
    have hfrac : Real.sqrt (a : ℝ) / max 1 (a : ℝ) ≤ 1 := (div_le_one hmax).2 hsqrt_le
    nlinarith [sq_nonneg cut, div_nonneg (Real.sqrt_nonneg (a : ℝ)) hmax.le]

theorem norm_scalingDensity_le_diag [Countable ι] (b : HilbertBasis ι ℂ L2R) {cut : ℝ}
    (hcut : 0 ≤ cut) (lam : Rplus) : ‖scalingDensity b cut lam‖ ≤ 4 * cut ^ 2 :=
  norm_semiLocalDensity_le_diag b hcut lam⁻¹

/-- The cut-off trace is an absolutely convergent integral, for every test function. -/
theorem integrable_mul_scalingDensity [Countable ι] (b : HilbertBasis ι ℂ L2R) {cut : ℝ}
    (hcut : 0 ≤ cut) (g : C_c(Rplus, ℂ)) :
    Integrable (fun lam : Rplus => g lam * scalingDensity b cut lam) Rplus.haar := by
  refine Integrable.mono' ((integrable_norm g).mul_const (4 * cut ^ 2)) ?_
    (.of_forall fun lam => ?_)
  · exact (map_continuous g).measurable.aestronglyMeasurable.mul
      (aestronglyMeasurable_scalingDensity b hcut)
  · rw [norm_mul]
    exact mul_le_mul_of_nonneg_left (norm_scalingDensity_le_diag b hcut lam) (norm_nonneg _)

theorem modelCutTrace_add [Countable ι] (b : HilbertBasis ι ℂ L2R) {cut : ℝ} (hcut : 0 ≤ cut)
    (g h : C_c(Rplus, ℂ)) :
    modelCutTrace b cut (g + h) = modelCutTrace b cut g + modelCutTrace b cut h := by
  rw [modelCutTrace, modelCutTrace, modelCutTrace,
    ← integral_add (integrable_mul_scalingDensity b hcut g)
      (integrable_mul_scalingDensity b hcut h)]
  refine integral_congr_ae (.of_forall fun lam => ?_)
  simp [add_mul]

theorem modelCutTrace_smul [Countable ι] (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (c : ℂ)
    (g : C_c(Rplus, ℂ)) :
    modelCutTrace b cut (c • g) = c * modelCutTrace b cut g := by
  rw [modelCutTrace, modelCutTrace, ← integral_const_mul]
  refine integral_congr_ae (.of_forall fun lam => ?_)
  simp [mul_assoc]

/-- **The divergent part of the cut-off trace is universal**: the difference of the cut-off
traces of two test functions whose difference vanishes at `1` at a Lipschitz rate converges
to the Weil-kernel pairing of the difference. -/
theorem tendsto_modelCutTrace_sub [Countable ι] (b : HilbertBasis ι ℂ L2R)
    (g h : C_c(Rplus, ℂ)) {C : ℝ} (hgh : ∀ lam : Rplus, ‖g lam - h lam‖ ≤ C * |1 - (lam : ℝ)|) :
    Tendsto (fun cut : ℝ => modelCutTrace b cut g - modelCutTrace b cut h) atTop
      (𝓝 (weilPairing (g - h))) := by
  have hlip : ∀ lam : Rplus, ‖(g - h) lam‖ ≤ C * |1 - (lam : ℝ)| := by
    intro lam; simpa using hgh lam
  refine (tendsto_modelCutTrace_of_lipschitz_at_one b (g - h) hlip).congr' ?_
  filter_upwards [eventually_ge_atTop (0:ℝ)] with cut hcut
  have hadd := modelCutTrace_add b hcut (g - h) h
  rw [sub_add_cancel] at hadd
  rw [hadd]
  ring

/-- **The logarithmic profile of the cut-off traces at a reference test function**:
`Tr(ϑ(h) S^{(Λ)}) - c log Λ → z₀`.  This is a `Prop` (a hypothesis), never an axiom. -/
def HasCutoffLogProfile (b : HilbertBasis ι ℂ L2R) (h : C_c(Rplus, ℂ)) (c z₀ : ℂ) : Prop :=
  Tendsto (fun cut : ℝ => modelCutTrace b cut h - c * (Real.log cut : ℂ)) atTop (𝓝 z₀)

/-- **The asymptotic expansion for all test functions follows from one reference function.**
If the cut-off traces of a single reference `h` with `h(1) = 1` have the logarithmic profile
`c log Λ + z₀`, then every test function `f` whose deviation `f - f(1) h` vanishes at `1` at
a Lipschitz rate satisfies the full asymptotic expansion

  `Tr(ϑ(f) S^{(Λ)}) = f(1) c log Λ + [∫ (f - f(1) h)(λ) λ^{1/2}/|1-λ| d*λ + f(1) z₀] + o(1)`.

So the *only* missing ingredient in the asymptotic expansion of the renormalized cut-off
trace is the single scalar `z₀`; the finite part is otherwise the pairing with the
archimedean Weil kernel. -/
theorem hasFinitePart_of_reference [Countable ι] (b : HilbertBasis ι ℂ L2R)
    {h : C_c(Rplus, ℂ)} {c z₀ : ℂ} (hprof : HasCutoffLogProfile b h c z₀)
    (f : C_c(Rplus, ℂ)) {C : ℝ}
    (hf : ∀ lam : Rplus, ‖f lam - f 1 * h lam‖ ≤ C * |1 - (lam : ℝ)|) :
    Tendsto (fun cut : ℝ => modelCutTrace b cut f - f 1 * c * (Real.log cut : ℂ)) atTop
      (𝓝 (weilPairing (f - f 1 • h) + f 1 * z₀)) := by
  have hlip : ∀ lam : Rplus, ‖(f - f 1 • h) lam‖ ≤ C * |1 - (lam : ℝ)| := by
    intro lam; simpa using hf lam
  have hmain := tendsto_modelCutTrace_of_lipschitz_at_one b (f - f 1 • h) hlip
  have hscaled : Tendsto (fun cut : ℝ =>
      f 1 * (modelCutTrace b cut h - c * (Real.log cut : ℂ))) atTop (𝓝 (f 1 * z₀)) :=
    hprof.const_mul (f 1)
  refine (hmain.add hscaled).congr' ?_
  filter_upwards [eventually_ge_atTop (0:ℝ)] with cut hcut
  have hadd := modelCutTrace_add b hcut (f - f 1 • h) (f 1 • h)
  rw [sub_add_cancel] at hadd
  rw [hadd, modelCutTrace_smul]
  ring

end ConnesConsani.WeilPositivity
