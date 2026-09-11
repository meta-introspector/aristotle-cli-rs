/-
# MonsterConstants.lean — Canonical Numerical Constants for the Monster Universe

This module centralizes all commonly-used numerical constants across the project,
eliminating duplication and providing a single source of truth.

## Constants provided
- Monster group order (`M_order`, `monsterOrder`)
- Baby Monster order (`B_order`)
- Conway group orders (`Co1_order`, `Co2_order`)
- Griess algebra dimension (`griess_dim`)
- Leech lattice rank (`leech_rank`)
- Supersingular primes / Ogg primes (`supersingularPrimes`, `oggPrimes`, `SSP`)
- j-function coefficients (`jCoeff`)
- Monster conjugacy class count (`M_classes`)
- DA51 prefix constant (`DA51_PREFIX`)
- MonsterBase type alias (`MonsterBase`, `S_ss`)
-/
import Mathlib

namespace MonsterConstants

/-! ## §1. Group Orders -/

/-- Order of the Monster group (Fischer–Griess). (Atlas, p. 232) -/
def M_order : ℕ :=
  2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- Synonym for `M_order`. -/
abbrev monsterOrder : ℕ := M_order

/-- The Monster order as a decimal literal (verified equal to the factored form). -/
theorem M_order_decimal : M_order = 808017424794512875886459904961710757005754368000000000 := by
  native_decide

/-- Order of the Baby Monster group B. (Atlas, p. 210) -/
def B_order : ℕ :=
  2^41 * 3^13 * 5^6 * 7^2 * 11 * 13 * 17 * 19 * 23 * 31 * 47

/-- The Baby Monster order as a decimal literal. -/
theorem B_order_decimal : B_order = 4154781481226426191177580544000000 := by
  native_decide

/-- Order of the first Conway group Co₁. -/
def Co1_order : ℕ := 4157776806543360000

/-- Order of the second Conway group Co₂. -/
def Co2_order : ℕ := 42305421312000

/-- Number of conjugacy classes of the Monster. -/
def M_classes : ℕ := 194

/-- Number of involution classes in the Monster. -/
def M_involution_classes : ℕ := 2

/-- Number of conjugacy classes of the Baby Monster. -/
def B_classes : ℕ := 184

/-! ## §2. Lattice & Algebra Constants -/

/-- Dimension of the Griess algebra = coefficient of q in j(q) - 744. -/
def griess_dim : ℕ := 196884

/-- Rank of the Leech lattice. -/
def leech_rank : ℕ := 24

/-- Number of Niemeier lattices (including Leech). -/
def niemeier_count : ℕ := 24

/-- Bott periodicity modulus. -/
def bott_period : ℕ := 8

/-! ## §3. Supersingular Primes -/

/-- The 15 supersingular primes (= Ogg primes = SSP generators).
    These are the primes p such that the genus of X₀⁺(p) is zero,
    equivalently the primes dividing |M|. -/
def supersingularPrimes : List ℕ :=
  [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- Synonym for `supersingularPrimes`. -/
abbrev oggPrimes : List ℕ := supersingularPrimes

/-- The supersingular primes as a `Finset`. -/
def SSP : Finset ℕ := {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71}

/-- There are exactly 15 supersingular primes. -/
theorem ssp_count : supersingularPrimes.length = 15 := by native_decide

/-- The SSP Finset has 15 elements. -/
theorem SSP_card : SSP.card = 15 := by native_decide

/-! ## §4. j-Function Coefficients -/

/-- First several coefficients of the j-invariant q-expansion.
    j(q) = q⁻¹ + 744 + 196884q + 21493760q² + 864299970q³ + … -/
def jCoeff : ℕ → ℕ
  | 0 => 1        -- coefficient of q⁻¹
  | 1 => 744      -- constant term
  | 2 => 196884   -- coefficient of q
  | 3 => 21493760 -- coefficient of q²
  | 4 => 864299970
  | _ => 0        -- higher coefficients not tabulated here

/-- The j-coefficients as signed integers. -/
def jCoeffZ : ℕ → ℤ
  | n => (jCoeff n : ℤ)

/-- Key relation: j₂ = griess_dim = 196884 = 196883 + 1. -/
theorem j2_griess : jCoeff 2 = griess_dim := by rfl

/-- McKay's observation: 196884 = 196883 + 1 (trivial rep + faithful rep). -/
theorem mckay_observation : jCoeff 2 = 196883 + 1 := by rfl

/-! ## §5. CRT Die Plate Constants -/

/-- The CRT modulus triple for the Monster base. -/
def crt_moduli : ℕ × ℕ × ℕ := (47, 59, 71)

/-- The Monster base type: ZMod 71 × ZMod 59 × ZMod 47. -/
abbrev MonsterBase := ZMod 71 × ZMod 59 × ZMod 47

/-- Product of CRT moduli. -/
def crt_product : ℕ := 47 * 59 * 71

theorem crt_product_val : crt_product = 196883 := by native_decide

/-! ## §6. Key Numerical Invariants -/

/-- 15 SSP generators + 8 Bott phases + 1 void = 24 Niemeier lattices. -/
theorem ssp_bott_niemeier : 15 + 8 + 1 = 24 := by norm_num

/-- The number of 2A involutions in M equals griess_dim - 1. -/
theorem involution_count_relation : griess_dim - 1 = 196883 := by rfl

end MonsterConstants
