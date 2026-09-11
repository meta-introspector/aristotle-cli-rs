/-
# Monster Group Order and Grid Structure

Formalization of the Monster group's order decomposition into grids
indexed by supersingular primes (SSP). The Monster's order factors as:

  |M| = 2^46 · 3^20 · 5^9 · 7^6 · 11^2 · 13^3 · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71

The SSP primes are exactly the prime divisors of |M|.
The primary grid (2 × 3 exponents) has 46 × 20 = 920 cells,
the secondary grid (5 × 7) has 9 × 6 = 54, and the tertiary grid (11 × 13)
has 2 × 3 = 6, totaling 980 cells.
-/
import Mathlib

/-! ## SSP primes and Monster exponents -/

/-- The 15 supersingular primes, i.e. the primes dividing |Monster|. -/
def sspPrimes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- Exponents of the SSP primes in the Monster order. -/
def monsterExponents : List ℕ := [46, 20, 9, 6, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1]

theorem sspPrimes_length : sspPrimes.length = 15 := by native_decide

theorem monsterExponents_length : monsterExponents.length = 15 := by native_decide

/-- All SSP primes are indeed prime. -/
theorem sspPrimes_all_prime : ∀ p ∈ sspPrimes, Nat.Prime p := by decide

/-! ## Grid dimensions -/

/-- The 2-adic valuation of |M|. -/
def monster_v2 : ℕ := 46

/-- The 3-adic valuation of |M|. -/
def monster_v3 : ℕ := 20

/-- The 5-adic valuation of |M|. -/
def monster_v5 : ℕ := 9

/-- The 7-adic valuation of |M|. -/
def monster_v7 : ℕ := 6

/-- The 11-adic valuation of |M|. -/
def monster_v11 : ℕ := 2

/-- The 13-adic valuation of |M|. -/
def monster_v13 : ℕ := 3

/-- Dimension of the primary grid: 46 × 20. -/
def primary_grid_dim : ℕ := monster_v2 * monster_v3

/-- Dimension of the secondary grid: 9 × 6. -/
def secondary_grid_dim : ℕ := monster_v5 * monster_v7

/-- Dimension of the tertiary grid: 2 × 3. -/
def tertiary_grid_dim : ℕ := monster_v11 * monster_v13

/-- Total grid dimension: 920 + 54 + 6 = 980. -/
def total_grid_dim : ℕ := primary_grid_dim + secondary_grid_dim + tertiary_grid_dim

theorem primary_grid_dim_eq : primary_grid_dim = 920 := by native_decide

theorem secondary_grid_dim_eq : secondary_grid_dim = 54 := by native_decide

theorem tertiary_grid_dim_eq : tertiary_grid_dim = 6 := by native_decide

theorem total_grid_dim_eq : total_grid_dim = 980 := by native_decide

/-! ## Primary Grid Cell -/

/-- A cell in the primary (2,3)-grid of the Monster. -/
structure PrimaryGridCell where
  row : Fin monster_v2   -- 2-adic depth 0..45
  col : Fin monster_v3   -- 3-adic depth 0..19
  deriving DecidableEq, Repr

instance : Fintype PrimaryGridCell :=
  Fintype.ofEquiv (Fin monster_v2 × Fin monster_v3)
    { toFun := fun ⟨r, c⟩ => ⟨r, c⟩
      invFun := fun ⟨r, c⟩ => ⟨r, c⟩
      left_inv := fun ⟨_, _⟩ => rfl
      right_inv := fun ⟨_, _⟩ => rfl }

theorem card_primaryGridCell :
    Fintype.card PrimaryGridCell = primary_grid_dim := by
  simp only [Fintype.card, primary_grid_dim, monster_v2, monster_v3]
  native_decide

/-! ## Hecke shifts on the grid -/

/-- The Hecke shift T_{2^a · 3^b} translates a grid cell by (a, b).
    Returns `none` if the shift goes out of bounds. -/
def heckeShift (cell : PrimaryGridCell) (a b : ℕ) : Option PrimaryGridCell :=
  let newRow := cell.row.val + a
  let newCol := cell.col.val + b
  if hr : newRow < monster_v2 then
    if hc : newCol < monster_v3 then
      some ⟨⟨newRow, hr⟩, ⟨newCol, hc⟩⟩
    else none
  else none

/-- Shifting by (0,0) is the identity. -/
theorem heckeShift_zero (cell : PrimaryGridCell) :
    heckeShift cell 0 0 = some cell := by
  simp [heckeShift]

/-! ## Scanning cost -/

/-- The scanning cost at depth k: min(k+1, primary_grid_dim). -/
def scanningCost (k : ℕ) : ℕ := min (k + 1) primary_grid_dim

theorem scanningCost_le_grid (k : ℕ) :
    scanningCost k ≤ primary_grid_dim := by
  simp [scanningCost]

theorem scanningCost_mono {k₁ k₂ : ℕ} (h : k₁ ≤ k₂) :
    scanningCost k₁ ≤ scanningCost k₂ := by
  simp [scanningCost]
  omega

/-! ## Monster order as a product -/

/-- The order of the Monster group. -/
def monsterOrder : ℕ :=
  2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- The Monster order is positive. -/
theorem monsterOrder_pos : 0 < monsterOrder := by
  unfold monsterOrder; positivity
