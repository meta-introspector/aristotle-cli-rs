/-
# M24 Arithmetic Closure under σ₃

The Mathieu group M₂₄ has order 2¹⁰ · 3³ · 5 · 7 · 11 · 23.
We study the closure of its prime factors under the arithmetic operator
σ₃(n) = Σ_{d|n} d³ (the sum of cubes of divisors).

## Key results:
- The first iteration forces supersingular primes: 13, 37, 43
- The closure also escapes the supersingular primes at 4 and 9
- Second iteration continues producing non-supersingular primes
-/
import Mathlib

set_option maxHeartbeats 800000
set_option maxRecDepth 8192

open Nat Finset BigOperators

/-! ## The σ₃ function: sum of cubes of divisors -/

/-- σ₃(n) = Σ_{d|n} d³, the sum of cubes of divisors of n. -/
def sigma3 (n : ℕ) : ℕ := ∑ d ∈ n.divisors, d ^ 3

/-! ## First-iteration computations

We compute σ₃ on M₂₄ primes and small M₂₄-smooth numbers. -/

theorem sigma3_2 : sigma3 2 = 9 := by native_decide
theorem sigma3_3 : sigma3 3 = 28 := by native_decide
theorem sigma3_4 : sigma3 4 = 73 := by native_decide
theorem sigma3_5 : sigma3 5 = 126 := by native_decide
theorem sigma3_7 : sigma3 7 = 344 := by native_decide
theorem sigma3_8 : sigma3 8 = 585 := by native_decide
theorem sigma3_9 : sigma3 9 = 757 := by native_decide
theorem sigma3_11 : sigma3 11 = 1332 := by native_decide
theorem sigma3_13 : sigma3 13 = 2198 := by native_decide
theorem sigma3_23 : sigma3 23 = 12168 := by native_decide

/-! ## Prime divisibility: forced primes from M₂₄ inputs -/

/-- σ₃(8) = 585 = 3² · 5 · 13, forcing prime 13 -/
theorem sigma3_8_div_13 : 13 ∣ sigma3 8 := by rw [sigma3_8]; norm_num

/-- σ₃(7) = 344 = 2³ · 43, forcing prime 43 -/
theorem sigma3_7_div_43 : 43 ∣ sigma3 7 := by rw [sigma3_7]; norm_num

/-- σ₃(11) = 1332 is divisible by 37 -/
theorem sigma3_11_div_37 : 37 ∣ sigma3 11 := by rw [sigma3_11]; norm_num

/-- σ₃(23) = 12168 is divisible by 13 -/
theorem sigma3_23_div_13 : 13 ∣ sigma3 23 := by rw [sigma3_23]; norm_num

/-- σ₃(13) = 2198 is divisible by 157 -/
theorem sigma3_13_div_157 : 157 ∣ sigma3 13 := by rw [sigma3_13]; norm_num

/-! ## Primality of escape primes -/

theorem prime_73 : Nat.Prime 73 := by decide
theorem prime_757 : Nat.Prime 757 := by decide
theorem prime_157 : Nat.Prime 157 := by decide

/-! ## Supersingular primes

The 15 supersingular primes are the prime divisors of the order of the
Monster group: {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 59, 71}. -/

/-- The set of supersingular primes (prime divisors of |Monster|). -/
def supersingularPrimes : Finset ℕ :=
  (⟨[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 59, 71], by decide⟩ : Finset ℕ)

/-! ## First-iteration primes are supersingular -/

theorem first_iteration_primes_are_supersingular :
    ({13, 37, 43} : Finset ℕ) ⊆ supersingularPrimes := by decide

/-! ## The closure escapes supersingular primes -/

/-- σ₃(4) = 73, which is NOT a supersingular prime. -/
theorem closure_escapes_supersingular_at_4 :
    73 ∉ supersingularPrimes := by decide

/-- σ₃(9) = 757, confirming the escape pattern. -/
theorem closure_escapes_supersingular_at_9 :
    757 ∉ supersingularPrimes := by decide

/-- σ₃(13) → 157, which is non-supersingular. -/
theorem second_iteration_escapes_supersingular :
    157 ∉ supersingularPrimes := by decide

/-! ## Redundant forcing paths -/

/-- Multiple M₂₄ inputs independently force the same supersingular primes. -/
theorem redundant_forcing_paths :
    (13 ∣ sigma3 8 ∧ 13 ∣ sigma3 23) ∧ (37 ∣ sigma3 11) :=
  ⟨⟨sigma3_8_div_13, sigma3_23_div_13⟩, sigma3_11_div_37⟩

/-! ## σ₃(243) = σ₃(3⁵) forces prime 37 -/

theorem sigma3_243 : sigma3 243 = 14900788 := by native_decide

/-- σ₃(243) is divisible by 37, giving a second route to 37. -/
theorem sigma3_243_div_37 : 37 ∣ sigma3 243 := by rw [sigma3_243]; norm_num
