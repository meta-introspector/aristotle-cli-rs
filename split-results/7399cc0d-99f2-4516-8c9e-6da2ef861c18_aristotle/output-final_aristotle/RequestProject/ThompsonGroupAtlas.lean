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

import Mathlib

set_option maxHeartbeats 4000000

namespace ThompsonGroupAtlas

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

/-- |Th| divides |M| (the Monster order). -/
def M_order : ℕ :=
  2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

theorem Th_divides_M : Th_order ∣ M_order := by native_decide

/-- |Th| divides |B| (the Baby Monster order). -/
def B_order : ℕ :=
  2^41 * 3^13 * 5^6 * 7^2 * 11 * 13 * 17 * 19 * 23 * 31 * 47

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
