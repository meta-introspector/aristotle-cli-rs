/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The archimedean Weil distribution `W_ℝ` and the normalization `∆^{1/2}`, following
Appendix B and the introduction of arXiv:2006.13771.
-/
import RequestProject.Imported.OutputFinal2.Scaling

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

/-- The involution `f ↦ f♯`, `f♯(x) = x⁻¹ f(x⁻¹)`, of the introduction of the paper. -/
def sharp (f : ℝ → ℂ) : ℝ → ℂ := fun x => (x : ℂ)⁻¹ * f x⁻¹

/-- `♯` is an involution on functions on `ℝ⋆₊`. -/
theorem sharp_sharp (f : ℝ → ℂ) {x : ℝ} (hx : x ≠ 0) : sharp (sharp f) x = f x := by
  have hx' : (x : ℂ) ≠ 0 := by exact_mod_cast hx
  simp only [sharp, Complex.ofReal_inv, inv_inv]
  field_simp

/-- The archimedean Weil distribution `W_ℝ`, formula (150) of arXiv:2006.13771:
`W_ℝ(f) = (log 4π + γ) f(1) + ∫₁^∞ (f(x) + f♯(x) - 2f(1)/x) dx/(x - x⁻¹)`. -/
def WeilR (f : ℝ → ℂ) : ℂ :=
  ((Real.log (4 * π) + Real.eulerMascheroniConstant : ℝ) : ℂ) * f 1 +
    ∫ x in Ioi (1:ℝ), (f x + sharp f x - 2 * f 1 / (x : ℂ)) / ((x : ℂ) - (x : ℂ)⁻¹)

/-- The archimedean term of the Weil explicit formula with the sign convention of the
paper: `W_∞ = -W_ℝ`. -/
def Winfty (f : ℝ → ℂ) : ℂ := -WeilR f

/-- For a test function vanishing at `1` the defining formula of `W_ℝ` simplifies. -/
theorem WeilR_of_apply_one_eq_zero {f : ℝ → ℂ} (hf : f 1 = 0) :
    WeilR f = ∫ x in Ioi (1:ℝ), (f x + sharp f x) / ((x : ℂ) - (x : ℂ)⁻¹) := by
  simp only [WeilR, hf, mul_zero, zero_add, zero_div, sub_zero]

/-! ## The explicit rational form of `W_ℝ` away from `ρ = 1` -/

/-- The inversion `x ↦ x⁻¹` maps `(1, ∞)` onto `(0, 1)`. -/
theorem image_inv_Ioi_one : (fun x : ℝ => x⁻¹) '' Ioi 1 = Ioo 0 1 := by
  ext u
  constructor
  · rintro ⟨x, hx, rfl⟩
    have hx1 : (1 : ℝ) < x := hx
    exact ⟨by positivity, by
      rw [inv_lt_one₀ (by linarith)]
      exact hx1⟩
  · rintro ⟨hu0, hu1⟩
    refine ⟨u⁻¹, ?_, by simp⟩
    exact (one_lt_inv₀ hu0).2 hu1

/-- Change of variables `u = x⁻¹` between `(0,1)` and `(1,∞)`. -/
theorem integral_Ioo_zero_one_eq_integral_Ioi_one (g : ℝ → ℂ) :
    ∫ u in Ioo (0:ℝ) 1, g u = ∫ x in Ioi (1:ℝ), ((x ^ 2)⁻¹ : ℝ) • g x⁻¹ := by
  have hderiv : ∀ x ∈ Ioi (1:ℝ),
      HasDerivWithinAt (fun x : ℝ => x⁻¹) (-(x ^ 2)⁻¹) (Ioi 1) x := by
    intro x hx
    have hx0 : x ≠ 0 := by
      have : (1 : ℝ) < x := hx
      linarith
    exact (hasDerivAt_inv hx0).hasDerivWithinAt
  have h := integral_image_eq_integral_abs_deriv_smul measurableSet_Ioi hderiv
    inv_injective.injOn g
  rw [image_inv_Ioi_one] at h
  rw [h]
  refine setIntegral_congr_fun measurableSet_Ioi fun x hx => ?_
  have hx1 : (1 : ℝ) < x := hx
  have : |(-(x ^ 2)⁻¹ : ℝ)| = (x ^ 2)⁻¹ := by
    rw [abs_neg, abs_of_nonneg (by positivity)]
  simp only [this]

/-- **The Weil distribution is locally rational away from `ρ = 1`.**  For a test function
vanishing at `1` (in the paper: with `1` outside its support) the distribution `W_ℝ` is
given by an absolutely convergent integral against the rational weight `x/(x²-1)` on
`(1,∞)` and `1/(1-x²)` on `(0,1)`. -/
theorem WeilR_explicit {f : ℝ → ℂ} (hf1 : f 1 = 0)
    (h1 : IntegrableOn (fun x : ℝ => f x * ((x : ℂ) / ((x : ℂ) ^ 2 - 1))) (Ioi 1))
    (h2 : IntegrableOn (fun x : ℝ => f x⁻¹ * (1 / ((x : ℂ) ^ 2 - 1))) (Ioi 1)) :
    WeilR f = (∫ x in Ioi (1:ℝ), f x * ((x : ℂ) / ((x : ℂ) ^ 2 - 1)))
      + ∫ x in Ioo (0:ℝ) 1, f x * (1 / (1 - (x : ℂ) ^ 2)) := by
  have hsplit : ∀ x ∈ Ioi (1:ℝ),
      (f x + sharp f x) / ((x : ℂ) - (x : ℂ)⁻¹)
        = f x * ((x : ℂ) / ((x : ℂ) ^ 2 - 1)) + f x⁻¹ * (1 / ((x : ℂ) ^ 2 - 1)) := by
    intro x hx
    have hx1 : (1 : ℝ) < x := hx
    have hx0 : (x : ℂ) ≠ 0 := by
      have : x ≠ 0 := by linarith
      exact_mod_cast this
    have hxsq : (x : ℂ) ^ 2 - 1 ≠ 0 := by
      have hne : x ^ 2 - 1 ≠ 0 := by nlinarith
      have : ((x ^ 2 - 1 : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hne
      push_cast at this
      exact this
    have hxx_eq : (x : ℂ) - (x : ℂ)⁻¹ = ((x : ℂ) ^ 2 - 1) / (x : ℂ) := by
      field_simp
    rw [hxx_eq]
    simp only [sharp]
    field_simp
  have hstep : WeilR f
      = ∫ x in Ioi (1:ℝ),
          (f x * ((x : ℂ) / ((x : ℂ) ^ 2 - 1)) + f x⁻¹ * (1 / ((x : ℂ) ^ 2 - 1))) := by
    rw [WeilR_of_apply_one_eq_zero hf1]
    exact setIntegral_congr_fun measurableSet_Ioi hsplit
  rw [hstep, integral_add h1 h2]
  congr 1
  rw [integral_Ioo_zero_one_eq_integral_Ioi_one]
  refine setIntegral_congr_fun measurableSet_Ioi fun x hx => ?_
  have hx1 : (1 : ℝ) < x := hx
  have hx0 : (x : ℂ) ≠ 0 := by
    have : x ≠ 0 := by linarith
    exact_mod_cast this
  have hxsq : (x : ℂ) ^ 2 - 1 ≠ 0 := by
    have hne : x ^ 2 - 1 ≠ 0 := by nlinarith
    have : ((x ^ 2 - 1 : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hne
    push_cast at this
    exact this
  have key : (((x ^ 2)⁻¹ : ℝ)) • (f x⁻¹ * (1 / (1 - ((x⁻¹ : ℝ) : ℂ) ^ 2)))
      = f x⁻¹ * (1 / ((x : ℂ) ^ 2 - 1)) := by
    rw [Complex.real_smul]
    push_cast
    have hden : 1 - ((x : ℂ)⁻¹) ^ 2 = ((x : ℂ) ^ 2 - 1) / (x : ℂ) ^ 2 := by
      field_simp
    rw [hden]
    field_simp
  exact key.symm

/-! ## The normalization `∆^{1/2}` -/

/-- The operator `∆^{-1/2} : f ↦ (x ↦ x^{-1/2} f(x))` used in the paper to make the
scaling action unitary. -/
def deltaHalfInv (f : ℝ → ℂ) : ℝ → ℂ := fun x => ((Real.sqrt x : ℝ) : ℂ)⁻¹ * f x

/-- The involution `f ↦ f*` of the convolution algebra, `f*(x) = conj (f (x⁻¹))`. -/
def starInvolution (f : ℝ → ℂ) : ℝ → ℂ := fun x => starRingEnd ℂ (f x⁻¹)

/-- In the `∆^{1/2}`-normalization the involution `f ↦ f*` of the convolution algebra
corresponds to the involution `f ↦ conj (f♯)` used in the Weil explicit formula:
`∆^{-1/2}(f*) = conj ((∆^{-1/2} f)♯)` on `ℝ⋆₊`. -/
theorem deltaHalfInv_starInvolution {f : ℝ → ℂ} {x : ℝ} (hx : 0 < x) :
    deltaHalfInv (starInvolution f) x
      = starRingEnd ℂ (sharp (deltaHalfInv f) x) := by
  have hs : Real.sqrt x ≠ 0 := ne_of_gt (Real.sqrt_pos.2 hx)
  have hxc : (x : ℂ) ≠ 0 := by exact_mod_cast ne_of_gt hx
  have hsx : Real.sqrt x * Real.sqrt x = x := Real.mul_self_sqrt hx.le
  have hinv : Real.sqrt x⁻¹ = (Real.sqrt x)⁻¹ := by
    rw [← Real.sqrt_inv]
  simp only [deltaHalfInv, starInvolution, sharp, hinv, map_mul, map_inv₀,
    Complex.ofReal_inv]
  rw [Complex.conj_ofReal, Complex.conj_ofReal]
  have : ((Real.sqrt x : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hs
  field_simp
  have h2 : ((Real.sqrt x : ℝ) : ℂ) ^ 2 = (x : ℂ) := by
    rw [sq, ← Complex.ofReal_mul, hsx]
  rw [h2]
  ring

end ConnesConsani.WeilPositivity
