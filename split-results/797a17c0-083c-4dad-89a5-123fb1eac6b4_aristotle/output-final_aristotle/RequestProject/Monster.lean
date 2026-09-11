import Mathlib

/-!
# The Monster, supersingular primes, and Ogg's coincidence

This file records, as a verified arithmetic fact, the famous coincidence at the root of
**Monstrous Moonshine**: the primes dividing the order of the Monster sporadic simple group
`M` are *exactly* the fifteen **supersingular primes**

`2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71`

(Ogg's observation).  We take `monsterOrder` to be the order of the Monster,

`|M| = 2⁴⁶·3²⁰·5⁹·7⁶·11²·13³·17·19·23·29·31·41·47·59·71`,

define `supersingularPrimes` as the fifteen-element set above, and prove:

* `supersingularPrimes_prime` — all fifteen are prime;
* `supersingular_dvd_monster` — each one divides `|M|`;
* `supersingular_no_spillover` — **no spillover**: every prime dividing `|M|` is one of
  these fifteen, so the Monster's prime support does not leak beyond `71`;
* `ogg_coincidence` — combining the two directions, a prime divides `|M|` *iff* it is
  supersingular;
* `supersingular_le_71` — in particular `71` is the largest prime factor of `|M|`.
-/

namespace Monster

/-- The order of the Monster sporadic simple group `M`,
`2⁴⁶·3²⁰·5⁹·7⁶·11²·13³·17·19·23·29·31·41·47·59·71`. -/
def monsterOrder : ℕ :=
  2 ^ 46 * 3 ^ 20 * 5 ^ 9 * 7 ^ 6 * 11 ^ 2 * 13 ^ 3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- The fifteen **supersingular primes**. -/
def supersingularPrimes : Finset ℕ :=
  {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71}

/-- There are exactly fifteen supersingular primes. -/
theorem card_supersingularPrimes : supersingularPrimes.card = 15 := by decide

/-- The Monster has nonzero order. -/
theorem monsterOrder_ne_zero : monsterOrder ≠ 0 := by
  unfold monsterOrder; positivity

/-- All fifteen supersingular primes are indeed prime. -/
theorem supersingularPrimes_prime : ∀ p ∈ supersingularPrimes, Nat.Prime p := by decide

/-- Each supersingular prime divides the order of the Monster. -/
theorem supersingular_dvd_monster : ∀ p ∈ supersingularPrimes, p ∣ monsterOrder := by
  native_decide

/-- The set of prime factors of `|M|` is exactly the set of supersingular primes. -/
theorem monster_primeFactors : monsterOrder.primeFactors = supersingularPrimes := by
  native_decide

/-- **No spillover.**  Every prime dividing the order of the Monster is one of the fifteen
supersingular primes. -/
theorem supersingular_no_spillover (p : ℕ) (hp : Nat.Prime p) (hdvd : p ∣ monsterOrder) :
    p ∈ supersingularPrimes := by
  have : p ∈ monsterOrder.primeFactors :=
    Nat.mem_primeFactors.mpr ⟨hp, hdvd, monsterOrder_ne_zero⟩
  rwa [monster_primeFactors] at this

/-- **Ogg's coincidence.**  A prime divides the order of the Monster if and only if it is a
supersingular prime. -/
theorem ogg_coincidence (p : ℕ) (hp : Nat.Prime p) :
    p ∣ monsterOrder ↔ p ∈ supersingularPrimes :=
  ⟨supersingular_no_spillover p hp, fun h => supersingular_dvd_monster p h⟩

/-- `71` is the largest prime factor of the Monster's order: no prime factor spills past it. -/
theorem supersingular_le_71 (p : ℕ) (hp : Nat.Prime p) (hdvd : p ∣ monsterOrder) :
    p ≤ 71 := by
  have h := supersingular_no_spillover p hp hdvd
  fin_cases h <;> norm_num

end Monster
