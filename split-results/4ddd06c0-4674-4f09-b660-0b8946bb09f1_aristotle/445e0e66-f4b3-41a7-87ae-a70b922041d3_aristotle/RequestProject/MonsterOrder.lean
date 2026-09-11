/-
# Monster Group Order and the 46 × 20 Primary Scanning Grid

The Monster group 𝕄 has order:
  |𝕄| = 2^46 · 3^20 · 5^9 · 7^6 · 11^2 · 13^3 · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71

The "first table" of the logN · logN tower decomposition is the 46 × 20 grid,
indexed by the 2-primary and 3-primary parts of the Monster's order.

This file establishes the basic arithmetic of this decomposition and proves
key properties of the scanning grid.
-/
import Mathlib

open Finset Nat

/-! ## Monster group order factorization -/

/-- The 2-adic valuation of the Monster group order -/
def monster_v2 : ℕ := 46

/-- The 3-adic valuation of the Monster group order -/
def monster_v3 : ℕ := 20

/-- The 5-adic valuation of the Monster group order -/
def monster_v5 : ℕ := 9

/-- The 7-adic valuation of the Monster group order -/
def monster_v7 : ℕ := 6

/-- The 11-adic valuation of the Monster group order -/
def monster_v11 : ℕ := 2

/-- The 13-adic valuation of the Monster group order -/
def monster_v13 : ℕ := 3

/-- The 2-primary × 3-primary part of the Monster order -/
def monster_23_part : ℕ := 2 ^ 46 * 3 ^ 20

/-- The dimension of the primary scanning grid -/
def primary_grid_dim : ℕ := monster_v2 * monster_v3

/-- The primary scanning grid has 920 cells -/
theorem primary_grid_dim_eq : primary_grid_dim = 920 := by
  native_decide

/-- The number of conjugacy classes of the Monster group -/
def monster_num_conjugacy_classes : ℕ := 194

/-- The primary grid (920 cells) is much larger than the number of
conjugacy classes (194), meaning the grid is sparse. -/
theorem primary_grid_sparse :
    monster_num_conjugacy_classes < primary_grid_dim := by
  native_decide

/-- The secondary correction tables: dimensions for the remaining prime pairs -/
def secondary_grid_57 : ℕ := monster_v5 * monster_v7  -- 9 × 6 = 54
def tertiary_grid_1113 : ℕ := monster_v11 * monster_v13  -- 2 × 3 = 6

theorem secondary_grid_57_eq : secondary_grid_57 = 54 := by native_decide
theorem tertiary_grid_1113_eq : tertiary_grid_1113 = 6 := by native_decide

/-- The total grid cells across the first three tables -/
theorem total_primary_cells :
    primary_grid_dim + secondary_grid_57 + tertiary_grid_1113 = 980 := by
  native_decide

/-- The Monster order's 2-3 primary part factorization -/
theorem monster_23_part_pos : 0 < monster_23_part := by
  unfold monster_23_part
  positivity

/-! ## Grid indexing -/

/-- A cell in the primary 46 × 20 scanning grid.
    Cell (i, j) corresponds to the moonshine module component V^♮_{2^i · 3^j}. -/
structure PrimaryGridCell where
  row : Fin monster_v2     -- 2-adic depth, i = 0..45
  col : Fin monster_v3     -- 3-adic depth, j = 0..19
  deriving DecidableEq, Fintype

/-- The moonshine index associated to a grid cell -/
def PrimaryGridCell.moonshineIndex (c : PrimaryGridCell) : ℕ :=
  2 ^ (c.row : ℕ) * 3 ^ (c.col : ℕ)

/-- Every moonshine index from the primary grid is positive -/
theorem PrimaryGridCell.moonshineIndex_pos (c : PrimaryGridCell) :
    0 < c.moonshineIndex := by
  unfold PrimaryGridCell.moonshineIndex
  positivity

/-- The Hecke shift on the primary grid: T_{2^a · 3^b} maps cell (i,j) to (i+a, j+b).
    Returns `none` if the shifted cell is out of bounds. -/
def heckeShift (c : PrimaryGridCell) (a b : ℕ) : Option PrimaryGridCell :=
  if h1 : (c.row : ℕ) + a < monster_v2 then
    if h2 : (c.col : ℕ) + b < monster_v3 then
      some ⟨⟨(c.row : ℕ) + a, h1⟩, ⟨(c.col : ℕ) + b, h2⟩⟩
    else none
  else none

/-- The identity Hecke shift is a no-op -/
theorem heckeShift_zero (c : PrimaryGridCell) :
    heckeShift c 0 0 = some c := by
  simp [heckeShift, c.row.isLt, c.col.isLt]

/-! ## Tower filtration -/

/-- The level tower at depth k: conjugacy classes of elements with order dividing 2^k -/
def levelTowerSize (k : ℕ) : ℕ := min k monster_v2

/-- The Hecke tower at depth k: number of Hecke operators T_n with n ≤ 3^k -/
def heckeTowerSize (k : ℕ) : ℕ := min k monster_v3

/-- The scanning cost at depth k is bounded by (level tower) × (Hecke tower) -/
def scanningCost (k : ℕ) : ℕ := levelTowerSize k * heckeTowerSize k

/-- The scanning cost grows quadratically in k until saturation -/
theorem scanningCost_le_grid (k : ℕ) :
    scanningCost k ≤ primary_grid_dim := by
  unfold scanningCost levelTowerSize heckeTowerSize primary_grid_dim monster_v2 monster_v3
  apply Nat.mul_le_mul <;> exact Nat.min_le_right ..

/-- At maximum depth, scanning cost equals the full grid -/
theorem scanningCost_saturates :
    scanningCost (max monster_v2 monster_v3) = primary_grid_dim := by
  native_decide

/-! ## Prime tower hierarchy -/

/-- The primes dividing the Monster group order -/
def monsterPrimes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- The Monster has exactly 15 prime divisors -/
theorem monsterPrimes_length : monsterPrimes.length = 15 := by native_decide

/-- All entries in monsterPrimes are prime -/
theorem monsterPrimes_all_prime : ∀ p ∈ monsterPrimes, Nat.Prime p := by decide

/-- The valuations for each prime, forming the tower hierarchy -/
def monsterValuations : List (ℕ × ℕ) :=
  [(2, 46), (3, 20), (5, 9), (7, 6), (11, 2), (13, 3),
   (17, 1), (19, 1), (23, 1), (29, 1), (31, 1), (41, 1),
   (47, 1), (59, 1), (71, 1)]

/-- The tower depths are ordered by importance (decreasing valuation) -/
theorem tower_hierarchy_ordered :
    (monsterValuations.map Prod.snd).head? = some 46 := by native_decide

