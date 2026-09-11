/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

A rigorous lower bound for `δ̂(0) = ∫_ℝ δ(e^u) du`, the value at the origin of the
Fourier transform of the trace remainder `δ` of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771.

By `fourierSide_zero_nonneg_of_deltaFourier_zero_ge` (in `RequestProject/CompactInterval.lean`)
the Fourier-side inequality `f(0) = 2θ'(0) + δ̂(0) ≥ 0` at the origin is exactly the numerical
statement `δ̂(0) ≥ 5.3765`.  This file proves it.  (The true value is `δ̂(0) = 5.42125…`.)

# The scheme

Writing `σ = siDiv`, `σ(x) = Si x / x`, the substitution `r = e^u` turns `δ̂(0)` into

  `δ̂(0) = 4 ∫_1^∞ (σ(2π(1+r)) + σ(2π(r-1))) r^{-1/2} dr`   (`deltaFourier_zero_eq_add`).

The two summands are bounded below separately.

* On `[1, 49/25]` the argument `2π(r-1)` of the second summand stays below `48π/25 ≈ 6.03`,
  and `σ` is bounded below by the truncated Taylor series
  `Q(x) = ∑_{k ≤ 7} (-1)^k x^{2k}/((2k+1)(2k+1)!)` (`siDiv_ge_taylorQ`), a consequence of the
  classical alternating bound for `sin`.  The substitution `r = s²` turns the resulting
  integral into an integral of a polynomial over `[1, 7/5]`, which is evaluated exactly.

* Everywhere else the *exact* expansion `Si x = π/2 - f(x) cos x - g(x) sin x` of
  `RequestProject/SiAsymptotic.lean` is used, with `0 ≤ f(x) ≤ 1/x` and `0 ≤ g(x) ≤ 1/x²`
  both antitone.  Since `2π(r ± 1)` differs from `2πr` by a multiple of `2π`, the main term
  contributes the two elementary integrals

  `∫_1^∞ dr/(4(r+1)√r) = π/8`,   `∫_{49/25}^∞ dr/(4(r-1)√r) = (log 6)/4`,

  and the two oscillating terms are estimated by `abs_integral_mul_halfAntiperiodic_le`: for
  a nonnegative antitone integrable `u`, `|∫_R^∞ u(r) c(r) dr| ≤ ∫_R^{R+1/2} u` whenever
  `|c| ≤ 1` and `c(r + 1/2) = -c(r)` (a half-period shift, as for `cos 2πr` and `sin 2πr`).

The resulting bound is `δ̂(0) ≥ 5.388`, comfortably above the required `5.3765`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.CompactInterval
import RequestProject.Imported.OutputFinal.RequestProject.DeltaDecay
import RequestProject.Imported.OutputFinal.RequestProject.TaylorBounds

noncomputable section

open MeasureTheory Set Real Filter Topology

namespace ConnesConsani.WeilPositivity

/-! ## 0. The two summands -/

/-- The integrand `σ(2π(r+c))/√r` of `δ̂(0)` in the multiplicative variable; `c = ±1`. -/
def gShift (c r : ℝ) : ℝ := siDiv (2 * π * (r + c)) / Real.sqrt r

/-- The `2π(1+r)` summand of the integrand of `δ̂(0)` in the multiplicative variable. -/
def gPlus (r : ℝ) : ℝ := gShift 1 r

/-- The `2π(r-1)` summand of the integrand of `δ̂(0)` in the multiplicative variable. -/
def gMinus (r : ℝ) : ℝ := gShift (-1) r

theorem gPlus_eq (r : ℝ) : gPlus r = siDiv (2 * π * (1 + r)) / Real.sqrt r := by
  rw [gPlus, gShift, add_comm]

theorem gMinus_eq (r : ℝ) : gMinus r = siDiv (2 * π * (r - 1)) / Real.sqrt r := by
  rw [gMinus, gShift, ← sub_eq_add_neg]

/-! ## 1. The Taylor minorant of `Si x / x` -/

/-- The degree-14 truncated Taylor series of `Si x / x`, ending on a negative term. -/
def taylorQ (x : ℝ) : ℝ := siDivPart 8 x

/-- `taylorQ` written out. -/
theorem taylorQ_eq (x : ℝ) :
    taylorQ x = 1 - x ^ 2 / 18 + x ^ 4 / 600 - x ^ 6 / 35280 + x ^ 8 / 3265920
      - x ^ 10 / 439084800 + x ^ 12 / 80951270400 - x ^ 14 / 19615115520000 := by
  simp only [taylorQ, siDivPart, Finset.sum_range_succ, Finset.sum_range_zero]
  norm_num [Nat.factorial]
  ring

/-- `Si x / x ≥ Q(x)` for `x ≥ 0`, where `Q` is the truncated Taylor series `taylorQ`. -/
theorem siDiv_ge_taylorQ {x : ℝ} (hx : 0 ≤ x) : taylorQ x ≤ siDiv x :=
  siDivPart_le_siDiv (by norm_num) (by decide) hx

/-! ## 2. The oscillation bound -/

/-- Translation of a set integral over a half-line. -/
theorem setIntegral_Ioi_shift (f : ℝ → ℝ) (a h : ℝ) :
    (∫ r in Ioi (a + h), f r) = ∫ r in Ioi a, f (r + h) := by
  have hind : (fun r : ℝ => (Ioi (a + h)).indicator f (r + h))
      = (Ioi a).indicator (fun r => f (r + h)) := by
    funext r
    by_cases hr : a < r
    · rw [Set.indicator_of_mem (by simpa using (by linarith : a + h < r + h)),
        Set.indicator_of_mem (by simpa using hr)]
    · rw [Set.indicator_of_notMem (by simp; linarith [not_lt.1 hr]),
        Set.indicator_of_notMem (by simpa using not_lt.1 hr)]
  rw [← integral_indicator measurableSet_Ioi, ← integral_indicator measurableSet_Ioi,
    ← integral_add_right_eq_self (fun r => (Ioi (a + h)).indicator f r) h, hind]

/-- Translation of integrability over a half-line. -/
theorem integrableOn_Ioi_shift {f : ℝ → ℝ} {a h : ℝ}
    (hf : IntegrableOn f (Ioi (a + h)) volume) :
    IntegrableOn (fun r => f (r + h)) (Ioi a) volume := by
  have h1 : Integrable ((Ioi (a + h)).indicator f) volume :=
    (integrable_indicator_iff measurableSet_Ioi).2 hf
  have h2 := h1.comp_add_right h
  have hind : (fun r : ℝ => (Ioi (a + h)).indicator f (r + h))
      = (Ioi a).indicator (fun r => f (r + h)) := by
    funext r
    by_cases hr : a < r
    · rw [Set.indicator_of_mem (by simpa using (by linarith : a + h < r + h)),
        Set.indicator_of_mem (by simpa using hr)]
    · rw [Set.indicator_of_notMem (by simp; linarith [not_lt.1 hr]),
        Set.indicator_of_notMem (by simpa using not_lt.1 hr)]
  rw [hind] at h2
  exact (integrable_indicator_iff measurableSet_Ioi).1 h2

/-- **The oscillation bound**: if `u ≥ 0` is antitone and integrable on `[R,∞)` and `c` is
bounded by `1` and changes sign under the half-period shift `r ↦ r + 1/2`, then
`|∫_R^∞ u(r) c(r) dr| ≤ ∫_R^{R+1/2} u`. -/
theorem abs_integral_mul_halfAntiperiodic_le {R : ℝ} {u c : ℝ → ℝ}
    (hnn : ∀ r ∈ Ici R, 0 ≤ u r) (hanti : AntitoneOn u (Ici R))
    (hint : IntegrableOn u (Ioi R) volume)
    (hcm : Continuous c) (hcb : ∀ r, |c r| ≤ 1) (hc : ∀ r, c (r + 1 / 2) = -c r) :
    |∫ r in Ioi R, u r * c r| ≤ ∫ r in Ioc R (R + 1 / 2), u r := by
  have hmulbd : ∀ v : ℝ → ℝ, IntegrableOn v (Ioi R) volume →
      IntegrableOn (fun r => v r * c r) (Ioi R) volume := by
    intro v hv
    refine Integrable.mono' hv.abs (hv.aestronglyMeasurable.mul hcm.aestronglyMeasurable) ?_
    filter_upwards with r
    rw [Real.norm_eq_abs, abs_mul]
    nlinarith [abs_nonneg (v r), abs_nonneg (c r), hcb r]
  have hsplit : ∀ f : ℝ → ℝ, IntegrableOn f (Ioi R) volume →
      (∫ r in Ioi R, f r) = (∫ r in Ioc R (R + 1/2), f r) + ∫ r in Ioi (R + 1/2), f r := by
    intro f hf
    have hdisj : Disjoint (Ioc R (R + 1/2)) (Ioi (R + 1/2)) := Ioc_disjoint_Ioi le_rfl
    have hu := setIntegral_union hdisj measurableSet_Ioi
      (hf.mono_set Ioc_subset_Ioi_self) (hf.mono_set (Ioi_subset_Ioi (by linarith)))
    rw [Ioc_union_Ioi_eq_Ioi (by linarith)] at hu
    exact hu
  have hintUC : IntegrableOn (fun r => u r * c r) (Ioi R) volume := hmulbd u hint
  have hintShift : IntegrableOn (fun r => u (r + 1/2)) (Ioi R) volume :=
    integrableOn_Ioi_shift (hint.mono_set (Ioi_subset_Ioi (by linarith)))
  have hintShiftC : IntegrableOn (fun r => u (r + 1/2) * c r) (Ioi R) volume :=
    hmulbd _ hintShift
  have hK : (∫ r in Ioi (R + 1/2), u r * c r) = -∫ r in Ioi R, u (r + 1/2) * c r := by
    rw [setIntegral_Ioi_shift (fun r => u r * c r) R (1/2)]
    simp_rw [hc]
    rw [← integral_neg]
    congr 1
    funext r
    ring
  set J := ∫ r in Ioi R, u r * c r with hJdef
  have hJ : J = (∫ r in Ioc R (R + 1/2), u r * c r) - ∫ r in Ioi R, u (r + 1/2) * c r := by
    rw [hJdef, hsplit _ hintUC, hK]
    ring
  have hdiff : (∫ r in Ioi R, (u r - u (r + 1/2)) * c r)
      = J - ∫ r in Ioi R, u (r + 1/2) * c r := by
    rw [hJdef, ← integral_sub hintUC hintShiftC]
    congr 1
    funext r
    ring
  have hb1 : |∫ r in Ioc R (R + 1/2), u r * c r| ≤ ∫ r in Ioc R (R + 1/2), u r := by
    refine le_trans (abs_integral_le_integral_abs) ?_
    refine setIntegral_mono_on ((hintUC.mono_set Ioc_subset_Ioi_self).abs)
      (hint.mono_set Ioc_subset_Ioi_self) measurableSet_Ioc fun r hr => ?_
    have hru : 0 ≤ u r := hnn r (mem_Ici.2 hr.1.le)
    rw [abs_mul, abs_of_nonneg hru]
    nlinarith [hcb r, abs_nonneg (c r)]
  have hdiffnn : ∀ r ∈ Ioi R, 0 ≤ u r - u (r + 1/2) := by
    intro r hr
    have hr' : R < r := hr
    have h1 : r ∈ Ici R := mem_Ici.2 hr'.le
    have h2 : r + 1/2 ∈ Ici R := mem_Ici.2 (by linarith)
    have := hanti h1 h2 (by linarith)
    linarith
  have hb2 : |∫ r in Ioi R, (u r - u (r + 1/2)) * c r| ≤ ∫ r in Ioi R, (u r - u (r + 1/2)) := by
    refine le_trans (abs_integral_le_integral_abs) ?_
    refine setIntegral_mono_on ((hmulbd _ (hint.sub hintShift)).abs)
      (hint.sub hintShift) measurableSet_Ioi fun r hr => ?_
    rw [abs_mul, abs_of_nonneg (hdiffnn r hr)]
    nlinarith [hcb r, abs_nonneg (c r), hdiffnn r hr]
  have hb3 : (∫ r in Ioi R, (u r - u (r + 1/2))) = ∫ r in Ioc R (R + 1/2), u r := by
    rw [integral_sub hint hintShift, ← setIntegral_Ioi_shift u R (1/2), hsplit u hint]
    ring
  rw [hb3] at hb2
  have h2J : 2 * J = (∫ r in Ioc R (R + 1/2), u r * c r)
      + ∫ r in Ioi R, (u r - u (r + 1/2)) * c r := by
    rw [hdiff, hJ]
    ring
  rw [abs_le]
  constructor <;> linarith [(abs_le.1 hb1).1, (abs_le.1 hb1).2, (abs_le.1 hb2).1,
    (abs_le.1 hb2).2, h2J]

theorem cos_two_pi_halfAntiperiodic (r : ℝ) :
    Real.cos (2 * π * (r + 1 / 2)) = -Real.cos (2 * π * r) := by
  rw [show 2 * π * (r + 1 / 2) = 2 * π * r + π by ring, Real.cos_add_pi]

theorem sin_two_pi_halfAntiperiodic (r : ℝ) :
    Real.sin (2 * π * (r + 1 / 2)) = -Real.sin (2 * π * r) := by
  rw [show 2 * π * (r + 1 / 2) = 2 * π * r + π by ring, Real.sin_add_pi]

/-! ## 3. The decomposition of the integrand -/

/-- The Laplace integral `f(x) = ∫_0^∞ e^{-xy}/(1+y²) dy` is antitone. -/
theorem siAuxCos_antitoneOn : AntitoneOn siAuxCos (Ioi 0) := by
  intro x hx y hy hxy
  refine setIntegral_mono_on (integrableOn_siAuxCos hy) (integrableOn_siAuxCos hx)
    measurableSet_Ioi fun t ht => ?_
  have ht' : (0:ℝ) < t := ht
  have h1 : Real.exp (-(y * t)) ≤ Real.exp (-(x * t)) := by
    apply Real.exp_le_exp.2
    nlinarith
  have h2 : (0:ℝ) < 1 + t ^ 2 := by positivity
  gcongr

/-- The Laplace integral `g(x) = ∫_0^∞ y e^{-xy}/(1+y²) dy` is antitone. -/
theorem siAuxSin_antitoneOn : AntitoneOn siAuxSin (Ioi 0) := by
  intro x hx y hy hxy
  refine setIntegral_mono_on (integrableOn_siAuxSin hy) (integrableOn_siAuxSin hx)
    measurableSet_Ioi fun t ht => ?_
  have ht' : (0:ℝ) < t := ht
  have h1 : Real.exp (-(y * t)) ≤ Real.exp (-(x * t)) := by
    apply Real.exp_le_exp.2
    nlinarith
  have h2 : (0:ℝ) < 1 + t ^ 2 := by positivity
  gcongr

/-- The amplitude of the `cos` term in the expansion of `gShift`. -/
def oscA (c r : ℝ) : ℝ := siAuxCos (2 * π * (r + c)) / (2 * π * (r + c) * Real.sqrt r)

/-- The amplitude of the `sin` term in the expansion of `gShift`. -/
def oscB (c r : ℝ) : ℝ := siAuxSin (2 * π * (r + c)) / (2 * π * (r + c) * Real.sqrt r)

/-- **The exact decomposition of the integrand** for an integer shift `c`:
`σ(2π(r+c))/√r = 1/(4(r+c)√r) - A(r) cos(2πr) - B(r) sin(2πr)`. -/
theorem gShift_eq_main_sub {c r : ℝ} (n : ℤ) (hn : c = n) (hr : 0 < r) (hrc : 0 < r + c) :
    gShift c r = 1 / (4 * (r + c) * Real.sqrt r)
      - oscA c r * Real.cos (2 * π * r) - oscB c r * Real.sin (2 * π * r) := by
  have hpi := Real.pi_pos
  have hx : 0 < 2 * π * (r + c) := by positivity
  have hcos : Real.cos (2 * π * (r + c)) = Real.cos (2 * π * r) := by
    rw [hn, show 2 * π * (r + (n:ℝ)) = 2 * π * r + n * (2 * π) by ring,
      Real.cos_add_int_mul_two_pi]
  have hsin : Real.sin (2 * π * (r + c)) = Real.sin (2 * π * r) := by
    rw [hn, show 2 * π * (r + (n:ℝ)) = 2 * π * r + n * (2 * π) by ring,
      Real.sin_add_int_mul_two_pi]
  have hsq : 0 < Real.sqrt r := Real.sqrt_pos.2 hr
  rw [gShift, siDiv_of_ne_zero hx.ne', Si_eq_pi_div_two_sub hx, oscA, oscB, hcos, hsin]
  field_simp
  ring

theorem oscA_nonneg {c r : ℝ} (hr : 0 < r) (hrc : 0 < r + c) : 0 ≤ oscA c r := by
  have hpi := Real.pi_pos
  have hsq : 0 < Real.sqrt r := Real.sqrt_pos.2 hr
  have := siAuxCos_nonneg (2 * π * (r + c))
  rw [oscA]
  positivity

theorem oscB_nonneg {c r : ℝ} (hr : 0 < r) (hrc : 0 < r + c) : 0 ≤ oscB c r := by
  have hpi := Real.pi_pos
  have hsq : 0 < Real.sqrt r := Real.sqrt_pos.2 hr
  have := siAuxSin_nonneg (2 * π * (r + c))
  rw [oscB]
  positivity

theorem oscA_le {c r : ℝ} (hr : 0 < r) (hrc : 0 < r + c) :
    oscA c r ≤ 1 / ((2 * π * (r + c)) ^ 2 * Real.sqrt r) := by
  have hpi := Real.pi_pos
  have hx : 0 < 2 * π * (r + c) := by positivity
  have hsq : 0 < Real.sqrt r := Real.sqrt_pos.2 hr
  have h := siAuxCos_le hx
  have heq : 1 / ((2 * π * (r + c)) ^ 2 * Real.sqrt r)
      = (1 / (2 * π * (r + c))) / (2 * π * (r + c) * Real.sqrt r) := by
    field_simp
  rw [oscA, heq]
  gcongr

theorem oscB_le {c r : ℝ} (hr : 0 < r) (hrc : 0 < r + c) :
    oscB c r ≤ 1 / ((2 * π * (r + c)) ^ 3 * Real.sqrt r) := by
  have hpi := Real.pi_pos
  have hx : 0 < 2 * π * (r + c) := by positivity
  have hsq : 0 < Real.sqrt r := Real.sqrt_pos.2 hr
  have h := siAuxSin_le hx
  have heq : 1 / ((2 * π * (r + c)) ^ 3 * Real.sqrt r)
      = (1 / (2 * π * (r + c)) ^ 2) / (2 * π * (r + c) * Real.sqrt r) := by
    field_simp
  rw [oscB, heq]
  gcongr

theorem oscA_antitoneOn {c R : ℝ} (hR : 0 < R) (hRc : 0 < R + c) :
    AntitoneOn (oscA c) (Ici R) := by
  have hpi := Real.pi_pos
  intro a ha b hb hab
  have ha' : R ≤ a := ha
  have hb' : R ≤ b := hb
  have hac : 0 < a + c := by linarith
  have hbc : 0 < b + c := by linarith
  have ha0 : 0 < a := lt_of_lt_of_le hR ha'
  have hb0 : 0 < b := lt_of_lt_of_le hR hb'
  have hxa : (0:ℝ) < 2 * π * (a + c) := by positivity
  have hxb : (0:ℝ) < 2 * π * (b + c) := by positivity
  have hmono : siAuxCos (2 * π * (b + c)) ≤ siAuxCos (2 * π * (a + c)) :=
    siAuxCos_antitoneOn hxa hxb (by nlinarith)
  have hnn : 0 ≤ siAuxCos (2 * π * (b + c)) := siAuxCos_nonneg _
  have hsa : 0 < Real.sqrt a := Real.sqrt_pos.2 ha0
  have hsb : Real.sqrt a ≤ Real.sqrt b := Real.sqrt_le_sqrt hab
  rw [oscA, oscA]
  gcongr
  nlinarith

theorem oscB_antitoneOn {c R : ℝ} (hR : 0 < R) (hRc : 0 < R + c) :
    AntitoneOn (oscB c) (Ici R) := by
  have hpi := Real.pi_pos
  intro a ha b hb hab
  have ha' : R ≤ a := ha
  have hb' : R ≤ b := hb
  have hac : 0 < a + c := by linarith
  have hbc : 0 < b + c := by linarith
  have ha0 : 0 < a := lt_of_lt_of_le hR ha'
  have hb0 : 0 < b := lt_of_lt_of_le hR hb'
  have hxa : (0:ℝ) < 2 * π * (a + c) := by positivity
  have hxb : (0:ℝ) < 2 * π * (b + c) := by positivity
  have hmono : siAuxSin (2 * π * (b + c)) ≤ siAuxSin (2 * π * (a + c)) :=
    siAuxSin_antitoneOn hxa hxb (by nlinarith)
  have hnn : 0 ≤ siAuxSin (2 * π * (b + c)) := siAuxSin_nonneg _
  have hsa : 0 < Real.sqrt a := Real.sqrt_pos.2 ha0
  have hsb : Real.sqrt a ≤ Real.sqrt b := Real.sqrt_le_sqrt hab
  rw [oscB, oscB]
  gcongr
  nlinarith

/-- `r ^ (-3/2)` is integrable on `(R,∞)` for `R > 0`. -/
theorem integrableOn_rpow_neg_three_halves {R : ℝ} (hR : 0 < R) :
    IntegrableOn (fun r : ℝ => r ^ (-(3:ℝ)/2)) (Ioi R) volume :=
  integrableOn_Ioi_rpow_of_lt (by norm_num) hR

theorem rpow_neg_three_halves_eq {r : ℝ} (hr : 0 < r) :
    r ^ (-(3:ℝ)/2) = 1 / (r * Real.sqrt r) := by
  have h : r ^ ((3:ℝ)/2) = r * Real.sqrt r := by
    rw [show (3:ℝ)/2 = 1 + 1/2 by norm_num, Real.rpow_add hr, Real.rpow_one,
      ← Real.sqrt_eq_rpow]
  rw [show -(3:ℝ)/2 = -((3:ℝ)/2) by ring, Real.rpow_neg hr.le, h, one_div]

/-- The elementary majorant `1/((r+c)^k √r)` is integrable on `(R,∞)` for `k ≥ 1`. -/
theorem integrableOn_inv_pow_mul_sqrt {c R : ℝ} (k : ℕ) (hk : 1 ≤ k) (hR : 1 ≤ R)
    (hRc : 0 < R + c) :
    IntegrableOn (fun r => 1 / ((r + c) ^ k * Real.sqrt r)) (Ioi R) volume := by
  have hR0 : (0:ℝ) < R := lt_of_lt_of_le one_pos hR
  set lam : ℝ := min 1 ((R + c) / R) with hlamdef
  have hlam0 : 0 < lam := lt_min one_pos (div_pos hRc hR0)
  have hlam1 : lam ≤ 1 := min_le_left _ _
  have hkey : ∀ r : ℝ, R ≤ r → lam * r ≤ r + c := by
    intro r hr
    rcases le_or_gt 0 c with hc | hc
    · nlinarith [hlam0.le]
    · have h2 : lam ≤ (R + c) / R := min_le_right _ _
      have h3 : lam * R ≤ R + c := by
        rw [le_div_iff₀ hR0] at h2; linarith
      nlinarith
  have hpos : ∀ r : ℝ, R < r → 0 < (r + c) ^ k * Real.sqrt r := by
    intro r hr
    have hrc : 0 < r + c := lt_of_lt_of_le (mul_pos hlam0 (hR0.trans hr)) (hkey r hr.le)
    have hsq : 0 < Real.sqrt r := Real.sqrt_pos.2 (lt_trans hR0 hr)
    positivity
  have hmeas : AEStronglyMeasurable (fun r : ℝ => 1 / ((r + c) ^ k * Real.sqrt r))
      (volume.restrict (Ioi R)) := by
    apply ContinuousOn.aestronglyMeasurable _ measurableSet_Ioi
    apply ContinuousOn.div continuousOn_const
      (((continuous_id.add continuous_const).pow k).mul Real.continuous_sqrt).continuousOn
    intro r hr
    exact (hpos r hr).ne'
  refine Integrable.mono' ((integrableOn_rpow_neg_three_halves hR0).const_mul (1 / lam ^ k))
    hmeas ?_
  filter_upwards [ae_restrict_mem measurableSet_Ioi] with r hr
  have hr' : R < r := hr
  have hr0 : 0 < r := lt_trans hR0 hr'
  have hr1 : (1:ℝ) ≤ r := le_trans hR hr'.le
  have hrc : 0 < r + c := lt_of_lt_of_le (mul_pos hlam0 hr0) (hkey r hr'.le)
  have hsq : 0 < Real.sqrt r := Real.sqrt_pos.2 hr0
  have hlk : 0 < lam ^ k := pow_pos hlam0 k
  have hpow : lam ^ k * r ^ k ≤ (r + c) ^ k := by
    have h := hkey r hr'.le
    calc lam ^ k * r ^ k = (lam * r) ^ k := (mul_pow _ _ _).symm
      _ ≤ (r + c) ^ k := pow_le_pow_left₀ (by positivity) h k
  have hrk : r ≤ r ^ k := le_self_pow₀ hr1 (by omega)
  have hB : lam ^ k * (r * Real.sqrt r) ≤ (r + c) ^ k * Real.sqrt r := by
    have h1 : lam ^ k * r ≤ lam ^ k * r ^ k := by nlinarith
    nlinarith [hsq.le]
  rw [Real.norm_eq_abs, abs_of_nonneg (by positivity), rpow_neg_three_halves_eq hr0]
  calc 1 / ((r + c) ^ k * Real.sqrt r) ≤ 1 / (lam ^ k * (r * Real.sqrt r)) :=
        one_div_le_one_div_of_le (by positivity) hB
    _ = 1 / lam ^ k * (1 / (r * Real.sqrt r)) := by
        field_simp

theorem integrableOn_oscA {c R : ℝ} (hR : 1 ≤ R) (hRc : 0 < R + c) :
    IntegrableOn (oscA c) (Ioi R) volume := by
  have hpi := Real.pi_pos
  have hR0 : (0:ℝ) < R := lt_of_lt_of_le one_pos hR
  have hmeas : AEStronglyMeasurable (oscA c) (volume.restrict (Ioi R)) :=
    (aemeasurable_restrict_of_antitoneOn measurableSet_Ioi
      ((oscA_antitoneOn hR0 hRc).mono Ioi_subset_Ici_self)).aestronglyMeasurable
  refine Integrable.mono' (((integrableOn_inv_pow_mul_sqrt 2 (by norm_num) hR hRc).const_mul
    (1 / (4 * π ^ 2)))) hmeas ?_
  filter_upwards [ae_restrict_mem measurableSet_Ioi] with r hr
  have hr' : R < r := hr
  have hr0 : 0 < r := lt_trans hR0 hr'
  have hrc : 0 < r + c := by nlinarith [hRc]
  have hsq : 0 < Real.sqrt r := Real.sqrt_pos.2 hr0
  rw [Real.norm_eq_abs, abs_of_nonneg (oscA_nonneg hr0 hrc)]
  have h := oscA_le (c := c) hr0 hrc
  have heq : 1 / ((2 * π * (r + c)) ^ 2 * Real.sqrt r)
      = 1 / (4 * π ^ 2) * (1 / ((r + c) ^ 2 * Real.sqrt r)) := by
    field_simp
    ring
  rw [heq] at h
  exact h

theorem integrableOn_oscB {c R : ℝ} (hR : 1 ≤ R) (hRc : 0 < R + c) :
    IntegrableOn (oscB c) (Ioi R) volume := by
  have hpi := Real.pi_pos
  have hR0 : (0:ℝ) < R := lt_of_lt_of_le one_pos hR
  have hmeas : AEStronglyMeasurable (oscB c) (volume.restrict (Ioi R)) :=
    (aemeasurable_restrict_of_antitoneOn measurableSet_Ioi
      ((oscB_antitoneOn hR0 hRc).mono Ioi_subset_Ici_self)).aestronglyMeasurable
  refine Integrable.mono' (((integrableOn_inv_pow_mul_sqrt 3 (by norm_num) hR hRc).const_mul
    (1 / (8 * π ^ 3)))) hmeas ?_
  filter_upwards [ae_restrict_mem measurableSet_Ioi] with r hr
  have hr' : R < r := hr
  have hr0 : 0 < r := lt_trans hR0 hr'
  have hrc : 0 < r + c := by nlinarith [hRc]
  have hsq : 0 < Real.sqrt r := Real.sqrt_pos.2 hr0
  rw [Real.norm_eq_abs, abs_of_nonneg (oscB_nonneg hr0 hrc)]
  have h := oscB_le (c := c) hr0 hrc
  have heq : 1 / ((2 * π * (r + c)) ^ 3 * Real.sqrt r)
      = 1 / (8 * π ^ 3) * (1 / ((r + c) ^ 3 * Real.sqrt r)) := by
    field_simp
    ring
  rw [heq] at h
  exact h

/-! ## 4. The two elementary integrals -/

theorem integrableOn_main {c R : ℝ} (hR : 1 ≤ R) (hRc : 0 < R + c) :
    IntegrableOn (fun r => 1 / (4 * (r + c) * Real.sqrt r)) (Ioi R) volume := by
  have h := integrableOn_inv_pow_mul_sqrt (c := c) (R := R) 1 (by norm_num) hR hRc
  have he : (fun r : ℝ => 1 / (4 * (r + c) * Real.sqrt r))
      = fun r : ℝ => (1/4) * (1 / ((r + c) ^ 1 * Real.sqrt r)) := by
    funext r
    rw [pow_one, show (4:ℝ) * (r + c) * Real.sqrt r = 4 * ((r + c) * Real.sqrt r) by ring,
      one_div, one_div, mul_inv]
    ring
  rw [he]
  exact h.const_mul _

theorem integral_Ioi_main_plus :
    (∫ r in Ioi (1:ℝ), 1 / (4 * (r + 1) * Real.sqrt r)) = π / 8 := by
  have hderiv : ∀ r ∈ Ioi (1:ℝ), HasDerivAt (fun r : ℝ => Real.arctan (Real.sqrt r) / 2)
      (1 / (4 * (r + 1) * Real.sqrt r)) r := by
    intro r hr
    have hr0 : (0:ℝ) < r := lt_trans one_pos hr
    have hs : HasDerivAt (fun r : ℝ => Real.sqrt r) (1 / (2 * Real.sqrt r)) r :=
      Real.hasDerivAt_sqrt hr0.ne'
    have hcomp := (Real.hasDerivAt_arctan (Real.sqrt r)).comp r hs
    have hsq : Real.sqrt r ^ 2 = r := Real.sq_sqrt hr0.le
    have hspos : 0 < Real.sqrt r := Real.sqrt_pos.2 hr0
    have h2 := hcomp.div_const 2
    convert h2 using 1
    rw [hsq]
    field_simp
    ring
  have hcont : ContinuousWithinAt (fun r : ℝ => Real.arctan (Real.sqrt r) / 2) (Ici 1) 1 :=
    (Real.continuous_arctan.comp Real.continuous_sqrt).continuousWithinAt.div_const 2
  have hlim : Tendsto (fun r : ℝ => Real.arctan (Real.sqrt r) / 2) atTop (𝓝 (π / 4)) := by
    have h1 : Tendsto Real.sqrt atTop atTop := Real.tendsto_sqrt_atTop
    have h2 : Tendsto Real.arctan atTop (𝓝 (π/2)) :=
      tendsto_arctan_atTop.mono_right nhdsWithin_le_nhds
    have h3 := (h2.comp h1).div_const 2
    rw [show π / 2 / 2 = π / 4 by ring] at h3
    exact h3
  have hmain := integral_Ioi_of_hasDerivAt_of_tendsto hcont hderiv
    (integrableOn_main (c := 1) le_rfl (by norm_num)) hlim
  rw [hmain, Real.sqrt_one, Real.arctan_one]
  ring

theorem integral_Ioi_main_minus :
    (∫ r in Ioi (49/25:ℝ), 1 / (4 * (r + (-1)) * Real.sqrt r)) = Real.log 6 / 4 := by
  set F : ℝ → ℝ := fun r => (Real.log (Real.sqrt r - 1) - Real.log (Real.sqrt r + 1)) / 4 with hF
  have hs74 : Real.sqrt (49/25) = 7/5 := by
    rw [show (49/25:ℝ) = (7/5)^2 by norm_num, Real.sqrt_sq (by norm_num)]
  have hsgt : ∀ r : ℝ, (49/25:ℝ) < r → (7:ℝ)/5 < Real.sqrt r := by
    intro r hr
    rw [← hs74]
    exact Real.sqrt_lt_sqrt (by norm_num) hr
  have hderiv : ∀ r ∈ Ioi (49/25:ℝ), HasDerivAt F (1 / (4 * (r + (-1)) * Real.sqrt r)) r := by
    intro r hr
    have hr' : (49/25:ℝ) < r := hr
    have hr0 : (0:ℝ) < r := by linarith
    have hsq : (7:ℝ)/5 < Real.sqrt r := hsgt r hr'
    have hsqr : Real.sqrt r ^ 2 = r := Real.sq_sqrt hr0.le
    have hs : HasDerivAt (fun r : ℝ => Real.sqrt r) (1 / (2 * Real.sqrt r)) r :=
      Real.hasDerivAt_sqrt hr0.ne'
    have hne1 : Real.sqrt r - 1 ≠ 0 := by intro h; nlinarith
    have hne2 : Real.sqrt r + 1 ≠ 0 := by intro h; nlinarith
    have hl1 := (hs.sub_const 1).log hne1
    have hl2 := (hs.add_const 1).log hne2
    have h3 := (hl1.sub hl2).div_const 4
    convert h3 using 1
    have hspos : (0:ℝ) < Real.sqrt r := by linarith
    have hrm : r - 1 = (Real.sqrt r - 1) * (Real.sqrt r + 1) := by nlinarith
    rw [show r + (-1) = r - 1 by ring, hrm]
    field_simp
    ring
  have hcont : ContinuousWithinAt F (Ici (49/25)) (49/25) := by
    have hc : ContinuousAt (fun r : ℝ => Real.sqrt r) (49/25) := Real.continuous_sqrt.continuousAt
    have h1 : ContinuousAt (fun r : ℝ => Real.log (Real.sqrt r - 1)) (49/25) := by
      refine (Real.continuousAt_log ?_).comp (hc.sub continuousAt_const)
      rw [hs74]; norm_num
    have h2 : ContinuousAt (fun r : ℝ => Real.log (Real.sqrt r + 1)) (49/25) := by
      refine (Real.continuousAt_log ?_).comp (hc.add continuousAt_const)
      rw [hs74]; norm_num
    exact ((h1.sub h2).div_const 4).continuousWithinAt
  have hlim : Tendsto F atTop (𝓝 0) := by
    have hsqrt : Tendsto Real.sqrt atTop atTop := Real.tendsto_sqrt_atTop
    have hq : Tendsto (fun s : ℝ => (s - 1) / (s + 1)) atTop (𝓝 1) := by
      have h0 : Tendsto (fun s : ℝ => 2 / (s + 1)) atTop (𝓝 0) :=
        Tendsto.div_atTop tendsto_const_nhds (tendsto_atTop_add_const_right _ 1 tendsto_id)
      have h1 : Tendsto (fun s : ℝ => 1 - 2 / (s + 1)) atTop (𝓝 (1 - 0)) :=
        tendsto_const_nhds.sub h0
      rw [sub_zero] at h1
      refine h1.congr' ?_
      filter_upwards [eventually_gt_atTop (1:ℝ)] with s hs
      field_simp
      ring
    have hlog : Tendsto (fun s : ℝ => Real.log ((s - 1) / (s + 1))) atTop (𝓝 0) := by
      have h := (Real.continuousAt_log (by norm_num : (1:ℝ) ≠ 0)).tendsto.comp hq
      simpa using h
    have h4 := (hlog.comp hsqrt).div_const 4
    rw [zero_div] at h4
    refine h4.congr' ?_
    filter_upwards [eventually_gt_atTop (2:ℝ)] with r hr
    have hs : (1:ℝ) < Real.sqrt r := by
      have h5 : Real.sqrt 1 < Real.sqrt r := Real.sqrt_lt_sqrt (by norm_num) (by linarith)
      simpa using h5
    show Real.log ((Real.sqrt r - 1) / (Real.sqrt r + 1)) / 4 = F r
    rw [hF, Real.log_div (by intro h; nlinarith) (by intro h; nlinarith)]
  have hmain := integral_Ioi_of_hasDerivAt_of_tendsto hcont hderiv
    (integrableOn_main (c := (-1:ℝ)) (by norm_num) (by norm_num)) hlim
  rw [hmain]
  simp only [hF, hs74]
  rw [show (7:ℝ)/5 - 1 = 2/5 by norm_num, show (7:ℝ)/5 + 1 = 12/5 by norm_num]
  have hkey : Real.log (12/5) - Real.log (2/5) = Real.log 6 := by
    rw [← Real.log_div (by norm_num) (by norm_num)]
    norm_num
  linarith

/-! ## 5. The tail estimate -/

/-- Multiplying by a bounded continuous function preserves integrability. -/
theorem integrableOn_mul_bounded {R : ℝ} {v w : ℝ → ℝ} (hv : IntegrableOn v (Ioi R) volume)
    (hwm : Continuous w) (hwb : ∀ r, |w r| ≤ 1) :
    IntegrableOn (fun r => v r * w r) (Ioi R) volume := by
  refine Integrable.mono' hv.abs (hv.aestronglyMeasurable.mul hwm.aestronglyMeasurable) ?_
  filter_upwards with r
  rw [Real.norm_eq_abs, abs_mul]
  nlinarith [abs_nonneg (v r), abs_nonneg (w r), hwb r]

theorem eqOn_gShift {c R : ℝ} (n : ℤ) (hn : c = n) (hR : 1 ≤ R) (hRc : 0 < R + c) :
    EqOn (gShift c) (fun r => 1 / (4 * (r + c) * Real.sqrt r)
      - oscA c r * Real.cos (2 * π * r) - oscB c r * Real.sin (2 * π * r)) (Ioi R) := by
  intro r hr
  have hr' : R < r := hr
  have hr0 : (0:ℝ) < r := lt_of_lt_of_le (lt_of_lt_of_le one_pos hR) hr'.le
  have hrc : 0 < r + c := by linarith
  exact gShift_eq_main_sub n hn hr0 hrc

theorem integrableOn_gShift_tail {c R : ℝ} (n : ℤ) (hn : c = n) (hR : 1 ≤ R) (hRc : 0 < R + c) :
    IntegrableOn (gShift c) (Ioi R) volume := by
  have hcos : Continuous fun r : ℝ => Real.cos (2 * π * r) := by fun_prop
  have hsin : Continuous fun r : ℝ => Real.sin (2 * π * r) := by fun_prop
  have h1 := integrableOn_main (c := c) hR hRc
  have h2 := integrableOn_mul_bounded (integrableOn_oscA hR hRc) hcos
    fun r => Real.abs_cos_le_one _
  have h3 := integrableOn_mul_bounded (integrableOn_oscB hR hRc) hsin
    fun r => Real.abs_sin_le_one _
  have h12 : IntegrableOn (fun r : ℝ => 1 / (4 * (r + c) * Real.sqrt r)
      - oscA c r * Real.cos (2 * π * r)) (Ioi R) volume := h1.sub h2
  have h123 : IntegrableOn (fun r : ℝ => 1 / (4 * (r + c) * Real.sqrt r)
      - oscA c r * Real.cos (2 * π * r) - oscB c r * Real.sin (2 * π * r)) (Ioi R) volume :=
    h12.sub h3
  exact h123.congr_fun (eqOn_gShift n hn hR hRc).symm measurableSet_Ioi

/-- The tail of `gShift` is bounded below by its main term minus the two oscillation
integrals. -/
theorem integral_gShift_tail_ge {c R : ℝ} (n : ℤ) (hn : c = n) (hR : 1 ≤ R) (hRc : 0 < R + c) :
    (∫ r in Ioi R, 1 / (4 * (r + c) * Real.sqrt r))
      - (∫ r in Ioc R (R + 1/2), oscA c r) - (∫ r in Ioc R (R + 1/2), oscB c r)
      ≤ ∫ r in Ioi R, gShift c r := by
  have hR0 : (0:ℝ) < R := lt_of_lt_of_le one_pos hR
  have hcos : Continuous fun r : ℝ => Real.cos (2 * π * r) := by fun_prop
  have hsin : Continuous fun r : ℝ => Real.sin (2 * π * r) := by fun_prop
  have h1 := integrableOn_main (c := c) hR hRc
  have h2 := integrableOn_mul_bounded (integrableOn_oscA hR hRc) hcos
    fun r => Real.abs_cos_le_one _
  have h3 := integrableOn_mul_bounded (integrableOn_oscB hR hRc) hsin
    fun r => Real.abs_sin_le_one _
  have hnnA : ∀ r ∈ Ici R, 0 ≤ oscA c r := by
    intro r hr
    have hr' : R ≤ r := hr
    exact oscA_nonneg (lt_of_lt_of_le hR0 hr') (by linarith)
  have hnnB : ∀ r ∈ Ici R, 0 ≤ oscB c r := by
    intro r hr
    have hr' : R ≤ r := hr
    exact oscB_nonneg (lt_of_lt_of_le hR0 hr') (by linarith)
  have hA := abs_integral_mul_halfAntiperiodic_le (u := oscA c)
    (c := fun r => Real.cos (2 * π * r)) hnnA (oscA_antitoneOn hR0 hRc)
    (integrableOn_oscA hR hRc) hcos (fun r => Real.abs_cos_le_one _)
    cos_two_pi_halfAntiperiodic
  have hB := abs_integral_mul_halfAntiperiodic_le (u := oscB c)
    (c := fun r => Real.sin (2 * π * r)) hnnB (oscB_antitoneOn hR0 hRc)
    (integrableOn_oscB hR hRc) hsin (fun r => Real.abs_sin_le_one _)
    sin_two_pi_halfAntiperiodic
  have h12 : IntegrableOn (fun r : ℝ => 1 / (4 * (r + c) * Real.sqrt r)
      - oscA c r * Real.cos (2 * π * r)) (Ioi R) volume := h1.sub h2
  rw [setIntegral_congr_fun measurableSet_Ioi (eqOn_gShift n hn hR hRc),
    integral_sub h12 h3, integral_sub h1 h2]
  linarith [(abs_le.1 hA).2, (abs_le.1 hB).2]

/-! ### The two elementary integrals over the half-period window -/

theorem integral_Ioc_inv_pow_two {c R : ℝ} (hRc : 0 < R + c) :
    (∫ r in Ioc R (R + 1/2), 1 / (r + c) ^ 2) = 1 / (R + c) - 1 / (R + 1/2 + c) := by
  have hle : R ≤ R + 1/2 := by linarith
  have hderiv : ∀ r ∈ uIcc R (R + 1/2), HasDerivAt (fun r : ℝ => -(1 / (r + c)))
      (1 / (r + c) ^ 2) r := by
    intro r hr
    rw [uIcc_of_le hle] at hr
    have hrc : 0 < r + c := by
      have := hr.1
      linarith
    have hb : HasDerivAt (fun x : ℝ => x + c) 1 r := (hasDerivAt_id r).add_const c
    have h1 : HasDerivAt (fun x : ℝ => (x + c)⁻¹) (-1 / (r + c) ^ 2) r := hb.inv hrc.ne'
    have h2 : HasDerivAt (fun x : ℝ => -(x + c)⁻¹) (1 / (r + c) ^ 2) r := by
      have h3 := h1.neg
      convert h3 using 1
      ring
    have hfun : (fun r : ℝ => -(1 / (r + c))) = fun x : ℝ => -(x + c)⁻¹ := by
      funext x; rw [one_div]
    rw [hfun]
    exact h2
  rw [← intervalIntegral.integral_of_le hle,
    intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv]
  · ring
  · apply ContinuousOn.intervalIntegrable
    rw [uIcc_of_le hle]
    apply ContinuousOn.div continuousOn_const
      ((continuous_id.add continuous_const).pow 2).continuousOn
    intro r hr
    have hrc : 0 < r + c := by have := hr.1; linarith
    positivity

theorem integral_Ioc_inv_pow_three {c R : ℝ} (hRc : 0 < R + c) :
    (∫ r in Ioc R (R + 1/2), 1 / (r + c) ^ 3)
      = 1/2 * (1 / (R + c) ^ 2 - 1 / (R + 1/2 + c) ^ 2) := by
  have hle : R ≤ R + 1/2 := by linarith
  have hderiv : ∀ r ∈ uIcc R (R + 1/2), HasDerivAt (fun r : ℝ => -(1/2) * (1 / (r + c) ^ 2))
      (1 / (r + c) ^ 3) r := by
    intro r hr
    rw [uIcc_of_le hle] at hr
    have hrc : 0 < r + c := by have := hr.1; linarith
    have hb : HasDerivAt (fun x : ℝ => x + c) 1 r := (hasDerivAt_id r).add_const c
    have hp : HasDerivAt (fun x : ℝ => (x + c) ^ 2) (2 * (r + c) ^ 1 * 1) r := hb.pow 2
    have hi : HasDerivAt (fun x : ℝ => ((x + c) ^ 2)⁻¹)
        (-(2 * (r + c) ^ 1 * 1) / ((r + c) ^ 2) ^ 2) r := hp.inv (by positivity)
    have h3 := hi.const_mul (-(1:ℝ)/2)
    have hval : -(1:ℝ)/2 * (-(2 * (r + c) ^ 1 * 1) / ((r + c) ^ 2) ^ 2) = 1 / (r + c) ^ 3 := by
      rw [pow_one]
      field_simp
    have h2 := h3.congr_deriv hval
    have hfun : (fun r : ℝ => -(1/2) * (1 / (r + c) ^ 2))
        = fun y : ℝ => -(1:ℝ)/2 * ((y + c) ^ 2)⁻¹ := by
      funext x; ring
    rw [hfun]
    exact h2
  rw [← intervalIntegral.integral_of_le hle,
    intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv]
  · ring
  · apply ContinuousOn.intervalIntegrable
    rw [uIcc_of_le hle]
    apply ContinuousOn.div continuousOn_const
      ((continuous_id.add continuous_const).pow 3).continuousOn
    intro r hr
    have hrc : 0 < r + c := by have := hr.1; linarith
    positivity

theorem integral_Ioc_oscA_le {c R : ℝ} (hR : 1 ≤ R) (hRc : 0 < R + c) :
    (∫ r in Ioc R (R + 1/2), oscA c r)
      ≤ 1 / (4 * π ^ 2 * Real.sqrt R) * (1 / (R + c) - 1 / (R + 1/2 + c)) := by
  have hpi := Real.pi_pos
  have hR0 : (0:ℝ) < R := lt_of_lt_of_le one_pos hR
  have hsR : 0 < Real.sqrt R := Real.sqrt_pos.2 hR0
  have hmaj : IntegrableOn (fun r : ℝ => 1 / (4 * π ^ 2 * Real.sqrt R) * (1 / (r + c) ^ 2))
      (Ioc R (R + 1/2)) volume := by
    have hcont : ContinuousOn (fun r : ℝ => 1 / (4 * π ^ 2 * Real.sqrt R) * (1 / (r + c) ^ 2))
        (Icc R (R + 1/2)) := by
      apply ContinuousOn.mul continuousOn_const
      apply ContinuousOn.div continuousOn_const
        ((continuous_id.add continuous_const).pow 2).continuousOn
      intro r hr
      have hrc : 0 < r + c := by have := hr.1; linarith
      positivity
    exact (hcont.integrableOn_compact isCompact_Icc).mono_set Ioc_subset_Icc_self
  have hmono : (∫ r in Ioc R (R + 1/2), oscA c r)
      ≤ ∫ r in Ioc R (R + 1/2), 1 / (4 * π ^ 2 * Real.sqrt R) * (1 / (r + c) ^ 2) := by
    refine setIntegral_mono_on ((integrableOn_oscA hR hRc).mono_set Ioc_subset_Ioi_self)
      hmaj measurableSet_Ioc fun r hr => ?_
    have hr1 : R < r := hr.1
    have hr0 : (0:ℝ) < r := lt_trans hR0 hr1
    have hrc : 0 < r + c := by linarith
    have hsr : Real.sqrt R ≤ Real.sqrt r := Real.sqrt_le_sqrt hr1.le
    refine le_trans (oscA_le hr0 hrc) ?_
    rw [show 1 / (4 * π ^ 2 * Real.sqrt R) * (1 / (r + c) ^ 2)
        = 1 / ((2 * π * (r + c)) ^ 2 * Real.sqrt R) by field_simp; ring]
    apply one_div_le_one_div_of_le (by positivity)
    have : (0:ℝ) < (2 * π * (r + c)) ^ 2 := by positivity
    nlinarith
  rw [integral_const_mul, integral_Ioc_inv_pow_two hRc] at hmono
  exact hmono

theorem integral_Ioc_oscB_le {c R : ℝ} (hR : 1 ≤ R) (hRc : 0 < R + c) :
    (∫ r in Ioc R (R + 1/2), oscB c r)
      ≤ 1 / (8 * π ^ 3 * Real.sqrt R) * (1/2 * (1 / (R + c) ^ 2 - 1 / (R + 1/2 + c) ^ 2)) := by
  have hpi := Real.pi_pos
  have hR0 : (0:ℝ) < R := lt_of_lt_of_le one_pos hR
  have hsR : 0 < Real.sqrt R := Real.sqrt_pos.2 hR0
  have hmaj : IntegrableOn (fun r : ℝ => 1 / (8 * π ^ 3 * Real.sqrt R) * (1 / (r + c) ^ 3))
      (Ioc R (R + 1/2)) volume := by
    have hcont : ContinuousOn (fun r : ℝ => 1 / (8 * π ^ 3 * Real.sqrt R) * (1 / (r + c) ^ 3))
        (Icc R (R + 1/2)) := by
      apply ContinuousOn.mul continuousOn_const
      apply ContinuousOn.div continuousOn_const
        ((continuous_id.add continuous_const).pow 3).continuousOn
      intro r hr
      have hrc : 0 < r + c := by have := hr.1; linarith
      positivity
    exact (hcont.integrableOn_compact isCompact_Icc).mono_set Ioc_subset_Icc_self
  have hmono : (∫ r in Ioc R (R + 1/2), oscB c r)
      ≤ ∫ r in Ioc R (R + 1/2), 1 / (8 * π ^ 3 * Real.sqrt R) * (1 / (r + c) ^ 3) := by
    refine setIntegral_mono_on ((integrableOn_oscB hR hRc).mono_set Ioc_subset_Ioi_self)
      hmaj measurableSet_Ioc fun r hr => ?_
    have hr1 : R < r := hr.1
    have hr0 : (0:ℝ) < r := lt_trans hR0 hr1
    have hrc : 0 < r + c := by linarith
    have hsr : Real.sqrt R ≤ Real.sqrt r := Real.sqrt_le_sqrt hr1.le
    refine le_trans (oscB_le hr0 hrc) ?_
    rw [show 1 / (8 * π ^ 3 * Real.sqrt R) * (1 / (r + c) ^ 3)
        = 1 / ((2 * π * (r + c)) ^ 3 * Real.sqrt R) by field_simp; ring]
    apply one_div_le_one_div_of_le (by positivity)
    have : (0:ℝ) < (2 * π * (r + c)) ^ 3 := by positivity
    nlinarith
  rw [integral_const_mul, integral_Ioc_inv_pow_three hRc] at hmono
  exact hmono

/-- `gShift c` is continuous on the positive half-line. -/
theorem continuousOn_gShift (c : ℝ) : ContinuousOn (gShift c) (Ioi (0:ℝ)) := by
  have hfun : gShift c = fun r : ℝ => siDiv (2 * π * (r + c)) / Real.sqrt r := rfl
  rw [hfun]
  intro r hr
  have hr0 : (0:ℝ) < r := hr
  refine ContinuousAt.continuousWithinAt ?_
  have h1 : ContinuousAt (fun r : ℝ => siDiv (2 * π * (r + c))) r :=
    siDiv_continuous.continuousAt.comp (by fun_prop)
  have h2 : ContinuousAt (fun r : ℝ => Real.sqrt r) r := Real.continuous_sqrt.continuousAt
  exact h1.div h2 (by positivity)

theorem integrableOn_gPlus : IntegrableOn gPlus (Ioi 1) volume :=
  integrableOn_gShift_tail (c := (1:ℝ)) (R := (1:ℝ)) 1 (by norm_num) le_rfl (by norm_num)

theorem integrableOn_gMinus : IntegrableOn gMinus (Ioi 1) volume := by
  have hcont : ContinuousOn gMinus (Icc 1 (49/25)) :=
    (continuousOn_gShift (-1)).mono (fun r hr => lt_of_lt_of_le one_pos hr.1)
  have h1 : IntegrableOn gMinus (Ioc 1 (49/25)) volume :=
    (hcont.integrableOn_compact isCompact_Icc).mono_set Ioc_subset_Icc_self
  have h2 : IntegrableOn gMinus (Ioi (49/25)) volume :=
    integrableOn_gShift_tail (c := (-1:ℝ)) (R := (49/25:ℝ)) (-1) (by norm_num) (by norm_num)
      (by norm_num)
  have hset : Ioi (1:ℝ) = Ioc 1 (49/25) ∪ Ioi (49/25) := (Ioc_union_Ioi_eq_Ioi (by norm_num)).symm
  rw [hset]
  exact h1.union h2

/-! ## 5. The three estimates -/

/-- The `2π(1+r)` summand contributes at least `π/8 - 0.0028`. -/
theorem integral_gPlus_ge : π / 8 - 0.0028 ≤ ∫ r in Ioi (1:ℝ), gPlus r := by
  have hpi : (3.14159:ℝ) < π := by linarith [Real.pi_gt_d6]
  have hpipos := Real.pi_pos
  have hbase := integral_gShift_tail_ge (c := (1:ℝ)) (R := (1:ℝ)) 1 (by norm_num) le_rfl
    (by norm_num)
  rw [integral_Ioi_main_plus] at hbase
  have hA := integral_Ioc_oscA_le (c := (1:ℝ)) (R := (1:ℝ)) le_rfl (by norm_num)
  have hB := integral_Ioc_oscB_le (c := (1:ℝ)) (R := (1:ℝ)) le_rfl (by norm_num)
  rw [Real.sqrt_one] at hA hB
  have h4 : (39.47:ℝ) ≤ 4 * π ^ 2 * 1 := by nlinarith
  have h8 : (248:ℝ) ≤ 8 * π ^ 3 * 1 := by nlinarith
  have hA2 : (∫ r in Ioc (1:ℝ) (1 + 1/2), oscA 1 r) ≤ 0.00254 := by
    refine hA.trans ?_
    have h1 : (1:ℝ) / (4 * π ^ 2 * 1) ≤ 1 / 39.47 := one_div_le_one_div_of_le (by norm_num) h4
    have h2 : (1:ℝ) / (1 + 1) - 1 / (1 + 1/2 + 1) = 1/10 := by norm_num
    rw [h2]
    linarith
  have hB2 : (∫ r in Ioc (1:ℝ) (1 + 1/2), oscB 1 r) ≤ 0.00019 := by
    refine hB.trans ?_
    have h1 : (1:ℝ) / (8 * π ^ 3 * 1) ≤ 1 / 248 := one_div_le_one_div_of_le (by norm_num) h8
    have h2 : (1:ℝ) / 2 * (1 / (1 + 1) ^ 2 - 1 / (1 + 1/2 + 1) ^ 2) = 9/200 := by norm_num
    rw [h2]
    linarith
  simp only [gPlus]
  linarith

/-! ### The head interval `[1, 49/25]`: a certified quadrature -/

/-- **Tangent-line minorant of `r ↦ 1/√r`** at the point `r = s²`: for `r, s > 0`,
`(3s² - r)/(2s³) ≤ 1/√r`, by convexity (the difference is `(√r-s)²(√r+2s)/(2s³√r)`). -/
theorem tangent_inv_sqrt_le {r s : ℝ} (hr : 0 < r) (hs : 0 < s) :
    (3 * s ^ 2 - r) / (2 * s ^ 3) ≤ 1 / Real.sqrt r := by
  set t := Real.sqrt r with hti
  have ht : 0 < t := Real.sqrt_pos.2 hr
  have hsq : t ^ 2 = r := Real.sq_sqrt hr.le
  rw [← hsq]
  have key : 1/t - (3*s^2 - t^2)/(2*s^3) = (t - s)^2*(t + 2*s)/(2*s^3*t) := by
    field_simp
    ring
  have hnn : 0 ≤ (t - s)^2*(t + 2*s)/(2*s^3*t) :=
    div_nonneg (mul_nonneg (sq_nonneg _) (by linarith)) (by positivity)
  linarith

/-- The antiderivative of `u ↦ siDivPart n (a u) * (C - u)`. -/
def siDivIntPart (n : ℕ) (a C u : ℝ) : ℝ :=
  ∑ k ∈ Finset.range n, ((-1:ℝ)^k * a^(2*k) / ((2*k+1) * (2*k+1).factorial))
      * (C * u^(2*k+1)/(2*k+1) - u^(2*k+2)/(2*k+2))

theorem hasDerivAt_siDivIntPart (n : ℕ) (a C u : ℝ) :
    HasDerivAt (siDivIntPart n a C) (siDivPart n (a*u) * (C - u)) u := by
  have hfun : siDivIntPart n a C = ∑ k ∈ Finset.range n,
      (fun u : ℝ => ((-1:ℝ)^k * a^(2*k) / ((2*k+1) * (2*k+1).factorial))
        * (C * u^(2*k+1)/(2*k+1) - u^(2*k+2)/(2*k+2))) := by
    funext v; simp [siDivIntPart]
  have hval : siDivPart n (a*u) * (C - u)
      = ∑ k ∈ Finset.range n, ((-1:ℝ)^k * a^(2*k) / ((2*k+1) * (2*k+1).factorial))
        * (C * u^(2*k) - u^(2*k+1)) := by
    rw [siDivPart, Finset.sum_mul]
    refine Finset.sum_congr rfl fun k _ => ?_
    rw [mul_pow]
    ring
  rw [hfun, hval]
  refine HasDerivAt.sum fun k _ => ?_
  have hA : HasDerivAt (fun u : ℝ => C * u^(2*k+1)/(2*(k:ℝ)+1)) (C * u^(2*k)) u := by
    have h := ((hasDerivAt_pow (2*k+1) u).const_mul C).div_const ((2*(k:ℝ)+1))
    convert h using 1
    simp only [Nat.add_sub_cancel]
    push_cast
    field_simp
  have hB : HasDerivAt (fun u : ℝ => u^(2*k+2)/(2*(k:ℝ)+2)) (u^(2*k+1)) u := by
    have h := (hasDerivAt_pow (2*k+2) u).div_const ((2*(k:ℝ)+2))
    rw [show 2*k+2-1 = 2*k+1 from rfl] at h
    convert h using 1
    push_cast
    field_simp
  exact (hA.sub hB).const_mul _

theorem continuous_siDivPart (n : ℕ) : Continuous (siDivPart n) := by
  unfold siDivPart
  exact continuous_finset_sum _ fun k _ => by fun_prop

/-- `gMinus` is interval integrable on any interval inside the positive half-line. -/
theorem intervalIntegrable_gMinus {a b : ℝ} (ha : 0 < a) (hab : a ≤ b) :
    IntervalIntegrable gMinus volume a b := by
  refine ContinuousOn.intervalIntegrable ?_
  refine (continuousOn_gShift (-1)).mono ?_
  rw [uIcc_of_le hab]
  intro r hr
  exact lt_of_lt_of_le ha hr.1

/-- **One piece of the certified quadrature.**  On `[a,b] ⊆ [1, 3s²]` the integrand `gMinus`
is bounded below by the degree-14 Taylor minorant of `Si/·` times the tangent-line minorant
of `1/√r` at `s²`, and the latter is integrated exactly. -/
theorem integral_head_piece_ge {a b s : ℝ} (ha : 1 ≤ a) (hab : a ≤ b) (hs : 0 < s)
    (hC : b ≤ 3 * s ^ 2) :
    (siDivIntPart 8 (2*π) (3*s^2-1) (b-1) - siDivIntPart 8 (2*π) (3*s^2-1) (a-1)) / (2*s^3)
      ≤ ∫ r in a..b, gMinus r := by
  set C := 3*s^2 - 1 with hCdef
  have huIcc : uIcc a b = Icc a b := uIcc_of_le hab
  have hcontm : Continuous (fun r : ℝ => siDivPart 8 (2*π*(r-1)) * ((3*s^2 - r)/(2*s^3))) := by
    have h1 : Continuous (fun r : ℝ => siDivPart 8 (2*π*(r-1))) :=
      (continuous_siDivPart 8).comp (by fun_prop)
    have h2 : Continuous (fun r : ℝ => (3*s^2 - r)/(2*s^3)) := by
      have hne : (2*s^3) ≠ 0 := by positivity
      fun_prop (disch := assumption)
    exact h1.mul h2
  have hint2 : IntervalIntegrable
      (fun r => siDivPart 8 (2*π*(r-1)) * ((3*s^2 - r)/(2*s^3))) volume a b :=
    hcontm.intervalIntegrable a b
  have hderiv : ∀ r ∈ uIcc a b, HasDerivAt (fun r : ℝ => siDivIntPart 8 (2*π) C (r-1) / (2*s^3))
      (siDivPart 8 (2*π*(r-1)) * ((3*s^2 - r)/(2*s^3))) r := by
    intro r _
    have hsub : HasDerivAt (fun r : ℝ => r - 1) 1 r := (hasDerivAt_id r).sub_const 1
    have h0 := HasDerivAt.comp r (hasDerivAt_siDivIntPart 8 (2*π) C (r-1)) hsub
    have h1 : HasDerivAt (fun r : ℝ => siDivIntPart 8 (2*π) C (r-1))
        (siDivPart 8 (2*π*(r-1)) * (C - (r-1)) * 1) r := by
      simpa [Function.comp_def] using h0
    have h2 := h1.div_const (2*s^3)
    convert h2 using 1
    rw [hCdef]
    field_simp
    ring
  have hFTC := intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hint2
  have hint1 : IntervalIntegrable gMinus volume a b :=
    intervalIntegrable_gMinus (lt_of_lt_of_le one_pos ha) hab
  have hle : ∀ r ∈ Icc a b, siDivPart 8 (2*π*(r-1)) * ((3*s^2 - r)/(2*s^3)) ≤ gMinus r := by
    intro r hr
    have hr1 : 1 ≤ r := le_trans ha hr.1
    have hr0 : (0:ℝ) < r := lt_of_lt_of_le one_pos hr1
    have hx : 0 ≤ 2*π*(r-1) := by
      have := Real.pi_pos
      nlinarith
    have hL0 : 0 ≤ (3*s^2 - r)/(2*s^3) := by
      have hrs : r ≤ 3*s^2 := le_trans hr.2 hC
      have h2 : (0:ℝ) < 2*s^3 := by positivity
      exact div_nonneg (by linarith) h2.le
    have hQ := siDivPart_le_siDiv (n := 8) (by norm_num) (by decide) hx
    have hpos := (siDiv_pos (2*π*(r-1))).le
    have hT := tangent_inv_sqrt_le (r := r) (s := s) hr0 hs
    calc siDivPart 8 (2*π*(r-1)) * ((3*s^2 - r)/(2*s^3))
        ≤ siDiv (2*π*(r-1)) * ((3*s^2 - r)/(2*s^3)) := by nlinarith
      _ ≤ siDiv (2*π*(r-1)) * (1 / Real.sqrt r) := by nlinarith
      _ = gMinus r := by rw [gMinus_eq]; field_simp
  have hmono := intervalIntegral.integral_mono_on hab hint2 hint1 hle
  rw [hFTC] at hmono
  calc (siDivIntPart 8 (2*π) C (b-1) - siDivIntPart 8 (2*π) C (a-1)) / (2*s^3)
      = siDivIntPart 8 (2*π) C (b-1) / (2*s^3) - siDivIntPart 8 (2*π) C (a-1) / (2*s^3) := by
        ring
    _ ≤ ∫ r in a..b, gMinus r := hmono

/-- Rational enclosures of the even powers of `π` up to `π^14`, obtained from
`3.141592 < π < 3.141593` by repeated multiplication. -/
theorem pi_pow_bounds :
    (9.8696:ℝ) ≤ π^2 ∧ π^2 ≤ 9.8697 ∧ (97.408:ℝ) ≤ π^4 ∧ π^4 ≤ 97.41 ∧
    (961.38:ℝ) ≤ π^6 ∧ π^6 ≤ 961.41 ∧ (9488.4:ℝ) ≤ π^8 ∧ π^8 ≤ 9488.9 ∧
    (93646:ℝ) ≤ π^10 ∧ π^10 ≤ 93653 ∧ (924248:ℝ) ≤ π^12 ∧ π^12 ≤ 924333 ∧
    (9121950:ℝ) ≤ π^14 ∧ π^14 ≤ 9123090 := by
  have hlo : (3.141592:ℝ) < π := Real.pi_gt_d6
  have hhi : π < 3.141593 := Real.pi_lt_d6
  have hpos : (0:ℝ) < π := Real.pi_pos
  have p2l : (9.8696:ℝ) ≤ π^2 := by nlinarith
  have p2u : π^2 ≤ 9.8697 := by nlinarith
  have step : ∀ (x lo hi : ℝ), lo ≤ x → x ≤ hi → (0:ℝ) ≤ lo →
      lo * 9.8696 ≤ x * π^2 ∧ x * π^2 ≤ hi * 9.8697 := by
    intro x lo hi h1 h2 h3
    exact ⟨mul_le_mul h1 p2l (by norm_num) (le_trans h3 h1),
      mul_le_mul h2 p2u (by positivity) (le_trans (le_trans h3 h1) h2)⟩
  have p4 := step (π^2) 9.8696 9.8697 p2l p2u (by norm_num)
  have p4l : (97.408:ℝ) ≤ π^4 := by nlinarith [p4.1]
  have p4u : π^4 ≤ 97.41 := by nlinarith [p4.2]
  have p6 := step (π^4) 97.408 97.41 p4l p4u (by norm_num)
  have p6l : (961.38:ℝ) ≤ π^6 := by nlinarith [p6.1]
  have p6u : π^6 ≤ 961.41 := by nlinarith [p6.2]
  have p8 := step (π^6) 961.38 961.41 p6l p6u (by norm_num)
  have p8l : (9488.4:ℝ) ≤ π^8 := by nlinarith [p8.1]
  have p8u : π^8 ≤ 9488.9 := by nlinarith [p8.2]
  have p10 := step (π^8) 9488.4 9488.9 p8l p8u (by norm_num)
  have p10l : (93646:ℝ) ≤ π^10 := by nlinarith [p10.1]
  have p10u : π^10 ≤ 93653 := by nlinarith [p10.2]
  have p12 := step (π^10) 93646 93653 p10l p10u (by norm_num)
  have p12l : (924248:ℝ) ≤ π^12 := by nlinarith [p12.1]
  have p12u : π^12 ≤ 924333 := by nlinarith [p12.2]
  have p14 := step (π^12) 924248 924333 p12l p12u (by norm_num)
  have p14l : (9121950:ℝ) ≤ π^14 := by nlinarith [p14.1]
  have p14u : π^14 ≤ 9123090 := by nlinarith [p14.2]
  exact ⟨p2l, p2u, p4l, p4u, p6l, p6u, p8l, p8u, p10l, p10u, p12l, p12u, p14l, p14u⟩

/-- On `[1, 49/25]` the `2π(r-1)` summand contributes at least `0.5145`.  The proof is a
certified quadrature: the interval is split into the four pieces `[1,1.24]`, `[1.24,1.48]`,
`[1.48,1.72]`, `[1.72,1.96]`, on each of which `Si(2π(r-1))/(2π(r-1))` is replaced by its
degree-14 Taylor minorant and `1/√r` by the tangent line at the midpoint; the resulting
polynomial integrals are evaluated exactly and estimated with `pi_pow_bounds`.
(The true value of the integral is `0.51673…`.) -/
theorem integral_gMinus_head_ge : (0.5145 : ℝ) ≤ ∫ r in (1:ℝ)..(49/25), gMinus r := by
  obtain ⟨p2l, p2u, p4l, p4u, p6l, p6u, p8l, p8u, p10l, p10u, p12l, p12u, p14l, p14u⟩ :=
    pi_pow_bounds
  have n1 : (0.2175:ℝ) ≤ ∫ r in (1:ℝ)..(31/25), gMinus r := by
    refine le_trans ?_ (integral_head_piece_ge (a := 1) (b := 31/25) (s := 53/50)
      le_rfl (by norm_num) (by norm_num) (by norm_num))
    simp only [siDivIntPart, Finset.sum_range_succ, Finset.sum_range_zero]
    norm_num [Nat.factorial]
    linarith
  have n2 : (0.1550:ℝ) ≤ ∫ r in (31/25:ℝ)..(37/25), gMinus r := by
    refine le_trans ?_ (integral_head_piece_ge (a := 31/25) (b := 37/25) (s := 583/500)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num))
    simp only [siDivIntPart, Finset.sum_range_succ, Finset.sum_range_zero]
    norm_num [Nat.factorial]
    linarith
  have n3 : (0.0913:ℝ) ≤ ∫ r in (37/25:ℝ)..(43/25), gMinus r := by
    refine le_trans ?_ (integral_head_piece_ge (a := 37/25) (b := 43/25) (s := 253/200)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num))
    simp only [siDivIntPart, Finset.sum_range_succ, Finset.sum_range_zero]
    norm_num [Nat.factorial]
    linarith
  have n4 : (0.0512:ℝ) ≤ ∫ r in (43/25:ℝ)..(49/25), gMinus r := by
    refine le_trans ?_ (integral_head_piece_ge (a := 43/25) (b := 49/25) (s := 339/250)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num))
    simp only [siDivIntPart, Finset.sum_range_succ, Finset.sum_range_zero]
    norm_num [Nat.factorial]
    linarith
  have s1 := intervalIntegral.integral_add_adjacent_intervals
    (intervalIntegrable_gMinus (a := 1) (b := 31/25) one_pos (by norm_num))
    (intervalIntegrable_gMinus (a := 31/25) (b := 37/25) (by norm_num) (by norm_num))
  have s2 := intervalIntegral.integral_add_adjacent_intervals
    (intervalIntegrable_gMinus (a := 1) (b := 37/25) one_pos (by norm_num))
    (intervalIntegrable_gMinus (a := 37/25) (b := 43/25) (by norm_num) (by norm_num))
  have s3 := intervalIntegral.integral_add_adjacent_intervals
    (intervalIntegrable_gMinus (a := 1) (b := 43/25) one_pos (by norm_num))
    (intervalIntegrable_gMinus (a := 43/25) (b := 49/25) (by norm_num) (by norm_num))
  linarith


/-- Beyond `49/25` the `2π(r-1)` summand contributes at least `(log 6)/4 - 0.0074`. -/
theorem integral_gMinus_tail_ge :
    Real.log 6 / 4 - 0.0074 ≤ ∫ r in Ioi (49/25:ℝ), gMinus r := by
  have hpi : (3.14159:ℝ) < π := by linarith [Real.pi_gt_d6]
  have hpipos := Real.pi_pos
  have hp2 : (9.8695:ℝ) < π ^ 2 := by nlinarith
  have hp3 : (31.006:ℝ) < π ^ 3 := by nlinarith
  have hs : Real.sqrt (49/25) = 7/5 := by
    rw [show (49/25:ℝ) = (7/5)^2 by norm_num, Real.sqrt_sq (by norm_num)]
  have hbase := integral_gShift_tail_ge (c := (-1:ℝ)) (R := (49/25:ℝ)) (-1) (by norm_num)
    (by norm_num) (by norm_num)
  rw [integral_Ioi_main_minus] at hbase
  have hA := integral_Ioc_oscA_le (c := (-1:ℝ)) (R := (49/25:ℝ)) (by norm_num) (by norm_num)
  have hB := integral_Ioc_oscB_le (c := (-1:ℝ)) (R := (49/25:ℝ)) (by norm_num) (by norm_num)
  rw [hs] at hA hB
  have h4 : (55.26:ℝ) ≤ 4 * π ^ 2 * (7/5) := by nlinarith
  have h8 : (347:ℝ) ≤ 8 * π ^ 3 * (7/5) := by nlinarith
  have hA2 : (∫ r in Ioc (49/25:ℝ) (49/25 + 1/2), oscA (-1) r) ≤ 0.00646 := by
    refine hA.trans ?_
    have h1 : (1:ℝ) / (4 * π ^ 2 * (7/5)) ≤ 1 / 55.26 := one_div_le_one_div_of_le (by norm_num) h4
    have h2 : (1:ℝ) / (49/25 + -1) - 1 / (49/25 + 1/2 + -1) ≤ 0.3568 := by norm_num
    have h3 : (0:ℝ) ≤ 1 / (49/25 + -1) - 1 / (49/25 + 1/2 + -1) := by norm_num
    have h5 : (0:ℝ) < 1 / (4 * π ^ 2 * (7/5)) := by positivity
    nlinarith
  have hB2 : (∫ r in Ioc (49/25:ℝ) (49/25 + 1/2), oscB (-1) r) ≤ 0.00089 := by
    refine hB.trans ?_
    have h1 : (1:ℝ) / (8 * π ^ 3 * (7/5)) ≤ 1 / 347 := one_div_le_one_div_of_le (by norm_num) h8
    have h2 : (1:ℝ) / 2 * (1 / (49/25 + -1) ^ 2 - 1 / (49/25 + 1/2 + -1) ^ 2) ≤ 0.308 := by
      norm_num
    have h3 : (0:ℝ) ≤ 1 / 2 * (1 / (49/25 + -1) ^ 2 - 1 / (49/25 + 1/2 + -1) ^ 2) := by norm_num
    have h5 : (0:ℝ) < 1 / (8 * π ^ 3 * (7/5)) := by positivity
    nlinarith
  simp only [gMinus]
  linarith

/-! ### The change of variables `r = e^u` -/

theorem delta_expHomeo_eq (t : ℝ) : delta (Rplus.expHomeo t) = deltaAux (Real.exp |t|) := by
  have hmax : max (Real.exp t) (Real.exp t)⁻¹ = Real.exp |t| := by
    rw [← Real.exp_neg]
    rcases le_or_gt 0 t with h | h
    · rw [abs_of_nonneg h, max_eq_left (Real.exp_le_exp.2 (by linarith))]
    · rw [abs_of_neg h, max_eq_right (Real.exp_le_exp.2 (by linarith))]
  show deltaAux (max (Real.exp t) (Real.exp t)⁻¹) = _
  rw [hmax]

theorem deltaAux_div_eq {r : ℝ} (hr : 0 < r) : deltaAux r / r = 2 * (gPlus r + gMinus r) := by
  have hs : Real.sqrt r ≠ 0 := by positivity
  rw [deltaAux_explicit, gPlus_eq, gMinus_eq]
  field_simp
  rw [Real.sq_sqrt hr.le]

theorem integrableOn_deltaAux_div : IntegrableOn (fun r => deltaAux r / r) (Ioi (1:ℝ)) volume := by
  have h : IntegrableOn (fun r : ℝ => 2 * (gPlus r + gMinus r)) (Ioi 1) volume :=
    (integrableOn_gPlus.add integrableOn_gMinus).const_mul 2
  exact h.congr_fun (fun r hr => (deltaAux_div_eq (lt_trans one_pos hr)).symm) measurableSet_Ioi

/-- **The value of `δ̂` at the origin as an integral over `(1,∞)`**:
`δ̂(0) = 4 ∫_1^∞ (σ(2π(1+r)) + σ(2π(r-1))) r^{-1/2} dr`, by the substitution `r = e^u`. -/
theorem deltaFourier_zero_eq_add :
    deltaFourier 0 = 4 * ((∫ r in Ioi (1:ℝ), gPlus r) + ∫ r in Ioi (1:ℝ), gMinus r) := by
  have h1 : deltaFourier 0 = ∫ u : ℝ, deltaAux (Real.exp |u|) := by
    rw [deltaFourier]
    refine integral_congr_ae (Filter.Eventually.of_forall fun u => ?_)
    show delta (Rplus.expHomeo u) * Real.cos (0 * u) = deltaAux (Real.exp |u|)
    rw [zero_mul, Real.cos_zero, mul_one, delta_expHomeo_eq]
  have h2 : (∫ u : ℝ, deltaAux (Real.exp |u|)) = 2 * ∫ x in Ioi (0:ℝ), deltaAux (Real.exp x) :=
    integral_comp_abs (f := fun x => deltaAux (Real.exp x))
  have himg : Real.exp '' Ici (0:ℝ) ⊆ Ici (1:ℝ) := by
    rintro y ⟨x, hx, rfl⟩
    exact Real.one_le_exp hx
  have himg2 : Real.exp '' Ioi (0:ℝ) ⊆ Ioi (0:ℝ) := by
    rintro y ⟨x, hx, rfl⟩
    exact Real.exp_pos x
  have hgcont : ContinuousOn (fun r : ℝ => deltaAux r / r) (Real.exp '' Ioi (0:ℝ)) := by
    refine ContinuousOn.mono ?_ himg2
    intro r hr
    have hr0 : (0:ℝ) < r := hr
    exact (deltaAux_continuous.continuousAt.div continuousAt_id hr0.ne').continuousWithinAt
  have hg1 : IntegrableOn (fun r : ℝ => deltaAux r / r) (Real.exp '' Ici (0:ℝ)) volume := by
    refine IntegrableOn.mono_set ?_ himg
    have hI := integrableOn_deltaAux_div
    rwa [← integrableOn_Ici_iff_integrableOn_Ioi] at hI
  have hg2 : IntegrableOn (fun x => ((fun r : ℝ => deltaAux r / r) ∘ Real.exp) x * Real.exp x)
      (Ici (0:ℝ)) volume := by
    have h := integrable_delta_log.integrableOn (s := Ici (0:ℝ))
    refine h.congr_fun (fun x hx => ?_) measurableSet_Ici
    have hx0 : (0:ℝ) ≤ x := hx
    have hne : Real.exp x ≠ 0 := (Real.exp_pos x).ne'
    simp only [Function.comp]
    rw [delta_expHomeo_eq, abs_of_nonneg hx0]
    field_simp
  have h3 := integral_comp_mul_deriv_Ioi (f := Real.exp) (f' := Real.exp)
    (g := fun r : ℝ => deltaAux r / r) (a := 0)
    Real.continuous_exp.continuousOn Real.tendsto_exp_atTop
    (fun x _ => (Real.hasDerivAt_exp x).hasDerivWithinAt) hgcont hg1 hg2
  rw [Real.exp_zero] at h3
  have h4 : (∫ x in Ioi (0:ℝ), deltaAux (Real.exp x))
      = ∫ r in Ioi (1:ℝ), deltaAux r / r := by
    rw [← h3]
    refine setIntegral_congr_fun measurableSet_Ioi (fun x _ => ?_)
    simp only [Function.comp]
    have hne : Real.exp x ≠ 0 := (Real.exp_pos x).ne'
    field_simp
  have h5 : (∫ r in Ioi (1:ℝ), deltaAux r / r)
      = 2 * ((∫ r in Ioi (1:ℝ), gPlus r) + ∫ r in Ioi (1:ℝ), gMinus r) := by
    rw [setIntegral_congr_fun measurableSet_Ioi
      (fun r hr => deltaAux_div_eq (lt_trans one_pos hr)), integral_const_mul,
      integral_add integrableOn_gPlus integrableOn_gMinus]
  rw [h1, h2, h4, h5]
  ring

/-! ## 6. The bound at the origin -/

/-- `log 3 > 1.0985`, from `exp 1 < 2.7182818286` and a partial sum of the exponential
series. -/
theorem log_three_gt : (1.0985 : ℝ) < Real.log 3 := by
  have hb : |Real.exp (0.0985:ℝ) - ∑ m ∈ Finset.range 4, (0.0985:ℝ) ^ m / m.factorial|
      ≤ |(0.0985:ℝ)| ^ 4 * ((4:ℕ).succ / ((Nat.factorial 4) * (4:ℕ))) :=
    Real.exp_bound (by rw [abs_of_nonneg (by norm_num : (0:ℝ) ≤ 0.0985)]; norm_num) (by norm_num)
  have habs := (abs_le.1 hb).2
  have hexp : Real.exp (0.0985 : ℝ) < 1.10352 := by
    rw [abs_of_nonneg (by norm_num : (0:ℝ) ≤ 0.0985)] at habs
    norm_num [Finset.sum_range_succ, Nat.factorial] at habs
    linarith
  have h1 : Real.exp (1.0985 : ℝ) < 3 := by
    have hmul : Real.exp (1.0985 : ℝ) = Real.exp 1 * Real.exp 0.0985 := by
      rw [← Real.exp_add]; norm_num
    have h2 := Real.exp_one_lt_d9
    have hpos : (0:ℝ) < Real.exp 0.0985 := Real.exp_pos _
    rw [hmul]; nlinarith
  calc (1.0985:ℝ) = Real.log (Real.exp 1.0985) := (Real.log_exp _).symm
    _ < Real.log 3 := Real.log_lt_log (Real.exp_pos _) h1

/-- `log 6 > 1.7916`. -/
theorem log_six_gt : (1.7916 : ℝ) < Real.log 6 := by
  have h : Real.log 6 = Real.log 2 + Real.log 3 := by
    rw [← Real.log_mul (by norm_num) (by norm_num)]; norm_num
  rw [h]
  linarith [Real.log_two_gt_d9, log_three_gt]

/-- **`δ̂(0) ≥ 5.3795`.**  The true value is `5.42125…`; the loss of `0.04` is the total
slack of the three certified estimates below (`0.0028 + 0.0074` on the two oscillating
tails, the rest on the quadrature of the head). -/
theorem deltaFourier_zero_ge_d4 : (5.3795 : ℝ) ≤ deltaFourier 0 := by
  have hint : IntervalIntegrable gMinus volume 1 (49/25) := by
    rw [intervalIntegrable_iff_integrableOn_Ioc_of_le (by norm_num)]
    exact integrableOn_gMinus.mono_set (Ioc_subset_Ioi_self)
  have hsplit : (∫ r in (1:ℝ)..(49/25), gMinus r) + (∫ r in Ioi (49/25:ℝ), gMinus r)
      = ∫ r in Ioi (1:ℝ), gMinus r :=
    intervalIntegral.integral_interval_add_Ioi' hint
      (integrableOn_gMinus.mono_set (Ioi_subset_Ioi (by norm_num)))
  have hpi : (3.14159 : ℝ) < π := by linarith [Real.pi_gt_d6]
  rw [deltaFourier_zero_eq_add]
  linarith [integral_gPlus_ge, integral_gMinus_head_ge, integral_gMinus_tail_ge, hsplit,
    log_six_gt]

/-- **`δ̂(0) ≥ 5.3765`**, the form in which the bound is used in
`RequestProject/CompactInterval.lean`. -/
theorem deltaFourier_zero_ge : (5.3765 : ℝ) ≤ deltaFourier 0 :=
  le_trans (by norm_num) deltaFourier_zero_ge_d4

/-- **The Fourier-side inequality at the origin**: `f(0) = 2θ'(0) + δ̂(0) ≥ 0`. -/
theorem fourierSide_zero_nonneg : 0 ≤ fourierSide 0 :=
  fourierSide_zero_nonneg_of_deltaFourier_zero_ge deltaFourier_zero_ge

end ConnesConsani.WeilPositivity
