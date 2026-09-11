/-
# Baby Monster Group B — Atlas Data

## Source
- Conway–Curtis–Norton–Parker–Wilson, *ATLAS of Finite Groups* (1985), p. 210
- Wilson, "The maximal subgroups of the Baby Monster. I" (1999)
- Leon–Sims, "The existence and uniqueness of a simple group generated
  by {3,4}-transpositions" (1977)

## What This Formalizes
The Baby Monster B (= F₂) is the second-largest sporadic simple group.
Its double cover 2·B is the centralizer of a 2A involution in the Monster M.

Key facts:
- |B| = 2⁴¹ · 3¹³ · 5⁶ · 7² · 11 · 13 · 17 · 19 · 23 · 31 · 47
- |B| ≈ 4.15 × 10³³
- Schur multiplier: Z/2Z
- Outer automorphism group: trivial
- Number of conjugacy classes: 184
- Smallest faithful permutation representation: 13,571,955,000 points
- Smallest faithful matrix representation: 4370 over F₂
- 30 conjugacy classes of maximal subgroups (Wilson 1999)

The Baby Monster is connected to the Monster via:
  C_M(z) = 2·B  for z ∈ 2A class of M

and to monstrous moonshine via the McKay-Thompson series T_{2A}(τ).
-/

import Mathlib

set_option maxHeartbeats 4000000

namespace BabyMonsterAtlas

/-! ## §1. Order and Factorization -/

/-- The order of the Baby Monster group B. -/
def B_order : ℕ :=
  2^41 * 3^13 * 5^6 * 7^2 * 11 * 13 * 17 * 19 * 23 * 31 * 47

/-- The decimal value of |B|. -/
theorem B_order_value : B_order = 4154781481226426191177580544000000 := by native_decide

/-- The prime divisors of |B| are a subset of the 15 supersingular primes.
    Specifically, |B| is divisible by 11 of the 15 SSPs (missing 29, 41, 59, 71). -/
def B_prime_divisors : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 31, 47]

theorem B_prime_divisors_length : B_prime_divisors.length = 11 := by native_decide

/-- Each listed prime divides |B|. -/
theorem B_prime_divisors_divide : ∀ p ∈ B_prime_divisors, p ∣ B_order := by decide

/-! ## §2. Smallest Representations -/

/-- The smallest faithful permutation representation of B acts on
    13,571,955,000 points. This is the index [B : 2·²E₆(2):2]. -/
def B_perm_degree : ℕ := 13571955000

theorem B_perm_degree_factored : B_perm_degree = 2^3 * 3^4 * 5^4 * 23 * 31 * 47 := by
  native_decide

/-- The smallest faithful matrix representation has dimension 4370 over F₂. -/
def B_matrix_dim : ℕ := 4370

/-- In characteristic 0, the smallest faithful representation has dimension 4371. -/
def B_char0_dim : ℕ := 4371

/-- 4371 = 3 × 1457 = 3 × 31 × 47. Note: involves two SSPs! -/
theorem B_char0_dim_factored : B_char0_dim = 3 * 31 * 47 := by native_decide

/-! ## §3. Connection to the Monster -/

/-- |B| divides |M|. -/
def M_order : ℕ :=
  2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

theorem B_divides_M : B_order ∣ M_order := by native_decide

/-- The index [M : B] — not quite meaningful as B is not a subgroup of M,
    but 2·B is a subgroup. The "index" |M|/|B| indicates the ratio. -/
def M_over_B : ℕ := M_order / B_order

theorem M_over_B_value : M_over_B = M_order / B_order := rfl

/-! ## §4. The 30 Conjugacy Classes of Maximal Subgroups

Wilson (1999) determined the 30 conjugacy classes of maximal subgroups of B.
We record their orders. -/

/-- Orders of the 30 maximal subgroups of B, one per conjugacy class. -/
def maxSubgroupOrders : List ℕ :=
  [ -- 1. 2·²E₆(2):2
    306129918735099415756800,
    -- 2. 2^{1+22}₊·Co₂
    354883595661213696000,
    -- 3. Fi₂₃
    4089470473293004800,
    -- 4. 2^{9+16}.S₈(2)
    1589728887019929600,
    -- 5. Th (Thompson group)
    90745943887872000,
    -- 6. (2² × F₄(2)):2
    26489012826931200,
    -- 7. 2^{2+10+20}.(M₂₂:2 × S₃)
    22858846741463040,
    -- 8. [2³⁰].L₅(2)
    10736731045232640,
    -- 9. S₃ × Fi₂₂:2
    774741019852800,
    -- 10. [2³⁵].(S₅ × L₃(2))
    692692325498880,
    -- 11. HN:2
    546061824000000,
    -- 12. O₈⁺(3):S₄
    118852315545600,
    -- 13. 3^{1+8}₊.2^{1+6}₋.U₄(2).2
    130606940160,
    -- 14. (3²:D₈ × U₄(3).2.2).2
    1881169920,
    -- 15. 5:4 × HS:2
    1774080000,
    -- 16. S₄ × ²F₄(2)
    862617600,
    -- 17. [3¹¹].(S₄ × 2S₄)
    204073344,
    -- 18. S₅ × M₂₂:2
    106444800,
    -- 19. (S₆ × L₃(4):2).2
    58060800,
    -- 20. 5³·L₃(5)
    46500000,
    -- 21. 5^{1+4}₊.2^{1+4}₋.A₅.4
    24000000,
    -- 22. (S₆ × S₆).4
    2073600,
    -- 23. 5²:4S₄ × S₅
    288000,
    -- 24. L₂(49).2₃
    117600,
    -- 25. L₂(31)
    14880,
    -- 26. M₁₁
    7920,
    -- 27. L₃(3)
    5616,
    -- 28. L₂(17):2
    4896,
    -- 29. L₂(11):2
    1320,
    -- 30. 47:23
    1081
  ]

theorem maxSubgroupOrders_length : maxSubgroupOrders.length = 30 := by native_decide

/-- Each maximal subgroup order divides |B|. -/
theorem maxSubgroups_divide_B : ∀ o ∈ maxSubgroupOrders, o ∣ B_order := by native_decide

/-! ## §5. Notable Maximal Subgroup Factorizations -/

/-- Maximal subgroup #1: 2·²E₆(2):2 has order 2³⁸ · 3⁹ · 5² · 7² · 11 · 13 · 17 · 19. -/
theorem max1_factored :
    (306129918735099415756800 : ℕ) = 2^38 * 3^9 * 5^2 * 7^2 * 11 * 13 * 17 * 19 := by
  native_decide

/-- Maximal subgroup #2: 2^{1+22}₊·Co₂ has order 2⁴¹ · 3⁶ · 5³ · 7 · 11 · 23. -/
theorem max2_factored :
    (354883595661213696000 : ℕ) = 2^41 * 3^6 * 5^3 * 7 * 11 * 23 := by
  native_decide

/-- Maximal subgroup #3: Fi₂₃ has order 2¹⁸ · 3¹³ · 5² · 7 · 11 · 13 · 17 · 23. -/
theorem max3_factored :
    (4089470473293004800 : ℕ) = 2^18 * 3^13 * 5^2 * 7 * 11 * 13 * 17 * 23 := by
  native_decide

/-- Maximal subgroup #5: Th (Thompson group) has order 2¹⁵ · 3¹⁰ · 5³ · 7² · 13 · 19 · 31.
    The Thompson group is a subgroup of the Baby Monster. -/
theorem max5_is_Th :
    (90745943887872000 : ℕ) = 2^15 * 3^10 * 5^3 * 7^2 * 13 * 19 * 31 := by
  native_decide

/-- Maximal subgroup #11: HN:2 has order 2¹⁵ · 3⁶ · 5⁶ · 7 · 11 · 19.
    The Harada-Norton group (extended by Out) is a subgroup of B. -/
theorem max11_is_HN2 :
    (546061824000000 : ℕ) = 2^15 * 3^6 * 5^6 * 7 * 11 * 19 := by
  native_decide

/-- Maximal subgroup #30: 47:23 has order 23 · 47 = 1081.
    This is the normalizer of a Sylow 47-subgroup. -/
theorem max30_factored : (1081 : ℕ) = 23 * 47 := by native_decide

/-! ## §6. Generalized Monstrous Moonshine: T_{2A}

The McKay-Thompson series for the Baby Monster is T_{2A}(τ), related to the
Hauptmodul j_{2A}(τ) = T_{2A}(τ) + 104.

j_{2A}(τ) = ((η(τ)/η(2τ))¹² + 2⁶(η(2τ)/η(τ))¹²)²
           = 1/q + 104 + 4372q + 96256q² + 1240002q³ + 10698752q⁴ + ⋯
-/

/-- Coefficients of j_{2A}(τ) = 1/q + Σ a(n)qⁿ. -/
def j2A_coeff : ℕ → ℤ
  | 0 => 104       -- constant term
  | 1 => 4372
  | 2 => 96256
  | 3 => 1240002
  | 4 => 10698752
  | 5 => 74428120
  | 6 => 431529984
  | _ => 0

/-- McKay's generalized observation: the constant term 104 and the
    coefficient 4372 relate to Baby Monster representation dimensions.
    4372 = 1 + 4371, where 4371 is the smallest nontrivial irrep dimension of B. -/
theorem mckay_baby_monster : j2A_coeff 1 = 1 + 4371 := by native_decide

/-- 4371 = dim(smallest nontrivial irrep of B) = 3 · 31 · 47. -/
theorem baby_monster_irrep_dim : (4371 : ℕ) = 3 * 31 * 47 := by native_decide

/-! ## §7. Relationship to Other Sporadic Groups

The Baby Monster contains several sporadic groups as subgroups or sections:
- Thompson group Th (maximal subgroup #5)
- Harada-Norton group HN (in HN:2, maximal subgroup #11)
- Fischer group Fi₂₃ (maximal subgroup #3)
- Fischer group Fi₂₂ (in S₃ × Fi₂₂:2, maximal subgroup #9)
- Higman-Sims group HS (in 5:4 × HS:2, maximal subgroup #15)
- Conway group Co₂ (in 2^{1+22}₊·Co₂, maximal subgroup #2)
- Mathieu group M₂₂ (in several maximal subgroups)
- Mathieu group M₁₁ (maximal subgroup #26)
-/

/-- The Thompson group order divides |B|. -/
theorem Th_divides_B : (90745943887872000 : ℕ) ∣ B_order := by native_decide

/-- The Harada-Norton group order divides |B| (via HN:2). -/
theorem HN_divides_B : (273030912000000 : ℕ) ∣ B_order := by native_decide

/-- Fi₂₃ divides |B|. -/
theorem Fi23_divides_B : (4089470473293004800 : ℕ) ∣ B_order := by native_decide

/-- M₁₁ divides |B|. -/
theorem M11_divides_B : (7920 : ℕ) ∣ B_order := by native_decide

end BabyMonsterAtlas
