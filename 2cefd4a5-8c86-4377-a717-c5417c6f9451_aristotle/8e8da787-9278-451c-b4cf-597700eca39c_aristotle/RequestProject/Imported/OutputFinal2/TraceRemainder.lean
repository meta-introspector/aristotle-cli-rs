/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The trace-remainder function `δ` of arXiv:2006.13771, §2.

The paper defines `δ` as a trace (formula (8)) and computes (Proposition 2.2 and
formula (48)) that for `ρ ≥ 1`

  δ(ρ) = 4 √ρ ∫₀¹ cos(2πρt) cos(2πt) (-log t) dt ,

together with the symmetry `δ(ρ⁻¹) = δ(ρ)`.  Here we *take* this integral formula
(symmetrized in `ρ ↦ ρ⁻¹`) as the definition of `δ`, and prove the closed formula (49)

  δ(ρ) = 2 √ρ ( Si(2π(1+ρ))/(2π(1+ρ)) + Si(2π(ρ-1))/(2π(ρ-1)) )   (ρ ≥ 1)

as well as the symmetry.
-/
import RequestProject.Imported.OutputFinal2.SiPositivity

noncomputable section

open MeasureTheory Real Set intervalIntegral

namespace ConnesConsani.WeilPositivity

/-- The integral expression (48) of the trace remainder, as a function of a real
parameter `r ≥ 1`. -/
def deltaAux (r : ℝ) : ℝ :=
  4 * Real.sqrt r * ∫ t in (0:ℝ)..1, Real.cos (2 * π * r * t) * Real.cos (2 * π * t) * (-Real.log t)

/-- The trace-remainder function `δ : ℝ⋆₊ → ℝ` of the paper, defined by the integral
formula (48) on `[1,∞)` and extended by the symmetry `δ(ρ) = δ(ρ⁻¹)`. -/
def delta (ρ : Rplus) : ℝ := deltaAux (max (ρ : ℝ) (ρ : ℝ)⁻¹)

/-- **Proposition 2.2 (ii)**: `δ` is invariant under `ρ ↦ ρ⁻¹`. -/
theorem delta_symmetric (ρ : Rplus) : delta ρ⁻¹ = delta ρ := by
  have h : ((ρ⁻¹ : Rplus) : ℝ) = (ρ : ℝ)⁻¹ := rfl
  simp only [delta, h, inv_inv, max_comm]

lemma delta_of_one_le {ρ : Rplus} (h : 1 ≤ (ρ : ℝ)) : delta ρ = deltaAux (ρ : ℝ) := by
  have hinv : (ρ : ℝ)⁻¹ ≤ (ρ : ℝ) := le_trans (inv_le_one_of_one_le₀ h) h
  simp only [delta]
  rw [max_eq_left hinv]

/-- The closed formula (49) for `deltaAux`. -/
theorem deltaAux_explicit (r : ℝ) :
    deltaAux r = 2 * Real.sqrt r * (siDiv (2 * π * (1 + r)) + siDiv (2 * π * (r - 1))) := by
  have hprod : ∀ t : ℝ,
      Real.cos (2 * π * r * t) * Real.cos (2 * π * t) * (-Real.log t) =
        (Real.cos ((2 * π * (1 + r)) * t) * (-Real.log t)) / 2 +
        (Real.cos ((2 * π * (r - 1)) * t) * (-Real.log t)) / 2 := by
    intro t
    have h1 : (2 * π * (1 + r)) * t = 2 * π * r * t + 2 * π * t := by ring
    have h2 : (2 * π * (r - 1)) * t = 2 * π * r * t - 2 * π * t := by ring
    rw [h1, h2, Real.cos_add, Real.cos_sub]
    ring
  have hint : (∫ t in (0:ℝ)..1,
      Real.cos (2 * π * r * t) * Real.cos (2 * π * t) * (-Real.log t)) =
      (siDiv (2 * π * (1 + r)) + siDiv (2 * π * (r - 1))) / 2 := by
    simp_rw [hprod]
    rw [intervalIntegral.integral_add
        (((intervalIntegrable_cos_mul_neg_log (2 * π * (1 + r))).div_const 2))
        (((intervalIntegrable_cos_mul_neg_log (2 * π * (r - 1))).div_const 2)),
      intervalIntegral.integral_div, intervalIntegral.integral_div,
      integral_cos_mul_neg_log, integral_cos_mul_neg_log]
    ring
  rw [deltaAux, hint]
  ring

/-- **Formula (49)** of arXiv:2006.13771: for `ρ ≥ 1`,
`δ(ρ) = 2 √ρ ( Si(2π(1+ρ))/(2π(1+ρ)) + Si(2π(ρ-1))/(2π(ρ-1)) )`. -/
theorem delta_explicit {ρ : Rplus} (h : 1 ≤ (ρ : ℝ)) :
    delta ρ = 2 * Real.sqrt ρ *
      (Si (2 * π * (1 + ρ)) / (2 * π * (1 + ρ)) + siDiv (2 * π * ((ρ : ℝ) - 1))) := by
  have hne : 2 * π * (1 + (ρ : ℝ)) ≠ 0 := by
    have : (0:ℝ) < 1 + (ρ : ℝ) := by linarith
    positivity
  rw [delta_of_one_le h, deltaAux_explicit, siDiv_of_ne_zero hne]

/-- The value at `ρ = 1`, i.e. the constant term of the expansion (50):
`δ(1) = 2 (Si(4π)/(4π) + 1)`. -/
theorem delta_one : delta (1 : Rplus) = 2 * (Si (4 * π) / (4 * π) + 1) := by
  have h1 : ((1 : Rplus) : ℝ) = 1 := rfl
  have hne : 2 * π * (1 + (1:ℝ)) ≠ 0 := by positivity
  rw [delta_of_one_le (by rw [h1]), h1, deltaAux_explicit]
  rw [siDiv_of_ne_zero hne]
  norm_num
  ring_nf

/-- The trace remainder is positive: this is the assertion of §2 of arXiv:2006.13771,
"since the Sine Integral function `Si(z)` is positive for `z ≥ 0`, `δ(ρ)` is positive". -/
theorem deltaAux_pos {r : ℝ} (hr : 0 < r) : 0 < deltaAux r := by
  rw [deltaAux_explicit]
  have h1 : 0 < Real.sqrt r := Real.sqrt_pos.2 hr
  have h2 : 0 < siDiv (2 * π * (1 + r)) := siDiv_pos _
  have h3 : 0 < siDiv (2 * π * (r - 1)) := siDiv_pos _
  positivity

/-- **Positivity of the trace remainder**: `δ(ρ) > 0` for every `ρ ∈ ℝ⋆₊`. -/
theorem delta_pos (ρ : Rplus) : 0 < delta ρ := by
  have hρ : (0:ℝ) < (ρ : ℝ) := ρ.2
  have hmax : 0 < max (ρ : ℝ) (ρ : ℝ)⁻¹ := lt_of_lt_of_le hρ (le_max_left _ _)
  exact deltaAux_pos hmax

/-- `δ` is continuous on `[1,∞)`, hence (by symmetry) everywhere. -/
theorem deltaAux_continuous : Continuous deltaAux := by
  have h : deltaAux = fun r : ℝ =>
      2 * Real.sqrt r * (siDiv (2 * π * (1 + r)) + siDiv (2 * π * (r - 1))) := by
    funext r
    exact deltaAux_explicit r
  rw [h]
  exact (continuous_const.mul Real.continuous_sqrt).mul
    ((siDiv_continuous.comp (by fun_prop)).add (siDiv_continuous.comp (by fun_prop)))

theorem delta_continuous : Continuous delta := by
  refine deltaAux_continuous.comp ?_
  exact (continuous_subtype_val.max (continuous_subtype_val.inv₀ fun ρ => ne_of_gt ρ.2))

/-! ## Decay of `δ` at infinity and integrability

The paper notes (§2) that `δ(ρ) = ρ^{-1/2} + O(ρ^{-3/2})`, so that `δ` is integrable for
the multiplicative Haar measure and its Fourier transform `δ̂` is well defined.  We prove
the upper bound `δ(ρ) ≤ C ρ^{-1/2}` (for `ρ ≥ 1`) and deduce the integrability. -/

lemma siDiv_two_pi_one_add_le {r : ℝ} (hr : 1 ≤ r) :
    siDiv (2 * π * (1 + r)) ≤ Si π / r := by
  have hπ : (0:ℝ) < π := Real.pi_pos
  have hr0 : (0:ℝ) < r := by linarith
  have hA : 0 < 2 * π * (1 + r) := by positivity
  refine le_trans (siDiv_le_div hA) ?_
  have hle : r ≤ 2 * π * (1 + r) := by nlinarith [Real.pi_gt_three]
  exact div_le_div_of_nonneg_left (Si_pos hπ).le hr0 hle

lemma siDiv_two_pi_sub_one_le {r : ℝ} (hr : 1 ≤ r) :
    siDiv (2 * π * (r - 1)) ≤ (Si π + 2) / r := by
  have hπ : (0:ℝ) < π := Real.pi_pos
  have hSi : 0 < Si π := Si_pos hπ
  have hr0 : (0:ℝ) < r := by linarith
  rcases le_or_gt r 2 with hr2 | hr2
  · refine le_trans (siDiv_le_one (by nlinarith [Real.pi_pos])) ?_
    rw [le_div_iff₀ hr0]
    linarith
  · have hB : 0 < 2 * π * (r - 1) := by
      have : (0:ℝ) < r - 1 := by linarith
      positivity
    refine le_trans (siDiv_le_div hB) ?_
    have hle : r ≤ 2 * π * (r - 1) := by nlinarith [Real.pi_gt_three]
    exact le_trans (div_le_div_of_nonneg_left hSi.le hr0 hle)
      (by gcongr; linarith)

/-- The decay bound `δ(r) ≤ (4 Si π + 4) r^{-1/2}` for `r ≥ 1`. -/
theorem deltaAux_le {r : ℝ} (hr : 1 ≤ r) :
    deltaAux r ≤ (4 * Si π + 4) / Real.sqrt r := by
  have hr0 : (0:ℝ) < r := by linarith
  have hsq : 0 < Real.sqrt r := Real.sqrt_pos.2 hr0
  have hrsq : Real.sqrt r * Real.sqrt r = r := Real.mul_self_sqrt hr0.le
  have h1 := siDiv_two_pi_one_add_le hr
  have h2 := siDiv_two_pi_sub_one_le hr
  rw [deltaAux_explicit]
  have hstep : 2 * Real.sqrt r * (siDiv (2 * π * (1 + r)) + siDiv (2 * π * (r - 1)))
      ≤ 2 * Real.sqrt r * (Si π / r + (Si π + 2) / r) := by
    have := add_le_add h1 h2
    nlinarith [hsq]
  refine le_trans hstep (le_of_eq ?_)
  set s := Real.sqrt r with hs
  rw [← hrsq]
  have hs0 : s ≠ 0 := ne_of_gt hsq
  field_simp
  ring

/-- The decay bound for `δ` on the group: `δ(ρ) ≤ (4 Si π + 4) (max ρ ρ⁻¹)^{-1/2}`. -/
theorem delta_le (ρ : Rplus) :
    delta ρ ≤ (4 * Si π + 4) / Real.sqrt (max (ρ : ℝ) (ρ : ℝ)⁻¹) := by
  have hρ : (0:ℝ) < (ρ : ℝ) := ρ.2
  have hmax : 1 ≤ max (ρ : ℝ) (ρ : ℝ)⁻¹ := by
    rcases le_or_gt 1 (ρ : ℝ) with h | h
    · exact le_trans h (le_max_left _ _)
    · refine le_trans ?_ (le_max_right _ _)
      rw [le_inv_comm₀ one_pos hρ]
      simpa using h.le
  exact deltaAux_le hmax

lemma integrable_exp_neg_half_abs :
    Integrable (fun t : ℝ => Real.exp (-(|t| / 2))) volume := by
  have h1 : IntegrableOn (fun t : ℝ => Real.exp (-(|t| / 2))) (Set.Iic 0) volume := by
    refine (integrableOn_exp_mul_Iic (a := 1/2) (by norm_num) 0).congr_fun ?_ measurableSet_Iic
    intro t ht
    show Real.exp (1 / 2 * t) = Real.exp (-(|t| / 2))
    rw [abs_of_nonpos ht]
    congr 1
    ring
  have h2 : IntegrableOn (fun t : ℝ => Real.exp (-(|t| / 2))) (Set.Ioi 0) volume := by
    refine (integrableOn_exp_mul_Ioi (a := -(1/2)) (by norm_num) 0).congr_fun ?_ measurableSet_Ioi
    intro t ht
    show Real.exp (-(1 / 2) * t) = Real.exp (-(|t| / 2))
    rw [abs_of_pos ht]
    congr 1
    ring
  have := h1.union h2
  rw [Set.Iic_union_Ioi, integrableOn_univ] at this
  exact this

/-- **The decay bound in the logarithmic coordinate**:
`δ(e^u) ≤ (4 Si π + 4) e^{-|u|/2}`. -/
theorem delta_expHomeo_le (t : ℝ) :
    delta (Rplus.expHomeo t) ≤ (4 * Si π + 4) * Real.exp (-(|t| / 2)) := by
  have hmax : max (Real.exp t) (Real.exp t)⁻¹ = Real.exp |t| := by
    rw [← Real.exp_neg]
    rcases le_or_gt 0 t with h | h
    · rw [abs_of_nonneg h, max_eq_left (Real.exp_le_exp.2 (by linarith))]
    · rw [abs_of_neg h, max_eq_right (Real.exp_le_exp.2 (by linarith))]
  have hval : delta (Rplus.expHomeo t) = deltaAux (Real.exp |t|) := by
    show deltaAux (max (Real.exp t) (Real.exp t)⁻¹) = _
    rw [hmax]
  have hsqrt : Real.sqrt (Real.exp |t|) = Real.exp (|t| / 2) := (Real.exp_half _).symm
  have hle := deltaAux_le (r := Real.exp |t|) (Real.one_le_exp (abs_nonneg t))
  rw [hsqrt] at hle
  rw [hval]
  refine le_trans hle (le_of_eq ?_)
  rw [Real.exp_neg]
  field_simp

/-- **`δ` is integrable** for the multiplicative Haar measure; consequently its Fourier
transform `δ̂` of §2 of the paper is well defined. -/
theorem delta_integrable : Integrable delta Rplus.haar := by
  rw [Rplus.integrable_haar_iff]
  have hmeas : AEStronglyMeasurable (fun t : ℝ => delta (Rplus.expHomeo t)) volume :=
    (delta_continuous.comp Rplus.expHomeo.continuous).aestronglyMeasurable
  have hbound : Integrable
      (fun t : ℝ => (4 * Si π + 4) * Real.exp (-(|t| / 2))) volume :=
    integrable_exp_neg_half_abs.const_mul _
  refine Integrable.mono' hbound hmeas ?_
  filter_upwards with t
  rw [Real.norm_eq_abs, abs_of_pos (delta_pos _)]
  exact delta_expHomeo_le t

/-! ## The jump of `δ'` at `ρ = 1` -/

/-- The trace remainder as a function of a real variable: `δ(x) = δ₀(max x x⁻¹)`. -/
def deltaReal (x : ℝ) : ℝ := deltaAux (max x x⁻¹)

lemma delta_eq_deltaReal (ρ : Rplus) : delta ρ = deltaReal (ρ : ℝ) := rfl

/-- The derivative at `1` of the branch `ρ ↦ δ(ρ)`, `ρ ≥ 1`, equals `1`.  (This is the
value of the linear term in the expansion (50) of the paper.) -/
theorem deltaAux_hasDerivAt_one : HasDerivAt deltaAux 1 1 := by
  have hexpl : deltaAux =
      fun r : ℝ => 2 * Real.sqrt r * (siDiv (2 * π * (1 + r)) + siDiv (2 * π * (r - 1))) :=
    funext deltaAux_explicit
  have hpi : (0:ℝ) < π := Real.pi_pos
  have hF : HasDerivAt (fun r : ℝ => 2 * Real.sqrt r) 1 1 := by
    have h := (Real.hasDerivAt_sqrt (one_ne_zero)).const_mul (2:ℝ)
    simpa using h
  have hlin1 : HasDerivAt (fun r : ℝ => 2 * π * (1 + r)) (2 * π) 1 := by
    simpa using (((hasDerivAt_id (1:ℝ)).const_add (1:ℝ)).const_mul (2 * π))
  have hlin2 : HasDerivAt (fun r : ℝ => 2 * π * (r - 1)) (2 * π) 1 := by
    simpa using (((hasDerivAt_id (1:ℝ)).sub_const (1:ℝ)).const_mul (2 * π))
  have h4 : 2 * π * (1 + (1:ℝ)) = 4 * π := by ring
  have hne : (4 * π : ℝ) ≠ 0 := by positivity
  have hsinc : Real.sinc (4 * π) = 0 := by
    rw [Real.sinc_of_ne_zero hne]
    have : Real.sin (4 * π) = 0 := by
      have := Real.sin_int_mul_pi 4
      simpa using this
    rw [this, zero_div]
  have hA : HasDerivAt (fun r : ℝ => siDiv (2 * π * (1 + r)))
      ((Real.sinc (4 * π) * (4 * π) - Si (4 * π)) / (4 * π) ^ 2 * (2 * π)) 1 := by
    have hd : HasDerivAt siDiv
        ((Real.sinc (4 * π) * (4 * π) - Si (4 * π)) / (4 * π) ^ 2) (2 * π * (1 + 1)) := by
      rw [h4]
      exact siDiv_hasDerivAt hne
    exact hd.comp 1 hlin1
  have hB : HasDerivAt (fun r : ℝ => siDiv (2 * π * (r - 1))) (0 * (2 * π)) 1 := by
    have hd : HasDerivAt siDiv 0 (2 * π * ((1:ℝ) - 1)) := by
      simpa using siDiv_hasDerivAt_zero
    exact hd.comp 1 hlin2
  have hG := hA.add hB
  have hprod := hF.mul hG
  have h0 : 2 * π * ((1:ℝ) - 1) = 0 := by ring
  rw [hexpl]
  convert hprod using 1
  simp only [Pi.add_apply, hsinc, Real.sqrt_one, h4, h0]
  rw [siDiv_of_ne_zero hne, siDiv_zero]
  field_simp
  ring

/-- The right derivative of `δ` at `1` is `1`. -/
theorem deltaReal_hasDerivWithinAt_Ici_one : HasDerivWithinAt deltaReal 1 (Set.Ici 1) 1 := by
  refine (deltaAux_hasDerivAt_one.hasDerivWithinAt (s := Set.Ici 1)).congr ?_ ?_
  · intro x hx
    have hx1 : (1:ℝ) ≤ x := hx
    have : x⁻¹ ≤ x := le_trans (inv_le_one_of_one_le₀ hx1) hx1
    simp [deltaReal, max_eq_left this]
  · simp [deltaReal]

/-- The left derivative of `δ` at `1` is `-1`.  Together with the previous lemma this says
that the derivative of `δ` jumps by `2` at `ρ = 1`, which is the feature of `δ` that drives
the argument of the paper. -/
theorem deltaReal_hasDerivWithinAt_Iic_one : HasDerivWithinAt deltaReal (-1) (Set.Iic 1) 1 := by
  have hinv : HasDerivAt (fun x : ℝ => x⁻¹) (-1) 1 := by
    simpa using hasDerivAt_inv (one_ne_zero (α := ℝ))
  have hd : HasDerivAt deltaAux 1 ((1:ℝ)⁻¹) := by simpa using deltaAux_hasDerivAt_one
  have hcomp : HasDerivAt (fun x : ℝ => deltaAux x⁻¹) (-1) 1 := by
    have h := hd.comp 1 hinv
    simpa using h
  refine (hcomp.hasDerivWithinAt (s := Set.Iic 1)).congr ?_ ?_
  · intro x hx
    have hx1 : x ≤ (1:ℝ) := hx
    rcases le_or_gt x 0 with hx0 | hx0
    · show deltaAux (max x x⁻¹) = deltaAux x⁻¹
      rcases eq_or_lt_of_le hx0 with rfl | hneg
      · simp
      · have h1 : x⁻¹ < 0 := inv_neg''.2 hneg
        rcases le_total x x⁻¹ with h | h
        · rw [max_eq_right h]
        · have hx2 : deltaAux x = 0 := by
            simp [deltaAux, Real.sqrt_eq_zero_of_nonpos hneg.le]
          have hx3 : deltaAux x⁻¹ = 0 := by
            simp [deltaAux, Real.sqrt_eq_zero_of_nonpos h1.le]
          rw [max_eq_left h, hx2, hx3]
    · have hle : x ≤ x⁻¹ := by
        rw [inv_eq_one_div, le_div_iff₀ hx0]
        nlinarith
      simp [deltaReal, max_eq_right hle]
  · simp [deltaReal]

/-! ## The functional `D` -/

/-- The functional `D(f) = ∫ f(ρ⁻¹) δ(ρ) d*ρ` of formula (9) of arXiv:2006.13771. -/
def D (f : Rplus → ℝ) : ℝ := ∫ ρ, f ρ⁻¹ * delta ρ ∂(Rplus.haar)

/-- Since both the Haar measure `d*ρ` and `δ` are invariant under `ρ ↦ ρ⁻¹`, the functional
`D` can equivalently be written without the inversion. -/
theorem D_eq (f : Rplus → ℝ) : D f = ∫ ρ, f ρ * delta ρ ∂(Rplus.haar) := by
  have h := Rplus.integral_haar_inv (fun ρ => f ρ * delta ρ)
  simp only [D]
  rw [← h]
  refine integral_congr_ae (Filter.Eventually.of_forall fun ρ => ?_)
  simp only
  rw [delta_symmetric]

end ConnesConsani.WeilPositivity
