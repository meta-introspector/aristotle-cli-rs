import Mathlib
/-!
# Supersingular Primes and the Monster Group Order
This file formalizes the 15 supersingular primes from moonshine theory
and their relationship to the order of the Monster group M.
## Informal source references
- "The 15-SSP prime support vectors of the 194 irreps as the actual generator set"
- "There are precisely 15 supersingular primes: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71"
- "These are exactly the primes dividing |M|"
-/
set_option maxHeartbeats 800000
/-- The 15 supersingular primes in moonshine theory. These are precisely the prime
divisors of |M| (the order of the Monster group), and also exactly the primes p
for which the modular curve X₀(p) has genus zero (Ogg's observation).
**Informal source**: "The 15-SSP prime support vectors of the 194 irreps as the actual
generator set" and "There are precisely 15 supersingular primes (in the moonshine sense):
2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71." -/
def supersingularPrimes : Finset ℕ :=
  {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71}
/-- The supersingular primes as an ordered list, for indexing by bit position.
**Informal source**: "bits 0..14 correspond to the 15 supersingular primes" -/
def supersingularPrimesList : List ℕ :=
  [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]
/-- There are exactly 15 supersingular primes.
**Informal source**: "15-bit mask" / "15-SSP prime support vectors" -/
theorem supersingularPrimes_card : supersingularPrimes.card = 15 := by native_decide
/-- The list of supersingular primes has length 15.
**Informal source**: "15-bit mask" -/
theorem supersingularPrimesList_length : supersingularPrimesList.length = 15 := by native_decide
/-- Every supersingular prime is indeed a prime number.
**Informal source**: "15 supersingular primes" -/
theorem supersingularPrimes_all_prime : ∀ p ∈ supersingularPrimes, Nat.Prime p := by decide
/-- The list of supersingular primes contains no duplicates.
**Informal source**: implicit in the definition as a set of 15 distinct primes -/
theorem supersingularPrimesList_nodup : supersingularPrimesList.Nodup := by native_decide
/-- The Finset and List representations agree.
**Informal source**: consistency between set and ordered representations -/
theorem supersingularPrimes_eq_list_toFinset :
    supersingularPrimes = supersingularPrimesList.toFinset := by native_decide
/-- The order of the Monster group M.
  |M| = 2⁴⁶ · 3²⁰ · 5⁹ · 7⁶ · 11² · 13³ · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71
  ≈ 8.08 × 10⁵³
**Informal source**: "the 15 supersingular primes and their relation to the Monster's order" -/
def monsterOrder : ℕ :=
  2 ^ 46 * 3 ^ 20 * 5 ^ 9 * 7 ^ 6 * 11 ^ 2 * 13 ^ 3 *
  17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71
/-- The order of the Monster is positive.
**Informal source**: basic well-definedness of |M| -/
theorem monsterOrder_pos : 0 < monsterOrder := by
  unfold monsterOrder; positivity
/-- Each supersingular prime divides the order of the Monster.
**Informal source**: "These are exactly the primes dividing |M|" -/
theorem ssp_dvd_monsterOrder : ∀ p ∈ supersingularPrimes, p ∣ monsterOrder := by
  intro p hp
  fin_cases hp <;> simp_all [monsterOrder]
/-- The number of conjugacy classes (equivalently, irreducible complex representations)
of the Monster group.
**Informal source**: "194 conjugacy classes" / "194 irreps" / "Each irrep is a 15-bit mask" -/
def numIrreps : ℕ := 194
/-- The Monster has exactly 194 irreducible representations.
**Informal source**: "monster_irreps_card_eq_conj_classes : numIrreps = 194" -/
theorem numIrreps_val : numIrreps = 194 := rfl
