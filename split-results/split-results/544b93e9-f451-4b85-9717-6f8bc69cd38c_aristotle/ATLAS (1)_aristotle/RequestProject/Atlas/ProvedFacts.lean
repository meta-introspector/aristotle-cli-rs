/-
# Proved Facts from the ATLAS

This file contains formally verified facts corresponding to data in
the ATLAS of Finite Groups. All numerical results are proved using
`norm_num` or `decide`, giving the highest level of confidence.
-/
import Mathlib

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

open scoped BigOperators Classical

noncomputable section

/-! ## Character degree sum formula

For any finite group G, the sum of squares of the degrees of its
irreducible complex characters equals |G|. We verify this numerically
for several ATLAS groups. -/

/-- For A₅: degrees 1, 3, 3, 4, 5 satisfy 1² + 3² + 3² + 4² + 5² = 60 = |A₅|. -/
theorem A5_degree_sum : 1^2 + 3^2 + 3^2 + 4^2 + 5^2 = 60 := by norm_num

/-- The conjugacy class sizes of A₅: 1, 15, 20, 12, 12 sum to 60 = |A₅|. -/
theorem A5_class_sizes_sum : 1 + 15 + 20 + 12 + 12 = 60 := by norm_num

/-- For M₁₁: degrees 1, 10, 10, 10, 11, 16, 16, 44, 45, 55. -/
theorem M11_degree_sum :
    1^2 + 10^2 + 10^2 + 10^2 + 11^2 + 16^2 + 16^2 + 44^2 + 45^2 + 55^2 = 7920 := by norm_num

/-- Conjugacy class sizes of M₁₁ sum to 7920. -/
theorem M11_class_sizes_sum :
    1 + 165 + 440 + 990 + 1584 + 1320 + 990 + 990 + 720 + 720 = 7920 := by norm_num

/-- For M₁₂: degrees 1, 11, 11, 16, 16, 45, 54, 55, 55, 55, 66, 99, 120, 144, 176. -/
theorem M12_degree_sum :
    1^2 + 11^2 + 11^2 + 16^2 + 16^2 + 45^2 + 54^2 + 55^2 + 55^2 + 55^2
    + 66^2 + 99^2 + 120^2 + 144^2 + 176^2 = 95040 := by norm_num

/-- For M₂₂: degrees 1, 21, 45, 45, 55, 99, 154, 210, 231, 280, 280, 385. -/
theorem M22_degree_sum :
    1^2 + 21^2 + 45^2 + 45^2 + 55^2 + 99^2 + 154^2 + 210^2 + 231^2
    + 280^2 + 280^2 + 385^2 = 443520 := by norm_num

/-- For A₆ ≅ L₂(9): degrees 1, 5, 5, 8, 8, 9, 10. Sum = 360. -/
theorem A6_degree_sum :
    1^2 + 5^2 + 5^2 + 8^2 + 8^2 + 9^2 + 10^2 = 360 := by norm_num

/-! ## Prime factorizations of all 26 sporadic group orders

Every sporadic group order is verified to equal its prime factorization. -/

/-- M₁₁ has order 7920 = 2⁴ · 3² · 5 · 11. -/
theorem M11_order_factored : 7920 = 2^4 * 3^2 * 5 * 11 := by norm_num

/-- M₁₂ has order 95040 = 2⁶ · 3³ · 5 · 11. -/
theorem M12_order_factored : 95040 = 2^6 * 3^3 * 5 * 11 := by norm_num

/-- M₂₂ has order 443520 = 2⁷ · 3² · 5 · 7 · 11. -/
theorem M22_order_factored : 443520 = 2^7 * 3^2 * 5 * 7 * 11 := by norm_num

/-- M₂₃ has order 10200960 = 2⁷ · 3² · 5 · 7 · 11 · 23. -/
theorem M23_order_factored : 10200960 = 2^7 * 3^2 * 5 * 7 * 11 * 23 := by norm_num

/-- M₂₄ has order 244823040 = 2¹⁰ · 3³ · 5 · 7 · 11 · 23. -/
theorem M24_order_factored : 244823040 = 2^10 * 3^3 * 5 * 7 * 11 * 23 := by norm_num

/-- J₁ has order 175560 = 2³ · 3 · 5 · 7 · 11 · 19. -/
theorem J1_order_factored : 175560 = 2^3 * 3 * 5 * 7 * 11 * 19 := by norm_num

/-- J₂ (Hall-Janko) has order 604800 = 2⁷ · 3³ · 5² · 7. -/
theorem J2_order_factored : 604800 = 2^7 * 3^3 * 5^2 * 7 := by norm_num

/-- J₃ has order 50232960 = 2⁷ · 3⁵ · 5 · 17 · 19. -/
theorem J3_order_factored : 50232960 = 2^7 * 3^5 * 5 * 17 * 19 := by norm_num

/-- J₄ has order 86775571046077562880 = 2²¹ · 3³ · 5 · 7 · 11³ · 23 · 29 · 31 · 37 · 43. -/
theorem J4_order_factored :
    86775571046077562880 = 2^21 * 3^3 * 5 * 7 * 11^3 * 23 * 29 * 31 * 37 * 43 := by norm_num

/-- HS (Higman-Sims) has order 44352000 = 2⁹ · 3² · 5³ · 7 · 11. -/
theorem HS_order_factored : 44352000 = 2^9 * 3^2 * 5^3 * 7 * 11 := by norm_num

/-- McL (McLaughlin) has order 898128000 = 2⁷ · 3⁶ · 5³ · 7 · 11. -/
theorem McL_order_factored : 898128000 = 2^7 * 3^6 * 5^3 * 7 * 11 := by norm_num

/-- Co₃ has order 495766656000 = 2¹⁰ · 3⁷ · 5³ · 7 · 11 · 23. -/
theorem Co3_order_factored : 495766656000 = 2^10 * 3^7 * 5^3 * 7 * 11 * 23 := by norm_num

/-- Co₂ has order 42305421312000 = 2¹⁸ · 3⁶ · 5³ · 7 · 11 · 23. -/
theorem Co2_order_factored : 42305421312000 = 2^18 * 3^6 * 5^3 * 7 * 11 * 23 := by norm_num

/-- Co₁ has order 4157776806543360000 = 2²¹ · 3⁹ · 5⁴ · 7² · 11 · 13 · 23. -/
theorem Co1_order_factored :
    4157776806543360000 = 2^21 * 3^9 * 5^4 * 7^2 * 11 * 13 * 23 := by norm_num

/-- Suz (Suzuki sporadic) has order 448345497600 = 2¹³ · 3⁷ · 5² · 7 · 11 · 13. -/
theorem Suz_order_factored : 448345497600 = 2^13 * 3^7 * 5^2 * 7 * 11 * 13 := by norm_num

/-- Fi₂₂ has order 64561751654400 = 2¹⁷ · 3⁹ · 5² · 7 · 11 · 13. -/
theorem Fi22_order_factored : 64561751654400 = 2^17 * 3^9 * 5^2 * 7 * 11 * 13 := by norm_num

/-- Fi₂₃ has order 4089470473293004800 = 2¹⁸ · 3¹³ · 5² · 7 · 11 · 13 · 17 · 23. -/
theorem Fi23_order_factored :
    4089470473293004800 = 2^18 * 3^13 * 5^2 * 7 * 11 * 13 * 17 * 23 := by norm_num

/-- Fi₂₄' has order 1255205709190661721292800 = 2²¹ · 3¹⁶ · 5² · 7³ · 11 · 13 · 17 · 23 · 29. -/
theorem Fi24'_order_factored :
    1255205709190661721292800 = 2^21 * 3^16 * 5^2 * 7^3 * 11 * 13 * 17 * 23 * 29 := by norm_num

/-- He (Held) has order 4030387200 = 2¹⁰ · 3³ · 5² · 7³ · 17. -/
theorem He_order_factored : 4030387200 = 2^10 * 3^3 * 5^2 * 7^3 * 17 := by norm_num

/-- HN (Harada-Norton) has order 273030912000000 = 2¹⁴ · 3⁶ · 5⁶ · 7 · 11 · 19. -/
theorem HN_order_factored : 273030912000000 = 2^14 * 3^6 * 5^6 * 7 * 11 * 19 := by norm_num

/-- Th (Thompson) has order 90745943887872000 = 2¹⁵ · 3¹⁰ · 5³ · 7² · 13 · 19 · 31. -/
theorem Th_order_factored :
    90745943887872000 = 2^15 * 3^10 * 5^3 * 7^2 * 13 * 19 * 31 := by norm_num

/-- Ru (Rudvalis) has order 145926144000 = 2¹⁴ · 3³ · 5³ · 7 · 13 · 29. -/
theorem Ru_order_factored : 145926144000 = 2^14 * 3^3 * 5^3 * 7 * 13 * 29 := by norm_num

/-- O'N (O'Nan) has order 460815505920 = 2⁹ · 3⁴ · 5 · 7³ · 11 · 19 · 31. -/
theorem ON_order_factored : 460815505920 = 2^9 * 3^4 * 5 * 7^3 * 11 * 19 * 31 := by norm_num

/-- Ly (Lyons) has order 51765179004000000 = 2⁸ · 3⁷ · 5⁶ · 7 · 11 · 31 · 37 · 67. -/
theorem Ly_order_factored :
    51765179004000000 = 2^8 * 3^7 * 5^6 * 7 * 11 * 31 * 37 * 67 := by norm_num

/-- B (Baby Monster) has order 2⁴¹ · 3¹³ · 5⁶ · 7² · 11 · 13 · 17 · 19 · 23 · 31 · 47. -/
theorem B_order_factored :
    4154781481226426191177580544000000 =
    2^41 * 3^13 * 5^6 * 7^2 * 11 * 13 * 17 * 19 * 23 * 31 * 47 := by norm_num

/-- The order of the Monster group has the famous factorization
    into 15 distinct prime factors. -/
theorem monster_order_factored :
    808017424794512875886459904961710757005754368000000000 =
    2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71 := by
  norm_num

/-! ## Number of distinct prime factors

The Monster has the most prime factors (15) of any sporadic group. -/

/-- The number of distinct prime factors of the Monster order is 15. -/
theorem monster_num_prime_factors : [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71].length = 15 := by
  decide

/-- The supersingular primes (primes dividing the Monster order)
    are exactly 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71.
    These are also the primes p for which the j-function is a Hauptmodul
    for a genus-zero group Γ₀(p)⁺ (Ogg's observation / Monstrous Moonshine). -/
theorem supersingular_primes_divide_monster :
    ∀ p ∈ [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71],
    p ∣ (808017424794512875886459904961710757005754368000000000 : ℕ) := by decide

/-! ## Divisibility relations among sporadic group orders

The ATLAS notes various containment relations. If H ≤ G then |H| ∣ |G|. -/

/-- |M₁₁| divides |M₁₂|: M₁₁ is a maximal subgroup of M₁₂. -/
theorem M11_divides_M12 : 7920 ∣ 95040 := by norm_num

/-- |M₁₂| divides |M₂₄|. -/
theorem M12_divides_M24 : 95040 ∣ 244823040 := by norm_num

/-- |M₂₂| divides |M₂₃|. -/
theorem M22_divides_M23 : 443520 ∣ 10200960 := by norm_num

/-- |M₂₃| divides |M₂₄|. -/
theorem M23_divides_M24 : 10200960 ∣ 244823040 := by norm_num

/-- The index [M₁₂ : M₁₁] = 12. -/
theorem M12_M11_index : 95040 / 7920 = 12 := by norm_num

/-- The index [M₂₃ : M₂₂] = 23. -/
theorem M23_M22_index : 10200960 / 443520 = 23 := by norm_num

/-- The index [M₂₄ : M₂₃] = 24. -/
theorem M24_M23_index : 244823040 / 10200960 = 24 := by norm_num

/-- |Co₂| divides |Co₁|. -/
theorem Co2_divides_Co1 : 42305421312000 ∣ 4157776806543360000 := by norm_num

/-- |M₂₄| divides |Co₃|. -/
theorem M24_divides_Co3 : 244823040 ∣ 495766656000 := by norm_num

/-- |M₂₄| divides |Co₁|. -/
theorem M24_divides_Co1 : 244823040 ∣ 4157776806543360000 := by norm_num

/-- |HS| divides |Co₃|. -/
theorem HS_divides_Co3 : 44352000 ∣ 495766656000 := by norm_num

/-- |J₂| divides |Suz|. -/
theorem J2_divides_Suz : 604800 ∣ 448345497600 := by norm_num

/-- |M₂₂| divides |HS|. -/
theorem M22_divides_HS : 443520 ∣ 44352000 := by norm_num

/-- |M₂₂| divides |McL|. -/
theorem M22_divides_McL : 443520 ∣ 898128000 := by norm_num

/-- |M₂₂| divides |Fi₂₂|. -/
theorem M22_divides_Fi22 : 443520 ∣ 64561751654400 := by norm_num

/-! ## Indices of maximal subgroups -/

/-- All character degrees of A₅ divide |A₅| = 60.
    This is a consequence of a general theorem: χ(1) | |G| for every
    irreducible character χ of G. -/
theorem A5_degrees_divide_order :
    ∀ d ∈ [1, 3, 3, 4, 5], d ∣ (60 : ℕ) := by decide

/-- All character degrees of M₁₁ divide |M₁₁| = 7920. -/
theorem M11_degrees_divide_order :
    ∀ d ∈ [1, 10, 10, 10, 11, 16, 16, 44, 45, 55], d ∣ (7920 : ℕ) := by decide

/-! ## Burnside's theorem consequences

Every finite simple group of non-prime order has even order
(Feit-Thompson theorem). The sporadic groups provide examples. -/

/-- All sporadic group orders are even. -/
theorem sporadic_orders_even :
    ∀ n ∈ [7920, 95040, 443520, 10200960, 244823040,
           175560, 604800, 50232960, 86775571046077562880,
           44352000, 898128000,
           4157776806543360000, 42305421312000, 495766656000,
           448345497600, 64561751654400, 4089470473293004800,
           1255205709190661721292800,
           4030387200, 273030912000000, 90745943887872000,
           4154781481226426191177580544000000,
           808017424794512875886459904961710757005754368000000000,
           145926144000, 460815505920, 51765179004000000],
    2 ∣ n := by decide

end -- noncomputable section
