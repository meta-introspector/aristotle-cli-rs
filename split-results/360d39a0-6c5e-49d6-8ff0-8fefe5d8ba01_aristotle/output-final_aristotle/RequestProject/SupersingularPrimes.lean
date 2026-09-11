/-
  SupersingularPrimes.lean — The 15 supersingular primes, Monster group order,
  McKay's observation, and Bott periodicity.
-/
import Mathlib

def supersingularPrimes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

theorem supersingularPrimes_length : supersingularPrimes.length = 15 := by native_decide
theorem supersingularPrimes_all_prime : ∀ p ∈ supersingularPrimes, Nat.Prime p := by
  simp only [supersingularPrimes, List.mem_cons, List.mem_singleton, List.mem_nil_iff]
  intro p hp
  rcases hp with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | h
  all_goals (first | decide | exact absurd h (by simp))
theorem supersingularPrimes_sorted : supersingularPrimes.Pairwise (· < ·) := by decide
theorem supersingularPrimes_nodup : supersingularPrimes.Nodup := by decide

theorem triangle_196883 : 47 * 59 * 71 = 196883 := by norm_num
theorem prime_47 : Nat.Prime 47 := by decide
theorem prime_59 : Nat.Prime 59 := by decide
theorem prime_71 : Nat.Prime 71 := by decide
theorem coprime_47_59 : Nat.Coprime 47 59 := by decide
theorem coprime_47_71 : Nat.Coprime 47 71 := by decide
theorem coprime_59_71 : Nat.Coprime 59 71 := by decide

theorem mckay_observation : 196884 = 196883 + 1 := by norm_num
theorem mckay_decomposition : 196884 = 1 + 47 * 59 * 71 := by norm_num

def monsterOrder : ℕ :=
  2 ^ 46 * 3 ^ 20 * 5 ^ 9 * 7 ^ 6 * 11 ^ 2 * 13 ^ 3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

theorem monsterOrder_positive : 0 < monsterOrder := by unfold monsterOrder; positivity

def bottClassFn (n : ℕ) : Fin 8 := ⟨n % 8, Nat.mod_lt n (by omega)⟩

theorem bott_period_8 (n : ℕ) : bottClassFn (n + 8) = bottClassFn n := by
  simp only [bottClassFn, Nat.add_mod_right]

theorem cl15_bott_class : bottClassFn 15 = ⟨7, by omega⟩ := by decide
theorem cl15_dim : 2 ^ 15 = 32768 := by norm_num
theorem coprime_clifford_monster : Nat.Coprime 32768 196883 := by native_decide
theorem harmonic_gcd : Nat.gcd 10 8 = 2 := by native_decide
theorem harmonic_lcm : Nat.lcm 10 8 = 40 := by native_decide
theorem eigenspace_decomposition : 7 + 5 + 1 + 2 = 15 := by norm_num
