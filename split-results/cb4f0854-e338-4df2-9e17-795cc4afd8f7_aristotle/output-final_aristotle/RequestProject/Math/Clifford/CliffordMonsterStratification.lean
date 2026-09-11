/-
# CliffordMonsterStratification — Divisor Stratification of the Monster Order

The order of the Monster sporadic group is

  |M| = 2⁴⁶ · 3²⁰ · 5⁹ · 7⁶ · 11² · 13³ · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71,

a product over the fifteen *supersingular primes*. The exponent structure splits
the fifteen primes into two groups:

* the **six weighted primes** `{2,3,5,7,11,13}` with nontrivial exponents — these
  carry genuine valuation depth and are given the full Clifford treatment
  `Cl(0,6)` (`finrank ℝ (Cl(0,6)) = 2⁶ = 64`, see `CliffordCl06SPerm.lean`);
* the **nine tail primes** `{17,19,23,29,31,41,47,59,71}`, each to the first power
  — these are pure presence/absence **bits**, giving `2⁹ = 512` states.

This file makes the *divisor stratification* precise:

* the Monster order factors as `weightedPart * tailPart` with the two factors
  coprime;
* the tail is squarefree, and its `512 = 2⁹` divisors are indexed bijectively by
  the 9-bit binary addresses `Fin 9 → Bool` (`tailDivisorOfBits`);
* consequently the divisors of `|M|` stratify as a product:
  `#|M|.divisors = #weightedPart.divisors * 2⁹`, the fiber over each binary
  configuration of the tail being the divisor set of the weighted part.

## Mathematical note

The number-theoretic statements proved here (factorization, coprimality,
squarefreeness, divisor counts, the binary bijection) are genuine. The
identification of `2⁹ = 512` with the `512` Gram blocks of the `Cl(0,10)`
computation, and the labelling of the weighted half by `Cl(0,6)`, is thematic
framing connecting the arithmetic to the Clifford-algebra architecture.
-/

import Mathlib
import RequestProject.Math.Clifford.CliffordCl06SPerm

open Finset

namespace MonsterStratification

/-! ## §1. The Monster order and its two strata -/

/-- The order of the Monster group, as a product over the 15 supersingular primes. -/
def monsterOrder : ℕ :=
  2 ^ 46 * 3 ^ 20 * 5 ^ 9 * 7 ^ 6 * 11 ^ 2 * 13 ^ 3 *
    17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- The weighted part: the six primes with nontrivial exponents. -/
def weightedPart : ℕ := 2 ^ 46 * 3 ^ 20 * 5 ^ 9 * 7 ^ 6 * 11 ^ 2 * 13 ^ 3

/-- The tail part: the nine primes appearing to the first power. -/
def tailPart : ℕ := 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- The Monster order factors as `weightedPart * tailPart`. -/
theorem monster_factorization : monsterOrder = weightedPart * tailPart := by
  unfold monsterOrder weightedPart tailPart; ring

/-- The two strata are coprime. -/
theorem weighted_tail_coprime : Nat.Coprime weightedPart tailPart := by
  unfold weightedPart tailPart; norm_num

theorem weightedPart_ne_zero : weightedPart ≠ 0 := by unfold weightedPart; norm_num
theorem tailPart_ne_zero : tailPart ≠ 0 := by unfold tailPart; norm_num
theorem monsterOrder_ne_zero : monsterOrder ≠ 0 := by unfold monsterOrder; norm_num

/-! ## §2. Divisor counts of the two strata -/

/-- Number of divisors of a prime power `p ^ k` is `k + 1`. -/
theorem card_divisors_prime_pow {p : ℕ} (hp : Nat.Prime p) (k : ℕ) :
    #(p ^ k).divisors = k + 1 := by
  rw [Nat.divisors_prime_pow hp, Finset.card_map, Finset.card_range]

/-- Number of divisors of a prime is `2`. -/
theorem card_divisors_prime {p : ℕ} (hp : Nat.Prime p) : #p.divisors = 2 := by
  rw [hp.divisors, Finset.card_pair hp.one_lt.ne]

/-- The weighted part has `47·21·10·7·3·4 = 829080` divisors. -/
theorem weighted_card_divisors : #weightedPart.divisors = 829080 := by
  unfold weightedPart
  rw [Nat.Coprime.card_divisors_mul (by norm_num),
      Nat.Coprime.card_divisors_mul (by norm_num),
      Nat.Coprime.card_divisors_mul (by norm_num),
      Nat.Coprime.card_divisors_mul (by norm_num),
      Nat.Coprime.card_divisors_mul (by norm_num)]
  rw [card_divisors_prime_pow (by norm_num) 46, card_divisors_prime_pow (by norm_num) 20,
      card_divisors_prime_pow (by norm_num) 9, card_divisors_prime_pow (by norm_num) 6,
      card_divisors_prime_pow (by norm_num) 2, card_divisors_prime_pow (by norm_num) 3]

/-- The tail part has `2⁹ = 512` divisors. -/
theorem tail_card_divisors : #tailPart.divisors = 512 := by
  unfold tailPart
  rw [Nat.Coprime.card_divisors_mul (by norm_num),
      Nat.Coprime.card_divisors_mul (by norm_num),
      Nat.Coprime.card_divisors_mul (by norm_num),
      Nat.Coprime.card_divisors_mul (by norm_num),
      Nat.Coprime.card_divisors_mul (by norm_num),
      Nat.Coprime.card_divisors_mul (by norm_num),
      Nat.Coprime.card_divisors_mul (by norm_num),
      Nat.Coprime.card_divisors_mul (by norm_num)]
  rw [card_divisors_prime (by norm_num), card_divisors_prime (by norm_num),
      card_divisors_prime (by norm_num), card_divisors_prime (by norm_num),
      card_divisors_prime (by norm_num), card_divisors_prime (by norm_num),
      card_divisors_prime (by norm_num), card_divisors_prime (by norm_num),
      card_divisors_prime (by norm_num)]

/-- The tail divisor count is exactly `2⁹` — the nine binary bits. -/
theorem tail_card_eq_two_pow_nine : #tailPart.divisors = 2 ^ 9 := by
  rw [tail_card_divisors]; norm_num

/-! ## §3. The nine tail primes and the 9-bit binary index -/

/-- The nine tail primes, indexed by `Fin 9`. -/
def tailPrimeAt : Fin 9 → ℕ := ![17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- Each tail prime is prime. -/
theorem tailPrimeAt_prime (i : Fin 9) : Nat.Prime (tailPrimeAt i) := by
  fin_cases i <;> · unfold tailPrimeAt; norm_num

/-- `tailPart` is the product of the nine tail primes. -/
theorem tailPart_eq_prod : tailPart = ∏ i : Fin 9, tailPrimeAt i := by
  unfold tailPart
  simp [tailPrimeAt, Fin.prod_univ_succ]

/-
The squarefree tail: each of the nine primes appears at most once.
-/
theorem tail_squarefree : Squarefree tailPart := by
  native_decide

/-- The divisor of the tail selected by a 9-bit binary address `b : Fin 9 → Bool`:
    the product of those tail primes whose bit is set. -/
def tailDivisorOfBits (b : Fin 9 → Bool) : ℕ :=
  ∏ i : Fin 9, if b i then tailPrimeAt i else 1

/-- A binary address selects a divisor of the tail. -/
theorem tailDivisorOfBits_dvd (b : Fin 9 → Bool) : tailDivisorOfBits b ∣ tailPart := by
  rw [tailPart_eq_prod, tailDivisorOfBits]
  apply Finset.prod_dvd_prod_of_dvd
  intro i _
  by_cases h : b i <;> simp [h]

/-- A binary address gives a member of the tail's divisor set. -/
theorem tailDivisorOfBits_mem (b : Fin 9 → Bool) :
    tailDivisorOfBits b ∈ tailPart.divisors :=
  Nat.mem_divisors.mpr ⟨tailDivisorOfBits_dvd b, tailPart_ne_zero⟩

/-
The `i`-th tail prime divides the selected divisor iff its bit is set.
-/
theorem tailPrime_dvd_iff (b : Fin 9 → Bool) (i : Fin 9) :
    tailPrimeAt i ∣ tailDivisorOfBits b ↔ b i = true := by
  fin_cases i <;> simp +decide [ tailPrimeAt ];
  all_goals revert b; native_decide;

/-
The 9-bit binary index is injective: distinct addresses give distinct divisors.
-/
theorem tailDivisorOfBits_injective : Function.Injective tailDivisorOfBits := by
  -- By definition of `tailDivisorOfBits`, if `tailDivisorOfBits b1 = tailDivisorOfBits b2`, then for every `i`, `b1 i = b2 i`.
  intro b1 b2 h_eq
  ext i
  have h_prime_div : (tailPrimeAt i) ∣ tailDivisorOfBits b1 ↔ (tailPrimeAt i) ∣ tailDivisorOfBits b2 := by
    rw [h_eq];
  rw [ tailPrime_dvd_iff b1 i, tailPrime_dvd_iff b2 i ] at h_prime_div ; aesop

/-
The image of all `2⁹` binary addresses is **exactly** the tail's divisor set:
    the divisors of the squarefree tail are bijectively indexed by the 9 bits.
-/
theorem tail_image_eq_divisors :
    Finset.univ.image tailDivisorOfBits = tailPart.divisors := by
  refine' Finset.eq_of_subset_of_card_le ( Finset.image_subset_iff.mpr _ ) _ <;> norm_num [ tail_card_divisors, Fintype.card ];
  · exact fun x => ⟨ tailDivisorOfBits_dvd x, by native_decide ⟩;
  · native_decide

/-- There are exactly `512 = 2⁹` binary addresses. -/
theorem tail_binary_card : Fintype.card (Fin 9 → Bool) = 512 := by
  simp

/-! ## §4. The combined divisor stratification -/

/-- The divisors of the Monster order split multiplicatively across the two strata. -/
theorem monster_card_divisors_split :
    #monsterOrder.divisors = #weightedPart.divisors * #tailPart.divisors := by
  rw [monster_factorization, Nat.Coprime.card_divisors_mul weighted_tail_coprime]

/-- **Divisor stratification of the Monster order.**
    The number of divisors of `|M|` is the number of divisors of the weighted
    `Cl(0,6)` part, times the `2⁹ = 512` binary configurations of the tail primes.
    Each binary address of the tail thus indexes a full fiber of weighted divisors. -/
theorem monster_divisor_stratification :
    #monsterOrder.divisors = #weightedPart.divisors * 2 ^ 9 := by
  rw [monster_card_divisors_split, tail_card_eq_two_pow_nine]

/-- The explicit divisor count: `829080 * 512 = 424488960`. -/
theorem monster_card_divisors : #monsterOrder.divisors = 424488960 := by
  rw [monster_card_divisors_split, weighted_card_divisors, tail_card_divisors]

/-! ## §5. The Clifford bridge

The weighted half carries the Clifford algebra `Cl(0,6)` of dimension `2⁶ = 64`
(`cl06_finrank`), while the tail contributes the `2⁹ = 512` binary index. The
total `2⁶ · 2⁹ = 2¹⁵` mirrors the `Cl(0,15)` picture: six weighted Clifford
directions and nine binary tail directions. -/

/-- The six weighted primes carry a Clifford algebra of dimension `2⁶`. -/
theorem weighted_clifford_dim : Module.finrank ℝ (Cl0 6) = 2 ^ 6 := cl06_finrank

/-- The combined Clifford-plus-binary dimension count is `2¹⁵`. -/
theorem combined_dim :
    Module.finrank ℝ (Cl0 6) * Fintype.card (Fin 9 → Bool) = 2 ^ 15 := by
  rw [weighted_clifford_dim, tail_binary_card]; norm_num

end MonsterStratification