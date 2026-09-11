/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Decay of the Fourier transform `δ̂` of the trace remainder of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771.

`RequestProject/FourierSide.lean` only records the crude bound `|δ̂(t)| ≤ δ̂(0)`, which is
useless for large `t`.  Here we prove a bound that *decays*:

  `|δ̂(t)| ≤ 32 π e^{π/(2|t|)} / |t|`   (`abs_deltaFourier_le_decay`),

and in particular `|δ̂(t)| ≤ 104/|t|` for `|t| ≥ 60` (`abs_deltaFourier_le_of_sixty_le`).

The proof is the standard "half-period shift" device.  Writing `g(u) = δ(e^u)`, and using
the invariance of the Lebesgue measure under translations together with
`cos(t(u+π/t)) = -cos(tu)`, one has

  `2 δ̂(t) = ∫ (g(u) - g(u + π/t)) cos(t u) du`,

so that any modulus-of-continuity estimate for `g` gives decay.  The estimate used is the
pointwise derivative bound

  `|(d/du) δ(e^u)| ≤ 16 e^{-|u|/2}`   (`abs_dl1_le`),

which is obtained from the closed form of `δ` in terms of the moments
`∫₀¹ tᵏ cos(a t)(-log t) dt` of `RequestProject/SiSmooth.lean` and the elementary moment
bounds of `RequestProject/KernelBound.lean`.
-/
import RequestProject.Imported.OutputFinal2.KernelBound
import RequestProject.Imported.OutputFinal2.FourierSide

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

/-! ## An inverse-square bound for the first sine moment -/

/-- `|S₁(y)| ≤ (π+1)/y²`: the large-argument bound for the first sine moment, from the
closed form `S₁(y) = (Si y - sin y)/y²`. -/
theorem abs_sinMoment_one_le_inv_sq {y : ℝ} (hy : y ≠ 0) :
    |sinMoment 1 y| ≤ (π + 1) / y ^ 2 := by
  have hy2 : (0:ℝ) < y ^ 2 := by positivity
  have hnum : |Si y - Real.sin y| ≤ π + 1 := by
    have h1 : |Si y| ≤ π := (abs_Si_le_Si_pi y).trans (Si_le_self Real.pi_pos.le)
    have h2 : |Real.sin y| ≤ 1 := Real.abs_sin_le_one y
    calc |Si y - Real.sin y| ≤ |Si y| + |Real.sin y| := abs_sub _ _
      _ ≤ π + 1 := add_le_add h1 h2
  rw [sinMoment_one_eq hy, abs_div, abs_of_pos hy2]
  gcongr

/-! ## The derivative of `δ(e^u)` decays like `e^{-u/2}` -/

/-- The oscillating factor of `δ` decays: `e^t (S(u₊) + S(u₋)) ≤ 5/2` for `t ≥ 0`. -/
theorem exp_mul_hMom_le {t : ℝ} (ht : 0 ≤ t) : Real.exp t * |hMom t| ≤ 5 / 2 := by
  have hpi3 : (3:ℝ) ≤ π := Real.pi_gt_three.le
  have hr1 : (1:ℝ) ≤ Real.exp t := Real.one_le_exp ht
  set r := Real.exp t with hr
  have hr0 : (0:ℝ) < r := Real.exp_pos t
  have hup : (0:ℝ) < uPlus t := by
    rw [uPlus]; positivity
  -- the two normalized sine integrals
  have hA : r * siDiv (uPlus t) ≤ 1 / 2 := by
    have h1 : siDiv (uPlus t) ≤ Si π / uPlus t := siDiv_le_div hup
    have h2 : Si π ≤ π := Si_le_self Real.pi_pos.le
    have h3 : siDiv (uPlus t) ≤ π / (2 * π * (1 + r)) := by
      refine h1.trans ?_
      rw [uPlus]
      gcongr
    have h4 : π / (2 * π * (1 + r)) = 1 / (2 * (1 + r)) := by
      field_simp
    rw [h4] at h3
    have h5 : r * (1 / (2 * (1 + r))) ≤ 1 / 2 := by
      rw [mul_one_div, div_le_div_iff₀ (by positivity) (by norm_num)]
      linarith
    calc r * siDiv (uPlus t) ≤ r * (1 / (2 * (1 + r))) := by
          exact mul_le_mul_of_nonneg_left h3 hr0.le
      _ ≤ 1 / 2 := h5
  have hB : r * siDiv (uMinus t) ≤ 2 := by
    rcases le_or_gt r 2 with hr2 | hr2
    · have h1 : siDiv (uMinus t) ≤ 1 := by
        refine siDiv_le_one ?_
        rw [uMinus]
        nlinarith
      nlinarith [siDiv_pos (uMinus t)]
    · have hum : (0:ℝ) < uMinus t := by
        rw [uMinus]
        have : (0:ℝ) < r - 1 := by linarith
        positivity
      have h1 : siDiv (uMinus t) ≤ Si π / uMinus t := siDiv_le_div hum
      have h2 : Si π ≤ π := Si_le_self Real.pi_pos.le
      have h3 : siDiv (uMinus t) ≤ π / (2 * π * (r - 1)) := by
        refine h1.trans ?_
        rw [uMinus] at hum ⊢
        gcongr
      have h4 : π / (2 * π * (r - 1)) = 1 / (2 * (r - 1)) := by
        have : (0:ℝ) < r - 1 := by linarith
        field_simp
      rw [h4] at h3
      have h5 : r * (1 / (2 * (r - 1))) ≤ 2 := by
        rw [mul_one_div, div_le_iff₀ (by nlinarith)]
        nlinarith
      calc r * siDiv (uMinus t) ≤ r * (1 / (2 * (r - 1))) :=
            mul_le_mul_of_nonneg_left h3 hr0.le
        _ ≤ 2 := h5
  have hval : hMom t = siDiv (uPlus t) + siDiv (uMinus t) := by
    rw [hMom, siDiv_eq_cosMoment, siDiv_eq_cosMoment]
  have hpos : 0 ≤ hMom t := by
    rw [hval]
    exact add_nonneg (siDiv_pos _).le (siDiv_pos _).le
  rw [abs_of_nonneg hpos, hval, mul_add]
  linarith

/-- The derivative of the oscillating factor decays: `2 e^t |h'(t)| ≤ 27/2` for `t ≥ 0`. -/
theorem two_mul_exp_mul_abs_hMom1_le {t : ℝ} (ht : 0 ≤ t) :
    2 * Real.exp t * |hMom1 t| ≤ 27 / 2 := by
  have hpi3 : (3:ℝ) ≤ π := Real.pi_gt_three.le
  have hpi' : π ≤ 3.15 := by linarith [Real.pi_lt_d2]
  have hr1 : (1:ℝ) ≤ Real.exp t := Real.one_le_exp ht
  set r := Real.exp t with hr
  have hr0 : (0:ℝ) < r := Real.exp_pos t
  have hupne : uPlus t ≠ 0 := by
    rw [uPlus]; positivity
  -- the `u₊` term
  have hA : 4 * π * r ^ 2 * |sinMoment 1 (uPlus t)| ≤ 3 / 2 := by
    have h1 : |sinMoment 1 (uPlus t)| ≤ (π + 1) / (uPlus t) ^ 2 :=
      abs_sinMoment_one_le_inv_sq hupne
    have h2 : (2 * π * r) ^ 2 ≤ (uPlus t) ^ 2 := by
      have : 2 * π * r ≤ uPlus t := by
        rw [uPlus]; nlinarith
      nlinarith [mul_pos (mul_pos (by norm_num : (0:ℝ) < 2) Real.pi_pos) hr0]
    have h3 : (π + 1) / (uPlus t) ^ 2 ≤ (π + 1) / (2 * π * r) ^ 2 := by
      apply div_le_div_of_nonneg_left (by linarith) (by positivity) h2
    have h4 : 4 * π * r ^ 2 * ((π + 1) / (2 * π * r) ^ 2) = (π + 1) / π := by
      field_simp
      ring
    calc 4 * π * r ^ 2 * |sinMoment 1 (uPlus t)|
        ≤ 4 * π * r ^ 2 * ((π + 1) / (2 * π * r) ^ 2) := by
          exact mul_le_mul_of_nonneg_left (h1.trans h3) (by positivity)
      _ = (π + 1) / π := h4
      _ ≤ 3 / 2 := by
          rw [div_le_iff₀ (by linarith)]
          linarith
  -- the `u₋` term
  have hB : 4 * π * r ^ 2 * |sinMoment 1 (uMinus t)| ≤ 12 := by
    rcases le_or_gt r (3 / 2) with hr2 | hr2
    · have h1 : |sinMoment 1 (uMinus t)| ≤ |uMinus t| / 9 := abs_sinMoment_one_le _
      have h2 : |uMinus t| = 2 * π * (r - 1) := by
        rw [uMinus, abs_of_nonneg (by nlinarith)]
      rw [h2] at h1
      have h3 : 2 * π * (r - 1) / 9 ≤ π / 9 := by
        rw [div_le_div_iff_of_pos_right (by norm_num)]
        nlinarith
      have h4 : 4 * π * r ^ 2 ≤ 4 * π * (9 / 4) := by nlinarith
      calc 4 * π * r ^ 2 * |sinMoment 1 (uMinus t)|
          ≤ (4 * π * (9 / 4)) * (π / 9) := by
            refine mul_le_mul h4 (h1.trans h3) (abs_nonneg _) (by positivity)
        _ = π ^ 2 := by ring
        _ ≤ 12 := by nlinarith
    · have hum : (0:ℝ) < uMinus t := by
        rw [uMinus]
        have : (0:ℝ) < r - 1 := by linarith
        positivity
      have h1 : |sinMoment 1 (uMinus t)| ≤ (π + 1) / (uMinus t) ^ 2 :=
        abs_sinMoment_one_le_inv_sq (ne_of_gt hum)
      have h2 : (2 * π * r / 3) ^ 2 ≤ (uMinus t) ^ 2 := by
        have hle : 2 * π * r / 3 ≤ uMinus t := by
          rw [uMinus]; nlinarith
        have hpos : (0:ℝ) < 2 * π * r / 3 := by positivity
        nlinarith
      have h3 : (π + 1) / (uMinus t) ^ 2 ≤ (π + 1) / (2 * π * r / 3) ^ 2 :=
        div_le_div_of_nonneg_left (by linarith) (by positivity) h2
      have h4 : 4 * π * r ^ 2 * ((π + 1) / (2 * π * r / 3) ^ 2) = 9 * (π + 1) / π := by
        field_simp
        ring
      calc 4 * π * r ^ 2 * |sinMoment 1 (uMinus t)|
          ≤ 4 * π * r ^ 2 * ((π + 1) / (2 * π * r / 3) ^ 2) :=
            mul_le_mul_of_nonneg_left (h1.trans h3) (by positivity)
        _ = 9 * (π + 1) / π := h4
        _ ≤ 12 := by
            rw [div_le_iff₀ (by linarith)]
            linarith
  -- combine
  have hsum : |sinMoment 1 (uPlus t) + sinMoment 1 (uMinus t)|
      ≤ |sinMoment 1 (uPlus t)| + |sinMoment 1 (uMinus t)| := abs_add_le _ _
  have hval : 2 * Real.exp t * |hMom1 t|
      = 4 * π * r ^ 2 * |sinMoment 1 (uPlus t) + sinMoment 1 (uMinus t)| := by
    rw [hMom1, abs_mul, abs_neg,
      abs_of_pos (by positivity : (0:ℝ) < 2 * π * Real.exp t)]
    rw [← hr]
    ring
  rw [hval]
  have hfac : (0:ℝ) ≤ 4 * π * r ^ 2 := by positivity
  calc 4 * π * r ^ 2 * |sinMoment 1 (uPlus t) + sinMoment 1 (uMinus t)|
      ≤ 4 * π * r ^ 2 * (|sinMoment 1 (uPlus t)| + |sinMoment 1 (uMinus t)|) :=
        mul_le_mul_of_nonneg_left hsum hfac
    _ = 4 * π * r ^ 2 * |sinMoment 1 (uPlus t)| + 4 * π * r ^ 2 * |sinMoment 1 (uMinus t)| := by
        ring
    _ ≤ 3 / 2 + 12 := add_le_add hA hB
    _ ≤ 27 / 2 := by norm_num

/-- **The pointwise decay of the derivative of the trace remainder**:
`|(d/du) δ(e^u)| ≤ 16 e^{-u/2}` for `u ≥ 0`. -/
theorem abs_dl1_le {t : ℝ} (ht : 0 ≤ t) : |dl1 t| ≤ 16 * Real.exp (-(t / 2)) := by
  have hA := exp_mul_hMom_le ht
  have hB := two_mul_exp_mul_abs_hMom1_le ht
  have hE : (0:ℝ) < Real.exp (t / 2) := Real.exp_pos _
  have hsplit : Real.exp (t / 2) = Real.exp (-(t / 2)) * Real.exp t := by
    rw [← Real.exp_add]
    ring_nf
  have h1 : |dl1 t| ≤ Real.exp (t / 2) * |hMom t| + 2 * Real.exp (t / 2) * |hMom1 t| := by
    rw [dl1]
    refine (abs_add_le _ _).trans ?_
    rw [abs_mul, abs_mul, abs_of_pos hE,
      abs_of_pos (by positivity : (0:ℝ) < 2 * Real.exp (t / 2))]
  have h2 : Real.exp (t / 2) * |hMom t| + 2 * Real.exp (t / 2) * |hMom1 t|
      = Real.exp (-(t / 2)) * (Real.exp t * |hMom t| + 2 * Real.exp t * |hMom1 t|) := by
    rw [hsplit]
    ring
  have h3 : Real.exp t * |hMom t| + 2 * Real.exp t * |hMom1 t| ≤ 16 := by linarith
  calc |dl1 t| ≤ Real.exp (t / 2) * |hMom t| + 2 * Real.exp (t / 2) * |hMom1 t| := h1
    _ = Real.exp (-(t / 2)) * (Real.exp t * |hMom t| + 2 * Real.exp t * |hMom1 t|) := h2
    _ ≤ Real.exp (-(t / 2)) * 16 :=
        mul_le_mul_of_nonneg_left h3 (Real.exp_pos _).le
    _ = 16 * Real.exp (-(t / 2)) := by ring

/-! ## A modulus of continuity for `δ` in the logarithmic coordinate -/

/-- `δ(e^u) = δ₀(e^{|u|})`: the trace remainder is even in the logarithmic coordinate. -/
theorem delta_expHomeo_eq_deltaLogAux (t : ℝ) : delta (Rplus.expHomeo t) = deltaLogAux |t| := by
  have hmax : max (Real.exp t) (Real.exp t)⁻¹ = Real.exp |t| := by
    rw [← Real.exp_neg]
    rcases le_or_gt 0 t with h | h
    · rw [abs_of_nonneg h, max_eq_left (Real.exp_le_exp.2 (by linarith))]
    · rw [abs_of_neg h, max_eq_right (Real.exp_le_exp.2 (by linarith))]
  show deltaAux (max (Real.exp t) (Real.exp t)⁻¹) = deltaAux (Real.exp |t|)
  rw [hmax]

/-- The mean value estimate on the right-hand branch:
`|δ₀(e^b) - δ₀(e^a)| ≤ 16 e^{-a/2} (b - a)` for `0 ≤ a ≤ b`. -/
theorem abs_deltaLogAux_sub_le {a b : ℝ} (ha : 0 ≤ a) (hab : a ≤ b) :
    |deltaLogAux b - deltaLogAux a| ≤ 16 * Real.exp (-(a / 2)) * (b - a) := by
  have hkey := Convex.norm_image_sub_le_of_norm_hasDerivWithin_le
    (f := deltaLogAux) (f' := dl1) (s := Set.Icc a b) (C := 16 * Real.exp (-(a / 2)))
    (fun x _ => (hasDerivAt_deltaLogAux x).hasDerivWithinAt)
    (fun x hx => by
      have hx0 : 0 ≤ x := ha.trans hx.1
      have := abs_dl1_le hx0
      have hmono : Real.exp (-(x / 2)) ≤ Real.exp (-(a / 2)) :=
        Real.exp_le_exp.2 (by linarith [hx.1])
      rw [Real.norm_eq_abs]
      nlinarith [Real.exp_pos (-(x / 2))])
    (convex_Icc a b) (Set.left_mem_Icc.2 hab) (Set.right_mem_Icc.2 hab)
  rw [Real.norm_eq_abs, Real.norm_eq_abs, abs_of_nonneg (sub_nonneg.2 hab)] at hkey
  exact hkey

/-- **The modulus of continuity of the trace remainder in the logarithmic coordinate**:
`|δ(e^{u+h}) - δ(e^u)| ≤ 16 h e^{h/2} e^{-|u|/2}` for `h ≥ 0`. -/
theorem abs_delta_expHomeo_shift_sub_le (u : ℝ) {h : ℝ} (hh : 0 ≤ h) :
    |delta (Rplus.expHomeo (u + h)) - delta (Rplus.expHomeo u)|
      ≤ 16 * h * Real.exp (h / 2) * Real.exp (-(|u| / 2)) := by
  have hexp1 : (1:ℝ) ≤ Real.exp (h / 2) := Real.one_le_exp (by linarith)
  rw [delta_expHomeo_eq_deltaLogAux, delta_expHomeo_eq_deltaLogAux]
  rcases le_or_gt 0 u with hu | hu
  · -- both points on the right branch
    have habs1 : |u| = u := abs_of_nonneg hu
    have habs2 : |u + h| = u + h := abs_of_nonneg (by linarith)
    rw [habs1, habs2]
    have hle := abs_deltaLogAux_sub_le (a := u) (b := u + h) hu (by linarith)
    have : 16 * Real.exp (-(u / 2)) * (u + h - u) = 16 * h * Real.exp (-(u / 2)) := by ring
    rw [this] at hle
    refine hle.trans ?_
    have hpos : (0:ℝ) ≤ 16 * h * Real.exp (-(u / 2)) := by positivity
    nlinarith [Real.exp_pos (-(u / 2))]
  · rcases le_or_gt (u + h) 0 with huh | huh
    · -- both points on the left branch
      have habs1 : |u| = -u := abs_of_neg hu
      have habs2 : |u + h| = -(u + h) := abs_of_nonpos huh
      rw [habs1, habs2]
      have hle := abs_deltaLogAux_sub_le (a := -(u + h)) (b := -u) (by linarith) (by linarith)
      rw [abs_sub_comm] at hle
      refine hle.trans (le_of_eq ?_)
      rw [show -u - -(u + h) = h by ring, show -(-(u + h) / 2) = h / 2 + u / 2 by ring,
        Real.exp_add, show -(-u / 2) = u / 2 by ring]
      ring
    · -- the two points straddle the origin
      have habs1 : |u| = -u := abs_of_neg hu
      have habs2 : |u + h| = u + h := abs_of_nonneg (by linarith)
      rw [habs1, habs2]
      have h1 : |deltaLogAux (u + h) - deltaLogAux 0| ≤ 16 * (u + h) := by
        have := abs_deltaLogAux_sub_le (a := 0) (b := u + h) le_rfl (by linarith)
        simpa using this
      have h2 : |deltaLogAux (-u) - deltaLogAux 0| ≤ 16 * (-u) := by
        have := abs_deltaLogAux_sub_le (a := 0) (b := -u) le_rfl (by linarith)
        simpa using this
      have h3 : |deltaLogAux (u + h) - deltaLogAux (-u)| ≤ 16 * h := by
        have := abs_sub_abs_le_abs_sub (deltaLogAux (u + h)) (deltaLogAux (-u))
        calc |deltaLogAux (u + h) - deltaLogAux (-u)|
            ≤ |deltaLogAux (u + h) - deltaLogAux 0| + |deltaLogAux 0 - deltaLogAux (-u)| :=
              abs_sub_le _ _ _
          _ ≤ 16 * (u + h) + 16 * (-u) := by
              rw [abs_sub_comm (deltaLogAux 0)]
              linarith
          _ = 16 * h := by ring
      refine h3.trans ?_
      have hfac : (1:ℝ) ≤ Real.exp (h / 2) * Real.exp (-(-u / 2)) := by
        rw [← Real.exp_add]
        exact Real.one_le_exp (by linarith)
      nlinarith [(by positivity : (0:ℝ) ≤ (16:ℝ) * h)]

/-! ## The decay of `δ̂` -/

/-- The integrand of `δ̂` is integrable. -/
theorem integrable_delta_log_cos (t : ℝ) :
    Integrable (fun u : ℝ => delta (Rplus.expHomeo u) * Real.cos (t * u)) volume :=
  integrable_delta_log_mul (by fun_prop) fun u => Real.abs_cos_le_one _

/-- The shifted integrand is integrable too. -/
theorem integrable_delta_log_shift_cos (t h : ℝ) :
    Integrable (fun u : ℝ => delta (Rplus.expHomeo (u + h)) * Real.cos (t * u)) volume := by
  have hb : Integrable (fun u : ℝ => delta (Rplus.expHomeo (u + h))) volume :=
    integrable_delta_log.comp_add_right h
  refine Integrable.mono' hb ?_ ?_
  · exact (((delta_continuous.comp Rplus.expHomeo.continuous).comp
      (continuous_id.add continuous_const)).mul (by fun_prop)).aestronglyMeasurable
  · filter_upwards with u
    rw [Real.norm_eq_abs, abs_mul, abs_of_pos (delta_pos _)]
    nlinarith [Real.abs_cos_le_one (t * u), abs_nonneg (Real.cos (t * u)),
      (delta_pos (Rplus.expHomeo (u + h))).le]

/-- **The half-period shift identity**: with `h = π/t` one has
`2 δ̂(t) = ∫ (δ(e^u) - δ(e^{u+h})) cos(t u) du`. -/
theorem two_mul_deltaFourier_eq {t : ℝ} (ht : 0 < t) :
    2 * deltaFourier t
      = ∫ u : ℝ, (delta (Rplus.expHomeo u) - delta (Rplus.expHomeo (u + π / t)))
          * Real.cos (t * u) := by
  set h : ℝ := π / t with hh
  set A : ℝ → ℝ := fun u => delta (Rplus.expHomeo u) * Real.cos (t * u) with hA
  have hAint : Integrable A volume := integrable_delta_log_cos t
  have hth : t * h = π := by
    rw [hh]
    field_simp
  set B : ℝ → ℝ := fun u => delta (Rplus.expHomeo (u + h)) * Real.cos (t * u) with hB
  have hBA : ∀ u : ℝ, B u = -A (u + h) := by
    intro u
    show delta (Rplus.expHomeo (u + h)) * Real.cos (t * u)
      = -(delta (Rplus.expHomeo (u + h)) * Real.cos (t * (u + h)))
    have : t * (u + h) = t * u + π := by rw [mul_add, hth]
    rw [this, Real.cos_add_pi]
    ring
  have hBint : Integrable B volume := by
    have := (hAint.comp_add_right h).neg
    exact this.congr (Filter.Eventually.of_forall fun u => (hBA u).symm)
  have hBval : (∫ u : ℝ, B u) = -deltaFourier t := by
    rw [integral_congr_ae (Filter.Eventually.of_forall hBA)]
    rw [integral_neg, integral_add_right_eq_self A h]
    rfl
  have hAval : (∫ u : ℝ, A u) = deltaFourier t := rfl
  have : (∫ u : ℝ, (A u - B u)) = deltaFourier t - -deltaFourier t := by
    rw [integral_sub hAint hBint, hAval, hBval]
  rw [show (fun u : ℝ => (delta (Rplus.expHomeo u) - delta (Rplus.expHomeo (u + h)))
      * Real.cos (t * u)) = fun u => A u - B u from funext fun u => by rw [hA, hB]; ring]
  rw [this]
  ring

/-- **The decay of `δ̂`**: `|δ̂(t)| ≤ 32 π e^{π/(2t)} / t` for `t > 0`. -/
theorem abs_deltaFourier_le_decay_pos {t : ℝ} (ht : 0 < t) :
    |deltaFourier t| ≤ 32 * (π / t) * Real.exp (π / (2 * t)) := by
  set h : ℝ := π / t with hh
  have hh0 : 0 < h := by rw [hh]; positivity
  have hhalf : h / 2 = π / (2 * t) := by
    rw [hh]
    field_simp
  have hkey := two_mul_deltaFourier_eq ht
  set F : ℝ → ℝ := fun u => (delta (Rplus.expHomeo u) - delta (Rplus.expHomeo (u + h)))
      * Real.cos (t * u) with hF
  have hFint : Integrable F volume := by
    have h1 : Integrable (fun u : ℝ => delta (Rplus.expHomeo u) * Real.cos (t * u)) volume :=
      integrable_delta_log_cos t
    have h2 : Integrable (fun u : ℝ => delta (Rplus.expHomeo (u + h)) * Real.cos (t * u))
        volume := integrable_delta_log_shift_cos t h
    refine (h1.sub h2).congr (Filter.Eventually.of_forall fun u => ?_)
    simp only [Pi.sub_apply, hF]
    ring
  have hbound : Integrable (fun u : ℝ => 16 * h * Real.exp (h / 2) * Real.exp (-(|u| / 2)))
      volume := integrable_exp_neg_half_abs.const_mul _
  have hptw : ∀ u : ℝ, ‖F u‖ ≤ 16 * h * Real.exp (h / 2) * Real.exp (-(|u| / 2)) := by
    intro u
    rw [hF, Real.norm_eq_abs, abs_mul]
    have h1 : |delta (Rplus.expHomeo u) - delta (Rplus.expHomeo (u + h))|
        ≤ 16 * h * Real.exp (h / 2) * Real.exp (-(|u| / 2)) := by
      rw [abs_sub_comm]
      exact abs_delta_expHomeo_shift_sub_le u hh0.le
    have h2 : |Real.cos (t * u)| ≤ 1 := Real.abs_cos_le_one _
    nlinarith [abs_nonneg (delta (Rplus.expHomeo u) - delta (Rplus.expHomeo (u + h))),
      abs_nonneg (Real.cos (t * u)),
      (by positivity : (0:ℝ) ≤ 16 * h * Real.exp (h / 2) * Real.exp (-(|u| / 2)))]
  have hint : |2 * deltaFourier t| ≤ 64 * h * Real.exp (h / 2) := by
    rw [hkey]
    calc |∫ u : ℝ, F u| ≤ ∫ u : ℝ, ‖F u‖ := by
          simpa [Real.norm_eq_abs] using norm_integral_le_integral_norm F
      _ ≤ ∫ u : ℝ, 16 * h * Real.exp (h / 2) * Real.exp (-(|u| / 2)) :=
          integral_mono hFint.norm hbound hptw
      _ = 16 * h * Real.exp (h / 2) * 4 := by
          rw [integral_const_mul, integral_exp_neg_half_abs_eq]
      _ = 64 * h * Real.exp (h / 2) := by ring
  rw [abs_mul, abs_of_pos (by norm_num : (0:ℝ) < 2)] at hint
  rw [← hhalf]
  linarith

/-- **The decay of `δ̂`** (even form): `|δ̂(t)| ≤ 32 π e^{π/(2|t|)} / |t|` for `t ≠ 0`. -/
theorem abs_deltaFourier_le_decay {t : ℝ} (ht : t ≠ 0) :
    |deltaFourier t| ≤ 32 * (π / |t|) * Real.exp (π / (2 * |t|)) := by
  have habs : 0 < |t| := abs_pos.2 ht
  have hval : deltaFourier |t| = deltaFourier t := by
    rcases abs_cases t with ⟨h, _⟩ | ⟨h, _⟩
    · rw [h]
    · rw [h, deltaFourier_even]
  rw [← hval]
  exact abs_deltaFourier_le_decay_pos habs

/-- The bound `e^x ≤ 1/(1-x)` for `0 ≤ x < 1`. -/
theorem exp_le_one_div_one_sub {x : ℝ} (hx : x < 1) : Real.exp x ≤ 1 / (1 - x) := by
  have h1 : (0:ℝ) < 1 - x := by linarith
  have h2 : 1 - x ≤ Real.exp (-x) := by
    have := Real.add_one_le_exp (-x)
    linarith
  have h3 : Real.exp x * (1 - x) ≤ 1 := by
    have h4 : Real.exp x * (1 - x) ≤ Real.exp x * Real.exp (-x) :=
      mul_le_mul_of_nonneg_left h2 (Real.exp_pos x).le
    rwa [← Real.exp_add, add_neg_cancel, Real.exp_zero] at h4
  rw [le_div_iff₀ h1]
  exact h3

/-- **A usable explicit decay bound**: `|δ̂(t)| ≤ 104/|t|` for `|t| ≥ 60`. -/
theorem abs_deltaFourier_le_of_sixty_le {t : ℝ} (ht : 60 ≤ |t|) :
    |deltaFourier t| ≤ 104 / |t| := by
  have habs : (0:ℝ) < |t| := by linarith
  have hne : t ≠ 0 := by
    intro h
    rw [h] at ht
    norm_num at ht
  have hpi : π ≤ 3.15 := by linarith [Real.pi_lt_d2]
  have hkey := abs_deltaFourier_le_decay hne
  have hx : π / (2 * |t|) ≤ 3.15 / 120 := by
    rw [div_le_div_iff₀ (by positivity) (by norm_num)]
    nlinarith
  have hexp : Real.exp (π / (2 * |t|)) ≤ 1.027 := by
    have h1 : Real.exp (π / (2 * |t|)) ≤ Real.exp (3.15 / 120) := Real.exp_le_exp.2 hx
    have h2 : Real.exp (3.15 / 120 : ℝ) ≤ 1 / (1 - 3.15 / 120) :=
      exp_le_one_div_one_sub (by norm_num)
    have h3 : (1:ℝ) / (1 - 3.15 / 120) ≤ 1.027 := by norm_num
    linarith
  have hfac : 32 * (π / |t|) * Real.exp (π / (2 * |t|)) ≤ 104 / |t| := by
    have hpos : (0:ℝ) < |t| := habs
    have h1 : 32 * (π / |t|) ≤ 32 * (3.15 / |t|) := by
      have : π / |t| ≤ 3.15 / |t| := by gcongr
      linarith
    have h2 : (0:ℝ) ≤ 32 * (π / |t|) := by positivity
    calc 32 * (π / |t|) * Real.exp (π / (2 * |t|)) ≤ 32 * (3.15 / |t|) * 1.027 := by
          nlinarith [Real.exp_pos (π / (2 * |t|))]
      _ = 103.5216 / |t| := by ring
      _ ≤ 104 / |t| := by gcongr; norm_num
  linarith

end ConnesConsani.WeilPositivity
