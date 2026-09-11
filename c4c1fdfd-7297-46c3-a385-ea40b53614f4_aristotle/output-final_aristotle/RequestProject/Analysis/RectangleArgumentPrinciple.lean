/-
Original to this repository (not part of the upstream ZetaZeros development).
-/
import RequestProject.Analysis.ArgumentPrinciple

/-!
# The argument principle on a rectangle

`RequestProject/Analysis/ArgumentPrinciple.lean` proves the argument principle for a *disc*. The
derivation of the Riemann–von Mangoldt formula uses instead the boundary of a *rectangle*, so this
file redoes the argument for that contour.

Mathlib provides the Cauchy–Goursat theorem for a rectangle
(`Complex.integral_boundary_rect_eq_zero_of_differentiableOn`) but not the winding number of the
rectangle around an interior point. That computation — `rectIntegral_sub_inv_of_mem`, done by
exhibiting explicit antiderivatives along the four sides and summing four `arctan` identities — is
the substance of this file; the argument principle `rectIntegral_logDeriv_eq_zeroCount` then
follows from the factorisation of the zeros exactly as in the case of a disc.
-/

namespace ZetaZeros.Analysis

open Complex Filter Function Metric Set intervalIntegral
open scoped Real Topology

/-! ## The rectangle and its boundary integral -/

/-- The closed rectangle with opposite corners `z` and `w`. -/
def rectClosed (z w : ℂ) : Set ℂ := Set.uIcc z.re w.re ×ℂ Set.uIcc z.im w.im

/-- The open rectangle with opposite corners `z` and `w`. -/
def rectOpen (z w : ℂ) : Set ℂ := Ioo z.re w.re ×ℂ Ioo z.im w.im

/-- The boundary of the rectangle with opposite corners `z` and `w`: the four sides. -/
def rectBoundary (z w : ℂ) : Set ℂ := rectClosed z w \ rectOpen z w

/-- The integral of `f` over the boundary of the rectangle with opposite corners `z` and `w`,
traversed counterclockwise; the shape of the left-hand side of Mathlib's Cauchy–Goursat theorem
for a rectangle. -/
noncomputable def rectIntegral (f : ℂ → ℂ) (z w : ℂ) : ℂ :=
  (∫ x : ℝ in z.re..w.re, f (x + z.im * I)) - (∫ x : ℝ in z.re..w.re, f (x + w.im * I)) +
    I • (∫ y : ℝ in z.im..w.im, f (w.re + y * I)) - I • (∫ y : ℝ in z.im..w.im, f (z.re + y * I))

theorem rectOpen_subset_rectClosed (z w : ℂ) : rectOpen z w ⊆ rectClosed z w :=
  fun _ hz => ⟨Icc_subset_uIcc (Ioo_subset_Icc_self hz.1), Icc_subset_uIcc (Ioo_subset_Icc_self hz.2)⟩

theorem isOpen_rectOpen (z w : ℂ) : IsOpen (rectOpen z w) := isOpen_Ioo.reProdIm isOpen_Ioo

theorem isCompact_rectClosed (z w : ℂ) : IsCompact (rectClosed z w) :=
  isCompact_uIcc.reProdIm isCompact_uIcc

theorem isPreconnected_rectOpen (z w : ℂ) : IsPreconnected (rectOpen z w) := by
  have hconv : Convex ℝ (rectOpen z w) :=
    ((convex_Ioo z.re w.re).linear_preimage Complex.reLm).inter
      ((convex_Ioo z.im w.im).linear_preimage Complex.imLm)
  exact hconv.isPreconnected

theorem mem_rectBoundary_bot (z w : ℂ) {x : ℝ} (hx : x ∈ Set.uIcc z.re w.re) :
    ((x : ℂ) + z.im * I) ∈ rectBoundary z w := by
  refine ⟨⟨by simpa using hx, by simp⟩, ?_⟩
  intro hmem
  have h := (Complex.mem_reProdIm.mp hmem).2
  simp only [add_im, ofReal_im, mul_im, ofReal_re, I_im, mul_one, I_re, mul_zero,
    zero_add, add_zero, Set.mem_Ioo] at h
  linarith [h.1]

theorem mem_rectBoundary_top (z w : ℂ) {x : ℝ} (hx : x ∈ Set.uIcc z.re w.re) :
    ((x : ℂ) + w.im * I) ∈ rectBoundary z w := by
  refine ⟨⟨by simpa using hx, by simp⟩, ?_⟩
  intro hmem
  have h := (Complex.mem_reProdIm.mp hmem).2
  simp only [add_im, ofReal_im, mul_im, ofReal_re, I_im, mul_one, I_re, mul_zero,
    zero_add, add_zero, Set.mem_Ioo] at h
  linarith [h.2]

theorem mem_rectBoundary_right (z w : ℂ) {y : ℝ} (hy : y ∈ Set.uIcc z.im w.im) :
    ((w.re : ℂ) + y * I) ∈ rectBoundary z w := by
  refine ⟨⟨by simp, by simpa using hy⟩, ?_⟩
  intro hmem
  have h := (Complex.mem_reProdIm.mp hmem).1
  simp only [add_re, ofReal_re, mul_re, I_re, mul_zero, ofReal_im, I_im, mul_one,
    add_zero, sub_self, Set.mem_Ioo] at h
  linarith [h.2]

theorem mem_rectBoundary_left (z w : ℂ) {y : ℝ} (hy : y ∈ Set.uIcc z.im w.im) :
    ((z.re : ℂ) + y * I) ∈ rectBoundary z w := by
  refine ⟨⟨by simp, by simpa using hy⟩, ?_⟩
  intro hmem
  have h := (Complex.mem_reProdIm.mp hmem).1
  simp only [add_re, ofReal_re, mul_re, I_re, mul_zero, ofReal_im, I_im, mul_one,
    add_zero, sub_self, Set.mem_Ioo] at h
  linarith [h.1]

/-! ## Elementary properties of the boundary integral -/

/-- The boundary integral only sees the values of `f` on the boundary. -/
theorem rectIntegral_congr {f g : ℂ → ℂ} {z w : ℂ} (h : EqOn f g (rectBoundary z w)) :
    rectIntegral f z w = rectIntegral g z w := by
  unfold rectIntegral
  rw [intervalIntegral.integral_congr (f := fun x : ℝ ↦ f (x + z.im * I))
      (fun x hx => h (mem_rectBoundary_bot z w hx)),
    intervalIntegral.integral_congr (f := fun x : ℝ ↦ f (x + w.im * I))
      (fun x hx => h (mem_rectBoundary_top z w hx)),
    intervalIntegral.integral_congr (f := fun y : ℝ ↦ f (w.re + y * I))
      (fun y hy => h (mem_rectBoundary_right z w hy)),
    intervalIntegral.integral_congr (f := fun y : ℝ ↦ f (z.re + y * I))
      (fun y hy => h (mem_rectBoundary_left z w hy))]

section Integrability

variable {f : ℂ → ℂ} {z w : ℂ}

theorem intervalIntegrable_bot (hf : ContinuousOn f (rectBoundary z w)) :
    IntervalIntegrable (fun x : ℝ ↦ f (x + z.im * I)) MeasureTheory.volume z.re w.re :=
  (hf.comp (by fun_prop) fun x hx => mem_rectBoundary_bot z w hx).intervalIntegrable

theorem intervalIntegrable_top (hf : ContinuousOn f (rectBoundary z w)) :
    IntervalIntegrable (fun x : ℝ ↦ f (x + w.im * I)) MeasureTheory.volume z.re w.re :=
  (hf.comp (by fun_prop) fun x hx => mem_rectBoundary_top z w hx).intervalIntegrable

theorem intervalIntegrable_right (hf : ContinuousOn f (rectBoundary z w)) :
    IntervalIntegrable (fun y : ℝ ↦ f (w.re + y * I)) MeasureTheory.volume z.im w.im :=
  (hf.comp (by fun_prop) fun y hy => mem_rectBoundary_right z w hy).intervalIntegrable

theorem intervalIntegrable_left (hf : ContinuousOn f (rectBoundary z w)) :
    IntervalIntegrable (fun y : ℝ ↦ f (z.re + y * I)) MeasureTheory.volume z.im w.im :=
  (hf.comp (by fun_prop) fun y hy => mem_rectBoundary_left z w hy).intervalIntegrable

end Integrability

/-- The boundary integral is additive. -/
theorem rectIntegral_add {f g : ℂ → ℂ} {z w : ℂ} (hf : ContinuousOn f (rectBoundary z w))
    (hg : ContinuousOn g (rectBoundary z w)) :
    rectIntegral (fun ζ ↦ f ζ + g ζ) z w = rectIntegral f z w + rectIntegral g z w := by
  unfold rectIntegral
  rw [intervalIntegral.integral_add (intervalIntegrable_bot hf) (intervalIntegrable_bot hg),
    intervalIntegral.integral_add (intervalIntegrable_top hf) (intervalIntegrable_top hg),
    intervalIntegral.integral_add (intervalIntegrable_right hf) (intervalIntegrable_right hg),
    intervalIntegral.integral_add (intervalIntegrable_left hf) (intervalIntegrable_left hg)]
  simp only [smul_eq_mul]
  ring

/-- The boundary integral commutes with finite sums. -/
theorem rectIntegral_finset_sum {ι : Type*} {s : Finset ι} {F : ι → ℂ → ℂ} {z w : ℂ}
    (hF : ∀ i ∈ s, ContinuousOn (F i) (rectBoundary z w)) :
    rectIntegral (fun ζ ↦ ∑ i ∈ s, F i ζ) z w = ∑ i ∈ s, rectIntegral (F i) z w := by
  unfold rectIntegral
  simp only []
  rw [intervalIntegral.integral_finset_sum (f := fun i (x : ℝ) ↦ F i (x + z.im * I))
      (fun i hi => intervalIntegrable_bot (hF i hi)),
    intervalIntegral.integral_finset_sum (f := fun i (x : ℝ) ↦ F i (x + w.im * I))
      (fun i hi => intervalIntegrable_top (hF i hi)),
    intervalIntegral.integral_finset_sum (f := fun i (y : ℝ) ↦ F i (w.re + y * I))
      (fun i hi => intervalIntegrable_right (hF i hi)),
    intervalIntegral.integral_finset_sum (f := fun i (y : ℝ) ↦ F i (z.re + y * I))
      (fun i hi => intervalIntegrable_left (hF i hi))]
  simp only [smul_eq_mul, Finset.mul_sum]
  rw [← Finset.sum_sub_distrib, ← Finset.sum_add_distrib, ← Finset.sum_sub_distrib]

/-- The boundary integral is homogeneous. -/
theorem rectIntegral_const_mul (a : ℂ) (f : ℂ → ℂ) (z w : ℂ) :
    rectIntegral (fun ζ ↦ a * f ζ) z w = a * rectIntegral f z w := by
  unfold rectIntegral
  rw [intervalIntegral.integral_const_mul, intervalIntegral.integral_const_mul,
    intervalIntegral.integral_const_mul, intervalIntegral.integral_const_mul]
  simp only [smul_eq_mul]
  ring

/-! ## Antiderivatives along the sides -/

/-- An antiderivative of `t ↦ (t + k i)⁻¹` for real `t`, where `k ≠ 0` is real. -/
noncomputable def horizAntideriv (k t : ℝ) : ℂ :=
  ((Real.log (t ^ 2 + k ^ 2) / 2 : ℝ) : ℂ) - I * ((Real.arctan (t / k) : ℝ) : ℂ)

theorem hasDerivAt_horizAntideriv {k : ℝ} (hk : k ≠ 0) (t : ℝ) :
    HasDerivAt (horizAntideriv k) (((t : ℂ) + k * I)⁻¹) t := by
  have hpos : (0:ℝ) < t ^ 2 + k ^ 2 := by positivity
  have h1 : HasDerivAt (fun t : ℝ => Real.log (t ^ 2 + k ^ 2) / 2) (t / (t ^ 2 + k ^ 2)) t := by
    have := (Real.hasDerivAt_log hpos.ne').comp t (((hasDerivAt_id t).pow 2).add_const (k ^ 2))
    simp at this
    convert this.div_const 2 using 1
    field_simp
  have h2 : HasDerivAt (fun t : ℝ => Real.arctan (t / k)) (k / (t ^ 2 + k ^ 2)) t := by
    have := (Real.hasDerivAt_arctan (t / k)).comp t ((hasDerivAt_id t).div_const k)
    simp at this
    convert this using 1
    field_simp
    ring
  have hd := (h1.ofReal_comp).sub ((h2.ofReal_comp).const_mul I)
  have hne : ((t:ℂ) + k * I) ≠ 0 := by
    intro h
    have := congrArg Complex.im h
    simp at this
    exact hk this
  have hden : ((t:ℂ) ^ 2 + (k:ℂ) ^ 2) ≠ 0 := by
    exact_mod_cast (by positivity : (0:ℝ) < t ^ 2 + k ^ 2).ne'
  have hval : ((t / (t ^ 2 + k ^ 2) : ℝ) : ℂ) - I * ((k / (t ^ 2 + k ^ 2) : ℝ) : ℂ)
      = ((t:ℂ) + (k:ℂ) * I)⁻¹ := by
    push_cast
    have key : ((t:ℂ) + (k:ℂ) * I) *
        ((t:ℂ) / ((t:ℂ) ^ 2 + (k:ℂ) ^ 2) - I * ((k:ℂ) / ((t:ℂ) ^ 2 + (k:ℂ) ^ 2))) = 1 := by
      field_simp
      ring_nf
      rw [Complex.I_sq]
      ring
    field_simp at key ⊢
    linear_combination key
  rw [← hval]
  exact hd

theorem integral_inv_shift {a b p k : ℝ} (hk : k ≠ 0) :
    (∫ x : ℝ in a..b, (((x - p : ℝ) : ℂ) + (k : ℝ) * I)⁻¹)
      = horizAntideriv k (b - p) - horizAntideriv k (a - p) := by
  have hderiv : ∀ x ∈ Set.uIcc a b,
      HasDerivAt (fun x : ℝ => horizAntideriv k (x - p)) ((((x - p : ℝ) : ℂ) + k * I)⁻¹) x := by
    intro x _
    have h1 : HasDerivAt (fun x : ℝ => x - p) 1 x := (hasDerivAt_id x).sub_const p
    simpa using (hasDerivAt_horizAntideriv hk (x - p)).scomp x h1
  have hcont : ContinuousOn (fun x : ℝ => (((x - p : ℝ) : ℂ) + (k : ℝ) * I)⁻¹) (Set.uIcc a b) := by
    apply ContinuousOn.inv₀ (by fun_prop)
    intro x _ hcon
    have := congrArg Complex.im hcon
    simp at this
    exact hk this
  rw [integral_eq_sub_of_hasDerivAt hderiv hcont.intervalIntegrable]

/-- The integral of `(ζ - u)⁻¹` along a horizontal side. -/
theorem integral_inv_horizSide {u : ℂ} {y₀ a b : ℝ} (hk : y₀ - u.im ≠ 0) :
    (∫ x : ℝ in a..b, (((x : ℂ) + y₀ * I) - u)⁻¹)
      = horizAntideriv (y₀ - u.im) (b - u.re) - horizAntideriv (y₀ - u.im) (a - u.re) := by
  rw [show (fun x : ℝ ↦ (((x : ℂ) + y₀ * I) - u)⁻¹)
      = fun x : ℝ ↦ (((x - u.re : ℝ) : ℂ) + ((y₀ - u.im : ℝ) : ℝ) * I)⁻¹ by
    funext x
    congr 1
    apply Complex.ext <;> simp]
  exact integral_inv_shift hk

/-- The integral of `(ζ - u)⁻¹` along a vertical side. -/
theorem integral_inv_vertSide {u : ℂ} {x₀ a b : ℝ} (hk : x₀ - u.re ≠ 0) :
    (∫ y : ℝ in a..b, (((x₀ : ℂ) + y * I) - u)⁻¹)
      = -I * (horizAntideriv (-(x₀ - u.re)) (b - u.im)
          - horizAntideriv (-(x₀ - u.re)) (a - u.im)) := by
  rw [show (fun y : ℝ ↦ (((x₀ : ℂ) + y * I) - u)⁻¹)
      = fun y : ℝ ↦ -I * (((y - u.im : ℝ) : ℂ) + ((-(x₀ - u.re) : ℝ) : ℝ) * I)⁻¹ by
    funext y
    have hIX : ((x₀ : ℂ) + y * I - u)
        = I * (((y - u.im : ℝ) : ℂ) + ((-(x₀ - u.re) : ℝ) : ℝ) * I) := by
      apply Complex.ext <;> simp
    rw [hIX, mul_inv, Complex.inv_I]]
  rw [integral_const_mul, integral_inv_shift (neg_ne_zero.mpr hk)]

/-! ## The winding number of a rectangle -/

private theorem arctan_div_add_arctan_div {x y : ℝ} (hx : 0 < x) (hy : 0 < y) :
    Real.arctan (x / y) + Real.arctan (y / x) = π / 2 := by
  rw [show y / x = (x / y)⁻¹ by rw [inv_div], Real.arctan_inv_of_pos (by positivity)]
  ring

/-- The algebraic heart of the winding-number computation: the four sides contribute logarithms
that cancel in pairs and arctangents that add up to `2π`. -/
theorem horizAntideriv_alternating_sum {a b c d : ℝ} (ha : a < 0) (hb : 0 < b) (hc : c < 0)
    (hd : 0 < d) :
    (horizAntideriv c b - horizAntideriv c a) - (horizAntideriv d b - horizAntideriv d a)
      + (horizAntideriv (-b) d - horizAntideriv (-b) c)
      - (horizAntideriv (-a) d - horizAntideriv (-a) c) = 2 * (π : ℂ) * I := by
  have hL : (Real.log (b ^ 2 + c ^ 2) / 2 - Real.log (a ^ 2 + c ^ 2) / 2
      - Real.log (b ^ 2 + d ^ 2) / 2 + Real.log (a ^ 2 + d ^ 2) / 2
      + Real.log (d ^ 2 + (-b) ^ 2) / 2 - Real.log (c ^ 2 + (-b) ^ 2) / 2
      - Real.log (d ^ 2 + (-a) ^ 2) / 2 + Real.log (c ^ 2 + (-a) ^ 2) / 2 : ℝ) = 0 := by ring_nf
  have hS : (Real.arctan (b / c) - Real.arctan (a / c) - Real.arctan (b / d)
      + Real.arctan (a / d) + Real.arctan (d / (-b)) - Real.arctan (c / (-b))
      - Real.arctan (d / (-a)) + Real.arctan (c / (-a)) : ℝ) = -(2 * π) := by
    have hA : 0 < -a := by linarith
    have hC : 0 < -c := by linarith
    have e1 : b / c = -(b / (-c)) := by field_simp
    have e2 : a / c = (-a) / (-c) := by field_simp
    have e3 : a / d = -((-a) / d) := by field_simp
    have e4 : d / (-b) = -(d / b) := by field_simp
    have e5 : c / (-b) = (-c) / b := by field_simp
    have e7 : c / (-a) = -((-c) / (-a)) := by field_simp
    rw [e1, e2, e3, e4, e5, e7, Real.arctan_neg, Real.arctan_neg, Real.arctan_neg, Real.arctan_neg]
    have p1 := arctan_div_add_arctan_div hb hC
    have p2 := arctan_div_add_arctan_div hA hC
    have p3 := arctan_div_add_arctan_div hb hd
    have p4 := arctan_div_add_arctan_div hA hd
    linarith
  have expand : (horizAntideriv c b - horizAntideriv c a)
      - (horizAntideriv d b - horizAntideriv d a)
      + (horizAntideriv (-b) d - horizAntideriv (-b) c)
      - (horizAntideriv (-a) d - horizAntideriv (-a) c)
      = ((Real.log (b ^ 2 + c ^ 2) / 2 - Real.log (a ^ 2 + c ^ 2) / 2
          - Real.log (b ^ 2 + d ^ 2) / 2 + Real.log (a ^ 2 + d ^ 2) / 2
          + Real.log (d ^ 2 + (-b) ^ 2) / 2 - Real.log (c ^ 2 + (-b) ^ 2) / 2
          - Real.log (d ^ 2 + (-a) ^ 2) / 2 + Real.log (c ^ 2 + (-a) ^ 2) / 2 : ℝ) : ℂ)
        - I * ((Real.arctan (b / c) - Real.arctan (a / c) - Real.arctan (b / d)
          + Real.arctan (a / d) + Real.arctan (d / (-b)) - Real.arctan (c / (-b))
          - Real.arctan (d / (-a)) + Real.arctan (c / (-a)) : ℝ) : ℂ) := by
    simp only [horizAntideriv]
    push_cast
    ring
  rw [expand, hL, hS]
  push_cast
  ring

/-- **The winding number of a rectangle around an interior point.** -/
theorem rectIntegral_sub_inv_of_mem {u z w : ℂ} (h₁ : z.re < u.re) (h₂ : u.re < w.re)
    (h₃ : z.im < u.im) (h₄ : u.im < w.im) :
    rectIntegral (fun ζ ↦ (ζ - u)⁻¹) z w = 2 * ↑π * I := by
  have ha : z.re - u.re < 0 := by linarith
  have hb : 0 < w.re - u.re := by linarith
  have hc : z.im - u.im < 0 := by linarith
  have hd : 0 < w.im - u.im := by linarith
  unfold rectIntegral
  rw [integral_inv_horizSide (a := z.re) (b := w.re) hc.ne,
    integral_inv_horizSide (a := z.re) (b := w.re) hd.ne',
    integral_inv_vertSide (a := z.im) (b := w.im) hb.ne',
    integral_inv_vertSide (a := z.im) (b := w.im) ha.ne]
  have hI : I • (-I * (horizAntideriv (-(w.re - u.re)) (w.im - u.im)
        - horizAntideriv (-(w.re - u.re)) (z.im - u.im)))
      - I • (-I * (horizAntideriv (-(z.re - u.re)) (w.im - u.im)
        - horizAntideriv (-(z.re - u.re)) (z.im - u.im)))
      = (horizAntideriv (-(w.re - u.re)) (w.im - u.im)
          - horizAntideriv (-(w.re - u.re)) (z.im - u.im))
        - (horizAntideriv (-(z.re - u.re)) (w.im - u.im)
          - horizAntideriv (-(z.re - u.re)) (z.im - u.im)) := by
    simp only [smul_eq_mul]
    ring_nf
    rw [Complex.I_sq]
    ring
  rw [show (horizAntideriv (z.im - u.im) (w.re - u.re) - horizAntideriv (z.im - u.im) (z.re - u.re))
        - (horizAntideriv (w.im - u.im) (w.re - u.re) - horizAntideriv (w.im - u.im) (z.re - u.re))
        + I • (-I * (horizAntideriv (-(w.re - u.re)) (w.im - u.im)
          - horizAntideriv (-(w.re - u.re)) (z.im - u.im)))
        - I • (-I * (horizAntideriv (-(z.re - u.re)) (w.im - u.im)
          - horizAntideriv (-(z.re - u.re)) (z.im - u.im)))
      = ((horizAntideriv (z.im - u.im) (w.re - u.re)
            - horizAntideriv (z.im - u.im) (z.re - u.re))
          - (horizAntideriv (w.im - u.im) (w.re - u.re)
            - horizAntideriv (w.im - u.im) (z.re - u.re)))
        + ((horizAntideriv (-(w.re - u.re)) (w.im - u.im)
            - horizAntideriv (-(w.re - u.re)) (z.im - u.im))
          - (horizAntideriv (-(z.re - u.re)) (w.im - u.im)
            - horizAntideriv (-(z.re - u.re)) (z.im - u.im))) by
    rw [← hI]; ring]
  linear_combination horizAntideriv_alternating_sum ha hb hc hd

/-- The boundary integral of `(ζ - u)⁻¹` vanishes when `u` lies outside the closed rectangle. -/
theorem rectIntegral_sub_inv_of_notMem {u z w : ℂ} (hu : u ∉ rectClosed z w) :
    rectIntegral (fun ζ ↦ (ζ - u)⁻¹) z w = 0 := by
  have hdiff : DifferentiableOn ℂ (fun ζ : ℂ ↦ (ζ - u)⁻¹) (rectClosed z w) := by
    intro ζ hζ
    apply DifferentiableAt.differentiableWithinAt
    apply DifferentiableAt.inv (by fun_prop)
    intro hcon
    rw [sub_eq_zero] at hcon
    exact hu (hcon ▸ hζ)
  exact Complex.integral_boundary_rect_eq_zero_of_differentiableOn (E := ℂ)
    (fun ζ ↦ (ζ - u)⁻¹) z w hdiff

/-! ## The argument principle -/

/-- **The argument principle on a rectangle.**  If `f` is holomorphic on a neighbourhood of a
closed rectangle `rectClosed z' w'` whose interior contains the closed rectangle `rectClosed z w`,
and `f` has no zero on the boundary of the smaller rectangle, then the integral of `f'/f` over that
boundary is `2πi` times the number of zeros of `f` inside, counted with multiplicity. -/
theorem rectIntegral_logDeriv_eq_zeroCount {f : ℂ → ℂ} {z w z' w' : ℂ}
    (hsub : rectClosed z w ⊆ rectOpen z' w')
    (hf : AnalyticOnNhd ℂ f (rectClosed z' w'))
    (hbd : ∀ ζ ∈ rectBoundary z w, f ζ ≠ 0) :
    rectIntegral (logDeriv f) z w
      = 2 * ↑π * I * ∑ᶠ u ∈ rectOpen z w, (analyticOrderNatAt f u : ℂ) := by
  classical
  have hzB : z ∈ rectBoundary z w := by
    have h := mem_rectBoundary_bot z w (left_mem_uIcc (a := z.re) (b := w.re))
    simpa [Complex.re_add_im] using h
  have hne : ∃ ζ ∈ rectOpen z' w', f ζ ≠ 0 := ⟨z, hsub hzB.1, hbd z hzB⟩
  obtain ⟨s, g, hsU, hg₁, hg₂, hfac, hsz, hmem⟩ :=
    exists_finset_factorization_of_isCompact (isOpen_rectOpen z' w')
      ⟨⟨z, hsub hzB.1⟩, isPreconnected_rectOpen z' w'⟩ (rectOpen_subset_rectClosed z' w')
      (isCompact_rectClosed z' w') hf hne
  have hsne : ∀ u ∈ s, u ∉ rectBoundary z w := fun u hu hcon =>
    hbd u hcon (apply_eq_zero_of_analyticOrderNatAt_ne_zero (hsz u hu))
  -- the logarithmic derivative along the boundary
  have hlog : EqOn (logDeriv f)
      (fun ζ ↦ (∑ u ∈ s, (analyticOrderNatAt f u : ℂ) * (ζ - u)⁻¹) + logDeriv g ζ)
      (rectBoundary z w) := by
    intro ζ hζ
    have hζU : ζ ∈ rectOpen z' w' := hsub hζ.1
    have heq : f =ᶠ[𝓝 ζ] fun x ↦ (∏ u ∈ s, (x - u) ^ analyticOrderNatAt f u) * g x := by
      filter_upwards [(isOpen_rectOpen z' w').mem_nhds hζU] with x hx using hfac x hx
    rw [show logDeriv f ζ
        = logDeriv (fun x ↦ (∏ u ∈ s, (x - u) ^ analyticOrderNatAt f u) * g x) ζ by
      simp only [logDeriv_apply, heq.deriv_eq, heq.eq_of_nhds]]
    exact logDeriv_prod_pow_mul (fun u hu hcon => hsne u hu (hcon ▸ hζ)) (hg₂ ζ hζU)
      (hg₁ ζ hζU).differentiableAt
  -- continuity of the pieces on the boundary
  have hcont₁ : ∀ u ∈ s, ContinuousOn (fun ζ : ℂ ↦ (analyticOrderNatAt f u : ℂ) * (ζ - u)⁻¹)
      (rectBoundary z w) := by
    intro u hu
    apply ContinuousOn.mul continuousOn_const
    apply ContinuousOn.inv₀ (by fun_prop)
    intro ζ hζ hcon
    rw [sub_eq_zero] at hcon
    exact hsne u hu (hcon ▸ hζ)
  have hdg : ∀ ζ ∈ rectClosed z w, DifferentiableAt ℂ (logDeriv g) ζ := by
    intro ζ hζ
    have hζU : ζ ∈ rectOpen z' w' := hsub hζ
    simp only [logDeriv]
    exact (((hg₁ ζ hζU).deriv).div (hg₁ ζ hζU) (hg₂ ζ hζU)).differentiableAt
  have hcont₂ : ContinuousOn (logDeriv g) (rectBoundary z w) := fun ζ hζ =>
    ((hdg ζ hζ.1).continuousAt).continuousWithinAt
  have hcontS : ContinuousOn (fun ζ : ℂ ↦ ∑ u ∈ s, (analyticOrderNatAt f u : ℂ) * (ζ - u)⁻¹)
      (rectBoundary z w) := continuousOn_finset_sum s hcont₁
  rw [rectIntegral_congr hlog, rectIntegral_add hcontS hcont₂, rectIntegral_finset_sum hcont₁]
  -- Cauchy's theorem kills the nonvanishing factor
  have hg0 : rectIntegral (logDeriv g) z w = 0 :=
    Complex.integral_boundary_rect_eq_zero_of_differentiableOn (E := ℂ) (logDeriv g) z w
      fun ζ hζ => (hdg ζ hζ).differentiableWithinAt
  rw [hg0, add_zero]
  -- each zero contributes `2πi` times its multiplicity, and only if it lies inside
  have step1 : ∀ u ∈ s, rectIntegral (fun ζ : ℂ ↦ (analyticOrderNatAt f u : ℂ) * (ζ - u)⁻¹) z w
      = if u ∈ rectOpen z w then (analyticOrderNatAt f u : ℂ) * (2 * ↑π * I) else 0 := by
    intro u hu
    rw [rectIntegral_const_mul]
    by_cases h : u ∈ rectOpen z w
    · rw [if_pos h, rectIntegral_sub_inv_of_mem h.1.1 h.1.2 h.2.1 h.2.2]
    · rw [if_neg h, rectIntegral_sub_inv_of_notMem (fun hcon => hsne u hu ⟨hcon, h⟩), mul_zero]
  rw [Finset.sum_congr rfl step1]
  have step2 : ∑ᶠ u ∈ rectOpen z w, (analyticOrderNatAt f u : ℂ)
      = ∑ u ∈ s.filter (fun u => u ∈ rectOpen z w), (analyticOrderNatAt f u : ℂ) := by
    refine finsum_mem_eq_sum_of_inter_support_eq _ ?_
    ext u
    simp only [Set.mem_inter_iff, Function.mem_support, ne_eq, Nat.cast_eq_zero,
      Finset.coe_filter, Set.mem_setOf_eq]
    constructor
    · rintro ⟨hu, hne'⟩
      exact ⟨⟨hmem u (hsub (rectOpen_subset_rectClosed z w hu)) hne', hu⟩, hne'⟩
    · rintro ⟨⟨_, hu⟩, hne'⟩
      exact ⟨hu, hne'⟩
  rw [step2, Finset.mul_sum, ← Finset.sum_filter]
  exact Finset.sum_congr rfl fun u _ => by ring

end ZetaZeros.Analysis
