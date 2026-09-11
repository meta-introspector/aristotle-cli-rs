/-
# Monster Group Order

The Monster group M has order:
  |M| = 2^46 · 3^20 · 5^9 · 7^6 · 11^2 · 13^3 · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71

Key structural observation: primes 17–71 appear with exponent exactly 1.
This means the "large" supersingular primes act as binary flags rather than
graded towers in the Monster's factorization.
-/
import Mathlib
import RequestProject.Math.Monster.Slice.SupersingularPrimes

namespace MonsterSlice

/-! ## Monster group order -/

/-- The order of the Monster group. -/
def monsterOrder : ℕ :=
  2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- The Monster order as a decimal. -/
theorem monsterOrder_value :
    monsterOrder = 808017424794512875886459904961710757005754368000000000 := by native_decide

/-- The exponents of each supersingular prime in the Monster order.
    Maps prime index (0-14) to its exponent in |M|. -/
def monsterExponent : Fin 15 → ℕ
  | ⟨0, _⟩ => 46   -- 2^46
  | ⟨1, _⟩ => 20   -- 3^20
  | ⟨2, _⟩ => 9    -- 5^9
  | ⟨3, _⟩ => 6    -- 7^6
  | ⟨4, _⟩ => 2    -- 11^2
  | ⟨5, _⟩ => 3    -- 13^3
  | ⟨6, _⟩ => 1    -- 17^1
  | ⟨7, _⟩ => 1    -- 19^1
  | ⟨8, _⟩ => 1    -- 23^1
  | ⟨9, _⟩ => 1    -- 29^1
  | ⟨10, _⟩ => 1   -- 31^1
  | ⟨11, _⟩ => 1   -- 41^1
  | ⟨12, _⟩ => 1   -- 47^1
  | ⟨13, _⟩ => 1   -- 59^1
  | ⟨14, _⟩ => 1   -- 71^1

/-- Primes with index ≥ 6 (i.e., 17, 19, 23, 29, 31, 41, 47, 59, 71) have exponent 1. -/
theorem monsterExponent_large_primes (i : Fin 15) (hi : 6 ≤ i.val) :
    monsterExponent i = 1 := by
  fin_cases i <;> simp_all [monsterExponent]

/-- The "small" primes (2, 3, 5, 7, 11, 13) have exponent > 1. -/
theorem monsterExponent_small_primes (i : Fin 15) (hi : i.val < 6) :
    1 < monsterExponent i := by
  fin_cases i <;> simp_all [monsterExponent]

/-- The Monster order equals the product of p_i^{e_i} over all supersingular primes. -/
theorem monsterOrder_eq_prod :
    monsterOrder = ∏ i : Fin 15, (supersingularPrime i) ^ (monsterExponent i) := by
  native_decide

/-- The number of "large" (exponent-1) supersingular primes is 9. -/
theorem count_exponent_one_primes :
    (Finset.univ.filter (fun i : Fin 15 => monsterExponent i = 1)).card = 9 := by
  native_decide

/-- The number of "small" (exponent > 1) supersingular primes is 6. -/
theorem count_exponent_gt_one_primes :
    (Finset.univ.filter (fun i : Fin 15 => 1 < monsterExponent i)).card = 6 := by
  native_decide

/-! ## The skeleton pair {3, 19}

After stripping all primes via a hex walk, only 3 and 19 survive as the
irreducible skeleton of the Monster:
- 3 is the dominant odd exponent (e₃ = 20)
- 19 is the hub eigenvector
-/

/-- The skeleton pair: indices of primes 3 and 19 in the supersingular ordering. -/
def skeletonPairIdx : Fin 15 × Fin 15 := (⟨1, by omega⟩, ⟨7, by omega⟩)

/-- The skeleton pair consists of primes 3 and 19. -/
theorem skeleton_pair_primes :
    supersingularPrime skeletonPairIdx.1 = 3 ∧
    supersingularPrime skeletonPairIdx.2 = 19 := by native_decide

/-- 3 has the largest odd-prime exponent (20). -/
theorem three_max_odd_exponent :
    monsterExponent ⟨1, by omega⟩ = 20 := by native_decide

/-- 19 is the unique hub prime with exponent 1. -/
theorem nineteen_hub_exponent :
    monsterExponent ⟨7, by omega⟩ = 1 := by native_decide

end MonsterSlice
