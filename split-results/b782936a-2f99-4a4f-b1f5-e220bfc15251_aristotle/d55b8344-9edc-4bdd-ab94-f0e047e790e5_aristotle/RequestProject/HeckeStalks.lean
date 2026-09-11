import Mathlib

/-!
# Hecke Stalks and Moonshine

The j-function's Fourier expansion begins:
  j(τ) = q⁻¹ + 744 + 196884q + 21493760q² + 864299970q³ + ...

McKay's observation: 196884 = 196883 + 1, where 196883 is the dimension
of the smallest faithful representation of the Monster.

The moonshine spectral page maps grid positions (i, j) in the primary
2-adic × 3-adic grid to j-function coefficients at index 2^i · 3^j.

## Key structures

- `jFunctionCoeffs`: First few j-function Fourier coefficients
- McKay's observation and j₂ decomposition as verified arithmetic
- `moonshineE2`: The spectral page E₂ mapping grid to coefficients
- `spectralDegeneration`: The genus-zero E₂ = E∞ condition
- Hecke action on the grid
-/

set_option maxHeartbeats 800000

open scoped BigOperators

/-- The first few Fourier coefficients of the j-function (starting at q⁻¹).
    j(τ) = q⁻¹ + 744 + 196884q + 21493760q² + 864299970q³ + ...
    Index 0 = coefficient of q⁻¹, index 1 = constant term, etc. -/
def jFunctionCoeffs : Fin 5 → ℕ
  | 0 => 1
  | 1 => 744
  | 2 => 196884
  | 3 => 21493760
  | 4 => 864299970

/-- McKay's observation: the q¹ coefficient of j is 196883 + 1,
    where 196883 is the dimension of the Monster's smallest faithful rep. -/
theorem mckay_observation : jFunctionCoeffs 2 = 196883 + 1 := by native_decide

/-- The q² coefficient decomposes as 21296876 + 196883 + 1. -/
theorem j2_decomposition : jFunctionCoeffs 3 = 21296876 + 196883 + 1 := by native_decide

/-- 196883 is the dimension of the smallest faithful Monster representation. -/
def monsterSmallestRepDim : ℕ := 196883

/-- 21296876 is the dimension of the second-smallest faithful Monster representation. -/
def monsterSecondRepDim : ℕ := 21296876

/-- The moonshine spectral page E₂:
    maps a grid position (i, j) to the j-function coefficient at index 2^i · 3^j.
    For positions outside our known range, returns 0. -/
noncomputable def moonshineE2 (i j : ℕ) : ℕ :=
  if h : 2^i * 3^j < 5 then
    jFunctionCoeffs ⟨2^i * 3^j, h⟩
  else 0

/-- The E₂ = E∞ degeneration condition (genus-zero property):
    the spectral sequence collapses at E₂. -/
def spectralDegeneration (E2 Einf : ℕ → ℕ → ℕ) : Prop :=
  ∀ i j, E2 i j = Einf i j

/-- Borcherds product: enumerate terms over grid cells. -/
def borcherdsTermCount (gridSize : ℕ) : ℕ := gridSize

/-- The origin cell of the primary grid. -/
def gridOrigin : Fin 46 × Fin 20 := (⟨0, by omega⟩, ⟨0, by omega⟩)

/-- Successor cell in the primary grid (with wraparound). -/
def gridSucc (c : Fin 46 × Fin 20) : Fin 46 × Fin 20 :=
  let i' := (c.1.val + 1) % 46
  let j' := if c.1.val + 1 ≥ 46 then (c.2.val + 1) % 20 else c.2.val
  (⟨i', Nat.mod_lt _ (by omega)⟩,
   ⟨j', by simp only [j']; split <;> omega⟩)

/-- Hecke index at grid position (i, j): the product 2^i · 3^j. -/
def heckeIndex (i : Fin 46) (j : Fin 20) : ℕ := 2^i.val * 3^j.val

/-- The Hecke index at the origin is 1. -/
theorem heckeIndex_origin : heckeIndex ⟨0, by omega⟩ ⟨0, by omega⟩ = 1 := by
  simp [heckeIndex]

/-- The Hecke index at (1, 0) is 2. -/
theorem heckeIndex_one_zero : heckeIndex ⟨1, by omega⟩ ⟨0, by omega⟩ = 2 := by
  simp [heckeIndex]

/-- The Hecke index at (0, 1) is 3. -/
theorem heckeIndex_zero_one : heckeIndex ⟨0, by omega⟩ ⟨1, by omega⟩ = 3 := by
  simp [heckeIndex]

/-- The j-function coefficient at q⁰ (constant term) is 744. -/
theorem j_constant_term : jFunctionCoeffs 1 = 744 := by native_decide

/-- The j-function leading coefficient (q⁻¹ term) is 1. -/
theorem j_leading : jFunctionCoeffs 0 = 1 := by native_decide
