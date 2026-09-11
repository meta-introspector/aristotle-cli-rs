import Mathlib

namespace MonsterArithmeticNS

/-!
# Monster Group Order Arithmetic

Formalization of the number-theoretic structure of the Monster group's order,
including its prime factorization, divisor count, the "log-Monster space" exponent
lattice, the 987-point first cell, and the container cube construction.
## The Monster Order
The Monster group M has order:
  |M| = 2^46 · 3^20 · 5^9 · 7^6 · 11^2 · 13^3 · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71
       = 808017424794512875886459904961710757005754368000000000
## Log-Monster Space
The "log-Monster space" is the 15-dimensional exponent lattice:
  (a₂, a₃, a₅, a₇, a₁₁, a₁₃, a₁₇, a₁₉, a₂₃, a₂₉, a₃₁, a₄₁, a₄₇, a₅₉, a₇₁)
where each coordinate ranges from 0 to the corresponding exponent.
The Monster's exponent vector is (46, 20, 9, 6, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1).
## First Cell
The "first cell" is the (2,3)-bulk: the 2D face spanned by the first two coordinates,
with 47 × 21 = 987 lattice points. This is the Hecke-scannable base of the full lattice.
## Container Cube
The container cube uses 6 SSP primes {47, 23, 11, 7, 3, 2} as dimension sizes:
  47 × 23 × 11 × 7 × 3 × 2 = 499,422
## Divisor Telescope
The total number of divisors of |M| is:
  τ(|M|) = 47 · 21 · 10 · 7 · 3 · 4 · 2⁹ = 424,488,960
This decomposes via a cascade through the prime towers.
-/
open scoped BigOperators Nat
/-! ## Definitions -/
/-- The 15 supersingular primes (SSP) — primes dividing the order of the Monster group. -/
def sspPrimes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]
/-- The exponents of each SSP prime in the Monster group's order. -/
def monsterExponents : List ℕ := [46, 20, 9, 6, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1]
/-- The order of the Monster group. -/
def monsterOrder : ℕ :=
  2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71
/-- The number of divisors of the Monster group's order.
    Equal to the product of (exponent + 1) over all prime factors. -/
def monsterDivisorCount : ℕ :=
  (46+1) * (20+1) * (9+1) * (6+1) * (2+1) * (3+1) * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2
/-- The first cell of log-Monster space: the (2,3)-bulk lattice.
    Has (46+1) × (20+1) = 987 points. -/
def firstCellSize : ℕ := 47 * 21
/-- The container cube: product of 6 SSP primes used as dimension sizes. -/
def containerCube : ℕ := 47 * 23 * 11 * 7 * 3 * 2
/-- The 9 "light" SSP primes with exponent 1. -/
def lightPrimes : List ℕ := [17, 19, 23, 29, 31, 41, 47, 59, 71]
/-- The product of all SSP primes. -/
def sspProduct : ℕ := sspPrimes.prod
/-- The sum of all Monster exponents. -/
def exponentSum : ℕ := monsterExponents.sum
/-! ## Monster Order Verification -/
/-- The Monster order equals 808017424794512875886459904961710757005754368000000000. -/
theorem monsterOrder_eq :
    monsterOrder = 808017424794512875886459904961710757005754368000000000 := by
  native_decide
/-- There are exactly 15 supersingular primes. -/
theorem sspPrimes_length : sspPrimes.length = 15 := by decide
/-- There are exactly 15 exponents (one per SSP prime). -/
theorem monsterExponents_length : monsterExponents.length = 15 := by decide
/-- There are 9 light primes (exponent 1). -/
theorem lightPrimes_length : lightPrimes.length = 9 := by decide
/-! ## Divisor Count -/
/-- The divisor count equals 424488960. -/
theorem monsterDivisorCount_eq : monsterDivisorCount = 424488960 := by native_decide
/-- The divisor count factors as 47 · 21 · 10 · 7 · 3 · 4 · 2⁹. -/
theorem monsterDivisorCount_factored :
    monsterDivisorCount = 47 * 21 * 10 * 7 * 3 * 4 * 2^9 := by native_decide
/-! ## First Cell (2,3)-Bulk -/
/-- The first cell has 987 points. -/
theorem firstCellSize_eq : firstCellSize = 987 := by native_decide
/-- 987 is the product of the first two (exponent + 1) values. -/
theorem firstCellSize_from_exponents :
    firstCellSize = (monsterExponents[0]! + 1) * (monsterExponents[1]! + 1) := by native_decide
/-! ## Container Cube -/
/-- The container cube has 499422 cells. -/
theorem containerCube_eq : containerCube = 499422 := by native_decide
/-- The container cube dimensions are all SSP primes. -/
theorem containerCube_dims_are_ssp :
    ∀ d ∈ ([47, 23, 11, 7, 3, 2] : List ℕ), d ∈ sspPrimes := by decide
/-- All container cube dimensions are prime. -/
theorem containerCube_dims_prime :
    ∀ d ∈ ([47, 23, 11, 7, 3, 2] : List ℕ), Nat.Prime d := by decide
/-! ## Divisor Telescope -/
/-- The divisor telescope: 424488960 = 987 × 10 × 7 × 3 × 4 × 512 -/
theorem divisor_telescope :
    monsterDivisorCount = firstCellSize * 10 * 7 * 3 * 4 * 512 := by native_decide
/-- The light primes contribute 2⁹ = 512 to the divisor count. -/
theorem light_prime_contribution : 2^(lightPrimes.length) = 512 := by native_decide
/-- Telescope level 1: full / 47 = 9031680 -/
theorem telescope_level_1 : monsterDivisorCount / 47 = 9031680 := by native_decide
/-- Telescope level 2: 9031680 / 21 = 430080 -/
theorem telescope_level_2 : 9031680 / 21 = 430080 := by native_decide
/-- Telescope level 3: 430080 / 10 = 43008 -/
theorem telescope_level_3 : 430080 / 10 = 43008 := by native_decide
/-- Telescope level 4: 43008 / 7 = 6144 -/
theorem telescope_level_4 : 43008 / 7 = 6144 := by native_decide
/-- Telescope level 5: 6144 / 3 = 2048 -/
theorem telescope_level_5 : 6144 / 3 = 2048 := by native_decide
/-- Telescope level 6: 2048 / 4 = 512 -/
theorem telescope_level_6 : 2048 / 4 = 512 := by native_decide
/-- Telescope level 7: 512 = 2⁹ (the 9 light primes) -/
theorem telescope_level_7 : (512 : ℕ) = 2^9 := by native_decide
/-! ## The 7-adic loop closure: 6 = 2 × 3 -/
/-- The exponent of 7 in the Monster order is 6, and 6 = 2 × 3,
    looping back to the seed primes. -/
theorem seven_exponent_is_seed : (monsterExponents[3]! : ℕ) = 2 * 3 := by native_decide
/-- The seed product 2 × 3 = 6, the fundamental orthogonal. -/
theorem seed_product : (2 : ℕ) * 3 = 6 := by decide
/-! ## SSP Prime Properties -/
/-- All 15 SSP primes are indeed prime. -/
theorem ssp_all_prime : ∀ p ∈ sspPrimes, Nat.Prime p := by decide
/-- The product of all SSP primes. -/
theorem sspProduct_eq :
    sspProduct = 2 * 3 * 5 * 7 * 11 * 13 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71 := by
  native_decide
/-- The sum of all Monster exponents is 95. -/
theorem exponentSum_val : exponentSum = 95 := by native_decide
/-! ## Structural Relationships -/
/-- The Monster order is divisible by 6 (the seed). -/
theorem monsterOrder_div_six : 6 ∣ monsterOrder := by decide
/-- The first cell size 987 = 3 × 7 × 47. -/
theorem firstCell_factorization : firstCellSize = 3 * 7 * 47 := by native_decide
/-- The container cube contains the first cell: 499422 > 987. -/
theorem cube_contains_firstCell : containerCube > firstCellSize := by native_decide
/-- Container cube / first cell = 506 = 2 × 11 × 23. -/
theorem cube_over_firstCell : containerCube / firstCellSize = 506 := by native_decide
/-- 506 = 2 × 11 × 23 — three SSP primes. -/
theorem cube_over_firstCell_factors : (506 : ℕ) = 2 * 11 * 23 := by native_decide
/-- The 6 "extra" dimensions are themselves SSP primes. -/
theorem extra_dims_are_ssp :
    ∀ d ∈ ([2, 11, 23] : List ℕ), d ∈ sspPrimes := by decide

end MonsterArithmeticNS
