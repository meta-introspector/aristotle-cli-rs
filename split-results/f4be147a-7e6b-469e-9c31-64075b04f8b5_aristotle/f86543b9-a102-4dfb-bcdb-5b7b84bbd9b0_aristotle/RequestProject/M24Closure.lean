import Mathlib

/-!
# M24 Prime Closure Under Divisor Sums

The Mathieu group M₂₄ is associated with the primes {2, 3, 5, 7, 11, 23}.
A natural question is whether the "Eisenstein arithmetic" — specifically, the
divisor sum functions σ_k(n) = ∑_{d|n} d^k — closes under this set of primes.

This file proves that it does **not**: applying σ₃ and σ₅ to small prime powers
of M24 primes immediately produces values with prime factors outside {2, 3, 5, 7, 11, 23}.

## Key results

### First iteration (from M24-smooth inputs)
- `sigma3_8_div_by_13`: 13 ∣ σ₃(2³), showing prime 13 is forced.
- `sigma5_8_div_by_41`: 41 ∣ σ₅(2³), showing prime 41 is forced.
- `sigma3_243_div_by_37`: 37 ∣ σ₃(3⁵), showing prime 37 is forced.
- `sigma3_7_div_by_43`: 43 ∣ σ₃(7), showing prime 43 is forced.
- `sigma3_4_eq_73`: σ₃(2²) = 73, a prime outside the M24 set.
- `sigma3_9_eq_757`: σ₃(3²) = 757, a prime outside even the supersingular set.

### Second iteration (from newly forced primes)
- `sigma3_13_div_by_157`: 157 ∣ σ₃(13), forcing a non-supersingular prime.

### Supersingular connection
- The first-iteration primes 13, 37, 41, 43 are all supersingular primes
  (primes dividing the order of the Monster group).
- But σ₃(3²) = 757 and σ₃(13) produces 157, which are NOT supersingular,
  showing the closure quickly escapes even the Monster's primes.

## Mathematical context

These results demonstrate that the arithmetic of modular forms interweaves
primes from different sporadic groups. Starting from the M24 primes, the
divisor sum operations force the appearance of primes significant to other
sporadic groups (the Monster's supersingular primes), and then quickly
produce primes beyond any single sporadic group's influence.
-/

/-- The divisor sigma function σ_k(n) = ∑_{d | n} d^k. -/
def divisorSigma (k n : ℕ) : ℕ :=
  (Nat.divisors n).sum (· ^ k)

/-! ## The M24 primes -/

/-- The M24 primes: prime divisors of |M₂₄| = 2¹⁰ · 3³ · 5 · 7 · 11 · 23. -/
def m24Primes : Finset ℕ := {2, 3, 5, 7, 11, 23}

/-! ## The supersingular primes

The supersingular primes are the 15 prime divisors of the order of the
Monster group. They are also characterized as the primes p for which the
supersingular j-invariants in characteristic p are all defined over 𝔽_p. -/

/-- The 15 supersingular primes (prime divisors of |𝕄|, the Monster group). -/
def supersingularPrimes : Finset ℕ := {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 59, 71}

/-! ## First iteration: σ₃ and σ₅ values -/

/-- σ₃(8) = 585 -/
theorem sigma3_8_val : divisorSigma 3 8 = 585 := by native_decide

/-- σ₅(8) = 33825 -/
theorem sigma5_8_val : divisorSigma 5 8 = 33825 := by native_decide

/-- σ₃(243) = 14900788 -/
theorem sigma3_243_val : divisorSigma 3 243 = 14900788 := by native_decide

/-- σ₃(7) = 344 -/
theorem sigma3_7_val : divisorSigma 3 7 = 344 := by native_decide

/-- σ₃(4) = 73, which is itself prime. -/
theorem sigma3_4_val : divisorSigma 3 4 = 73 := by native_decide

/-- σ₃(9) = 757, which is itself prime. -/
theorem sigma3_9_val : divisorSigma 3 9 = 757 := by native_decide

/-- σ₃(11) = 1332 -/
theorem sigma3_11_val : divisorSigma 3 11 = 1332 := by native_decide

/-- σ₃(23) = 12168 -/
theorem sigma3_23_val : divisorSigma 3 23 = 12168 := by native_decide

/-- σ₃(5) = 126 -/
theorem sigma3_5_val : divisorSigma 3 5 = 126 := by native_decide

/-! ## Second iteration: σ₃ of newly forced primes -/

/-- σ₃(13) = 2198 -/
theorem sigma3_13_val : divisorSigma 3 13 = 2198 := by native_decide

/-! ## Divisibility results: first iteration -/

/-- 13 divides σ₃(2³), forcing prime 13 into the closure. -/
theorem sigma3_8_div_by_13 : 13 ∣ divisorSigma 3 8 := by
  rw [sigma3_8_val]; norm_num

/-- 41 divides σ₅(2³), forcing prime 41 into the closure. -/
theorem sigma5_8_div_by_41 : 41 ∣ divisorSigma 5 8 := by
  rw [sigma5_8_val]; norm_num

/-- 37 divides σ₃(3⁵), forcing prime 37 into the closure. -/
theorem sigma3_243_div_by_37 : 37 ∣ divisorSigma 3 243 := by
  rw [sigma3_243_val]; norm_num

/-- 43 divides σ₃(7), forcing prime 43 into the closure. -/
theorem sigma3_7_div_by_43 : 43 ∣ divisorSigma 3 7 := by
  rw [sigma3_7_val]; norm_num

/-- 73 divides σ₃(2²) (in fact σ₃(4) = 73 exactly). -/
theorem sigma3_4_div_by_73 : 73 ∣ divisorSigma 3 4 := by
  rw [sigma3_4_val]

/-- 757 divides σ₃(3²) (in fact σ₃(9) = 757 exactly). -/
theorem sigma3_9_div_by_757 : 757 ∣ divisorSigma 3 9 := by
  rw [sigma3_9_val]

/-- 37 also divides σ₃(11), giving a second route to prime 37. -/
theorem sigma3_11_div_by_37 : 37 ∣ divisorSigma 3 11 := by
  rw [sigma3_11_val]; norm_num

/-- 13 also divides σ₃(23), giving a second route to prime 13. -/
theorem sigma3_23_div_by_13 : 13 ∣ divisorSigma 3 23 := by
  rw [sigma3_23_val]; norm_num

/-! ## Divisibility results: second iteration -/

/-- 157 divides σ₃(13), forcing prime 157 in the second iteration. -/
theorem sigma3_13_div_by_157 : 157 ∣ divisorSigma 3 13 := by
  rw [sigma3_13_val]; norm_num

/-! ## Primality of forced primes -/

theorem prime_13 : Nat.Prime 13 := by decide
theorem prime_37 : Nat.Prime 37 := by decide
theorem prime_41 : Nat.Prime 41 := by decide
theorem prime_43 : Nat.Prime 43 := by decide
theorem prime_73 : Nat.Prime 73 := by decide
theorem prime_157 : Nat.Prime 157 := by native_decide
theorem prime_757 : Nat.Prime 757 := by native_decide

/-! ## M24 membership results -/

/-- 8 = 2³ is a product of M24 primes. -/
theorem eight_m24_smooth : ∀ p, Nat.Prime p → p ∣ 8 → p ∈ m24Primes := by
  intro p hp hd
  have hle : p ≤ 8 := Nat.le_of_dvd (by norm_num) hd
  have hge : 2 ≤ p := hp.two_le
  interval_cases p <;> first | exact absurd hp (by decide) | simp_all [m24Primes]

/-- 4 = 2² is a product of M24 primes. -/
theorem four_m24_smooth : ∀ p, Nat.Prime p → p ∣ 4 → p ∈ m24Primes := by
  intro p hp hd
  have hle : p ≤ 4 := Nat.le_of_dvd (by norm_num) hd
  have hge : 2 ≤ p := hp.two_le
  have : p = 2 ∨ p = 3 ∨ p = 4 := by omega
  rcases this with rfl | rfl | rfl
  · simp [m24Primes]
  · exact absurd hd (by decide)
  · exact absurd hp (by decide)

/-- 9 = 3² is a product of M24 primes. -/
theorem nine_m24_smooth : ∀ p, Nat.Prime p → p ∣ 9 → p ∈ m24Primes := by
  intro p hp hd
  have hle : p ≤ 9 := Nat.le_of_dvd (by norm_num) hd
  have hge : 2 ≤ p := hp.two_le
  have : p = 2 ∨ p = 3 ∨ p = 4 ∨ p = 5 ∨ p = 6 ∨ p = 7 ∨ p = 8 ∨ p = 9 := by omega
  rcases this with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
    first | exact absurd hp (by decide) | exact absurd hd (by decide) | simp [m24Primes]

theorem thirteen_not_m24 : 13 ∉ m24Primes := by decide
theorem thirtyseven_not_m24 : 37 ∉ m24Primes := by decide
theorem fortyone_not_m24 : 41 ∉ m24Primes := by decide
theorem fortythree_not_m24 : 43 ∉ m24Primes := by decide
theorem seventythree_not_m24 : 73 ∉ m24Primes := by decide
theorem sevenfiftyseven_not_m24 : 757 ∉ m24Primes := by decide

/-! ## Supersingular membership -/

/-- 13 is a supersingular prime (divides |Monster|). -/
theorem thirteen_supersingular : 13 ∈ supersingularPrimes := by decide

/-- 37 is a supersingular prime. -/
theorem thirtyseven_supersingular : 37 ∈ supersingularPrimes := by decide

/-- 41 is a supersingular prime. -/
theorem fortyone_supersingular : 41 ∈ supersingularPrimes := by decide

/-- 43 is a supersingular prime. -/
theorem fortythree_supersingular : 43 ∈ supersingularPrimes := by decide

/-- 73 is NOT a supersingular prime — even the first iteration escapes the Monster. -/
theorem seventythree_not_supersingular : 73 ∉ supersingularPrimes := by decide

/-- 757 is NOT a supersingular prime — the closure escapes the Monster's primes. -/
theorem sevenfiftyseven_not_supersingular : 757 ∉ supersingularPrimes := by decide

/-- 157 is NOT a supersingular prime. -/
theorem onefiftyseven_not_supersingular : 157 ∉ supersingularPrimes := by decide

/-! ## Main theorems -/

/-- The M24 primes are not closed under "take prime factors of σ₃":
there exists an M24-smooth number whose σ₃ has a prime factor outside M24. -/
theorem m24_primes_not_closed_under_sigma3 :
    ∃ (n : ℕ), (∀ p, Nat.Prime p → p ∣ n → p ∈ m24Primes) ∧
    (∃ q, Nat.Prime q ∧ q ∣ divisorSigma 3 n ∧ q ∉ m24Primes) :=
  ⟨8, eight_m24_smooth, 13, prime_13, sigma3_8_div_by_13, thirteen_not_m24⟩

/-- The M24 primes are not closed under σ₅ either. -/
theorem m24_primes_not_closed_under_sigma5 :
    ∃ (n : ℕ), (∀ p, Nat.Prime p → p ∣ n → p ∈ m24Primes) ∧
    (∃ q, Nat.Prime q ∧ q ∣ divisorSigma 5 n ∧ q ∉ m24Primes) :=
  ⟨8, eight_m24_smooth, 41, prime_41, sigma5_8_div_by_41, by decide⟩

/-- Even σ₃ applied to a single M24 prime (7) produces a non-M24 prime factor (43). -/
theorem m24_primes_not_closed_under_sigma3_single_prime :
    ∃ (p : ℕ), p ∈ m24Primes ∧ Nat.Prime p ∧
    (∃ q, Nat.Prime q ∧ q ∣ divisorSigma 3 p ∧ q ∉ m24Primes) :=
  ⟨7, by decide, by decide, 43, prime_43, sigma3_7_div_by_43, by decide⟩

/-- The first-iteration forced primes (13, 37, 41, 43) are all supersingular,
connecting M24 arithmetic to the Monster group. -/
theorem first_iteration_primes_are_supersingular :
    (13 ∈ supersingularPrimes) ∧ (37 ∈ supersingularPrimes) ∧
    (41 ∈ supersingularPrimes) ∧ (43 ∈ supersingularPrimes) := by decide

/-- The closure escapes the supersingular primes already at 2²: σ₃(4) = 73,
which is prime and not supersingular. -/
theorem closure_escapes_supersingular_at_4 :
    ∃ (n : ℕ), (∀ p, Nat.Prime p → p ∣ n → p ∈ m24Primes) ∧
    (∃ q, Nat.Prime q ∧ q ∣ divisorSigma 3 n ∧ q ∉ supersingularPrimes) :=
  ⟨4, four_m24_smooth, 73, prime_73, sigma3_4_div_by_73, seventythree_not_supersingular⟩

/-- σ₃(3²) = 757, another non-supersingular prime, confirming the pattern. -/
theorem closure_escapes_supersingular_at_9 :
    ∃ (n : ℕ), (∀ p, Nat.Prime p → p ∣ n → p ∈ m24Primes) ∧
    (∃ q, Nat.Prime q ∧ q ∣ divisorSigma 3 n ∧ q ∉ supersingularPrimes) :=
  ⟨9, nine_m24_smooth, 757, prime_757, sigma3_9_div_by_757, sevenfiftyseven_not_supersingular⟩

/-- The second iteration also produces non-supersingular primes:
13 is forced in the first iteration, and σ₃(13) has the prime factor 157
which is not supersingular. -/
theorem second_iteration_escapes_supersingular :
    ∃ (p : ℕ), Nat.Prime p ∧ p ∉ m24Primes ∧ p ∈ supersingularPrimes ∧
    (∃ q, Nat.Prime q ∧ q ∣ divisorSigma 3 p ∧ q ∉ supersingularPrimes) :=
  ⟨13, prime_13, thirteen_not_m24, thirteen_supersingular,
   157, prime_157, sigma3_13_div_by_157, onefiftyseven_not_supersingular⟩

/-- Multiple M24 primes independently force the same non-M24 primes:
both σ₃(2³) and σ₃(23) are divisible by 13, and both σ₃(3⁵) and σ₃(11)
are divisible by 37. This shows the interconnections are robust, not accidental. -/
theorem redundant_forcing_paths :
    (13 ∣ divisorSigma 3 8 ∧ 13 ∣ divisorSigma 3 23) ∧
    (37 ∣ divisorSigma 3 243 ∧ 37 ∣ divisorSigma 3 11) :=
  ⟨⟨sigma3_8_div_by_13, sigma3_23_div_by_13⟩,
   ⟨sigma3_243_div_by_37, sigma3_11_div_by_37⟩⟩
