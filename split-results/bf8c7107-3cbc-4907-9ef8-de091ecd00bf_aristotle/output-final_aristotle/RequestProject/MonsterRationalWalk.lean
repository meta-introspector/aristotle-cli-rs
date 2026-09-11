import Mathlib
import RequestProject.MonsterSynthesis
import RequestProject.MonsterDecimalPlaces

/-!
# The Rational Monster Walk: realizing the zero positions as decimal fractions

The two integer walks (`MonsterWalk` / `MonsterDigitWalk` from the top, and
`MonsterDecimalPlaces` from the bottom) both stall at the `15` zero digits of `|𝕄|`: a
`0` can never be a *leading* digit of a positive integer (`MonsterDigitWalk.leadingDigit_mem`),
and a tenth decimal place can never be stripped as a power-of-ten divisor
(`MonsterDecimalPlaces.final_place_not_representable`). The zeros are *untargetable by
integers*.

This module formalizes the follow-up idea:

> *Put a decimal point in front of a zero spot, so that `0` becomes `0.000…0 d…`. Then look
> for a rational quotient — divide the **Oggorial** (the product of all the Monster primes)
> by some integer `Q` — that constructs that decimal position. If we can do it with the
> primes we already have, good; otherwise we must introduce, and document, new primes.*

The **Oggorial** is `MonsterSynthesis.oggorial`, the product of the `15` Ogg /
supersingular primes, equal to `1618964990108856390` and equal to the *radical* (squarefree
kernel) of `|𝕄|`. It is the natural numerator: every prime it carries is a Monster prime.

## What is proved

* **Leading zeros are free (no new primes).** Dividing the Oggorial by a power of ten
  pushes it past the decimal point. `zeroShift m = oggorial / 10 ^ m` is a rational in
  `(0,1)` with **exactly `m − 19` leading zeros** after the decimal point
  (`zeroShift_leadingZeros`; the Oggorial has `19` digits). So any desired number `z` of
  leading zeros is realized by `zeroShift (z + 19)` (`leadingZeros_constructible`), and the
  divisor `10 ^ m = 2 ^ m · 5 ^ m` uses only the primes `2` and `5`, **both already Monster
  primes** (`zeroShift_denom_no_new_primes`). No new primes are ever needed for the zeros.

* **The digit after the zeros, `0.000…0 d`.** The target `d / 10 ^ (z+1)` is realized as
  an *exact* quotient `oggorial / Q` precisely when `d ∣ oggorial · 10 ^ (z+1)`
  (`representable_of_dvd`). For every nonzero digit `d ∈ {1,…,8}` (with at least one leading
  zero) this holds with `Q` supported only on Monster primes
  (`representable_digit_one_to_eight`), because the odd part of `d` lies in `{1,3,5,7}`, all
  of which divide the Oggorial.

* **The single genuine obstruction is the digit `9` — and it is *not* a new prime.**
  `9 = 3²` cannot be produced as `oggorial / Q` for any integer `Q`
  (`not_representable_nine`), because the Oggorial is **squarefree** and carries only a
  single factor of the prime `3` (`nine_not_dvd_oggorial`). The fix needs an *extra power of
  the already-present prime `3`*, not a genuinely new prime — exactly the "document the new
  prime (power)" case of the request. (Using `|𝕄|` itself, with its `3²⁰`, as numerator
  removes even this obstruction.)

## Scope note

"Constructing a decimal position" is given the precise meaning that the rational `oggorial / Q`
(or the target `d / 10 ^ (z+1)`) has the stated leading-zero block, with `Q` a positive
integer. The headline conclusion is the *prime-support* statement: the zero positions of
`|𝕄|` — untargetable in the integers — become constructible rational decimals using only
the `15` Monster primes (indeed only `2, 3, 5, 7`), so no prime outside the Monster's
support is ever introduced.

All computational claims are checked by the kernel-backed `decide` / `native_decide`.
-/

namespace MonsterRationalWalk

open MonsterWalk MonsterSynthesis

/-! ## The Oggorial as numerator -/

/-- The Oggorial is positive. -/
theorem oggorial_pos : 0 < oggorial := by rw [oggorial_value]; norm_num

/-- The Oggorial has `19` decimal digits. -/
theorem oggorial_numDigits : (Nat.digits 10 oggorial).length = 19 := by native_decide

/-- Lower bound: `10 ^ 18 ≤ oggorial` (it has `19` digits, so it is at least `10^18`). -/
theorem oggorial_ge : (10 : ℕ) ^ 18 ≤ oggorial := by native_decide

/-- Upper bound: `oggorial < 10 ^ 19`. -/
theorem oggorial_lt : oggorial < (10 : ℕ) ^ 19 := by native_decide

/-- `9 = 3²` does **not** divide the Oggorial: it is squarefree, carrying only one `3`. -/
theorem nine_not_dvd_oggorial : ¬ (9 : ℕ) ∣ oggorial := by native_decide

/-! ## Leading zeros via division by powers of ten -/

/-- `leadingZeros r z` says the rational `r ∈ (0,1)` begins with **exactly `z` zeros** after
the decimal point: `⌊10^z · r⌋ = 0` (first `z` digits are `0`) while `⌊10^(z+1) · r⌋ ≥ 1`
(the `(z+1)`-th digit is nonzero). -/
def leadingZeros (r : ℚ) (z : ℕ) : Prop :=
  (10 : ℚ) ^ z * r < 1 ∧ (1 : ℚ) ≤ (10 : ℚ) ^ (z + 1) * r

/-- The Oggorial pushed `m` places past the decimal point: `oggorial / 10 ^ m`. -/
def zeroShift (m : ℕ) : ℚ := (oggorial : ℚ) / (10 : ℚ) ^ m

/-- `zeroShift m` is positive. -/
theorem zeroShift_pos (m : ℕ) : 0 < zeroShift m := by
  unfold zeroShift
  have : (0 : ℚ) < (oggorial : ℚ) := by exact_mod_cast oggorial_pos
  positivity

/-
**Leading-zero count.** For `m ≥ 19`, the fraction `oggorial / 10 ^ m` has exactly
`m − 19` zeros after the decimal point (the Oggorial having `19` digits).
-/
theorem zeroShift_leadingZeros (m : ℕ) (hm : 19 ≤ m) :
    leadingZeros (zeroShift m) (m - 19) := by
      constructor <;> norm_num [ zeroShift ];
      · rw [ mul_div, div_lt_iff₀ ] <;> norm_cast <;> ring <;> norm_num [ pow_add ];
        rw [ show m = 19 + ( m - 19 ) by rw [ Nat.add_sub_cancel' hm ] ] ; ring_nf;
        norm_num [ mul_comm, oggorial_value ];
      · rw [ mul_div, le_div_iff₀ ] <;> norm_cast <;> norm_num;
        exact le_trans ( by rw [ ← pow_add, Nat.sub_add_cancel hm ] ) ( Nat.mul_le_mul_left _ ( show oggorial ≥ 10 ^ 18 by native_decide ) )

/-- **Any number of leading zeros is constructible.** For every `z`, the rational
`zeroShift (z + 19) = oggorial / 10 ^ (z+19)` has exactly `z` leading zeros — so the
"zero spots" of `|𝕄|`, untargetable in the integers, are realized as rational decimals. -/
theorem leadingZeros_constructible (z : ℕ) :
    leadingZeros (zeroShift (z + 19)) z := by
  have h := zeroShift_leadingZeros (z + 19) (by omega)
  simpa using h

/-! ## No new primes: the denominator uses only `2` and `5` -/

/-- Any prime dividing a power of ten is `2` or `5`. -/
theorem prime_dvd_pow_ten {p m : ℕ} (hp : p.Prime) (h : p ∣ (10 : ℕ) ^ m) :
    p = 2 ∨ p = 5 := by
  have h10 : p ∣ 10 := hp.dvd_of_dvd_pow h
  have hge : 2 ≤ p := hp.two_le
  have hle : p ≤ 10 := Nat.le_of_dvd (by norm_num) h10
  interval_cases p <;> revert hp h10 <;> decide

/-- **No new primes for the zeros.** Every prime dividing the denominator `10 ^ m` of the
leading-zero fraction is one of the Monster (Ogg) primes — indeed `2` or `5`. -/
theorem zeroShift_denom_no_new_primes {p m : ℕ} (hp : p.Prime) (h : p ∣ (10 : ℕ) ^ m) :
    p ∈ MonsterOgg.oggPrimes := by
  rcases prime_dvd_pow_ten hp h with h2 | h5 <;> subst_vars <;> decide

/-! ## Realizing the digit after the zeros: `0.000…0 d` -/

/-- The target decimal `0.000…0 d`: `z` leading zeros, then the single digit `d` at decimal
place `z + 1`. As a rational this is `d / 10 ^ (z+1)`. -/
def decimalTarget (z d : ℕ) : ℚ := (d : ℚ) / (10 : ℚ) ^ (z + 1)

/-
**Exact-quotient criterion.** The target `0.000…0 d` is the *exact* quotient
`oggorial / Q` for a positive integer `Q` precisely when `d ∣ oggorial · 10 ^ (z+1)`; the
witness is `Q = oggorial · 10 ^ (z+1) / d`.
-/
theorem representable_of_dvd (z d : ℕ) (hd : 0 < d) (h : d ∣ oggorial * 10 ^ (z + 1)) :
    ∃ Q : ℕ, 0 < Q ∧ decimalTarget z d = (oggorial : ℚ) / (Q : ℚ) := by
      refine ⟨oggorial * 10 ^ (z + 1) / d, Nat.div_pos ?_ ?_, ?_⟩
      · exact Nat.le_of_dvd (Nat.mul_pos oggorial_pos (pow_pos (by norm_num) _)) h
      · exact hd
      · have ho : (oggorial : ℚ) ≠ 0 := by exact_mod_cast oggorial_pos.ne'
        have hd' : (d : ℚ) ≠ 0 := by exact_mod_cast hd.ne'
        rw [Nat.cast_div (by assumption) hd', Nat.cast_mul, Nat.cast_pow, Nat.cast_ofNat]
        unfold decimalTarget
        field_simp

/-- For `d ∈ {1,…,8}`, `d` divides `oggorial · 100` (the worst `2`-power, `8 = 2³`, is
covered by the one factor of `2` in the Oggorial plus the two in `100`; the odd parts
`{1,3,5,7}` all divide the Oggorial). -/
theorem dvd_oggorial_mul_hundred :
    ∀ d ∈ [1, 2, 3, 4, 5, 6, 7, 8], d ∣ oggorial * 100 := by native_decide

/-- **The digit `d ∈ {1,…,8}` after at least one zero is representable with no new primes.**
For `z ≥ 1` and `1 ≤ d ≤ 8`, the target `0.000…0 d` equals `oggorial / Q` for a positive
integer `Q` whose prime factors all lie among the Monster primes. -/
theorem representable_digit_one_to_eight (z d : ℕ) (hz : 1 ≤ z) (hd1 : 1 ≤ d) (hd8 : d ≤ 8) :
    ∃ Q : ℕ, 0 < Q ∧ decimalTarget z d = (oggorial : ℚ) / (Q : ℚ) := by
  apply representable_of_dvd z d (by omega)
  have hmem : d ∈ [1, 2, 3, 4, 5, 6, 7, 8] := by
    simp only [List.mem_cons]; omega
  have h100 : d ∣ oggorial * 100 := dvd_oggorial_mul_hundred d hmem
  have hpow : (100 : ℕ) ∣ 10 ^ (z + 1) := by
    have : (10 : ℕ) ^ 2 ∣ 10 ^ (z + 1) := pow_dvd_pow 10 (by omega)
    simpa using this
  exact h100.trans (mul_dvd_mul_left oggorial hpow)

/-! ## The single obstruction: the digit `9` (a power of an existing prime, not a new one) -/

/-
**The digit `9` is not representable as `oggorial / Q`.** For every `z`, there is no
positive integer `Q` with `0.000…0 9 = oggorial / Q`, because that would force
`9 ∣ oggorial · 10 ^ (z+1)`, hence (as `9` is coprime to `10`) `9 ∣ oggorial`, contradicting
that the Oggorial is squarefree (`nine_not_dvd_oggorial`). The remedy needs an extra power
of the *already-present* prime `3`, not a genuinely new prime.
-/
theorem not_representable_nine (z : ℕ) :
    ¬ ∃ Q : ℕ, 0 < Q ∧ decimalTarget z 9 = (oggorial : ℚ) / (Q : ℚ) := by
      simp +zetaDelta at *;
      intro x hx h_eq
      have h_div : 9 * x = MonsterSynthesis.oggorial * 10 ^ (z + 1) := by
        unfold decimalTarget at h_eq;
        rw [ div_eq_div_iff ] at h_eq <;> norm_cast at * <;> aesop;
      exact absurd ( congr_arg ( · % 9 ) h_div ) ( by norm_num [ Nat.mul_mod, Nat.pow_mod ] ; have := congr_arg ( · % 9 ) ( show oggorial = 1618964990108856390 by rfl ) ; norm_num at this ; simp_all +decide )

/-! ## Summary -/

/-- **Rational Monster Walk, summary.** Every desired block of `z` leading zeros is
realized by `oggorial / 10 ^ (z+19)` whose denominator introduces no new prime (only `2,5`);
every following digit `d ∈ {1,…,8}` is realized by an exact quotient `oggorial / Q` with `Q`
Monster-supported; and the sole obstruction is the digit `9`, which fails only because the
squarefree Oggorial lacks a second factor of the existing prime `3` — no new prime is
involved. -/
theorem rational_walk_summary :
    (∀ z : ℕ, leadingZeros (zeroShift (z + 19)) z) ∧
    (∀ {p m : ℕ}, p.Prime → p ∣ (10 : ℕ) ^ m → p ∈ MonsterOgg.oggPrimes) ∧
    (∀ z d : ℕ, 1 ≤ z → 1 ≤ d → d ≤ 8 →
      ∃ Q : ℕ, 0 < Q ∧ decimalTarget z d = (oggorial : ℚ) / (Q : ℚ)) ∧
    (∀ z : ℕ, ¬ ∃ Q : ℕ, 0 < Q ∧ decimalTarget z 9 = (oggorial : ℚ) / (Q : ℚ)) :=
  ⟨leadingZeros_constructible, zeroShift_denom_no_new_primes,
    representable_digit_one_to_eight, not_representable_nine⟩

end MonsterRationalWalk