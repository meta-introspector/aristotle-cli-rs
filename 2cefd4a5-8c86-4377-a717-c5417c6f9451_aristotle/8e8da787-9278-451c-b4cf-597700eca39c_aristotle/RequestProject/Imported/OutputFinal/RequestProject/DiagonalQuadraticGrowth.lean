/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**The diagonal density grows quadratically — `DiagLogUpperBound` is false.**

`RequestProject/SemiLocalDiagonal.lean` isolates the diagonal value

  `d(Λ) = κ_Λ(1) = Tr(S^{(Λ)}) = ‖B_Λ‖²_{HS}`,  `B_Λ = P̂^{(Λ)} P^{(Λ)}`,
  `S^{(Λ)} = P^{(Λ)} P̂^{(Λ)} P^{(Λ)}`,

of the semi-local kernel and `RequestProject/NearDiagonalKernel.lean` isolates, as a
hypothesis, the *logarithmic upper bound*

  `DiagLogUpperBound U b C` : `d(Λ) ≤ 2 log Λ + C` for all large `Λ`.

This file **disproves** that hypothesis.  The point is elementary and quantitative: the
cut-offs `P^{(Λ)} = 1_{[-Λ,Λ]}` and `P̂^{(Λ)} = 𝓕⁻¹ 1_{[-Λ,Λ]} 𝓕` are the Fourier pair of
cut-offs of a *box of phase-space area `4Λ²`*, and the trace of the sandwich is that area,
not a logarithm:

  `d(Λ) = ‖B_Λ‖²_{HS} = 4Λ²`.

We prove the lower half of this, in the sharp order of magnitude and with an explicit
constant, by exhibiting an orthonormal family of `⌊2Λ²⌋` normalized boxes of width
`h = 1/(2Λ)` inside `[-Λ, Λ]`, each of which keeps a definite fraction of its energy in the
frequency window `[-Λ, Λ]`:

* `norm_fourierIntegral_box` — `|𝓕 1_{[a, a+h]}(ξ)| = |sin(π h ξ)| / (π|ξ|)`;
* `enorm_PcutHat_boxVec_sq_ge` — hence `‖P̂^{(Λ)} v‖² ≥ 4/π²` for a normalized box `v` of
  width `1/(2Λ)`, by Jordan's inequality;
* `sum_enorm_sq_le_hsNormSq` — any orthonormal family gives a lower bound for the
  Hilbert–Schmidt norm;
* `diagDensity_ge_floor` and `diagDensity_ge_quadratic` —
  `d(Λ) ≥ (4/π²)⌊2Λ²⌋ ≥ (8/π²)Λ² − 4/π²` for `Λ ≥ 1`.

The consequences for the renormalized-trace programme are recorded at the end:

* `not_diagLogUpperBound`, `not_hasDiagLogUpperBound` — the missing estimate
  `d(Λ) ≤ 2 log Λ + C` is *false*, for every constant `C`;
* `not_hasDiagLogAsymptotics` — a fortiori `d(Λ) = 2 log Λ + c + o(1)` is false;
* `not_shortDistanceModulus_and_traceAsymptotics` — via the transfer theorem of
  `RequestProject/NearDiagonalKernel.lean`, a short-distance modulus and the expected
  trace asymptotics cannot both hold with the balance `M(Λ)·r(Λ) → 0`.

Nothing here contradicts the *trace* asymptotics `Tr(ϑ(f) S^{(Λ)}) = 2 f(1) log Λ + …`
for a test function `f` on `ℝ⋆₊`: the semi-local kernel `κ_Λ` is a positive-definite
function of `λ` whose value `4Λ²` at `λ = 1` is concentrated in a window of width `~Λ⁻²`
around the diagonal.  What is refuted is the reduction of the logarithmic divergence to the
diagonal value `d(Λ)` alone.
-/
import RequestProject.Imported.OutputFinal.RequestProject.NearDiagonalKernel

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory Real Set FourierTransform Filter Topology ContinuousLinearMap

open scoped ENNReal NNReal CompactlySupported

namespace ConnesConsani.WeilPositivity

/-! ## 1. The Fourier transform of a box -/

/-- `|e^{it} - 1| = 2|sin(t/2)|`. -/
theorem norm_cexp_ofReal_mul_I_sub_one (t : ℝ) :
    ‖Complex.exp ((t : ℂ) * Complex.I) - 1‖ = 2 * |Real.sin (t / 2)| := by
  have hnn : (0 : ℝ) ≤ 2 * |Real.sin (t / 2)| := by positivity
  have hc : Real.cos t = 1 - 2 * Real.sin (t / 2) ^ 2 := by
    have h := Real.cos_two_mul' (t / 2)
    have hpy := Real.sin_sq_add_cos_sq (t / 2)
    have h2 : (2 : ℝ) * (t / 2) = t := by ring
    rw [h2] at h
    nlinarith
  have h1 : ‖Complex.exp ((t : ℂ) * Complex.I) - 1‖ ^ 2 = (2 * |Real.sin (t / 2)|) ^ 2 := by
    rw [← Complex.normSq_eq_norm_sq]
    simp [Complex.normSq_apply, Complex.exp_mul_I, mul_pow, sq_abs, Complex.cos_ofReal_re,
      Complex.sin_ofReal_re]
    nlinarith [Real.sin_sq_add_cos_sq t]
  calc ‖Complex.exp ((t : ℂ) * Complex.I) - 1‖
      = Real.sqrt (‖Complex.exp ((t : ℂ) * Complex.I) - 1‖ ^ 2) :=
        (Real.sqrt_sq (norm_nonneg _)).symm
    _ = Real.sqrt ((2 * |Real.sin (t / 2)|) ^ 2) := by rw [h1]
    _ = 2 * |Real.sin (t / 2)| := Real.sqrt_sq hnn

/-- The Fourier integral of the indicator of a box, as an integral of a character. -/
theorem fourierIntegral_box (a h xi : ℝ) :
    𝓕 ((Set.Ico a (a + h)).indicator (fun _ => (1 : ℂ))) xi
      = ∫ x in Set.Ico a (a + h), Complex.exp ((-2 * Real.pi * Complex.I * xi) * x) := by
  rw [Real.fourier_eq, ← MeasureTheory.integral_indicator measurableSet_Ico]
  refine integral_congr_ae (.of_forall fun v => ?_)
  by_cases hv : v ∈ Set.Ico a (a + h)
  · simp only [Set.indicator_of_mem hv, Circle.smul_def, smul_eq_mul, mul_one,
      Real.fourierChar_apply, RCLike.inner_apply, conj_trivial]
    push_cast
    ring_nf
  · simp [hv]

/-- **The modulus of the Fourier transform of a box**:
`|𝓕 1_{[a, a+h]}(ξ)| = |sin(π h ξ)| / (π |ξ|)`; in particular it does not depend on the
position `a` of the box. -/
theorem norm_fourierIntegral_box (a : ℝ) {h xi : ℝ} (hh : 0 < h) (hxi : xi ≠ 0) :
    ‖𝓕 ((Set.Ico a (a + h)).indicator (fun _ => (1 : ℂ))) xi‖
      = |Real.sin (Real.pi * h * xi)| / (Real.pi * |xi|) := by
  set c : ℂ := -2 * Real.pi * Complex.I * xi with hc
  have hcne : c ≠ 0 := by
    simp [hc, Complex.ext_iff]
    intro h1
    exact absurd h1 (by positivity)
  have h1 : ∫ x in Set.Ico a (a + h), Complex.exp (c * x)
      = (Complex.exp (c * ((a : ℂ) + h)) - Complex.exp (c * a)) / c := by
    rw [setIntegral_congr_set Ico_ae_eq_Ioc, ← intervalIntegral.integral_of_le (by linarith),
      integral_exp_mul_complex hcne]
    push_cast
    ring_nf
  rw [fourierIntegral_box, h1]
  have hfac : Complex.exp (c * ((a : ℂ) + h)) - Complex.exp (c * a)
      = Complex.exp (c * a) * (Complex.exp (c * h) - 1) := by
    rw [mul_sub, ← Complex.exp_add]
    ring_nf
  have hnorm1 : ‖Complex.exp (c * a)‖ = 1 := by
    rw [hc, show (-2 * (Real.pi : ℂ) * Complex.I * xi) * a
        = ((-2 * Real.pi * xi * a : ℝ) : ℂ) * Complex.I by push_cast; ring,
      Complex.norm_exp_ofReal_mul_I]
  have hnorm2 : ‖Complex.exp (c * h) - 1‖ = 2 * |Real.sin (Real.pi * h * xi)| := by
    rw [show c * (h : ℂ) = ((-2 * Real.pi * xi * h : ℝ) : ℂ) * Complex.I by
        rw [hc]; push_cast; ring, norm_cexp_ofReal_mul_I_sub_one]
    congr 1
    rw [show (-2 * Real.pi * xi * h) / 2 = -(Real.pi * h * xi) by ring, Real.sin_neg, abs_neg]
  have hnormc : ‖c‖ = 2 * Real.pi * |xi| := by
    rw [hc]
    simp [abs_of_nonneg Real.pi_pos.le]
  rw [hfac, norm_div, norm_mul, hnorm1, hnorm2, hnormc]
  field_simp

/-- **Jordan's inequality applied to the box**: inside the frequency window `|ξ| ≤ 1/(2h)`
the transform of a box of width `h` is at least `2h/π`. -/
theorem norm_fourierIntegral_box_ge (a : ℝ) {h xi : ℝ} (hh : 0 < h) (hxi : xi ≠ 0)
    (hsmall : h * |xi| ≤ 1 / 2) :
    2 * h / Real.pi ≤ ‖𝓕 ((Set.Ico a (a + h)).indicator (fun _ => (1 : ℂ))) xi‖ := by
  have hpi := Real.pi_pos
  have hxa : 0 < |xi| := abs_pos.2 hxi
  have hjordan : 2 / Real.pi * |Real.pi * h * xi| ≤ |Real.sin (Real.pi * h * xi)| := by
    refine Real.mul_abs_le_abs_sin ?_
    rw [abs_mul, abs_mul, abs_of_pos hpi, abs_of_pos hh]
    calc Real.pi * h * |xi| = Real.pi * (h * |xi|) := by ring
      _ ≤ Real.pi * (1 / 2) := by nlinarith
      _ = Real.pi / 2 := by ring
  have habs : |Real.pi * h * xi| = Real.pi * h * |xi| := by
    rw [abs_mul, abs_mul, abs_of_pos hpi, abs_of_pos hh]
  rw [norm_fourierIntegral_box a hh hxi, le_div_iff₀ (by positivity)]
  rw [habs] at hjordan
  have : 2 / Real.pi * (Real.pi * h * |xi|) = 2 * h * |xi| := by field_simp
  rw [this] at hjordan
  calc 2 * h / Real.pi * (Real.pi * |xi|) = 2 * h * |xi| := by field_simp
    _ ≤ |Real.sin (Real.pi * h * xi)| := hjordan

/-! ## 2. Normalized boxes as elements of `L²(ℝ)` -/

/-- The `L²`-normalized box of width `h` starting at `a`. -/
def boxFun (a h : ℝ) : ℝ → ℂ :=
  (Set.Ico a (a + h)).indicator (fun _ => ((Real.sqrt h)⁻¹ : ℂ))

theorem boxFun_eq_smul (a h : ℝ) :
    boxFun a h = fun x => ((Real.sqrt h)⁻¹ : ℂ) *
      (Set.Ico a (a + h)).indicator (fun _ => (1 : ℂ)) x := by
  funext x
  by_cases hx : x ∈ Set.Ico a (a + h) <;> simp [boxFun, hx]

/-- The Fourier transform of a normalized box, in terms of that of the plain box. -/
theorem fourierIntegral_boxFun (a h xi : ℝ) :
    𝓕 (boxFun a h) xi
      = ((Real.sqrt h)⁻¹ : ℂ) * 𝓕 ((Set.Ico a (a + h)).indicator (fun _ => (1 : ℂ))) xi := by
  rw [boxFun_eq_smul, Real.fourier_eq, Real.fourier_eq, ← integral_const_mul]
  refine integral_congr_ae (.of_forall fun v => ?_)
  simp [Circle.smul_def]
  ring

/-- **Energy of a normalized box in a frequency window.**  Inside `|ξ| ≤ 1/(2h)` the
transform of the normalized box of width `h` is at least `2√h/π`. -/
theorem norm_fourierIntegral_boxFun_ge (a : ℝ) {h xi : ℝ} (hh : 0 < h) (hxi : xi ≠ 0)
    (hsmall : h * |xi| ≤ 1 / 2) :
    2 * Real.sqrt h / Real.pi ≤ ‖𝓕 (boxFun a h) xi‖ := by
  have hpi := Real.pi_pos
  have hs : 0 < Real.sqrt h := Real.sqrt_pos.2 hh
  rw [fourierIntegral_boxFun, norm_mul,
    show ‖((Real.sqrt h)⁻¹ : ℂ)‖ = (Real.sqrt h)⁻¹ by
      simp [abs_of_nonneg (Real.sqrt_nonneg h)]]
  have hb := norm_fourierIntegral_box_ge a hh hxi hsmall
  calc 2 * Real.sqrt h / Real.pi = (Real.sqrt h)⁻¹ * (2 * h / Real.pi) := by
        rw [eq_comm]
        field_simp
        nlinarith [Real.sq_sqrt hh.le]
    _ ≤ (Real.sqrt h)⁻¹ * ‖𝓕 ((Set.Ico a (a + h)).indicator (fun _ => (1 : ℂ))) xi‖ := by
        exact mul_le_mul_of_nonneg_left hb (by positivity)

theorem memLp_boxFun (a h : ℝ) : MemLp (boxFun a h) 2 volume :=
  memLp_indicator_const 2 measurableSet_Ico _ (Or.inr (by simp))

theorem integrable_boxFun (a h : ℝ) : Integrable (boxFun a h) volume := by
  rw [boxFun, integrable_indicator_iff measurableSet_Ico]
  exact integrableOn_const (by simp)

/-- The normalized box, as an element of `L²(ℝ)`. -/
def boxVec (a h : ℝ) : L2R := (memLp_boxFun a h).toLp _

theorem coeFn_boxVec (a h : ℝ) : (boxVec a h : ℝ → ℂ) =ᵐ[volume] boxFun a h :=
  MemLp.coeFn_toLp _

theorem integrable_coeFn_boxVec (a h : ℝ) : Integrable ((boxVec a h : ℝ → ℂ)) volume :=
  (integrable_boxFun a h).congr (coeFn_boxVec a h).symm

/-- The normalized box has norm one. -/
theorem norm_boxVec (a : ℝ) {h : ℝ} (hh : 0 < h) : ‖boxVec a h‖ = 1 := by
  have hsq : ‖boxVec a h‖ₑ ^ 2 = 1 := by
    rw [enorm_sq_eq_lintegral,
      lintegral_congr_ae ((coeFn_boxVec a h).mono fun x hx => by rw [hx])]
    have hpt : ∀ x, ‖boxFun a h x‖ₑ ^ 2
        = (Set.Ico a (a + h)).indicator (fun _ => (‖((Real.sqrt h)⁻¹ : ℂ)‖ₑ ^ 2)) x := by
      intro x
      by_cases hx : x ∈ Set.Ico a (a + h) <;> simp [boxFun, hx]
    rw [lintegral_congr hpt, lintegral_indicator_const measurableSet_Ico, Real.volume_Ico]
    have h1 : ‖((Real.sqrt h)⁻¹ : ℂ)‖ₑ = ENNReal.ofReal ((Real.sqrt h)⁻¹) := by
      rw [← ofReal_norm_eq_enorm]
      congr 1
      simp [abs_of_nonneg (Real.sqrt_nonneg h)]
    rw [h1, show a + h - a = h by ring, ← ENNReal.ofReal_pow (by positivity),
      ← ENNReal.ofReal_mul (by positivity),
      show ((Real.sqrt h)⁻¹) ^ 2 * h = 1 by rw [inv_pow, Real.sq_sqrt hh.le]; field_simp]
    simp
  have hn : ‖boxVec a h‖ₑ = ENNReal.ofReal ‖boxVec a h‖ := (ofReal_norm_eq_enorm _).symm
  rw [hn, ← ENNReal.ofReal_pow (norm_nonneg _)] at hsq
  have := (ENNReal.ofReal_eq_one).1 hsq
  nlinarith [norm_nonneg (boxVec a h)]

/-- Boxes sitting on disjoint intervals are orthogonal. -/
theorem inner_boxVec_eq_zero {a a' h h' : ℝ}
    (hd : Disjoint (Set.Ico a (a + h)) (Set.Ico a' (a' + h'))) :
    inner ℂ (boxVec a h) (boxVec a' h') = 0 := by
  rw [L2.inner_def, integral_congr_ae (g := fun _ => (0 : ℂ)) ?_]
  · simp
  · filter_upwards [coeFn_boxVec a h, coeFn_boxVec a' h'] with x hx hx'
    rw [hx, hx']
    by_cases hmem : x ∈ Set.Ico a (a + h)
    · have hnot : x ∉ Set.Ico a' (a' + h') := fun hc => (Set.disjoint_left.1 hd hmem) hc
      simp [boxFun, hnot]
    · simp [boxFun, hmem]

/-- A box inside the cut-off window is left untouched by the space cut-off. -/
theorem Pcut_boxVec {a h cut : ℝ} (hsub : Set.Ico a (a + h) ⊆ Set.Icc (-cut) cut) :
    Pcut cut (boxVec a h) = boxVec a h := by
  rw [Lp.ext_iff]
  filter_upwards [coeFn_cutoff (measurableSet_cutoffSet cut) (boxVec a h), coeFn_boxVec a h]
    with x hx hx'
  rw [show ((Pcut cut (boxVec a h) : L2R) : ℝ → ℂ) x = _ from hx, hx']
  by_cases hmem : x ∈ Set.Ico a (a + h)
  · rw [Set.indicator_of_mem (show x ∈ cutoffSet cut from hsub hmem), hx']
  · rw [show boxFun a h x = 0 from by simp [boxFun, hmem]]
    by_cases hc : x ∈ cutoffSet cut
    · rw [Set.indicator_of_mem hc, hx', show boxFun a h x = 0 from by simp [boxFun, hmem]]
    · rw [Set.indicator_of_notMem hc]

/-- **The frequency cut-off keeps a definite fraction of the energy of a thin box.**
For a normalized box of width `h = 1/(2Λ)` inside the window, `‖P̂^{(Λ)} v‖² ≥ 4/π²`. -/
theorem enorm_PcutHat_boxVec_sq_ge (a : ℝ) {cut : ℝ} (hcut : 0 < cut) :
    ENNReal.ofReal (4 / Real.pi ^ 2)
      ≤ ‖PcutHat cut (boxVec a (1 / (2 * cut)))‖ₑ ^ 2 := by
  have hpi := Real.pi_pos
  set h : ℝ := 1 / (2 * cut) with hdef
  have hh : 0 < h := by rw [hdef]; positivity
  have h1 : ‖PcutHat cut (boxVec a h)‖ₑ = ‖Pcut cut (fourierL2 (boxVec a h))‖ₑ := by
    rw [PcutHat, fourierConj_apply]
    simp [enorm_eq_nnnorm]
  have h2 : ‖Pcut cut (fourierL2 (boxVec a h))‖ₑ ^ 2
      = ∫⁻ x in cutoffSet cut, ‖(fourierL2 (boxVec a h) : ℝ → ℂ) x‖ₑ ^ 2 := by
    rw [enorm_sq_eq_lintegral, ← lintegral_indicator (measurableSet_cutoffSet cut)]
    refine lintegral_congr_ae ?_
    filter_upwards [coeFn_cutoff (measurableSet_cutoffSet cut) (fourierL2 (boxVec a h))]
      with x hx
    have hx' : ((Pcut cut (fourierL2 (boxVec a h)) : L2R) : ℝ → ℂ) x
        = (cutoffSet cut).indicator ((fourierL2 (boxVec a h) : L2R) : ℝ → ℂ) x := hx
    rw [hx']
    by_cases hmem : x ∈ cutoffSet cut <;> simp [hmem]
  rw [h1, h2]
  have hfl : (fourierL2 (boxVec a h) : ℝ → ℂ) =ᵐ[volume] 𝓕 (boxFun a h) := by
    refine (coeFn_fourierL2_of_integrable _ (integrable_coeFn_boxVec a h)).trans ?_
    rw [fourier_congr_ae (coeFn_boxVec a h)]
  have hne : ∀ᵐ x ∂(volume : Measure ℝ), x ≠ 0 := by rw [ae_iff]; simp
  have hae : ∀ᵐ x ∂(volume.restrict (cutoffSet cut)),
      ENNReal.ofReal (4 * h / Real.pi ^ 2)
        ≤ ‖(fourierL2 (boxVec a h) : ℝ → ℂ) x‖ₑ ^ 2 := by
    filter_upwards [ae_restrict_of_ae hfl, ae_restrict_of_ae hne,
      ae_restrict_mem (measurableSet_cutoffSet cut)] with x hx hx0 hxmem
    rw [hx]
    have hxle : |x| ≤ cut := by
      rw [abs_le]
      exact ⟨(hxmem : x ∈ Set.Icc (-cut) cut).1, (hxmem : x ∈ Set.Icc (-cut) cut).2⟩
    have hsmall : h * |x| ≤ 1 / 2 := by
      calc h * |x| ≤ h * cut := by nlinarith
        _ = 1 / 2 := by rw [hdef]; field_simp
    have hb := norm_fourierIntegral_boxFun_ge a hh hx0 hsmall
    have hsq : 4 * h / Real.pi ^ 2 ≤ ‖𝓕 (boxFun a h) x‖ ^ 2 := by
      have hnn : 0 ≤ 2 * Real.sqrt h / Real.pi := by positivity
      have hkey : (2 * Real.sqrt h / Real.pi) ^ 2 ≤ ‖𝓕 (boxFun a h) x‖ ^ 2 := by
        nlinarith [hb, hnn]
      calc 4 * h / Real.pi ^ 2 = (2 * Real.sqrt h / Real.pi) ^ 2 := by
            rw [div_pow, mul_pow, Real.sq_sqrt hh.le]; ring
        _ ≤ _ := hkey
    calc ENNReal.ofReal (4 * h / Real.pi ^ 2)
        ≤ ENNReal.ofReal (‖𝓕 (boxFun a h) x‖ ^ 2) := ENNReal.ofReal_le_ofReal hsq
      _ = ‖𝓕 (boxFun a h) x‖ₑ ^ 2 := by
          rw [← ofReal_norm_eq_enorm, ← ENNReal.ofReal_pow (norm_nonneg _)]
  calc ENNReal.ofReal (4 / Real.pi ^ 2)
      = ENNReal.ofReal (4 * h / Real.pi ^ 2) * ENNReal.ofReal (2 * cut) := by
        rw [← ENNReal.ofReal_mul (by positivity)]
        congr 1
        rw [hdef]
        field_simp
    _ = ENNReal.ofReal (4 * h / Real.pi ^ 2) * volume (cutoffSet cut) := by
        rw [cutoffSet, Real.volume_Icc, show cut - -cut = 2 * cut by ring]
    _ = ∫⁻ _ in cutoffSet cut, ENNReal.ofReal (4 * h / Real.pi ^ 2) :=
        (setLIntegral_const _ _).symm
    _ ≤ _ := lintegral_mono_ae hae

/-! ## 3. Orthonormal families bound the Hilbert–Schmidt norm from below -/

/-- **A finite orthonormal family gives a lower bound for the Hilbert–Schmidt norm.** -/
theorem sum_enorm_sq_le_hsNormSq {ι : Type*} {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℂ E] [CompleteSpace E] (b : HilbertBasis ι ℂ E) (T : E →L[ℂ] E)
    {n : ℕ} (v : Fin n → E) (hv : Orthonormal ℂ v) :
    ∑ k, ‖T (v k)‖ₑ ^ 2 ≤ hsNormSq b T := by
  classical
  have hinj : Function.Injective v := hv.linearIndependent.injective
  have hset : Orthonormal ℂ ((↑) : (Set.range v) → E) := (orthonormal_subtype_range hinj).2 hv
  obtain ⟨w, c, hsub, hc⟩ := hset.exists_hilbertBasis_extension
  set f : Fin n → w := fun k => ⟨v k, hsub (Set.mem_range_self k)⟩ with hf
  have hfinj : Function.Injective f := by
    intro i j hij
    exact hinj (by simpa [hf, Subtype.ext_iff] using hij)
  have hcv : ∀ k, c (f k) = v k := fun k => by rw [hc]
  calc ∑ k, ‖T (v k)‖ₑ ^ 2 = ∑ k, ‖T (c (f k))‖ₑ ^ 2 :=
        Finset.sum_congr rfl fun k _ => by rw [hcv k]
    _ = ∑ i ∈ Finset.image f Finset.univ, ‖T (c i)‖ₑ ^ 2 := by
        rw [Finset.sum_image (fun i _ j _ hij => hfinj hij)]
    _ ≤ ∑' i, ‖T (c i)‖ₑ ^ 2 := ENNReal.sum_le_tsum _
    _ = hsNormSq c T := by simp [hsNormSq, enorm_eq_nnnorm]
    _ = hsNormSq b T := hsNormSq_basis_indep c b T

/-! ## 4. The quadratic lower bound for the diagonal density -/

/-- The family of `n` consecutive normalized boxes of width `h` starting at `0`. -/
def boxFamily (h : ℝ) (n : ℕ) : Fin n → L2R := fun k => boxVec (k * h) h

theorem orthonormal_boxFamily {h : ℝ} (hh : 0 < h) (n : ℕ) :
    Orthonormal ℂ (boxFamily h n) := by
  rw [orthonormal_iff_ite]
  intro i j
  by_cases hij : i = j
  · subst hij
    simp [boxFamily, inner_self_eq_norm_sq_to_K, norm_boxVec _ hh]
  · rw [if_neg hij]
    refine inner_boxVec_eq_zero ?_
    rcases lt_or_gt_of_ne (fun hc : (i : ℕ) = j => hij (Fin.ext hc)) with hlt | hlt
    · rw [Set.Ico_disjoint_Ico]
      have hij' : ((i : ℕ) : ℝ) + 1 ≤ (j : ℕ) := by exact_mod_cast hlt
      have h1 : ((i : ℕ) : ℝ) * h + h ≤ (j : ℕ) * h := by nlinarith
      calc min (((i : ℕ) : ℝ) * h + h) (((j : ℕ) : ℝ) * h + h) ≤ ((i : ℕ) : ℝ) * h + h :=
            min_le_left _ _
        _ ≤ ((j : ℕ) : ℝ) * h := h1
        _ ≤ max (((i : ℕ) : ℝ) * h) (((j : ℕ) : ℝ) * h) := le_max_right _ _
    · rw [Set.Ico_disjoint_Ico]
      have hij' : ((j : ℕ) : ℝ) + 1 ≤ (i : ℕ) := by exact_mod_cast hlt
      have h1 : ((j : ℕ) : ℝ) * h + h ≤ ((i : ℕ) : ℝ) * h := by nlinarith
      calc min (((i : ℕ) : ℝ) * h + h) (((j : ℕ) : ℝ) * h + h) ≤ ((j : ℕ) : ℝ) * h + h :=
            min_le_right _ _
        _ ≤ ((i : ℕ) : ℝ) * h := h1
        _ ≤ max (((i : ℕ) : ℝ) * h) (((j : ℕ) : ℝ) * h) := le_max_left _ _

/-- **The Hilbert–Schmidt norm of `B_Λ` is at least `(4/π²)⌊2Λ²⌋`.** -/
theorem le_hsNormSq_PcutHat_comp_Pcut {ι : Type*} (b : HilbertBasis ι ℂ L2R) {cut : ℝ}
    (hcut : 1 ≤ cut) :
    (⌊2 * cut ^ 2⌋₊ : ℝ≥0∞) * ENNReal.ofReal (4 / Real.pi ^ 2)
      ≤ hsNormSq b (PcutHat cut ∘L Pcut cut) := by
  have hc0 : (0 : ℝ) < cut := lt_of_lt_of_le one_pos hcut
  set h : ℝ := 1 / (2 * cut) with hdef
  have hh : 0 < h := by rw [hdef]; positivity
  set N : ℕ := ⌊2 * cut ^ 2⌋₊ with hN
  have hNh : (N : ℝ) * h ≤ cut := by
    have h1 : (N : ℝ) ≤ 2 * cut ^ 2 := by rw [hN]; exact Nat.floor_le (by positivity)
    have h2 : (N : ℝ) * h = (N : ℝ) / (2 * cut) := by rw [hdef]; ring
    rw [h2, div_le_iff₀ (by positivity)]
    nlinarith
  have hsub : ∀ k : Fin N, Set.Ico (((k : ℕ) : ℝ) * h) (((k : ℕ) : ℝ) * h + h)
      ⊆ Set.Icc (-cut) cut := by
    intro k
    have hk1 : ((k : ℕ) : ℝ) + 1 ≤ (N : ℝ) := by exact_mod_cast Nat.succ_le_of_lt k.isLt
    have hub : ((k : ℕ) : ℝ) * h + h ≤ cut := by nlinarith
    intro x hx
    exact ⟨by nlinarith [hx.1, Nat.cast_nonneg (α := ℝ) (k : ℕ)],
      le_of_lt (lt_of_lt_of_le hx.2 hub)⟩
  have hterm : ∀ k : Fin N, ENNReal.ofReal (4 / Real.pi ^ 2)
      ≤ ‖(PcutHat cut ∘L Pcut cut) (boxFamily h N k)‖ₑ ^ 2 := by
    intro k
    have hk : (PcutHat cut ∘L Pcut cut) (boxFamily h N k)
        = PcutHat cut (boxVec (((k : ℕ) : ℝ) * h) h) := by
      simp only [ContinuousLinearMap.comp_apply, boxFamily]
      rw [Pcut_boxVec (hsub k)]
    rw [hk, hdef]
    exact enorm_PcutHat_boxVec_sq_ge _ hc0
  calc ((N : ℕ) : ℝ≥0∞) * ENNReal.ofReal (4 / Real.pi ^ 2)
      = ∑ _k : Fin N, ENNReal.ofReal (4 / Real.pi ^ 2) := by simp [Finset.sum_const]
    _ ≤ ∑ k : Fin N, ‖(PcutHat cut ∘L Pcut cut) (boxFamily h N k)‖ₑ ^ 2 :=
        Finset.sum_le_sum fun k _ => hterm k
    _ ≤ hsNormSq b (PcutHat cut ∘L Pcut cut) :=
        sum_enorm_sq_le_hsNormSq b _ (boxFamily h N) (orthonormal_boxFamily hh N)

variable {ι : Type*} (U : L2Rplus ≃ₗᵢ[ℂ] L2R)

/-- **The diagonal density is at least `(4/π²)⌊2Λ²⌋`.** -/
theorem diagDensity_ge_floor (b : HilbertBasis ι ℂ L2R) {cut : ℝ} (hcut : 1 ≤ cut) :
    (⌊2 * cut ^ 2⌋₊ : ℝ) * (4 / Real.pi ^ 2) ≤ diagDensity U b cut := by
  have hpi := Real.pi_pos
  have hfin : hsNormSq b (PcutHat cut ∘L Pcut cut) ≠ ⊤ :=
    isHilbertSchmidt_PcutHat_comp_Pcut cut b
  have hmono := ENNReal.toReal_mono hfin (le_hsNormSq_PcutHat_comp_Pcut b hcut)
  rw [diagDensity, re_traceDensityCut_one_eq_toReal]
  refine le_trans (le_of_eq ?_) hmono
  rw [ENNReal.toReal_mul, ENNReal.toReal_ofReal (by positivity)]
  simp

/-- **The diagonal density grows at least quadratically**: `d(Λ) ≥ (8/π²)Λ² − 4/π²`.
This is the exact opposite of the missing hypothesis `DiagLogUpperBound`. -/
theorem diagDensity_ge_quadratic (b : HilbertBasis ι ℂ L2R) {cut : ℝ} (hcut : 1 ≤ cut) :
    (8 / Real.pi ^ 2) * cut ^ 2 - 4 / Real.pi ^ 2 ≤ diagDensity U b cut := by
  have hpi := Real.pi_pos
  refine le_trans ?_ (diagDensity_ge_floor U b hcut)
  have hfl : 2 * cut ^ 2 - 1 ≤ (⌊2 * cut ^ 2⌋₊ : ℝ) := by
    have := Nat.lt_floor_add_one (2 * cut ^ 2)
    linarith
  have h4 : (0 : ℝ) < 4 / Real.pi ^ 2 := by positivity
  calc (8 / Real.pi ^ 2) * cut ^ 2 - 4 / Real.pi ^ 2
      = (2 * cut ^ 2 - 1) * (4 / Real.pi ^ 2) := by ring
    _ ≤ (⌊2 * cut ^ 2⌋₊ : ℝ) * (4 / Real.pi ^ 2) := mul_le_mul_of_nonneg_right hfl h4.le

/-! ## 5. Consequences: the logarithmic hypotheses are false -/

/-- **`DiagLogUpperBound` is false**: no constant `C` satisfies `d(Λ) ≤ 2 log Λ + C`
eventually. -/
theorem not_diagLogUpperBound (b : HilbertBasis ι ℂ L2R) (C : ℝ) :
    ¬ DiagLogUpperBound U b C := by
  intro hC
  obtain ⟨cut, hd, hK⟩ := (hC.and (eventually_ge_atTop (|C| + 10))).exists
  have habs : 0 ≤ |C| := abs_nonneg C
  have hCle : C ≤ |C| := le_abs_self C
  have hcut10 : (10 : ℝ) ≤ cut := by linarith
  have hc1 : (1 : ℝ) ≤ cut := by linarith
  have hlog : Real.log cut ≤ cut := by
    have := Real.log_le_sub_one_of_pos (x := cut) (by linarith)
    linarith
  have hq := diagDensity_ge_quadratic U b hc1
  have hpi4 : Real.pi ≤ 4 := Real.pi_le_four
  have hpi3 : 3 < Real.pi := Real.pi_gt_three
  have h8 : (1 : ℝ) / 2 ≤ 8 / Real.pi ^ 2 := by
    rw [le_div_iff₀ (by positivity)]; nlinarith
  have h4 : 4 / Real.pi ^ 2 ≤ 1 := by
    rw [div_le_one (by positivity)]; nlinarith
  have hlow : (1 : ℝ) / 2 * cut ^ 2 - 1 ≤ diagDensity U b cut := by nlinarith [sq_nonneg cut]
  nlinarith [hd, hlow, hlog, hcut10]

/-- **`HasDiagLogUpperBound` is false.** -/
theorem not_hasDiagLogUpperBound (b : HilbertBasis ι ℂ L2R) :
    ¬ HasDiagLogUpperBound U b := by
  rintro ⟨C, hC⟩
  exact not_diagLogUpperBound U b C hC

/-- **The conjectural diagonal asymptotics `d(Λ) = 2 log Λ + c + o(1)` is false**, for every
finite part `c`. -/
theorem not_hasDiagLogAsymptotics (b : HilbertBasis ι ℂ L2R) (c : ℝ) :
    ¬ HasDiagLogAsymptotics U b c := fun h =>
  not_diagLogUpperBound U b (c + 1) h.diagLogUpperBound

/-! ## 6. The matching upper bound `d(Λ) ≤ 4Λ²`

The elementary kernel bound of `RequestProject/CutoffFamilyHS.lean` gives, with the value
of the constant kept track of, `‖B_Λ‖²_{HS} ≤ |[-Λ,Λ]|² = 4Λ²`.  Together with
`diagDensity_ge_quadratic` this pins the true order of the diagonal density:

  `(8/π²) Λ² − 4/π² ≤ d(Λ) ≤ 4 Λ²`,

so `d(Λ) = Θ(Λ²)`, and no logarithmic asymptotics is possible. -/

/-- The `L²` mass of the indicator of `s` is `|s|`. -/
theorem enorm_cutoffConstVecOn_sq {s : Set ℝ} (hs : MeasurableSet s) (hfin : volume s ≠ ⊤) :
    ‖cutoffConstVecOn hs hfin‖ₑ ^ 2 = volume s := by
  have hae : ((cutoffConstVecOn hs hfin : L2R) : ℝ → ℂ) =ᵐ[volume]
      s.indicator (fun _ => (1 : ℂ)) := MemLp.coeFn_toLp _
  rw [enorm_sq_eq_lintegral, lintegral_congr_ae (hae.mono fun x hx => by rw [hx])]
  have hpt : ∀ x, ‖s.indicator (fun _ => (1 : ℂ)) x‖ₑ ^ 2
      = s.indicator (fun _ => (1 : ℝ≥0∞)) x := by
    intro x; by_cases hx : x ∈ s <;> simp [hx]
  rw [lintegral_congr hpt, lintegral_indicator_const hs, one_mul]

/-- **Quantitative form of `isHilbertSchmidt_cutFourierCutOn`**: `‖1_s 𝓕 1_s‖²_{HS} ≤ |s|²`. -/
theorem hsNormSq_cutFourierCutOn_le {s : Set ℝ} (hs : MeasurableSet s) (hfin : volume s ≠ ⊤)
    (b : HilbertBasis ι ℂ L2R) :
    hsNormSq b (cutoff hs ∘L fourierCLM ∘L cutoff hs) ≤ volume s * volume s := by
  classical
  refine (hsNormSq_le_of_kernel b (cutoff hs ∘L fourierCLM ∘L cutoff hs)
    (cutoffKernelVecOn hs hfin) (coeFn_cutFourierCutOn hs hfin)).trans ?_
  calc ∫⁻ x, ‖cutoffKernelVecOn hs hfin x‖ₑ ^ 2
      ≤ ∫⁻ x, s.indicator (fun _ => ‖cutoffConstVecOn hs hfin‖ₑ ^ 2) x := by
        refine lintegral_mono fun x => ?_
        by_cases hx : x ∈ s
        · rw [Set.indicator_of_mem hx]
          have hnn : (‖cutoffKernelVecOn hs hfin x‖₊ : ℝ≥0∞)
              ≤ (‖cutoffConstVecOn hs hfin‖₊ : ℝ≥0∞) := by
            exact_mod_cast norm_cutoffKernelVecOn_le hs hfin x
          simpa [enorm_eq_nnnorm] using pow_le_pow_left' hnn 2
        · rw [Set.indicator_of_notMem hx]
          simp only [cutoffKernelVecOn, if_neg hx]
          simp
    _ = ‖cutoffConstVecOn hs hfin‖ₑ ^ 2 * volume s := by rw [lintegral_indicator_const hs]
    _ = volume s * volume s := by rw [enorm_cutoffConstVecOn_sq hs hfin]

/-- **`‖B_Λ‖²_{HS} ≤ |[-Λ,Λ]|²`.** -/
theorem hsNormSq_PcutHat_comp_Pcut_le (b : HilbertBasis ι ℂ L2R) (cut : ℝ) :
    hsNormSq b (PcutHat cut ∘L Pcut cut) ≤ volume (cutoffSet cut) * volume (cutoffSet cut) := by
  have hcomp : PcutHat cut ∘L Pcut cut
      = (fourierL2.symm.toContinuousLinearEquiv : L2R →L[ℂ] L2R) ∘L
        (Pcut cut ∘L fourierCLM ∘L Pcut cut) := by
    ext xi
    simp [PcutHat, Pcut, fourierConj_apply, fourierCLM]
  rw [hcomp, hsNormSq_isometry_comp b fourierL2.symm]
  exact hsNormSq_cutFourierCutOn_le _ (volume_cutoffSet_ne_top cut) b

/-- **The diagonal density is at most `4Λ²`.**  With `diagDensity_ge_quadratic` this gives
`d(Λ) = Θ(Λ²)`. -/
theorem diagDensity_le_four_mul_sq (b : HilbertBasis ι ℂ L2R) {cut : ℝ} (hcut : 0 ≤ cut) :
    diagDensity U b cut ≤ 4 * cut ^ 2 := by
  have hvol : volume (cutoffSet cut) = ENNReal.ofReal (2 * cut) := by
    rw [cutoffSet, Real.volume_Icc]; ring_nf
  have hle := hsNormSq_PcutHat_comp_Pcut_le b cut
  rw [diagDensity, re_traceDensityCut_one_eq_toReal]
  have hfin : volume (cutoffSet cut) * volume (cutoffSet cut) ≠ ⊤ := by
    rw [hvol]; finiteness
  refine (ENNReal.toReal_mono hfin hle).trans ?_
  rw [hvol, ← ENNReal.ofReal_mul (by positivity), ENNReal.toReal_ofReal (by positivity)]
  nlinarith

/-! ## 7. Consequence for the transfer theorem

`hasDiagLogAsymptotics_of_modulus_of_traceAsymptotics` transfers the expected logarithmic
asymptotics of the *averaged traces* to the diagonal density, provided a short-distance
modulus with the balance `M(Λ)·r(Λ) → 0` is available.  Since the conclusion is now known
to be false, the two inputs are incompatible: with a modulus and a balanced bump family,
the averaged traces cannot converge after subtracting `2 log Λ`. -/

/-- **A short-distance modulus with a balanced bump family rules out the logarithmic trace
asymptotics.**  Contrapositive of `hasDiagLogAsymptotics_of_modulus_of_traceAsymptotics`
via `not_hasDiagLogAsymptotics`. -/
theorem not_traceAsymptotics_of_modulus [Countable ι] (b : HilbertBasis ι ℂ L2R) {M : ℝ → ℝ}
    (hM : ShortDistanceModulus U b M) (G : ℝ → C_c(Rplus, ℂ)) (r w : ℝ → ℝ)
    (hG : ∀ cut : ℝ, IsNonnegReal (G cut)) (hmass : ∀ cut : ℝ, l1Norm (G cut) = 1)
    (hr : ∀ cut : ℝ, ∀ lam : Rplus, (G cut) lam ≠ 0 → Rplus.logSize lam ≤ r cut)
    (hw0 : ∀ cut : ℝ, 0 ≤ w cut) (hMr : ∀ cut : ℝ, M cut * r cut ≤ w cut)
    (hw : Tendsto w atTop (𝓝 0)) (c : ℝ) :
    ¬ Tendsto (fun cut : ℝ => (cutTrace b U cut (G cut)).re - 2 * Real.log cut) atTop (𝓝 c) :=
  fun htrace => not_hasDiagLogAsymptotics U b c
    (hasDiagLogAsymptotics_of_modulus_of_traceAsymptotics U hM G r w hG hmass hr hw0 hMr hw
      htrace)

end ConnesConsani.WeilPositivity
