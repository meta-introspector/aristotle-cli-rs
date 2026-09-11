/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

An *explicit* bound for the kernel `Q δ(exp t)` of §3 of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771.

The proof of Corollary 3.8 of the paper rests on the numerical verification of
`∫₀ˢ |Q δ(exp x)| dx ≤ 1` (Figure 8 of the paper).  This file replaces the numerical
verification by a proved inequality: writing the trace remainder through the cosine
moments `∫₀¹ tᵏ cos(a t)(-log t) dt` of `RequestProject/SiSmooth.lean`, the operator
`Q = -(d/dt)² + 1/4` applied to `δ(exp t)` has the closed form

  `Q δ(exp t) = 2 e^{t/2} ( 2 c e^t (S₁(u₊) + S₁(u₋)) + c² e^{2t} (C₂(u₊) + C₂(u₋)) )`,
  `c = 2π`, `u± = c (e^t ± 1)`, `S₁ = sinMoment 1`, `C₂ = cosMoment 2`,

from which the explicit bound `|Q δ(exp t)| ≤ 14` for `|t| ≤ 1/15` follows.
-/
import RequestProject.Imported.OutputFinal2.DeltaSmooth

noncomputable section

open MeasureTheory Set Real intervalIntegral

namespace ConnesConsani.WeilPositivity

/-! ## The elementary moment bounds -/

/-- `∫₀¹ t² (-log t) dt = 1/9`. -/
theorem integral_sq_neg_log : ∫ t in (0:ℝ)..1, t ^ 2 * (-Real.log t) = 1 / 9 := by
  have hcont : ContinuousOn (fun t : ℝ => t ^ 3 / 9 - t ^ 3 * Real.log t / 3) (Icc 0 1) := by
    have h : Continuous (fun t : ℝ => t ^ 3 / 9 - t ^ 2 * (t * Real.log t) / 3) := by
      have := Real.continuous_mul_log
      fun_prop
    exact h.continuousOn.congr fun x _ => by ring
  have hderiv : ∀ x ∈ Ioo (0:ℝ) 1,
      HasDerivWithinAt (fun t : ℝ => t ^ 3 / 9 - t ^ 3 * Real.log t / 3)
        (x ^ 2 * (-Real.log x)) (Ioi x) x := by
    intro x hx
    have hx0 : x ≠ 0 := ne_of_gt hx.1
    have hA : HasDerivAt (fun t : ℝ => t ^ 3) (3 * x ^ 2) x := by simpa using hasDerivAt_pow 3 x
    have hB : HasDerivAt Real.log (1 / x) x := by simpa using Real.hasDerivAt_log hx0
    have h1 : HasDerivAt (fun t : ℝ => t ^ 3 / 9 - t ^ 3 * Real.log t / 3)
        (3 * x ^ 2 / 9 - (3 * x ^ 2 * Real.log x + x ^ 3 * (1 / x)) / 3) x :=
      (hA.div_const 9).sub ((hA.mul hB).div_const 3)
    have heq : 3 * x ^ 2 / 9 - (3 * x ^ 2 * Real.log x + x ^ 3 * (1 / x)) / 3
        = x ^ 2 * (-Real.log x) := by field_simp; ring
    rw [heq] at h1
    exact h1.hasDerivWithinAt
  have hint : IntervalIntegrable (fun t : ℝ => t ^ 2 * (-Real.log t)) volume 0 1 :=
    intervalIntegrable_neg_log.continuousOn_mul (g := fun t : ℝ => t ^ 2) (by fun_prop)
  rw [intervalIntegral.integral_eq_sub_of_hasDeriv_right_of_le (by norm_num) hcont hderiv hint]
  norm_num

/-- `|C₂(a)| ≤ 1/9`: the second cosine moment is bounded by the total mass `∫₀¹t²(-log t)`. -/
theorem abs_cosMoment_two_le (a : ℝ) : |cosMoment 2 a| ≤ 1 / 9 := by
  have hint : IntervalIntegrable (fun t : ℝ => t ^ 2 * Real.cos (a * t) * (-Real.log t))
      volume 0 1 := intervalIntegrable_moment (Real.continuous_cos.comp (by fun_prop)) 2
  have hint2 : IntervalIntegrable (fun t : ℝ => t ^ 2 * (-Real.log t)) volume 0 1 :=
    intervalIntegrable_neg_log.continuousOn_mul (g := fun t : ℝ => t ^ 2) (by fun_prop)
  have hbound : ∀ t ∈ Ioc (0:ℝ) 1,
      |t ^ 2 * Real.cos (a * t) * (-Real.log t)| ≤ t ^ 2 * (-Real.log t) := by
    intro t ht
    have hlog : 0 ≤ -Real.log t := by
      have := Real.log_nonpos ht.1.le ht.2
      linarith
    rw [abs_mul, abs_mul, abs_of_nonneg (by positivity : (0:ℝ) ≤ t ^ 2),
      abs_of_nonneg hlog]
    have hc : |Real.cos (a * t)| ≤ 1 := Real.abs_cos_le_one _
    nlinarith [mul_nonneg (mul_nonneg (sq_nonneg t) hlog) (sub_nonneg.2 hc)]
  calc |cosMoment 2 a| ≤ ∫ t in (0:ℝ)..1, |t ^ 2 * Real.cos (a * t) * (-Real.log t)| := by
        rw [cosMoment]
        exact intervalIntegral.abs_integral_le_integral_abs (by norm_num)
    _ ≤ ∫ t in (0:ℝ)..1, t ^ 2 * (-Real.log t) := by
        refine intervalIntegral.integral_mono_on_of_le_Ioo (by norm_num) hint.abs hint2 ?_
        intro t ht
        exact hbound t ⟨ht.1, ht.2.le⟩
    _ = 1 / 9 := integral_sq_neg_log

/-- `|S₁(a)| ≤ |a|/9`: the first sine moment vanishes at the origin to first order. -/
theorem abs_sinMoment_one_le (a : ℝ) : |sinMoment 1 a| ≤ |a| / 9 := by
  have hint : IntervalIntegrable (fun t : ℝ => t ^ 1 * Real.sin (a * t) * (-Real.log t))
      volume 0 1 := intervalIntegrable_moment (Real.continuous_sin.comp (by fun_prop)) 1
  have hint2 : IntervalIntegrable (fun t : ℝ => |a| * (t ^ 2 * (-Real.log t))) volume 0 1 :=
    (intervalIntegrable_neg_log.continuousOn_mul (g := fun t : ℝ => t ^ 2)
      (by fun_prop)).const_mul _
  have hbound : ∀ t ∈ Ioo (0:ℝ) 1,
      |t ^ 1 * Real.sin (a * t) * (-Real.log t)| ≤ |a| * (t ^ 2 * (-Real.log t)) := by
    intro t ht
    have hlog : 0 ≤ -Real.log t := by
      have := Real.log_nonpos ht.1.le ht.2.le
      linarith
    have hsin : |Real.sin (a * t)| ≤ |a * t| := Real.abs_sin_le_abs
    have habs : |a * t| = |a| * t := by
      rw [abs_mul, abs_of_pos ht.1]
    rw [abs_mul, abs_mul, abs_of_nonneg (pow_nonneg ht.1.le 1), abs_of_nonneg hlog]
    rw [habs] at hsin
    nlinarith [mul_nonneg (mul_nonneg ht.1.le hlog) (sub_nonneg.2 hsin)]
  calc |sinMoment 1 a| ≤ ∫ t in (0:ℝ)..1, |t ^ 1 * Real.sin (a * t) * (-Real.log t)| := by
        rw [sinMoment]
        exact intervalIntegral.abs_integral_le_integral_abs (by norm_num)
    _ ≤ ∫ t in (0:ℝ)..1, |a| * (t ^ 2 * (-Real.log t)) :=
        intervalIntegral.integral_mono_on_of_le_Ioo (by norm_num) hint.abs hint2 hbound
    _ = |a| / 9 := by
        rw [intervalIntegral.integral_const_mul, integral_sq_neg_log]
        ring

/-! ## Sharper bounds for a large argument, through the sine integral -/

/-- `S₁(y) = (Si y - sin y)/y²` for `y ≠ 0`: the first sine moment is minus the derivative
of `y ↦ Si y / y`. -/
theorem sinMoment_one_eq {y : ℝ} (hy : y ≠ 0) :
    sinMoment 1 y = (Si y - Real.sin y) / y ^ 2 := by
  have h1 : HasDerivAt siDiv (-sinMoment 1 y) y := by
    have h := hasDerivAt_cosMoment 0 y
    have hs : siDiv = cosMoment 0 := funext siDiv_eq_cosMoment
    rw [hs]
    exact h
  have h2 : HasDerivAt (fun x : ℝ => Si x / x) ((Real.sin y - Si y) / y ^ 2) y := by
    have h := (Si_hasDerivAt y).div (hasDerivAt_id y) hy
    simp only [id] at h
    convert h using 1
    rw [Real.sinc_of_ne_zero hy]
    field_simp
  have heq : siDiv =ᶠ[nhds y] fun x : ℝ => Si x / x := by
    have hopen : IsOpen {x : ℝ | x ≠ 0} := isOpen_ne
    filter_upwards [hopen.mem_nhds hy] with x hx using siDiv_of_ne_zero hx
  have := h1.congr_of_eventuallyEq heq.symm
  have huniq := this.unique h2
  have hy2 : (y : ℝ) ^ 2 ≠ 0 := pow_ne_zero 2 hy
  field_simp at huniq ⊢
  linarith [huniq]

/-- `C₂(y) = -cos y/y² + 3 sin y/y³ - 2 Si y/y³` for `y ≠ 0`. -/
theorem cosMoment_two_eq {y : ℝ} (hy : y ≠ 0) :
    cosMoment 2 y = -Real.cos y / y ^ 2 + 3 * Real.sin y / y ^ 3 - 2 * Si y / y ^ 3 := by
  have h1 : HasDerivAt (sinMoment 1) (cosMoment 2 y) y := hasDerivAt_sinMoment 1 y
  have h2 : HasDerivAt (fun x : ℝ => (Si x - Real.sin x) / x ^ 2)
      (-Real.cos y / y ^ 2 + 3 * Real.sin y / y ^ 3 - 2 * Si y / y ^ 3) y := by
    have hnum : HasDerivAt (fun x : ℝ => Si x - Real.sin x) (Real.sinc y - Real.cos y) y :=
      (Si_hasDerivAt y).sub (Real.hasDerivAt_sin y)
    have hden : HasDerivAt (fun x : ℝ => x ^ 2) (2 * y) y := by
      simpa using hasDerivAt_pow 2 y
    have hy2 : (y : ℝ) ^ 2 ≠ 0 := pow_ne_zero 2 hy
    have h := hnum.div hden hy2
    convert h using 1
    rw [Real.sinc_of_ne_zero hy]
    field_simp
    ring
  have heq : sinMoment 1 =ᶠ[nhds y] fun x : ℝ => (Si x - Real.sin x) / x ^ 2 := by
    have hopen : IsOpen {x : ℝ | x ≠ 0} := isOpen_ne
    filter_upwards [hopen.mem_nhds hy] with x hx using sinMoment_one_eq hx
  exact (h1.congr_of_eventuallyEq heq.symm).unique h2

/-- For `y ≥ 12` the first sine moment is at most `1/34` in absolute value. -/
theorem abs_sinMoment_one_le_of_twelve_le {y : ℝ} (hy : 12 ≤ y) : |sinMoment 1 y| ≤ 1 / 34 := by
  have hy0 : (0:ℝ) < y := by linarith
  have hSi : |Si y| ≤ π := le_trans (abs_Si_le_Si_pi y) (Si_le_self Real.pi_pos.le)
  have hsin : |Real.sin y| ≤ 1 := Real.abs_sin_le_one y
  have hpi : π ≤ 3.15 := by linarith [Real.pi_lt_d2]
  rw [sinMoment_one_eq (ne_of_gt hy0), abs_div, abs_of_pos (by positivity : (0:ℝ) < y ^ 2),
    div_le_iff₀ (by positivity)]
  have h1 : |Si y - Real.sin y| ≤ π + 1 := by
    rw [abs_le] at hSi hsin ⊢
    constructor <;> linarith [hSi.1, hSi.2, hsin.1, hsin.2]
  nlinarith [sq_nonneg (y - 12)]

/-- For `y ≥ 12` the second cosine moment is at most `1/75` in absolute value. -/
theorem abs_cosMoment_two_le_of_twelve_le {y : ℝ} (hy : 12 ≤ y) : |cosMoment 2 y| ≤ 1 / 75 := by
  have hy0 : (0:ℝ) < y := by linarith
  have hSi : |Si y| ≤ π := le_trans (abs_Si_le_Si_pi y) (Si_le_self Real.pi_pos.le)
  have hsin : |Real.sin y| ≤ 1 := Real.abs_sin_le_one y
  have hcos : |Real.cos y| ≤ 1 := Real.abs_cos_le_one y
  have hpi : π ≤ 3.15 := by linarith [Real.pi_lt_d2]
  have hy3 : (0:ℝ) < y ^ 3 := by positivity
  have hfrac : -Real.cos y / y ^ 2 + 3 * Real.sin y / y ^ 3 - 2 * Si y / y ^ 3
      = (-(y * Real.cos y) + 3 * Real.sin y - 2 * Si y) / y ^ 3 := by
    field_simp
  rw [cosMoment_two_eq (ne_of_gt hy0), hfrac, abs_div, abs_of_pos hy3, div_le_iff₀ hy3]
  have hcos1 : -y ≤ y * Real.cos y := by nlinarith [(abs_le.mp hcos).1]
  have hcos2 : y * Real.cos y ≤ y := by nlinarith [(abs_le.mp hcos).2]
  have hnum : |(-(y * Real.cos y) + 3 * Real.sin y - 2 * Si y)| ≤ y + 3 + 2 * π := by
    rw [abs_le]
    constructor <;>
      linarith [(abs_le.mp hsin).1, (abs_le.mp hsin).2, (abs_le.mp hSi).1, (abs_le.mp hSi).2]
  nlinarith [sq_nonneg (y - 12), hy0.le]

/-! ## The kernel `Q δ(exp t)` in closed form -/

/-- The argument `u₊ = 2π(1 + e^t)` of the first moment. -/
def uPlus (t : ℝ) : ℝ := 2 * π * (1 + Real.exp t)

/-- The argument `u₋ = 2π(e^t - 1)` of the second moment. -/
def uMinus (t : ℝ) : ℝ := 2 * π * (Real.exp t - 1)

/-- The oscillating factor `h(t) = S(u₊) + S(u₋)` of the trace remainder. -/
def hMom (t : ℝ) : ℝ := cosMoment 0 (uPlus t) + cosMoment 0 (uMinus t)

/-- The derivative of `hMom`. -/
def hMom1 (t : ℝ) : ℝ :=
  -(2 * π * Real.exp t) * (sinMoment 1 (uPlus t) + sinMoment 1 (uMinus t))

/-- The second derivative of `hMom`. -/
def hMom2 (t : ℝ) : ℝ :=
  hMom1 t - (2 * π * Real.exp t) ^ 2 * (cosMoment 2 (uPlus t) + cosMoment 2 (uMinus t))

theorem hasDerivAt_uPlus (t : ℝ) : HasDerivAt uPlus (2 * π * Real.exp t) t := by
  have h : HasDerivAt (fun s : ℝ => 1 + Real.exp s) (Real.exp t) t :=
    (Real.hasDerivAt_exp t).const_add 1
  simpa [uPlus] using h.const_mul (2 * π)

theorem hasDerivAt_uMinus (t : ℝ) : HasDerivAt uMinus (2 * π * Real.exp t) t := by
  have h : HasDerivAt (fun s : ℝ => Real.exp s - 1) (Real.exp t) t :=
    (Real.hasDerivAt_exp t).sub_const 1
  simpa [uMinus] using h.const_mul (2 * π)

theorem hasDerivAt_hMom (t : ℝ) : HasDerivAt hMom (hMom1 t) t := by
  have h1 := (hasDerivAt_cosMoment 0 (uPlus t)).comp t (hasDerivAt_uPlus t)
  have h2 := (hasDerivAt_cosMoment 0 (uMinus t)).comp t (hasDerivAt_uMinus t)
  have h := h1.add h2
  refine h.congr_deriv ?_
  simp only [hMom1]
  ring

theorem hasDerivAt_hMom1 (t : ℝ) : HasDerivAt hMom1 (hMom2 t) t := by
  have hE : HasDerivAt (fun s : ℝ => -(2 * π * Real.exp s)) (-(2 * π * Real.exp t)) t := by
    have h : HasDerivAt (fun s : ℝ => 2 * π * Real.exp s) (2 * π * Real.exp t) t :=
      (Real.hasDerivAt_exp t).const_mul (2 * π)
    exact h.neg
  have h1 := (hasDerivAt_sinMoment 1 (uPlus t)).comp t (hasDerivAt_uPlus t)
  have h2 := (hasDerivAt_sinMoment 1 (uMinus t)).comp t (hasDerivAt_uMinus t)
  have h := hE.mul (h1.add h2)
  refine h.congr_deriv ?_
  simp only [hMom2, hMom1, Pi.add_apply, Function.comp_apply]
  ring

theorem deltaLogAux_eq_hMom (t : ℝ) : deltaLogAux t = 2 * Real.exp (t / 2) * hMom t := by
  rw [deltaLogAux_eq, hMom, siDiv_eq_cosMoment, siDiv_eq_cosMoment]
  rfl

/-- The derivative of `t ↦ δ(e^t)` (on the right-hand side of `1`). -/
def dl1 (t : ℝ) : ℝ := Real.exp (t / 2) * hMom t + 2 * Real.exp (t / 2) * hMom1 t

/-- Its second derivative. -/
def dl2 (t : ℝ) : ℝ :=
  (1 / 2) * Real.exp (t / 2) * hMom t + 2 * Real.exp (t / 2) * hMom1 t
    + 2 * Real.exp (t / 2) * hMom2 t

theorem hasDerivAt_expHalf' (t : ℝ) :
    HasDerivAt (fun s : ℝ => Real.exp (s / 2)) (Real.exp (t / 2) / 2) t := by
  have h := (Real.hasDerivAt_exp (t / 2)).comp t ((hasDerivAt_id t).div_const 2)
  simpa [Function.comp] using h

theorem hasDerivAt_deltaLogAux (t : ℝ) : HasDerivAt deltaLogAux (dl1 t) t := by
  have h : HasDerivAt (fun s : ℝ => 2 * Real.exp (s / 2) * hMom s)
      ((2 * (Real.exp (t / 2) / 2)) * hMom t + 2 * Real.exp (t / 2) * hMom1 t) t :=
    ((hasDerivAt_expHalf' t).const_mul 2).mul (hasDerivAt_hMom t)
  have h' : HasDerivAt deltaLogAux
      ((2 * (Real.exp (t / 2) / 2)) * hMom t + 2 * Real.exp (t / 2) * hMom1 t) t := by
    refine h.congr_of_eventuallyEq ?_
    exact Filter.Eventually.of_forall fun s => deltaLogAux_eq_hMom s
  refine h'.congr_deriv ?_
  simp only [dl1]
  ring

theorem deriv_deltaLogAux : deriv deltaLogAux = dl1 :=
  funext fun t => (hasDerivAt_deltaLogAux t).deriv

theorem hasDerivAt_dl1 (t : ℝ) : HasDerivAt dl1 (dl2 t) t := by
  have hA : HasDerivAt (fun s : ℝ => Real.exp (s / 2) * hMom s)
      (Real.exp (t / 2) / 2 * hMom t + Real.exp (t / 2) * hMom1 t) t :=
    (hasDerivAt_expHalf' t).mul (hasDerivAt_hMom t)
  have hB : HasDerivAt (fun s : ℝ => 2 * Real.exp (s / 2) * hMom1 s)
      ((2 * (Real.exp (t / 2) / 2)) * hMom1 t + 2 * Real.exp (t / 2) * hMom2 t) t :=
    ((hasDerivAt_expHalf' t).const_mul 2).mul (hasDerivAt_hMom1 t)
  have h := hA.add hB
  refine h.congr_deriv ?_
  simp only [dl2]
  ring

/-! ## `Q δ` in closed form and its explicit bound -/

/-- **The kernel `Q δ(exp t)` in closed form**, `t ≥ 0` side:
`2 e^{t/2} (2 c e^t (S₁(u₊) + S₁(u₋)) + c² e^{2t} (C₂(u₊) + C₂(u₋)))` with `c = 2π`. -/
def Qdel (t : ℝ) : ℝ :=
  2 * Real.exp (t / 2) *
    (2 * (2 * π * Real.exp t) * (sinMoment 1 (uPlus t) + sinMoment 1 (uMinus t))
      + (2 * π * Real.exp t) ^ 2 * (cosMoment 2 (uPlus t) + cosMoment 2 (uMinus t)))

theorem deriv_deltaPieceR_eq : deriv deltaPieceR = fun t => ((dl1 t : ℝ) : ℂ) := by
  funext t
  exact (Complex.ofRealCLM.hasFDerivAt.comp_hasDerivAt t (hasDerivAt_deltaLogAux t)).deriv

theorem deriv2_deltaPieceR_eq : deriv (deriv deltaPieceR) = fun t => ((dl2 t : ℝ) : ℂ) := by
  rw [deriv_deltaPieceR_eq]
  funext t
  exact (Complex.ofRealCLM.hasFDerivAt.comp_hasDerivAt t (hasDerivAt_dl1 t)).deriv

/-- `Q` applied to the right-hand piece of the trace remainder is `Qdel`. -/
theorem Qlog_deltaPieceR_apply (t : ℝ) : Qlog deltaPieceR t = ((Qdel t : ℝ) : ℂ) := by
  have hval : -dl2 t + deltaLogAux t / 4 = Qdel t := by
    rw [deltaLogAux_eq_hMom]
    simp only [dl2, hMom2, hMom1, Qdel]
    ring
  rw [Qlog, deriv2_deltaPieceR_eq]
  show -((dl2 t : ℝ) : ℂ) + ((deltaLogAux t : ℝ) : ℂ) / 4 = _
  rw [← hval]
  push_cast
  ring

/-! ## The explicit bound `|Q δ(exp t)| ≤ 14` on `|t| ≤ 1/15` -/

theorem exp_one_fifteenth_le : Real.exp (1 / 15) ≤ 1.07 := by
  by_contra h
  push_neg at h
  have h1 : Real.exp 1 = Real.exp (1 / 15) ^ 15 := by
    rw [← Real.exp_nat_mul]; norm_num
  have h2 : (1.07 : ℝ) ^ 15 < Real.exp (1 / 15) ^ 15 := by gcongr
  have h3 := Real.exp_one_lt_d9
  rw [h1] at h3
  norm_num at h2 h3
  linarith

theorem exp_one_thirtieth_le : Real.exp (1 / 30) ≤ 1.035 := by
  by_contra h
  push_neg at h
  have h1 : Real.exp 1 = Real.exp (1 / 30) ^ 30 := by
    rw [← Real.exp_nat_mul]; norm_num
  have h2 : (1.035 : ℝ) ^ 30 < Real.exp (1 / 30) ^ 30 := by gcongr
  have h3 := Real.exp_one_lt_d9
  rw [h1] at h3
  norm_num at h2 h3
  linarith

/-- **The explicit bound for the kernel.**  On the interval `0 ≤ t ≤ 1/15` the function
`Q δ(exp t)` is bounded by `14` in absolute value.  (Numerically the true maximum on this
interval is about `11.3`; the constant `14` is what the elementary bounds on the moments
give.) -/
theorem abs_Qdel_le {t : ℝ} (ht0 : 0 ≤ t) (ht : t ≤ 1 / 15) : |Qdel t| ≤ 14 := by
  have hpi : π ≤ 3.15 := by linarith [Real.pi_lt_d2]
  have hpi3 : (3:ℝ) ≤ π := by linarith [Real.pi_gt_three]
  have hx1 : (1:ℝ) ≤ Real.exp t := Real.one_le_exp ht0
  have hx : Real.exp t ≤ 1.07 := le_trans (Real.exp_le_exp.2 ht) exp_one_fifteenth_le
  have hE0 : (0:ℝ) < Real.exp (t / 2) := Real.exp_pos _
  have hE : Real.exp (t / 2) ≤ 1.035 :=
    le_trans (Real.exp_le_exp.2 (by linarith)) exp_one_thirtieth_le
  -- the four moment bounds
  have huP : 12 ≤ uPlus t := by
    have : (2:ℝ) ≤ 1 + Real.exp t := by linarith
    calc (12:ℝ) ≤ 2 * 3 * 2 := by norm_num
      _ ≤ 2 * π * (1 + Real.exp t) := by nlinarith
      _ = uPlus t := rfl
  have hb1 : |sinMoment 1 (uPlus t)| ≤ 1 / 34 := abs_sinMoment_one_le_of_twelve_le huP
  have hb2 : |cosMoment 2 (uPlus t)| ≤ 1 / 75 := abs_cosMoment_two_le_of_twelve_le huP
  have hb3 : |sinMoment 1 (uMinus t)| ≤ 2 * π * (Real.exp t - 1) / 9 := by
    refine (abs_sinMoment_one_le _).trans ?_
    have : |uMinus t| = 2 * π * (Real.exp t - 1) := by
      rw [uMinus, abs_of_nonneg (by nlinarith)]
    rw [this]
  have hb4 : |cosMoment 2 (uMinus t)| ≤ 1 / 9 := abs_cosMoment_two_le _
  -- abbreviations
  set c : ℝ := 2 * π * Real.exp t with hc
  set d : ℝ := 2 * π * (Real.exp t - 1) with hd
  have hc0 : 0 < c := by positivity
  have hcle : c ≤ 6.741 := by nlinarith
  have hd0 : 0 ≤ d := by nlinarith
  have hdle : d ≤ 0.441 := by nlinarith
  -- the triangle inequality
  have hsum1 : |sinMoment 1 (uPlus t) + sinMoment 1 (uMinus t)| ≤ 1 / 34 + d / 9 :=
    (abs_add_le _ _).trans (by linarith)
  have hsum2 : |cosMoment 2 (uPlus t) + cosMoment 2 (uMinus t)| ≤ 1 / 75 + 1 / 9 :=
    (abs_add_le _ _).trans (by linarith)
  have hinner : |2 * c * (sinMoment 1 (uPlus t) + sinMoment 1 (uMinus t))
      + c ^ 2 * (cosMoment 2 (uPlus t) + cosMoment 2 (uMinus t))|
      ≤ 2 * c * (1 / 34 + d / 9) + c ^ 2 * (1 / 75 + 1 / 9) := by
    refine (abs_add_le _ _).trans ?_
    have e1 : |2 * c * (sinMoment 1 (uPlus t) + sinMoment 1 (uMinus t))|
        ≤ 2 * c * (1 / 34 + d / 9) := by
      rw [abs_mul, abs_of_pos (by linarith : (0:ℝ) < 2 * c)]
      exact mul_le_mul_of_nonneg_left hsum1 (by linarith)
    have e2 : |c ^ 2 * (cosMoment 2 (uPlus t) + cosMoment 2 (uMinus t))|
        ≤ c ^ 2 * (1 / 75 + 1 / 9) := by
      rw [abs_mul, abs_of_pos (by positivity : (0:ℝ) < c ^ 2)]
      exact mul_le_mul_of_nonneg_left hsum2 (by positivity)
    linarith
  have hnum : 2 * c * (1 / 34 + d / 9) + c ^ 2 * (1 / 75 + 1 / 9) ≤ 6.72 := by
    nlinarith [mul_nonneg hc0.le hd0, sq_nonneg (c - 6.741)]
  calc |Qdel t| = 2 * Real.exp (t / 2)
        * |2 * c * (sinMoment 1 (uPlus t) + sinMoment 1 (uMinus t))
            + c ^ 2 * (cosMoment 2 (uPlus t) + cosMoment 2 (uMinus t))| := by
        rw [Qdel, abs_mul, abs_of_pos (by positivity : (0:ℝ) < 2 * Real.exp (t / 2))]
    _ ≤ 2 * 1.035 * 6.72 := by
        have h1 : (0:ℝ) ≤ |2 * c * (sinMoment 1 (uPlus t) + sinMoment 1 (uMinus t))
            + c ^ 2 * (cosMoment 2 (uPlus t) + cosMoment 2 (uMinus t))| := abs_nonneg _
        have h2 := hinner.trans hnum
        nlinarith
    _ ≤ 14 := by norm_num

/-- `Q` applied to the left-hand piece of the trace remainder is `Qdel(-t)`: the trace
remainder is even in the logarithmic coordinate. -/
theorem Qlog_deltaPieceL_apply (t : ℝ) : Qlog deltaPieceL t = ((Qdel (-t) : ℝ) : ℂ) := by
  have h1 : deriv deltaPieceL = fun s : ℝ => ((-(dl1 (-s)) : ℝ) : ℂ) := by
    funext s
    have hr : HasDerivAt (fun u : ℝ => deltaLogAux (-u)) (-(dl1 (-s))) s := by
      simpa using (hasDerivAt_deltaLogAux (-s)).comp s (hasDerivAt_neg s)
    exact (Complex.ofRealCLM.hasFDerivAt.comp_hasDerivAt s hr).deriv
  have h2 : deriv (deriv deltaPieceL) = fun s : ℝ => ((dl2 (-s) : ℝ) : ℂ) := by
    rw [h1]
    funext s
    have hr : HasDerivAt (fun u : ℝ => -(dl1 (-u))) (dl2 (-s)) s := by
      have := (hasDerivAt_dl1 (-s)).comp s (hasDerivAt_neg s)
      simpa using this.neg
    exact (Complex.ofRealCLM.hasFDerivAt.comp_hasDerivAt s hr).deriv
  have hval : deltaPieceL t = ((deltaLogAux (-t) : ℝ) : ℂ) := rfl
  have hQ : -dl2 (-t) + deltaLogAux (-t) / 4 = Qdel (-t) := by
    rw [deltaLogAux_eq_hMom]
    simp only [dl2, hMom2, hMom1, Qdel]
    ring
  rw [Qlog, h2, hval]
  show -((dl2 (-t) : ℝ) : ℂ) + ((deltaLogAux (-t) : ℝ) : ℂ) / 4 = _
  rw [← hQ]
  push_cast
  ring

/-- **The explicit bound for the kernel `Qδ` of the paper**: `|Q δ(exp t)| ≤ 14` for
`|t| ≤ 1/15`.  This is the rigorous replacement of the numerical verification behind
Figure 8 and Corollary 3.8 of the paper. -/
theorem norm_Qdelta_le {t : ℝ} (ht : |t| ≤ 1 / 15) :
    ‖corner (Qlog deltaPieceR) (Qlog deltaPieceL) t‖ ≤ 14 := by
  have habs := abs_le.mp ht
  rcases le_or_gt 0 t with h | h
  · rw [corner_of_nonneg h, Qlog_deltaPieceR_apply, Complex.norm_real, Real.norm_eq_abs]
    exact abs_Qdel_le h (by linarith [habs.2])
  · rw [corner_of_neg h, Qlog_deltaPieceL_apply, Complex.norm_real, Real.norm_eq_abs]
    exact abs_Qdel_le (by linarith) (by linarith [habs.1])

end ConnesConsani.WeilPositivity
