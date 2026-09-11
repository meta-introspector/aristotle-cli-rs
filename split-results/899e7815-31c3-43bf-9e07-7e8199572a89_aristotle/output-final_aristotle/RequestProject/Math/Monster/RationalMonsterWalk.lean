/-
# RationalMonsterWalk.lean
## The "Zero Walk": targeting the zero spots of `|𝕄|` with decimal fractions

The integer **Monster Walk** can target every *nonzero* decimal digit of the Monster
order `|𝕄|` by a leading digit of an integer quotient, but the leading digit of a
positive integer is always in `{1, …, 9}`, so the **zero positions of `|𝕄|` are
untargetable as leading integer digits**.

This module formalizes the *rational* extension proposed to repair this — the
**Zero Walk** — and answers the concrete question it raises:

> To realize a "zero spot" as a decimal place `0.0…0d…`, divide the **Oggorial**
> `Ω = 2·3·5·…·71` (the radical / squarefree kernel of `|𝕄|`) by some quotient.
> Can this be done using only the numbers we already have, or must we introduce
> *new primes* and document them?

### The answer (no new primes are needed)

Every decimal place is a power of ten, and the decimal radix factors as `10 = 2 · 5`
with **both `2` and `5` supersingular** (Monster) primes. Hence the denominator of the
quotient producing the `k`-th decimal place, `Ω · 10^k`, has its **entire prime support
inside the 15 supersingular primes** — the Zero Walk never leaves the Monster's prime
universe and never requires a new prime.

## What is formalized

* `monsterOrder_decimal_digits` / `monsterOrder_zero_digits` /
  `monsterOrder_nonzero_digits` — the `54 = 39 + 15` decimal split of `|𝕄|`.
* `monsterOrder_trailingZeros` — `|𝕄|` ends in exactly `9` zeros (the "nine zeros"
  run), which equals `v₅(|𝕄|) = 9` (the smaller of `v₂ = 46`, `v₅ = 9`).
* `ten_eq_two_mul_five` / `two_five_supersingular` — `10 = 2·5`, both supersingular.
* `oggorial_decimal_place` — `Ω / (Ω · 10^k) = 10^(-k)`: dividing the Oggorial by
  `Ω · 10^k` yields exactly the `k`-th decimal place.
* `tenPow_primeFactors_subset` / `denominator_primeFactors` — the denominator's prime
  support stays inside the supersingular primes.
* `rational_walk_no_new_primes` — the capstone: for every `k`, the Zero-Walk quotient
  is correct *and* introduces no prime outside the Monster's support.
* `nine_zeros_place` — the specific "nine zeros" instance matching the trailing run
  of `|𝕄|`.

All proofs use only the standard allowed axioms.
-/

import Mathlib
import RequestProject.Math.Monster.Slice.MonsterOrder
import RequestProject.Math.Monster.Divisors

namespace RationalMonsterWalk

open Divisors MonsterSlice

/-! ## The decimal landscape of `|𝕄|`: the `39 / 15` split -/

/-- `|𝕄|` has `54` decimal digits. -/
theorem monsterOrder_decimal_digits :
    (Nat.digits 10 monsterOrder).length = 54 := by native_decide

/-- Exactly `15` of the `54` decimal digits of `|𝕄|` are zeros — the "zero spots". -/
theorem monsterOrder_zero_digits :
    (Nat.digits 10 monsterOrder).count 0 = 15 := by native_decide

/-- The remaining `39` decimal digits of `|𝕄|` are nonzero. -/
theorem monsterOrder_nonzero_digits :
    ((Nat.digits 10 monsterOrder).filter (· ≠ 0)).length = 39 := by native_decide

/-- The `39 / 15` split adds up to the full `54` digits. -/
theorem monsterOrder_digit_split :
    ((Nat.digits 10 monsterOrder).filter (· ≠ 0)).length
      + (Nat.digits 10 monsterOrder).count 0 = 54 := by native_decide

/-- The number of *trailing* decimal zeros of `n` (the little-endian run of leading
zeros in Mathlib's least-significant-first `Nat.digits`). -/
def trailingZeros (n : ℕ) : ℕ := ((Nat.digits 10 n).takeWhile (· = 0)).length

/-- `|𝕄|` ends in exactly **nine** zeros — the "nine zeros" run of the Zero Walk. -/
theorem monsterOrder_trailingZeros : trailingZeros monsterOrder = 9 := by native_decide

/-- The nine trailing zeros are exactly `v₅(|𝕄|) = 9`, the smaller of the `2`- and
`5`-adic valuations (`v₂ = 46`, `v₅ = 9`), i.e. the number of factors of `10` in `|𝕄|`. -/
theorem monsterOrder_trailingZeros_eq_v5 :
    trailingZeros monsterOrder = monsterOrder.factorization 5 ∧
    monsterOrder.factorization 5 = 9 ∧
    monsterOrder.factorization 2 = 46 := by native_decide

/-! ## The radix factors entirely inside the Monster's primes -/

/-- The decimal radix factors as `10 = 2 · 5`. -/
theorem ten_eq_two_mul_five : (10 : ℕ) = 2 * 5 := by norm_num

/-- Both factors of the radix, `2` and `5`, are supersingular (Monster) primes. -/
theorem two_five_supersingular :
    2 ∈ supersingularPrimes ∧ 5 ∈ supersingularPrimes := by decide

/-- The prime factors of any power of ten lie among `{2, 5}`, the supersingular pair. -/
theorem tenPow_primeFactors_subset (k : ℕ) :
    (10 ^ k).primeFactors ⊆ ({2, 5} : Finset ℕ) := by
  rcases Nat.eq_zero_or_pos k with h | h
  · subst h; simp
  · rw [Nat.primeFactors_pow _ (by omega)]; native_decide

/-- `{2, 5}` are among the prime factors of the Oggorial. -/
theorem two_five_subset_oggorial :
    ({2, 5} : Finset ℕ) ⊆ oggorial.primeFactors := by native_decide

/-! ## The rational construction of a decimal place from the Oggorial -/

/-- **The decimal place is a quotient of the Oggorial.** Dividing the Oggorial `Ω` by
`Ω · 10^k` yields exactly `10^(-k)` — the value of the `k`-th decimal place
`0.0…0 1` (with `k-1` leading zeros). No new numbers beyond `Ω` and the radix are used. -/
theorem oggorial_decimal_place (k : ℕ) :
    (oggorial : ℚ) / (oggorial * 10 ^ k) = 1 / 10 ^ k := by
  have ho : (oggorial : ℚ) ≠ 0 := by
    have : (0 : ℚ) < oggorial := by unfold oggorial; norm_num
    exact ne_of_gt this
  have ht : (10 : ℚ) ^ k ≠ 0 := by positivity
  field_simp

/-- **The denominator introduces no new primes.** The prime support of the Zero-Walk
denominator `Ω · 10^k` is *exactly* the prime support of the Oggorial — the 15
supersingular primes — because every prime of `10^k` is already `2` or `5`. -/
theorem denominator_primeFactors (k : ℕ) :
    (oggorial * 10 ^ k).primeFactors = oggorial.primeFactors := by
  rw [Nat.primeFactors_mul (by decide) (by positivity)]
  refine Finset.union_eq_left.mpr ?_
  exact (tenPow_primeFactors_subset k).trans two_five_subset_oggorial

/-- **Capstone — the Rational Monster ("Zero") Walk needs no new primes.**

For every decimal place `k`:
1. the value is reconstructed exactly as the Oggorial quotient `Ω / (Ω · 10^k) = 10^(-k)`;
2. the denominator `Ω · 10^k` has its entire prime support inside the supersingular
   primes (no prime outside the Monster's universe is ever introduced).

Thus the `15` untargetable zero spots of the integer Monster Walk become fully
targetable rational decimal places, all built from the numbers we already have. -/
theorem rational_walk_no_new_primes (k : ℕ) :
    (oggorial : ℚ) / (oggorial * 10 ^ k) = 1 / 10 ^ k ∧
    (oggorial * 10 ^ k).primeFactors = oggorial.primeFactors ∧
    (oggorial * 10 ^ k).primeFactors ⊆
      ({2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71} : Finset ℕ) := by
  refine ⟨oggorial_decimal_place k, denominator_primeFactors k, ?_⟩
  rw [denominator_primeFactors k, oggorial_primeFactors]

/-- **The "nine zeros" instance.** The trailing nine-zero run of `|𝕄|` corresponds to the
decimal place `10^(-9) = 0.000000001`, built as `Ω / (Ω · 10^9)`, whose denominator's
prime support is precisely the 15 supersingular primes. -/
theorem nine_zeros_place :
    (oggorial : ℚ) / (oggorial * 10 ^ 9) = 1 / 1000000000 ∧
    (oggorial * 10 ^ 9).primeFactors = oggorial.primeFactors := by
  refine ⟨?_, denominator_primeFactors 9⟩
  rw [oggorial_decimal_place 9]; norm_num

end RationalMonsterWalk
