import Mathlib
import RequestProject.Imported.EisensteinAlgebra.EisensteinIntegers_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinTheta_Root

/-!
# Prime splitting in `ℤ[ω]` — the easy direction

This file proves the **inert and ramified cases** of the prime splitting
classification in $\mathbb{Z}[\omega]$:

* **Inert** ($p \equiv 2 \pmod 3$): there is no $z \in \mathbb{Z}[\omega]$
  with $N(z) = p$. The prime $p$ stays prime in $\mathbb{Z}[\omega]$.

* **Ramified** ($p = 3$): the element $\theta = 1 - \omega$ has $N(\theta) = 3$.
  In fact $3 = -\omega^2 \cdot \theta^2$ in $\mathbb{Z}[\omega]$.

* **Split** ($p \equiv 1 \pmod 3$): there exists $\pi \in \mathbb{Z}[\omega]$
  with $N(\pi) = p$. This is the hard direction, **deferred to a separate file**
  (`EisensteinPrimeSplitHard.lean`).
-/

namespace EisensteinPrimeSplit

open Eisenstein

/-! ### The norm is never `2 mod 3` -/

/-- **Key lemma:** the norm of an Eisenstein integer, reduced mod 3, is
either 0 or 1 — never 2. -/
theorem norm_mod_three (z : Eisenstein) :
    ((norm z : ℤ) : ZMod 3) = 0 ∨ ((norm z : ℤ) : ZMod 3) = 1 := by
  have h_cases : ∀ a b : ZMod 3, a^2 - a * b + b^2 = 0 ∨ a^2 - a * b + b^2 = 1 := by
    native_decide;
  convert h_cases ( z.a : ZMod 3 ) ( z.b : ZMod 3 ) <;> norm_cast

/-- The norm is never $\equiv 2 \pmod 3$. -/
theorem norm_ne_two_mod_three (z : Eisenstein) :
    ((norm z : ℤ) : ZMod 3) ≠ 2 := by
  intro h
  rcases norm_mod_three z with h0 | h1
  · rw [h0] at h; exact absurd h (by decide)
  · rw [h1] at h; exact absurd h (by decide)

/-! ### Consequences for arbitrary `n` -/

/-- If `n` is an integer with `n % 3 = 2`, no Eisenstein element has norm `n`. -/
theorem no_norm_eq_of_two_mod_three (n : ℤ) (hn : (n : ZMod 3) = 2) :
    ∀ z : Eisenstein, norm z ≠ n := by
  intro z h_eq
  have : ((norm z : ℤ) : ZMod 3) = 2 := by rw [h_eq]; exact hn
  exact norm_ne_two_mod_three z this

/-- A `ℕ`-version: if `p` is a natural number with `p % 3 = 2`, no Eisenstein
element has norm equal to `(p : ℤ)`. -/
theorem no_norm_eq_of_two_mod_three_nat (p : ℕ) (hp : p % 3 = 2) :
    ∀ z : Eisenstein, norm z ≠ (p : ℤ) := by
  apply no_norm_eq_of_two_mod_three
  have : (p : ZMod 3) = 2 := by
    rw [show (2 : ZMod 3) = ((2 : ℕ) : ZMod 3) from by decide]
    rw [ZMod.natCast_eq_natCast_iff']
    omega
  exact_mod_cast this

/-! ### The inert case: primes ≡ 2 mod 3 have no norm-p element -/

/-- **Inert primes:** if `p` is a prime with `p ≡ 2 (mod 3)`, then no
Eisenstein integer has norm `p`. -/
theorem inert_prime (p : ℕ) (_hp_prime : p.Prime) (hp_mod : p % 3 = 2) :
    ∀ z : Eisenstein, norm z ≠ (p : ℤ) :=
  no_norm_eq_of_two_mod_three_nat p hp_mod

/-! ### The ramified case: p = 3 has norm-3 element θ -/

/-- **Ramified prime 3:** the element $\theta = 1 - \omega$ has norm 3. -/
theorem ramified_three : ∃ z : Eisenstein, norm z = 3 :=
  ⟨θ, norm_θ⟩

/-! ### Concrete checks -/

/-- Spot check: prime 5 has no norm-5 Eisenstein element (inert, 5 ≡ 2 mod 3). -/
theorem no_norm_eq_five : ∀ z : Eisenstein, norm z ≠ 5 :=
  inert_prime 5 (by decide) (by decide)

/-- Spot check: prime 11 has no norm-11 Eisenstein element (inert, 11 ≡ 2 mod 3). -/
theorem no_norm_eq_eleven : ∀ z : Eisenstein, norm z ≠ 11 :=
  inert_prime 11 (by decide) (by decide)

/-- Spot check: prime 17 has no norm-17 Eisenstein element (inert, 17 ≡ 2 mod 3). -/
theorem no_norm_eq_seventeen : ∀ z : Eisenstein, norm z ≠ 17 :=
  inert_prime 17 (by decide) (by decide)

end EisensteinPrimeSplit
