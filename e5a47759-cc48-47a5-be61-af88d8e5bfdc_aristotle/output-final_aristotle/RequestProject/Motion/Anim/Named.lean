import Mathlib

/-!
# The arithmetic behind the checks

`web/js/verify.js` does not take a library record's word for anything: it
recomputes.  This file is the specification of the arithmetic those
recomputations use.

* **Elliptic curves.**  From the Weierstrass coefficients the studio forms
  `b₂, b₄, b₆, b₈, c₄, c₆` and the discriminant, and compares Δ and
  `j = c₄³/Δ` with what the LMFDB publishes.  `c4_cubed_sub_c6_sq` and
  `four_mul_b8` are the identities that make those the right quantities to
  form.

* **Counting points.**  For each `x` the studio solves a quadratic in `y`, and
  counts its roots by asking whether the discriminant `(a₁x + a₃)² + 4·f(x)` is
  a square.  `card_roots_quadratic` is why that is the same count — completing
  the square is a bijection when 2 is invertible — and `affineCount_eq_sum` is
  the loop the studio actually runs.  `apOf` is then `p + 1 − #E(𝔽ₚ)`.

* **The Hasse bound.**  The studio tests `aₚ² ≤ 4p` in integers rather than
  `|aₚ| ≤ 2√p` in reals; `hasseOK_iff` says those are the same test.

* **Sequences.**  The recurrences the recomputations use are stated and proved
  against Mathlib's own definitions: `catalan_recurrence` is the step
  `Cₙ₊₁ = 2(2n+1)Cₙ/(n+2)` used in `verify.js`, and `fib_doubling` /
  `fib_doubling_add_one` are the identities behind the matrix-power check in
  `tests/node/test_library.mjs`.
-/

namespace Hesper.Named

/-! ## Elliptic curves in Weierstrass form -/

/-- The coefficients of `y² + a₁xy + a₃y = x³ + a₂x² + a₄x + a₆`. -/
structure Weier where
  a1 : ℤ
  a2 : ℤ
  a3 : ℤ
  a4 : ℤ
  a6 : ℤ
deriving DecidableEq, Repr

namespace Weier

variable (E : Weier)

def b2 : ℤ := E.a1 ^ 2 + 4 * E.a2
def b4 : ℤ := 2 * E.a4 + E.a1 * E.a3
def b6 : ℤ := E.a3 ^ 2 + 4 * E.a6
def b8 : ℤ := E.a1 ^ 2 * E.a6 + 4 * E.a2 * E.a6 - E.a1 * E.a3 * E.a4 + E.a2 * E.a3 ^ 2 - E.a4 ^ 2
def c4 : ℤ := E.b2 ^ 2 - 24 * E.b4
def c6 : ℤ := -E.b2 ^ 3 + 36 * E.b2 * E.b4 - 216 * E.b6
def disc : ℤ := -E.b2 ^ 2 * E.b8 - 8 * E.b4 ^ 3 - 27 * E.b6 ^ 2 + 9 * E.b2 * E.b4 * E.b6

/-- The identity that ties `c₄`, `c₆` and Δ together: `c₄³ − c₆² = 1728Δ`. -/
theorem c4_cubed_sub_c6_sq : E.c4 ^ 3 - E.c6 ^ 2 = 1728 * E.disc := by
  simp only [c4, c6, disc, b2, b4, b6, b8]
  ring

/-- `4b₈ = b₂b₆ − b₄²`. -/
theorem four_mul_b8 : 4 * E.b8 = E.b2 * E.b6 - E.b4 ^ 2 := by
  simp only [b8, b2, b4, b6]
  ring

/-- The discriminant of the quadratic in `y`, at `x`: this is what the studio
tests for being a square. -/
def yDisc (x : ℤ) : ℤ :=
  (E.a1 * x + E.a3) ^ 2 + 4 * (x ^ 3 + E.a2 * x ^ 2 + E.a4 * x + E.a6)

/-- And it is the cubic `4x³ + b₂x² + 2b₄x + b₆`. -/
theorem yDisc_eq (x : ℤ) : E.yDisc x = 4 * x ^ 3 + E.b2 * x ^ 2 + 2 * E.b4 * x + E.b6 := by
  simp only [yDisc, b2, b4, b6]
  ring

end Weier

/-! ## Counting points over 𝔽ₚ -/

section Counting

variable {p : ℕ} [Fact p.Prime]

/-- In a field of odd characteristic, 2 is invertible. -/
theorem two_ne_zero_zmod {p : ℕ} [hp : Fact p.Prime] (h2 : p ≠ 2) : (2 : ZMod p) ≠ 0 := by
  intro h
  have h' : ((2 : ℕ) : ZMod p) = 0 := by exact_mod_cast h
  exact h2 ((Nat.prime_dvd_prime_iff_eq hp.out Nat.prime_two).mp
    ((ZMod.natCast_eq_zero_iff 2 p).mp h'))

/-- Completing the square: `y² + by = c` has exactly as many solutions as
`z² = b² + 4c`.  This is why the studio may count square roots of the
discriminant instead of solving the quadratic. -/
theorem card_roots_quadratic (h2 : p ≠ 2) (b c : ZMod p) :
    (Finset.univ.filter (fun y : ZMod p => y ^ 2 + b * y = c)).card
      = (Finset.univ.filter (fun z : ZMod p => z ^ 2 = b ^ 2 + 4 * c)).card := by
  have hu : (2 : ZMod p) ≠ 0 := two_ne_zero_zmod h2
  refine Finset.card_bij' (fun y _ => 2 * y + b) (fun z _ => (z - b) / 2) ?_ ?_ ?_ ?_
  · intro y hy
    simp only [Finset.mem_filter, Finset.mem_univ, true_and] at hy ⊢
    have hexp : (2 * y + b) ^ 2 = 4 * (y ^ 2 + b * y) + b ^ 2 := by ring
    rw [hexp, hy]; ring
  · intro z hz
    simp only [Finset.mem_filter, Finset.mem_univ, true_and] at hz ⊢
    field_simp
    have hexp : (z - b) ^ 2 = z ^ 2 - 2 * b * z + b ^ 2 := by ring
    rw [hz] at hexp
    linear_combination hexp
  · intro y _
    field_simp
    ring
  · intro z _
    field_simp
    ring

/-- The affine points of the curve, counted the way the studio counts them:
one `x` at a time. -/
def affineCount (E : Weier) (p : ℕ) [Fact p.Prime] : ℕ :=
  ∑ x : ZMod p, (Finset.univ.filter (fun y : ZMod p =>
    y ^ 2 + ((E.a1 : ZMod p) * x + (E.a3 : ZMod p)) * y
      = x ^ 3 + (E.a2 : ZMod p) * x ^ 2 + (E.a4 : ZMod p) * x + (E.a6 : ZMod p))).card

/-- Counting the points of the curve: the affine ones and the point at
infinity. -/
def pointCount (E : Weier) (p : ℕ) [Fact p.Prime] : ℕ := affineCount E p + 1

/-- The Frobenius trace, as the studio computes it. -/
def apOf (E : Weier) (p : ℕ) [Fact p.Prime] : ℤ := (p : ℤ) + 1 - (pointCount E p : ℤ)

/-- So `#E(𝔽ₚ) = p + 1 − aₚ`, which is the shape the Hasse bound is stated in. -/
theorem pointCount_eq (E : Weier) (p : ℕ) [Fact p.Prime] :
    (pointCount E p : ℤ) = (p : ℤ) + 1 - apOf E p := by
  simp [apOf]

/-- The loop the studio runs: for each `x`, count the square roots of the
discriminant of the quadratic in `y`. -/
theorem affineCount_eq_sum (E : Weier) (p : ℕ) [Fact p.Prime] (h2 : p ≠ 2) :
    affineCount E p =
      ∑ x : ZMod p, (Finset.univ.filter (fun z : ZMod p =>
        z ^ 2 = ((E.a1 : ZMod p) * x + (E.a3 : ZMod p)) ^ 2
          + 4 * (x ^ 3 + (E.a2 : ZMod p) * x ^ 2 + (E.a4 : ZMod p) * x
            + (E.a6 : ZMod p)))).card := by
  refine Finset.sum_congr rfl (fun x _ => ?_)
  exact card_roots_quadratic h2 _ _

end Counting

/-! ## The Hasse bound, as a test on integers -/

/-- The test the studio makes. -/
def hasseOK (p a : ℤ) : Bool := decide (a ^ 2 ≤ 4 * p)

/-- It is the Hasse bound: for `p ≥ 0`, `a² ≤ 4p` exactly when `|a| ≤ 2√p`. -/
theorem hasseOK_iff {p a : ℤ} (hp : 0 ≤ p) :
    hasseOK p a = true ↔ |(a : ℝ)| ≤ 2 * Real.sqrt p := by
  have hp' : (0 : ℝ) ≤ (p : ℝ) := by exact_mod_cast hp
  constructor
  · intro h
    have h' : (a : ℝ) ^ 2 ≤ 4 * (p : ℝ) := by exact_mod_cast (of_decide_eq_true h)
    have hs : (0 : ℝ) ≤ 2 * Real.sqrt p := by positivity
    have habs : |(a : ℝ)| ^ 2 ≤ (2 * Real.sqrt p) ^ 2 := by
      rw [sq_abs, mul_pow, Real.sq_sqrt hp']
      linarith
    exact (sq_le_sq₀ (abs_nonneg _) hs).mp habs
  · intro h
    have hsq : (a : ℝ) ^ 2 ≤ (2 * Real.sqrt p) ^ 2 := by
      have := abs_nonneg (a : ℝ)
      nlinarith [abs_nonneg (a : ℝ), sq_abs (a : ℝ)]
    rw [mul_pow, Real.sq_sqrt hp'] at hsq
    have : (a : ℝ) ^ 2 ≤ 4 * (p : ℝ) := by linarith
    have : a ^ 2 ≤ 4 * p := by exact_mod_cast this
    simpa [hasseOK] using this

/-! ## The sequences -/

/-- The step the Catalan recomputation takes: `(n+2)Cₙ₊₁ = 2(2n+1)Cₙ`. -/
theorem catalan_recurrence (n : ℕ) :
    (n + 2) * catalan (n + 1) = 2 * (2 * n + 1) * catalan n := by
  have h1 : (n + 1) * catalan n = n.centralBinom := by
    rw [catalan_eq_centralBinom_div, Nat.mul_div_cancel' (Nat.succ_dvd_centralBinom n)]
  have h2 : (n + 2) * catalan (n + 1) = (n + 1).centralBinom := by
    rw [catalan_eq_centralBinom_div, Nat.mul_div_cancel' (Nat.succ_dvd_centralBinom (n + 1))]
  have h3 := Nat.succ_mul_centralBinom_succ n
  have key : (n + 1) * ((n + 2) * catalan (n + 1)) = (n + 1) * (2 * (2 * n + 1) * catalan n) := by
    rw [h2, h3, ← h1]; ring
  exact Nat.eq_of_mul_eq_mul_left (Nat.succ_pos n) key

/-- The identities behind computing Fibonacci numbers by repeated squaring,
which is how the test suite recomputes them independently of the recurrence. -/
theorem fib_doubling (n : ℕ) : Nat.fib (2 * n) = Nat.fib n * (2 * Nat.fib (n + 1) - Nat.fib n) :=
  Nat.fib_two_mul n

theorem fib_doubling_add_one (n : ℕ) :
    Nat.fib (2 * n + 1) = Nat.fib (n + 1) ^ 2 + Nat.fib n ^ 2 :=
  Nat.fib_two_mul_add_one n

end Hesper.Named
