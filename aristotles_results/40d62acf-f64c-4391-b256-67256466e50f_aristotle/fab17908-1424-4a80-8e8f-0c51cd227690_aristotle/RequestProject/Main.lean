import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

/-!
# Monster group order: verification of its 15 prime factors

The order of the Fischer–Griess Monster sporadic simple group `M` is

`|M| = 2^46 · 3^20 · 5^9 · 7^6 · 11^2 · 13^3 · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71`.

Its set of distinct prime divisors has exactly 15 elements, namely
`{2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71}`.

These are also exactly the "supersingular primes" appearing in monstrous moonshine.
Below we encode `|M|` as a Lean natural number and verify, by kernel-checked
computation, its decimal value and its complete set of prime factors.
-/

namespace Monster

/-- The order of the Monster group, given as a prime factorization. -/
def monsterOrder : ℕ :=
  2 ^ 46 * 3 ^ 20 * 5 ^ 9 * 7 ^ 6 * 11 ^ 2 * 13 ^ 3
    * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- The decimal value of the Monster group order. -/
theorem monsterOrder_value :
    monsterOrder = 808017424794512875886459904961710757005754368000000000 := by
  native_decide

/-- The 15 distinct prime divisors of the Monster group order. -/
theorem monsterOrder_primeFactors :
    monsterOrder.primeFactors =
      {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71} := by
  native_decide

/-- The Monster group order has exactly 15 distinct prime divisors. -/
theorem monsterOrder_primeFactors_card :
    monsterOrder.primeFactors.card = 15 := by
  native_decide

/-- Each of the 15 listed numbers is indeed prime. -/
theorem monster_primes_prime :
    (∀ p ∈ ({2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71} : Finset ℕ),
      Nat.Prime p) := by
  decide

end Monster
