/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Positivity of the sine integral: `Si x > 0` for `x > 0`.  This is the fact quoted in
§2 of arXiv:2006.13771 ("Since the Sine Integral function `Si(z)` is positive for
`z ≥ 0`, `δ(ρ)` is positive") and used there to assert the positivity of the trace
remainder `δ`.
-/
import RequestProject.Imported.OutputFinal2.SineIntegral

noncomputable section

open MeasureTheory Real Set intervalIntegral

namespace ConnesConsani.WeilPositivity

/-- The shifted half-arch integral `J(a,s) = ∫₀ˢ sin u / (a + u) du`. -/
def sinShiftIntegral (a s : ℝ) : ℝ := ∫ u in (0:ℝ)..s, Real.sin u / (a + u)

lemma sin_nat_mul_pi_add (k : ℕ) (u : ℝ) :
    Real.sin ((k : ℝ) * π + u) = (-1) ^ k * Real.sin u := by
  induction k with
  | zero => simp
  | succ k ih =>
      have h : ((k + 1 : ℕ) : ℝ) * π + u = ((k : ℝ) * π + u) + π := by push_cast; ring
      rw [h, Real.sin_add_pi, ih, pow_succ]
      ring

lemma intervalIntegrable_sin_div_shift {a : ℝ} (ha : 0 < a) {s : ℝ} (hs : 0 ≤ s) :
    IntervalIntegrable (fun u => Real.sin u / (a + u)) volume 0 s := by
  apply ContinuousOn.intervalIntegrable
  rw [Set.uIcc_of_le hs]
  apply ContinuousOn.div (Real.continuous_sin.continuousOn) (by fun_prop)
  intro u hu
  have : 0 ≤ u := hu.1
  positivity

lemma intervalIntegrable_sin_div_shift' {a : ℝ} (ha : 0 < a) {s t : ℝ} (hs : 0 ≤ s)
    (hst : s ≤ t) : IntervalIntegrable (fun u => Real.sin u / (a + u)) volume s t := by
  apply ContinuousOn.intervalIntegrable
  rw [Set.uIcc_of_le hst]
  apply ContinuousOn.div (Real.continuous_sin.continuousOn) (by fun_prop)
  intro u hu
  have : 0 ≤ u := le_trans hs hu.1
  positivity

/-- Over the `k`-th half arch, the sine integral is `(-1)^k` times a positive quantity. -/
lemma integral_sinc_shift {k : ℕ} (hk : 1 ≤ k) {s : ℝ} (hs : 0 ≤ s) :
    (∫ t in ((k : ℝ) * π)..((k : ℝ) * π + s), Real.sinc t)
      = (-1) ^ k * sinShiftIntegral ((k : ℝ) * π) s := by
  have hkpi : 0 < (k : ℝ) * π := by
    have : (1:ℝ) ≤ (k : ℝ) := by exact_mod_cast hk
    nlinarith [Real.pi_pos]
  have h1 : (∫ t in ((k : ℝ) * π)..((k : ℝ) * π + s), Real.sinc t)
      = ∫ u in (0:ℝ)..s, Real.sinc ((k : ℝ) * π + u) := by
    rw [intervalIntegral.integral_comp_add_left (f := Real.sinc) ((k : ℝ) * π)]
    simp
  rw [h1]
  have h2 : ∀ u ∈ Set.uIcc (0:ℝ) s, Real.sinc ((k : ℝ) * π + u)
      = (-1) ^ k * (Real.sin u / ((k : ℝ) * π + u)) := by
    intro u hu
    have hu0 : 0 ≤ u := by
      rw [Set.uIcc_of_le hs] at hu; exact hu.1
    have hne : (k : ℝ) * π + u ≠ 0 := by positivity
    rw [Real.sinc_of_ne_zero hne, sin_nat_mul_pi_add]
    ring
  rw [intervalIntegral.integral_congr h2, intervalIntegral.integral_const_mul]
  rfl

lemma sinShiftIntegral_nonneg {a : ℝ} (ha : 0 < a) {s : ℝ} (hs : 0 ≤ s) (hsp : s ≤ π) :
    0 ≤ sinShiftIntegral a s := by
  refine intervalIntegral.integral_nonneg hs (fun u hu => ?_)
  have h1 : 0 ≤ Real.sin u := Real.sin_nonneg_of_nonneg_of_le_pi hu.1 (le_trans hu.2 hsp)
  have h2 : 0 < a + u := by have := hu.1; positivity
  positivity

lemma sinShiftIntegral_le_pi {a : ℝ} (ha : 0 < a) {s : ℝ} (hs : 0 ≤ s) (hsp : s ≤ π) :
    sinShiftIntegral a s ≤ sinShiftIntegral a π := by
  have hadd := intervalIntegral.integral_add_adjacent_intervals
    (f := fun u => Real.sin u / (a + u)) (μ := volume) (a := 0) (b := s) (c := π)
    (intervalIntegrable_sin_div_shift ha hs) (intervalIntegrable_sin_div_shift' ha hs hsp)
  have hrest : 0 ≤ ∫ u in s..π, Real.sin u / (a + u) := by
    refine intervalIntegral.integral_nonneg hsp (fun u hu => ?_)
    have h1 : 0 ≤ Real.sin u :=
      Real.sin_nonneg_of_nonneg_of_le_pi (le_trans hs hu.1) hu.2
    have h2 : 0 < a + u := by have := le_trans hs hu.1; positivity
    positivity
  simp only [sinShiftIntegral]
  linarith [hadd]

/-- `J(·, π)` is antitone in the shift. -/
lemma sinShiftIntegral_antitone {a b : ℝ} (ha : 0 < a) (hab : a ≤ b) :
    sinShiftIntegral b π ≤ sinShiftIntegral a π := by
  have hb : 0 < b := lt_of_lt_of_le ha hab
  refine intervalIntegral.integral_mono_on Real.pi_pos.le
    (intervalIntegrable_sin_div_shift hb Real.pi_pos.le)
    (intervalIntegrable_sin_div_shift ha Real.pi_pos.le) (fun u hu => ?_)
  have h1 : 0 ≤ Real.sin u := Real.sin_nonneg_of_nonneg_of_le_pi hu.1 hu.2
  have h2 : 0 < a + u := by have := hu.1; positivity
  have h3 : 0 < b + u := by have := hu.1; positivity
  exact div_le_div_of_nonneg_left h1 h2 (by linarith) |>.trans_eq rfl

/-! ### Positivity -/

lemma Si_pos_of_le_pi {x : ℝ} (hx : 0 < x) (hxp : x ≤ π) : 0 < Si x := by
  refine intervalIntegral.intervalIntegral_pos_of_pos_on
    (Real.continuous_sinc.intervalIntegrable _ _) (fun t ht => ?_) hx
  have h1 : 0 < Real.sin t :=
    Real.sin_pos_of_pos_of_lt_pi ht.1 (lt_of_lt_of_le ht.2 hxp)
  rw [Real.sinc_of_ne_zero (ne_of_gt ht.1)]
  exact div_pos h1 ht.1

lemma Si_pi_pos : 0 < Si π := Si_pos_of_le_pi Real.pi_pos le_rfl

/-- `Si(2π) > 0`: the second half arch is strictly smaller than the first one. -/
lemma Si_two_pi_pos : 0 < Si (2 * π) := by
  have hπ : (0:ℝ) < π := Real.pi_pos
  have hsplit : Si (2 * π) = Si π + ∫ t in π..(2*π), Real.sinc t := by
    have := intervalIntegral.integral_add_adjacent_intervals
      (f := Real.sinc) (μ := volume) (a := 0) (b := π) (c := 2*π)
      (Real.continuous_sinc.intervalIntegrable _ _) (Real.continuous_sinc.intervalIntegrable _ _)
    simp only [Si]
    linarith [this]
  have harch : (∫ t in π..(2*π), Real.sinc t) = -sinShiftIntegral π π := by
    have h := integral_sinc_shift (k := 1) le_rfl (s := π) hπ.le
    simp only [Nat.cast_one, one_mul, pow_one] at h
    have h2 : π + π = 2 * π := by ring
    rw [h2] at h
    rw [h]
    ring
  rw [hsplit, harch]
  have hdiff : Si π - sinShiftIntegral π π
      = ∫ u in (0:ℝ)..π, (Real.sinc u - Real.sin u / (π + u)) := by
    rw [intervalIntegral.integral_sub (Real.continuous_sinc.intervalIntegrable _ _)
      (intervalIntegrable_sin_div_shift hπ hπ.le)]
    rfl
  have hpos : 0 < ∫ u in (0:ℝ)..π, (Real.sinc u - Real.sin u / (π + u)) := by
    refine intervalIntegral.intervalIntegral_pos_of_pos_on
      ((Real.continuous_sinc.intervalIntegrable _ _).sub
        (intervalIntegrable_sin_div_shift hπ hπ.le)) (fun u hu => ?_) hπ
    have hsin : 0 < Real.sin u := Real.sin_pos_of_pos_of_lt_pi hu.1 hu.2
    rw [Real.sinc_of_ne_zero (ne_of_gt hu.1), sub_pos]
    apply div_lt_div_of_pos_left hsin hu.1
    linarith [hu.1]
  linarith [hdiff ▸ hpos]

/-- One step of the alternating decomposition of `Si` into half arches. -/
lemma Si_succ_pi {k : ℕ} (hk : 1 ≤ k) :
    Si (((k : ℝ) + 1) * π) = Si ((k : ℝ) * π) + (-1) ^ k * sinShiftIntegral ((k : ℝ) * π) π := by
  have hπ : (0:ℝ) < π := Real.pi_pos
  have harch := integral_sinc_shift hk (s := π) hπ.le
  have hsplit := intervalIntegral.integral_add_adjacent_intervals
    (f := Real.sinc) (μ := volume) (a := 0) (b := (k : ℝ) * π) (c := ((k : ℝ) + 1) * π)
    (Real.continuous_sinc.intervalIntegrable _ _) (Real.continuous_sinc.intervalIntegrable _ _)
  have he : ((k : ℝ) + 1) * π = (k : ℝ) * π + π := by ring
  rw [he] at hsplit
  simp only [Si, he]
  rw [← harch]
  linarith [hsplit]

/-- On the `k`-th half arch, `Si` is bounded below by the smaller of its endpoint values. -/
lemma Si_ge_min_of_mem {k : ℕ} (hk : 1 ≤ k) {x : ℝ}
    (hx1 : (k : ℝ) * π ≤ x) (hx2 : x ≤ ((k : ℝ) + 1) * π) :
    min (Si ((k : ℝ) * π)) (Si (((k : ℝ) + 1) * π)) ≤ Si x := by
  have hπ : (0:ℝ) < π := Real.pi_pos
  have hkpi : 0 < (k : ℝ) * π := by
    have : (1:ℝ) ≤ (k : ℝ) := by exact_mod_cast hk
    nlinarith
  set s := x - (k : ℝ) * π with hsdef
  have hs : 0 ≤ s := by simp [hsdef]; linarith
  have hsp : s ≤ π := by simp only [hsdef]; linarith
  have hsplit := intervalIntegral.integral_add_adjacent_intervals
    (f := Real.sinc) (μ := volume) (a := 0) (b := (k : ℝ) * π) (c := x)
    (Real.continuous_sinc.intervalIntegrable _ _) (Real.continuous_sinc.intervalIntegrable _ _)
  have hxeq : x = (k : ℝ) * π + s := by simp [hsdef]
  have harch : (∫ t in ((k : ℝ) * π)..x, Real.sinc t)
      = (-1) ^ k * sinShiftIntegral ((k : ℝ) * π) s := by
    rw [hxeq]; exact integral_sinc_shift hk hs
  have hSix : Si x = Si ((k : ℝ) * π) + (-1) ^ k * sinShiftIntegral ((k : ℝ) * π) s := by
    simp only [Si]
    rw [← harch]
    linarith [hsplit]
  have hJ0 := sinShiftIntegral_nonneg hkpi hs hsp
  have hJle := sinShiftIntegral_le_pi hkpi hs hsp
  have hnext := Si_succ_pi hk
  rcases Nat.even_or_odd k with hpar | hpar
  · have hone : (-1 : ℝ) ^ k = 1 := hpar.neg_one_pow
    rw [hone, one_mul] at hSix
    have : Si ((k : ℝ) * π) ≤ Si x := by linarith
    exact le_trans (min_le_left _ _) this
  · have hone : (-1 : ℝ) ^ k = -1 := hpar.neg_one_pow
    rw [hone] at hSix hnext
    have : Si (((k : ℝ) + 1) * π) ≤ Si x := by
      rw [hnext]; linarith
    exact le_trans (min_le_right _ _) this

/-- For every `k ≥ 1`, the value `Si(kπ)` is at least `Si(2π) > 0`. -/
lemma Si_two_pi_le_pi_mul (k : ℕ) (hk : 1 ≤ k) : Si (2 * π) ≤ Si ((k : ℝ) * π) := by
  have hπ : (0:ℝ) < π := Real.pi_pos
  have key : ∀ m : ℕ, Si (2 * π) ≤ Si (((m : ℝ) + 1) * π)
      ∧ Si (2 * π) ≤ Si (((m : ℝ) + 2) * π) := by
    intro m
    induction m with
    | zero =>
        constructor
        · have h := Si_succ_pi (k := 1) le_rfl
          simp only [Nat.cast_one, one_mul, pow_one] at h
          have h2 : ((1:ℝ) + 1) * π = 2 * π := by ring
          rw [h2] at h
          have hJ := sinShiftIntegral_nonneg hπ hπ.le le_rfl
          simp only [Nat.cast_zero, zero_add, one_mul]
          linarith
        · norm_num
    | succ m ih =>
        obtain ⟨n, hn⟩ : ∃ n : ℕ, n = m + 1 := ⟨m + 1, rfl⟩
        have hn1 : 1 ≤ n := by omega
        have hcast : ((n : ℝ)) = (m : ℝ) + 1 := by rw [hn]; push_cast; ring
        rw [← hn]
        refine ⟨by rw [hcast, show ((m : ℝ) + 1 + 1) = (m : ℝ) + 2 by ring]; exact ih.2, ?_⟩
        have hJn : 0 ≤ sinShiftIntegral ((n : ℝ) * π) π := by
          have : 0 < (n : ℝ) * π := by
            have : (1:ℝ) ≤ (n : ℝ) := by exact_mod_cast hn1
            nlinarith
          exact sinShiftIntegral_nonneg this hπ.le le_rfl
        have hstep1 := Si_succ_pi hn1
        have hstep2 := Si_succ_pi (k := n + 1) (by omega)
        have hcast2 : ((n + 1 : ℕ) : ℝ) = (n : ℝ) + 1 := by push_cast; ring
        rw [hcast2] at hstep2
        have hJn1 : 0 ≤ sinShiftIntegral (((n : ℝ) + 1) * π) π := by
          have : 0 < ((n : ℝ) + 1) * π := by
            have : (0:ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
            nlinarith
          exact sinShiftIntegral_nonneg this hπ.le le_rfl
        have hanti : sinShiftIntegral (((n : ℝ) + 1) * π) π
            ≤ sinShiftIntegral ((n : ℝ) * π) π := by
          have hpos : 0 < (n : ℝ) * π := by
            have : (1:ℝ) ≤ (n : ℝ) := by exact_mod_cast hn1
            nlinarith
          exact sinShiftIntegral_antitone hpos (by nlinarith [Nat.cast_nonneg (α := ℝ) n])
        have hgoal : Si (2 * π) ≤ Si (((n : ℝ) + 2) * π) := by
          have heq : ((n : ℝ) + 1 + 1) * π = ((n : ℝ) + 2) * π := by ring
          rcases Nat.even_or_odd n with hpar | hpar
          · have h1 : (-1 : ℝ) ^ n = 1 := hpar.neg_one_pow
            have h2 : (-1 : ℝ) ^ (n + 1) = -1 := by
              rw [pow_succ, h1]; ring
            rw [h1, one_mul] at hstep1
            rw [h2] at hstep2
            rw [heq] at hstep2
            have hmid : Si (2 * π) ≤ Si ((n : ℝ) * π) := by
              rw [hcast] at *
              exact ih.1
            linarith
          · have h1 : (-1 : ℝ) ^ n = -1 := hpar.neg_one_pow
            have h2 : (-1 : ℝ) ^ (n + 1) = 1 := by
              rw [pow_succ, h1]; ring
            rw [h2, one_mul, heq] at hstep2
            have hmid : Si (2 * π) ≤ Si (((n : ℝ) + 1) * π) := by
              rw [hcast]
              have : ((m : ℝ) + 1 + 1) = ((m : ℝ) + 2) := by ring
              rw [this]
              exact ih.2
            linarith
        exact hgoal
  obtain ⟨m, rfl⟩ : ∃ m : ℕ, k = m + 1 := ⟨k - 1, by omega⟩
  have := (key m).1
  push_cast
  push_cast at this
  exact this

/-- **Positivity of the sine integral**: `Si x > 0` for every `x > 0`. -/
theorem Si_pos {x : ℝ} (hx : 0 < x) : 0 < Si x := by
  have hπ : (0:ℝ) < π := Real.pi_pos
  rcases le_or_gt x π with hxp | hxp
  · exact Si_pos_of_le_pi hx hxp
  · -- `x > π`; let `k = ⌊x/π⌋ ≥ 1`
    set k : ℕ := ⌊x / π⌋₊ with hk
    have hxdiv : 1 < x / π := by
      rw [lt_div_iff₀ hπ]; linarith
    have hk1 : 1 ≤ k := by
      rw [hk, Nat.one_le_floor_iff]
      linarith
    have hkle : (k : ℝ) ≤ x / π := Nat.floor_le (by positivity)
    have hklt : x / π < (k : ℝ) + 1 := by
      rw [hk]
      exact_mod_cast Nat.lt_floor_add_one (x / π)
    have hx1 : (k : ℝ) * π ≤ x := by
      rw [← le_div_iff₀ hπ]; exact hkle
    have hx2 : x ≤ ((k : ℝ) + 1) * π := by
      rw [← div_le_iff₀ hπ]; exact hklt.le
    have hmin := Si_ge_min_of_mem hk1 hx1 hx2
    have h1 : Si (2 * π) ≤ Si ((k : ℝ) * π) := Si_two_pi_le_pi_mul k hk1
    have h2 : Si (2 * π) ≤ Si (((k : ℝ) + 1) * π) := by
      have := Si_two_pi_le_pi_mul (k + 1) (by omega)
      push_cast at this
      exact this
    have := le_min h1 h2
    linarith [Si_two_pi_pos, le_trans this hmin]

theorem Si_nonneg {x : ℝ} (hx : 0 ≤ x) : 0 ≤ Si x := by
  rcases eq_or_lt_of_le hx with rfl | h
  · simp
  · exact (Si_pos h).le

/-! ### The maximum of `Si` -/

/-- On the `k`-th half arch, `Si` is bounded above by the larger of its endpoint values. -/
lemma Si_le_max_of_mem {k : ℕ} (hk : 1 ≤ k) {x : ℝ}
    (hx1 : (k : ℝ) * π ≤ x) (hx2 : x ≤ ((k : ℝ) + 1) * π) :
    Si x ≤ max (Si ((k : ℝ) * π)) (Si (((k : ℝ) + 1) * π)) := by
  have hπ : (0:ℝ) < π := Real.pi_pos
  have hkpi : 0 < (k : ℝ) * π := by
    have : (1:ℝ) ≤ (k : ℝ) := by exact_mod_cast hk
    nlinarith
  set s := x - (k : ℝ) * π with hsdef
  have hs : 0 ≤ s := by simp only [hsdef]; linarith
  have hsp : s ≤ π := by simp only [hsdef]; linarith
  have hsplit := intervalIntegral.integral_add_adjacent_intervals
    (f := Real.sinc) (μ := volume) (a := 0) (b := (k : ℝ) * π) (c := x)
    (Real.continuous_sinc.intervalIntegrable _ _) (Real.continuous_sinc.intervalIntegrable _ _)
  have hxeq : x = (k : ℝ) * π + s := by simp [hsdef]
  have harch : (∫ t in ((k : ℝ) * π)..x, Real.sinc t)
      = (-1) ^ k * sinShiftIntegral ((k : ℝ) * π) s := by
    rw [hxeq]; exact integral_sinc_shift hk hs
  have hSix : Si x = Si ((k : ℝ) * π) + (-1) ^ k * sinShiftIntegral ((k : ℝ) * π) s := by
    simp only [Si]
    rw [← harch]
    linarith [hsplit]
  have hJ0 := sinShiftIntegral_nonneg hkpi hs hsp
  have hJle := sinShiftIntegral_le_pi hkpi hs hsp
  have hnext := Si_succ_pi hk
  rcases Nat.even_or_odd k with hpar | hpar
  · have hone : (-1 : ℝ) ^ k = 1 := hpar.neg_one_pow
    rw [hone, one_mul] at hSix hnext
    have : Si x ≤ Si (((k : ℝ) + 1) * π) := by rw [hnext]; linarith
    exact le_trans this (le_max_right _ _)
  · have hone : (-1 : ℝ) ^ k = -1 := hpar.neg_one_pow
    rw [hone] at hSix
    have : Si x ≤ Si ((k : ℝ) * π) := by linarith
    exact le_trans this (le_max_left _ _)

/-- For every `k ≥ 1`, the value `Si(kπ)` is at most `Si(π)`. -/
lemma Si_pi_mul_le_pi (k : ℕ) (hk : 1 ≤ k) : Si ((k : ℝ) * π) ≤ Si π := by
  have hπ : (0:ℝ) < π := Real.pi_pos
  have key : ∀ m : ℕ, Si (((m : ℝ) + 1) * π) ≤ Si π ∧ Si (((m : ℝ) + 2) * π) ≤ Si π := by
    intro m
    induction m with
    | zero =>
        constructor
        · norm_num
        · have h := Si_succ_pi (k := 1) le_rfl
          simp only [Nat.cast_one, one_mul, pow_one] at h
          rw [show ((1:ℝ) + 1) * π = 2 * π by ring] at h
          have hJ := sinShiftIntegral_nonneg hπ hπ.le le_rfl
          simp only [Nat.cast_zero, zero_add]
          linarith
    | succ m ih =>
        obtain ⟨n, hn⟩ : ∃ n : ℕ, n = m + 1 := ⟨m + 1, rfl⟩
        have hn1 : 1 ≤ n := by omega
        have hcast : ((n : ℝ)) = (m : ℝ) + 1 := by rw [hn]; push_cast; ring
        rw [← hn]
        refine ⟨by rw [hcast, show ((m : ℝ) + 1 + 1) = (m : ℝ) + 2 by ring]; exact ih.2, ?_⟩
        have hnpos : 0 < (n : ℝ) * π := by
          have : (1:ℝ) ≤ (n : ℝ) := by exact_mod_cast hn1
          nlinarith
        have hn1pos : 0 < ((n : ℝ) + 1) * π := by nlinarith [Nat.cast_nonneg (α := ℝ) n]
        have hJn : 0 ≤ sinShiftIntegral ((n : ℝ) * π) π :=
          sinShiftIntegral_nonneg hnpos hπ.le le_rfl
        have hJn1 : 0 ≤ sinShiftIntegral (((n : ℝ) + 1) * π) π :=
          sinShiftIntegral_nonneg hn1pos hπ.le le_rfl
        have hanti : sinShiftIntegral (((n : ℝ) + 1) * π) π
            ≤ sinShiftIntegral ((n : ℝ) * π) π :=
          sinShiftIntegral_antitone hnpos (by nlinarith [Nat.cast_nonneg (α := ℝ) n])
        have hstep1 := Si_succ_pi hn1
        have hstep2 := Si_succ_pi (k := n + 1) (by omega)
        have hcast2 : ((n + 1 : ℕ) : ℝ) = (n : ℝ) + 1 := by push_cast; ring
        rw [hcast2] at hstep2
        have heq : ((n : ℝ) + 1 + 1) * π = ((n : ℝ) + 2) * π := by ring
        rcases Nat.even_or_odd n with hpar | hpar
        · have h1 : (-1 : ℝ) ^ n = 1 := hpar.neg_one_pow
          have h2 : (-1 : ℝ) ^ (n + 1) = -1 := by rw [pow_succ, h1]; ring
          rw [h2, heq] at hstep2
          have hmid : Si (((n : ℝ) + 1) * π) ≤ Si π := by
            rw [hcast, show ((m : ℝ) + 1 + 1) = (m : ℝ) + 2 by ring]
            exact ih.2
          linarith
        · have h1 : (-1 : ℝ) ^ n = -1 := hpar.neg_one_pow
          have h2 : (-1 : ℝ) ^ (n + 1) = 1 := by rw [pow_succ, h1]; ring
          rw [h1] at hstep1
          rw [h2, one_mul, heq] at hstep2
          have hmid : Si ((n : ℝ) * π) ≤ Si π := by
            rw [hcast]
            exact ih.1
          linarith
  obtain ⟨m, rfl⟩ : ∃ m : ℕ, k = m + 1 := ⟨k - 1, by omega⟩
  have := (key m).1
  push_cast
  push_cast at this
  exact this

/-- `Si` attains its maximum over `[0,∞)` at `π`. -/
theorem Si_le_Si_pi {x : ℝ} (hx : 0 ≤ x) : Si x ≤ Si π := by
  have hπ : (0:ℝ) < π := Real.pi_pos
  rcases le_or_gt x π with hxp | hxp
  · have hsplit := intervalIntegral.integral_add_adjacent_intervals
      (f := Real.sinc) (μ := volume) (a := 0) (b := x) (c := π)
      (Real.continuous_sinc.intervalIntegrable _ _) (Real.continuous_sinc.intervalIntegrable _ _)
    have hrest : 0 ≤ ∫ t in x..π, Real.sinc t := by
      refine intervalIntegral.integral_nonneg hxp (fun t ht => ?_)
      have ht0 : 0 ≤ t := le_trans hx ht.1
      rcases eq_or_lt_of_le ht0 with h | h
      · simp [← h]
      · rw [Real.sinc_of_ne_zero (ne_of_gt h)]
        exact div_nonneg (Real.sin_nonneg_of_nonneg_of_le_pi ht0 ht.2) h.le
    simp only [Si]
    linarith [hsplit]
  · set k : ℕ := ⌊x / π⌋₊ with hk
    have hxdiv : 1 < x / π := by rw [lt_div_iff₀ hπ]; linarith
    have hk1 : 1 ≤ k := by rw [hk, Nat.one_le_floor_iff]; linarith
    have hkle : (k : ℝ) ≤ x / π := Nat.floor_le (by positivity)
    have hklt : x / π < (k : ℝ) + 1 := by
      rw [hk]; exact_mod_cast Nat.lt_floor_add_one (x / π)
    have hx1 : (k : ℝ) * π ≤ x := by rw [← le_div_iff₀ hπ]; exact hkle
    have hx2 : x ≤ ((k : ℝ) + 1) * π := by rw [← div_le_iff₀ hπ]; exact hklt.le
    have hmax := Si_le_max_of_mem hk1 hx1 hx2
    have h1 : Si ((k : ℝ) * π) ≤ Si π := Si_pi_mul_le_pi k hk1
    have h2 : Si (((k : ℝ) + 1) * π) ≤ Si π := by
      have := Si_pi_mul_le_pi (k + 1) (by omega)
      push_cast at this
      exact this
    exact le_trans hmax (max_le h1 h2)

/-- `Si` is bounded: `|Si x| ≤ Si π` for every real `x`. -/
theorem abs_Si_le_Si_pi (x : ℝ) : |Si x| ≤ Si π := by
  rcases le_or_gt 0 x with hx | hx
  · rw [abs_of_nonneg (Si_nonneg hx)]
    exact Si_le_Si_pi hx
  · have h : Si x = -Si (-x) := by rw [Si_neg]; ring
    rw [h, abs_neg, abs_of_nonneg (Si_nonneg (by linarith))]
    exact Si_le_Si_pi (by linarith)

/-! ### Bounds for the normalized sine integral -/

/-- `Si a ≤ a` for `a ≥ 0`, because the cardinal sine is bounded by `1`. -/
lemma Si_le_self {a : ℝ} (ha : 0 ≤ a) : Si a ≤ a := by
  have h : Si a ≤ ∫ _ in (0:ℝ)..a, (1:ℝ) := by
    refine intervalIntegral.integral_mono_on ha
      (Real.continuous_sinc.intervalIntegrable _ _) _root_.intervalIntegrable_const
      (fun t _ => ?_)
    exact le_trans (le_abs_self _) (Real.abs_sinc_le_one t)
  simpa using h

lemma siDiv_le_one {a : ℝ} (ha : 0 ≤ a) : siDiv a ≤ 1 := by
  rcases eq_or_lt_of_le ha with rfl | h
  · simp [siDiv]
  · rw [siDiv_of_ne_zero (ne_of_gt h), div_le_one h]
    exact Si_le_self ha

lemma siDiv_le_div {a : ℝ} (ha : 0 < a) : siDiv a ≤ Si π / a := by
  rw [siDiv_of_ne_zero (ne_of_gt ha)]
  exact (div_le_div_iff_of_pos_right ha).mpr (Si_le_Si_pi ha.le)

/-- The normalized sine integral is everywhere positive. -/
theorem siDiv_pos (a : ℝ) : 0 < siDiv a := by
  rcases lt_trichotomy a 0 with h | rfl | h
  · rw [siDiv_of_ne_zero (ne_of_lt h)]
    have hpos : 0 < Si (-a) := Si_pos (by linarith)
    have hsym : Si (-a) = -Si a := Si_neg a
    exact div_pos_of_neg_of_neg (by linarith) h
  · simp [siDiv]
  · rw [siDiv_of_ne_zero (ne_of_gt h)]
    exact div_pos (Si_pos h) h

end ConnesConsani.WeilPositivity
