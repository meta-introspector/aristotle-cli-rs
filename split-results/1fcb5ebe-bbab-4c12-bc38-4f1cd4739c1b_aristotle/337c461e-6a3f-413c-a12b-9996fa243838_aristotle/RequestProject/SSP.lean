/-
# Supersingular Primes and Monster Group Foundations

This file formalizes the concrete mathematical facts underlying the
"Spectral Monster Approximation" idea — that rational/finite approximations
of fundamental constants (π, e, γ, Eisenstein series, j-invariant) are
hidden elements of the Monster group structure at different levels.

We formalize:
- The 15 supersingular primes (SSPs)
- The Monster group order and its prime factorization
- The key factorization 196883 = 47 × 59 × 71 (Monster's smallest
  faithful irrep dimension, factoring purely over SSPs)
- That j-invariant coefficients (744, 196884) relate to Monster irreps
- That factorial denominators stay SSP-pure up to 71!
- Basic FRACTRAN computation over SSP primes
-/
import Mathlib

/-! ## The 15 Supersingular Primes -/

/-- The 15 supersingular primes: exactly the prime divisors of the
    order of the Monster group. These are also exactly the primes p
    for which the elliptic curve in characteristic p has supersingular
    reduction for all j-invariants. -/
def SupersingularPrimes : List ℕ :=
  [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- There are exactly 15 supersingular primes. -/
theorem card_supersingularPrimes : SupersingularPrimes.length = 15 := by decide

/-- All supersingular primes are indeed prime. -/
theorem all_ssp_prime : ∀ p ∈ SupersingularPrimes, Nat.Prime p := by decide

/-- A number is SSP-smooth if all its prime factors are supersingular primes. -/
def IsSSPSmooth (n : ℕ) : Prop :=
  ∀ p : ℕ, Nat.Prime p → p ∣ n → p ∈ SupersingularPrimes

/-! ## The Monster Group Order -/

/-- The order of the Monster group M.
    |M| = 2^46 · 3^20 · 5^9 · 7^6 · 11^2 · 13^3 · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71 -/
def MonsterOrder : ℕ :=
  2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-
The Monster group order is SSP-smooth: all its prime factors are supersingular primes.
-/
theorem monsterOrder_ssp_smooth : IsSSPSmooth MonsterOrder := by
  intro p hp hdiv
  have h_prime : p ∈ Nat.primeFactorsList MonsterOrder := by
    norm_num +zetaDelta at *;
    exact ⟨ hp, hdiv, by native_decide ⟩
  have h_prime : p ∈ [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71] := by
    have h_prime_factors : p ∈ Nat.primeFactorsList MonsterOrder := by
      aesop
    have h_prime_factors : p ∈ Nat.primeFactorsList (2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71) := by
      exact h_prime_factors
    norm_num [ Nat.primeFactorsList ] at h_prime_factors
    aesop
  exact h_prime

/-! ## Key Factorizations -/

/-- The dimension of the Monster's smallest faithful irreducible representation. -/
def MonsterSmallestIrrepDim : ℕ := 196883

/-- 196883 = 47 × 59 × 71 — the three largest supersingular primes.
    This is the key connection between the j-invariant and the Monster group. -/
theorem monster_irrep_factorization : MonsterSmallestIrrepDim = 47 * 59 * 71 := by decide

/-- The first nontrivial j-invariant coefficient. -/
def jCoeff1 : ℕ := 196884

/-- Monstrous Moonshine: 196884 = 196883 + 1, connecting the j-invariant
    to Monster irrep dimensions (McKay's observation). -/
theorem mckay_observation : jCoeff1 = MonsterSmallestIrrepDim + 1 := by decide

/-- The constant term of the j-invariant q-expansion. -/
def jConstantTerm : ℕ := 744

/-- 744 = 2³ × 3 × 31, factoring purely over SSPs. -/
theorem j_constant_ssp : jConstantTerm = 2^3 * 3 * 31 := by decide

/-
744 is SSP-smooth.
-/
theorem j_constant_ssp_smooth : IsSSPSmooth jConstantTerm := by
  intro p pp dp; have := Nat.Prime.dvd_factorial pp |>.1 ( dvd_trans dp ( by native_decide : jConstantTerm ∣ Nat.factorial 71 ) ) ; interval_cases p <;> trivial;

/-
196883 is SSP-smooth (since 47, 59, 71 are all SSPs).
-/
theorem monster_irrep_ssp_smooth : IsSSPSmooth MonsterSmallestIrrepDim := by
  intro p pp dp; rw [ show MonsterSmallestIrrepDim = 47 * 59 * 71 by rfl ] at dp; simp_all +decide [ Nat.Prime.dvd_mul ] ;
  -- Since 196883 = 47 * 59 * 71, its prime factors are exactly 47, 59, and 71.
  have h_factors : p ∈ Nat.primeFactors 196883 := by
    grind;
  norm_num [ Nat.primeFactors, Nat.primeFactorsList ] at h_factors;
  rcases h_factors with ( rfl | rfl | rfl ) <;> decide

/-! ## Factorial SSP-Smoothness

The key observation: n! stays SSP-smooth as long as every prime ≤ n
is a supersingular prime. The smallest prime NOT in the SSP list is 37.
So n! is SSP-smooth for n ≤ 36, and NOT SSP-smooth for n ≥ 37.

Note: The original conversation claimed n ≤ 72, but this is incorrect.
The primes 37, 43, 53, 61, 67 are all ≤ 72 and NOT supersingular primes.
The correct bound is n ≤ 36. -/

/-- The largest supersingular prime. -/
theorem largest_ssp : SupersingularPrimes.getLast (by decide) = 71 := by decide

/-- 73 is prime but NOT a supersingular prime. -/
theorem seventyThree_not_ssp : Nat.Prime 73 ∧ 73 ∉ SupersingularPrimes := by decide

/-- 37 is the smallest prime NOT in the SSP list. -/
theorem thirtySevenNotSSP : Nat.Prime 37 ∧ 37 ∉ SupersingularPrimes := by decide

/-
For n ≤ 36, n! is SSP-smooth. This is because every prime ≤ 36
    is a supersingular prime (the primes ≤ 36 are 2,3,5,7,11,13,17,19,23,29,31,
    all of which are SSPs).
-/
theorem factorial_ssp_smooth_le_36 : ∀ n : ℕ, n ≤ 36 → IsSSPSmooth n.factorial := by
  -- We can prove this by checking each prime number less than or equal to 36 and showing that it is in SupersingularPrimes.
  have h_primes_le_36 : ∀ p : ℕ, Nat.Prime p → p ≤ 36 → p ∈ SupersingularPrimes := by
    intro p pp p36; interval_cases p <;> trivial;
  exact fun n hn p pp dp => h_primes_le_36 p pp ( Nat.le_trans ( pp.dvd_factorial.mp dp ) hn )

/-
37! is NOT SSP-smooth (37 is prime and divides 37!, but 37 is not an SSP).
-/
theorem factorial_37_not_ssp_smooth : ¬ IsSSPSmooth (37).factorial := by
  exact fun h => by have := h 37 ( by norm_num ) ( by native_decide ) ; contradiction;

/-
73! is NOT SSP-smooth (73 is prime and divides 73!).
-/
theorem factorial_73_not_ssp_smooth : ¬ IsSSPSmooth (73).factorial := by
  -- We show 73! is not SSP-smooth by showing 73! contains a prime factor not in `SupersingularPrimes`
  by_contra h
  have h2 : 73 ∈ SupersingularPrimes := by
    exact h 73 ( by norm_num ) ( by native_decide );
  contradiction

/-! ## SSP-Smooth Approximations to π

The continued fraction convergents of π: 3/1, 22/7, 333/106, 355/113, ...
Some have SSP-smooth denominators and some don't. The SSP-smooth ones
form a distinguished subsequence — the "Monster-natural" approximation. -/

/-
22/7 is an SSP-smooth approximation to π (denominator 7 is SSP).
-/
theorem pi_convergent_22_7_ssp : IsSSPSmooth 7 := by
  exact fun p pp dp => by have := Nat.le_of_dvd ( by decide ) dp; interval_cases p <;> trivial;

/-
106 is NOT SSP-smooth (106 = 2 × 53, and 53 is not an SSP).
-/
theorem pi_convergent_106_not_ssp : ¬ IsSSPSmooth 106 := by
  exact fun h => absurd ( h 53 ( by norm_num ) ( by norm_num ) ) ( by native_decide )

/-
113 is NOT SSP-smooth (113 is prime and not an SSP).
-/
theorem pi_convergent_113_not_ssp : ¬ IsSSPSmooth 113 := by
  -- Since 113 is a prime number and not in the list of supersingular primes, it cannot be SSP-smooth.
  have h_prime : Nat.Prime 113 := by
    norm_num
  have h_not_ssp : 113 ∉ SupersingularPrimes := by
    native_decide
  exact fun h => h_not_ssp (h 113 h_prime (by norm_num))

/-! ## Bernoulli Number SSP-Smoothness

The Bernoulli numbers B_2k appear in the Eisenstein series and connect
π to modular forms. Their denominators are SSP-smooth for small k. -/

/-
The denominator of B_2 is 6 = 2 × 3, which is SSP-smooth.
-/
theorem bernoulli_B2_denom_ssp : IsSSPSmooth 6 := by
  intro p pp dp; have := Nat.le_of_dvd ( by decide ) dp; interval_cases p <;> trivial;

/-
The denominator of B_4 is 30 = 2 × 3 × 5, which is SSP-smooth.
-/
theorem bernoulli_B4_denom_ssp : IsSSPSmooth 30 := by
  intro p pp dp; have := Nat.le_of_dvd ( by decide ) dp; interval_cases p <;> trivial;

/-
The denominator of B_6 is 42 = 2 × 3 × 7, which is SSP-smooth.
-/
theorem bernoulli_B6_denom_ssp : IsSSPSmooth 42 := by
  intro p pp dp; have := Nat.le_of_dvd ( by decide ) dp; interval_cases p <;> trivial;

/-
691 (appearing in B_12) is NOT SSP-smooth — it's prime and not an SSP.
    This marks the boundary where Eisenstein series leave pure SSP-space.
-/
theorem ramanujan_691_not_ssp : Nat.Prime 691 ∧ ¬ IsSSPSmooth 691 := by
  exact ⟨ by norm_num, fun h => absurd ( h 691 ( by norm_num ) ( by norm_num ) ) ( by native_decide ) ⟩

/-! ## FRACTRAN over SSP Primes

A FRACTRAN program is a list of fractions. Given an integer n,
multiply n by the first fraction in the list that yields an integer,
and repeat. Conway proved FRACTRAN is Turing complete.

We define FRACTRAN restricted to SSP primes: all fractions must have
numerators and denominators that are products of SSPs only. -/

/-- A FRACTRAN fraction: numerator and denominator. -/
structure SSPFractranFrac where
  numerator : ℕ
  denominator : ℕ
  den_pos : 0 < denominator

/-- A FRACTRAN program is a list of fractions. -/
abbrev SSPFractranProg := List SSPFractranFrac

/-- An SSP-FRACTRAN program: all fractions have SSP-smooth num and den. -/
def IsSSPFractran (prog : SSPFractranProg) : Prop :=
  ∀ f ∈ prog, IsSSPSmooth f.numerator ∧ IsSSPSmooth f.denominator

/-- One step of FRACTRAN execution: find the first fraction that divides evenly. -/
def fractranStep (prog : SSPFractranProg) (n : ℕ) : Option ℕ :=
  match prog with
  | [] => none
  | f :: rest =>
    if n * f.numerator % f.denominator = 0 then
      some (n * f.numerator / f.denominator)
    else
      fractranStep rest n

/-- An SSP state is a natural number that is SSP-smooth.
    In FRACTRAN over SSPs, states are encoded as products of SSP powers:
    N = 2^a · 3^b · 5^c · 7^d · 11^e · 13^f · ... · 71^o
    The exponent vector (a,b,...,o) ∈ ℕ^15 is the complete state. -/
abbrev IsSSPState (n : ℕ) : Prop := IsSSPSmooth n

/-
If we start from an SSP-smooth state and apply an SSP-FRACTRAN program,
    the result (if any) is also SSP-smooth. This is the closure property
    that makes SSP-FRACTRAN self-contained.
-/
theorem ssp_fractran_closed (prog : SSPFractranProg) (n : ℕ)
    (hprog : IsSSPFractran prog) (hn : IsSSPState n) :
    ∀ m, fractranStep prog n = some m → IsSSPState m := by
  intro m hm;
  induction' prog with f prog ih generalizing n m;
  · cases hm;
  · unfold fractranStep at hm;
    split_ifs at hm ; simp_all +decide [ IsSSPState ];
    · intro p pp dp; have := hprog f; simp_all +decide [ IsSSPFractran ] ;
      -- Since $p$ divides $m$, it must divide $n * f.numerator$.
      have h_div : p ∣ n * f.numerator := by
        exact dvd_trans dp ( hm ▸ Nat.div_dvd_of_dvd ( Nat.dvd_of_mod_eq_zero ‹_› ) );
      rw [ Nat.Prime.dvd_mul ] at h_div <;> aesop;
    · exact ih n ( fun g hg => hprog g ( List.mem_cons_of_mem _ hg ) ) hn m hm

/-! ## The 15-Dimensional SSP Exponent Space

The key insight: every SSP-smooth number corresponds to a point in ℕ^15,
where each coordinate is the exponent of the corresponding SSP prime.
This is the "state space" of the Monster FRACTRAN machine. -/

/-- Encode a point in ℕ^15 as an SSP-smooth number. -/
def sspEncode (v : Fin 15 → ℕ) : ℕ :=
  (List.finRange 15).foldl (fun acc i => acc * SupersingularPrimes[i]! ^ v i) 1

/-
The encoding always produces SSP-smooth numbers.
-/
theorem sspEncode_smooth (v : Fin 15 → ℕ) : IsSSPSmooth (sspEncode v) := by
  intro p pp dp;
  contrapose! dp;
  simp +decide [ sspEncode, List.foldl, Nat.Prime.dvd_iff_not_coprime pp ];
  induction' ( List.finRange 15 ) using List.reverseRecOn with i hi <;> simp_all +decide [ Nat.coprime_mul_iff_right, Nat.coprime_mul_iff_left ];
  refine' ⟨ by assumption, Nat.Coprime.pow_right _ _ ⟩;
  fin_cases hi <;> simp_all +decide [ Nat.coprime_primes ];
  all_goals intro h; simp_all +decide [ SupersingularPrimes ] ;

/-! ## Summary of Key Relationships

The formalized facts establish:

1. **SSP Primes** = {2,3,5,7,11,13,17,19,23,29,31,41,47,59,71}
   - Exactly 15 primes, all prime (✓ verified)

2. **Monster Connection**:
   - 196883 = 47 × 59 × 71 (three largest SSPs)
   - 196884 = 196883 + 1 (McKay's observation)
   - 744 = 2³ × 3 × 31 (SSP-smooth)
   - Monster order is SSP-smooth

3. **e Series**: n! is SSP-smooth for n ≤ 36 (corrected from 72)
   First "leak" at 37! (37 is prime, not SSP)
   (The original claim of 72 was incorrect; 37, 43, 53, 61, 67 are non-SSP primes ≤ 72)

4. **π Convergents**: 22/7 is SSP-smooth, 333/106 and 355/113 are not
   The SSP-filtered convergents form a coarser, Monster-natural sequence

5. **Bernoulli/Eisenstein**: B_2, B_4, B_6 denominators are SSP-smooth
   B_12 denominator contains 691 (not SSP) — marking the modular boundary

6. **FRACTRAN**: SSP-FRACTRAN is closed under computation
   States live in ℕ^15 (one dimension per SSP)
   The entire computation stays in exact integer arithmetic
-/