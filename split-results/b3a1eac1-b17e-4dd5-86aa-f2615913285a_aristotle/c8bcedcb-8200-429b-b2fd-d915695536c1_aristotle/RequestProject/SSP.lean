import Mathlib

/-!
# Supersingular Primes and Hecke Operator Structure

Formalization of key mathematical claims from the analysis of supersingular primes (SSPs),
their T₂/T₃ Hecke classification, and digital root structures.

## Main results

- The 15 supersingular primes are all prime
- The digital root mod 9 closure of {3, 6, 9}
- The ν₂/ν₃ classification of SSPs via factorization of p-1
- p = 19 is the unique SSP with ν₃(p-1) = 2

## References

The supersingular primes are the prime factors of the order of the Monster group
that divide the order of SL₂(𝔽_p) for supersingular elliptic curves. They are:
  {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71}
-/

open Finset Nat

/-- The list of 15 supersingular primes. -/
def sspList : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- The finset of supersingular primes. -/
def sspFinset : Finset ℕ := {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71}

/-
Every supersingular prime is prime.
-/
theorem ssp_all_prime : ∀ p ∈ sspFinset, Nat.Prime p := by
  native_decide

/-
There are exactly 15 supersingular primes.
-/
theorem ssp_card : sspFinset.card = 15 := by
  native_decide +revert

/-!
## Digital Root and Tesla 3-6-9 Structure

The digital root of n in base b is the iterative sum of digits until a single digit remains.
For base 10, this equals n mod 9 (with 9 replacing 0 for nonzero n).
The set {3, 6, 9} is closed under multiplication mod 9, forming an ideal in ℤ/9ℤ.
-/

/-
The set {3, 6, 9} forms an ideal in ℤ/9ℤ under multiplication:
    if a ∈ {3,6,9} then for all b ∈ {1,...,8}, a*b mod 9 ∈ {3,6,9}.
-/
theorem tesla_369_closed_mul :
    ∀ a ∈ ({3, 6, 9} : Finset ℕ),
    ∀ b ∈ Finset.range 9,
    b ≠ 0 →
    (a * b) % 9 ∈ ({0, 3, 6} : Finset ℕ) := by
  native_decide

/-
The set {3, 6, 9} is closed under addition mod 9:
    {3,6,9} + {3,6,9} mod 9 ⊆ {0, 3, 6}.
-/
theorem tesla_369_closed_add :
    ∀ a ∈ ({3, 6, 9} : Finset ℕ),
    ∀ b ∈ ({3, 6, 9} : Finset ℕ),
    (a + b) % 9 ∈ ({0, 3, 6} : Finset ℕ) := by
  decide +revert

/-!
## ν₂/ν₃ Classification of Supersingular Primes

For each SSP p, we examine the 2-adic and 3-adic valuations of p-1.
This gives the "T₂/T₃ signature" of the prime.

| ν₂ | ν₃ | SSPs              |
|----|----|--------------------|
| 1  | 0  | 3,11,23,47,59,71  |
| 1  | 1  | 7,31               |
| 1  | 2  | 19                 |
| 2  | 0  | 5,29               |
| 2  | 1  | 13                 |
| 3  | 0  | 41                 |
| 4  | 0  | 17                 |

(p=2 has p-1=1, which has ν₂=0, ν₃=0)
-/

/-- The 2-adic valuation of (p-1) for SSPs, computed via multiplicity. -/
noncomputable def nu2 (p : ℕ) : ℕ := (p - 1).factorization 2

/-- The 3-adic valuation of (p-1) for SSPs, computed via multiplicity. -/
noncomputable def nu3 (p : ℕ) : ℕ := (p - 1).factorization 3

/-
p = 19 is the unique SSP (other than 2) with ν₃(p-1) = 2.
-/
theorem ssp_unique_nu3_eq_2 :
    ∀ p ∈ sspFinset, p ≠ 2 → (p - 1).factorization 3 = 2 → p = 19 := by
  native_decide

/-
The trivector primes {47, 59, 71} all have the same T₂/T₃ signature: ν₂=1, ν₃=0.
-/
theorem trivector_same_signature :
    ∀ p ∈ ({47, 59, 71} : Finset ℕ),
    (p - 1).factorization 2 = 1 ∧ (p - 1).factorization 3 = 0 := by
  native_decide

/-
The SSPs {3, 11, 23, 47, 59, 71} all have ν₂(p-1) = 1 and ν₃(p-1) = 0.
-/
theorem ssp_nu2_1_nu3_0 :
    ∀ p ∈ ({3, 11, 23, 47, 59, 71} : Finset ℕ),
    (p - 1).factorization 2 = 1 ∧ (p - 1).factorization 3 = 0 := by
  native_decide

/-
p = 19 has p-1 = 18 = 2 × 3², confirming ν₂ = 1, ν₃ = 2.
-/
theorem ssp_19_signature : (18 : ℕ).factorization 2 = 1 ∧ (18 : ℕ).factorization 3 = 2 := by
  native_decide

/-!
## Monster Group Order

The order of the Monster group is:
  |M| = 2⁴⁶ · 3²⁰ · 5⁹ · 7⁶ · 11² · 13³ · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71

The sum of the exponents is 46+20+9+6+2+3+1+1+1+1+1+1+1+1+1 = 95.
-/

/-- The exponents in the prime factorization of the Monster group order,
    indexed by the SSP list position. -/
def monsterExponents : List ℕ := [46, 20, 9, 6, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1]

/-
The sum of exponents in the Monster group order factorization.
-/
theorem monster_exponent_sum : monsterExponents.sum = 95 := by
  rfl

/-
The product 2310 = 2 × 3 × 5 × 7 × 11 is the primorial of the first 5 SSPs.
-/
theorem primorial_5_ssp : 2 * 3 * 5 * 7 * 11 = 2310 := by
  grind

/-!
## Bott Periodicity Connection

Bott periodicity has period 8 = 2³. The observation is that the 2-3 interaction
in SSP classification connects to the Clifford algebra period structure.

The fact that 18 = 2 × 3² (= p-1 for p=19, the boundary SSP) is the only SSP modulus
with a squared 3-factor connects the Tesla 3-6-9 structure uniquely to the boundary prime.
-/

/-
18 = 2 × 3² is the factorization of p-1 for p = 19.
-/
theorem eighteen_factorization : 18 = 2 * 3^2 := by
  rfl

/-
Among all SSPs p > 2, p = 19 is the only one where 9 ∣ (p-1).
-/
theorem ssp_unique_9_divides :
    ∀ p ∈ sspFinset, p ≠ 2 → 9 ∣ (p - 1) → p = 19 := by
  native_decide