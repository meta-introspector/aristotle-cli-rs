import Mathlib

/-!
# Monstrous Moonshine: Supersingular Prime Factorizations of j-invariant Coefficients

This file formalizes numerical relationships arising from Monstrous Moonshine,
connecting the Fourier coefficients of Klein's j-invariant to products of
powers of the 15 supersingular primes.

## Background

The j-invariant has q-expansion: j(τ) = q⁻¹ + 744 + 196884q + 21493760q² + ⋯

The 15 supersingular primes are: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71.
These are the primes p for which every supersingular elliptic curve in characteristic p
is defined over 𝔽_p.

McKay's observation (the genesis of Monstrous Moonshine) notes that 196884 = 1 + 196883,
where 196883 is the dimension of the smallest nontrivial irreducible representation of
the Monster group, and 196883 = 47 × 59 × 71 (product of the three largest
supersingular primes).

The trace data encodes a factorization of each j-invariant coefficient over the
supersingular primes, producing "companion values" (temps) whose weighted sum
(plus 1) yields the total 98220881625283513136530.
-/

set_option maxHeartbeats 8000000

/-! ## The 15 Supersingular Primes -/

/-- The 15 supersingular primes, in increasing order. -/
def supersingularPrimes : List Nat := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

theorem supersingularPrimes_length : supersingularPrimes.length = 15 := by native_decide

theorem supersingularPrimes_all_prime : ∀ p ∈ supersingularPrimes, Nat.Prime p := by decide

/-- The product of all 15 supersingular primes. -/
theorem supersingularPrimes_prod :
    supersingularPrimes.prod = 1618964990108856390 := by native_decide

/-! ## j-invariant Coefficients

The first seven coefficients of q · j(τ) = 1 + 744q + 196884q² + ⋯
(i.e., c(-1)=1, c(0)=744, c(1)=196884, c(2)=21493760, …)
-/

/-- The first 7 Fourier coefficients of q · j(τ). -/
def jCoeffs : List Nat := [1, 744, 196884, 21493760, 864299970, 20245856256, 333202640600]

/-! ## McKay's Observation -/

/-- 196883 is the product of the three largest supersingular primes. -/
theorem three_largest_supersingular_prod : 47 * 59 * 71 = 196883 := by norm_num

/-- McKay's observation: the second j-coefficient equals 1 plus the dimension
of the smallest nontrivial irreducible representation of the Monster group. -/
theorem mckay_observation : 196884 = 1 + 196883 := by norm_num

/-- Combined: 196884 = 1 + 47 × 59 × 71. -/
theorem mckay_supersingular : 196884 = 1 + 47 * 59 * 71 := by norm_num

/-! ## Supersingular Prime Power Factorizations (Companion Values)

For each j-coefficient y, the trace computes a companion value (temp) as a product
of powers of supersingular primes. The exponent vectors (ssp) encode how each
coefficient interacts with the supersingular primes.
-/

/-- Companion value for c(-1) = 1: trivial factorization. -/
theorem temp_0 : (1 : Nat) = 1 := rfl

/-- Companion value for c(0) = 744: temp = 47 × 59 × 71 = 196883. -/
theorem temp_1 : 47 ^ 1 * 59 ^ 1 * 71 ^ 1 = 196883 := by norm_num

/-- Companion value for c(1) = 196884: temp = 2² × 31 × 41 × 59 × 71. -/
theorem temp_2 : 2 ^ 2 * 31 ^ 1 * 41 ^ 1 * 59 ^ 1 * 71 ^ 1 = 21296876 := by norm_num

/-- Companion value for c(2) = 21493760: temp = 2 × 13² × 29 × 31 × 47 × 59. -/
theorem temp_3 : 2 ^ 1 * 13 ^ 2 * 29 ^ 1 * 31 ^ 1 * 47 ^ 1 * 59 ^ 1 = 842609326 := by norm_num

/-- Companion value for c(3) = 864299970: temp = 2² × 7 × 11 × 23 × 29 × 31 × 41 × 71. -/
theorem temp_4 :
    2 ^ 2 * 7 ^ 1 * 11 ^ 1 * 23 ^ 1 * 29 ^ 1 * 31 ^ 1 * 41 ^ 1 * 71 ^ 1
      = 18538750076 := by norm_num

/-- Companion value for c(4) = 20245856256: temp = 13² × 23 × 29 × 41 × 59 × 71. -/
theorem temp_5 : 13 ^ 2 * 23 ^ 1 * 29 ^ 1 * 41 ^ 1 * 59 ^ 1 * 71 ^ 1 = 19360062527 := by
  norm_num

/-- Companion value for c(5) = 333202640600: temp = 2 × 3 × 11 × 19 × 29 × 41 × 47 × 59 × 71. -/
theorem temp_6 :
    2 ^ 1 * 3 ^ 1 * 11 ^ 1 * 19 ^ 1 * 29 ^ 1 * 41 ^ 1 * 47 ^ 1 * 59 ^ 1 * 71 ^ 1
      = 293553734298 := by norm_num

/-- The companion values. -/
def companionValues : List Nat :=
  [1, 196883, 21296876, 842609326, 18538750076, 19360062527, 293553734298]

/-! ## The Total: Weighted Sum of Coefficients and Companion Values

The total from the trace equals 1 + Σⱼ jCoeffs[j] × companionValues[j].
-/

/-- The total equals 1 + Σⱼ y[j] × temp[j]. -/
theorem total_value :
    1 + (List.map (fun p => p.1 * p.2) (jCoeffs.zip companionValues)).sum
      = 98220881625283513136530 := by native_decide

/-! ## Decomposition of j-coefficients as Sums of Monster Irrep Dimensions

The j-invariant coefficients decompose as non-negative integer linear combinations
of dimensions of irreducible representations of the Monster group.
-/

/-- The second coefficient decomposes as dimensions of Monster irreps:
196884 = 1 + 196883. Here 196883 is the dimension of the smallest
nontrivial irreducible representation V₁ of the Monster. -/
theorem j_coeff_1_decomp : 196884 = 1 + 196883 := by norm_num

/-- The third coefficient: 21493760 = 1 + 196883 + 21296876,
where 21296876 is the dimension of V₂ (the next Monster irrep). -/
theorem j_coeff_2_decomp : 21493760 = 1 + 196883 + 21296876 := by norm_num

/-- The fourth coefficient: 864299970 = 2 × 1 + 2 × 196883 + 21296876 + 842609326,
where 842609326 = dim(V₃). -/
theorem j_coeff_3_decomp :
    864299970 = 2 * 1 + 2 * 196883 + 1 * 21296876 + 842609326 := by norm_num

/-- All j-coefficients are positive. -/
theorem jCoeffs_pos : ∀ c ∈ jCoeffs, 0 < c := by decide

/-- All companion values are positive. -/
theorem companionValues_pos : ∀ c ∈ companionValues, 0 < c := by decide

/-- Sum of the first 7 companion values. -/
theorem companion_sum : companionValues.sum = 332316649987 := by native_decide

/-! ## Orbifold Coordinates

The markup specifies orbifold coordinates (26 mod 71, 55 mod 59, 18 mod 47),
forming a point in the product of residue fields of the three largest
supersingular primes. By CRT, ℤ/71 × ℤ/59 × ℤ/47 ≅ ℤ/196883,
and these coordinates determine a unique residue.
-/

theorem orbifold_coord_1 : 26 < 71 := by norm_num
theorem orbifold_coord_2 : 55 < 59 := by norm_num
theorem orbifold_coord_3 : 18 < 47 := by norm_num

/-- The orbifold modulus equals 196883, the Monster dimension. -/
theorem orbifold_crt_modulus : 71 * 59 * 47 = 196883 := by norm_num

/-- The CRT reconstruction: the unique x < 196883 with
x ≡ 26 (mod 71), x ≡ 55 (mod 59), x ≡ 18 (mod 47) is 68967. -/
theorem orbifold_crt_value :
    68967 < 196883 ∧ 68967 % 71 = 26 ∧ 68967 % 59 = 55 ∧ 68967 % 47 = 18 := by norm_num

/-- Uniqueness of the CRT solution. -/
theorem orbifold_crt_unique (x : Nat) (hx : x < 196883)
    (h1 : x % 71 = 26) (h2 : x % 59 = 55) (h3 : x % 47 = 18) :
    x = 68967 := by omega
