/-
# Moonshine Core — Unified j-function, VOA, and Monster Representations

## Prime Invariant: j(τ) = q⁻¹ + 744 + 196884q + 21493760q² + ...

Merged from MonsterMoonshine (j-coefficients, genus-0 primes, Hecke operators)
and MoonshineModule (VOA structure, McKay decompositions, Thompson series).
Both files share the same prime invariant: the j-function and its decomposition
into Monster irreducible representations.

## Sources
- Conway-Norton, "Monstrous Moonshine" (1979)
- Frenkel-Lepowsky-Meurman, "Vertex Operator Algebras and the Monster" (1988)
- Borcherds, "Monstrous moonshine and monstrous Lie superalgebras" (1992)
-/

import Mathlib
import RequestProject.Math.Monster.SupersingularPrimes
import RequestProject.MonsterConstants

open MonsterConstants

namespace MoonshineCore

/-! ## §1. j-function Coefficients -/

/-- Coefficient c(n) of qⁿ in j(τ) - 744 = q⁻¹ + Σ c(n)qⁿ. -/
def jCoeff : ℕ → ℕ
  | 0 => 1           -- q⁻¹
  | 1 => 196884
  | 2 => 21493760
  | 3 => 864299970
  | 4 => 20245856256
  | 5 => 333202640600
  | 6 => 4252023300096
  | 7 => 44656994071935
  | 8 => 401490886656000
  | 9 => 3176440229784420
  | 10 => 22567393309593600
  | _ => 0

/-- j-coefficients as a signed list (for contexts needing ℤ). -/
def jCoefficients : List ℤ := [1, 744, 196884, 21493760, 864299970]

theorem j_constant_term : jCoefficients[1]! = 744 := by native_decide
theorem j_first_coeff : jCoefficients[2]! = 196884 := by native_decide

/-- 744 = 3 × 248 = 3 × dim(E₈). -/
theorem j_constant_744 : (744 : ℕ) = 3 * 248 := by native_decide

/-! ## §2. Monster Irreducible Representations -/

/-- Dimensions of the smallest Monster irreps. -/
def monsterIrrepDim : ℕ → ℕ
  | 0 => 1           -- trivial χ₁
  | 1 => 196883      -- χ₂ (smallest faithful)
  | 2 => 21296876    -- χ₃
  | 3 => 842609326   -- χ₄
  | _ => 0

/-- As a list (for MonsterMoonshine compatibility). -/
def monsterIrrepDims : List ℕ := [1, 196883, 21296876, 842609326]

theorem monster_trivial_dim : monsterIrrepDims[0]! = 1 := by native_decide
theorem monster_min_nontrivial : monsterIrrepDims[1]! = 196883 := by native_decide

/-- The Monster has exactly 194 conjugacy classes. -/
def monster_num_classes : ℕ := 194

/-! ## §3. McKay's Observation and Decompositions -/

/-- McKay's observation: c(1) = dim(χ₁) + dim(χ₂) = 1 + 196883 = 196884. -/
theorem mckay_observation :
    jCoeff 1 = monsterIrrepDim 0 + monsterIrrepDim 1 := by native_decide

/-- McKay's observation (signed version). -/
theorem mckay_observation_decomp :
    jCoefficients[2]! = (monsterIrrepDims[0]! : ℤ) + monsterIrrepDims[1]! := by native_decide

/-- c(2) = dim(χ₁) + dim(χ₂) + dim(χ₃). -/
theorem j_coeff_2_decomposition :
    jCoeff 2 = monsterIrrepDim 0 + monsterIrrepDim 1 + monsterIrrepDim 2 := by native_decide

/-- c(3) = 2·dim(χ₁) + 2·dim(χ₂) + dim(χ₃) + dim(χ₄). -/
theorem j_coeff_3_decomposition :
    jCoeff 3 = 2 * monsterIrrepDim 0 + 2 * monsterIrrepDim 1 +
               monsterIrrepDim 2 + monsterIrrepDim 3 := by native_decide

/-- The q² coefficient (signed). -/
theorem j_q2_decomp :
    jCoefficients[3]! = (monsterIrrepDims[0]! : ℤ) + monsterIrrepDims[1]! + monsterIrrepDims[2]! := by
  native_decide

/-- c(3) - c(2) - c(1) = dim(χ₄). -/
theorem j_coeff_3_new_irrep :
    jCoeff 3 - jCoeff 2 - jCoeff 1 = monsterIrrepDim 3 := by native_decide

/-- Master consistency: all McKay decompositions hold simultaneously. -/
theorem mckay_consistency :
    jCoeff 1 = monsterIrrepDim 0 + monsterIrrepDim 1 ∧
    jCoeff 2 = monsterIrrepDim 0 + monsterIrrepDim 1 + monsterIrrepDim 2 ∧
    jCoeff 3 = 2 * monsterIrrepDim 0 + 2 * monsterIrrepDim 1 +
               monsterIrrepDim 2 + monsterIrrepDim 3 := by
  exact ⟨by native_decide, by native_decide, by native_decide⟩

/-! ## §4. Genus-0 Primes = Supersingular Primes -/

def genus0Primes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

theorem genus0_eq_supersingular : genus0Primes = supersingularPrimes := rfl
theorem genus0_all_prime : ∀ p ∈ genus0Primes, Nat.Prime p := by decide
theorem genus0_count : genus0Primes.length = 15 := by native_decide

/-! ## §5. Hecke Operators -/

def heckeIndexToPrime : Fin 15 → ℕ
  | ⟨0, _⟩ => 2  | ⟨1, _⟩ => 3  | ⟨2, _⟩ => 5  | ⟨3, _⟩ => 7  | ⟨4, _⟩ => 11
  | ⟨5, _⟩ => 13 | ⟨6, _⟩ => 17 | ⟨7, _⟩ => 19 | ⟨8, _⟩ => 23 | ⟨9, _⟩ => 29
  | ⟨10, _⟩ => 31 | ⟨11, _⟩ => 41 | ⟨12, _⟩ => 47 | ⟨13, _⟩ => 59 | ⟨14, _⟩ => 71

theorem hecke_all_prime : ∀ (i : Fin 15), Nat.Prime (heckeIndexToPrime i) := by
  intro i; fin_cases i <;> decide

/-! ## §6. p-adic Valuations -/

def monsterValuation : Fin 15 → ℕ
  | ⟨0, _⟩ => 46  | ⟨1, _⟩ => 20  | ⟨2, _⟩ => 9   | ⟨3, _⟩ => 6   | ⟨4, _⟩ => 2
  | ⟨5, _⟩ => 3   | ⟨6, _⟩ => 1   | ⟨7, _⟩ => 1   | ⟨8, _⟩ => 1   | ⟨9, _⟩ => 1
  | ⟨10, _⟩ => 1  | ⟨11, _⟩ => 1  | ⟨12, _⟩ => 1  | ⟨13, _⟩ => 1  | ⟨14, _⟩ => 1

theorem monster_valuation_sum :
    Finset.univ.sum monsterValuation = 95 := by native_decide

theorem monster_max_valuation :
    Finset.univ.sup' ⟨⟨0, by omega⟩, Finset.mem_univ _⟩ monsterValuation = 46 := by
  native_decide

/-! ## §7. The Moonshine Module V♮ -/

/-- Central charge of V♮. -/
def centralCharge : ℕ := 24

/-- Thompson series count. -/
def num_thompson_series : ℕ := 171

theorem thompson_fewer_than_classes :
    num_thompson_series < monster_num_classes := by native_decide

/-! ## §8. Thompson Traces (2A vs 2B) -/

def thompson_2A_coeff : ℕ := 4372
def thompson_2B_coeff : ℕ := 276

theorem traces_distinguish :
    thompson_2A_coeff ≠ thompson_2B_coeff := by native_decide

theorem trace_2A_split : thompson_2A_coeff = 1 + 4371 := by native_decide
theorem trace_2B_split : thompson_2B_coeff = 1 + 275 := by native_decide

/-! ## §9. The FLM Construction: V♮ from the Leech Lattice -/

def leech_short : ℕ := 196560
def sym2_dim : ℕ := 300

/-- 196884 = 196560 + 300 + 24 (FLM decomposition). -/
theorem FLM_decomposition :
    jCoeff 1 = leech_short + sym2_dim + leech_rank := by native_decide

theorem sym2_formula : sym2_dim = 24 * 25 / 2 := by native_decide
theorem leech_short_from_mod2 : leech_short = 2 * 98280 := by native_decide

/-! ## §10. j-Coefficient Growth -/

theorem growth_1_2 : jCoeff 2 / jCoeff 1 = 109 := by native_decide
theorem growth_2_3 : jCoeff 3 / jCoeff 2 = 40 := by native_decide
theorem growth_3_4 : jCoeff 4 / jCoeff 3 = 23 := by native_decide

theorem j_coeff_sum_3 :
    jCoeff 1 + jCoeff 2 + jCoeff 3 = 885990614 := by native_decide

theorem irrep_ratio : monsterIrrepDim 2 / monsterIrrepDim 1 = 108 := by native_decide

end MoonshineCore
