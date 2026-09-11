import Mathlib

/-!
# Monster-Adjacent Primes

We define the **Monster-adjacent primes**: primes that appear as factors of the
Fourier coefficients of the modular j-invariant but do *not* divide the order of
the Monster group.

## The Monster Group

The Monster group M is the largest sporadic finite simple group. Its order is
divisible by exactly 15 primes: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71.

## The j-invariant

The modular j-function has a q-expansion (OEIS A000521 / A014708):
  j(τ) = q⁻¹ + 744 + 196884q + 21493760q² + 864299970q³ + ⋯

The Monstrous Moonshine theorem (Borcherds, 1992) proves that each coefficient cₙ
is the dimension of the n-th graded piece of the Moonshine module V♮, and hence
decomposes as a sum of dimensions of irreducible Monster representations.

## Monster-adjacent primes

At each depth n, the coefficient cₙ may have prime factors that do not divide |M|.
We call these the **Monster-adjacent primes at depth n**. The union over all depths
forms the infinite structured set of Monster-adjacent primes.

## OEIS reference

The coefficients used here are from OEIS A014708 (J = j − 744, McKay-Thompson
series of class 1A for the Monster group). The first 16 nontrivial coefficients
(a(1) through a(16)) are:
  196884, 21493760, 864299970, 20245856256, 333202640600,
  4252023300096, 44656994071935, 401490886656000, 3176440229784420,
  22567393309593600, 146211911499519294, 874313719685775360,
  4872010111798142520, 25497827389410525184, 126142916465781843075,
  593121772421445058560
-/

open Finset in
/-- The 15 primes dividing the order of the Monster group. -/
def monsterPrimes : Finset ℕ :=
  {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71}

/-- The coefficients of the q-expansion of the modular j-invariant,
    j(τ) = q⁻¹ + 744 + Σₙ₌₁^∞ c(n) qⁿ.

    We define the first 16 coefficients from OEIS A014708.
    A full definition would require the theory of modular forms. -/
def jCoefficient : ℕ → ℕ
  | 0  => 744               -- constant term
  | 1  => 196884
  | 2  => 21493760
  | 3  => 864299970
  | 4  => 20245856256
  | 5  => 333202640600
  | 6  => 4252023300096
  | 7  => 44656994071935
  | 8  => 401490886656000
  | 9  => 3176440229784420
  | 10 => 22567393309593600
  | 11 => 146211911499519294
  | 12 => 874313719685775360
  | 13 => 4872010111798142520
  | 14 => 25497827389410525184
  | 15 => 126142916465781843075
  | 16 => 593121772421445058560
  | _  => 0                  -- placeholder for higher depths

/-- The set of Monster-adjacent primes at a given depth n:
    prime factors of c(n) that do not divide the order of the Monster group. -/
def adjacentPrimesAtDepth (n : ℕ) : Finset ℕ :=
  (Nat.primeFactors (jCoefficient n)).filter (· ∉ monsterPrimes)

/-- The infinite structured set of **Monster-adjacent primes**:
    primes that appear as factors of some j-invariant coefficient
    but do not divide the order of the Monster group. -/
def monsterAdjacentPrimes : Set ℕ :=
  { p : ℕ | ∃ n : ℕ, p ∈ adjacentPrimesAtDepth n }

/-! ## Coefficient values -/

theorem j_coeff_1_eq : jCoefficient 1 = 196884 := rfl
theorem j_coeff_2_eq : jCoefficient 2 = 21493760 := rfl
theorem j_coeff_3_eq : jCoefficient 3 = 864299970 := rfl

/-! ## Adjacent primes at each depth

The following theorems identify the exact set of Monster-adjacent primes
emerging at each depth of the j-invariant q-expansion. -/

/-- Depth 1: c₁ = 196884 = 2² × 3³ × **1823** -/
theorem adjacent_depth_1 : adjacentPrimesAtDepth 1 = {1823} := by native_decide

/-- Depth 2: c₂ = 21493760 = 2⁷ × 5 × **2099** × ... -/
theorem adjacent_depth_2 : adjacentPrimesAtDepth 2 = {2099} := by native_decide

/-- Depth 3: c₃ = 864299970 = 2 × 3⁵ × 5 × **355679** -/
theorem adjacent_depth_3 : adjacentPrimesAtDepth 3 = {355679} := by native_decide

/-- Depth 4: c₄ = 20245856256 = 2⁹ × 3 × ... × **45767** -/
theorem adjacent_depth_4 : adjacentPrimesAtDepth 4 = {45767} := by native_decide

/-- Depth 5: c₅ = 333202640600, yielding two adjacent primes. -/
theorem adjacent_depth_5 : adjacentPrimesAtDepth 5 = {2143, 777421} := by native_decide

/-- Depth 6: c₆ = 4252023300096, yielding adjacent prime **383**
    (notably, 383 is itself prime and < 1000). -/
theorem adjacent_depth_6 : adjacentPrimesAtDepth 6 = {383} := by native_decide

/-- Depth 7: c₇ = 44656994071935, yielding two adjacent primes. -/
theorem adjacent_depth_7 : adjacentPrimesAtDepth 7 = {271, 174376673} := by native_decide

/-- Depth 8: c₈ = 401490886656000, yielding two adjacent primes.
    Note: 199 is relatively small for an adjacent prime. -/
theorem adjacent_depth_8 : adjacentPrimesAtDepth 8 = {199, 41047} := by native_decide

/-- Depth 9: c₉ = 3176440229784420. -/
theorem adjacent_depth_9 : adjacentPrimesAtDepth 9 = {4723, 15376021} := by native_decide

/-- Depth 10: c₁₀ = 22567393309593600, yielding a single large adjacent prime. -/
theorem adjacent_depth_10 : adjacentPrimesAtDepth 10 = {5366467} := by native_decide

/-! ## Membership in the Monster-adjacent prime set -/

/-- 1823 is a Monster-adjacent prime, arising at depth 1. -/
theorem mem_1823 : 1823 ∈ monsterAdjacentPrimes :=
  ⟨1, by native_decide⟩

/-- 2099 is a Monster-adjacent prime, arising at depth 2. -/
theorem mem_2099 : 2099 ∈ monsterAdjacentPrimes :=
  ⟨2, by native_decide⟩

/-- 355679 is a Monster-adjacent prime, arising at depth 3. -/
theorem mem_355679 : 355679 ∈ monsterAdjacentPrimes :=
  ⟨3, by native_decide⟩

/-- 383 is a Monster-adjacent prime, arising at depth 6. -/
theorem mem_383 : 383 ∈ monsterAdjacentPrimes :=
  ⟨6, by native_decide⟩

/-- 199 is a Monster-adjacent prime, arising at depth 8.
    This is the smallest Monster-adjacent prime in our computed range. -/
theorem mem_199 : 199 ∈ monsterAdjacentPrimes :=
  ⟨8, by native_decide⟩

/-! ## Primality of notable adjacent primes -/

theorem prime_1823 : Nat.Prime 1823 := by native_decide
theorem prime_2099 : Nat.Prime 2099 := by native_decide
theorem prime_355679 : Nat.Prime 355679 := by native_decide
theorem prime_383 : Nat.Prime 383 := by native_decide
theorem prime_199 : Nat.Prime 199 := by native_decide

/-! ## Disjointness -/

/-- No Monster prime is a Monster-adjacent prime (for the defined depths). -/
theorem monsterPrimes_disjoint :
    ∀ p ∈ monsterPrimes, p ∉ monsterAdjacentPrimes := by
  intro p hp ⟨n, hn⟩
  simp only [adjacentPrimesAtDepth, Finset.mem_filter] at hn
  exact hn.2 hp
