/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Alternating Taylor bounds for `sin`, `cos` and the sine integral `Si`.

For `t ≥ 0` the partial sums of the Taylor series of `sin` and `cos` bracket the functions:
the error has the sign of the first omitted term.  Mathlib has only the first few instances
of this (`Real.sin_le`, `Real.cos_le_one`, `Real.sin_gt_sub_cube` on `[0,1]`); the general
statement is proved here by the classical simultaneous induction, each step integrating the
previous one.

The consequence used in `RequestProject/DeltaFourierZero.lean` is the lower bound

  `Si x / x ≥ ∑_{k < n} (-1)^k x^{2k}/((2k+1)(2k+1)!)`   (`n` even, `x ≥ 0`),

the truncated Taylor series of `Si x / x` ending on a negative term.
-/
import RequestProject.Imported.OutputFinal.RequestProject.SineIntegral

noncomputable section

open MeasureTheory Set Real Filter Topology

namespace ConnesConsani.WeilPositivity

/-! ## A one-dimensional comparison lemma -/

/-- If `F 0 = 0` and `F' ≥ 0` on `[0,∞)` then `F ≥ 0` on `[0,∞)`. -/
theorem nonneg_of_deriv_nonneg {F F' : ℝ → ℝ} (hF : ∀ t, HasDerivAt F (F' t) t)
    (h0 : F 0 = 0) (hd : ∀ t, 0 ≤ t → 0 ≤ F' t) {t : ℝ} (ht : 0 ≤ t) : 0 ≤ F t := by
  have hmono : MonotoneOn F (Ici 0) := by
    refine monotoneOn_of_deriv_nonneg (convex_Ici 0)
      (fun x _ => (hF x).continuousAt.continuousWithinAt)
      (fun x _ => (hF x).differentiableAt.differentiableWithinAt) (fun x hx => ?_)
    rw [interior_Ici] at hx
    rw [(hF x).deriv]
    exact hd x (le_of_lt hx)
  have := hmono Set.self_mem_Ici (Set.mem_Ici.2 ht) ht
  linarith [h0]

/-! ## The partial sums -/

/-- The `n`-th partial sum of the Taylor series of `sin` at the origin. -/
def sinPart (n : ℕ) (t : ℝ) : ℝ :=
  ∑ k ∈ Finset.range n, (-1:ℝ)^k * t^(2*k+1)/(2*k+1).factorial

/-- The `n`-th partial sum of the Taylor series of `cos` at the origin. -/
def cosPart (n : ℕ) (t : ℝ) : ℝ :=
  ∑ k ∈ Finset.range n, (-1:ℝ)^k * t^(2*k)/(2*k).factorial

@[simp] theorem sinPart_zero (n : ℕ) : sinPart n 0 = 0 := by simp [sinPart]

theorem cosPart_zero {n : ℕ} (hn : 1 ≤ n) : cosPart n 0 = 1 := by
  obtain ⟨m, rfl⟩ := Nat.exists_eq_add_of_le hn
  rw [add_comm, cosPart,
    Finset.sum_range_succ' (fun k => (-1:ℝ)^k * (0:ℝ)^(2*k)/(2*k).factorial) m]
  simp

@[simp] theorem sinPart_one (t : ℝ) : sinPart 1 t = t := by simp [sinPart]

@[simp] theorem cosPart_one (t : ℝ) : cosPart 1 t = 1 := by simp [cosPart]

theorem hasDerivAt_sinPart (n : ℕ) (t : ℝ) : HasDerivAt (sinPart n) (cosPart n t) t := by
  have hfun : sinPart n = ∑ k ∈ Finset.range n,
      (fun t : ℝ => (-1:ℝ)^k * t^(2*k+1)/(2*k+1).factorial) := by
    funext s; simp [sinPart]
  rw [hfun, cosPart]
  refine HasDerivAt.sum fun k _ => ?_
  have h := (((hasDerivAt_pow (2*k+1) t).const_mul ((-1:ℝ)^k)).div_const ((2*k+1).factorial : ℝ))
  convert h using 1
  have hf : ((2*k+1).factorial : ℝ) = (2*k+1) * (2*k).factorial := by
    rw [Nat.factorial_succ]; push_cast; ring
  have hpos : ((2*k).factorial : ℝ) ≠ 0 := Nat.cast_ne_zero.2 (Nat.factorial_ne_zero _)
  rw [hf]
  simp only [Nat.add_sub_cancel]
  field_simp
  push_cast
  ring

theorem hasDerivAt_cosPart (n : ℕ) (t : ℝ) :
    HasDerivAt (cosPart (n+1)) (-(sinPart n t)) t := by
  have hfun : cosPart (n+1) = fun t : ℝ => (1 : ℝ) + ∑ i ∈ Finset.range n,
      (-1:ℝ)^(i+1) * t^(2*i+2)/(2*i+2).factorial := by
    funext s
    rw [cosPart, Finset.sum_range_succ' (fun k => (-1:ℝ)^k * s^(2*k)/(2*k).factorial) n]
    simp [add_comm, mul_add]
  rw [hfun]
  have hsum : HasDerivAt (fun t : ℝ => ∑ i ∈ Finset.range n,
      (-1:ℝ)^(i+1) * t^(2*i+2)/(2*i+2).factorial)
      (∑ i ∈ Finset.range n, (-1:ℝ)^(i+1) * t^(2*i+1)/(2*i+1).factorial) t := by
    have hfun2 : (fun t : ℝ => ∑ i ∈ Finset.range n,
        (-1:ℝ)^(i+1) * t^(2*i+2)/(2*i+2).factorial)
        = ∑ i ∈ Finset.range n, (fun t : ℝ => (-1:ℝ)^(i+1) * t^(2*i+2)/(2*i+2).factorial) := by
      funext s; simp
    rw [hfun2]
    refine HasDerivAt.sum fun i _ => ?_
    have h := (((hasDerivAt_pow (2*i+2) t).const_mul ((-1:ℝ)^(i+1))).div_const
      ((2*i+2).factorial : ℝ))
    convert h using 1
    have hf : ((2*i+2).factorial : ℝ) = (2*i+2) * (2*i+1).factorial := by
      rw [show 2*i+2 = (2*i+1)+1 from rfl, Nat.factorial_succ]; push_cast; ring
    have hpos : ((2*i+1).factorial : ℝ) ≠ 0 := Nat.cast_ne_zero.2 (Nat.factorial_ne_zero _)
    rw [hf]
    field_simp
    push_cast
    ring
  have := (hasDerivAt_const t (1:ℝ)).add hsum
  convert this using 1
  rw [sinPart, zero_add, ← Finset.sum_neg_distrib]
  exact Finset.sum_congr rfl fun i _ => by ring

/-! ## The alternating bounds -/

/-- **The Taylor remainder of `sin` and `cos` has the sign of the first omitted term**, for
`t ≥ 0` (uniform version, needed for the induction). -/
theorem taylor_sign_forall {n : ℕ} (hn : 1 ≤ n) :
    ∀ t : ℝ, 0 ≤ t → 0 ≤ (-1:ℝ)^n * (Real.cos t - cosPart n t) ∧
      0 ≤ (-1:ℝ)^n * (Real.sin t - sinPart n t) := by
  induction n, hn using Nat.le_induction with
  | base =>
      intro t ht
      constructor
      · simp only [pow_one, cosPart_one]
        nlinarith [Real.cos_le_one t]
      · simp only [pow_one, sinPart_one]
        nlinarith [Real.sin_le ht]
  | succ n hn ih =>
      have hcos : ∀ s : ℝ, 0 ≤ s → 0 ≤ (-1:ℝ)^(n+1) * (Real.cos s - cosPart (n+1) s) := by
        intro s hs
        refine nonneg_of_deriv_nonneg
          (F := fun u : ℝ => (-1:ℝ)^(n+1) * (Real.cos u - cosPart (n+1) u))
          (F' := fun u : ℝ => (-1:ℝ)^(n+1) * (-Real.sin u - -(sinPart n u))) ?_ ?_ ?_ hs
        · intro u
          exact ((Real.hasDerivAt_cos u).sub (hasDerivAt_cosPart n u)).const_mul _
        · show (-1:ℝ)^(n+1) * (Real.cos 0 - cosPart (n+1) 0) = 0
          rw [cosPart_zero (Nat.le_add_left 1 n)]
          simp
        · intro u hu
          show 0 ≤ (-1:ℝ)^(n+1) * (-Real.sin u - -(sinPart n u))
          have h := (ih u hu).2
          have heq : (-1:ℝ)^(n+1) * (-Real.sin u - -(sinPart n u))
              = (-1:ℝ)^n * (Real.sin u - sinPart n u) := by
            rw [pow_succ]; ring
          rw [heq]
          exact h
      intro t ht
      refine ⟨hcos t ht, ?_⟩
      refine nonneg_of_deriv_nonneg
        (F := fun u : ℝ => (-1:ℝ)^(n+1) * (Real.sin u - sinPart (n+1) u))
        (F' := fun u : ℝ => (-1:ℝ)^(n+1) * (Real.cos u - cosPart (n+1) u)) ?_ ?_ ?_ ht
      · intro u
        exact ((Real.hasDerivAt_sin u).sub (hasDerivAt_sinPart (n+1) u)).const_mul _
      · simp
      · intro u hu
        exact hcos u hu

/-- **The Taylor remainder of `sin` and `cos` has the sign of the first omitted term**, for
`t ≥ 0`. -/
theorem taylor_sign {n : ℕ} (hn : 1 ≤ n) {t : ℝ} (ht : 0 ≤ t) :
    0 ≤ (-1:ℝ)^n * (Real.cos t - cosPart n t) ∧
      0 ≤ (-1:ℝ)^n * (Real.sin t - sinPart n t) :=
  taylor_sign_forall hn t ht

/-- For even `n`, the partial sum of the Taylor series of `sin` is a lower bound on `[0,∞)`. -/
theorem sinPart_le_sin {n : ℕ} (hn : 1 ≤ n) (hev : Even n) {t : ℝ} (ht : 0 ≤ t) :
    sinPart n t ≤ Real.sin t := by
  have h := (taylor_sign hn ht).2
  rw [hev.neg_one_pow, one_mul] at h
  linarith

/-! ## The Taylor bound for the sine integral -/

/-- The `n`-th partial sum of the Taylor series of `sinc x = sin x / x`. -/
def sincPart (n : ℕ) (x : ℝ) : ℝ :=
  ∑ k ∈ Finset.range n, (-1:ℝ)^k * x^(2*k)/(2*k+1).factorial

/-- The `n`-th partial sum of the Taylor series of `Si x / x`. -/
def siDivPart (n : ℕ) (x : ℝ) : ℝ :=
  ∑ k ∈ Finset.range n, (-1:ℝ)^k * x^(2*k)/((2*k+1) * (2*k+1).factorial)

/-- The `n`-th partial sum of the Taylor series of `Si`. -/
def siPart (n : ℕ) (x : ℝ) : ℝ :=
  ∑ k ∈ Finset.range n, (-1:ℝ)^k * x^(2*k+1)/((2*k+1) * (2*k+1).factorial)

theorem sinPart_div (n : ℕ) {t : ℝ} (ht : t ≠ 0) : sinPart n t / t = sincPart n t := by
  rw [sinPart, sincPart, Finset.sum_div]
  refine Finset.sum_congr rfl fun k _ => ?_
  have hfac : ((2*k+1).factorial : ℝ) ≠ 0 := Nat.cast_ne_zero.2 (Nat.factorial_ne_zero _)
  field_simp
  ring

theorem siPart_div (n : ℕ) {x : ℝ} (hx : x ≠ 0) : siPart n x / x = siDivPart n x := by
  rw [siPart, siDivPart, Finset.sum_div]
  refine Finset.sum_congr rfl fun k _ => ?_
  have hfac : ((2*k+1).factorial : ℝ) ≠ 0 := Nat.cast_ne_zero.2 (Nat.factorial_ne_zero _)
  have hodd : ((2*(k:ℝ)+1)) ≠ 0 := by positivity
  field_simp
  ring

theorem sincPart_zero {n : ℕ} (hn : 1 ≤ n) : sincPart n 0 = 1 := by
  obtain ⟨m, rfl⟩ := Nat.exists_eq_add_of_le hn
  rw [add_comm, sincPart,
    Finset.sum_range_succ' (fun k => (-1:ℝ)^k * (0:ℝ)^(2*k)/(2*k+1).factorial) m]
  simp

theorem siDivPart_zero {n : ℕ} (hn : 1 ≤ n) : siDivPart n 0 = 1 := by
  obtain ⟨m, rfl⟩ := Nat.exists_eq_add_of_le hn
  rw [add_comm, siDivPart,
    Finset.sum_range_succ' (fun k => (-1:ℝ)^k * (0:ℝ)^(2*k)/((2*k+1) * (2*k+1).factorial)) m]
  simp

theorem hasDerivAt_siPart (n : ℕ) (x : ℝ) : HasDerivAt (siPart n) (sincPart n x) x := by
  have hfun : siPart n = ∑ k ∈ Finset.range n,
      (fun x : ℝ => (-1:ℝ)^k * x^(2*k+1)/((2*k+1) * (2*k+1).factorial)) := by
    funext s; simp [siPart]
  rw [hfun, sincPart]
  refine HasDerivAt.sum fun k _ => ?_
  have h := (((hasDerivAt_pow (2*k+1) x).const_mul ((-1:ℝ)^k)).div_const
    (((2*k+1 : ℝ)) * (2*k+1).factorial))
  convert h using 1
  have hfac : ((2*k+1).factorial : ℝ) ≠ 0 := Nat.cast_ne_zero.2 (Nat.factorial_ne_zero _)
  have hodd : ((2*(k:ℝ)+1)) ≠ 0 := by positivity
  simp only [Nat.add_sub_cancel]
  field_simp
  push_cast
  ring

/-- For even `n`, the partial sum of the Taylor series of `sinc` is a lower bound on `[0,∞)`. -/
theorem sincPart_le_sinc {n : ℕ} (hn : 1 ≤ n) (hev : Even n) {t : ℝ} (ht : 0 ≤ t) :
    sincPart n t ≤ Real.sinc t := by
  rcases eq_or_lt_of_le ht with h | h
  · subst_vars
    rw [sincPart_zero hn]
    simp [Real.sinc]
  · have hsin := sinPart_le_sin hn hev (le_of_lt h)
    rw [Real.sinc_of_ne_zero (ne_of_gt h), ← sinPart_div n (ne_of_gt h)]
    exact div_le_div_of_nonneg_right hsin h.le

/-- **The Taylor lower bound for `Si`**: for even `n` and `x ≥ 0`,
`Si x ≥ ∑_{k<n} (-1)^k x^{2k+1}/((2k+1)(2k+1)!)`. -/
theorem siPart_le_Si {n : ℕ} (hn : 1 ≤ n) (hev : Even n) {x : ℝ} (hx : 0 ≤ x) :
    siPart n x ≤ Si x := by
  have := nonneg_of_deriv_nonneg (F := fun x => Si x - siPart n x)
    (F' := fun x => Real.sinc x - sincPart n x)
    (fun u => (Si_hasDerivAt u).sub (hasDerivAt_siPart n u))
    (by simp [siPart]) (fun u hu => by linarith [sincPart_le_sinc hn hev hu]) hx
  linarith

/-- **The Taylor lower bound for `Si x / x`**: for even `n` and `x ≥ 0`,
`Si x / x ≥ ∑_{k<n} (-1)^k x^{2k}/((2k+1)(2k+1)!)`. -/
theorem siDivPart_le_siDiv {n : ℕ} (hn : 1 ≤ n) (hev : Even n) {x : ℝ} (hx : 0 ≤ x) :
    siDivPart n x ≤ siDiv x := by
  rcases eq_or_lt_of_le hx with h | h
  · subst_vars
    rw [siDivPart_zero hn]
    simp
  · have hSi := siPart_le_Si hn hev (le_of_lt h)
    rw [siDiv_of_ne_zero (ne_of_gt h), ← siPart_div n (ne_of_gt h)]
    exact div_le_div_of_nonneg_right hSi h.le

end ConnesConsani.WeilPositivity
