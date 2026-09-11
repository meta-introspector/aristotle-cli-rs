/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**Evaluation of the semi-local trace density and the archimedean Weil kernel**, for
arXiv:2006.13771 (Connes–Consani, *Weil positivity and Trace formula – the archimedean
place*).

`RequestProject/SemiLocalKernel.lean` computes the semi-local trace density exactly as a
phase integral,

  `κ_Λ(a) = Tr(D_a S^{(Λ)}) = √a ∫_{|x| ≤ Λ} ∫_{v ∈ B_Λ(a)} e^{2πi (a-1) v x} dv dx`,

`B_Λ(a) = {v : |v| ≤ Λ, |a v| ≤ Λ}`.  Here we evaluate the two integrals in closed form:

  `κ_Λ(a) = √a · (2 / (π (a-1))) · Si(2π (a-1) Λ² / max(1,a))`     (`a ≠ 1`),

and deduce the limit

  `κ_Λ(a) → √a / |a - 1|`  as  `Λ → ∞`.

Written in terms of the scaling representation `ϑ(λ) = D_{λ⁻¹}` this is

  `Tr(ϑ(λ) S^{(Λ)}) → λ^{1/2} / |1 - λ|`,

i.e. **the archimedean kernel of the Weil distribution**
(`WeilDistribution_explicit` in the skeleton) is recovered as the `Λ → ∞` limit of the
semi-local trace density of the cut-off Sonin sandwich.
-/
import RequestProject.Imported.OutputFinal.RequestProject.SemiLocalKernel
import RequestProject.Imported.OutputFinal.RequestProject.SiAsymptotic
import RequestProject.Imported.OutputFinal.RequestProject.SiPositivity

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Real Set Filter Topology FourierTransform intervalIntegral

namespace ConnesConsani.WeilPositivity

/-! ## 1. The symmetric phase integral -/

/-- `∫_{-m}^{m} e^{2πi c v} dv = sin(2π c m) / (π c)` for `c ≠ 0`. -/
theorem integral_fourierChar_symm {c : ℝ} (hc : c ≠ 0) {m : ℝ} (hm : 0 ≤ m) :
    ∫ v in Set.Icc (-m) m, ((𝐞 (c * v) : Circle) : ℂ)
      = ((Real.sin (2 * π * c * m) / (π * c) : ℝ) : ℂ) := by
  have hle : -m ≤ m := by linarith
  have h1 : ∫ v in Set.Icc (-m) m, ((𝐞 (c * v) : Circle) : ℂ)
      = ∫ v in (-m)..m, ((𝐞 (c * v) : Circle) : ℂ) := by
    rw [intervalIntegral.integral_of_le hle, MeasureTheory.integral_Icc_eq_integral_Ioc]
  rw [h1]
  have hrw : ∀ v : ℝ, ((𝐞 (c * v) : Circle) : ℂ)
      = Complex.exp ((2 * π * c * Complex.I) * (v : ℂ)) := by
    intro v
    rw [Real.fourierChar_apply]
    congr 1
    push_cast
    ring
  simp_rw [hrw]
  have hne : (2 * π * c * Complex.I) ≠ 0 := by
    simp [Complex.ext_iff, Real.pi_ne_zero, hc]
  rw [integral_exp_mul_complex hne]
  set w : ℂ := ((2 * π * c * m : ℝ) : ℂ) with hw
  have e1 : (2 * π * c * Complex.I) * ((m : ℝ) : ℂ) = w * Complex.I := by
    rw [hw]; push_cast; ring
  have e2 : (2 * π * c * Complex.I) * ((-m : ℝ) : ℂ) = (-w) * Complex.I := by
    rw [hw]; push_cast; ring
  rw [e1, e2, Complex.exp_mul_I, Complex.exp_mul_I, Complex.cos_neg, Complex.sin_neg]
  have hsin : Complex.sin w = ((Real.sin (2 * π * c * m) : ℝ) : ℂ) := by
    rw [hw, ← Complex.ofReal_sin]
  rw [hsin]
  have hpi : (π : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
  have hcc : (c : ℂ) ≠ 0 := by exact_mod_cast hc
  push_cast
  field_simp
  ring

/-! ## 2. The symmetric sine-integral -/

/-- `∫_{-Λ}^{Λ} sin(K x)/x dx = 2 Si(K Λ)`. -/
theorem integral_sin_div_symm (K : ℝ) {cut : ℝ} (hcut : 0 ≤ cut) :
    ∫ x in Set.Icc (-cut) cut, Real.sin (K * x) / x = 2 * Si (K * cut) := by
  have hle : -cut ≤ cut := by linarith
  have h1 : ∫ x in Set.Icc (-cut) cut, Real.sin (K * x) / x
      = ∫ x in (-cut)..cut, Real.sin (K * x) / x := by
    rw [intervalIntegral.integral_of_le hle, MeasureTheory.integral_Icc_eq_integral_Ioc]
  rw [h1]
  rcases eq_or_ne K 0 with rfl | hK
  · simp
  · have hae : ∫ x in (-cut)..cut, Real.sin (K * x) / x
        = ∫ x in (-cut)..cut, K * Real.sinc (K * x) := by
      refine intervalIntegral.integral_congr_ae ?_
      have h0 : ∀ᵐ t : ℝ, t ≠ 0 := by rw [MeasureTheory.ae_iff]; simp
      filter_upwards [h0] with t ht _
      rw [Real.sinc_of_ne_zero (by simp [hK, ht])]
      field_simp
    rw [hae, intervalIntegral.integral_const_mul,
      intervalIntegral.integral_comp_mul_left (f := Real.sinc) hK]
    have hsplit : ∫ x in (K * -cut)..(K * cut), Real.sinc x = Si (K * cut) - Si (K * -cut) := by
      rw [Si, Si, ← intervalIntegral.integral_interval_sub_left
        (Real.continuous_sinc.intervalIntegrable _ _) (Real.continuous_sinc.intervalIntegrable _ _)]
    rw [hsplit]
    have hneg : K * -cut = -(K * cut) := by ring
    rw [hneg, Si_neg, smul_eq_mul]
    field_simp
    ring

/-! ## 3. The band is a symmetric interval -/

/-- The dilation band `{v : |v| ≤ Λ, |a v| ≤ Λ}` is the symmetric interval of half-width
`Λ / max(1,a)`. -/
theorem dilBand_eq_Icc {cut : ℝ} (hcut : 0 ≤ cut) {a : ℝ} (ha : 0 < a) :
    dilBand cut a = Set.Icc (-(cut / max 1 a)) (cut / max 1 a) := by
  have hmin : min cut (cut / a) = cut / max 1 a := by
    rcases le_total a 1 with h | h
    · rw [max_eq_left h, div_one, min_eq_left (by rw [le_div_iff₀ ha]; nlinarith)]
    · rw [max_eq_right h, min_eq_right (by rw [div_le_iff₀ ha]; nlinarith)]
  have key : ∀ v : ℝ, (v ∈ dilBand cut a ↔ |v| ≤ min cut (cut / a)) := by
    intro v
    simp only [dilBand, cutoffSet, Set.mem_inter_iff, Set.mem_preimage, Set.mem_Icc, ← abs_le,
      abs_mul, abs_of_pos ha, le_min_iff]
    rw [and_congr_right_iff]
    intro _
    rw [← le_div_iff₀' ha]
  ext v
  rw [key v, hmin, Set.mem_Icc]
  exact abs_le

/-! ## 4. Closed form of the semi-local trace density -/

variable {ι : Type*}

/-- **Closed form of the semi-local trace density.**

  `Tr(D_a S^{(Λ)}) = √a · (2 / (π (a-1))) · Si(2π (a-1) Λ² / max(1,a))`   for `a ≠ 1`. -/
theorem semiLocalDensity_eq_Si [Countable ι] (b : HilbertBasis ι ℂ L2R)
    {cut : ℝ} (hcut : 0 ≤ cut) (a : Rplus) (ha : (a : ℝ) ≠ 1) :
    semiLocalDensity b cut a
      = ((Real.sqrt (a : ℝ) * (2 / (π * ((a : ℝ) - 1))) *
          Si (2 * π * ((a : ℝ) - 1) * (cut / max 1 (a : ℝ)) * cut) : ℝ) : ℂ) := by
  have ha0 : (0:ℝ) < (a : ℝ) := a.2
  have hA1 : ((a : ℝ) - 1) ≠ 0 := sub_ne_zero.2 ha
  have hmax : (0:ℝ) < max 1 (a : ℝ) := lt_of_lt_of_le zero_lt_one (le_max_left _ _)
  set m : ℝ := cut / max 1 (a : ℝ) with hmdef
  have hm : 0 ≤ m := div_nonneg hcut hmax.le
  set K : ℝ := 2 * π * ((a : ℝ) - 1) * m with hKdef
  rw [semiLocalDensity_eq_double_integral b cut a, dilBand_eq_Icc hcut ha0]
  have hinner : ∀ x : ℝ, x ≠ 0 →
      (∫ v in Set.Icc (-m) m, ((𝐞 (((a : ℝ) - 1) * (v * x)) : Circle) : ℂ))
        = ((Real.sin (K * x) / (π * ((a : ℝ) - 1)) / x : ℝ) : ℂ) := by
    intro x hx
    have hrw : ∀ v : ℝ, ((a : ℝ) - 1) * (v * x) = (((a : ℝ) - 1) * x) * v := by
      intro v; ring
    simp_rw [hrw]
    rw [integral_fourierChar_symm (mul_ne_zero hA1 hx) hm]
    congr 1
    rw [hKdef]
    have hK2 : 2 * π * (((a : ℝ) - 1) * x) * m = 2 * π * ((a : ℝ) - 1) * m * x := by ring
    rw [hK2]
    field_simp
  have hcongr : ∫ x in cutoffSet cut,
        (∫ v in Set.Icc (-m) m, ((𝐞 (((a : ℝ) - 1) * (v * x)) : Circle) : ℂ))
      = ∫ x in cutoffSet cut, ((Real.sin (K * x) / (π * ((a : ℝ) - 1)) / x : ℝ) : ℂ) := by
    refine setIntegral_congr_ae (measurableSet_cutoffSet cut) ?_
    have h0 : ∀ᵐ x : ℝ, x ≠ 0 := by rw [MeasureTheory.ae_iff]; simp
    filter_upwards [h0] with x hx _
    exact hinner x hx
  rw [hcongr, integral_complex_ofReal]
  have hset : cutoffSet cut = Set.Icc (-cut) cut := rfl
  rw [hset]
  have hg : ∀ x : ℝ, Real.sin (K * x) / (π * ((a : ℝ) - 1)) / x
      = (π * ((a : ℝ) - 1))⁻¹ * (Real.sin (K * x) / x) := by
    intro x; field_simp
  simp_rw [hg]
  rw [MeasureTheory.integral_const_mul, integral_sin_div_symm K hcut, hKdef]
  push_cast
  field_simp

/-! ## 5. The limit `Λ → ∞`: the archimedean Weil kernel -/

/-- `Si` tends to `-π/2` at `-∞`. -/
theorem tendsto_Si_atBot : Tendsto Si atBot (𝓝 (-(π / 2))) := by
  have h : Tendsto (fun x : ℝ => -Si x) atBot (𝓝 (π / 2)) := by
    simpa [Function.comp_def, Si_neg] using
      tendsto_Si_atTop.comp (Filter.tendsto_neg_atBot_atTop (G := ℝ))
  simpa using h.neg

/-- **The semi-local trace density converges to the archimedean Weil kernel**:
`Tr(D_a S^{(Λ)}) → √a / |a - 1|` as `Λ → ∞`, for every `a ≠ 1`. -/
theorem tendsto_semiLocalDensity_atTop [Countable ι] (b : HilbertBasis ι ℂ L2R)
    (a : Rplus) (ha : (a : ℝ) ≠ 1) :
    Tendsto (fun cut : ℝ => semiLocalDensity b cut a) atTop
      (𝓝 ((Real.sqrt (a : ℝ) / |(a : ℝ) - 1| : ℝ) : ℂ)) := by
  have ha0 : (0:ℝ) < (a : ℝ) := a.2
  have hA1 : ((a : ℝ) - 1) ≠ 0 := sub_ne_zero.2 ha
  have hmax : (0:ℝ) < max 1 (a : ℝ) := lt_of_lt_of_le zero_lt_one (le_max_left _ _)
  set A : ℝ := (a : ℝ) with hA
  set c : ℝ := 2 * π * (A - 1) / max 1 A with hc
  set Kc : ℝ := Real.sqrt A * (2 / (π * (A - 1))) with hKc
  have hsq : Tendsto (fun cut : ℝ => cut ^ 2) atTop atTop := tendsto_pow_atTop (by norm_num)
  have hreal : Tendsto (fun cut : ℝ => Kc * Si (c * cut ^ 2)) atTop
      (𝓝 (Real.sqrt A / |A - 1|)) := by
    rcases lt_or_gt_of_ne ha with hlt | hgt
    · have hAlt : A - 1 < 0 := by simp only [hA]; linarith
      have hcneg : c < 0 := by
        rw [hc]
        exact div_neg_of_neg_of_pos (by nlinarith [Real.pi_pos]) hmax
      have h1 : Tendsto (fun cut : ℝ => c * cut ^ 2) atTop atBot := by
        have h := Tendsto.const_mul_atTop (neg_pos.2 hcneg) hsq
        simpa [Function.comp_def] using tendsto_neg_atTop_atBot.comp h
      have h2 := (tendsto_Si_atBot.comp h1).const_mul Kc
      have hval : Kc * -(π / 2) = Real.sqrt A / |A - 1| := by
        rw [abs_of_neg hAlt, hKc]
        field_simp
      simpa [Function.comp_def, hval] using h2
    · have hAgt : 0 < A - 1 := by simp only [hA]; linarith
      have hcpos : 0 < c := by
        rw [hc]
        exact div_pos (by nlinarith [Real.pi_pos]) hmax
      have h1 : Tendsto (fun cut : ℝ => c * cut ^ 2) atTop atTop :=
        Tendsto.const_mul_atTop hcpos hsq
      have h2 := (tendsto_Si_atTop.comp h1).const_mul Kc
      have hval : Kc * (π / 2) = Real.sqrt A / |A - 1| := by
        rw [abs_of_pos hAgt, hKc]
        field_simp
      simpa [Function.comp_def, hval] using h2
  have hcomplex : Tendsto (fun cut : ℝ => ((Kc * Si (c * cut ^ 2) : ℝ) : ℂ)) atTop
      (𝓝 ((Real.sqrt A / |A - 1| : ℝ) : ℂ)) :=
    (Complex.continuous_ofReal.tendsto _).comp hreal
  refine hcomplex.congr' ?_
  filter_upwards [eventually_ge_atTop (0:ℝ)] with cut hcut
  rw [semiLocalDensity_eq_Si b hcut a ha, hKc]
  norm_cast
  congr 2
  rw [hc]
  field_simp
  ring

/-- **The archimedean Weil kernel from the local trace formula.**  In terms of the scaling
representation `ϑ(λ) = D_{λ⁻¹}`,

  `Tr(ϑ(λ) S^{(Λ)}) → λ^{1/2} / |1 - λ|`  as `Λ → ∞`,

which is exactly the kernel `ρ^{1/2} / |1 - ρ|` of the archimedean Weil distribution away
from `λ = 1` (`WeilDistribution_explicit` in the paper's skeleton). -/
theorem tendsto_semiLocalDensity_scaling [Countable ι] (b : HilbertBasis ι ℂ L2R)
    (lam : Rplus) (hlam : (lam : ℝ) ≠ 1) :
    Tendsto (fun cut : ℝ => semiLocalDensity b cut lam⁻¹) atTop
      (𝓝 ((Real.sqrt (lam : ℝ) / |1 - (lam : ℝ)| : ℝ) : ℂ)) := by
  have hl : (0:ℝ) < (lam : ℝ) := lam.2
  have hinv : ((lam⁻¹ : Rplus) : ℝ) = (lam : ℝ)⁻¹ := rfl
  have hne : ((lam⁻¹ : Rplus) : ℝ) ≠ 1 := by
    rw [hinv]
    intro h
    refine hlam ?_
    field_simp at h
    linarith
  have h := tendsto_semiLocalDensity_atTop b lam⁻¹ hne
  rw [hinv] at h
  convert h using 3
  rw [Real.sqrt_inv, show (lam : ℝ)⁻¹ - 1 = (1 - (lam : ℝ)) / (lam : ℝ) by field_simp,
    abs_div, abs_of_pos hl]
  have hs : Real.sqrt (lam : ℝ) ≠ 0 := Real.sqrt_ne_zero'.2 hl
  have habs : |1 - (lam : ℝ)| ≠ 0 := by
    simp only [ne_eq, abs_eq_zero, sub_eq_zero]
    exact fun h' => hlam h'.symm
  field_simp
  rw [Real.sq_sqrt hl.le]

/-! ## 6. A uniform bound, valid for every cut-off -/

/-- **The semi-local trace density is uniformly dominated by the Weil kernel** away from
`a = 1`: `|Tr(D_a S^{(Λ)})| ≤ (2 Si(π)/π) · √a / |a - 1|`, with a bound independent of the
cut-off `Λ`.  (Contrast the diagonal `a = 1`, where the density is `4Λ²`.) -/
theorem norm_semiLocalDensity_le [Countable ι] (b : HilbertBasis ι ℂ L2R)
    {cut : ℝ} (hcut : 0 ≤ cut) (a : Rplus) (ha : (a : ℝ) ≠ 1) :
    ‖semiLocalDensity b cut a‖ ≤ (2 * Si π / π) * (Real.sqrt (a : ℝ) / |(a : ℝ) - 1|) := by
  have hpi : (0:ℝ) < π := Real.pi_pos
  have hA1 : |(a : ℝ) - 1| > 0 := abs_pos.2 (sub_ne_zero.2 ha)
  rw [semiLocalDensity_eq_Si b hcut a ha, Complex.norm_real, Real.norm_eq_abs, abs_mul, abs_mul,
    abs_of_nonneg (Real.sqrt_nonneg _)]
  have habs : |2 / (π * ((a : ℝ) - 1))| = 2 / (π * |(a : ℝ) - 1|) := by
    rw [abs_div, abs_mul, abs_of_pos hpi]
    norm_num
  rw [habs]
  have hstep : Real.sqrt (a : ℝ) * (2 / (π * |(a : ℝ) - 1|)) *
      |Si (2 * π * ((a : ℝ) - 1) * (cut / max 1 (a : ℝ)) * cut)|
      ≤ Real.sqrt (a : ℝ) * (2 / (π * |(a : ℝ) - 1|)) * Si π := by
    gcongr
    exact abs_Si_le_Si_pi _
  refine hstep.trans_eq ?_
  field_simp

/-! ## 7. The kernel in logarithmic coordinates -/

/-- In logarithmic coordinates `λ = e^u` the archimedean Weil kernel is
`1 / (2 sinh(|u|/2))`. -/
theorem weilKernel_exp {u : ℝ} (hu : u ≠ 0) :
    Real.sqrt (Real.exp u) / |1 - Real.exp u| = 1 / (2 * Real.sinh (|u| / 2)) := by
  have hs : Real.sqrt (Real.exp u) = Real.exp (u / 2) := by
    rw [show Real.exp u = Real.exp (u / 2) * Real.exp (u / 2) by rw [← Real.exp_add]; ring_nf,
      Real.sqrt_mul_self (Real.exp_pos _).le]
  have hsq : Real.exp (u / 2) ^ 2 = Real.exp u := by
    rw [← Real.exp_nat_mul]; ring_nf
  rw [hs, Real.sinh_eq]
  rcases lt_or_gt_of_ne hu with h | h
  · have he : Real.exp u < 1 := by rw [show (1:ℝ) = Real.exp 0 by simp]; exact Real.exp_lt_exp.2 h
    rw [abs_of_neg h, abs_of_pos (by linarith), show -u / 2 = -(u / 2) by ring,
      show -(-(u / 2)) = u / 2 by ring, Real.exp_neg]
    have hpos : (0:ℝ) < Real.exp (u / 2) := Real.exp_pos _
    field_simp
    rw [hsq]
  · have he : 1 < Real.exp u := by rw [show (1:ℝ) = Real.exp 0 by simp]; exact Real.exp_lt_exp.2 h
    rw [abs_of_pos h, abs_of_neg (by linarith), Real.exp_neg]
    have hpos : (0:ℝ) < Real.exp (u / 2) := Real.exp_pos _
    field_simp
    rw [hsq]
    have h1 : (1:ℝ) - Real.exp u ≠ 0 := by intro hc; linarith
    have h2 : Real.exp u - 1 ≠ 0 := by intro hc; linarith
    field_simp
    ring

/-- **The archimedean Weil kernel in logarithmic coordinates.**  For `u ≠ 0`,

  `Tr(ϑ(e^u) S^{(Λ)}) → 1 / (2 sinh(|u|/2))`  as `Λ → ∞`. -/
theorem tendsto_semiLocalDensity_log [Countable ι] (b : HilbertBasis ι ℂ L2R)
    {u : ℝ} (hu : u ≠ 0) :
    Tendsto (fun cut : ℝ => semiLocalDensity b cut (⟨Real.exp u, Real.exp_pos u⟩ : Rplus)⁻¹)
      atTop (𝓝 ((1 / (2 * Real.sinh (|u| / 2)) : ℝ) : ℂ)) := by
  have hne : ((⟨Real.exp u, Real.exp_pos u⟩ : Rplus) : ℝ) ≠ 1 := by
    intro h
    exact hu ((Real.exp_eq_one_iff u).1 h)
  have h := tendsto_semiLocalDensity_scaling b ⟨Real.exp u, Real.exp_pos u⟩ hne
  rwa [show ((⟨Real.exp u, Real.exp_pos u⟩ : Rplus) : ℝ) = Real.exp u from rfl,
    weilKernel_exp hu] at h

end ConnesConsani.WeilPositivity
