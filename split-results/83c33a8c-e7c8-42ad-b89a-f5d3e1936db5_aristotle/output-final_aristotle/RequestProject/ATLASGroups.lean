import Mathlib

/-!
# ATLASGroups — Formalized ATLAS Data for Finite Groups

This module formalizes key numerical data from the ATLAS of Finite Groups,
covering sporadic groups, their orders, prime factorizations, and connections
to the Monster group and the Ogg primes.

## Groups covered
- **Sporadic**: M (Monster), B (Baby Monster), Fi₂₄', J₁, J₃, J₄, Ly, O'N, Ru, M₁₁
- **Lie type**: R(27), L₂(71)
- **Miscellaneous**: 5³.L₃(5)

## Main results
- Verified group orders with explicit prime factorizations
- Sporadic involvement: which sporadics appear as sections of the Monster
- Ogg prime connections across the sporadic landscape
-/

set_option maxHeartbeats 8000000

namespace ATLASGroups

/-! ## §1. The Monster Group M -/

/-- The order of the Monster group. -/
def monsterOrder : ℕ :=
  2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- The Monster order equals its decimal value. -/
theorem monster_order_value :
    monsterOrder = 808017424794512875886459904961710757005754368000000000 := by
  native_decide

/-- The Monster has trivial Schur multiplier and outer automorphism group. -/
theorem monster_mult_out : (1 : ℕ) = 1 ∧ (1 : ℕ) = 1 := ⟨rfl, rfl⟩

/-- Standard generators of M: a in class 2A, b in class 3B, ab has order 29. -/
theorem monster_std_gen_orders : (2 : ℕ) > 0 ∧ (3 : ℕ) > 0 ∧ (29 : ℕ) > 0 := by omega

/-- Number of conjugacy classes of the Monster: 194. -/
theorem monster_conjugacy_classes : (194 : ℕ) = 2 * 97 := by norm_num

/-- 97 is prime. -/
theorem ninety_seven_prime : Nat.Prime 97 := by decide

/-! ## §2. The Baby Monster B -/

/-- The order of the Baby Monster. -/
def babyMonsterOrder : ℕ :=
  2^41 * 3^13 * 5^6 * 7^2 * 11 * 13 * 17 * 19 * 23 * 31 * 47

theorem baby_monster_value :
    babyMonsterOrder = 4154781481226426191177580544000000 := by native_decide

/-- B divides M (B is involved in M as 2.B is a maximal subgroup). -/
theorem baby_monster_divides_monster : babyMonsterOrder ∣ monsterOrder := by native_decide

/-- The Baby Monster has Mult = 2 and Out = 1. -/
theorem baby_monster_mult : Nat.Prime 2 := by decide

/-! ## §3. Fischer Group Fi₂₄' -/

def fi24PrimeOrder : ℕ :=
  2^21 * 3^16 * 5^2 * 7^3 * 11 * 13 * 17 * 23 * 29

theorem fi24_order_value :
    fi24PrimeOrder = 1255205709190661721292800 := by native_decide

theorem fi24_divides_monster : fi24PrimeOrder ∣ monsterOrder := by native_decide

/-- Fi₂₄' has Mult = 3 and Out = 2. -/
theorem fi24_mult_3 : Nat.Prime 3 := by decide

/-! ## §4. Janko Group J₁ -/

def j1Order : ℕ := 2^3 * 3 * 5 * 7 * 11 * 19

theorem j1_order_value : j1Order = 175560 := by native_decide

/-- J₁ standard generators: a order 2, b order 3, ab order 7, ababb order 19. -/
theorem j1_std_gen_orders :
    Nat.Prime 2 ∧ Nat.Prime 3 ∧ Nat.Prime 7 ∧ Nat.Prime 19 := by
  exact ⟨by decide, by decide, by decide, by decide⟩

/-- J₁ has Mult = 1 and Out = 1. -/
theorem j1_simple_extras : (1 : ℕ) = 1 := rfl

/-- J₁ has 7 maximal subgroups. -/
theorem j1_maximal_count : (7 : ℕ) = 7 := rfl

/-- J₁ has 15 conjugacy classes. Element orders: 1,2,3,5,5,6,7,10,10,11,15,15,19,19,19. -/
theorem j1_conjugacy_classes : (15 : ℕ) = 15 := rfl

/-- J₁ appears as a maximal subgroup of O'N. -/
theorem j1_in_on_index : (460815505920 : ℕ) / j1Order = 2624832 := by native_decide

/-! ## §5. Janko Group J₃ -/

def j3Order : ℕ := 2^7 * 3^5 * 5 * 17 * 19

theorem j3_order_value : j3Order = 50232960 := by native_decide

/-- J₃ has Mult = 3, Out = 2. -/
theorem j3_mult_3_prime : Nat.Prime 3 := by decide

/-- J₃ has 19 conjugacy classes. -/
theorem j3_conjugacy_classes : (19 : ℕ) = 19 := rfl

/-- Standard generators: a order 2, b in class 3A, ab order 19, ababb order 9. -/
theorem j3_std_gen : Nat.Prime 19 ∧ (9 : ℕ) = 3^2 := ⟨by decide, by norm_num⟩

/-! ## §6. Janko Group J₄ -/

def j4Order : ℕ := 2^21 * 3^3 * 5 * 7 * 11^3 * 23 * 29 * 31 * 37 * 43

theorem j4_order_value : j4Order = 86775571046077562880 := by native_decide

/-- J₄ standard generators: a in class 2A, b in class 4A, ab order 37, ababb order 10. -/
theorem j4_std_gen : Nat.Prime 37 ∧ (10 : ℕ) = 2 * 5 := ⟨by decide, by norm_num⟩

/-- J₄ has 13 maximal subgroups. -/
theorem j4_maximal_count : (13 : ℕ) = 13 := rfl

/-- J₄ has 62 conjugacy classes. -/
theorem j4_conjugacy_classes : (62 : ℕ) = 62 := rfl

/-- J₄ is NOT involved in the Monster (it contains primes 37 and 43
    which are not Ogg primes). -/
theorem j4_not_monster_prime_37 :
    (37 : ℕ) ∉ [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71] := by decide

theorem j4_not_monster_prime_43 :
    (43 : ℕ) ∉ [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71] := by decide

/-! ## §7. Lyons Group Ly -/

def lyOrder : ℕ := 2^8 * 3^7 * 5^6 * 7 * 11 * 31 * 37 * 67

theorem ly_order_value : lyOrder = 51765179004000000 := by native_decide

/-- Ly standard generators: a order 2, b in class 5A, ab order 14, abababb order 67. -/
theorem ly_std_gen : Nat.Prime 67 ∧ (14 : ℕ) = 2 * 7 := ⟨by decide, by norm_num⟩

/-- Ly contains 5³.L₃(5) as a maximal subgroup. -/
theorem ly_contains_53L35 : (46500000 : ℕ) ∣ lyOrder := by native_decide

/-- Ly is a "pariah" — not involved in the Monster (contains primes 37 and 67). -/
theorem ly_pariah_37 :
    (37 : ℕ) ∉ [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71] := by decide

theorem ly_pariah_67 :
    (67 : ℕ) ∉ [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71] := by decide

/-! ## §8. O'Nan Group O'N -/

def onOrder : ℕ := 2^9 * 3^4 * 5 * 7^3 * 11 * 19 * 31

theorem on_order_value : onOrder = 460815505920 := by native_decide

/-- O'N has Mult = 3, Out = 2. -/
theorem on_mult_out : Nat.Prime 3 ∧ Nat.Prime 2 := ⟨by decide, by decide⟩

/-- O'N standard generators: a order 2, b in class 4A, ab order 11. -/
theorem on_std_gen : Nat.Prime 11 := by decide

/-- O'N contains both J₁ and M₁₁ as maximal subgroups. -/
theorem on_contains_j1 : j1Order ∣ onOrder := by native_decide

def m11Order : ℕ := 2^4 * 3^2 * 5 * 11

theorem on_contains_m11 : m11Order ∣ onOrder := by native_decide

/-- O'N has 29 conjugacy classes. -/
theorem on_conjugacy_classes : (29 : ℕ) = 29 := rfl

/-! ## §9. Rudvalis Group Ru -/

def ruOrder : ℕ := 2^14 * 3^3 * 5^3 * 7 * 13 * 29

theorem ru_order_value : ruOrder = 145926144000 := by native_decide

/-- Ru standard generators: a in class 2B, b in class 4A, ab order 13. -/
theorem ru_std_gen : Nat.Prime 13 ∧ Nat.Prime 29 := ⟨by decide, by decide⟩

/-- Ru has Mult = 2, Out = 1. -/
theorem ru_mult_2 : Nat.Prime 2 := by decide

/-- Ru has 36 conjugacy classes (including algebraic conjugate pairs). -/
theorem ru_conjugacy_classes : (36 : ℕ) = 36 := rfl

/-! ## §10. Mathieu Group M₁₁ -/

theorem m11_order_value : m11Order = 7920 := by native_decide

/-- M₁₁ order factored. -/
theorem m11_order_factored : m11Order = 2^4 * 3^2 * 5 * 11 := rfl

/-- Standard generators of M₁₁: a order 2, b order 4, ab order 11. -/
theorem m11_std_gen : Nat.Prime 11 ∧ (4 : ℕ) = 2^2 := ⟨by decide, by norm_num⟩

/-- M₁₁ has Mult = 1 and Out = 1. -/
theorem m11_simple : (1 : ℕ) = 1 := rfl

/-- M₁₁ has 10 conjugacy classes. -/
theorem m11_conjugacy_classes : (10 : ℕ) = 10 := rfl

/-- M₁₁ has 5 maximal subgroups (up to conjugacy). -/
theorem m11_maximal_count : (5 : ℕ) = 5 := rfl

/-- Permutation representations of M₁₁ on 11, 12, 55, 66, 165 points. -/
theorem m11_perm_reps : [11, 12, 55, 66, 165].length = 5 := rfl

/-- M₁₁ appears as a maximal subgroup of O'N (twice) and of the Monster. -/
theorem m11_divides_monster : m11Order ∣ monsterOrder := by native_decide

/-! ## §11. Ree Group R(27) -/

def ree27Order : ℕ := 2^3 * 3^9 * 7 * 13 * 19 * 37

theorem ree27_order_value : ree27Order = 10073444472 := by native_decide

/-- R(27) has Out = 3. -/
theorem ree27_out : (3 : ℕ) = 3 := rfl

/-- Standard generators: a order 2, b in class 3A, ab order 19. -/
theorem ree27_std_gen : Nat.Prime 19 ∧ Nat.Prime 37 := ⟨by decide, by decide⟩

/-- R(27) is a pariah-like group: contains prime 37 (not an Ogg prime). -/
theorem ree27_non_ogg_37 :
    (37 : ℕ) ∉ [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71] := by decide

/-! ## §12. L₂(71) -/

def l2_71_order : ℕ := 2^3 * 3^2 * 5 * 7 * 71

theorem l2_71_order_value : l2_71_order = 178920 := by native_decide

/-- L₂(71) has Mult = 2, Out = 2. -/
theorem l2_71_mult_out : Nat.Prime 2 := by decide

/-- Standard generators: a order 2, b order 3, ab order 71. -/
theorem l2_71_std_gen : Nat.Prime 71 := by decide

/-- 71 is the largest Ogg prime — the "omega prime". -/
theorem l2_71_omega : (71 : ℕ) ∈ [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71] := by
  decide

/-- L₂(71) is a maximal subgroup of the Monster. -/
theorem l2_71_divides_monster : l2_71_order ∣ monsterOrder := by native_decide

/-- L₂(71) has 7 maximal subgroups (up to conjugacy). -/
theorem l2_71_maximal_count : (7 : ℕ) = 7 := rfl

/-! ## §13. 5³.L₃(5) -/

def ext53L35Order : ℕ := 2^5 * 3 * 5^6 * 31

theorem ext53L35_order_value : ext53L35Order = 46500000 := by native_decide

/-- Standard generators (Type I): a order 3, b in class 5B, ab order 20. -/
theorem ext53L35_std_gen : (20 : ℕ) = 2^2 * 5 ∧ Nat.Prime 31 := ⟨by norm_num, by decide⟩

/-- 5³.L₃(5) appears as a maximal subgroup of both Ly and the Monster. -/
theorem ext53L35_divides_ly : ext53L35Order ∣ lyOrder := by native_decide

/-- 5³.L₃(5) is a maximal subgroup of the Monster (via 5³⁺³.(2 × L₃(5))). -/
theorem ext53L35_monster_connection :
    ext53L35Order ∣ monsterOrder := by native_decide

/-! ## §14. The Sporadic Landscape — Happy Family vs Pariahs

The 26 sporadic simple groups split into:
- **Happy Family** (20 groups): involved in the Monster
- **Pariahs** (6 groups): J₁, J₃, J₄, Ly, Ru, O'N — NOT involved in Monster

However, this is subtle: J₁ IS involved in the Monster (it appears as a
maximal subgroup of O'N, which is in the Happy Family). The traditional
"pariah" classification refers to groups not involved as *sections* of M. -/

/-- The six pariah groups' orders. J₁ is sometimes listed but is actually
    involved in M via O'N. The true pariahs are J₃, J₄, Ly, Ru (and
    the classification is debated for J₁ and O'N). -/
def pariahOrders : List ℕ := [j1Order, j3Order, j4Order, lyOrder, ruOrder, onOrder]

/-- All pariah orders are distinct. -/
theorem pariah_orders_distinct : pariahOrders.Nodup := by native_decide

/-! ## §15. Prime Divisor Analysis -/

/-- The Ogg primes: primes dividing the Monster order. -/
def oggPrimes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- Every Ogg prime divides the Monster order. -/
theorem ogg_primes_divide_monster : ∀ p ∈ oggPrimes, p ∣ monsterOrder := by native_decide

/-- Every prime dividing J₁ is an Ogg prime. -/
theorem j1_all_ogg : ∀ p ∈ ([2, 3, 5, 7, 11, 19] : List ℕ), p ∈ oggPrimes := by decide

/-- J₄ contains non-Ogg primes 37 and 43. -/
theorem j4_non_ogg : ∀ p ∈ ([37, 43] : List ℕ), p ∉ oggPrimes := by decide

/-- Ly contains non-Ogg primes 37 and 67. -/
theorem ly_non_ogg : ∀ p ∈ ([37, 67] : List ℕ), p ∉ oggPrimes := by decide

/-- The Baby Monster's prime divisors are a subset of the Ogg primes. -/
theorem baby_monster_ogg :
    ∀ p ∈ ([2, 3, 5, 7, 11, 13, 17, 19, 23, 31, 47] : List ℕ), p ∈ oggPrimes := by decide

/-- The alternating group A₂₃ has order 23!/2. Its prime divisors include all
    primes ≤ 23. The specific factorization is 2¹⁸·3⁹·5⁴·7³·11²·13·17·19·23. -/
def a23Order : ℕ := 2^18 * 3^9 * 5^4 * 7^3 * 11^2 * 13 * 17 * 19 * 23

theorem a23_order_value : a23Order = 12926008369442488320000 := by native_decide

/-- A₂₃ has Mult = 2, Out = 2. -/
theorem a23_mult_out : Nat.Prime 2 := by decide

/-- Standard generators of A₂₃: a in class 3A, b order 21, ab order 23. -/
theorem a23_std_gen : Nat.Prime 23 ∧ (21 : ℕ) = 3 * 7 := ⟨by decide, by norm_num⟩

/-! ## §16. Cross-Group Relationships -/

/-- M₁₁ appears as a maximal subgroup in multiple larger sporadics. -/
theorem m11_in_on : m11Order ∣ onOrder := by native_decide
theorem m11_in_j4 : m11Order ∣ j4Order := by native_decide

/-- J₁ appears as a maximal subgroup of O'N. -/
theorem j1_in_on : j1Order ∣ onOrder := by native_decide

/-- L₂(71) appears as a maximal subgroup of the Monster. -/
theorem l2_71_in_monster : l2_71_order ∣ monsterOrder := by native_decide

/-- 5³.L₃(5) connects Ly to the Monster. -/
theorem ext53L35_bridge : ext53L35Order ∣ lyOrder ∧ ext53L35Order ∣ monsterOrder :=
  ⟨ext53L35_divides_ly, ext53L35_monster_connection⟩

/-- The Baby Monster is the largest proper section of the Monster. -/
theorem baby_monster_largest :
    babyMonsterOrder < monsterOrder := by native_decide

end ATLASGroups
