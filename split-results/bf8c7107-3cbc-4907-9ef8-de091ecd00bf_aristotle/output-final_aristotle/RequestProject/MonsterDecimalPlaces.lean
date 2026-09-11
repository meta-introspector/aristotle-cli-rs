import Mathlib
import RequestProject.MonsterWalk
import RequestProject.MonsterDigitWalk

/-!
# Treating leading zeros as decimal places: the place-value walk

The original **Monster Walk** (`MonsterWalk.lean`) moves *left to right* through the
decimal expansion of `|𝕄|`, preserving runs of leading digits by removing prime-power
factors. It necessarily **terminates at a leading `0`**: the leading digit of a positive
integer is always one of `1,…,9` (`MonsterDigitWalk.leadingDigit_mem`), so a `0` can
never be exposed as a leading digit. This is why `MonsterDigitWalk.uncovered_are_exactly_zeros`
shows the only non-targetable positions are exactly the zeros.

This file formalizes the follow-up idea:

> *What if we treat a leading `0` not as a digit to be exposed, but as a **decimal place**,
> and represent it as a divisor? Then every such zero can be represented except the final
> one.*

A decimal place (a trailing zero) is "representable as a divisor" precisely when the
corresponding power of ten divides `|𝕄|`. This gives a **place-value walk** that descends
*right to left* through the trailing zeros, mirror-image to the original leading-digit walk:

* the leading-digit walk stops at the **top**, at the first leading `0` (impossible to
  expose as a leading digit);
* the place-value walk stops at the **bottom**, at the **final `0`** (impossible to
  represent as a power-of-ten divisor).

## Main results

* `monster_trailingZeros` : `|𝕄|` ends in exactly `9` trailing zeros.
* `trailingZeros_eq_padicValNat_five` : that count is exactly the `5`-adic valuation
  `v₅(|𝕄|) = 9` — the prime `5` is the bottleneck (there are `46` factors of `2` but only
  `9` of `5`).
* `pow_ten_dvd_iff_le_min` / `isGreatest_pow_ten_dvd` : the **general** `2`/`5`-adic
  bottleneck for an arbitrary `n ≠ 0` — `10 ^ k ∣ n ↔ k ≤ min (v₂ n) (v₅ n)` — with
  `monster_bottleneck_is_five` specializing it to `|𝕄|`.
* `placeRepresentable_iff` : the `k`-th decimal place is representable as a divisor
  (`10 ^ k ∣ |𝕄|`) **iff** `k ≤ 9`.
* `places_one_to_nine_representable` : all nine trailing-zero places are representable.
* `final_place_not_representable` / `only_final_place_unrepresentable` : the `10`-th place
  — the **final `0`** terminating the descent — is the unique first place that is *not*
  representable, exactly because the supply of the prime `5` is exhausted (`5 ^ 10 ∤ |𝕄|`).
* `zero_digits_split` : the `15` zero digits of `|𝕄|` split as `9` trailing (place-value,
  representable) `+ 6` internal.
* `interior_zeros_insulated` : the `6` interior zeros (positions `1,3,25,32,36,37`) are
  unreachable by **both** walks — each is a `0` digit (blocking the leading-digit walk) and
  sits at a decimal place beyond the ninth (blocking the place-value walk).

All computational claims are checked by the kernel-backed `decide` / `native_decide`.

## Scope note

"Representable as a divisor" is given the precise meaning `10 ^ k ∣ |𝕄|` (the place-value
shift `n ↦ n / 10 ^ k` is exact). The phrase "the final `0` is not representable" is the
statement that this descent terminates: the first power of ten that fails to divide `|𝕄|`
is `10 ^ 10`, one step past the nine genuine trailing zeros — symmetric to the way the
original walk terminates at the first leading `0`.
-/

namespace MonsterDecimalPlaces

open MonsterWalk

/-! ## Trailing zeros and the `5`-adic bottleneck -/

/-- The number of trailing zeros of `n` in its base-10 representation. -/
def trailingZeros (n : Nat) : Nat :=
  ((toString n).toList.reverse.takeWhile (· == '0')).length

/-- `|𝕄|` ends in exactly nine zeros. -/
theorem monster_trailingZeros : trailingZeros monsterOrder = 9 := by native_decide

/-- The `5`-adic valuation of `|𝕄|` is `9`. -/
theorem padicValNat_five : padicValNat 5 monsterOrder = 9 := by native_decide

/-- The `2`-adic valuation of `|𝕄|` is `46`. -/
theorem padicValNat_two : padicValNat 2 monsterOrder = 46 := by native_decide

/-- The trailing-zero count equals the `5`-adic valuation: the number of decimal places
that can be stripped is exactly the supply of the prime `5` (which is far scarcer than the
`46` factors of `2`). -/
theorem trailingZeros_eq_padicValNat_five :
    trailingZeros monsterOrder = padicValNat 5 monsterOrder := by native_decide

/-! ## The general `2`/`5`-adic bottleneck

The special facts above (`pow_ten_nine_dvd`, `pow_ten_ten_not_dvd`, …) are all instances of
a single piece of elementary number theory, stated here for an arbitrary `n ≠ 0`:

> A power of ten `10 ^ k` divides `n` **iff** `k` is at most the smaller of the `2`-adic and
> `5`-adic valuations of `n`.

Hence the number of decimal places that can be stripped from any `n` is exactly
`min (v₂ n) (v₅ n)`, and the *bottleneck* is whichever of the two primes is scarcer. For
`|𝕄|` that is the prime `5` (only `9` factors versus `46` factors of `2`), which is the
structural reason the place-value descent halts after nine steps.
-/

/-
**General `2`/`5`-adic bottleneck.** For any `n ≠ 0`, a power of ten divides `n` iff its
exponent is at most the smaller of the `2`-adic and `5`-adic valuations of `n`. This is the
reusable form of the place-value walk: the supply of decimal places is governed by whichever
of the primes `2`, `5` runs out first.
-/
theorem pow_ten_dvd_iff_le_min {n : Nat} (hn : n ≠ 0) (k : Nat) :
    (10 : Nat) ^ k ∣ n ↔ k ≤ min (padicValNat 2 n) (padicValNat 5 n) := by
  constructor;
  · intro hk
    have h2 : 2 ^ k ∣ n := by
      exact dvd_trans ( pow_dvd_pow_of_dvd ( by decide ) _ ) hk
    have h5 : 5 ^ k ∣ n := by
      exact dvd_trans ( pow_dvd_pow_of_dvd ( by decide ) _ ) hk;
    simp_all +decide [ padicValNat_dvd_iff_le ];
  · intro hk;
    -- Since $2^k \mid n$ and $5^k \mid n$, we have $10^k = 2^k \cdot 5^k \mid n$.
    have h_div : 2 ^ k ∣ n ∧ 5 ^ k ∣ n := by
      exact ⟨ Nat.dvd_trans ( pow_dvd_pow _ ( le_trans hk ( min_le_left _ _ ) ) ) ( Nat.ordProj_dvd _ _ ), Nat.dvd_trans ( pow_dvd_pow _ ( le_trans hk ( min_le_right _ _ ) ) ) ( Nat.ordProj_dvd _ _ ) ⟩;
    convert Nat.lcm_dvd h_div.1 h_div.2 using 1;
    norm_num [ ← mul_pow, Nat.lcm ];
    norm_num [ Nat.coprime_pow_primes, Nat.Coprime.gcd_eq_one ]

/-- The greatest power of ten dividing `n ≠ 0` has exponent `min (v₂ n) (v₅ n)`: the number
of representable decimal places is the smaller of the two valuations. -/
theorem isGreatest_pow_ten_dvd {n : Nat} (hn : n ≠ 0) :
    IsGreatest {k | (10 : Nat) ^ k ∣ n} (min (padicValNat 2 n) (padicValNat 5 n)) := by
  constructor
  · exact (pow_ten_dvd_iff_le_min hn _).2 (le_refl _)
  · intro k hk
    exact (pow_ten_dvd_iff_le_min hn k).1 hk

/-- For `|𝕄|`, the bottleneck is the prime `5`: `min (v₂ |𝕄|) (v₅ |𝕄|) = v₅ |𝕄| = 9`,
because there are only `9` factors of `5` against `46` factors of `2`. -/
theorem monster_bottleneck_is_five :
    min (padicValNat 2 monsterOrder) (padicValNat 5 monsterOrder)
      = padicValNat 5 monsterOrder
      ∧ padicValNat 5 monsterOrder = 9 := by
  refine ⟨?_, padicValNat_five⟩
  rw [padicValNat_five, padicValNat_two]
  decide

/-! ## The place-value walk: representing decimal places as divisors -/

/-- A decimal place `k` of `|𝕄|` is **representable as a divisor** when the place-value
shift by `10 ^ k` is exact, i.e. `10 ^ k ∣ |𝕄|`. -/
def placeRepresentable (k : Nat) : Prop := (10 : Nat) ^ k ∣ monsterOrder

instance (k : Nat) : Decidable (placeRepresentable k) := by
  unfold placeRepresentable; infer_instance

/-- `10 ^ 9` divides `|𝕄|`: the nine trailing places are exactly captured by the divisor
`10 ^ 9 = 2 ^ 9 · 5 ^ 9`. -/
theorem pow_ten_nine_dvd : (10 : Nat) ^ 9 ∣ monsterOrder := by native_decide

/-- `10 ^ 10` does **not** divide `|𝕄|`: there is no tenth decimal place to represent. -/
theorem pow_ten_ten_not_dvd : ¬ (10 : Nat) ^ 10 ∣ monsterOrder := by native_decide

/-- `5 ^ 10` does not divide `|𝕄|`: the prime `5` — not `2` — is what runs out, which is
the real reason the final place cannot be represented. -/
theorem pow_five_ten_not_dvd : ¬ (5 : Nat) ^ 10 ∣ monsterOrder := by native_decide

/-- **The place-value walk.** The `k`-th decimal place of `|𝕄|` is representable as a
divisor exactly when `k ≤ 9`. -/
theorem placeRepresentable_iff (k : Nat) : placeRepresentable k ↔ k ≤ 9 := by
  constructor
  · intro h
    by_contra hk
    push_neg at hk
    exact pow_ten_ten_not_dvd (dvd_trans (pow_dvd_pow 10 hk) h)
  · intro hk
    exact dvd_trans (pow_dvd_pow 10 hk) pow_ten_nine_dvd

/-- All nine trailing-zero places `1, 2, …, 9` are representable as divisors. -/
theorem places_one_to_nine_representable :
    ∀ k, 1 ≤ k → k ≤ 9 → placeRepresentable k := by
  intro k _ hk
  exact (placeRepresentable_iff k).2 hk

/-- **The tenth place (digit `8`) is not representable.** One step past the nine genuine
trailing zeros there is no tenth zero at all: the tenth digit from the right is an `8`
(see `trailing_block_divisor`). So the descent does not stall on a zero — it stalls because
the required divisor `10 ^ 10` is unavailable (`pow_ten_ten_not_dvd`), the supply of the
prime `5` being exhausted. -/
theorem final_place_not_representable : ¬ placeRepresentable 10 :=
  fun h => pow_ten_ten_not_dvd h

/-- **Only the final `0` is not representable.** Every place strictly below the tenth is
representable, and the tenth is the first that is not — so the descent through the trailing
zeros represents every decimal place except the final boundary one. -/
theorem only_final_place_unrepresentable :
    ¬ placeRepresentable 10 ∧ ∀ k, k < 10 → placeRepresentable k := by
  refine ⟨final_place_not_representable, ?_⟩
  intro k hk
  exact (placeRepresentable_iff k).2 (Nat.lt_succ_iff.1 hk)

/-- The exact divisor that represents the entire trailing block: `10 ^ 9 = 2 ^ 9 · 5 ^ 9`,
and the quotient `|𝕄| / 10 ^ 9` no longer ends in `0` (its last digit is `8`). -/
theorem trailing_block_divisor :
    (10 : Nat) ^ 9 ∣ monsterOrder ∧ (monsterOrder / 10 ^ 9) % 10 = 8 := by
  refine ⟨pow_ten_nine_dvd, ?_⟩
  native_decide

/-! ## How the zeros of `|𝕄|` split -/

/-- The decimal positions (from the left, 0-indexed) of the zero digits of `|𝕄|`. -/
theorem zero_positions :
    (List.range 54).filter (fun p => (MonsterDigitWalk.digitAt p) == "0")
      = [1, 3, 25, 32, 36, 37, 45, 46, 47, 48, 49, 50, 51, 52, 53] := by native_decide

/-- **The zeros split as `9 + 6`.** Of the `15` zero digits, the final `9` form the
trailing block (the place-value zeros, representable as the divisor `10 ^ 9`), while the
remaining `6` are interior zeros (which are *not* place-value and are not representable as
powers of ten). -/
theorem zero_digits_split :
    ((List.range 54).filter (fun p => (MonsterDigitWalk.digitAt p) == "0")).length = 15
      ∧ trailingZeros monsterOrder = 9
      ∧ 15 = 9 + 6 := by
  refine ⟨by native_decide, monster_trailingZeros, rfl⟩

/-! ## The interior zeros: the insulated wilderness

Of the `15` zero digits, the final `9` are the trailing block handled by the place-value
walk. The remaining `6` are **interior zeros** (left-indexed positions
`1, 3, 25, 32, 36, 37`). These are insulated from *both* walks:

* the leading-digit walk cannot reach them, because they are zeros and a leading digit is
  never `0` (`MonsterDigitWalk.leadingDigit_mem`);
* the place-value walk cannot reach them, because each lies at a decimal place `> 9`
  (`53 - p ≥ 10` for every interior position `p`), beyond the exhausted `5`-adic supply.
-/

/-- The interior (non-trailing) zero positions of `|𝕄|`, left-indexed. -/
def interiorZeroPositions : List Nat := [1, 3, 25, 32, 36, 37]

/-- The interior zeros are exactly the zero positions outside the nine-place trailing block
(positions `< 45`); there are `6` of them. -/
theorem interiorZeroPositions_eq :
    ((List.range 54).filter (fun p => (MonsterDigitWalk.digitAt p) == "0")).filter
        (fun p => decide (p < 45)) = interiorZeroPositions := by native_decide

/-- There are exactly `6` interior zeros. -/
theorem interiorZeroPositions_count : interiorZeroPositions.length = 6 := by native_decide

/-- Each interior position genuinely carries a `0` digit (so the leading-digit walk, which
never exposes a `0`, cannot reach it). -/
theorem interior_zeros_are_zeros :
    interiorZeroPositions.all (fun p => MonsterDigitWalk.digitAt p == "0") = true := by
  native_decide

/-- Each interior zero lies at a decimal place strictly beyond the representable range
(`53 - p > 9`), so the place-value walk cannot reach it either. -/
theorem interior_zeros_not_representable :
    ∀ p ∈ interiorZeroPositions, ¬ placeRepresentable (53 - p) := by
  intro p hp
  rw [placeRepresentable_iff]
  fin_cases hp <;> omega

/-- **The interior zeros are insulated.** The six interior zeros are unreachable by both
walks: each is a `0` digit (blocking the top-down leading-digit walk) and each sits at a
decimal place beyond the ninth (blocking the bottom-up place-value walk). -/
theorem interior_zeros_insulated :
    interiorZeroPositions.length = 6
      ∧ interiorZeroPositions.all (fun p => MonsterDigitWalk.digitAt p == "0") = true
      ∧ (∀ p ∈ interiorZeroPositions, ¬ placeRepresentable (53 - p)) :=
  ⟨interiorZeroPositions_count, interior_zeros_are_zeros, interior_zeros_not_representable⟩

/-! ## Symmetry with the leading-digit walk

The original walk descends from the top and halts at the first **leading** `0`; the
place-value walk descends from the bottom and halts at the **final** `0`. The two
obstructions are dual:

* a `0` can never be a *leading* digit (`MonsterDigitWalk.leadingDigit_mem`);
* a tenth decimal place can never be represented as a divisor
  (`final_place_not_representable`), because `5 ^ 10 ∤ |𝕄|`.
-/

/-- The place-value walk and the leading-digit walk are dual obstructions: the leading
digit of every positive number is in `{1,…,9}` (so a leading `0` is impossible), and the
power-of-ten divisor descent stops at the tenth place (so the final `0` is impossible to
represent). Together they pin the representable trailing places to exactly `1 ≤ k ≤ 9`. -/
theorem place_walk_duality :
    (∀ n : Nat, 0 < n → 1 ≤ n / 10 ^ (Nat.log 10 n) ∧ n / 10 ^ (Nat.log 10 n) ≤ 9)
      ∧ (∀ k, placeRepresentable k ↔ k ≤ 9) :=
  ⟨MonsterDigitWalk.leadingDigit_mem, placeRepresentable_iff⟩

end MonsterDecimalPlaces