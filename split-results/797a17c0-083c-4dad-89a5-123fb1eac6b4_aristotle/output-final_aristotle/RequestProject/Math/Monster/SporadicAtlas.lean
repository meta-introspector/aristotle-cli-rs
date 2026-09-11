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
import RequestProject.MonsterConstants

set_option maxHeartbeats 4000000

namespace BabyMonsterAtlas

open MonsterConstants

/-! ## §1. Order and Factorization -/
-- [dedup] B_order now imported from MonsterConstants
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
-- [dedup] M_order now imported from MonsterConstants
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

/-! ## ════════════════════════════════════════════════════════
   Merged from HaradaNortonAtlas.lean (semantic dedup: same prime invariant — sporadic atlas data)
   ════════════════════════════════════════════════════════ -/

/-
# Harada-Norton Group HN — Atlas Data

## Source
- Conway–Curtis–Norton–Parker–Wilson, *ATLAS of Finite Groups* (1985), p. 166
- Harada, "On the simple group F of order 2¹⁴·3⁶·5⁶·7·11·19" (1976)
- Norton–Wilson, "Maximal subgroups of the Harada-Norton group" (1986)
- Ryba, "A natural invariant algebra for the Harada-Norton group" (1996)

## What This Formalizes
The Harada-Norton group HN (= F₅) is a sporadic simple group of order
  |HN| = 2¹⁴ · 3⁶ · 5⁶ · 7 · 11 · 19 ≈ 2.73 × 10¹⁴

Key facts:
- Found by Harada (1976), constructed by Norton (1975)
- Schur multiplier: trivial
- Outer automorphism group: Z/2Z
- C_M(g₅A) = 5 × HN for g₅A of order 5 type 5A in the Monster
- Full normalizer of 5A in M is (D₁₀ × HN).2
- HN acts on a 133-dimensional algebra over F₅ (analogous to Griess algebra)
- HN is a subgroup of the Baby Monster B (in HN:2)
- 14 conjugacy classes of maximal subgroups (Norton–Wilson 1986)
-/


set_option maxHeartbeats 4000000

namespace HaradaNortonAtlas

open MonsterConstants

/-! ## §1. Order and Factorization -/

/-- The order of the Harada-Norton group. -/
def HN_order : ℕ := 2^14 * 3^6 * 5^6 * 7 * 11 * 19

/-- The decimal value of |HN|. -/
theorem HN_order_value : HN_order = 273030912000000 := by native_decide

/-- The prime divisors of |HN|. -/
def HN_prime_divisors : List ℕ := [2, 3, 5, 7, 11, 19]

theorem HN_prime_divisors_length : HN_prime_divisors.length = 6 := by native_decide
-- [dedup] M_order now imported from MonsterConstants
theorem HN_divides_M : HN_order ∣ M_order := by native_decide
-- [dedup] B_order now imported from MonsterConstants
theorem HN_divides_B : HN_order ∣ B_order := by native_decide

/-! ## §2. The 14 Conjugacy Classes of Maximal Subgroups (Norton–Wilson 1986) -/

/-- Orders of the 14 maximal subgroups of HN, one per conjugacy class.
    Note: #11 and #12 are two classes of M₁₂:2, fused by outer automorphism. -/
def maxSubgroupOrders : List ℕ :=
  [ -- 1. A₁₂
    239500800,
    -- 2. 2·HS.2 (centralizer of involution 2A)
    177408000,
    -- 3. U₃(8):3
    16547328,
    -- 4. 2^{1+8}.(A₅ × A₅).2 (centralizer of involution 2B)
    3686400,
    -- 5. (D₁₀ × U₃(5)).2 (normalizer of 5A subgroup)
    2520000,
    -- 6. 5^{1+4}₊.2^{1+4}₋.5.4 (normalizer of 5B subgroup)
    2000000,
    -- 7. 2⁶.U₄(2)
    1658880,
    -- 8. (A₆ × A₆).D₈
    1036800,
    -- 9. 2^{3+2+6}.(3 × L₃(2))
    1032192,
    -- 10. 5^{2+1+2}.4.A₅
    750000,
    -- 11. M₁₂:2 (first class)
    190080,
    -- 12. M₁₂:2 (second class, fused by Out)
    190080,
    -- 13. 3⁴:2.(A₄ × A₄).4
    93312,
    -- 14. 3^{1+4}:4.A₅ (normalizer of 3B subgroup)
    58320
  ]

theorem maxSubgroupOrders_length : maxSubgroupOrders.length = 14 := by native_decide

/-- Each maximal subgroup order divides |HN|. -/
theorem maxSubgroups_divide_HN : ∀ o ∈ maxSubgroupOrders, o ∣ HN_order := by native_decide

/-! ## §3. Notable Maximal Subgroup Factorizations -/

/-- Maximal subgroup #1: A₁₂ has order 2⁹ · 3⁵ · 5² · 7 · 11.
    The alternating group A₁₂ is a maximal subgroup of HN. -/
theorem max1_factored :
    (239500800 : ℕ) = 2^9 * 3^5 * 5^2 * 7 * 11 := by native_decide

/-- Maximal subgroup #2: 2·HS.2 — centralizer of involution 2A.
    Order = 2¹¹ · 3² · 5³ · 7 · 11.
    Contains the Higman-Sims group HS. -/
theorem max2_factored :
    (177408000 : ℕ) = 2^11 * 3^2 * 5^3 * 7 * 11 := by native_decide

/-- Maximal subgroup #3: U₃(8):3 has order 2⁹ · 3⁵ · 7 · 19. -/
theorem max3_factored :
    (16547328 : ℕ) = 2^9 * 3^5 * 7 * 19 := by native_decide

/-- Maximal subgroup #6: 5^{1+4}₊.2^{1+4}₋.5.4 has order 2⁷ · 5⁶.
    Normalizer of 5B subgroup. -/
theorem max6_factored :
    (2000000 : ℕ) = 2^7 * 5^6 := by native_decide

/-- Maximal subgroups #11,12: M₁₂:2 has order 2⁷ · 3³ · 5 · 11 = 190080. -/
theorem max11_factored :
    (190080 : ℕ) = 2^7 * 3^3 * 5 * 11 := by native_decide

/-! ## §4. Generalized Monstrous Moonshine: T_{5A}

The McKay-Thompson series for HN is T_{5A}(τ), with constant term a(0) = −6:

  j_{5A}(τ) = T_{5A}(τ) − 6
            = (η(τ)/η(5τ))⁶ + 5³(η(5τ)/η(τ))⁶
            = 1/q − 6 + 134q + 760q² + 3345q³ + 12256q⁴ + 39350q⁵ + ⋯
-/

/-- Coefficients of j_{5A}(τ) = 1/q + Σ a(n)qⁿ. -/
def j5A_coeff : ℕ → ℤ
  | 0 => -6       -- constant term
  | 1 => 134
  | 2 => 760
  | 3 => 3345
  | 4 => 12256
  | 5 => 39350
  | _ => 0

/-- The leading coefficient 134 relates to HN:
    134 = 1 + 133, where 133 is the dimension of the HN-invariant algebra over F₅. -/
theorem j5A_mckay : j5A_coeff 1 = 1 + 133 := by native_decide

/-- The dimension of the HN-invariant algebra over F₅. -/
def HN_algebra_dim : ℕ := 133

/-- 133 = 7 × 19, both primes dividing |HN|. -/
theorem HN_algebra_dim_factored : HN_algebra_dim = 7 * 19 := by native_decide

/-! ## §5. The 5A Centralizer in the Monster

The centralizer of a 5A element in M is 5 × HN:
  C_M(g_{5A}) = 5 × HN

The full normalizer is (D₁₀ × HN).2.
-/

/-- 5 × |HN| divides |M|. -/
theorem five_times_HN_divides_M : 5 * HN_order ∣ M_order := by native_decide

/-- 10 × |HN| divides |M| (for D₁₀ × HN normalizer). -/
theorem ten_times_HN_divides_M : 10 * HN_order ∣ M_order := by native_decide

/-! ## §6. Indices of Maximal Subgroups -/

/-- Index of A₁₂ in HN. -/
theorem index_max1 : HN_order / 239500800 = 1140000 := by native_decide

/-- Index of 2·HS.2 in HN. -/
theorem index_max2 : HN_order / 177408000 = 1539000 := by native_decide

end HaradaNortonAtlas

/-! ## ════════════════════════════════════════════════════════
   Merged from ThompsonGroupAtlas.lean (semantic dedup: same prime invariant — sporadic atlas data)
   ════════════════════════════════════════════════════════ -/

/-
# Thompson Group Th — Atlas Data

## Source
- Conway–Curtis–Norton–Parker–Wilson, *ATLAS of Finite Groups* (1985), p. 177
- Thompson, "A conjugacy theorem for E₈" (1976)
- Smith, "A simple subgroup of M? and E₈(3)" (1976)
- Linton, "The maximal subgroups of the Thompson group" (1989)

## What This Formalizes
The Thompson group Th (= F₃) is a sporadic simple group of order
  |Th| = 2¹⁵ · 3¹⁰ · 5³ · 7² · 13 · 19 · 31 ≈ 9.07 × 10¹⁶

Key facts:
- Constructed as automorphism group of a lattice in the 248-dim Lie algebra of E₈
- Does not preserve the Lie bracket, but preserves it mod 3
- Hence Th ⊂ E₈(3) (Chevalley group over F₃)
- The Dempwolff group (preserving the bracket over ℤ) is a maximal subgroup
- Schur multiplier: trivial
- Outer automorphism group: trivial
- 48 conjugacy classes
- 16 conjugacy classes of maximal subgroups (Linton 1989)
- C_M(g) = 3 × Th for g of type 3C in M
- Th is a subgroup of the Baby Monster B
-/


set_option maxHeartbeats 4000000

namespace ThompsonGroupAtlas

open MonsterConstants

/-! ## §1. Order and Factorization -/

/-- The order of the Thompson group. -/
def Th_order : ℕ := 2^15 * 3^10 * 5^3 * 7^2 * 13 * 19 * 31

/-- The decimal value of |Th|. -/
theorem Th_order_value : Th_order = 90745943887872000 := by native_decide

/-- The prime divisors of |Th|. -/
def Th_prime_divisors : List ℕ := [2, 3, 5, 7, 13, 19, 31]

theorem Th_prime_divisors_length : Th_prime_divisors.length = 7 := by native_decide

/-- Each listed prime divides |Th|. -/
theorem Th_primes_divide : ∀ p ∈ Th_prime_divisors, p ∣ Th_order := by decide
-- [dedup] M_order now imported from MonsterConstants
theorem Th_divides_M : Th_order ∣ M_order := by native_decide
-- [dedup] B_order now imported from MonsterConstants
theorem Th_divides_B : Th_order ∣ B_order := by native_decide

/-! ## §2. Connection to E₈

The Thompson group is the automorphism group of a certain lattice L in the
248-dimensional Lie algebra of E₈. It preserves the Lie bracket mod 3:
  Th ⊂ E₈(F₃)

The 248-dimensional representation of E₈ restricts to a faithful
representation of Th (over F₃).
-/

/-- The dimension of the E₈ Lie algebra. -/
def E8_dim : ℕ := 248

/-- 248 = 8 × 31. Note: 31 is an SSP dividing |Th|. -/
theorem E8_dim_factored : E8_dim = 8 * 31 := by native_decide

-- E₈(3) order is astronomically large; we note the divisibility via Th ⊂ E₈(3)

/-! ## §3. The 16 Conjugacy Classes of Maximal Subgroups (Linton 1989) -/

/-- Orders of the 16 maximal subgroups of Th, one per conjugacy class. -/
def maxSubgroupOrders : List ℕ :=
  [ -- 1. ³D₄(2):3
    634023936,
    -- 2. 2⁵·L₅(2) (the Dempwolff group)
    319979520,
    -- 3. 2^{1+8}₊·A₉
    92897280,
    -- 4. U₃(8):6
    33094656,
    -- 5. (3 × G₂(3)):2
    25474176,
    -- 6. (3³ × 3^{1+2}₊)·3^{1+2}₊:2S₄
    944784,
    -- 7. 3²·3⁷:2S₄
    944784,
    -- 8. (3 × 3⁴:2·A₆):2
    349920,
    -- 9. 5^{1+2}₊:4S₄
    12000,
    -- 10. 5²:GL₂(5)
    12000,
    -- 11. 7²:(3 × 2S₄)
    7056,
    -- 12. L₂(19):2
    6840,
    -- 13. L₃(3)
    5616,
    -- 14. M₁₀
    720,
    -- 15. 31:15
    465,
    -- 16. S₅
    120
  ]

theorem maxSubgroupOrders_length : maxSubgroupOrders.length = 16 := by native_decide

/-- Each maximal subgroup order divides |Th|. -/
theorem maxSubgroups_divide_Th : ∀ o ∈ maxSubgroupOrders, o ∣ Th_order := by native_decide

/-! ## §4. Notable Maximal Subgroup Factorizations -/

/-- Maximal subgroup #1: ³D₄(2):3 has order 2¹² · 3⁵ · 7² · 13. -/
theorem max1_factored :
    (634023936 : ℕ) = 2^12 * 3^5 * 7^2 * 13 := by native_decide

/-- Maximal subgroup #2: 2⁵·L₅(2) (Dempwolff group) has order 2¹⁵ · 3² · 5 · 7 · 31. -/
theorem max2_factored :
    (319979520 : ℕ) = 2^15 * 3^2 * 5 * 7 * 31 := by native_decide

/-- Maximal subgroup #3: centralizer of involution, order 2¹⁵ · 3⁴ · 5 · 7. -/
theorem max3_factored :
    (92897280 : ℕ) = 2^15 * 3^4 * 5 * 7 := by native_decide

/-- Maximal subgroup #15: 31:15 — normalizer of a Sylow 31-subgroup.
    Order = 3 · 5 · 31 = 465. -/
theorem max15_factored : (465 : ℕ) = 3 * 5 * 31 := by native_decide

/-- Maximal subgroup #16: S₅ — the smallest maximal subgroup.
    Order = 2³ · 3 · 5 = 120. -/
theorem max16_factored : (120 : ℕ) = 2^3 * 3 * 5 := by native_decide

/-! ## §5. Generalized Monstrous Moonshine: T_{3C}

The McKay-Thompson series for the Thompson group is T_{3C}(τ):

  T_{3C}(τ) = (j(3τ))^{1/3}
            = 1/q + 248q² + 4124q⁵ + 34752q⁸ + 213126q¹¹ + 1057504q¹⁴ + ⋯

Note the spacing: only q^{3n-1} terms appear (n = 0, 1, 2, ...).
The coefficient 248 = dim(E₈), connecting to Th's E₈ origin.
-/

/-- Coefficients of T_{3C}(τ) at the relevant powers.
    T_{3C} = q⁻¹ + 248q² + 4124q⁵ + 34752q⁸ + 213126q¹¹ + 1057504q¹⁴ + ⋯ -/
def T3C_coeff : ℕ → ℤ
  | 0 => 1       -- coefficient of q⁻¹
  | 1 => 0       -- no q⁰ term
  | 2 => 0       -- no q¹ term
  | 3 => 248     -- coefficient of q²
  | 4 => 0
  | 5 => 0
  | 6 => 4124    -- coefficient of q⁵
  | 7 => 0
  | 8 => 0
  | 9 => 34752   -- coefficient of q⁸
  | 10 => 0
  | 11 => 0
  | 12 => 213126  -- coefficient of q¹¹
  | 13 => 0
  | 14 => 0
  | 15 => 1057504 -- coefficient of q¹⁴
  | _ => 0

/-- The first nontrivial coefficient is 248 = dim(E₈). -/
theorem T3C_first_nontrivial : T3C_coeff 3 = 248 := by native_decide

/-- 248 = dim(E₈) = 8 × 31, and 31 divides |Th|. -/
theorem dim_E8_involves_Th_prime : (248 : ℕ) = 8 * 31 := by native_decide

/-! ## §6. Indices of Maximal Subgroups -/

/-- Index of maximal subgroup #1: ³D₄(2):3 in Th. -/
theorem index_max1 : Th_order / 634023936 = 143127000 := by native_decide

/-- Index of maximal subgroup #2: Dempwolff group in Th. -/
theorem index_max2 : Th_order / 319979520 = 283599225 := by native_decide

/-- Index of maximal subgroup #16: S₅ in Th (largest index). -/
theorem index_max16 : Th_order / 120 = 756216199065600 := by native_decide

/-! ## §7. The Centralizer Connection to the Monster

The Thompson group centralizes an element of order 3 of type 3C in M:
  C_M(g₃C) = 3 × Th

The full normalizer is S₃ × Th. This means Th centralizes 3 involutions
alongside the 3-cycle. These involutions are centralized by the Baby Monster,
explaining why Th ⊂ B.
-/

/-- 3 × |Th| divides |M|. -/
theorem three_times_Th_divides_M : 3 * Th_order ∣ M_order := by native_decide

/-- 6 × |Th| divides |M| (for S₃ × Th normalizer). -/
theorem six_times_Th_divides_M : 6 * Th_order ∣ M_order := by native_decide

end ThompsonGroupAtlas
