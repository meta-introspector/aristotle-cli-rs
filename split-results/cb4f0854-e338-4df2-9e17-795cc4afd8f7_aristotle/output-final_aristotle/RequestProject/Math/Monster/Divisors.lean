import Mathlib

namespace Divisors

/-!
# The Oggorial: Product of the Supersingular Primes

The **Oggorial** is the product of the 15 supersingular primes (Ogg's primes):
  2 × 3 × 5 × 7 × 11 × 13 × 17 × 19 × 23 × 29 × 31 × 41 × 47 × 59 × 71
    = 1,618,964,990,108,856,390

These are the primes p for which the classical modular curve X₀(p) has genus zero,
equivalently the primes dividing the order of the Monster group. Andrew Ogg's observation
that these two lists coincide was an early hint of **monstrous moonshine**, later proved
by Borcherds.

This file proves:
- The factorization of the Oggorial into 15 distinct primes.
- The Oggorial is squarefree.
- The Oggorial has exactly 2^15 = 32768 divisors.
- Some small examples of counting primes between consecutive divisors.
-/

/-- The **supersingular primes** (Ogg's primes): the 15 primes p for which the
classical modular curve X₀(p) has genus zero. -/
def supersingularPrimes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- The **Oggorial**: product of the 15 supersingular primes. -/
def oggorial : ℕ := 1618964990108856390

-- ============================================================================
-- § 1. Factorization
-- ============================================================================

/-- The Oggorial factors as the product of the 15 supersingular primes. -/
theorem oggorial_eq_prod :
    oggorial = 2 * 3 * 5 * 7 * 11 * 13 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71 := by
  native_decide

/-- Every supersingular prime is indeed prime. -/
theorem supersingularPrimes_all_prime :
    ∀ p ∈ supersingularPrimes, Nat.Prime p := by
  decide

/-- The 15 supersingular primes are pairwise distinct (and listed in increasing order). -/
theorem supersingularPrimes_pairwise : supersingularPrimes.Pairwise (· < ·) := by
  decide

/-- There are exactly 15 supersingular primes. -/
theorem supersingularPrimes_length : supersingularPrimes.length = 15 := by
  decide

/-- The product of the supersingular primes list equals the Oggorial. -/
theorem supersingularPrimes_prod : supersingularPrimes.prod = oggorial := by
  native_decide

/-- The prime factors of the Oggorial are exactly the 15 supersingular primes. -/
theorem oggorial_primeFactors :
    oggorial.primeFactors = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71} := by
  native_decide

-- ============================================================================
-- § 2. Divisor count
-- ============================================================================

/-- The Oggorial is squarefree (each prime appears with exponent exactly 1). -/
theorem oggorial_squarefree : Squarefree oggorial := by
  native_decide

/-- The Oggorial has exactly 2^15 = 32768 divisors.

We avoid computing all 32768 divisors directly (which would be too expensive).
Instead we use `Nat.card_divisors`, which expresses the divisor count as
  ∏ p ∈ n.primeFactors, (n.factorization p + 1)
Since each of the 15 prime factors appears with exponent 1, this product equals 2^15.
-/
theorem oggorial_num_divisors : oggorial.divisors.card = 32768 := by
  rw [Nat.card_divisors (show oggorial ≠ 0 by decide)]
  native_decide

-- ============================================================================
-- § 3. Counting primes between consecutive divisors
-- ============================================================================

/-- Count the number of primes p with a < p < b. -/
noncomputable def countPrimesBetween (a b : ℕ) : ℕ :=
  ((Finset.Ico (a + 1) b).filter Nat.Prime).card

/-- There are no primes between divisors 1 and 2. -/
theorem no_primes_1_2 : countPrimesBetween 1 2 = 0 := by decide

/-- There are no primes between divisors 5 and 6. -/
theorem no_primes_5_6 : countPrimesBetween 5 6 = 0 := by decide

/-- There is exactly one prime (37) between divisors 35 and 38.
Note that 37 is **not** a supersingular prime — it falls in a gap
between consecutive divisors of the Oggorial. -/
theorem one_prime_35_38 : countPrimesBetween 35 38 = 1 := by decide

/-- There is exactly one prime (43) between divisors 42 and 46.
Similarly, 43 is not a supersingular prime. -/
theorem one_prime_42_46 : countPrimesBetween 42 46 = 1 := by decide

end Divisors
