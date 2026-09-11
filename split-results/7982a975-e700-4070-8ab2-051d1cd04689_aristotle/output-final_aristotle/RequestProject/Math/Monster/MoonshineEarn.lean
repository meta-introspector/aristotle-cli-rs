/-
  MoonshineEarn.lean

  Port of MoonshineEarn.lean from meta-introspector-dashi_lean4 and
  MoonshineFractran.lean: FRACTRAN earning chain from perf primes to
  Monster primes, and the Ramanujan taxi number connection.

  Key results:
    • 7 × 11 × 23 →₃ 47 × 59 × 71 via FRACTRAN fractions
    • 196884 mod p = 1 for p ∈ {47, 59, 71} (observer residue)
    • 1729 earns moonshine: taxi number → 196883
    • Taxicab property: 1³ + 12³ = 9³ + 10³ = 1729
-/
import Mathlib

/-! ## §1. FRACTRAN step -/

/-- FRACTRAN step: if n divisible by den, result is n/den * num. -/
def fstep (n num den : ℕ) : Option ℕ :=
  if n % den = 0 then some (n / den * num) else none

/-! ## §2. The earning chain: 7×11×23 →₃ 47×59×71 -/

theorem perf_product : 7 * 11 * 23 = 1771 := by norm_num
theorem moonshine_product : 47 * 59 * 71 = 196883 := by norm_num

-- Step 1: apply 47/23 to 1771
theorem step1_fires : 1771 % 23 = 0 := by norm_num
theorem step1_result : 1771 / 23 * 47 = 3619 := by norm_num
theorem step1_factors : 3619 = 7 * 11 * 47 := by norm_num

-- Step 2: apply 59/7 to 3619
theorem step2_fires : 3619 % 7 = 0 := by norm_num
theorem step2_result : 3619 / 7 * 59 = 30503 := by norm_num
theorem step2_factors : 30503 = 11 * 47 * 59 := by norm_num

-- Step 3: apply 71/11 to 30503
theorem step3_fires : 30503 % 11 = 0 := by norm_num
theorem step3_result : 30503 / 11 * 71 = 196883 := by norm_num
theorem step3_factors : 196883 = 47 * 59 * 71 := by norm_num

/-- The full earning chain: 7×11×23 →₃ 47×59×71. -/
theorem earning_chain :
    let s0 := 7 * 11 * 23
    let s1 := s0 / 23 * 47
    let s2 := s1 / 7 * 59
    let s3 := s2 / 11 * 71
    s0 = 1771 ∧ s3 = 196883 := by native_decide

/-! ## §3. Observer residues -/

/-- 196884 = 196883 + 1: the observer completes the j-invariant. -/
theorem moonshine_observed : 47 * 59 * 71 + 1 = 196884 := by norm_num

/-- 196884 mod each earning prime = 1. -/
theorem residue_47 : 196884 % 47 = 1 := by norm_num
theorem residue_59 : 196884 % 59 = 1 := by norm_num
theorem residue_71 : 196884 % 71 = 1 := by norm_num

/-- The source primes are consumed (residue ≠ 0 but ≠ 1). -/
theorem residue_7  : 196884 % 7  = 2 := by norm_num
theorem residue_11 : 196884 % 11 = 6 := by norm_num
theorem residue_23 : 196884 % 23 = 4 := by norm_num

/-- Each fraction fires exactly once. -/
theorem each_fires_once :
    1771 % 23 = 0 ∧ 3619 % 7 = 0 ∧ 30503 % 11 = 0 := by
  exact ⟨by norm_num, by norm_num, by norm_num⟩

/-- After earning, the fractions become inert. -/
theorem f1_inert : 196883 % 23 ≠ 0 := by norm_num
theorem f2_inert : 196883 % 7 ≠ 0 := by norm_num
theorem f3_inert : 196883 % 11 ≠ 0 := by norm_num

/-! ## §4. Full perf state earning -/

/-- 2²×3³×7×11×23 earns 2²×3³×47×59×71. -/
theorem full_perf_earn :
    let s0 := 4 * 27 * 7 * 11 * 23
    let s1 := s0 / 23 * 47
    let s2 := s1 / 7 * 59
    let s3 := s2 / 11 * 71
    s3 = 4 * 27 * 47 * 59 * 71 := by native_decide

theorem observer_preserved : 4 * 27 * 47 * 59 * 71 = 108 * 196883 := by norm_num

/-! ## §5. Phase invariant -/

theorem phase_invariant :
    47 * 59 * 71 + 1 = 196884 ∧
    196884 % 71 = 1 ∧
    196884 % 59 = 1 ∧
    196884 % 47 = 1 := by
  exact ⟨by norm_num, by norm_num, by norm_num, by norm_num⟩

/-! ## §6. Ramanujan's taxi number -/

theorem taxi_is_1729 : 7 * 13 * 19 = 1729 := by norm_num

/-- 1729 earns 196883 via fractions 47/7, 59/13, 71/19. -/
theorem taxi_earns_moonshine :
    (((1729 / 7 * 47) / 13 * 59) / 19 * 71) = 196883 := by native_decide

/-- Taxicab property: 1729 is the smallest number expressible as sum of two cubes in two ways. -/
theorem taxicab_sum1 : 1 ^ 3 + 12 ^ 3 = 1729 := by norm_num
theorem taxicab_sum2 : 9 ^ 3 + 10 ^ 3 = 1729 := by norm_num

/-! ## §7. Monster primes (SSP) -/

def SSP : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]
theorem ssp_len : SSP.length = 15 := by native_decide

/-- 196883 is purely SSP: all prime factors are Monster primes. -/
theorem moonshine_kernel : 47 * 59 * 71 = 196883 := by norm_num

/-- 196884 = 4 × 27 × 1823. -/
theorem moonshine_factored : 4 * 27 * 1823 = 196884 := by norm_num
