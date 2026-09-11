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

import Mathlib

set_option maxHeartbeats 4000000

namespace HaradaNortonAtlas

/-! ## §1. Order and Factorization -/

/-- The order of the Harada-Norton group. -/
def HN_order : ℕ := 2^14 * 3^6 * 5^6 * 7 * 11 * 19

/-- The decimal value of |HN|. -/
theorem HN_order_value : HN_order = 273030912000000 := by native_decide

/-- The prime divisors of |HN|. -/
def HN_prime_divisors : List ℕ := [2, 3, 5, 7, 11, 19]

theorem HN_prime_divisors_length : HN_prime_divisors.length = 6 := by native_decide

/-- |HN| divides |M| (the Monster order). -/
def M_order : ℕ :=
  2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

theorem HN_divides_M : HN_order ∣ M_order := by native_decide

/-- |HN| divides |B| (the Baby Monster order). -/
def B_order : ℕ :=
  2^41 * 3^13 * 5^6 * 7^2 * 11 * 13 * 17 * 19 * 23 * 31 * 47

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
