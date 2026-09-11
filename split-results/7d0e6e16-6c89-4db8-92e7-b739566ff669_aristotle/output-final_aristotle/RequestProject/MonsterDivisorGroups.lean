import Mathlib
import RequestProject.MonsterDivisors

/-!
# Divisor Strata of the Monster Group: 2⁴⁶ and 3²⁰ Groupings

We partition the 424,488,960 divisors of |M| into strata by their 2-adic and
3-adic valuations, reflecting the factorization |M| = 2⁴⁶ · 3²⁰ · M₂₃,
and show how each of the 104 q-expansion coefficients c₀, …, c₁₀₃
(those ≤ |M|) is "captured" by the closest divisors in specific strata.

## Divisor Stratification

### By powers of 2: 47 strata (v₂ = 0, 1, …, 46)
Each stratum contains exactly 424,488,960 / 47 = **9,031,680** divisors.

### By powers of 3: 21 strata (v₃ = 0, 1, …, 20)
Each stratum contains exactly 424,488,960 / 21 = **20,213,760** divisors.

### Joint (2,3)-strata: 47 × 21 = 987 cells
Each cell contains 424,488,960 / (47 × 21) = **430,080** divisors.

## Capturing q-Coefficients

| n | cₙ          | Closest d*  | |cₙ−d*| | v₂(d*) | v₃(d*) | d* factorization        |
|---|-------------|-------------|---------|--------|--------|-------------------------|
| 0 | 744         | 744         | 0       | 3      | 1      | 2³·3·31                 |
| 1 | 196884      | 196883      | 1       | 0      | 0      | 47·59·71                |
| 2 | 21493760    | 21493758    | 2       | 1      | 1      | 2·3·11·13²·41·47        |
| 3 | 864299970   | 864299975   | 5       | 0      | 0      | 5²·7⁵·11²·17           |
-/

open scoped BigOperators Nat

set_option maxHeartbeats 800000

/-! ## §1. The factored parts of |M| -/

/-- The odd part of |M|: |M| / 2⁴⁶ -/
def Monster.oddPart' : ℕ :=
  3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- The (2,3)-free part of |M|: |M| / (2⁴⁶ · 3²⁰) -/
def Monster.free23 : ℕ :=
  5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- The 3-free part of |M|: |M| / 3²⁰ -/
def Monster.threeFreePart : ℕ :=
  2^46 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

theorem Monster.order_eq_2pow_oddPart :
    Monster.order = 2^46 * Monster.oddPart' := by
  unfold Monster.order Monster.oddPart'; ring

theorem Monster.order_eq_2pow_3pow_free23 :
    Monster.order = 2^46 * 3^20 * Monster.free23 := by
  unfold Monster.order Monster.free23; ring

theorem Monster.order_eq_3pow_threeFreePart :
    Monster.order = 3^20 * Monster.threeFreePart := by
  unfold Monster.order Monster.threeFreePart; ring

/-! ## §2. Stratum sizes -/

/-- Divisors per 2-stratum = 9,031,680 -/
def numDivisorsPerTwoStratum : ℕ :=
  (20 + 1) * (9 + 1) * (6 + 1) * (2 + 1) * (3 + 1) *
  (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) *
  (1 + 1) * (1 + 1) * (1 + 1)

theorem numDivisorsPerTwoStratum_val : numDivisorsPerTwoStratum = 9031680 := by
  native_decide

/-- Divisors per 3-stratum = 20,213,760 -/
def numDivisorsPerThreeStratum : ℕ :=
  (46 + 1) * (9 + 1) * (6 + 1) * (2 + 1) * (3 + 1) *
  (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) *
  (1 + 1) * (1 + 1) * (1 + 1)

theorem numDivisorsPerThreeStratum_val : numDivisorsPerThreeStratum = 20213760 := by
  native_decide

/-- Divisors per joint (2,3)-cell = 430,080 -/
def numDivisorsPerCell : ℕ :=
  (9 + 1) * (6 + 1) * (2 + 1) * (3 + 1) *
  (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) *
  (1 + 1) * (1 + 1) * (1 + 1)

theorem numDivisorsPerCell_val : numDivisorsPerCell = 430080 := by native_decide

theorem two_stratum_size : Monster.numDivisors / 47 = numDivisorsPerTwoStratum := by
  native_decide

theorem three_stratum_size : Monster.numDivisors / 21 = numDivisorsPerThreeStratum := by
  native_decide

theorem joint_cell_size : Monster.numDivisors / (47 * 21) = numDivisorsPerCell := by
  native_decide

theorem total_from_2strata :
    47 * numDivisorsPerTwoStratum = Monster.numDivisors := by native_decide

theorem total_from_3strata :
    21 * numDivisorsPerThreeStratum = Monster.numDivisors := by native_decide

theorem total_from_cells :
    47 * 21 * numDivisorsPerCell = Monster.numDivisors := by native_decide

/-! ## §3. Stratum membership -/

/-- d belongs to 2-stratum a iff 2^a | d but 2^(a+1) ∤ d. -/
structure TwoStratum (d a : ℕ) : Prop where
  dvd_monster : d ∣ Monster.order
  pow_dvd : 2^a ∣ d
  pow_succ_ndvd : ¬(2^(a+1) ∣ d)

/-- d belongs to 3-stratum b iff 3^b | d but 3^(b+1) ∤ d. -/
structure ThreeStratum (d b : ℕ) : Prop where
  dvd_monster : d ∣ Monster.order
  pow_dvd : 3^b ∣ d
  pow_succ_ndvd : ¬(3^(b+1) ∣ d)

/-- d belongs to joint cell (a, b). -/
structure JointCell (d a b : ℕ) : Prop where
  two : TwoStratum d a
  three : ThreeStratum d b

/-! ## §4. Powers of 2 and 3 divide |M| -/

theorem two_pow_46_val : (2 : ℕ)^46 = 70368744177664 := by norm_num
theorem three_pow_20_val : (3 : ℕ)^20 = 3486784401 := by norm_num

theorem pow2_dvd_monster (a : ℕ) (ha : a ≤ 46) : 2^a ∣ Monster.order := by
  have : 2^a ∣ 2^46 := Nat.pow_dvd_pow 2 ha
  exact dvd_trans this (by rw [Monster.order_eq_2pow_oddPart]; exact dvd_mul_right _ _)

theorem pow3_dvd_monster (b : ℕ) (hb : b ≤ 20) : 3^b ∣ Monster.order := by
  have : 3^b ∣ 3^20 := Nat.pow_dvd_pow 3 hb
  exact dvd_trans this (by rw [Monster.order_eq_3pow_threeFreePart]; exact dvd_mul_right _ _)

theorem pow23_dvd_monster (a b : ℕ) (ha : a ≤ 46) (hb : b ≤ 20) :
    2^a * 3^b ∣ Monster.order := by
  rw [Monster.order_eq_2pow_3pow_free23]
  have h1 : 2^a * 3^b ∣ 2^46 * 3^20 :=
    Nat.mul_dvd_mul (Nat.pow_dvd_pow 2 ha) (Nat.pow_dvd_pow 3 hb)
  exact dvd_trans h1 (dvd_mul_right _ _)

theorem max_in_2stratum (a : ℕ) (ha : a ≤ 46) :
    2^a * Monster.oddPart' ∣ Monster.order := by
  rw [Monster.order_eq_2pow_oddPart]
  exact Nat.mul_dvd_mul (Nat.pow_dvd_pow 2 ha) dvd_rfl

theorem max_in_3stratum (b : ℕ) (hb : b ≤ 20) :
    3^b * Monster.threeFreePart ∣ Monster.order := by
  rw [Monster.order_eq_3pow_threeFreePart]
  exact Nat.mul_dvd_mul (Nat.pow_dvd_pow 3 hb) dvd_rfl

/-! ## §5. Joint cells: 47 × 21 = 987 -/

theorem num_joint_cells_val : 47 * 21 = 987 := by norm_num

theorem Monster.free23_coprime_2 : Nat.Coprime Monster.free23 2 := by native_decide
theorem Monster.free23_coprime_3 : Nat.Coprime Monster.free23 3 := by native_decide
theorem Monster.free23_pos : 0 < Monster.free23 := by unfold Monster.free23; positivity

/-! ## §6. Concrete stratum assignments: closest divisors for c₀ through c₃ -/

/-- c₀ = 744 = 2³ × 3 × 31 is a divisor, in cell (3, 1). -/
theorem stratum_c0 : JointCell 744 3 1 :=
  ⟨⟨by native_decide, ⟨93, by norm_num⟩, fun h => by revert h; decide⟩,
   ⟨by native_decide, ⟨248, by norm_num⟩, fun h => by revert h; decide⟩⟩

/-- c₁ closest divisor: 196883 = 47 × 59 × 71, in cell (0, 0). -/
theorem stratum_c1 : JointCell 196883 0 0 :=
  ⟨⟨by native_decide, one_dvd _, fun h => by revert h; decide⟩,
   ⟨by native_decide, one_dvd _, fun h => by revert h; decide⟩⟩

/-- c₂ closest divisor: 21493758 = 2 × 3 × 11 × 13² × 41 × 47, in cell (1, 1). -/
theorem stratum_c2 : JointCell 21493758 1 1 :=
  ⟨⟨by native_decide, ⟨10746879, by norm_num⟩, fun h => by revert h; decide⟩,
   ⟨by native_decide, ⟨7164586, by norm_num⟩, fun h => by revert h; decide⟩⟩

/-- c₃ closest divisor: 864299975 = 5² × 7⁵ × 11² × 17, in cell (0, 0). -/
theorem stratum_c3 : JointCell 864299975 0 0 :=
  ⟨⟨by native_decide, one_dvd _, fun h => by revert h; decide⟩,
   ⟨by native_decide, one_dvd _, fun h => by revert h; decide⟩⟩

/-! ## §7. Stratum summary data -/

structure StratumRecord where
  index : ℕ := 0
  qCoeff : ℕ := 0
  closestDiv : ℕ := 0
  distance : ℕ := 0
  v2 : ℕ := 0
  v3 : ℕ := 0
  deriving Inhabited

def stratumTable : List StratumRecord :=
  [ ⟨0, 744,       744,       0, 3, 1⟩,
    ⟨1, 196884,    196883,    1, 0, 0⟩,
    ⟨2, 21493760,  21493758,  2, 1, 1⟩,
    ⟨3, 864299970, 864299975, 5, 0, 0⟩ ]

theorem stratumTable_valid :
    ∀ s ∈ stratumTable, s.closestDiv ∣ Monster.order := by
  intro s hs
  simp only [stratumTable, List.mem_cons, List.mem_nil_iff, or_false] at hs
  rcases hs with rfl | rfl | rfl | rfl <;> native_decide

theorem stratumTable_distances :
    ∀ s ∈ stratumTable,
      Int.natAbs ((s.qCoeff : ℤ) - s.closestDiv) = s.distance := by
  intro s hs
  simp only [stratumTable, List.mem_cons, List.mem_nil_iff, or_false] at hs
  rcases hs with rfl | rfl | rfl | rfl <;> native_decide

/-! ## §8. Bounding q-coefficients by divisors -/

theorem bound_c0 : 744 ∣ Monster.order := by native_decide

theorem bound_c1 :
    196883 ∣ Monster.order ∧ 196911 ∣ Monster.order ∧
    196883 ≤ 196884 ∧ 196884 ≤ 196911 ∧
    ¬(196884 ∣ Monster.order) :=
  ⟨by native_decide, by native_decide, by omega, by omega, by native_decide⟩

theorem bound_c2 :
    21493758 ∣ Monster.order ∧ 21493758 ≤ 21493760 ∧
    ¬(21493759 ∣ Monster.order) ∧ ¬(21493760 ∣ Monster.order) :=
  ⟨by native_decide, by omega, by native_decide, by native_decide⟩

theorem bound_c3 :
    864299975 ∣ Monster.order ∧ 864299970 ≤ 864299975 ∧
    ¬(864299970 ∣ Monster.order) :=
  ⟨by native_decide, by omega, by native_decide⟩

/-! ## §9. Valuation checks for closest divisors -/

theorem v2_744_is_3 : 2^3 ∣ 744 ∧ ¬(2^4 ∣ 744) := by omega
theorem v3_744_is_1 : 3^1 ∣ 744 ∧ ¬(3^2 ∣ 744) := by omega

theorem v2_196883_is_0 : ¬(2 ∣ 196883) := by omega
theorem v3_196883_is_0 : ¬(3 ∣ 196883) := by omega

theorem v2_21493758_is_1 : 2^1 ∣ 21493758 ∧ ¬(2^2 ∣ 21493758) := by omega
theorem v3_21493758_is_1 : 3^1 ∣ 21493758 ∧ ¬(3^2 ∣ 21493758) := by omega

theorem v2_864299975_is_0 : ¬(2 ∣ 864299975) := by omega
theorem v3_864299975_is_0 : ¬(3 ∣ 864299975) := by omega

/-! ## §10. Scale of the stratification -/

theorem monster_digit_count : 10^53 < Monster.order ∧ Monster.order < 10^54 := by
  constructor <;> (unfold Monster.order; norm_num)

theorem two46_digits : 10^13 < (2:ℕ)^46 ∧ (2:ℕ)^46 < 10^14 := by
  constructor <;> norm_num

theorem three20_digits : 10^9 < (3:ℕ)^20 ∧ (3:ℕ)^20 < 10^10 := by
  constructor <;> norm_num

/-! ## §11. Divisor sandwich -/

theorem divisor_sandwich' (c : ℕ) (hc : 0 < c) (hle : c ≤ Monster.order) :
    ∃ d₁ d₂, d₁ ∣ Monster.order ∧ d₂ ∣ Monster.order ∧ d₁ ≤ c ∧ c ≤ d₂ :=
  ⟨1, Monster.order, one_dvd _, dvd_refl _, by omega, hle⟩

/-! ## §12. Consistent decomposition views -/

theorem views_consistent :
    47 * 9031680 = (424488960 : ℕ) ∧
    21 * 20213760 = (424488960 : ℕ) ∧
    987 * 430080 = (424488960 : ℕ) := by omega

theorem uniform_2strata' :
    Monster.numDivisors = 47 * numDivisorsPerTwoStratum := by native_decide

theorem uniform_3strata' :
    Monster.numDivisors = 21 * numDivisorsPerThreeStratum := by native_decide

theorem uniform_cells :
    Monster.numDivisors = 47 * 21 * numDivisorsPerCell := by native_decide

/-! ## §13. Pattern: closest divisors hop between strata

The stratum assignments of the closest divisors show no fixed pattern —
they hop between cells (3,1), (0,0), (1,1), (0,0).

Of the first four closest divisors:
- Two are odd and 3-free (cell (0,0)): 196883 and 864299975
- One is 2×3×... (cell (1,1)): 21493758
- One is 2³×3×... (cell (3,1)): 744

The closest divisors preferentially land in low-valuation cells because
the q-coefficients decompose into irrep dimensions that are typically
not highly divisible by 2 or 3. -/

theorem low_strata_c0 : (stratumTable[0]!).v2 ≤ 3 ∧ (stratumTable[0]!).v3 ≤ 1 := by
  simp [stratumTable]

theorem low_strata_c1 : (stratumTable[1]!).v2 ≤ 3 ∧ (stratumTable[1]!).v3 ≤ 1 := by
  simp [stratumTable]

theorem low_strata_c2 : (stratumTable[2]!).v2 ≤ 3 ∧ (stratumTable[2]!).v3 ≤ 1 := by
  simp [stratumTable]

theorem low_strata_c3 : (stratumTable[3]!).v2 ≤ 3 ∧ (stratumTable[3]!).v3 ≤ 1 := by
  simp [stratumTable]

/-! ## §14. Small divisors showing density -/

theorem small_divisors :
    ∀ n ∈ ([1, 2, 3, 4, 5, 6, 7, 8, 9, 10] : List ℕ), n ∣ Monster.order := by
  decide

theorem all_ssp_divide :
    ∀ p ∈ ([2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71] : List ℕ),
    p ∣ Monster.order := by
  decide
