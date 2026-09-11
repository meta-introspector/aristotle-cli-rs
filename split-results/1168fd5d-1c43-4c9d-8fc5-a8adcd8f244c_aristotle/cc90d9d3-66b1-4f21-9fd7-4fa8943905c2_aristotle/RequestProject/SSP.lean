import Mathlib

/-!
# Spectral Monster Approximation

This file formalizes the mathematical foundations of the "Spectral Monster Approximation" idea:
the 15 supersingular primes (SSPs) — the exact prime divisors of the Monster group's order —
act as a natural filter on rational approximations to fundamental constants.

## Main results

- `monster_irrep_factorization`: 196883 = 47 × 59 × 71
- `mckay_observation`: 196884 = 196883 + 1 (but 196884 has prime factor 1823, escaping SSP-space)
- `factorial_ssp_smooth_le_36`: n! is SSP-smooth for n ≤ 36
- `factorial_37_not_ssp_smooth`: 37! breaks SSP-smoothness
- `ssp_fractran_closed`: SSP-FRACTRAN is computationally closed
- `sspEncode_smooth`: ℕ¹⁵ → SSP-smooth ℕ encoding is valid

## The "holes" and filtration

The SSP-smooth rationals form a sublattice of ℚ. The "hole primes" — primes in [2,71] not in
the SSP set — index obstruction classes. This gives a natural filtration:

  ℚ_SSP ⊂ ℚ_{37} ⊂ ℚ_{53} ⊂ ... ⊂ ℚ

where each layer adds the next hole prime. Each hole prime witnesses a specific "escape" from
Monster space: 37 breaks factorial smoothness, 53 appears in π convergents, and 691 (far
beyond the SSP range) marks the Ramanujan obstruction in modular forms.
-/

open scoped BigOperators Nat
open Finset

/-! ## Supersingular Primes -/

/-- The 15 supersingular primes: prime divisors of the Monster group order -/
def sspSet : Finset ℕ := {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71}

/-- A natural number is SSP-smooth if all its prime factors are supersingular primes -/
def SSPSmooth (n : ℕ) : Prop :=
  ∀ p ∈ n.primeFactors, p ∈ sspSet

instance (n : ℕ) : Decidable (SSPSmooth n) := by unfold SSPSmooth; exact inferInstance

/-! ## Monster Group Irreducible Representation -/

/-- The dimension of the smallest faithful irreducible representation of the Monster group -/
def monsterIrrepDim : ℕ := 196883

/-- 196883 = 47 × 59 × 71 -/
theorem monster_irrep_factorization : monsterIrrepDim = 47 * 59 * 71 := by native_decide

/-- McKay's observation: 196884 = 196883 + 1.
This is the connection between the j-invariant's q-expansion coefficient
and Monster representation dimensions. -/
theorem mckay_observation : monsterIrrepDim + 1 = 196884 := by native_decide

/-- The Monster irrep dimension is SSP-smooth -/
theorem monster_irrep_ssp_smooth : SSPSmooth monsterIrrepDim := by native_decide

/-- 196884 is NOT SSP-smooth: it has prime factor 1823.
This is mathematically interesting — the McKay coefficient itself "escapes" SSP-space,
while the irrep dimension 196883 stays within it. -/
theorem mckay_coefficient_not_ssp_smooth : ¬ SSPSmooth 196884 := by native_decide

/-- 744 (the j-invariant constant term q⁻¹ + 744 + ...) is SSP-smooth: 744 = 2³ × 3 × 31 -/
theorem j_invariant_constant_ssp_smooth : SSPSmooth 744 := by native_decide

/-! ## Factorial SSP-Smoothness -/

/-- n! is SSP-smooth for n ≤ 36.
This is because every prime ≤ 36 is a supersingular prime (the smallest non-SSP prime is 37). -/
theorem factorial_ssp_smooth_le_36 : ∀ n ≤ 36, SSPSmooth n.factorial := by native_decide

/-- 37! is not SSP-smooth: 37 is prime and not an SSP -/
theorem factorial_37_not_ssp_smooth : ¬ SSPSmooth (37).factorial := by native_decide

/-- 37 is prime and not an SSP -/
theorem prime_37_not_ssp : (37 : ℕ).Prime ∧ 37 ∉ sspSet := by native_decide

/-- Every prime below 37 is an SSP (so 37 is the smallest non-SSP prime) -/
theorem primes_below_37_are_ssp :
    ∀ p ∈ Finset.range 37, p.Prime → p ∈ sspSet := by native_decide

/-! ## Hole Primes -/

/-- The "hole primes": primes in [2, 71] that are NOT supersingular primes.
These index the obstruction classes — each one witnesses a specific "escape" from Monster space. -/
def holePrimesBelow72 : Finset ℕ := {37, 43, 53, 61, 67}

/-- Every element of holePrimesBelow72 is prime and not in sspSet -/
theorem hole_primes_are_prime_non_ssp :
    ∀ p ∈ holePrimesBelow72, p.Prime ∧ p ∉ sspSet := by native_decide

/-- The union of SSPs and hole primes below 72 gives all primes up to 71 -/
theorem ssp_union_holes_eq_primes_to_71 :
    ∀ p ∈ Finset.range 72, p.Prime → p ∈ sspSet ∨ p ∈ holePrimesBelow72 := by native_decide

/-! ## SSP Encoding: ℕ¹⁵ ↔ SSP-smooth naturals -/

/-- The SSP primes as a list (ordered) -/
def sspPrimes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- Encode a vector of 15 exponents as a product of SSP prime powers.
This gives a bijection between ℕ¹⁵ and the SSP-smooth positive naturals. -/
def sspEncode (v : Fin 15 → ℕ) : ℕ :=
  ∏ i : Fin 15, sspPrimes[i.val]! ^ v i

/-- The encoding of the zero vector is 1 -/
theorem sspEncode_zero : sspEncode (fun _ => 0) = 1 := by native_decide

/-- All SSP primes are indeed prime -/
theorem sspPrimes_all_prime : ∀ i : Fin 15, (sspPrimes[i.val]!).Prime := by native_decide

/-- All SSP primes are in sspSet -/
theorem sspPrimes_mem_sspSet : ∀ i : Fin 15, sspPrimes[i.val]! ∈ sspSet := by native_decide

/-
The encoding of any exponent vector is SSP-smooth
-/
theorem sspEncode_smooth (v : Fin 15 → ℕ) : SSPSmooth (sspEncode v) := by
  intro p;
  simp +zetaDelta at *;
  intro hp hdiv hne;
  -- Since p divides the product, it must divide at least one of the factors.
  obtain ⟨i, hi⟩ : ∃ i : Fin 15, p ∣ sspPrimes[i.val]! ^ v i := by
    contrapose! hdiv;
    simp_all +decide [ Nat.Prime.dvd_iff_not_coprime hp ];
    exact Nat.Coprime.prod_right fun i _ => by aesop;
  have := Nat.Prime.dvd_of_dvd_pow hp hi;
  have := Nat.prime_dvd_prime_iff_eq hp ( sspPrimes_all_prime i );
  exact this.mp ‹_› ▸ sspPrimes_mem_sspSet i

/-
The encoding is positive for any exponent vector
-/
theorem sspEncode_pos (v : Fin 15 → ℕ) : 0 < sspEncode v := by
  exact Finset.prod_pos fun i _ => pow_pos ( Nat.Prime.pos ( by fin_cases i <;> trivial ) ) _

/-! ## SSP-FRACTRAN -/

/-- An SSP-FRACTRAN instruction: a fraction p/q where both p and q are SSP-smooth -/
structure SSPFraction where
  num : ℕ
  den : ℕ
  den_pos : 0 < den
  num_smooth : SSPSmooth num
  den_smooth : SSPSmooth den

/-- Execute one step of SSP-FRACTRAN: find the first fraction that divides evenly -/
def sspFractranStep (program : List SSPFraction) (state : ℕ) : Option ℕ :=
  match program.find? (fun f => state * f.num % f.den == 0) with
  | some f => some (state * f.num / f.den)
  | none => none

/-
An SSP-FRACTRAN step preserves SSP-smoothness of the state.
Since both the state and the fraction's numerator/denominator are SSP-smooth,
and division of SSP-smooth numbers by SSP-smooth numbers remains SSP-smooth,
the resulting state is also SSP-smooth.
-/
theorem ssp_fractran_closed (program : List SSPFraction) (state : ℕ)
    (h_smooth : SSPSmooth state) (result : ℕ)
    (h_step : sspFractranStep program state = some result) :
    SSPSmooth result := by
  unfold SSPSmooth;
  unfold sspFractranStep at h_step;
  cases h : List.find? ( fun f => state * f.num % f.den == 0 ) program <;> simp_all +decide;
  rename_i f;
  intro p pp dp _; have := Nat.dvd_trans dp ( show result ∣ state * f.num from h_step ▸ Nat.div_dvd_of_dvd ( Nat.dvd_of_mod_eq_zero ( by have := List.find?_some h; aesop ) ) ) ; simp_all +decide [ Nat.Prime.dvd_mul ] ;
  cases this <;> have := h_smooth p <;> have := f.num_smooth p <;> aesop

/-! ## Smoothness over arbitrary prime sets & Filtration -/

/-- Smoothness with respect to a given set of primes -/
def SmoothOver (S : Finset ℕ) (n : ℕ) : Prop :=
  ∀ p ∈ n.primeFactors, p ∈ S

instance (S : Finset ℕ) (n : ℕ) : Decidable (SmoothOver S n) := by
  unfold SmoothOver; exact inferInstance

/-- The SSP filtration: SSP set extended by the first k hole primes.
Level 0 = SSPs only, level k adds the k-th hole prime from {37, 43, 53, 61, 67}. -/
def sspFiltration : ℕ → Finset ℕ
  | 0 => sspSet
  | 1 => sspSet ∪ {37}
  | 2 => sspSet ∪ {37, 43}
  | 3 => sspSet ∪ {37, 43, 53}
  | 4 => sspSet ∪ {37, 43, 53, 61}
  | _ => sspSet ∪ {37, 43, 53, 61, 67}

/-- 37! is smooth over the first filtration level (SSPs ∪ {37}) -/
theorem factorial_37_smooth_filtration_1 :
    SmoothOver (sspFiltration 1) (37).factorial := by native_decide

/-- 691 (the Ramanujan prime from B₁₂) is not SSP-smooth.
This prime appears in the numerator of B₁₂ = -691/2730 and in the congruence
τ(n) ≡ σ₁₁(n) mod 691, marking the first "collision" between Eisenstein series
and cusp forms. -/
theorem ramanujan_691_not_ssp_smooth : ¬ SSPSmooth 691 := by native_decide

/-- 691 is prime -/
theorem ramanujan_691_prime : Nat.Prime 691 := by native_decide

/-! ## π Convergent Analysis -/

/-- 22/7: denominator 7 is SSP-smooth (SSP prime) -/
theorem pi_convergent_7_smooth : SSPSmooth 7 := by native_decide

/-- 333/106: denominator 106 = 2 × 53 is NOT SSP-smooth (53 is a hole prime) -/
theorem pi_convergent_106_not_smooth : ¬ SSPSmooth 106 := by native_decide

/-- 355/113: denominator 113 is prime and NOT an SSP -/
theorem pi_convergent_113_not_smooth : ¬ SSPSmooth 113 := by native_decide

/-- The factorization witness: 53 divides 106 and is not an SSP -/
theorem pi_hole_witness_53 : (53 : ℕ).Prime ∧ 53 ∣ 106 ∧ 53 ∉ sspSet := by native_decide