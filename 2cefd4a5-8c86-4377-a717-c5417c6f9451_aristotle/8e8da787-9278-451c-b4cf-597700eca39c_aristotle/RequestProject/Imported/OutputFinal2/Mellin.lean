/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The convolution `*`-algebra of `ℝ⋆₊` in logarithmic coordinates, its Fourier–Mellin
transform, and the differential operator `Q = -(ρ∂ρ)² + 1/4` of §3 of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771.
-/
import RequestProject.Imported.OutputFinal2.Basic

noncomputable section

open MeasureTheory Set Real Complex
open scoped Convolution

namespace ConnesConsani.WeilPositivity

/-! ## The Fourier–Mellin transform

We work in logarithmic coordinates `ρ = e^t`, in which the group `ℝ⋆₊` becomes the
additive group `ℝ`, the Haar measure `d*ρ` becomes the Lebesgue measure `dt`, and the
Mellin transform `f ↦ ∫ f(ρ) ρ^z d*ρ` becomes the two–sided Laplace transform
`F ↦ ∫ F(t) e^{zt} dt`.  The characters of `ℝ⋆₊` correspond to the purely imaginary
values of `z`.
-/

/-- The Fourier–Mellin transform in logarithmic coordinates:
`mellinLog F z = ∫ F(t) e^{z t} dt`. -/
def mellinLog (F : ℝ → ℂ) (z : ℂ) : ℂ := ∫ t : ℝ, F t * Complex.exp (z * t)

/-- The Mellin transform of a function on `ℝ⋆₊`: `mellinMul f z = ∫ f(ρ) ρ^z d*ρ`. -/
def mellinMul (f : Rplus → ℂ) (z : ℂ) : ℂ := ∫ ρ, f ρ * ((ρ : ℝ) : ℂ) ^ z ∂(Rplus.haar)

/-- `(e^t)^z = e^{zt}`. -/
theorem cpow_exp (t : ℝ) (z : ℂ) : ((Real.exp t : ℝ) : ℂ) ^ z = Complex.exp (z * t) := by
  rw [Complex.cpow_def_of_ne_zero (by simp : ((Real.exp t : ℝ) : ℂ) ≠ 0),
    Complex.ofReal_exp, Complex.log_exp (by simp [Real.pi_pos]) (by simp [Real.pi_pos.le])]
  ring_nf

/-- The two transforms agree under the change of variables `ρ = e^t`. -/
theorem mellinMul_eq_mellinLog (f : Rplus → ℂ) (z : ℂ) :
    mellinMul f z = mellinLog (fun t => f (Rplus.expHomeo t)) z := by
  rw [mellinMul, Rplus.integral_haar, mellinLog]
  refine integral_congr_ae (Filter.Eventually.of_forall fun t => ?_)
  show f (Rplus.expHomeo t) * ((Real.exp t : ℝ) : ℂ) ^ z
    = f (Rplus.expHomeo t) * Complex.exp (z * t)
  rw [cpow_exp]

/-- Integrability of the integrand defining `mellinLog`, for a continuous compactly
supported function. -/
theorem integrable_mellinLog {F : ℝ → ℂ} (hF : Continuous F) (hsupp : HasCompactSupport F)
    (z : ℂ) : Integrable (fun t : ℝ => F t * Complex.exp (z * t)) := by
  refine Continuous.integrable_of_hasCompactSupport
    (hF.mul (Complex.continuous_exp.comp (by fun_prop))) ?_
  exact hsupp.mul_right

/-! ## Integration by parts: the transform intertwines `d/dt` with multiplication -/

/-- The Fourier–Mellin transform turns the derivation `ρ∂ρ = d/dt` into multiplication
by `-z`. -/
theorem mellinLog_deriv {F : ℝ → ℂ} (hF : ContDiff ℝ 1 F) (hsupp : HasCompactSupport F)
    (z : ℂ) : mellinLog (deriv F) z = -z * mellinLog F z := by
  have hderiv : ∀ x : ℝ, HasDerivAt F (deriv F x) x := fun x =>
    (hF.differentiable (by norm_num) x).hasDerivAt
  have hv : ∀ x : ℝ, HasDerivAt (fun t : ℝ => Complex.exp (z * t))
      (z * Complex.exp (z * x)) x := by
    intro x
    have h1 : HasDerivAt (fun t : ℝ => z * (t : ℂ)) z x := by
      simpa using (Complex.ofRealCLM.hasDerivAt (x := x)).const_mul z
    simpa [mul_comm] using h1.cexp
  have hcont : Continuous (deriv F) := hF.continuous_deriv le_rfl
  have hi1 : Integrable (F * fun x : ℝ => z * Complex.exp (z * x)) := by
    refine ((integrable_mellinLog hF.continuous hsupp z).const_mul z).congr
      (Filter.Eventually.of_forall fun t => ?_)
    show z * (F t * Complex.exp (z * t)) = F t * (z * Complex.exp (z * t))
    ring
  have hi2 : Integrable (deriv F * fun x : ℝ => Complex.exp (z * x)) :=
    integrable_mellinLog hcont hsupp.deriv z
  have hi3 : Integrable (F * fun x : ℝ => Complex.exp (z * x)) :=
    integrable_mellinLog hF.continuous hsupp z
  have key := MeasureTheory.integral_mul_deriv_eq_deriv_mul_of_integrable
    hderiv hv hi1 hi2 hi3
  have hL : ∫ x : ℝ, F x * (z * Complex.exp (z * x)) = z * mellinLog F z := by
    rw [mellinLog, ← integral_const_mul]
    exact integral_congr_ae (Filter.Eventually.of_forall fun t => by ring)
  rw [hL] at key
  have hfin : ∫ x : ℝ, deriv F x * Complex.exp (z * x) = -z * mellinLog F z := by
    rw [neg_mul, key]; ring
  rw [mellinLog, hfin]

/-! ## The operator `Q = -(ρ∂ρ)² + 1/4` -/

/-- The operator `Q = -(ρ∂ρ)² + 1/4` of §3 of the paper, in logarithmic coordinates. -/
def Qlog (F : ℝ → ℂ) : ℝ → ℂ := fun t => -deriv (deriv F) t + F t / 4

/-- `Q` preserves supports: `Q f` is supported in the (closed) support of `f`.  This is the
statement that `Q` is a differential operator, used in the paper to keep the support of the
test functions inside a fixed interval. -/
theorem support_Qlog_subset (F : ℝ → ℂ) : Function.support (Qlog F) ⊆ tsupport F := by
  intro t ht
  by_contra hts
  have hopen : IsOpen (tsupport F)ᶜ := isClosed_tsupport F |>.isOpen_compl
  have hev : F =ᶠ[nhds t] fun _ => 0 :=
    Filter.eventuallyEq_of_mem (hopen.mem_nhds hts) fun z hz => image_eq_zero_of_notMem_tsupport hz
  have h1 : deriv F =ᶠ[nhds t] fun _ => 0 := by
    filter_upwards [hopen.mem_nhds hts] with z hz
    have : F =ᶠ[nhds z] fun _ => 0 :=
      Filter.eventuallyEq_of_mem (hopen.mem_nhds hz) fun w hw => image_eq_zero_of_notMem_tsupport hw
    rw [this.deriv_eq, deriv_const]
  have h2 : deriv (deriv F) t = 0 := by rw [h1.deriv_eq, deriv_const]
  exact ht (by simp [Qlog, h2, hev.eq_of_nhds])

/-- `Q` preserves compact support. -/
theorem hasCompactSupport_Qlog {F : ℝ → ℂ} (hF : HasCompactSupport F) :
    HasCompactSupport (Qlog F) :=
  HasCompactSupport.intro (K := tsupport F) hF
    (fun _ ht => Function.notMem_support.1 fun h => ht (support_Qlog_subset F h))

/-- `Q` loses two derivatives. -/
theorem contDiff_Qlog {F : ℝ → ℂ} (hF : ContDiff ℝ 4 F) : ContDiff ℝ 2 (Qlog F) := by
  have h1 : ContDiff ℝ 3 (deriv F) := hF.deriv'
  have h2 : ContDiff ℝ 2 (deriv (deriv F)) := h1.deriv'
  exact (h2.neg).add ((hF.of_le (by norm_num)).div_const 4)

/-- The Fourier–Mellin transform of `Q F` is `(1/4 - z²)` times that of `F`. -/
theorem mellinLog_Qlog {F : ℝ → ℂ} (hF : ContDiff ℝ 2 F) (hsupp : HasCompactSupport F)
    (z : ℂ) : mellinLog (Qlog F) z = (1 / 4 - z ^ 2) * mellinLog F z := by
  have hF1 : ContDiff ℝ 1 F := hF.of_le (by norm_num)
  have hd1 : ContDiff ℝ 1 (deriv F) := hF.deriv'
  have h2 : mellinLog (deriv (deriv F)) z = z ^ 2 * mellinLog F z := by
    rw [mellinLog_deriv hd1 hsupp.deriv z, mellinLog_deriv hF1 hsupp z]
    ring
  have hi1 : Integrable (fun t : ℝ => (-deriv (deriv F) t) * Complex.exp (z * t)) := by
    have := integrable_mellinLog (hd1.continuous_deriv le_rfl) hsupp.deriv.deriv z
    simpa only [neg_mul] using this.neg
  have hi2 : Integrable (fun t : ℝ => (F t / 4) * Complex.exp (z * t)) := by
    have := integrable_mellinLog hF1.continuous hsupp z
    simpa [div_eq_mul_inv, mul_comm, mul_assoc, mul_left_comm] using this.div_const 4
  have hsplit : mellinLog (Qlog F) z
      = (∫ t : ℝ, (-deriv (deriv F) t) * Complex.exp (z * t))
        + ∫ t : ℝ, (F t / 4) * Complex.exp (z * t) := by
    rw [mellinLog, ← integral_add hi1 hi2]
    exact integral_congr_ae (Filter.Eventually.of_forall fun t => by simp only [Qlog]; ring)
  have hA : ∫ t : ℝ, (-deriv (deriv F) t) * Complex.exp (z * t)
      = -(z ^ 2 * mellinLog F z) := by
    rw [← h2, mellinLog, ← integral_neg]
    exact integral_congr_ae (Filter.Eventually.of_forall fun t => by ring)
  have hB : ∫ t : ℝ, (F t / 4) * Complex.exp (z * t) = mellinLog F z / 4 := by
    rw [mellinLog, ← integral_div]
    exact integral_congr_ae (Filter.Eventually.of_forall fun t => by ring)
  rw [hsplit, hA, hB]
  ring

/-- The image of `Q` lies in the ideal of functions whose Fourier–Mellin transform
vanishes at `z = ±1/2` (the points `±i/2` in the dual variable). -/
theorem mellinLog_Qlog_half {F : ℝ → ℂ} (hF : ContDiff ℝ 2 F) (hsupp : HasCompactSupport F) :
    mellinLog (Qlog F) (1 / 2) = 0 ∧ mellinLog (Qlog F) (-(1 / 2)) = 0 := by
  constructor <;> rw [mellinLog_Qlog hF hsupp] <;> norm_num

/-! ## The convolution `*`-algebra -/

/-- Convolution on `ℝ⋆₊` in logarithmic coordinates. -/
def convLog (F G : ℝ → ℂ) : ℝ → ℂ :=
  F ⋆[ContinuousLinearMap.mul ℝ ℂ, volume] G

theorem convLog_apply (F G : ℝ → ℂ) (t : ℝ) :
    convLog F G t = ∫ s : ℝ, F s * G (t - s) := rfl

/-- The involution `F ↦ F*`, `F*(t) = conj (F (-t))`, i.e. `f*(ρ) = conj (f (ρ⁻¹))`. -/
def starLog (F : ℝ → ℂ) : ℝ → ℂ := fun t => starRingEnd ℂ (F (-t))

@[simp] theorem starLog_starLog (F : ℝ → ℂ) : starLog (starLog F) = F := by
  funext t; simp [starLog]

theorem continuous_starLog {F : ℝ → ℂ} (hF : Continuous F) : Continuous (starLog F) :=
  Complex.continuous_conj.comp (hF.comp continuous_neg)

theorem hasCompactSupport_starLog {F : ℝ → ℂ} (hF : HasCompactSupport F) :
    HasCompactSupport (starLog F) := by
  have h : (starLog F) = (fun z => starRingEnd ℂ z) ∘ (F ∘ (fun t : ℝ => -t)) := rfl
  rw [h]
  exact HasCompactSupport.comp_left (g := fun z : ℂ => starRingEnd ℂ z)
    (hF.comp_homeomorph (Homeomorph.neg ℝ)) (by simp)

theorem continuous_convLog {F G : ℝ → ℂ} (hF : Continuous F) (hsF : HasCompactSupport F)
    (hG : Continuous G) : Continuous (convLog F G) :=
  hsF.continuous_convolution_left _ hF hG.locallyIntegrable

theorem hasCompactSupport_convLog {F G : ℝ → ℂ} (hF : HasCompactSupport F)
    (hG : HasCompactSupport G) : HasCompactSupport (convLog F G) :=
  hF.convolution _ hG

/-- The convolution algebra of `ℝ⋆₊` is commutative. -/
theorem convLog_comm (F G : ℝ → ℂ) : convLog F G = convLog G F := by
  funext x
  rw [convLog, MeasureTheory.convolution_eq_swap, convLog_apply]
  exact integral_congr_ae (Filter.Eventually.of_forall fun t => mul_comm _ _)

/-- The convolution algebra of `ℝ⋆₊` is associative. -/
theorem convLog_assoc {F G H : ℝ → ℂ} (hF : Continuous F)
    (hG : Continuous G) (hsG : HasCompactSupport G)
    (hH : Continuous H) (hsH : HasCompactSupport H) :
    convLog (convLog F G) H = convLog F (convLog G H) := by
  funext x₀
  have hgk : ∀ x : ℝ, ConvolutionExistsAt (fun x => ‖G x‖) (fun x => ‖H x‖) x
      (ContinuousLinearMap.mul ℝ ℝ) volume :=
    hsH.norm.convolutionExists_right (ContinuousLinearMap.mul ℝ ℝ)
      hG.norm.locallyIntegrable hH.norm
  have hcnorm : Continuous ((fun x => ‖G x‖) ⋆[ContinuousLinearMap.mul ℝ ℝ, volume]
      fun x => ‖H x‖) :=
    hsG.norm.continuous_convolution_left _ hG.norm hH.norm.locallyIntegrable
  have hsnorm : HasCompactSupport ((fun x => ‖G x‖) ⋆[ContinuousLinearMap.mul ℝ ℝ, volume]
      fun x => ‖H x‖) := hsG.norm.convolution _ hsH.norm
  exact MeasureTheory.convolution_assoc (ContinuousLinearMap.mul ℝ ℂ)
    (ContinuousLinearMap.mul ℝ ℂ) (ContinuousLinearMap.mul ℝ ℂ) (ContinuousLinearMap.mul ℝ ℂ)
    (fun x y z => mul_assoc x y z) hF.aestronglyMeasurable hG.aestronglyMeasurable
    hH.aestronglyMeasurable
    (Filter.Eventually.of_forall
      (hsG.convolutionExists_right (ContinuousLinearMap.mul ℝ ℂ) hF.locallyIntegrable hG))
    (Filter.Eventually.of_forall hgk)
    (hsnorm.convolutionExists_right (ContinuousLinearMap.mul ℝ ℝ)
      hF.norm.locallyIntegrable hcnorm x₀)

/-- The involution `F ↦ F*` is an (anti)automorphism of the convolution algebra:
`(F ⋆ G)* = F* ⋆ G*`. -/
theorem starLog_convLog (F G : ℝ → ℂ) :
    starLog (convLog F G) = convLog (starLog F) (starLog G) := by
  funext t
  have hL : starLog (convLog F G) t
      = ∫ s : ℝ, starRingEnd ℂ (F s) * starRingEnd ℂ (G (-s - t)) := by
    show starRingEnd ℂ (convLog F G (-t)) = _
    rw [convLog_apply, ← integral_conj]
    refine integral_congr_ae (Filter.Eventually.of_forall fun s => ?_)
    simp only [map_mul]
    rw [show (-t - s : ℝ) = -s - t from by ring]
  have hR : convLog (starLog F) (starLog G) t
      = ∫ s : ℝ, starRingEnd ℂ (F (-s)) * starRingEnd ℂ (G (s - t)) := by
    rw [convLog_apply]
    refine integral_congr_ae (Filter.Eventually.of_forall fun s => ?_)
    show starRingEnd ℂ (F (-s)) * starRingEnd ℂ (G (-(t - s))) = _
    rw [show -(t - s) = s - t from by ring]
  have hswap : (∫ s : ℝ, starRingEnd ℂ (F (-s)) * starRingEnd ℂ (G (s - t)))
      = ∫ s : ℝ, starRingEnd ℂ (F s) * starRingEnd ℂ (G (-s - t)) := by
    have h := integral_neg_eq_self
      (fun s : ℝ => starRingEnd ℂ (F s) * starRingEnd ℂ (G (-s - t))) volume
    simpa using h
  rw [hL, hR, hswap]

/-- The Fourier–Mellin transform turns convolution into pointwise multiplication. -/
theorem mellinLog_convLog {F G : ℝ → ℂ} (hF : Continuous F) (hsF : HasCompactSupport F)
    (hG : Continuous G) (hsG : HasCompactSupport G) (z : ℂ) :
    mellinLog (convLog F G) z = mellinLog F z * mellinLog G z := by
  have hkey : ∀ t : ℝ, convLog F G t * Complex.exp (z * t)
      = convLog (fun u => F u * Complex.exp (z * u))
          (fun u => G u * Complex.exp (z * u)) t := by
    intro t
    rw [convLog_apply, convLog_apply, ← integral_mul_const]
    refine integral_congr_ae (Filter.Eventually.of_forall fun s => ?_)
    have hexp : Complex.exp (z * s) * Complex.exp (z * (t - s)) = Complex.exp (z * t) := by
      rw [← Complex.exp_add]; ring_nf
    show F s * G (t - s) * Complex.exp (z * t)
      = (F s * Complex.exp (z * s)) * (G (t - s) * Complex.exp (z * ((t - s : ℝ) : ℂ)))
    push_cast
    rw [show (F s * Complex.exp (z * s)) * (G (t - s) * Complex.exp (z * ((t : ℂ) - s)))
        = F s * G (t - s) * (Complex.exp (z * s) * Complex.exp (z * ((t : ℂ) - s))) by ring,
      hexp]
  have hFzi : Integrable (fun t => F t * Complex.exp (z * t)) := integrable_mellinLog hF hsF z
  have hGzi : Integrable (fun t => G t * Complex.exp (z * t)) := integrable_mellinLog hG hsG z
  have hconv := MeasureTheory.integral_convolution (L := ContinuousLinearMap.mul ℝ ℂ)
    (μ := volume) (ν := volume) hFzi hGzi
  rw [mellinLog, integral_congr_ae (Filter.Eventually.of_forall hkey)]
  exact hconv

/-- On the unitary characters (`z` purely imaginary) the involution corresponds to
complex conjugation of the transform. -/
theorem mellinLog_starLog (F : ℝ → ℂ) (x : ℝ) :
    mellinLog (starLog F) (Complex.I * x) = starRingEnd ℂ (mellinLog F (Complex.I * x)) := by
  have hg : ∀ t : ℝ, starLog F t * Complex.exp (Complex.I * x * t)
      = starRingEnd ℂ (F (-t) * Complex.exp (Complex.I * x * ((-t : ℝ) : ℂ))) := by
    intro t
    have hc : starRingEnd ℂ (Complex.exp (Complex.I * x * ((-t : ℝ) : ℂ)))
        = Complex.exp (Complex.I * x * t) := by
      rw [← Complex.exp_conj]
      congr 1
      simp
    simp only [starLog, map_mul]
    rw [hc]
  have h1 : (∫ a : ℝ, starRingEnd ℂ (F (-a) * Complex.exp (Complex.I * x * ((-a : ℝ) : ℂ))))
      = ∫ u : ℝ, starRingEnd ℂ (F u * Complex.exp (Complex.I * x * u)) :=
    integral_neg_eq_self
      (fun u : ℝ => starRingEnd ℂ (F u * Complex.exp (Complex.I * x * u))) volume
  rw [mellinLog, integral_congr_ae (Filter.Eventually.of_forall hg), h1,
    integral_conj, mellinLog]

/-- **Positive definiteness**: the Fourier–Mellin transform of `F ⋆ F*` is nonnegative on
the unitary characters. -/
theorem mellinLog_convLog_starLog_self {F : ℝ → ℂ} (hF : Continuous F)
    (hsF : HasCompactSupport F) (x : ℝ) :
    mellinLog (convLog F (starLog F)) (Complex.I * x)
      = ((‖mellinLog F (Complex.I * x)‖ : ℝ) : ℂ) ^ 2 := by
  rw [mellinLog_convLog hF hsF (continuous_starLog hF) (hasCompactSupport_starLog hsF),
    mellinLog_starLog, Complex.mul_conj']

theorem mellinLog_convLog_starLog_self_nonneg {F : ℝ → ℂ} (hF : Continuous F)
    (hsF : HasCompactSupport F) (x : ℝ) :
    0 ≤ (mellinLog (convLog F (starLog F)) (Complex.I * x)).re := by
  rw [mellinLog_convLog_starLog_self hF hsF, ← Complex.ofReal_pow, Complex.ofReal_re]
  positivity

/-- `Q` does not affect positive definiteness: the transform of `(QF) ⋆ (QF)*` is
`(1/4 + x²)²` times that of `F ⋆ F*` on the unitary characters. -/
theorem mellinLog_Qlog_convLog_starLog {F : ℝ → ℂ} (hF4 : ContDiff ℝ 4 F)
    (hsF : HasCompactSupport F) (x : ℝ) :
    mellinLog (convLog (Qlog F) (starLog (Qlog F))) (Complex.I * x)
      = ((1 / 4 + x ^ 2 : ℝ) : ℂ) ^ 2 * mellinLog (convLog F (starLog F)) (Complex.I * x) := by
  have hF : ContDiff ℝ 2 F := hF4.of_le (by norm_num)
  have hQcont : Continuous (Qlog F) := (contDiff_Qlog hF4).continuous
  have hQsupp : HasCompactSupport (Qlog F) := hasCompactSupport_Qlog hsF
  have hz : (1 : ℂ) / 4 - (Complex.I * x) ^ 2 = ((1 / 4 + x ^ 2 : ℝ) : ℂ) := by
    push_cast
    rw [mul_pow, Complex.I_sq]
    ring
  rw [mellinLog_convLog hQcont hQsupp (continuous_starLog hQcont)
      (hasCompactSupport_starLog hQsupp),
    mellinLog_convLog hF.continuous hsF (continuous_starLog hF.continuous)
      (hasCompactSupport_starLog hsF),
    mellinLog_starLog, mellinLog_starLog, mellinLog_Qlog hF hsF, hz, map_mul,
    Complex.conj_ofReal]
  ring

end ConnesConsani.WeilPositivity
