import Mathlib
import RequestProject.MonsterAdjacentPrimes

/-!
# Moonshine Arithmetic and Enochian Claim Verification

This file formalizes arithmetic facts related to the Monstrous Moonshine conjecture
and rigorously verifies (or refutes) numerical claims from an alternative-history
cryptographic framework mapping the 16th-century Enochian system of John Dee and
Edward Kelley onto the Klein j-invariant and the Monster group.

## Historical Context

John Dee (1527–1608) was a brilliant mathematician and advisor to Queen Elizabeth I.
The Enochian system, developed with Edward Kelley (1582–1589), consists of angelic
alphabets and watchtower tables. Modern claims linking this system to the j-invariant
and Monster group are speculative numerology — the Monster group was not discovered
until the late 20th century (Griess, 1982).

## Verified Claims

- The Moonshine connection: 196884 = 196883 + 1 (first coefficient minus
  Monster minimal representation dimension).
- 196883 = 47 × 59 × 71 (product of the three largest Monster primes).
- 196884 = 2² × 3³ × 1823.
- The Enochian table arithmetic: 660 × 298 + 203 = 196883.

## Refuted Claims

- **FALSE**: 744 = Σₖ₌₁²⁴ k² (the actual value is 4900).
- **FALSE**: 21! mod 196883 = 744 (the actual value is 53469).

## References

- OEIS A014708: Coefficients of J = j − 744
- OEIS A000521: Coefficients of Klein's j-invariant
- Conway, J. H. and Norton, S. P., "Monstrous Moonshine" (1979)
- Borcherds, R. E., "Monstrous Moonshine and Monstrous Lie Superalgebras" (1992)
-/

/-! ## The Moonshine Connection -/

/-- The fundamental Moonshine coincidence: the first Fourier coefficient of the
    j-invariant exceeds the dimension of the Monster's smallest nontrivial
    representation by exactly 1.

    McKay (1978) observed: 196884 = 196883 + 1.
    This was the spark that led to the Monstrous Moonshine conjecture. -/
theorem moonshine_connection : jCoefficient 1 = 196883 + 1 := by norm_num [jCoefficient]

/-- 196883 factors as the product of the three largest Monster primes.
    This is one of the remarkable structural properties of the Monster group:
    dim(V₁) = 47 × 59 × 71, where 47, 59, 71 are the three largest primes
    dividing |M|. -/
theorem monster_dim_factorization : 47 * 59 * 71 = 196883 := by norm_num

/-- All three factors of 196883 are Monster primes. -/
theorem monster_dim_factors_are_monster_primes :
    47 ∈ monsterPrimes ∧ 59 ∈ monsterPrimes ∧ 71 ∈ monsterPrimes := by
  refine ⟨?_, ?_, ?_⟩ <;> native_decide

/-- The first j-coefficient decomposes as 196884 = 2² × 3³ × 1823,
    tying the birth year of Kronecker and Eisenstein (1823) directly to
    the Moonshine coefficient. -/
theorem j_coeff_1_factorization : 2 ^ 2 * 3 ^ 3 * 1823 = jCoefficient 1 := by
  norm_num [jCoefficient]

/-! ## Enochian Table Arithmetic -/

/-- The Enochian Great Table has 660 squares (4 watchtowers × 12 × 13 + 36 Black Cross
    squares = 4 × 156 + 36 = 660). The alternative-history framework claims that with
    a scaling factor of 298 and an addition of 203 (from the Tablet of Union), one
    recovers the Monster's minimal representation dimension.

    This arithmetic identity is correct, though the connection is numerological. -/
theorem enochian_table_arithmetic : 660 * 298 + 203 = 196883 := by norm_num

/-- The Great Table square count. -/
theorem great_table_squares : 4 * (12 * 13) + 36 = 660 := by norm_num

/-! ## Debunking False Claims

The following theorems formally refute specific false numerical claims from
the Enochian-Moonshine framework. -/

/-- **REFUTED**: The claim "744 = Σₖ₌₁²⁴ k²" is false.
    The sum of the first 24 squares is 4900, not 744.
    (By the formula: n(n+1)(2n+1)/6 = 24 × 25 × 49 / 6 = 4900.) -/
theorem sum_of_24_squares_is_4900 :
    (Finset.range 24).sum (fun k => (k + 1) ^ 2) = 4900 := by native_decide

theorem sum_of_24_squares_ne_744 :
    (Finset.range 24).sum (fun k => (k + 1) ^ 2) ≠ 744 := by native_decide

/-- **REFUTED**: The claim "21! mod 196883 = 744" is false.
    The actual value is 53469. -/
theorem factorial_21_mod_196883 :
    Nat.factorial 21 % 196883 = 53469 := by native_decide

theorem factorial_21_mod_196883_ne_744 :
    Nat.factorial 21 % 196883 ≠ 744 := by native_decide

/-! ## Additional Moonshine Facts -/

/-- The constant term 744 of the j-invariant factors as 2³ × 3 × 31. -/
theorem j_const_factorization : 2 ^ 3 * 3 * 31 = 744 := by norm_num

/-- The constant term 744 in the j-expansion: c₀ = 744. -/
theorem j_coeff_0_eq : jCoefficient 0 = 744 := rfl

/-- **REFUTED**: The claim "1823 is a Sophie Germain prime" is false.
    While 1823 is indeed prime, 2 × 1823 + 1 = 3647 = 7 × 521 is composite. -/
theorem not_sophie_germain_1823 : ¬ Nat.Prime (2 * 1823 + 1) := by native_decide

theorem composite_3647 : 2 * 1823 + 1 = 3647 := by norm_num
theorem factorization_3647 : 7 * 521 = 3647 := by norm_num

/-- The Moonshine decomposition at depth 1:
    c₁ = 196884 = 1 + 196883
    where 1 is the dimension of the trivial representation and
    196883 is the dimension of the smallest nontrivial representation of M. -/
theorem moonshine_decomposition_depth_1 :
    jCoefficient 1 = 1 + 47 * 59 * 71 := by norm_num [jCoefficient]

/-- The Moonshine decomposition at depth 2:
    c₂ = 21493760 = 1 + 196883 + 21296876
    where 21296876 is the dimension of the second-smallest nontrivial
    representation of M.
    (The coefficient 21296876 factors as 2² × 5324219.) -/
theorem moonshine_decomposition_depth_2 :
    jCoefficient 2 = 1 + 196883 + 21296876 := by norm_num [jCoefficient]

/-! ## The Bisection A099818

OEIS A099818 is the bisection of A000521 (odd-indexed coefficients of j),
giving the sequence 1, 196884, 864299970, 333202640600, 44656994071935, ...
These are exactly jCoefficient at odd depths (shifted). -/

/-- The odd-depth j-coefficients match OEIS A099818. -/
theorem bisection_depth_1 : jCoefficient 1 = 196884 := rfl
theorem bisection_depth_3 : jCoefficient 3 = 864299970 := rfl
theorem bisection_depth_5 : jCoefficient 5 = 333202640600 := rfl
theorem bisection_depth_7 : jCoefficient 7 = 44656994071935 := rfl
theorem bisection_depth_9 : jCoefficient 9 = 3176440229784420 := rfl
