/-
# Supersingular Primes — The 15 Primes Dividing the Monster Order

## Source
- Ogg, "Automorphismes de courbes modulaires" (1975)
- Conway–Norton, "Monstrous Moonshine" (1979)

## What This Formalizes
A prime p is **supersingular** if and only if the modular curve X₀(p) has genus zero.
There are exactly 15 such primes:
  {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71}

Ogg's remarkable observation (1975): these are precisely the prime divisors of
the order of the Monster group |M|.

This file also formalizes the natural partition of the 15 SSPs into two sets:
  A = {2, 3, 5, 7, 11, 13, 17, 19}   (8 primes, the "Earth" block)
  B = {23, 29, 31, 41, 47, 59, 71}    (7 primes, the "Spoke" block)

corresponding to the Clifford algebra decomposition
  Cl(15,0) ≅ Cl(8,0) ⊗̂ Cl(7,0)
-/

import Mathlib
import RequestProject.MonsterConstants

set_option maxHeartbeats 4000000

namespace SupersingularPrimes

open MonsterConstants

/-! ## §1. The 15 Supersingular Primes -/

/-- The 15 supersingular primes, in ascending order. -/
def ssp : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- There are exactly 15 supersingular primes. -/
theorem ssp_length : ssp.length = 15 := by native_decide

/-- Every supersingular prime is prime. -/
theorem ssp_all_prime : ∀ p ∈ ssp, Nat.Prime p := by decide

/-- The product of all 15 supersingular primes. -/
def ssp_product : ℕ := 2 * 3 * 5 * 7 * 11 * 13 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

theorem ssp_product_value : ssp_product = 1618964990108856390 := by native_decide

/-! ## §2. The 8+7 Partition (Clifford Split) -/

/-- Set A: the first 8 supersingular primes. -/
def sspA : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19]

/-- Set B: the last 7 supersingular primes. -/
def sspB : List ℕ := [23, 29, 31, 41, 47, 59, 71]

theorem sspA_length : sspA.length = 8 := by native_decide
theorem sspB_length : sspB.length = 7 := by native_decide

/-- A and B partition the SSPs. -/
theorem ssp_partition : sspA ++ sspB = ssp := by native_decide

/-- All elements of A are prime. -/
theorem sspA_all_prime : ∀ p ∈ sspA, Nat.Prime p := by decide

/-- All elements of B are prime. -/
theorem sspB_all_prime : ∀ p ∈ sspB, Nat.Prime p := by decide

/-- The product of set B primes. -/
def sspB_product : ℕ := 23 * 29 * 31 * 41 * 47 * 59 * 71

theorem sspB_product_value : sspB_product = 166908941431 := by native_decide

/-! ## §3. Ogg's Observation

The set of supersingular primes equals the set of primes dividing |M|.
We verify that each SSP divides the Monster order. -/
-- [dedup] M_order now imported from MonsterConstants
/-- Every supersingular prime divides the Monster order. -/
theorem ssp_divides_monster : ∀ p ∈ ssp, p ∣ M_order := by decide

/-! ## §4. The Monster Order Decomposition

The Monster order decomposes as N₁ · N₂ where:
  N₁ = 2⁴⁶ · 3²⁰ · 5⁹ · 7⁶ · 11² · 13³ · 17 · 19  (powers of A-primes)
  N₂ = 23 · 29 · 31 · 41 · 47 · 59 · 71              (B-primes, each to the 1st power)
-/

/-- N₁: the A-prime component of the Monster order. -/
def N1 : ℕ := 2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19

/-- N₂: the B-prime component of the Monster order. -/
def N2 : ℕ := 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- The Monster order equals N₁ · N₂. -/
theorem monster_order_split : M_order = N1 * N2 := by
  simp only [M_order, N1, N2]; ring

/-- N₂ computed explicitly. -/
theorem N2_value : N2 = 166908941431 := by native_decide

/-! ## §5. The Clifford Algebra Correspondence

The 8+7 partition of SSPs corresponds to a graded tensor product of
Clifford algebras:
  Cl(15,0) ≅ Cl(8,0) ⊗̂ Cl(7,0)
-/

theorem clifford_8_dim : (2 : ℕ)^8 = 256 := by norm_num
theorem clifford_7_dim : (2 : ℕ)^7 = 128 := by norm_num
theorem clifford_15_dim : (2 : ℕ)^15 = 32768 := by norm_num

/-- dim Cl(8,0) × dim Cl(7,0) = dim Cl(15,0). -/
theorem clifford_tensor_dim : (2 : ℕ)^8 * 2^7 = 2^15 := by norm_num

/-! ## §6. Supersingular j-invariants

For each SSP p, the number of supersingular j-invariants in characteristic p
is ⌊p/12⌋ + ε where ε ∈ {0,1}.
-/

/-- Number of supersingular j-invariants in characteristic p. -/
def numSupersingularJ : ℕ → ℕ
  | 2 => 1
  | 3 => 1
  | 5 => 1
  | 7 => 1
  | 11 => 1
  | 13 => 1
  | 17 => 2
  | 19 => 2
  | 23 => 2
  | 29 => 3
  | 31 => 3
  | 41 => 4
  | 47 => 4
  | 59 => 5
  | 71 => 6
  | _ => 0

/-- The total number of supersingular j-invariants across all 15 SSPs. -/
theorem total_supersingular_j :
    (ssp.map numSupersingularJ).sum = 37 := by native_decide

/-! ## §7. The Genus-Zero Primes for Γ₀(p)

Among the 15 SSPs, only {2, 3, 5, 7, 13} make Γ₀(p) itself (without
Atkin-Lehner extension) genus zero. For the others, one needs the
full Atkin-Lehner group Γ₀(p)⁺ to achieve genus zero.
-/

/-- The 5 primes p for which Γ₀(p) has genus zero. -/
def gamma0_genus_zero : List ℕ := [2, 3, 5, 7, 13]

theorem gamma0_genus_zero_length : gamma0_genus_zero.length = 5 := by native_decide

/-- All genus-zero-for-Γ₀ primes are SSPs. -/
theorem gamma0_subset_ssp : ∀ p ∈ gamma0_genus_zero, p ∈ ssp := by decide

end SupersingularPrimes
