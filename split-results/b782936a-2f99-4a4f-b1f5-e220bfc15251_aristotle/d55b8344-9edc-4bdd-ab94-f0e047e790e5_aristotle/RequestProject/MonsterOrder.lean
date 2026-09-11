import Mathlib

/-!
# Monster Group Order Arithmetic

The Monster group order is:
  |M| = 2^46 · 3^20 · 5^9 · 7^6 · 11^2 · 13^3 · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71

The 15 supersingular primes (SSP) are exactly the primes dividing |M|.

## Grid Decomposition

The primary grid is the 2-adic × 3-adic valuation space:
  {0, ..., 46} × {0, ..., 20} with 47 × 21 = 987 points,
  but we use the 46 × 20 = 920 "interior" cells for dynamics.

Secondary grid: 5-adic × 7-adic = {0,...,9} × {0,...,6} = 10 × 7 = 70, interior 9 × 6 = 54
Tertiary grid: 11-adic × 13-adic = {0,...,2} × {0,...,3} = 3 × 4 = 12, interior 2 × 3 = 6
-/

open scoped BigOperators Nat

set_option maxHeartbeats 800000

/-- The 15 supersingular primes in ascending order. -/
def sspPrimes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- The exponents of each SSP in the Monster group order. -/
def sspExponents : List ℕ := [46, 20, 9, 6, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1]

theorem sspPrimes_length : sspPrimes.length = 15 := by native_decide

theorem sspExponents_length : sspExponents.length = 15 := by native_decide

theorem sspPrimes_all_prime : ∀ p ∈ sspPrimes, Nat.Prime p := by decide

/-- The primary grid cell: a position in the 2-adic × 3-adic valuation space. -/
structure PrimaryGridCell where
  i : Fin 46  -- 2-adic coordinate (1..46)
  j : Fin 20  -- 3-adic coordinate (1..20)
  deriving DecidableEq, Repr

instance : Fintype PrimaryGridCell :=
  Fintype.ofEquiv (Fin 46 × Fin 20)
    { toFun := fun ⟨a, b⟩ => ⟨a, b⟩
      invFun := fun ⟨a, b⟩ => ⟨a, b⟩
      left_inv := fun ⟨_, _⟩ => rfl
      right_inv := fun ⟨_, _⟩ => rfl }

theorem primaryGrid_card : Fintype.card PrimaryGridCell = 920 := by
  native_decide

/-- Grid dimensions for the three-level decomposition. -/
def primaryGridSize : ℕ := 46 * 20
def secondaryGridSize : ℕ := 9 * 6
def tertiaryGridSize : ℕ := 2 * 3

theorem primary_eq : primaryGridSize = 920 := by native_decide
theorem secondary_eq : secondaryGridSize = 54 := by native_decide
theorem tertiary_eq : tertiaryGridSize = 6 := by native_decide
theorem total_grid : primaryGridSize + secondaryGridSize + tertiaryGridSize = 980 := by native_decide

/-- A Hecke shift moves a cell by (di, dj) with boundary clamping. -/
def heckeShift (c : PrimaryGridCell) (di dj : ℤ) : PrimaryGridCell where
  i := ⟨(((c.i : ℤ) + di) % 46).toNat % 46,
        Nat.mod_lt _ (by omega)⟩
  j := ⟨(((c.j : ℤ) + dj) % 20).toNat % 20,
        Nat.mod_lt _ (by omega)⟩

/-- The Monster group order is positive. -/
theorem monsterOrder_pos : (0 : ℕ) < 2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71 := by
  positivity

/-- The number of supersingular primes. -/
theorem ssp_count : sspPrimes.length = 15 := sspPrimes_length
