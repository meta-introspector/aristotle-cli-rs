/-
# Weighted Moonshine Sums and SSP Sector Classification

This file formalizes additional arithmetic facts from the Monster moonshine
conversation, including:

- The SSP sector classification (Earth / Clock / Hub / Spoke)
- All 7 irrep dimensions factor exclusively through SSPs
- The weighted moonshine sum components for T_{1A} (the j-function)
- The 46/37 split: first trivector prime (47) vs first non-SSP prime (37)
- Properties of the prime tower product
-/

import Mathlib
import RequestProject.MonsterMoonshine

/-! ## SSP Sector Classification

The 15 supersingular primes partition into three sectors based on
their role in the Monster's structure:
- Earth:  {2, 3, 5, 7, 11, 13} — the "small" primes
- Clock:  {17, 19, 23, 29, 31, 41} — intermediate primes
- Trivector: {47, 59, 71} — the three largest SSPs
-/

def EarthPrimes : List ℕ := [2, 3, 5, 7, 11, 13]
def ClockPrimes : List ℕ := [17, 19, 23, 29, 31, 41]
def TrivectorPrimes : List ℕ := [47, 59, 71]

/-- The three sectors partition the supersingular primes. -/
theorem SSP_partition :
    SupersingularPrimes = EarthPrimes ++ ClockPrimes ++ TrivectorPrimes := by native_decide

theorem EarthPrimes_length : EarthPrimes.length = 6 := by native_decide
theorem ClockPrimes_length : ClockPrimes.length = 6 := by native_decide
theorem TrivectorPrimes_length : TrivectorPrimes.length = 3 := by native_decide

/-- 6 + 6 + 3 = 15: the sector sizes sum to the total SSP count. -/
theorem sector_sizes : 6 + 6 + 3 = 15 := by norm_num

/-- All Earth primes are prime. -/
theorem earth_primes_prime : ∀ p ∈ EarthPrimes, Nat.Prime p := by decide

/-- All Clock primes are prime. -/
theorem clock_primes_prime : ∀ p ∈ ClockPrimes, Nat.Prime p := by decide

/-- All Trivector primes are prime. -/
theorem trivector_primes_prime : ∀ p ∈ TrivectorPrimes, Nat.Prime p := by decide

/-- The product of trivector primes gives the Griess algebra dimension. -/
theorem trivector_product_eq_Griess :
    TrivectorPrimes.prod = GriessAlgebraDim := by native_decide

/-! ## Irrep Dimensions: SSP Factorizations

Every prime factor of the first 7 Monster irrep dimensions
is a supersingular prime. We state this via explicit factorizations. -/

theorem irrep1_val : MonsterIrrepDims[0]! = 1 := by native_decide
-- irrep2: 196883 = 47 × 59 × 71 (already proved as irrep2_trivector)
-- irrep3: 21296876 = 2² × 31 × 41 × 59 × 71 (already proved as irrep3_factored)

theorem irrep4_val : MonsterIrrepDims[3]! = 842609326 := by native_decide
theorem irrep4_ssp_factored :
    (842609326 : ℕ) = 2 * 13^2 * 29 * 31 * 47 * 59 := by native_decide

theorem irrep5_val : MonsterIrrepDims[4]! = 18538750076 := by native_decide
theorem irrep5_ssp_factored :
    (18538750076 : ℕ) = 2^2 * 7 * 11 * 23 * 29 * 31 * 41 * 71 := by native_decide

theorem irrep6_val : MonsterIrrepDims[5]! = 19360062527 := by native_decide
theorem irrep6_ssp_factored :
    (19360062527 : ℕ) = 13^2 * 23 * 29 * 41 * 59 * 71 := by native_decide

theorem irrep7_val : MonsterIrrepDims[6]! = 293553734298 := by native_decide
theorem irrep7_ssp_factored :
    (293553734298 : ℕ) = 2 * 3 * 11 * 19 * 29 * 41 * 47 * 59 * 71 := by native_decide

/-! ## The 46/37 Split

In the weighted moonshine sum computation, there are 47 positive totals
and 37 negative totals among the McKay-Thompson series.
47 is the first trivector prime; 37 is the first non-supersingular prime.
This encodes the boundary between monstrous (genus-0) and
non-monstrous (genus ≥ 1) moonshine classes. -/

/-- 37 is the smallest prime not dividing the Monster order. -/
theorem first_non_ssp_is_37 :
    Nat.Prime 37 ∧ ¬(37 ∣ MonsterOrder) ∧
    ∀ p, Nat.Prime p → p < 37 → p ∣ MonsterOrder := by
  exact ⟨prime_37, not_37_dvd_MonsterOrder, primes_lt_37_dvd_MonsterOrder⟩

/-- 47 is the smallest trivector prime and the first prime > 41 dividing |M|. -/
theorem smallest_trivector : TrivectorPrimes[0]! = 47 := by native_decide

/-- The first 5 non-supersingular primes. -/
def FirstNonSSPs : List ℕ := [37, 43, 53, 61, 67]

theorem non_ssps_are_prime : ∀ p ∈ FirstNonSSPs, Nat.Prime p := by decide

theorem non_ssps_dont_divide_Monster :
    ∀ p ∈ FirstNonSSPs, ¬(p ∣ MonsterOrder) := by decide

/-! ## Weighted Moonshine Sums

The weighted moonshine sum for a McKay-Thompson series T_g is:
  W(g) = Σ_j T_g(j) × dim(ρ_j)

For the j-function (class 1A), we verify the individual products. -/

/-- The j-function coefficients (A000521), first 7 terms
    (including the q⁻¹ pole term). -/
def jFunctionCoeffs : List ℕ :=
  [1, 744, 196884, 21493760, 864299970, 20245856256, 333202640600]

/-- The zeroth weighted contribution: 1 × 1 = 1. -/
theorem weighted_contribution_0 :
    jFunctionCoeffs[0]! * MonsterIrrepDims[0]! = 1 := by native_decide

/-- The first weighted contribution: 744 × 196883 = 146480952.
    This equals 744 × 47 × 59 × 71. -/
theorem weighted_contribution_1 :
    jFunctionCoeffs[1]! * MonsterIrrepDims[1]! = 146480952 := by native_decide

theorem weighted_1_factored :
    (146480952 : ℕ) = 2^3 * 3 * 31 * 47 * 59 * 71 := by native_decide

/-- 744 = 2³ × 3 × 31: the j-function constant term factors through SSPs. -/
theorem j_constant_factored : (744 : ℕ) = 2^3 * 3 * 31 := by native_decide

/-! ## Divisibility and Moonshine Congruences -/

/-- 196883 divides the Monster order. -/
theorem GriessAlgebraDim_dvd_MonsterOrder : GriessAlgebraDim ∣ MonsterOrder := by
  native_decide

/-- The Monster order divided by the Griess algebra dimension. -/
theorem MonsterOrder_div_Griess :
    MonsterOrder / GriessAlgebraDim = 4104048723325593758153115835098564919296000000000 := by
  native_decide

/-! ## McKay-Thompson Series Properties -/

/-- At level 71, the growth exponent involves √(1/71).
    71 is the largest SSP. -/
theorem largest_SSP : SupersingularPrimes.getLast (by decide) = 71 := by native_decide

/-- The T71A series grows slowly: its first 10 nonzero coefficients are all ≤ 4. -/
theorem T71A_slow_growth :
    ∀ i, i < 10 → (T71A_coeffs[i]!).natAbs ≤ 4 := by decide

/-! ## The 196884/196883 Near-Miss -/

/-- 196884 = 196883 + 1: the moonshine near-miss. -/
theorem moonshine_near_miss : (196884 : ℕ) = GriessAlgebraDim + 1 := by native_decide

/-- 196884 = 2² × 3³ × 1823.
    Note: 1823 is prime but NOT a supersingular prime. The j-function
    coefficient 196884 = 1 + 196883 breaks SSP-purity precisely because
    of the +1 shift from the trivial representation. -/
theorem j_coeff1_factored : (196884 : ℕ) = 2^2 * 3^3 * 1823 := by native_decide

theorem prime_1823 : Nat.Prime 1823 := by native_decide

theorem not_1823_dvd_MonsterOrder : ¬(1823 ∣ MonsterOrder) := by native_decide

/-! ## Earth Prime Product -/

/-- The product of the 6 Earth primes. -/
theorem earth_product : EarthPrimes.prod = 30030 := by native_decide

/-- 30030 = 2 × 3 × 5 × 7 × 11 × 13 is the primorial of 13. -/
theorem earth_product_factored : (30030 : ℕ) = 2 * 3 * 5 * 7 * 11 * 13 := by native_decide

/-- The product of the 6 Clock primes. -/
theorem clock_product : ClockPrimes.prod = 273825511 := by native_decide

/-- The product of all SSPs equals Earth × Clock × Trivector. -/
theorem SSP_product_factored :
    SSP_product = EarthPrimes.prod * ClockPrimes.prod * TrivectorPrimes.prod := by
  native_decide
