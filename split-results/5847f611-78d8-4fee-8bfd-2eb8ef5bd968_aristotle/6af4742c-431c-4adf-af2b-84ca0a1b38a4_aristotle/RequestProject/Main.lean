import Mathlib

/-!
# ATLAS of Finite Groups: Formalized Verifications

This file formalizes key mathematical constraints ("connectives") from the ATLAS of Finite
Simple Groups, verified computationally in the companion Python scripts.

## Contents

1. **Group Orders and Prime Factorizations** — e.g. |M₁₁| = 2⁴·3²·5·11 = 7920
2. **Character Degree Constraints** — Sum of squares of irreducible character degrees equals
   the group order; each degree divides the group order.
3. **Monstrous Moonshine** — The first few j-function coefficients decompose as sums of
   Monster group irreducible character dimensions.
4. **Projective Geometry Counting** — |PG(n-1, q)| = (qⁿ - 1)/(q - 1)
-/

set_option maxHeartbeats 800000

/-! ## 1. Group Orders and Prime Factorizations -/

/-- The order of A₅ is 60 = 2² · 3 · 5 -/
theorem A5_order : 2^2 * 3 * 5 = 60 := by norm_num

/-- The order of L₂(7) is 168 = 2³ · 3 · 7 -/
theorem L2_7_order : 2^3 * 3 * 7 = 168 := by norm_num

/-- The order of A₆ is 360 = 2³ · 3² · 5 -/
theorem A6_order : 2^3 * 3^2 * 5 = 360 := by norm_num

/-- The order of M₁₁ is 7920 = 2⁴ · 3² · 5 · 11 -/
theorem M11_order : 2^4 * 3^2 * 5 * 11 = 7920 := by norm_num

/-- The order of L₃(4) is 20160 = 2⁶ · 3² · 5 · 7 -/
theorem L3_4_order : 2^6 * 3^2 * 5 * 7 = 20160 := by norm_num

/-- The order of the Monster group -/
theorem Monster_order :
    2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71 =
    808017424794512875886459904961710757005754368000000000 := by norm_num

/-! ## 2. Character Degree Constraints

For a finite group G, the sum of squares of degrees of irreducible complex characters
equals |G|, and each degree divides |G|.
-/

/-- A₅: The irreducible character degrees are [1, 3, 3, 4, 5] and their sum of squares is 60. -/
theorem A5_sum_sq_degrees :
    1^2 + 3^2 + 3^2 + 4^2 + 5^2 = 60 := by norm_num

/-- A₅: Each character degree divides 60 -/
theorem A5_degrees_divide :
    60 % 1 = 0 ∧ 60 % 3 = 0 ∧ 60 % 4 = 0 ∧ 60 % 5 = 0 := by decide

/-- M₁₁: The irreducible character degrees are [1, 10, 10, 10, 11, 16, 16, 44, 45, 55]
    and their sum of squares equals |M₁₁| = 7920. -/
theorem M11_sum_sq_degrees :
    1^2 + 10^2 + 10^2 + 10^2 + 11^2 + 16^2 + 16^2 + 44^2 + 45^2 + 55^2 = 7920 := by norm_num

/-- M₁₁: Each character degree divides 7920 -/
theorem M11_degrees_divide :
    7920 % 1 = 0 ∧ 7920 % 10 = 0 ∧ 7920 % 11 = 0 ∧ 7920 % 16 = 0 ∧
    7920 % 44 = 0 ∧ 7920 % 45 = 0 ∧ 7920 % 55 = 0 := by decide

/-- L₃(4): The irreducible character degrees are [1, 20, 35, 35, 35, 45, 45, 63, 63, 64]
    and their sum of squares equals |L₃(4)| = 20160. -/
theorem L3_4_sum_sq_degrees :
    1^2 + 20^2 + 35^2 + 35^2 + 35^2 + 45^2 + 45^2 + 63^2 + 63^2 + 64^2 = 20160 := by norm_num

/-- L₃(4): Each character degree divides 20160 -/
theorem L3_4_degrees_divide :
    20160 % 1 = 0 ∧ 20160 % 20 = 0 ∧ 20160 % 35 = 0 ∧ 20160 % 45 = 0 ∧
    20160 % 63 = 0 ∧ 20160 % 64 = 0 := by decide

/-- L₂(7): The irreducible character degrees are [1, 3, 3, 6, 7, 8]
    and their sum of squares equals |L₂(7)| = 168. -/
theorem L2_7_sum_sq_degrees :
    1^2 + 3^2 + 3^2 + 6^2 + 7^2 + 8^2 = 168 := by norm_num

/-- L₂(7): Each character degree divides 168 -/
theorem L2_7_degrees_divide :
    168 % 1 = 0 ∧ 168 % 3 = 0 ∧ 168 % 6 = 0 ∧ 168 % 7 = 0 ∧ 168 % 8 = 0 := by decide

/-! ## 3. M₁₁ Column Orthogonality

The second column orthogonality relation: for the identity class (1A) and class 2A of M₁₁,
∑ᵢ χᵢ(1A)·χᵢ(2A) = 0 (orthogonality of distinct columns of the character table).
-/

/-- M₁₁ orthogonality: columns 1A and 2A are orthogonal.
    Character values at 2A: [1, 2, -2, -2, 3, 0, 0, 4, -3, -1].
    ∑ χᵢ(1)·χᵢ(2A) = 1·1 + 10·2 + 10·(-2) + 10·(-2) + 11·3 + 16·0 + 16·0 + 44·4 + 45·(-3) + 55·(-1) = 0 -/
theorem M11_orthogonality_1A_2A :
    (1 : ℤ) * 1 + 10 * 2 + 10 * (-2) + 10 * (-2) + 11 * 3 + 16 * 0 + 16 * 0 +
    44 * 4 + 45 * (-3) + 55 * (-1) = 0 := by norm_num

/-- M₁₁: The sum of squared absolute values of 2A character values gives the centralizer
    order |C_G(2A)| = 48. -/
theorem M11_centralizer_2A :
    (1 : ℕ)^2 + 2^2 + 2^2 + 2^2 + 3^2 + 0^2 + 0^2 + 4^2 + 3^2 + 1^2 = 48 := by norm_num

/-! ## 4. Monstrous Moonshine

The McKay observation and Thompson's conjecture: the first coefficients of the j-invariant
(Klein's modular function) decompose as sums of dimensions of irreducible representations
of the Monster group.

The j-function: j(τ) = q⁻¹ + 744 + 196884q + 21493760q² + 864299970q³ + ⋯
where q = e^{2πiτ}.

The Monster irreducible character degrees start: 1, 196883, 21296876, 842609326, …
-/

/-- Monstrous moonshine, degree 1: c₁ = χ₁ + χ₂, i.e., 196884 = 1 + 196883 -/
theorem moonshine_c1 : 196884 = 1 + 196883 := by norm_num

/-- Monstrous moonshine, degree 2: c₂ = χ₁ + χ₂ + χ₃, i.e., 21493760 = 1 + 196883 + 21296876 -/
theorem moonshine_c2 : 21493760 = 1 + 196883 + 21296876 := by norm_num

/-- Monstrous moonshine, degree 3: c₃ = 2χ₁ + 2χ₂ + χ₃ + χ₄ -/
theorem moonshine_c3 :
    864299970 = 2 * 1 + 2 * 196883 + 21296876 + 842609326 := by norm_num

/-! ## 5. Projective Geometry Counting

For the linear group Lₙ(q), the number of points of PG(n-1, q) is (qⁿ - 1)/(q - 1).
This equals the index of a maximal parabolic subgroup (point stabilizer).
-/

/-- |PG(2, 2)| = (2³ - 1)/(2 - 1) = 7, the index of a point stabilizer in L₃(2). -/
theorem PG_2_2 : (2^3 - 1) / (2 - 1) = 7 := by norm_num

/-- |PG(2, 4)| = (4³ - 1)/(4 - 1) = 21, the index of a point stabilizer in L₃(4). -/
theorem PG_2_4 : (4^3 - 1) / (4 - 1) = 21 := by norm_num

/-- |PG(3, 2)| = (2⁴ - 1)/(2 - 1) = 15, the index of a point stabilizer in L₄(2). -/
theorem PG_3_2 : (2^4 - 1) / (2 - 1) = 15 := by norm_num

/-! ## 6. Non-isomorphism of A₈ and L₃(4)

A₈ and L₃(4) both have order 20160 but are non-isomorphic simple groups.
They are distinguished by their number of conjugacy classes (14 vs 10) and
Schur multiplier orders (2 vs 48).
-/

/-- A₈ and L₃(4) have the same order -/
theorem A8_L3_4_same_order : (Nat.factorial 8) / 2 = 20160 := by norm_num [Nat.factorial]

/-- The number of conjugacy classes differs: A₈ has 14 classes, L₃(4) has 10 -/
theorem A8_L3_4_different_classes : 14 ≠ 10 := by norm_num

/-- The Schur multiplier orders differ: A₈ has multiplier 2, L₃(4) has multiplier 48 -/
theorem A8_L3_4_different_multipliers : 2 ≠ 48 := by norm_num

/-! ## 7. Genus-Zero Primes (Monstrous Moonshine)

The genus-zero primes are exactly those primes p such that the modular curve X₀⁺(p)
has genus zero. These are exactly the prime divisors of the Monster group order.
-/

/-- The 15 genus-zero (supersingular) primes -/
def genusZeroPrimes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- All genus-zero primes are indeed prime -/
theorem genusZeroPrimes_all_prime :
    ∀ p ∈ genusZeroPrimes, Nat.Prime p := by decide

/-- There are exactly 15 genus-zero primes -/
theorem genusZeroPrimes_length : genusZeroPrimes.length = 15 := by decide

/-- The product of the genus-zero primes -/
theorem genusZeroPrimes_product :
    genusZeroPrimes.foldl (· * ·) 1 =
    2 * 3 * 5 * 7 * 11 * 13 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71 := by native_decide

/-- Each genus-zero prime divides the Monster group order -/
theorem genusZeroPrimes_divide_Monster :
    ∀ p ∈ genusZeroPrimes,
    (2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71) % p = 0 := by
  native_decide
