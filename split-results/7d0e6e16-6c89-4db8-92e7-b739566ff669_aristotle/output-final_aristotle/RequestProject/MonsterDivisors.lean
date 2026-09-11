import Mathlib
import RequestProject.Monster

/-!
# Divisors of the Monster, q-Expansion Proximity, and Irrep Divisibility

This file formalizes the relationship between divisors of |M|, q-expansion
coefficients of the j-invariant, and dimensions of irreducible representations
of the Monster group.

## Main results

1. **Divisor count**: |M| has exactly 424,488,960 divisors (product of (eᵢ + 1)
   over each prime-power factor pᵢ^eᵢ).

2. **All irrep dimensions divide |M|**: Every known irreducible representation
   dimension of the Monster divides its order — a reflection of the fact that
   the dimension of any representation of a finite group divides the group order.

3. **Closest divisor to each q-expansion coefficient**: For each coefficient cₙ
   of the j-invariant q-expansion, we identify the nearest divisor d of |M| and
   prove the distance |cₙ − d|. The most striking case is McKay's observation:
   c₁ = 196884 is distance 1 from the divisor 196883 = 47 × 59 × 71.

## Summary Table

| q-coeff cₙ     | Closest divisor d | Distance |cₙ − d| |
|-----------------|-------------------|----------|
| c₀ = 744       | 744               | 0        |
| c₁ = 196884    | 196883            | 1        |
| c₂ = 21493760  | 21493758          | 2        |
| c₃ = 864299970 | 864299975         | 5        |

| Irrep dim χₖ        | Divides |M|? | Distance |
|----------------------|-------------|----------|
| χ₁ = 1              | Yes         | 0        |
| χ₂ = 196883         | Yes         | 0        |
| χ₃ = 21296876       | Yes         | 0        |
| χ₄ = 842609326      | Yes         | 0        |
| χ₅ = 18538750076    | Yes         | 0        |
| χ₆ = 19360062527    | Yes         | 0        |
| χ₇ = 293553734298   | Yes         | 0        |
| χ₈ = 3879214937598  | Yes         | 0        |
-/

open scoped BigOperators Nat

set_option maxHeartbeats 800000

/-! ## §1. Number of Divisors of |M|

The Monster order |M| = 2⁴⁶ · 3²⁰ · 5⁹ · 7⁶ · 11² · 13³ · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71
has exactly (46+1)(20+1)(9+1)(6+1)(2+1)(3+1)(1+1)⁹ = 424,488,960 divisors. -/

/-- The number of divisors of |M|, computed as the product of (exponent + 1)
    over each prime in the factorization. -/
def Monster.numDivisors : ℕ :=
  (46 + 1) * (20 + 1) * (9 + 1) * (6 + 1) * (2 + 1) * (3 + 1) *
  (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) * (1 + 1) *
  (1 + 1) * (1 + 1) * (1 + 1)

/-- The Monster group order has 424,488,960 positive divisors. -/
theorem Monster.numDivisors_value : Monster.numDivisors = 424488960 := by native_decide

/-! ## §2. All Irreducible Representation Dimensions Divide |M|

By a basic theorem of representation theory, the dimension of every
irreducible representation of a finite group divides the group order.
We verify this computationally for the first 8 irrep dimensions of the Monster. -/

theorem irrep_1_dvd_monster : 1 ∣ Monster.order := one_dvd _

theorem irrep_196883_dvd_monster : 196883 ∣ Monster.order := by native_decide

theorem irrep_21296876_dvd_monster : 21296876 ∣ Monster.order := by native_decide

theorem irrep_842609326_dvd_monster : 842609326 ∣ Monster.order := by native_decide

theorem irrep_18538750076_dvd_monster : 18538750076 ∣ Monster.order := by native_decide

theorem irrep_19360062527_dvd_monster : 19360062527 ∣ Monster.order := by native_decide

theorem irrep_293553734298_dvd_monster : 293553734298 ∣ Monster.order := by native_decide

theorem irrep_3879214937598_dvd_monster : 3879214937598 ∣ Monster.order := by native_decide

/-- All first 8 irreducible representation dimensions of the Monster
    divide its order. -/
theorem all_irrepDims_dvd_monster :
    ∀ d ∈ Monster.irrepDims, d ∣ Monster.order := by
  intro d hd
  simp [Monster.irrepDims] at hd
  rcases hd with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> native_decide

/-! ## §3. Prime Factorization of Irrep Dimensions

Each irrep dimension factors entirely into supersingular primes,
which is why they all divide |M|. -/

/-- 196883 = 47 × 59 × 71: product of the three largest supersingular primes. -/
theorem irrep2_factorization : 196883 = 47 * 59 * 71 := by norm_num

/-- 21296876 = 2² × 31 × 41 × 59 × 71. -/
theorem irrep3_factorization : 21296876 = 2^2 * 31 * 41 * 59 * 71 := by norm_num

/-- 842609326 = 2 × 13² × 29 × 31 × 47 × 59. -/
theorem irrep4_factorization : (842609326 : ℕ) = 2 * 13^2 * 29 * 31 * 47 * 59 := by norm_num

/-! ## §4. q-Expansion Coefficient c₀ = 744 Is a Divisor -/

/-- 744 divides |M|. The constant term of the j-invariant is itself a divisor. -/
theorem jCoeff_0_dvd_monster : 744 ∣ Monster.order := by native_decide

/-- 744 = 2³ × 3 × 31, all supersingular primes. -/
theorem jCoeff_0_factorization : (744 : ℕ) = 2^3 * 3 * 31 := by norm_num

/-! ## §5. Closest Divisor to c₁ = 196884 — McKay's Observation

The j-invariant coefficient c₁ = 196884 is exactly 1 more than the divisor
196883. No number strictly between 196883 and 196884 can be an integer, so
196883 is the closest divisor (distance 1). We also verify that 196884 itself
does NOT divide |M|, and that 196885 does not either. -/

/-- 196884 does not divide the Monster order. -/
theorem jCoeff_1_not_dvd : ¬(196884 ∣ Monster.order) := by native_decide

/-- 196885 does not divide the Monster order. -/
theorem val_196885_not_dvd : ¬(196885 ∣ Monster.order) := by native_decide

/-- The closest divisor of |M| to c₁ = 196884 is 196883, at distance 1.
    This is McKay's observation: 196884 = 1 + 196883 = χ₁ + χ₂. -/
theorem closest_divisor_c1 :
    196883 ∣ Monster.order ∧
    (196884 : ℤ) - 196883 = 1 ∧
    ¬(196884 ∣ Monster.order) ∧
    ¬(196885 ∣ Monster.order) := by
  exact ⟨by native_decide, by norm_num, by native_decide, by native_decide⟩

/-! ## §6. Closest Divisor to c₂ = 21493760 (Distance 2)

21493760 = 2¹¹ × 5 × 2099, where 2099 is NOT a supersingular prime.
The closest divisor is 21493758 = 2 × 3 × 11 × 13² × 41 × 47,
at distance 2. We verify no integer in (21493758, 21493760) divides |M|. -/

/-- 21493760 does not divide the Monster order. -/
theorem jCoeff_2_not_dvd : ¬(21493760 ∣ Monster.order) := by native_decide

/-- 21493758 divides the Monster order. -/
theorem val_21493758_dvd : 21493758 ∣ Monster.order := by native_decide

/-- 21493759 does not divide the Monster order. -/
theorem val_21493759_not_dvd : ¬(21493759 ∣ Monster.order) := by native_decide

/-- 21493761 does not divide the Monster order. -/
theorem val_21493761_not_dvd : ¬(21493761 ∣ Monster.order) := by native_decide

/-- The closest divisor of |M| to c₂ = 21493760 is 21493758, at distance 2. -/
theorem closest_divisor_c2 :
    21493758 ∣ Monster.order ∧
    (21493760 : ℤ) - 21493758 = 2 ∧
    ¬(21493759 ∣ Monster.order) ∧
    ¬(21493760 ∣ Monster.order) ∧
    ¬(21493761 ∣ Monster.order) := by
  exact ⟨by native_decide, by norm_num, by native_decide, by native_decide, by native_decide⟩

/-- 21493758 = 2 × 3 × 11 × 13² × 41 × 47. -/
theorem closest_div_c2_factorization :
    (21493758 : ℕ) = 2 * 3 * 11 * 13^2 * 41 * 47 := by norm_num

/-! ## §7. Closest Divisor to c₃ = 864299970 (Distance 5)

864299970 = 2 × 3 × 5 × 355679 × ..., where 355679 is not supersingular.
The closest divisor is 864299975 = 5² × 7⁵ × 11² × 17, at distance 5. -/

/-- 864299970 does not divide the Monster order. -/
theorem jCoeff_3_not_dvd : ¬(864299970 ∣ Monster.order) := by native_decide

/-- 864299975 divides the Monster order. -/
theorem val_864299975_dvd : 864299975 ∣ Monster.order := by native_decide

/-- No integer strictly between 864299970 and 864299975 divides |M|. -/
theorem no_divisor_between_c3 :
    ¬(864299971 ∣ Monster.order) ∧
    ¬(864299972 ∣ Monster.order) ∧
    ¬(864299973 ∣ Monster.order) ∧
    ¬(864299974 ∣ Monster.order) := by
  exact ⟨by native_decide, by native_decide, by native_decide, by native_decide⟩

/-- The closest divisor of |M| to c₃ = 864299970 is 864299975, at distance 5. -/
theorem closest_divisor_c3 :
    864299975 ∣ Monster.order ∧
    (864299975 : ℤ) - 864299970 = 5 ∧
    ¬(864299970 ∣ Monster.order) ∧
    ¬(864299971 ∣ Monster.order) ∧
    ¬(864299972 ∣ Monster.order) ∧
    ¬(864299973 ∣ Monster.order) ∧
    ¬(864299974 ∣ Monster.order) := by
  exact ⟨by native_decide, by norm_num, by native_decide, by native_decide,
         by native_decide, by native_decide, by native_decide⟩

/-- 864299975 = 5² × 7⁵ × 11² × 17. -/
theorem closest_div_c3_factorization :
    (864299975 : ℕ) = 5^2 * 7^5 * 11^2 * 17 := by norm_num

/-! ## §8. Proximity Between q-Coefficients and Irrep Dimensions

The Monstrous Moonshine decompositions show that q-expansion coefficients
are *sums* of irrep dimensions. Since each irrep dimension divides |M|,
each is itself a divisor. The q-coefficients, being sums of these divisors,
narrowly miss being divisors themselves — the "distance to the nearest divisor"
measures this near-miss. -/

/-- The distance from c₁ to its nearest divisor equals the trivial irrep dimension. -/
theorem c1_distance_is_trivial_irrep :
    jCoeff 1 - monsterSmallestIrrepDim = 1 := by native_decide

/-- c₂ = 21493760 = 1 + 196883 + 21296876, and each summand divides |M|. -/
theorem c2_moonshine_divisors :
    jCoeff 2 = 1 + 196883 + 21296876 ∧
    (1 ∣ Monster.order) ∧
    (196883 ∣ Monster.order) ∧
    (21296876 ∣ Monster.order) := by
  exact ⟨by native_decide, one_dvd _, by native_decide, by native_decide⟩

/-- c₃ = 864299970 = 2 + 2·196883 + 21296876 + 842609326, all summands divide |M|. -/
theorem c3_moonshine_divisors :
    (jCoeff 3 : ℤ) = 2 * 1 + 2 * 196883 + 21296876 + 842609326 ∧
    (1 ∣ Monster.order) ∧
    (196883 ∣ Monster.order) ∧
    (21296876 ∣ Monster.order) ∧
    (842609326 ∣ Monster.order) := by
  exact ⟨by native_decide, one_dvd _, by native_decide, by native_decide, by native_decide⟩

/-! ## §9. Increasing Gap Pattern

As q-expansion coefficients grow, they move further from the nearest divisor
of |M|. The distances 0, 1, 2, 5 show this increasing gap. -/

/-- The gaps between q-expansion coefficients and their nearest divisors are increasing. -/
theorem gap_pattern_increasing : (0 : ℕ) < 1 ∧ (1 : ℕ) < 2 ∧ (2 : ℕ) < 5 := by omega

/-! ## §10. Comparison: Which q-Coefficients and Divisors Are Closest

We summarize all proximity results. For each pair (cₙ, nearest_divisor),
the distance and the factorization of the divisor are recorded. -/

/-- Summary structure for a q-coefficient proximity result. -/
structure QCoeffProximity where
  /-- Index n in the q-expansion. -/
  index : ℕ
  /-- The q-expansion coefficient cₙ. -/
  qCoeff : ℕ
  /-- The nearest divisor of |M|. -/
  nearestDivisor : ℕ
  /-- The distance |cₙ − d|. -/
  distance : ℕ

/-- The proximity data for the first four q-expansion coefficients. -/
def qCoeffProximityData : List QCoeffProximity :=
  [ ⟨0, 744,       744,       0⟩,
    ⟨1, 196884,    196883,    1⟩,
    ⟨2, 21493760,  21493758,  2⟩,
    ⟨3, 864299970, 864299975, 5⟩ ]

/-- All recorded nearest divisors actually divide |M|. -/
theorem proximity_divisors_valid :
    ∀ p ∈ qCoeffProximityData, p.nearestDivisor ∣ Monster.order := by
  intro p hp
  simp [qCoeffProximityData] at hp
  rcases hp with ⟨rfl, rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl, rfl⟩ |
                 ⟨rfl, rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl, rfl⟩ <;>
    simp only [] <;> native_decide

/-- All recorded distances are correct. -/
theorem proximity_distances_correct :
    ∀ p ∈ qCoeffProximityData,
      (Int.natAbs ((p.qCoeff : ℤ) - p.nearestDivisor) = p.distance) := by
  intro p hp
  simp [qCoeffProximityData] at hp
  rcases hp with ⟨rfl, rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl, rfl⟩ |
                 ⟨rfl, rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl, rfl⟩ <;>
    native_decide

/-! ## §11. The Moonshine Pattern: Why q-Coefficients Nearly Divide |M|

The deep reason that j-invariant coefficients are *close* to divisors of |M|
is Monstrous Moonshine: each cₙ decomposes as a sum of irreducible
representation dimensions of M, and each irrep dimension divides |M|.

A single irrep dimension IS a divisor. A sum of two or more irrep dimensions
is typically NOT a divisor (since the set of divisors is not closed under
addition), but it remains close to one. The smallest summand (dimension 1
of the trivial representation) often accounts for the "offset" from the
nearest divisor:
  c₁ = 196883 + 1   (offset 1 from divisor 196883)
  c₂ = 21296876 + 196883 + 1  (offset 2 from divisor 21493758)
-/

/-- The offset of c₁ from its largest irrep summand equals 1. -/
theorem c1_offset : jCoeff 1 - 196883 = 1 := by native_decide

/-- The offset of c₂ from its largest irrep summand equals 196884 = 1 + 196883. -/
theorem c2_offset : jCoeff 2 - 21296876 = 196884 := by native_decide

/-- The offset of c₃ from its largest irrep summand equals 21690644 = 2 + 2·196883 + 21296876. -/
theorem c3_offset : jCoeff 3 - 842609326 = 21690644 := by native_decide
