import Mathlib

/-!
# Supersingular Primes

The 15 supersingular primes: primes p such that the supersingular j-invariants
in characteristic p are all in 𝔽_p. Equivalently, p divides |M| (the Monster group order).
-/

open scoped BigOperators

/-- The 15 supersingular primes, listed in increasing order. -/
def supersingularPrimesList : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- The set of supersingular primes. -/
def supersingularPrimes : Finset ℕ :=
  {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71}

/-- Number of supersingular primes. -/
theorem supersingularPrimes_card : supersingularPrimes.card = 15 := by native_decide

/-- All supersingular primes are prime. -/
theorem supersingularPrimes_all_prime : ∀ p ∈ supersingularPrimes, Nat.Prime p := by decide

/-- The product 71 × 59 × 47 = 196883, the dimension of the smallest faithful
    Monster representation. -/
theorem monster_rep_dim : 71 * 59 * 47 = 196883 := by norm_num

/-- The Monster group order as a natural number. -/
def monsterOrder : ℕ :=
  2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- Every supersingular prime divides the Monster group order. -/
theorem ssp_dvd_monsterOrder : ∀ p ∈ supersingularPrimes, p ∣ monsterOrder := by decide

/-- The number of conjugacy classes (= number of irreducible representations) of the Monster. -/
def numIrreps : ℕ := 194

/-- The three key primes whose product gives the smallest faithful rep dimension. -/
def keyPrimes : Fin 3 → ℕ := ![71, 59, 47]

theorem keyPrimes_are_ssp : ∀ i : Fin 3, keyPrimes i ∈ supersingularPrimes := by decide

/-- Index mapping: which position (0-indexed) each SSP occupies in the sorted list. -/
def sspIndex (i : Fin 15) : ℕ := supersingularPrimesList[i]
