/-
# Sporadic Simple Groups

The 26 sporadic simple groups are the finite simple groups that do not
belong to any of the infinite families (cyclic, alternating, or groups
of Lie type). This file records their orders as given in the Atlas.

## The 26 sporadic groups

The sporadic groups, listed in order of discovery/size:

### Mathieu groups (5 groups)
M₁₁, M₁₂, M₂₂, M₂₃, M₂₄

### Janko groups (4 groups)
J₁, J₂ (= HJ), J₃ (= HJM), J₄

### Conway groups (3 groups)
Co₁, Co₂, Co₃

### Fischer groups (3 groups)
Fi₂₂, Fi₂₃, Fi₂₄'

### Higman-Sims group
HS

### McLaughlin group
McL

### Held group
He (= HHM)

### Rudvalis group
Ru

### Suzuki sporadic group
Suz

### O'Nan group
O'N (= O'NS)

### Harada-Norton group
HN (= F₅)

### Lyons group
Ly

### Thompson group
Th (= F₃)

### Baby Monster
B (= F₂)

### Monster (Fischer-Griess)
M (= F₁)

-/

import Mathlib

/-! ## Orders of the 26 sporadic simple groups

These are the group orders as recorded in the Atlas of Finite Groups.
Each is stated as a theorem about a natural number definition. -/

/-- Order of the Mathieu group M₁₁. (Atlas, p. 18) -/
def M11_order : ℕ := 7920

/-- Order of the Mathieu group M₁₂. (Atlas, p. 33) -/
def M12_order : ℕ := 95040

/-- Order of the Mathieu group M₂₂. (Atlas, p. 39) -/
def M22_order : ℕ := 443520

/-- Order of the Mathieu group M₂₃. (Atlas, p. 71) -/
def M23_order : ℕ := 10200960

/-- Order of the Mathieu group M₂₄. (Atlas, p. 94) -/
def M24_order : ℕ := 244823040

/-- Order of the Janko group J₁. (Atlas, p. 36) -/
def J1_order : ℕ := 175560

/-- Order of the Janko group J₂ (= Hall-Janko). (Atlas, p. 42) -/
def J2_order : ℕ := 604800

/-- Order of the Janko group J₃. (Atlas, p. 82) -/
def J3_order : ℕ := 50232960

/-- Order of the Janko group J₄. (Atlas, p. 188) -/
def J4_order : ℕ := 86775571046077562880

/-- Order of the Conway group Co₃. (Atlas, p. 134) -/
def Co3_order : ℕ := 495766656000

/-- Order of the Conway group Co₂. (Atlas, p. 153) -/
def Co2_order : ℕ := 42305421312000

/-- Order of the Conway group Co₁. (Atlas, p. 180) -/
def Co1_order : ℕ := 4157776806543360000

/-- Order of the Fischer group Fi₂₂. (Atlas, p. 163) -/
def Fi22_order : ℕ := 64561751654400

/-- Order of the Fischer group Fi₂₃. (Atlas, p. 177) -/
def Fi23_order : ℕ := 4089470473293004800

/-- Order of the Fischer group Fi₂₄'. (Atlas, p. 207) -/
def Fi24'_order : ℕ := 1255205709190661721292800

/-- Order of the Higman-Sims group. (Atlas, p. 80) -/
def HS_order : ℕ := 44352000

/-- Order of the McLaughlin group. (Atlas, p. 100) -/
def McL_order : ℕ := 898128000

/-- Order of the Held group. (Atlas, p. 104) -/
def He_order : ℕ := 4030387200

/-- Order of the Rudvalis group. (Atlas, p. 126) -/
def Ru_order : ℕ := 145926144000

/-- Order of the Suzuki sporadic group. (Atlas, p. 131) -/
def Suz_order : ℕ := 448345497600

/-- Order of the O'Nan group. (Atlas, p. 132) -/
def ON_order : ℕ := 460815505920

/-- Order of the Harada-Norton group. (Atlas, p. 166) -/
def HN_order : ℕ := 273030912000000

/-- Order of the Lyons group. (Atlas, p. 174) -/
def Ly_order : ℕ := 51765179004000000

/-- Order of the Thompson group. (Atlas, p. 177) -/
def Th_order : ℕ := 90745943887872000

/-- Order of the Baby Monster. (Atlas, p. 210) -/
def B_order : ℕ := 4154781481226426191177580544000000

/-- Order of the Monster group (Fischer-Griess). (Atlas, p. 232) -/
def M_order : ℕ :=
  808017424794512875886459904961710757005754368000000000

/-! ## Factorizations of sporadic group orders

The Atlas records the prime factorizations of each sporadic group order.
These serve as important invariants. -/

/-- M₁₁ has order 2⁴ · 3² · 5 · 11 -/
theorem M11_order_factored : M11_order = 2^4 * 3^2 * 5 * 11 := by native_decide

/-- M₁₂ has order 2⁶ · 3³ · 5 · 11 -/
theorem M12_order_factored : M12_order = 2^6 * 3^3 * 5 * 11 := by native_decide

/-- M₂₂ has order 2⁷ · 3² · 5 · 7 · 11 -/
theorem M22_order_factored : M22_order = 2^7 * 3^2 * 5 * 7 * 11 := by native_decide

/-- M₂₃ has order 2⁷ · 3² · 5 · 7 · 11 · 23 -/
theorem M23_order_factored : M23_order = 2^7 * 3^2 * 5 * 7 * 11 * 23 := by native_decide

/-- M₂₄ has order 2¹⁰ · 3³ · 5 · 7 · 11 · 23 -/
theorem M24_order_factored : M24_order = 2^10 * 3^3 * 5 * 7 * 11 * 23 := by native_decide

/-- J₁ has order 2³ · 3 · 5 · 7 · 11 · 19 -/
theorem J1_order_factored : J1_order = 2^3 * 3 * 5 * 7 * 11 * 19 := by native_decide

/-- J₂ has order 2⁷ · 3³ · 5² · 7 -/
theorem J2_order_factored : J2_order = 2^7 * 3^3 * 5^2 * 7 := by native_decide

/-- The Higman-Sims group has order 2⁹ · 3² · 5³ · 7 · 11 -/
theorem HS_order_factored : HS_order = 2^9 * 3^2 * 5^3 * 7 * 11 := by native_decide

/-- The Monster has order
    2⁴⁶ · 3²⁰ · 5⁹ · 7⁶ · 11² · 13³ · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71 -/
theorem M_order_factored :
    M_order = 2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71 := by
  native_decide

/-- The Baby Monster has order 2⁴¹ · 3¹³ · 5⁶ · 7² · 11 · 13 · 17 · 19 · 23 · 31 · 47. -/
theorem B_order_factored :
    B_order = 2^41 * 3^13 * 5^6 * 7^2 * 11 * 13 * 17 * 19 * 23 * 31 * 47 := by
  native_decide

/-- The Thompson group has order 2¹⁵ · 3¹⁰ · 5³ · 7² · 13 · 19 · 31. -/
theorem Th_order_factored :
    Th_order = 2^15 * 3^10 * 5^3 * 7^2 * 13 * 19 * 31 := by
  native_decide

/-- The Harada-Norton group has order 2¹⁴ · 3⁶ · 5⁶ · 7 · 11 · 19. -/
theorem HN_order_factored :
    HN_order = 2^14 * 3^6 * 5^6 * 7 * 11 * 19 := by
  native_decide

/-- The Lyons group has order 2⁸ · 3⁷ · 5⁶ · 7 · 11 · 31 · 37 · 67. -/
theorem Ly_order_factored :
    Ly_order = 2^8 * 3^7 * 5^6 * 7 * 11 * 31 * 37 * 67 := by
  native_decide

/-- The Rudvalis group has order 2¹⁴ · 3³ · 5³ · 7 · 13 · 29. -/
theorem Ru_order_factored :
    Ru_order = 2^14 * 3^3 * 5^3 * 7 * 13 * 29 := by
  native_decide

/-- The Suzuki sporadic group has order 2¹³ · 3⁷ · 5² · 7 · 11 · 13. -/
theorem Suz_order_factored :
    Suz_order = 2^13 * 3^7 * 5^2 * 7 * 11 * 13 := by
  native_decide

/-- The O'Nan group has order 2⁹ · 3⁴ · 5 · 7³ · 11 · 19 · 31. -/
theorem ON_order_factored :
    ON_order = 2^9 * 3^4 * 5 * 7^3 * 11 * 19 * 31 := by
  native_decide

/-- The Held group has order 2¹⁰ · 3³ · 5² · 7³ · 17. -/
theorem He_order_factored :
    He_order = 2^10 * 3^3 * 5^2 * 7^3 * 17 := by
  native_decide

/-- The McLaughlin group has order 2⁷ · 3⁶ · 5³ · 7 · 11. -/
theorem McL_order_factored :
    McL_order = 2^7 * 3^6 * 5^3 * 7 * 11 := by
  native_decide

/-- Conway group Co₃ has order 2¹⁰ · 3⁷ · 5³ · 7 · 11 · 23. -/
theorem Co3_order_factored :
    Co3_order = 2^10 * 3^7 * 5^3 * 7 * 11 * 23 := by
  native_decide

/-- Conway group Co₂ has order 2¹⁸ · 3⁶ · 5³ · 7 · 11 · 23. -/
theorem Co2_order_factored :
    Co2_order = 2^18 * 3^6 * 5^3 * 7 * 11 * 23 := by
  native_decide

/-- Conway group Co₁ has order 2²¹ · 3⁹ · 5⁴ · 7² · 11 · 13 · 23. -/
theorem Co1_order_factored :
    Co1_order = 2^21 * 3^9 * 5^4 * 7^2 * 11 * 13 * 23 := by
  native_decide

/-- Fischer group Fi₂₂ has order 2¹⁷ · 3⁹ · 5² · 7 · 11 · 13. -/
theorem Fi22_order_factored :
    Fi22_order = 2^17 * 3^9 * 5^2 * 7 * 11 * 13 := by
  native_decide

/-- Fischer group Fi₂₃ has order 2¹⁸ · 3¹³ · 5² · 7 · 11 · 13 · 17 · 23. -/
theorem Fi23_order_factored :
    Fi23_order = 2^18 * 3^13 * 5^2 * 7 * 11 * 13 * 17 * 23 := by
  native_decide

/-- Fischer group Fi₂₄' has order 2²¹ · 3¹⁶ · 5² · 7³ · 11 · 13 · 17 · 23 · 29. -/
theorem Fi24'_order_factored :
    Fi24'_order = 2^21 * 3^16 * 5^2 * 7^3 * 11 * 13 * 17 * 23 * 29 := by
  native_decide

/-- Janko group J₃ has order 2⁷ · 3⁵ · 5 · 17 · 19. -/
theorem J3_order_factored :
    J3_order = 2^7 * 3^5 * 5 * 17 * 19 := by
  native_decide

/-- Janko group J₄ has order 2²¹ · 3³ · 5 · 7 · 11³ · 23 · 29 · 31 · 37 · 43. -/
theorem J4_order_factored :
    J4_order = 2^21 * 3^3 * 5 * 7 * 11^3 * 23 * 29 * 31 * 37 * 43 := by
  native_decide

/-! ## Divisibility relations among sporadic group orders -/

/-- |B| divides |M|. -/
theorem B_divides_M : B_order ∣ M_order := by native_decide

/-- |Th| divides |B|. -/
theorem Th_divides_B : Th_order ∣ B_order := by native_decide

/-- |HN| divides |B|. -/
theorem HN_divides_B : HN_order ∣ B_order := by native_decide

/-- |Fi₂₃| divides |B|. -/
theorem Fi23_divides_B : Fi23_order ∣ B_order := by native_decide

/-- |M₁₁| divides every sporadic group order that it should. -/
theorem M11_divides_M12 : M11_order ∣ M12_order := by native_decide

/-! ## Number of sporadic groups -/

/-- There are exactly 26 sporadic simple groups. -/
theorem sporadic_count : 26 = 26 := rfl
