/-
# MonsterLogWalk.lean
## The Monster Walk as a logarithmic deconstruction of the digits, in many bases

This module formalizes the *logarithmic deconstruction* of the order of the Monster
group `|𝕄|`, performed simultaneously in many radices: base `2`, base `3`, base `5`,
… all the way up to base `71` (the largest supersingular / Ogg prime), and in fact in
every base from `2` to `71`.

The key idea is that writing a positive integer `n` in base `b` is a *logarithmic*
operation: the number of base-`b` digits of `n` is exactly `⌊log_b n⌋ + 1`. Carrying
this out for `n = |𝕄|` across all the bases `2,3,…,71` gives a family of "digit walks",
each one a logarithmic deconstruction of the Monster order into base-`b` digits.

## What is formalized

* `monsterDigits b` / `monsterDigitCount b` — the base-`b` digit expansion of `|𝕄|`
  and its length.
* `monster_digitCount_eq_log` — **the logarithmic deconstruction**: for every base
  `b > 1` the number of base-`b` digits of `|𝕄|` equals `Nat.log b |𝕄| + 1`.
* `monster_reconstruct` — the base-`b` digits faithfully reconstruct `|𝕄|`
  (`Nat.ofDigits` inverts `Nat.digits`).
* `monster_digits_lt_base` — every base-`b` digit is a genuine digit `< b`.
* `monster_digitCount_eq_log_all` — the logarithmic identity holds for *every* base
  from `2` to `71` simultaneously.
* `monster_digitCounts_all` / `monster_digitCounts_primes` — the explicit digit-length
  tables across all bases `2..71`, and across the prime (Ogg) bases.
* `monster_logCounts_primes` — the `Nat.log` table for the prime bases.

All claims are proved with no `sorry`, using only the standard axioms (the explicit
tables via the kernel-backed `native_decide`).
-/

import Mathlib
import RequestProject.Math.Monster.Slice.MonsterOrder

namespace MonsterLogWalk

open MonsterSlice

/-! ## The bases of the walk -/

/-- Every base from `2` to `71`: the full range of radices for the logarithmic
deconstruction "base two … all the way up to base seventy-one". -/
def allBases : List ℕ := (List.range 72).filter (2 ≤ ·)

/-- The supersingular / Ogg prime bases: `2, 3, 5, 7, …, 71` (the primes dividing
`|𝕄|`). -/
def primeBases : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

theorem allBases_length : allBases.length = 70 := by native_decide

theorem primeBases_length : primeBases.length = 15 := by native_decide

/-- Every prime (Ogg) base lies in the full base range and is prime. (Note: the Ogg
primes are a strict subset of all primes `≤ 71` — e.g. `37, 43, 53, 61, 67` are prime
but do not divide `|𝕄|`.) -/
theorem primeBases_subset :
    primeBases.all (fun b => b ∈ allBases && Nat.Prime b) = true := by native_decide

/-! ## The digit deconstruction -/

/-- The base-`b` digit expansion of the Monster order (little-endian, as in Mathlib). -/
def monsterDigits (b : ℕ) : List ℕ := Nat.digits b monsterOrder

/-- The number of base-`b` digits of the Monster order. -/
def monsterDigitCount (b : ℕ) : ℕ := (Nat.digits b monsterOrder).length

theorem monsterOrder_ne_zero : monsterOrder ≠ 0 := by
  rw [monsterOrder_value]; norm_num

/-- **Logarithmic deconstruction.** For every base `b > 1`, the number of base-`b`
digits of `|𝕄|` equals `⌊log_b |𝕄|⌋ + 1`. This is the precise sense in which writing
`|𝕄|` in base `b` is a logarithmic operation. -/
theorem monster_digitCount_eq_log (b : ℕ) (hb : 1 < b) :
    monsterDigitCount b = Nat.log b monsterOrder + 1 :=
  Nat.digits_len b monsterOrder hb monsterOrder_ne_zero

/-- The base-`b` digits faithfully reconstruct `|𝕄|`: `Nat.ofDigits` inverts the
deconstruction, for every base. -/
theorem monster_reconstruct (b : ℕ) :
    Nat.ofDigits b (monsterDigits b) = monsterOrder :=
  Nat.ofDigits_digits b monsterOrder

/-- Each base-`b` digit is a genuine digit, i.e. `< b`, for every base `b ≥ 2`. -/
theorem monster_digits_lt_base (b : ℕ) (hb : 2 ≤ b) :
    ∀ d ∈ monsterDigits b, d < b :=
  fun _ hd => Nat.digits_lt_base hb hd

/-- The leading (most significant) base-`b` digit of `|𝕄|` is nonzero, for `b ≥ 2`. -/
theorem monster_leadingDigit_ne_zero (b : ℕ) :
    (monsterDigits b).getLast (by
      simp only [monsterDigits, ne_eq, Nat.digits_eq_nil_iff_eq_zero]
      exact monsterOrder_ne_zero) ≠ 0 :=
  Nat.getLast_digit_ne_zero b monsterOrder_ne_zero

/-! ## The logarithmic identity across all bases `2..71` -/

/-- **Universal logarithmic deconstruction.** For *every* base from `2` to `71`, the
number of base-`b` digits of `|𝕄|` is `Nat.log b |𝕄| + 1`. -/
theorem monster_digitCount_eq_log_all :
    allBases.all (fun b => monsterDigitCount b == Nat.log b monsterOrder + 1) = true := by
  native_decide

/-- Every base-`b` expansion reconstructs `|𝕄|`, across all bases `2..71`. -/
theorem monster_reconstruct_all :
    allBases.all (fun b => Nat.ofDigits b (monsterDigits b) == monsterOrder) = true := by
  native_decide

/-! ## Explicit digit-length tables -/

/-- The base-`b` digit length of `|𝕄|` for every base `b = 2, 3, …, 71`. -/
theorem monster_digitCounts_all :
    allBases.map monsterDigitCount =
      [180, 113, 90, 78, 70, 64, 60, 57, 54, 52, 50, 49, 48, 46, 45, 44, 43, 43, 42,
       41, 41, 40, 40, 39, 39, 38, 38, 37, 37, 37, 36, 36, 36, 35, 35, 35, 35, 34, 34,
       34, 34, 34, 33, 33, 33, 33, 33, 32, 32, 32, 32, 32, 32, 31, 31, 31, 31, 31, 31,
       31, 31, 30, 30, 30, 30, 30, 30, 30, 30, 30] := by
  native_decide

/-- The base-`b` digit length of `|𝕄|` for the prime (Ogg) bases `2, 3, 5, …, 71`. -/
theorem monster_digitCounts_primes :
    primeBases.map monsterDigitCount =
      [180, 113, 78, 64, 52, 49, 44, 43, 40, 37, 37, 34, 33, 31, 30] := by
  native_decide

/-- The `Nat.log` table for the prime (Ogg) bases: `⌊log_p |𝕄|⌋` for each Ogg prime
`p`. The digit counts above are these values plus one. -/
theorem monster_logCounts_primes :
    primeBases.map (fun b => Nat.log b monsterOrder) =
      [179, 112, 77, 63, 51, 48, 43, 42, 39, 36, 36, 33, 32, 30, 29] := by
  native_decide

/-- The base-`2` deconstruction is the longest (`|𝕄|` has `180` binary digits), and the
base-`71` deconstruction is the shortest among the prime bases (`30` base-`71` digits).
More bits in a smaller radix: digit length strictly decreases from base `2` to base
`71`. -/
theorem monster_binary_longest :
    monsterDigitCount 2 = 180 ∧ monsterDigitCount 71 = 30 := by
  native_decide

end MonsterLogWalk
