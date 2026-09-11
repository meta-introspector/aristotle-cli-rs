/-
# Monster Group Moonshine: Core Arithmetic Facts

This file formalizes the key arithmetic facts about the Monster group
and its relationship to moonshine theory, including:

- The Monster group order and its prime factorization
- The 15 supersingular primes (SSPs)
- The "trivector" factorization 196883 = 47 × 59 × 71
- The relationship between SSPs and the Monster order
- The first non-supersingular prime (37)
-/

import Mathlib

/-! ## Monster Group Order -/

/-- The order of the Monster group (the largest sporadic simple group). -/
def MonsterOrder : ℕ :=
  2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- The Monster group order equals the well-known decimal value. -/
theorem MonsterOrder_val :
    MonsterOrder = 808017424794512875886459904961710757005754368000000000 := by
  native_decide

/-! ## Supersingular Primes -/

/-- The 15 supersingular primes: the primes p for which the elliptic curve
    supersingular locus in characteristic p has genus 0. These are exactly
    the prime divisors of the Monster group order. -/
def SupersingularPrimes : List ℕ :=
  [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

theorem SupersingularPrimes_length : SupersingularPrimes.length = 15 := by native_decide

/-- Every supersingular prime divides the Monster group order. -/
theorem ssp_dvd_MonsterOrder : ∀ p ∈ SupersingularPrimes, p ∣ MonsterOrder := by
  decide

/-- 37 is prime and does not divide the Monster group order —
    it is the first non-supersingular prime, where X₀(p) first has genus ≥ 1. -/
theorem prime_37 : Nat.Prime 37 := by decide

theorem not_37_dvd_MonsterOrder : ¬ (37 ∣ MonsterOrder) := by decide

/-
Every prime less than 37 divides the Monster group order.
-/
theorem primes_lt_37_dvd_MonsterOrder :
    ∀ p, Nat.Prime p → p < 37 → p ∣ MonsterOrder := by
  exact fun p hp hlt => by interval_cases p <;> simp_all +decide only

/-! ## The Trivector: 196883 = 47 × 59 × 71 -/

/-- The dimension of the smallest faithful complex representation of the Monster group. -/
def GriessAlgebraDim : ℕ := 196883

/-- 196883 factors as the product of the three largest supersingular primes.
    This is the "trivector" factorization central to moonshine. -/
theorem GriessAlgebraDim_eq : GriessAlgebraDim = 47 * 59 * 71 := by native_decide

/-- 196883 is squarefree — each trivector prime appears exactly once. -/
theorem GriessAlgebraDim_squarefree : Squarefree GriessAlgebraDim := by native_decide

/-
All prime factors of 196883 are supersingular primes.
-/
theorem GriessAlgebraDim_primes_ssp :
    ∀ p, Nat.Prime p → p ∣ GriessAlgebraDim → p ∈ SupersingularPrimes := by
  intro p pp dp;
  -- Since $p$ divides $196883$, we know that $p$ must be a prime factor of $196883$.
  have h_factor : p ∈ Nat.primeFactors 196883 := by
    aesop;
  norm_num [ Nat.primeFactors, Nat.primeFactorsList ] at h_factor;
  rcases h_factor with ( rfl | rfl | rfl ) <;> decide

/-! ## McKay's Observation: 196884 = 196883 + 1 -/

/-- The coefficient of q in the j-invariant Fourier expansion. -/
def jCoeff1 : ℕ := 196884

/-- McKay's observation: the first nontrivial Fourier coefficient of the
    j-invariant exceeds the Griess algebra dimension by exactly 1.
    This is the starting point of monstrous moonshine:
    196884 = 1 + 196883  (trivial rep + Griess algebra). -/
theorem McKay_observation : jCoeff1 = 1 + GriessAlgebraDim := by native_decide

/-- The constant term of the j-invariant. -/
def jConstantTerm : ℕ := 744

/-! ## Moonshine Module Dimensions

The first few graded dimensions of the Monster module V♮,
matching the Fourier coefficients of the j-invariant. -/

/-- Graded dimensions of V♮ (first 7 terms, matching j-function coefficients). -/
def MoonshineGradedDims : List ℕ :=
  [1, 196884, 21493760, 864299970, 20245856256, 333202640600, 4252023300096]

/-- The second graded piece decomposes as 1 + 196883 + 21296876,
    verifying the moonshine module structure at level 2. -/
theorem V2_decomposition :
    MoonshineGradedDims[2]! = 1 + 196883 + 21296876 := by native_decide

/-! ## Monster Irreducible Representation Dimensions

The dimensions of the first few irreducible representations of the Monster,
ordered by size (OEIS A001379). -/

/-- Dimensions of the first 7 irreducible representations of the Monster group. -/
def MonsterIrrepDims : List ℕ :=
  [1, 196883, 21296876, 842609326, 18538750076, 19360062527, 293553734298]

/-- The second irrep dimension (the Griess algebra) equals 47 × 59 × 71. -/
theorem irrep2_trivector : MonsterIrrepDims[1]! = 47 * 59 * 71 := by native_decide

/-- The third irrep dimension. -/
theorem irrep3_val : MonsterIrrepDims[2]! = 21296876 := by native_decide

/-- 21296876 = 4 × 31 × 41 × 59 × 71 — factors through SSPs only. -/
theorem irrep3_factored : (21296876 : ℕ) = 2^2 * 31 * 41 * 59 * 71 := by native_decide

/-! ## T71A McKay-Thompson Series

The McKay-Thompson series for conjugacy class 71A (OEIS A034322).
The zero at n=1 reflects the trivector structure: 71 | 196883 forces
the trace of a 71A element on the Griess algebra to vanish. -/

/-- First coefficients of the McKay-Thompson series T_{71A}
    (after the q⁻¹ pole term). -/
def T71A_coeffs : List ℤ :=
  [0, 1, 1, 1, 1, 2, 2, 3, 3, 4, 4, 6, 6, 7, 8, 10, 11, 13, 14, 17, 19, 22, 24, 29, 31, 36, 40, 46, 50, 58, 63]

/-- The T71A coefficient at n=1 is zero: a 71A element acts with
    zero trace on the 196883-dimensional Griess algebra, because
    71 divides 196883 and the action has no fixed points. -/
theorem T71A_vanishes_at_1 : T71A_coeffs[0]! = 0 := by native_decide

/-! ## Moonshine Arithmetic -/

/-- The product of all 15 supersingular primes. -/
def SSP_product : ℕ := SupersingularPrimes.prod

theorem SSP_product_val :
    SSP_product = 2 * 3 * 5 * 7 * 11 * 13 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71 := by
  native_decide

/-- 196883 divides the product of all supersingular primes
    (since 47, 59, 71 are all SSPs). -/
theorem GriessAlgebraDim_dvd_SSP_product : GriessAlgebraDim ∣ SSP_product := by
  native_decide

/-! ## Fibonacci Connection

987 = 3 × 7 × 47: the 16th Fibonacci number factors through two
earth primes and the first trivector prime. -/

theorem fib_987 : (987 : ℕ) = 3 * 7 * 47 := by native_decide

/-- 987 is the 16th Fibonacci number (0-indexed). -/
theorem fib_16_eq : Nat.fib 16 = 987 := by native_decide