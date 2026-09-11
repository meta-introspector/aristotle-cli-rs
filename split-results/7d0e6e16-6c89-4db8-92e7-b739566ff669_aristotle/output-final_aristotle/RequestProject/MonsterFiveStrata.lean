import Mathlib
import RequestProject.MonsterDivisorGroups

/-!
# 5⁹ Strata of the Monster Group Order

We extend the 2⁴⁶ and 3²⁰ divisor stratification to include 5⁹,
the third prime-power factor of |M| = 2⁴⁶ · 3²⁰ · 5⁹ · 7⁶ · … · 71.

## Divisor Stratification by 5

### By powers of 5: 10 strata (v₅ = 0, 1, …, 9)
Each stratum contains exactly 424,488,960 / 10 = **42,448,896** divisors.

### Joint (2,5)-strata: 47 × 10 = 470 cells
Each cell contains 424,488,960 / 470 = **903,168** divisors.

### Joint (3,5)-strata: 21 × 10 = 210 cells
Each cell contains 424,488,960 / 210 = **2,021,376** divisors.

### Full (2,3,5)-strata: 47 × 21 × 10 = 9870 cells
Each cell contains 424,488,960 / 9870 = **43,008** divisors.

## Pattern Observation

| n | cₙ          | Closest d*  | |cₙ−d*| | v₂(d*) | v₃(d*) | v₅(d*) | Cell (v₂,v₃,v₅) |
|---|-------------|-------------|---------|--------|--------|--------|------------------|
| 0 | 744         | 744         | 0       | 3      | 1      | 0      | (3, 1, 0)        |
| 1 | 196884      | 196883      | 1       | 0      | 0      | 0      | (0, 0, 0)        |
| 2 | 21493760    | 21493758    | 2       | 1      | 1      | 0      | (1, 1, 0)        |
| 3 | 864299970   | 864299975   | 5       | 0      | 0      | 2      | (0, 0, 2)        |

Closest divisors hop between low-valuation strata: three of the four have
v₅ = 0, while c₃'s closest divisor is the only one with v₅ = 2
(since 864299975 = 5² × 7⁵ × 11² × 17). This hopping pattern reflects
the fact that q-expansion coefficients decompose into irrep dimensions
which are typically not highly divisible by small primes.

## Uniform Stratum Sizes from Multiplicativity

The divisor function d(n) = ∏(eᵢ + 1) is multiplicative. For
|M| = 2⁴⁶ · 3²⁰ · 5⁹ · R where R is coprime to 2, 3, 5:
- Fixing v₅(d) = c removes the factor (9+1) = 10, giving d(R) × ∏ other = 42,448,896
- This is uniform across all c ∈ {0,…,9} by multiplicativity
- The triple (v₂,v₃,v₅) cell sizes are d(R) = 43,008, also uniform
-/

open scoped BigOperators Nat

set_option maxHeartbeats 800000

/-! ## §1. Factored parts involving 5 -/

/-- The 5-free part of |M|: |M| / 5⁹ -/
def Monster.fiveFreePart : ℕ :=
  2^46 * 3^20 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- The (2,3,5)-free part of |M|: |M| / (2⁴⁶ · 3²⁰ · 5⁹) -/
def Monster.free235 : ℕ :=
  7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

theorem Monster.order_eq_5pow_fiveFreePart :
    Monster.order = 5^9 * Monster.fiveFreePart := by
  unfold Monster.order Monster.fiveFreePart; ring

theorem Monster.order_eq_2pow_3pow_5pow_free235 :
    Monster.order = 2^46 * 3^20 * 5^9 * Monster.free235 := by
  unfold Monster.order Monster.free235; ring

theorem Monster.free235_coprime_2 : Nat.Coprime Monster.free235 2 := by native_decide
theorem Monster.free235_coprime_3 : Nat.Coprime Monster.free235 3 := by native_decide
theorem Monster.free235_coprime_5 : Nat.Coprime Monster.free235 5 := by native_decide
theorem Monster.free235_pos : 0 < Monster.free235 := by unfold Monster.free235; positivity

/-! ## §2. 5-stratum sizes -/

/-- Divisors per 5-stratum = 42,448,896 -/
def numDivisorsPerFiveStratum : ℕ :=
  (46 + 1) * (20 + 1) * (6 + 1) * (2 + 1) * (3 + 1) *
  (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) *
  (1 + 1) * (1 + 1) * (1 + 1)

theorem numDivisorsPerFiveStratum_val : numDivisorsPerFiveStratum = 42448896 := by
  native_decide

theorem five_stratum_size : Monster.numDivisors / 10 = numDivisorsPerFiveStratum := by
  native_decide

theorem total_from_5strata :
    10 * numDivisorsPerFiveStratum = Monster.numDivisors := by native_decide

theorem uniform_5strata :
    Monster.numDivisors = 10 * numDivisorsPerFiveStratum := by native_decide

/-! ## §3. Joint (2,5)-strata: 47 × 10 = 470 cells -/

/-- Divisors per (2,5)-cell = 903,168 -/
def numDivisorsPerTwoFiveCell : ℕ :=
  (20 + 1) * (6 + 1) * (2 + 1) * (3 + 1) *
  (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) *
  (1 + 1) * (1 + 1) * (1 + 1)

theorem numDivisorsPerTwoFiveCell_val : numDivisorsPerTwoFiveCell = 903168 := by
  native_decide

theorem num_twoFive_cells : 47 * 10 = 470 := by norm_num

theorem total_from_25cells :
    47 * 10 * numDivisorsPerTwoFiveCell = Monster.numDivisors := by native_decide

theorem uniform_25cells :
    Monster.numDivisors = 47 * 10 * numDivisorsPerTwoFiveCell := by native_decide

/-! ## §4. Joint (3,5)-strata: 21 × 10 = 210 cells -/

/-- Divisors per (3,5)-cell = 2,021,376 -/
def numDivisorsPerThreeFiveCell : ℕ :=
  (46 + 1) * (6 + 1) * (2 + 1) * (3 + 1) *
  (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) *
  (1 + 1) * (1 + 1) * (1 + 1)

theorem numDivisorsPerThreeFiveCell_val : numDivisorsPerThreeFiveCell = 2021376 := by
  native_decide

theorem num_threeFive_cells : 21 * 10 = 210 := by norm_num

theorem total_from_35cells :
    21 * 10 * numDivisorsPerThreeFiveCell = Monster.numDivisors := by native_decide

theorem uniform_35cells :
    Monster.numDivisors = 21 * 10 * numDivisorsPerThreeFiveCell := by native_decide

/-! ## §5. Full (2,3,5)-strata: 47 × 21 × 10 = 9870 cells -/

/-- Divisors per (2,3,5)-cell = 43,008

This is d(free235) = d(7⁶ · 11² · 13³ · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71)
= 7 × 3 × 4 × 2 × 2 × 2 × 2 × 2 × 2 × 2 × 2 × 2 = 43,008. -/
def numDivisorsPerTripleCell : ℕ :=
  (6 + 1) * (2 + 1) * (3 + 1) *
  (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) *
  (1 + 1) * (1 + 1) * (1 + 1)

theorem numDivisorsPerTripleCell_val : numDivisorsPerTripleCell = 43008 := by
  native_decide

theorem num_triple_cells : 47 * 21 * 10 = 9870 := by norm_num

theorem total_from_235cells :
    47 * 21 * 10 * numDivisorsPerTripleCell = Monster.numDivisors := by native_decide

theorem uniform_235cells :
    Monster.numDivisors = 47 * 21 * 10 * numDivisorsPerTripleCell := by native_decide

/-! ## §6. 5-stratum membership -/

/-- d belongs to 5-stratum c iff 5^c | d but 5^(c+1) ∤ d. -/
structure FiveStratum (d c : ℕ) : Prop where
  dvd_monster : d ∣ Monster.order
  pow_dvd : 5^c ∣ d
  pow_succ_ndvd : ¬(5^(c+1) ∣ d)

/-- d belongs to joint (2,3,5)-cell (a, b, c). -/
structure TripleCell (d a b c : ℕ) : Prop where
  two : TwoStratum d a
  three : ThreeStratum d b
  five : FiveStratum d c

/-! ## §7. Powers of 5 divide |M| -/

theorem five_pow_9_val : (5 : ℕ)^9 = 1953125 := by norm_num

theorem pow5_dvd_monster (c : ℕ) (hc : c ≤ 9) : 5^c ∣ Monster.order := by
  have : 5^c ∣ 5^9 := Nat.pow_dvd_pow 5 hc
  exact dvd_trans this (by rw [Monster.order_eq_5pow_fiveFreePart]; exact dvd_mul_right _ _)

theorem pow235_dvd_monster (a b c : ℕ) (ha : a ≤ 46) (hb : b ≤ 20) (hc : c ≤ 9) :
    2^a * 3^b * 5^c ∣ Monster.order := by
  rw [Monster.order_eq_2pow_3pow_5pow_free235]
  have h1 : 2^a ∣ 2^46 := Nat.pow_dvd_pow 2 ha
  have h2 : 3^b ∣ 3^20 := Nat.pow_dvd_pow 3 hb
  have h3 : 5^c ∣ 5^9 := Nat.pow_dvd_pow 5 hc
  calc 2^a * 3^b * 5^c
      ∣ 2^46 * 3^20 * 5^9 := by exact Nat.mul_dvd_mul (Nat.mul_dvd_mul h1 h2) h3
    _ ∣ 2^46 * 3^20 * 5^9 * Monster.free235 := dvd_mul_right _ _

/-! ## §8. Concrete triple-cell assignments for closest divisors -/

/-- c₀ = 744 = 2³ × 3 × 31, in triple cell (3, 1, 0). -/
theorem tripleCell_c0 : TripleCell 744 3 1 0 :=
  ⟨stratum_c0.two, stratum_c0.three,
   ⟨by native_decide, one_dvd _, fun h => by revert h; decide⟩⟩

/-- c₁ closest divisor: 196883 = 47 × 59 × 71, in triple cell (0, 0, 0). -/
theorem tripleCell_c1 : TripleCell 196883 0 0 0 :=
  ⟨stratum_c1.two, stratum_c1.three,
   ⟨by native_decide, one_dvd _, fun h => by revert h; decide⟩⟩

/-- c₂ closest divisor: 21493758 = 2 × 3 × 11 × 13² × 41 × 47, in triple cell (1, 1, 0). -/
theorem tripleCell_c2 : TripleCell 21493758 1 1 0 :=
  ⟨stratum_c2.two, stratum_c2.three,
   ⟨by native_decide, one_dvd _, fun h => by revert h; decide⟩⟩

/-- c₃ closest divisor: 864299975 = 5² × 7⁵ × 11² × 17, in triple cell (0, 0, 2). -/
theorem tripleCell_c3 : TripleCell 864299975 0 0 2 :=
  ⟨stratum_c3.two, stratum_c3.three,
   ⟨by native_decide, ⟨34571999, by norm_num⟩, fun h => by revert h; decide⟩⟩

/-! ## §9. 5-adic valuation checks -/

theorem v5_744_is_0 : ¬(5 ∣ 744) := by omega
theorem v5_196883_is_0 : ¬(5 ∣ 196883) := by omega
theorem v5_21493758_is_0 : ¬(5 ∣ 21493758) := by omega
theorem v5_864299975_is_2 : 5^2 ∣ 864299975 ∧ ¬(5^3 ∣ 864299975) := by omega

/-! ## §10. Scale of the 5⁹ factor -/

theorem five9_digits : 10^6 < (5:ℕ)^9 ∧ (5:ℕ)^9 < 10^7 := by
  constructor <;> norm_num

/-! ## §11. Extended stratum summary data -/

structure TripleStratumRecord where
  index : ℕ := 0
  qCoeff : ℕ := 0
  closestDiv : ℕ := 0
  distance : ℕ := 0
  v2 : ℕ := 0
  v3 : ℕ := 0
  v5 : ℕ := 0
  deriving Inhabited

def tripleStratumTable : List TripleStratumRecord :=
  [ ⟨0, 744,       744,       0, 3, 1, 0⟩,
    ⟨1, 196884,    196883,    1, 0, 0, 0⟩,
    ⟨2, 21493760,  21493758,  2, 1, 1, 0⟩,
    ⟨3, 864299970, 864299975, 5, 0, 0, 2⟩ ]

theorem tripleStratumTable_valid :
    ∀ s ∈ tripleStratumTable, s.closestDiv ∣ Monster.order := by
  intro s hs
  simp only [tripleStratumTable, List.mem_cons, List.mem_nil_iff, or_false] at hs
  rcases hs with rfl | rfl | rfl | rfl <;> native_decide

theorem tripleStratumTable_distances :
    ∀ s ∈ tripleStratumTable,
      Int.natAbs ((s.qCoeff : ℤ) - s.closestDiv) = s.distance := by
  intro s hs
  simp only [tripleStratumTable, List.mem_cons, List.mem_nil_iff, or_false] at hs
  rcases hs with rfl | rfl | rfl | rfl <;> native_decide

/-! ## §12. Pattern: closest divisors hop between low-valuation strata (with v₅)

With the 5-adic valuation added, the hopping pattern becomes even clearer:
- c₀: cell (3, 1, 0) — small primes 2, 3, 31
- c₁: cell (0, 0, 0) — entirely odd, 3-free, 5-free (47 × 59 × 71)
- c₂: cell (1, 1, 0) — one factor each of 2, 3 but 5-free
- c₃: cell (0, 0, 2) — odd, 3-free, but v₅ = 2 (5² × 7⁵ × 11² × 17)

Three out of four closest divisors are 5-free (v₅ = 0). The lone
exception (c₃) has only v₅ = 2 out of the possible 9. This confirms
the pattern: closest divisors cluster in low-valuation strata because
irrep dimensions (from which q-coefficients are built) tend to avoid
high powers of small primes.
-/

theorem low_5strata_c0 : (tripleStratumTable[0]!).v5 ≤ 2 := by simp [tripleStratumTable]
theorem low_5strata_c1 : (tripleStratumTable[1]!).v5 ≤ 2 := by simp [tripleStratumTable]
theorem low_5strata_c2 : (tripleStratumTable[2]!).v5 ≤ 2 := by simp [tripleStratumTable]
theorem low_5strata_c3 : (tripleStratumTable[3]!).v5 ≤ 2 := by simp [tripleStratumTable]

/-- All four closest divisors have v₅ ≤ 2, far below the maximum v₅ = 9 -/
theorem all_closest_low_v5 :
    ∀ s ∈ tripleStratumTable, s.v5 ≤ 2 := by
  intro s hs
  simp only [tripleStratumTable, List.mem_cons, List.mem_nil_iff, or_false] at hs
  rcases hs with rfl | rfl | rfl | rfl <;> simp

/-! ## §13. Uniform stratum sizes from multiplicativity of the divisor function

For a number n = p₁^e₁ · p₂^e₂ · … · pₖ^eₖ, the number of divisors is
d(n) = ∏ᵢ (eᵢ + 1). This is multiplicative: d(ab) = d(a)·d(b) when gcd(a,b) = 1.

For |M| = 2⁴⁶ · 3²⁰ · 5⁹ · R where R = 7⁶·11²·13³·17·19·23·29·31·41·47·59·71:
- d(|M|) = 47 · 21 · 10 · d(R) = 47 · 21 · 10 · 43,008 = 424,488,960
- Fixing v₂ = a removes one factor of 47: strata of size 21 · 10 · d(R) = 9,031,680 ✓
- Fixing v₃ = b removes one factor of 21: strata of size 47 · 10 · d(R) = 20,213,760 ✓
- Fixing v₅ = c removes one factor of 10: strata of size 47 · 21 · d(R) = 42,448,896 ✓
- Fixing (v₂,v₃) removes 47·21: cells of size 10 · d(R) = 430,080 ✓
- Fixing (v₂,v₅) removes 47·10: cells of size 21 · d(R) = 903,168 ✓
- Fixing (v₃,v₅) removes 21·10: cells of size 47 · d(R) = 2,021,376 ✓
- Fixing (v₂,v₃,v₅) removes 47·21·10: cells of size d(R) = 43,008 ✓

Each stratum has exactly the same number of divisors — this is a direct
consequence of multiplicativity. The total number of strata is:
- 47 two-strata, 21 three-strata, 10 five-strata
- 987 (2,3)-cells, 470 (2,5)-cells, 210 (3,5)-cells
- 9,870 (2,3,5)-cells
-/

/-- Multiplicativity check: d(|M|) = (46+1)·(20+1)·(9+1)·d(R) -/
theorem multiplicativity_decomp :
    Monster.numDivisors = 47 * 21 * 10 * numDivisorsPerTripleCell := by native_decide

/-- The consistent decomposition at all levels -/
theorem views_consistent_full :
    47 * numDivisorsPerTwoStratum = Monster.numDivisors ∧
    21 * numDivisorsPerThreeStratum = Monster.numDivisors ∧
    10 * numDivisorsPerFiveStratum = Monster.numDivisors ∧
    47 * 21 * numDivisorsPerCell = Monster.numDivisors ∧
    47 * 10 * numDivisorsPerTwoFiveCell = Monster.numDivisors ∧
    21 * 10 * numDivisorsPerThreeFiveCell = Monster.numDivisors ∧
    47 * 21 * 10 * numDivisorsPerTripleCell = Monster.numDivisors := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> native_decide

/-- Each single-prime stratum size = total / (exponent + 1) -/
theorem stratum_sizes_from_exponents :
    numDivisorsPerTwoStratum * 47 = Monster.numDivisors ∧
    numDivisorsPerThreeStratum * 21 = Monster.numDivisors ∧
    numDivisorsPerFiveStratum * 10 = Monster.numDivisors := by
  refine ⟨?_, ?_, ?_⟩ <;> native_decide

/-! ## §14. Max element in each 5-stratum -/

theorem max_in_5stratum (c : ℕ) (hc : c ≤ 9) :
    5^c * Monster.fiveFreePart ∣ Monster.order := by
  rw [Monster.order_eq_5pow_fiveFreePart]
  exact Nat.mul_dvd_mul (Nat.pow_dvd_pow 5 hc) dvd_rfl
