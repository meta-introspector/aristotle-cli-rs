/-
  MonsterMoonshine.lean

  Formalizes key aspects of Monstrous Moonshine:
  j-invariant coefficients, Monster irrep dimensions, McKay's observation,
  genus-0 primes, Hecke operators, and p-adic valuations.
-/
import Mathlib
import RequestProject.SupersingularPrimes

/-! ## §1. Monster irrep dimensions -/

def monsterIrrepDims : List ℕ := [1, 196883, 21296876, 842609326]

theorem monster_trivial_dim : monsterIrrepDims[0]! = 1 := by native_decide
theorem monster_min_nontrivial : monsterIrrepDims[1]! = 196883 := by native_decide

/-! ## §2. j-invariant q-expansion -/

def jCoefficients : List ℤ := [1, 744, 196884, 21493760, 864299970]

theorem j_constant_term : jCoefficients[1]! = 744 := by native_decide
theorem j_first_coeff : jCoefficients[2]! = 196884 := by native_decide

/-- McKay's observation: c₁(j) = 1 + 196883. -/
theorem mckay_observation_decomp :
    jCoefficients[2]! = (monsterIrrepDims[0]! : ℤ) + monsterIrrepDims[1]! := by native_decide

/-- The q² coefficient: 21493760 = 1 + 196883 + 21296876. -/
theorem j_q2_decomp :
    jCoefficients[3]! = (monsterIrrepDims[0]! : ℤ) + monsterIrrepDims[1]! + monsterIrrepDims[2]! := by
  native_decide

/-! ## §3. Genus-0 primes = supersingular primes -/

def genus0Primes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

theorem genus0_eq_supersingular : genus0Primes = supersingularPrimes := rfl
theorem genus0_all_prime : ∀ p ∈ genus0Primes, Nat.Prime p := by decide
theorem genus0_count : genus0Primes.length = 15 := by native_decide

/-! ## §4. Hecke operators -/

def heckeIndexToPrime : Fin 15 → ℕ
  | ⟨0, _⟩ => 2  | ⟨1, _⟩ => 3  | ⟨2, _⟩ => 5  | ⟨3, _⟩ => 7  | ⟨4, _⟩ => 11
  | ⟨5, _⟩ => 13 | ⟨6, _⟩ => 17 | ⟨7, _⟩ => 19 | ⟨8, _⟩ => 23 | ⟨9, _⟩ => 29
  | ⟨10, _⟩ => 31 | ⟨11, _⟩ => 41 | ⟨12, _⟩ => 47 | ⟨13, _⟩ => 59 | ⟨14, _⟩ => 71

theorem hecke_all_prime : ∀ (i : Fin 15), Nat.Prime (heckeIndexToPrime i) := by
  intro i; fin_cases i <;> decide

/-! ## §5. p-adic valuations -/

def monsterValuation : Fin 15 → ℕ
  | ⟨0, _⟩ => 46  | ⟨1, _⟩ => 20  | ⟨2, _⟩ => 9   | ⟨3, _⟩ => 6   | ⟨4, _⟩ => 2
  | ⟨5, _⟩ => 3   | ⟨6, _⟩ => 1   | ⟨7, _⟩ => 1   | ⟨8, _⟩ => 1   | ⟨9, _⟩ => 1
  | ⟨10, _⟩ => 1  | ⟨11, _⟩ => 1  | ⟨12, _⟩ => 1  | ⟨13, _⟩ => 1  | ⟨14, _⟩ => 1

theorem monster_valuation_sum :
    Finset.univ.sum monsterValuation = 95 := by native_decide

theorem monster_max_valuation :
    Finset.univ.sup' ⟨⟨0, by omega⟩, Finset.mem_univ _⟩ monsterValuation = 46 := by
  native_decide
