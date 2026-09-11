/-
# MoonshineIrrepGrading — Coloring the 194 Monster irreps by Ogg-prime grades

## What this is

`MoonshineSheafStalk` built stalks of the moonshine sheaf and split nodes into the
**Monster regime** (Ogg primes 47, 59, 71, whose product is 196883) and the
**umbral regime** (the twelve smaller Ogg primes).  This file *colors the 194
irreducible representations of the Monster* by exactly those gradings.

The raw data is the prime factorization of each of the 194 Monster irreducible
character degrees over the 15 supersingular (Ogg) primes
`2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71`
(OEIS A001379, in the ATLAS ordering where complex-conjugate pairs are adjacent).
Every Monster character degree divides `|M|`, hence factors *completely* over these
15 primes — so the p-adic valuation table reconstructs the degree exactly.

`padicTable[i]` is the length-15 vector of valuations `(v₂, v₃, …, v₇₁)` of the
`i`-th irrep's degree, and `rowExpSumTable[i] = Ω(dim)` is the total number of
prime factors with multiplicity (the sum of the valuation row).

## The three gradings ("colors")

For each irrep `i` we record three colorings:

1. **Big grade** — `gradeBig i = dim i % 196883`, the residue modulo
   `71·59·47 = 196883`.  This is the CRT class of the degree on the Monster branch.

2. **Ogg-prime grade** — `gradeOgg i j = dim i % (j-th Ogg prime)`, the residue
   modulo each of the 15 supersingular primes.  By construction `gradeOgg i j = 0`
   iff the `j`-th prime divides the degree, i.e. iff `padicVal i j ≥ 1`.

3. **p-adic grade** — the valuation vector `padicTable[i]` itself, the per-prime
   exponent coloring.

`gradeOf i` bundles all three into an `IrrepGrade` record.

## Key coherence facts

* `padicRowSum_eq_table` — the valuation rows sum to the recorded `Ω` values
  (internal consistency of the data).
* `irrepDim_dvd_monsterOrder` — every degree divides `|M|`.
* `gradeOgg_zero_iff` — divisibility by an Ogg prime is detected by its valuation.
* `gradeBig_zero_iff_monsterPrimes` — divisibility by 196883 happens exactly when
  all three Monster primes 47, 59, 71 divide the degree.
* `card_monsterColored` — exactly 112 of the 194 irreps are divisible by 196883.
-/

import Mathlib
import RequestProject.Math.Monster.Slice.SupersingularPrimes

namespace RequestProject.Math.Bridge.MoonshineIrrepGrading

/-! ## §1. The 15 Ogg (supersingular) primes -/

/-- The 15 supersingular primes, in increasing order: the prime divisors of `|M|`. -/
def oggPrimes : Array ℕ := #[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- The `j`-th Ogg prime (out-of-range defaults to `1`, the multiplicative unit). -/
def oggPrime (j : ℕ) : ℕ := oggPrimes.getD j 1

theorem oggPrimes_size : oggPrimes.size = 15 := by native_decide

/-- Link to the project's canonical supersingular-prime table. -/
theorem oggPrime_eq_supersingular (j : Fin 15) :
    oggPrime j.val = MonsterSlice.supersingularPrime j := by
  fin_cases j <;> rfl

/-- The three Monster-branch primes have product 196883. -/
theorem monster_primes_prod : oggPrime 12 * oggPrime 13 * oggPrime 14 = 196883 := by
  native_decide

/-! ## §2. The p-adic valuation table (OEIS A001379, ATLAS order) -/

/-- For each of the 194 Monster irreps, the length-15 vector of p-adic valuations
    of its degree over the Ogg primes `(v₂, v₃, v₅, …, v₅₉, v₇₁)`. -/
def padicTable : Array (Array ℕ) := #[
    #[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    #[0,0,0,0,0,0,0,0,0,0,0,0,1,1,1],
    #[2,0,0,0,0,0,0,0,0,0,1,1,0,1,1],
    #[1,0,0,0,0,2,0,0,0,1,1,0,1,1,0],
    #[2,0,0,1,1,0,0,0,1,1,1,1,0,0,1],
    #[0,0,0,0,0,2,0,0,1,1,0,1,0,1,1],
    #[1,1,0,0,1,0,0,1,0,1,0,1,1,1,1],
    #[1,1,0,1,1,2,0,1,1,0,0,1,1,1,0],
    #[0,6,0,1,0,2,1,1,0,0,1,0,0,1,1],
    #[0,0,2,4,0,0,1,0,0,1,1,1,1,0,1],
    #[0,3,0,1,1,0,1,0,1,1,0,1,1,1,1],
    #[0,1,0,0,1,2,1,0,1,1,1,1,1,1,0],
    #[0,0,0,4,1,2,0,0,0,1,0,1,1,1,1],
    #[1,0,2,1,0,0,0,1,1,1,1,1,1,1,1],
    #[12,0,0,4,1,2,0,0,0,0,1,0,0,1,1],
    #[0,0,9,6,2,0,1,1,0,0,0,0,0,0,0],
    #[0,0,9,6,2,0,1,1,0,0,0,0,0,0,0],
    #[3,0,0,1,0,3,1,0,0,1,1,1,1,1,1],
    #[0,0,2,5,1,2,1,0,1,0,1,0,0,1,1],
    #[1,1,2,5,1,0,0,1,1,1,0,1,0,1,1],
    #[2,0,7,0,0,2,0,1,0,0,1,1,1,1,1],
    #[0,0,0,5,0,2,0,1,1,1,0,1,1,1,1],
    #[1,0,2,1,1,3,1,1,0,1,1,1,1,0,1],
    #[3,2,0,4,1,0,1,1,1,1,1,0,1,1,1],
    #[0,0,3,1,2,2,0,0,1,1,1,1,1,1,1],
    #[0,19,0,0,2,3,1,0,1,1,0,0,0,0,0],
    #[0,19,0,0,2,3,1,0,1,1,0,0,0,0,0],
    #[0,6,7,0,1,0,0,0,1,0,1,1,1,1,1],
    #[7,0,2,0,1,3,0,1,1,0,1,1,1,1,1],
    #[0,3,7,0,1,2,1,0,1,1,0,0,1,1,1],
    #[0,1,7,5,0,0,0,0,0,1,1,1,1,1,1],
    #[0,0,1,5,0,3,0,0,1,1,1,1,1,1,1],
    #[0,2,1,1,1,2,1,1,1,1,1,1,1,1,1],
    #[4,0,2,0,0,3,1,1,1,1,1,1,1,1,1],
    #[0,2,1,0,2,2,1,1,1,1,1,1,1,1,1],
    #[3,0,8,1,0,3,1,1,0,1,0,1,0,1,1],
    #[1,3,8,4,1,0,0,0,0,1,0,1,1,1,1],
    #[1,0,2,4,1,3,0,1,1,1,1,1,1,0,1],
    #[2,0,0,6,2,3,1,0,1,0,1,1,1,1,0],
    #[2,0,0,6,2,3,1,0,1,0,1,1,1,1,0],
    #[18,0,0,6,1,3,1,1,0,1,0,1,0,0,0],
    #[18,0,0,6,1,3,1,1,0,1,0,1,0,0,0],
    #[18,0,0,0,1,3,1,1,1,0,0,1,1,1,1],
    #[1,12,0,6,0,1,1,1,1,1,1,0,0,1,0],
    #[1,12,0,6,0,1,1,1,1,1,1,0,0,1,0],
    #[18,1,2,5,1,0,0,0,0,1,1,0,1,1,1],
    #[1,0,0,5,2,3,0,1,1,1,1,0,1,1,1],
    #[1,0,0,5,2,3,0,1,1,1,1,0,1,1,1],
    #[5,0,8,4,1,0,0,0,1,1,1,1,1,1,0],
    #[19,1,1,1,2,0,0,1,0,1,1,1,1,1,1],
    #[2,2,0,6,2,0,1,1,0,1,1,1,1,1,1],
    #[2,2,0,5,2,2,0,1,1,0,1,1,1,1,1],
    #[0,1,9,0,2,3,0,1,1,1,1,1,0,1,0],
    #[0,1,9,0,2,3,0,1,1,1,1,1,0,1,0],
    #[0,0,9,6,2,0,1,1,0,0,0,0,1,1,1],
    #[0,0,9,6,2,0,1,1,0,0,0,0,1,1,1],
    #[5,7,1,1,1,3,1,1,0,1,1,1,1,0,1],
    #[0,0,7,1,1,2,1,1,0,1,1,1,1,1,1],
    #[17,0,5,0,2,3,1,1,0,0,1,0,0,1,1],
    #[17,0,5,0,2,3,1,1,0,0,1,0,0,1,1],
    #[12,1,0,1,2,2,0,1,1,1,1,1,1,1,1],
    #[0,6,0,5,0,2,0,1,1,1,1,1,1,1,1],
    #[3,0,7,5,0,2,0,0,1,1,1,0,1,1,1],
    #[16,3,2,0,1,2,1,0,0,1,1,1,1,1,1],
    #[6,3,0,6,1,3,1,1,0,0,0,1,1,1,1],
    #[3,17,0,1,1,2,1,0,1,1,1,0,0,1,1],
    #[2,3,7,4,1,0,1,0,1,0,1,1,1,1,1],
    #[1,12,2,1,0,3,1,0,1,1,1,1,0,1,1],
    #[3,0,2,3,2,3,1,1,1,1,0,1,1,1,1],
    #[2,0,9,0,1,2,1,0,1,1,1,1,1,1,1],
    #[0,18,9,0,0,0,0,1,1,0,1,0,0,1,1],
    #[0,18,9,0,0,0,0,1,1,0,1,0,0,1,1],
    #[0,3,1,6,0,3,1,1,1,1,0,1,1,1,1],
    #[0,0,9,1,2,3,1,1,1,1,1,1,0,0,1],
    #[0,0,9,1,2,3,1,1,1,1,1,1,0,0,1],
    #[3,0,3,5,0,3,1,1,0,1,1,1,1,1,1],
    #[0,17,2,0,0,2,0,0,1,1,1,1,1,1,1],
    #[6,17,0,4,0,0,0,0,1,0,1,1,1,1,1],
    #[4,3,7,0,2,2,0,0,1,1,1,1,1,1,1],
    #[2,1,2,5,2,3,0,1,1,0,1,1,1,1,1],
    #[31,1,0,3,2,0,1,1,0,1,1,1,1,0,0],
    #[31,1,0,3,2,0,1,1,0,1,1,1,1,0,0],
    #[1,1,9,6,2,0,1,1,0,1,1,0,1,0,1],
    #[1,1,9,6,2,0,1,1,0,1,1,0,1,0,1],
    #[2,0,9,6,2,0,1,1,0,0,1,1,0,1,1],
    #[2,0,9,6,2,0,1,1,0,0,1,1,0,1,1],
    #[0,0,5,6,1,0,1,1,1,1,1,1,1,1,1],
    #[3,2,0,6,2,3,1,0,1,0,1,1,1,1,1],
    #[1,0,8,6,0,0,1,0,1,1,1,1,1,1,1],
    #[1,0,8,6,0,0,1,0,1,1,1,1,1,1,1],
    #[1,3,8,4,0,3,0,0,1,1,1,1,1,1,0],
    #[0,9,7,1,1,0,1,1,0,1,1,1,1,1,1],
    #[1,1,8,4,0,0,1,1,1,1,1,1,1,1,1],
    #[3,1,1,6,2,2,1,1,1,1,1,1,0,1,1],
    #[6,1,2,5,1,2,1,1,0,1,1,1,1,1,1],
    #[10,1,2,5,0,3,0,1,0,1,1,1,1,1,1],
    #[18,3,8,1,1,0,1,1,0,1,0,0,1,1,1],
    #[11,2,0,3,1,3,1,0,1,1,1,1,1,1,1],
    #[0,13,0,6,1,1,1,1,1,1,1,0,1,0,1],
    #[0,13,0,6,1,1,1,1,1,1,1,0,1,0,1],
    #[0,19,0,0,2,3,0,1,0,1,1,1,1,1,0],
    #[46,0,0,0,2,3,0,0,1,0,1,0,1,0,0],
    #[46,0,0,0,2,3,0,0,1,0,1,0,1,0,0],
    #[0,3,7,1,2,3,0,0,1,1,1,1,1,1,1],
    #[1,19,0,4,2,3,1,0,1,1,0,1,0,0,0],
    #[1,19,0,4,2,3,1,0,1,1,0,1,0,0,0],
    #[0,19,0,0,2,3,1,0,1,1,0,0,1,1,1],
    #[0,19,0,0,2,3,1,0,1,1,0,0,1,1,1],
    #[3,0,0,6,2,2,1,1,1,1,1,1,1,1,1],
    #[0,6,3,2,2,3,1,1,1,1,1,1,0,1,1],
    #[2,0,9,4,1,3,0,1,1,0,0,1,1,1,1],
    #[18,0,0,6,0,0,1,1,1,1,1,1,1,1,1],
    #[4,12,0,1,2,3,0,1,0,1,1,1,1,1,1],
    #[0,3,9,0,1,3,1,1,1,1,0,1,1,1,1],
    #[3,2,0,4,2,3,1,1,1,1,1,1,1,1,1],
    #[7,9,0,0,1,3,1,1,1,1,1,1,1,1,1],
    #[2,1,2,6,1,2,1,1,1,1,1,1,1,1,1],
    #[3,6,0,6,1,2,1,0,1,1,1,1,1,1,1],
    #[18,0,8,5,0,0,0,1,1,0,1,1,0,1,1],
    #[3,6,8,1,1,1,1,1,1,0,1,1,1,1,1],
    #[13,0,2,5,2,3,0,0,1,1,0,1,1,1,1],
    #[0,19,5,1,2,0,0,1,1,1,0,1,1,0,1],
    #[43,0,0,0,2,2,0,1,1,1,0,1,0,1,0],
    #[43,0,0,0,2,2,0,1,1,1,0,1,0,1,0],
    #[43,0,0,0,2,2,0,1,1,1,0,1,0,1,0],
    #[20,2,0,0,2,3,1,0,1,1,1,1,1,1,1],
    #[0,2,9,6,2,0,1,1,1,1,0,1,1,0,1],
    #[1,0,9,6,2,2,1,1,0,1,1,0,1,1,0],
    #[1,0,9,6,2,2,1,1,0,1,1,0,1,1,0],
    #[9,1,8,1,1,3,0,1,1,1,1,0,1,1,1],
    #[1,17,2,5,0,0,0,1,1,1,1,0,1,1,1],
    #[2,0,2,6,2,3,1,0,1,1,1,1,1,1,1],
    #[42,0,0,4,1,0,0,0,1,0,1,1,1,1,0],
    #[3,0,8,6,1,0,1,1,0,1,1,1,1,1,1],
    #[18,0,0,6,1,3,1,1,1,1,1,1,1,0,0],
    #[18,0,0,6,1,3,1,1,1,1,1,1,1,0,0],
    #[21,0,0,6,1,3,1,1,0,1,0,1,0,1,1],
    #[0,2,9,6,1,2,1,1,0,0,0,1,1,1,1],
    #[1,0,5,4,2,3,0,1,1,1,1,1,1,1,1],
    #[42,0,7,0,1,0,0,0,1,0,0,1,0,1,1],
    #[1,17,1,5,1,0,0,1,1,1,1,1,0,1,1],
    #[16,1,0,4,2,2,1,1,0,1,1,1,1,1,1],
    #[0,17,1,0,2,2,1,1,1,0,1,1,1,1,1],
    #[2,0,7,4,2,3,0,1,0,1,1,1,1,1,1],
    #[28,1,0,1,1,2,1,0,1,1,1,1,1,1,1],
    #[18,3,2,1,2,3,0,1,1,1,0,1,1,1,1],
    #[2,0,1,6,2,3,1,1,1,1,1,1,1,1,1],
    #[32,0,9,0,0,0,0,1,0,1,0,1,1,1,1],
    #[2,4,1,6,2,3,1,1,1,1,1,1,1,1,0],
    #[2,2,9,1,2,1,1,1,1,1,1,1,1,1,1],
    #[3,6,7,5,1,2,0,1,0,1,1,1,0,1,1],
    #[1,19,1,1,2,3,0,1,0,1,1,1,1,1,0],
    #[0,19,0,0,2,3,0,1,0,1,1,1,1,1,1],
    #[10,1,0,5,2,3,0,1,1,1,1,1,1,1,1],
    #[4,7,7,1,1,3,0,1,1,0,1,1,1,1,1],
    #[2,2,9,4,2,3,0,1,1,1,1,1,0,0,1],
    #[18,0,0,6,1,3,1,1,0,1,0,1,1,1,1],
    #[20,0,2,5,0,3,1,0,1,1,1,1,0,1,1],
    #[32,0,1,0,0,3,1,1,1,1,1,0,1,1,1],
    #[0,19,0,1,2,3,1,1,1,1,0,1,1,0,1],
    #[0,17,7,4,2,2,0,0,0,0,1,0,0,1,1],
    #[12,1,9,1,0,2,1,1,0,1,1,1,1,1,1],
    #[1,19,0,4,2,0,0,1,1,1,0,1,1,1,1],
    #[2,19,0,0,2,3,1,0,1,1,1,1,0,1,1],
    #[1,2,3,4,2,3,1,1,1,1,1,1,1,1,1],
    #[0,1,9,0,2,3,1,1,1,1,1,1,1,1,1],
    #[3,1,7,5,2,1,1,1,1,1,0,1,1,1,1],
    #[0,18,0,5,0,2,1,1,0,0,1,1,1,1,1],
    #[18,19,0,0,0,3,0,0,0,1,1,1,0,1,1],
    #[6,0,9,4,2,0,0,1,1,1,1,1,1,1,1],
    #[0,12,2,1,1,3,1,1,1,1,1,1,1,1,1],
    #[42,0,0,0,0,2,0,0,1,1,1,1,1,1,1],
    #[12,6,2,5,0,3,1,1,1,0,1,0,1,1,1],
    #[0,12,0,6,0,3,1,1,1,1,1,1,1,0,1],
    #[42,2,1,4,0,2,0,0,1,1,0,1,0,1,0],
    #[0,20,0,6,2,0,1,0,0,1,1,1,0,1,1],
    #[0,0,9,3,2,3,1,1,1,1,1,1,1,1,0],
    #[0,17,7,0,1,2,0,0,0,1,1,1,1,1,1],
    #[0,4,0,6,2,3,1,1,1,1,1,1,1,1,1],
    #[0,4,0,6,2,3,1,1,1,1,1,1,1,1,1],
    #[44,0,0,6,0,0,1,0,1,0,0,1,0,1,1],
    #[0,12,5,3,2,0,1,1,0,1,1,1,1,1,1],
    #[2,0,9,6,0,3,1,1,0,0,1,1,1,1,1],
    #[2,0,7,5,2,3,1,0,0,1,1,1,1,1,1],
    #[0,0,9,6,2,2,1,1,1,1,0,1,0,1,1],
    #[0,18,0,1,2,2,0,1,1,1,1,1,1,1,1],
    #[2,19,0,4,0,3,0,0,0,1,1,1,1,1,1],
    #[7,2,1,4,2,3,1,1,1,1,1,1,1,1,1],
    #[0,17,7,1,0,0,1,0,1,1,1,1,1,1,1],
    #[1,0,8,6,1,3,1,0,1,1,0,1,1,1,1],
    #[1,2,9,1,2,3,0,1,1,1,1,1,1,1,1],
    #[1,6,8,6,0,0,0,1,1,1,1,1,1,1,1],
    #[46,2,0,0,2,0,1,0,1,0,0,1,1,1,1],
    #[0,12,7,0,0,3,1,0,1,1,1,1,1,1,1]]

/-- `Ω(dim)` for each irrep: the recorded total number of prime factors (with
    multiplicity) of the degree, i.e. the sum of the corresponding valuation row. -/
def rowExpSumTable : Array ℕ := #[0,3,6,7,9,7,9,11,14,12,12,11,12,12,22,19,19,14,15,16,17,14,15,18,15,27,27,20,20,19,19,16,16,18,16,21,22,18,19,19,32,32,29,26,26,32,18,18,24,31,20,20,21,21,22,22,25,19,32,32,26,21,23,31,25,30,24,26,21,22,32,32,21,22,22,22,28,33,25,22,43,43,25,25,25,25,21,23,23,23,25,26,23,23,25,28,37,28,28,28,30,54,54,23,33,33,30,30,22,24,25,33,29,24,23,29,23,26,37,28,31,33,52,52,52,35,26,26,26,30,32,23,52,26,35,35,37,26,23,54,32,33,30,25,41,36,23,47,26,26,30,33,31,29,30,28,35,37,44,32,35,33,33,33,24,24,27,32,45,29,28,51,35,29,55,34,25,33,24,24,55,30,27,26,26,31,34,28,33,26,26,29,56,30]

/-- There are exactly 194 Monster irreps. -/
def numIrreps : ℕ := 194

theorem padicTable_size : padicTable.size = 194 := by native_decide

theorem rowExpSumTable_size : rowExpSumTable.size = 194 := by native_decide

/-- Every valuation row has length 15 (one slot per Ogg prime). -/
theorem padicTable_rows_len : ∀ i < 194, (padicTable.getD i #[]).size = 15 := by
  native_decide

/-! ## §3. The p-adic valuation lookup and the reconstructed degree -/

/-- The p-adic valuation `vₚ(dim i)` where `p` is the `j`-th Ogg prime. -/
def padicVal (i j : ℕ) : ℕ := (padicTable.getD i #[]).getD j 0

/-- The degree of the `i`-th Monster irrep, reconstructed from its valuations as
    `∏ⱼ (Ogg primeⱼ) ^ (padicVal i j)`.  Since every Monster degree divides `|M|`
    and `|M|` is supported on the Ogg primes, this is the exact degree. -/
def irrepDim (i : ℕ) : ℕ :=
  (List.range 15).foldl (fun acc j => acc * (oggPrime j) ^ (padicVal i j)) 1

theorem irrepDim_trivial : irrepDim 0 = 1 := by native_decide

/-- The smallest faithful irrep has degree `196883 = 47 · 59 · 71`. -/
theorem irrepDim_one : irrepDim 1 = 196883 := by native_decide

theorem irrepDim_two : irrepDim 2 = 21296876 := by native_decide

theorem irrepDim_three : irrepDim 3 = 842609326 := by native_decide

/-- The order of the Monster group `|M| = 2⁴⁶·3²⁰·5⁹·7⁶·11²·13³·17·19·23·29·31·41·47·59·71`. -/
def monsterOrder : ℕ := 808017424794512875886459904961710757005754368000000000

/-- Every Monster irrep degree divides `|M|` — the key arithmetic fact that makes
    the Ogg-prime factorization complete. -/
theorem irrepDim_dvd_monsterOrder : ∀ i < 194, irrepDim i ∣ monsterOrder := by
  native_decide

/-! ## §4. Data validation: valuation rows sum to the recorded `Ω` -/

/-- The sum of the `i`-th valuation row. -/
def padicRowSum (i : ℕ) : ℕ := (List.range 15).foldl (fun acc j => acc + padicVal i j) 0

/-- Internal consistency: each valuation row sums to its recorded `Ω(dim)`. -/
theorem padicRowSum_eq_table : ∀ i < 194, padicRowSum i = rowExpSumTable.getD i 0 := by
  native_decide

/-! ## §5. The three gradings ("colors") -/

/-- **Big grade**: the degree modulo `71·59·47 = 196883`. -/
def gradeBig (i : ℕ) : ℕ := irrepDim i % 196883

/-- **Ogg-prime grade**: the degree modulo the `j`-th supersingular prime. -/
def gradeOgg (i j : ℕ) : ℕ := irrepDim i % oggPrime j

/-- The full grade record of an irrep: its index, degree, big grade, the vector of
    its residues modulo each Ogg prime, and its p-adic valuation vector. -/
structure IrrepGrade where
  /-- Index `0..193` of the irrep. -/
  idx : ℕ
  /-- The degree (dimension) of the irrep. -/
  dim : ℕ
  /-- Residue of the degree mod `196883 = 47·59·71`. -/
  bigGrade : ℕ
  /-- Residues of the degree modulo each of the 15 Ogg primes. -/
  oggGrades : Array ℕ
  /-- The p-adic valuation vector. -/
  padicGrade : Array ℕ
  deriving Repr

/-- Assemble all three colorings of the `i`-th irrep. -/
def gradeOf (i : ℕ) : IrrepGrade where
  idx := i
  dim := irrepDim i
  bigGrade := gradeBig i
  oggGrades := (Array.range 15).map (fun j => gradeOgg i j)
  padicGrade := padicTable.getD i #[]

/-! ## §6. Coherence of the colorings -/

/-- An Ogg prime divides a degree iff the corresponding residue is `0`, i.e. iff its
    p-adic valuation is positive.  This is the meaning of the Ogg-prime coloring. -/
theorem gradeOgg_zero_iff : ∀ i < 194, ∀ j < 15,
    (gradeOgg i j = 0 ↔ 1 ≤ padicVal i j) := by
  native_decide

/-- The big grade vanishes exactly when all three Monster primes 47, 59, 71 divide
    the degree — the CRT criterion `196883 ∣ dim ↔ 47 ∣ dim ∧ 59 ∣ dim ∧ 71 ∣ dim`.
    This is precisely the Monster-branch condition from `MoonshineSheafStalk`. -/
theorem gradeBig_zero_iff_monsterPrimes : ∀ i < 194,
    (gradeBig i = 0 ↔ (1 ≤ padicVal i 12 ∧ 1 ≤ padicVal i 13 ∧ 1 ≤ padicVal i 14)) := by
  native_decide

/-- The trivial representation (degree 1) is not divisible by 196883. -/
theorem gradeBig_trivial : gradeBig 0 = 1 := by native_decide

/-- The 196883-dimensional representation has big grade 0. -/
theorem gradeBig_one : gradeBig 1 = 0 := by native_decide

/-! ## §7. Counting the Monster-colored irreps -/

/-- An irrep is **Monster-colored** if its big grade is `0`, i.e. its degree is
    divisible by `196883 = 47·59·71`. -/
def IsMonsterColored (i : ℕ) : Prop := gradeBig i = 0

instance (i : ℕ) : Decidable (IsMonsterColored i) :=
  inferInstanceAs (Decidable (gradeBig i = 0))

/-- Exactly 112 of the 194 Monster irreps are Monster-colored (degree divisible by
    `196883`); the remaining 82 carry a nonzero big grade. -/
theorem card_monsterColored :
    ((List.range 194).filter (fun i => decide (gradeBig i = 0))).length = 112 := by
  native_decide

/-- The complementary count: 82 irreps have a nonzero big grade. -/
theorem card_not_monsterColored :
    ((List.range 194).filter (fun i => decide (gradeBig i ≠ 0))).length = 82 := by
  native_decide

/-! ## §8. Per-Ogg-prime divisibility census

For each Ogg prime, how many of the 194 irreps have degree divisible by it. -/

/-- Number of irreps whose degree is divisible by the `j`-th Ogg prime. -/
def oggDivCount (j : ℕ) : ℕ :=
  ((List.range 194).filter (fun i => decide (gradeOgg i j = 0))).length

/-- The full divisibility census across the 15 Ogg primes. -/
theorem oggDivCount_census :
    (List.range 15).map oggDivCount =
      [130, 113, 114, 145, 144, 139, 116, 126, 129, 149, 143, 153, 144, 163, 157] := by
  native_decide

end RequestProject.Math.Bridge.MoonshineIrrepGrading
