/-
# Proved Facts from the ATLAS
This file contains formally verified facts corresponding to data in
the ATLAS of Finite Groups.
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
/-! ## Prime factorizations of sporadic group orders -/
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
/-- Co₃ has order 495766656000 = 2¹⁰ · 3⁷ · 5³ · 7 · 11 · 23. -/
theorem Co3_order_factored : 495766656000 = 2^10 * 3^7 * 5^3 * 7 * 11 * 23 := by norm_num
/-- The order of the Monster group has the famous factorization
    into 15 distinct prime factors. -/
theorem monster_order_factored :
    808017424794512875886459904961710757005754368000000000 =
    2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71 := by
  norm_num
/-! ## Divisibility relations among sporadic group orders
The ATLAS notes various containment relations. If H ≤ G then |H| ∣ |G|. -/
/-- |M₁₁| divides |M₁₂|: M₁₁ is a maximal subgroup of M₁₂. -/
theorem M11_divides_M12 : 7920 ∣ 95040 := by norm_num
/-- |M₁₂| divides |M₂₄| (up to index). -/
theorem M12_divides_M24 : 95040 ∣ 244823040 := by norm_num
/-- |M₂₂| divides |M₂₃|. -/
theorem M22_divides_M23 : 443520 ∣ 10200960 := by norm_num
/-- |M₂₃| divides |M₂₄|. -/
theorem M23_divides_M24 : 10200960 ∣ 244823040 := by norm_num
end -- noncomputable section
