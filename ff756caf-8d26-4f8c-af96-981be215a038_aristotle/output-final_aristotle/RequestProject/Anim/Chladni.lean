import Mathlib

/-!
# Chladni figures: the modes of a square plate

The semantics of `web/js/chladni.js`, which is what the `chladni` statement of
a playbook means.  The classical figure of a square plate with free edges,
driven at a mode `(n, m)`, is the nodal set of

`u n m x y = cos(nπx)·cos(mπy) − cos(mπx)·cos(nπy)`

on the unit square: sand collects where the plate does not move, which is
where `u = 0`.  The studio draws exactly this set.

What is proved here:

* `chladni_swap` — swapping the two mode numbers negates the function, so the
  figure of `(n, m)` and of `(m, n)` are the same set of nodal lines;
* `chladni_self` — the degenerate mode `n = m` is identically zero, which is
  why the runtime refuses it rather than drawing a blank plate;
* `chladni_diag` — the leading diagonal is always nodal;
* `chladni_antidiag` — the anti-diagonal is nodal exactly when `n` and `m`
  have the same parity;
* `chladni_half_turn`, `chladni_flip_x`, `chladni_flip_y` — the figure is
  carried onto itself by the half turn and by both edge reflections, so it
  really does have the symmetry the pictures show;
* `chladni_neumann_left` / `_right` / `_bottom` / `_top` — the free-edge
  (Neumann) boundary condition: the normal derivative vanishes on all four
  edges, which is what makes this the mode of a *free* plate;
* `chladni_laplacian` — the physical content: `u` is an eigenfunction of the
  Laplacian with eigenvalue `−π²(n² + m²)`.  Both halves of the difference
  share that eigenvalue, which is exactly why their difference is a mode at
  all, and why `(n, m)` and `(m, n)` are degenerate.
-/

namespace Hesper.Chladni

open Real

noncomputable section

/-- One product mode of the square plate. -/
def mode (n m : ℕ) (x y : ℝ) : ℝ := cos (n * π * x) * cos (m * π * y)

/-- The Chladni function of the mode pair `(n, m)`: sand collects on `u = 0`. -/
def chladni (n m : ℕ) (x y : ℝ) : ℝ := mode n m x y - mode m n x y

@[simp] theorem mode_swap_arg (n m : ℕ) (x y : ℝ) : mode n m x y = mode m n y x := by
  simp [mode, mul_comm]

/-- Swapping the mode numbers negates the function, so the nodal set is the same. -/
theorem chladni_swap (n m : ℕ) (x y : ℝ) : chladni n m x y = - chladni m n x y := by
  simp [chladni]

/-- The degenerate mode is identically zero. -/
@[simp] theorem chladni_self (n : ℕ) (x y : ℝ) : chladni n n x y = 0 := by
  simp [chladni]

/-- The leading diagonal is always nodal. -/
theorem chladni_diag (n m : ℕ) (x : ℝ) : chladni n m x x = 0 := by
  simp [chladni, mode, mul_comm]

/-! ### The reflections

`cos(kπ(1 - t)) = (-1)^k cos(kπt)`, which is the one computation the symmetry
statements rest on.
-/

theorem cos_pi_sub (k : ℕ) (t : ℝ) : cos (k * π * (1 - t)) = (-1) ^ k * cos (k * π * t) := by
  have h : (k : ℝ) * π * (1 - t) = k * π - k * π * t := by ring
  rw [h, Real.cos_sub, Real.sin_nat_mul_pi, Real.cos_nat_mul_pi]
  ring

/-- Reflecting in the left edge multiplies the function by `(-1)^n` on one term
    and `(-1)^m` on the other; the nodal set is preserved when they agree. -/
theorem chladni_flip_x (n m : ℕ) (x y : ℝ) :
    chladni n m (1 - x) y = (-1) ^ n * mode n m x y - (-1) ^ m * mode m n x y := by
  simp only [chladni, mode, cos_pi_sub]
  ring

theorem chladni_flip_y (n m : ℕ) (x y : ℝ) :
    chladni n m x (1 - y) = (-1) ^ m * mode n m x y - (-1) ^ n * mode m n x y := by
  simp only [chladni, mode, cos_pi_sub]
  ring

/-- The half turn carries the figure onto itself. -/
theorem chladni_half_turn (n m : ℕ) (x y : ℝ) :
    chladni n m (1 - x) (1 - y) = (-1) ^ (n + m) * chladni n m x y := by
  simp only [chladni, mode, cos_pi_sub, pow_add]
  ring

/-- The anti-diagonal is nodal exactly when the two mode numbers have the same parity. -/
theorem chladni_antidiag {n m : ℕ} (h : n % 2 = m % 2) (x : ℝ) : chladni n m x (1 - x) = 0 := by
  have hpar : ((-1 : ℝ)) ^ m = (-1) ^ n := by
    rcases Nat.even_or_odd n with he | ho
    · have hm : Even m := by
        rcases Nat.even_or_odd m with hm | hm
        · exact hm
        · exact absurd h (by
            simp [Nat.even_iff.mp he, Nat.odd_iff.mp hm])
      rw [Even.neg_one_pow hm, Even.neg_one_pow he]
    · have hm : Odd m := by
        rcases Nat.even_or_odd m with hm | hm
        · exact absurd h (by simp [Nat.odd_iff.mp ho, Nat.even_iff.mp hm])
        · exact hm
      rw [Odd.neg_one_pow hm, Odd.neg_one_pow ho]
  rw [chladni_flip_y, hpar]
  simp only [mode, mul_comm]
  ring

/-! ### The free edges

The normal derivative vanishes on every edge: this is the boundary condition
of a plate that is driven but not clamped.
-/

private theorem hasDerivAt_cos_mul (a x : ℝ) :
    HasDerivAt (fun t : ℝ => cos (a * t)) (-(a * sin (a * x))) x := by
  have h : HasDerivAt (fun t : ℝ => a * t) a x := by
    simpa using (hasDerivAt_id x).const_mul a
  simpa [mul_comm] using (Real.hasDerivAt_cos (a * x)).comp x h

private theorem hasDerivAt_sin_mul (a x : ℝ) :
    HasDerivAt (fun t : ℝ => sin (a * t)) (a * cos (a * x)) x := by
  have h : HasDerivAt (fun t : ℝ => a * t) a x := by
    simpa using (hasDerivAt_id x).const_mul a
  simpa [mul_comm] using (Real.hasDerivAt_sin (a * x)).comp x h

/-- The `x`-derivative of the figure, in closed form. -/
theorem deriv_x (n m : ℕ) (x y : ℝ) :
    deriv (fun t => chladni n m t y) x
      = -(n * π * sin (n * π * x)) * cos (m * π * y)
        + (m * π * sin (m * π * x)) * cos (n * π * y) := by
  have h : HasDerivAt (fun t => chladni n m t y)
      (-((n : ℝ) * π * sin (n * π * x)) * cos (m * π * y)
        + ((m : ℝ) * π * sin (m * π * x)) * cos (n * π * y)) x := by
    have h₁ := (hasDerivAt_cos_mul ((n : ℝ) * π) x).mul_const (cos ((m : ℝ) * π * y))
    have h₂ := (hasDerivAt_cos_mul ((m : ℝ) * π) x).mul_const (cos ((n : ℝ) * π * y))
    have := h₁.sub h₂
    convert this using 1
    ring
  exact h.deriv

/-- The plate's left edge is free. -/
theorem chladni_neumann_left (n m : ℕ) (y : ℝ) : deriv (fun t => chladni n m t y) 0 = 0 := by
  simp [deriv_x]

/-- …and so is its right edge. -/
theorem chladni_neumann_right (n m : ℕ) (y : ℝ) : deriv (fun t => chladni n m t y) 1 = 0 := by
  simp [deriv_x, Real.sin_nat_mul_pi]

/-- The `y`-derivative, in closed form. -/
theorem deriv_y (n m : ℕ) (x y : ℝ) :
    deriv (fun t => chladni n m x t) y
      = cos (n * π * x) * -((m : ℝ) * π * sin (m * π * y))
        + cos (m * π * x) * ((n : ℝ) * π * sin (n * π * y)) := by
  have h : HasDerivAt (fun t => chladni n m x t)
      (cos ((n : ℝ) * π * x) * -((m : ℝ) * π * sin (m * π * y))
        + cos ((m : ℝ) * π * x) * ((n : ℝ) * π * sin (n * π * y))) y := by
    have h₁ := (hasDerivAt_cos_mul ((m : ℝ) * π) y).const_mul (cos ((n : ℝ) * π * x))
    have h₂ := (hasDerivAt_cos_mul ((n : ℝ) * π) y).const_mul (cos ((m : ℝ) * π * x))
    have := h₁.sub h₂
    convert this using 1
    ring
  exact h.deriv

theorem chladni_neumann_bottom (n m : ℕ) (x : ℝ) : deriv (fun t => chladni n m x t) 0 = 0 := by
  simp [deriv_y]

theorem chladni_neumann_top (n m : ℕ) (x : ℝ) : deriv (fun t => chladni n m x t) 1 = 0 := by
  simp [deriv_y, Real.sin_nat_mul_pi]

/-! ### The eigenvalue -/

theorem deriv2_x (n m : ℕ) (x y : ℝ) :
    deriv (deriv (fun t => chladni n m t y)) x
      = -((n : ℝ) * π) ^ 2 * mode n m x y + ((m : ℝ) * π) ^ 2 * mode m n x y := by
  have hfun : deriv (fun t => chladni n m t y)
      = fun t => -((n : ℝ) * π * sin (n * π * t)) * cos (m * π * y)
        + ((m : ℝ) * π * sin (m * π * t)) * cos (n * π * y) := by
    funext t; exact deriv_x n m t y
  rw [hfun]
  have h₁ := ((((hasDerivAt_sin_mul ((n : ℝ) * π) x).const_mul ((n : ℝ) * π)).neg).mul_const
    (cos ((m : ℝ) * π * y)))
  have h₂ := (((hasDerivAt_sin_mul ((m : ℝ) * π) x).const_mul ((m : ℝ) * π)).mul_const
    (cos ((n : ℝ) * π * y)))
  have h : HasDerivAt (fun t => -((n : ℝ) * π * sin ((n : ℝ) * π * t)) * cos ((m : ℝ) * π * y)
      + ((m : ℝ) * π * sin ((m : ℝ) * π * t)) * cos ((n : ℝ) * π * y))
      (-((n : ℝ) * π * ((n : ℝ) * π * cos ((n : ℝ) * π * x))) * cos ((m : ℝ) * π * y)
        + (m : ℝ) * π * ((m : ℝ) * π * cos ((m : ℝ) * π * x)) * cos ((n : ℝ) * π * y)) x := by
    simpa using h₁.add h₂
  rw [h.deriv]
  simp only [mode]
  ring

theorem deriv2_y (n m : ℕ) (x y : ℝ) :
    deriv (deriv (fun t => chladni n m x t)) y
      = -((m : ℝ) * π) ^ 2 * mode n m x y + ((n : ℝ) * π) ^ 2 * mode m n x y := by
  have hfun : deriv (fun t => chladni n m x t)
      = fun t => cos ((n : ℝ) * π * x) * -((m : ℝ) * π * sin (m * π * t))
        + cos ((m : ℝ) * π * x) * ((n : ℝ) * π * sin (n * π * t)) := by
    funext t; exact deriv_y n m x t
  rw [hfun]
  have h₁ := ((((hasDerivAt_sin_mul ((m : ℝ) * π) y).const_mul ((m : ℝ) * π)).neg).const_mul
    (cos ((n : ℝ) * π * x)))
  have h₂ := (((hasDerivAt_sin_mul ((n : ℝ) * π) y).const_mul ((n : ℝ) * π)).const_mul
    (cos ((m : ℝ) * π * x)))
  have h : HasDerivAt (fun t => cos ((n : ℝ) * π * x) * -((m : ℝ) * π * sin ((m : ℝ) * π * t))
      + cos ((m : ℝ) * π * x) * ((n : ℝ) * π * sin ((n : ℝ) * π * t)))
      (cos ((n : ℝ) * π * x) * -((m : ℝ) * π * ((m : ℝ) * π * cos ((m : ℝ) * π * y)))
        + cos ((m : ℝ) * π * x) * ((n : ℝ) * π * ((n : ℝ) * π * cos ((n : ℝ) * π * y)))) y := by
    simpa using h₁.add h₂
  rw [h.deriv]
  simp only [mode]
  ring

/-- The figure is an eigenfunction of the Laplacian with eigenvalue `−π²(n² + m²)`;
    that the two halves share it is why their difference is a mode at all, and
    why `(n, m)` and `(m, n)` are degenerate. -/
theorem chladni_laplacian (n m : ℕ) (x y : ℝ) :
    deriv (deriv (fun t => chladni n m t y)) x + deriv (deriv (fun t => chladni n m x t)) y
      = -(π ^ 2 * ((n : ℝ) ^ 2 + (m : ℝ) ^ 2)) * chladni n m x y := by
  rw [deriv2_x, deriv2_y]
  simp only [chladni]
  ring

end

end Hesper.Chladni
