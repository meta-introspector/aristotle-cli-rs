/-
# MonsterOrderHairs.lean — The Hair / Digit-Removal Analysis applied to the
  *whole* Monster order |M| (not just the walk step 8080)

## Motivation

The `BaseDigitRemoval` module applied the "hair" reading — write a number in a
base `b`, then *remove* a single digit (or a contiguous group of digits) and
re-interpret the remaining digits as a new number ("new target") — only to the
walk step `8080`.

This module lifts the **same** construction to the genuine Monster group order

  |M| = 2⁴⁶ · 3²⁰ · 5⁹ · 7⁶ · 11² · 13³ · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71
      = 808017424794512875886459904961710757005754368000000000.

We reuse the removal primitives (`ofDigits`, `removeAt`, `removeRange`,
`removalTargets`) and the base-representation primitives (`digitVec`) already
in the project, and apply them to `|M|`.

## Highlights

* The digit-count **strata** of `|M|` across all 15 supersingular bases
  (binary has 180 digits, base 71 has 30).
* For each named base `b ∈ {8, 10, 16, 24}` there are exactly `d` single-digit
  removal targets, where `d` is the base-`b` digit count of `|M|`.
* A **cross-base coincidence** exactly analogous to the `8080` case
  (where octal & hex leading-digit removal both strip `2¹²`):
  for `|M|`, octal **and** hexadecimal leading-digit removal both yield the
  same number
  `41769654361568446707286391386556165196384806908198912`,
  i.e. both strip exactly `2¹⁷⁹` — the top binary power inside `|M|`.
* A group-removal example: deleting the 9 trailing decimal zeros of `|M|`
  (it ends in exactly 9 zeros, from `min(46, 9) = 9` factors of 10) leaves
  `808017424794512875886459904961710757005754368`.

## File location
`RequestProject/Math/Monster/MonsterOrderHairs.lean`

## Dependencies
`BaseDigitRemoval`, `HexWalkProjection`, `MonsterHairs`,
`MonsterSlice.monsterOrder`
-/

import Mathlib
import RequestProject.Math.Monster.BaseDigitRemoval
import RequestProject.Math.Monster.HexWalkProjection
import RequestProject.Math.Monster.MonsterHairs
import RequestProject.Math.Monster.Slice.MonsterOrder

set_option maxHeartbeats 1600000

namespace MonsterOrderHairs

open BaseDigitRemoval HexWalkProjection

/-! ## §1. The Target: the whole Monster order -/

/-- The Monster group order (alias of the project-wide value). -/
def M : ℕ := MonsterSlice.monsterOrder

/-- The decimal value of `|M|`. -/
theorem M_value :
    M = 808017424794512875886459904961710757005754368000000000 := by
  native_decide

/-! ## §2. Digit-Count Strata of |M| across the Supersingular Bases

Exactly as `HexWalkProjection` did for `8080`, but now for the full order.
The digit count `(Nat.digits b |M|).length` is the dimension of the base-`b`
"hair window". -/

/-- Digit counts of `|M|` in every supersingular base `2 .. 71`. -/
theorem digitCount_strata :
    ([2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71] : List ℕ).map
        (fun b => (Nat.digits b M).length)
      = [180, 113, 78, 64, 52, 49, 44, 43, 40, 37, 37, 34, 33, 31, 30] := by
  native_decide

/-- Binary gives the most hairs (180 digits); base 71 the fewest (30). -/
theorem strata_extremes :
    (Nat.digits 2 M).length = 180 ∧ (Nat.digits 71 M).length = 30 := by
  native_decide

/-- Digit counts of `|M|` in the four "named" bases used for removal. -/
theorem named_base_digitCounts :
    (Nat.digits 8 M).length = 60 ∧
    (Nat.digits 10 M).length = 54 ∧
    (Nat.digits 16 M).length = 45 ∧
    (Nat.digits 24 M).length = 40 := by
  native_decide

/-! ## §3. Single-Digit Removal — "New Targets" from |M|

For each base `b` with digit count `d`, `removalTargets M b d` is the length-`d`
list of numbers obtained by deleting one digit at a time. -/

/-- There are exactly as many single-digit removal targets as there are digits,
    in every named base. -/
theorem removalTargets_counts :
    (removalTargets M 8 60).length = 60 ∧
    (removalTargets M 10 54).length = 54 ∧
    (removalTargets M 16 45).length = 45 ∧
    (removalTargets M 24 40).length = 40 := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> simp [removalTargets]

/-- The leading-digit removal target in base 10 is `|M|` with its top digit
    deleted — equivalently `|M| mod 10⁵³`. -/
theorem leading_removal_base10 :
    (removalTargets M 10 54).head! =
      8017424794512875886459904961710757005754368000000000 ∧
    (removalTargets M 10 54).head! = M % 10 ^ 53 := by
  refine ⟨by native_decide, by native_decide⟩

/-- The leading-digit removal target in octal. -/
theorem leading_removal_base8 :
    (removalTargets M 8 60).head! =
      41769654361568446707286391386556165196384806908198912 := by
  native_decide

/-- The leading-digit removal target in hexadecimal. -/
theorem leading_removal_base16 :
    (removalTargets M 16 45).head! =
      41769654361568446707286391386556165196384806908198912 := by
  native_decide

/-- The leading-digit removal target in base 24. -/
theorem leading_removal_base24 :
    (removalTargets M 24 40).head! =
      134671204312607015166496678257504163983658737809227776 := by
  native_decide

/-! ## §4. The Cross-Base Coincidence (Octal = Hex)

For `8080`, octal and hex leading-digit removal both stripped `2¹²`.
For `|M|`, octal and hex leading-digit removal both strip `2¹⁷⁹` — the top
binary power below `|M|` (since `|M| < 2¹⁸⁰`, the binary length being 180). -/

/-- Octal and hexadecimal leading-digit removal of `|M|` yield the **same**
    number, exactly as for the walk step. -/
theorem leading_removal_octal_hex_agree :
    (removalTargets M 8 60).head! = (removalTargets M 16 45).head! := by
  native_decide

/-- Both strip exactly `2¹⁷⁹`: the common target equals `|M| − 2¹⁷⁹`. -/
theorem leading_removal_strips_two_pow_179 :
    (removalTargets M 16 45).head! = M - 2 ^ 179 ∧
    4 * 8 ^ 59 = 2 ^ 179 ∧
    8 * 16 ^ 44 = 2 ^ 179 := by
  refine ⟨by native_decide, by native_decide, by native_decide⟩

/-- `2¹⁷⁹` really is the top binary power: `2¹⁷⁹ ≤ |M| < 2¹⁸⁰`. -/
theorem two_pow_179_is_top :
    2 ^ 179 ≤ M ∧ M < 2 ^ 180 := by
  refine ⟨by native_decide, by native_decide⟩

/-! ## §5. Group (Multi-Digit) Removal — Trailing Zeros

`|M| = 2⁴⁶ · 5⁹ · (odd)`, so it ends in exactly `min(46, 9) = 9` decimal zeros.
Deleting that trailing block of 9 zeros is a group removal yielding a new
target. -/

/-- `|M|` ends in exactly 9 decimal zeros. -/
theorem trailing_zeros_base10 :
    ((Nat.digits 10 M).takeWhile (· == 0)).length = 9 := by
  native_decide

/-- Deleting the 9 trailing decimal zeros leaves
    `808017424794512875886459904961710757005754368`. -/
theorem drop_trailing_zeros_base10 :
    M / 10 ^ 9 = 808017424794512875886459904961710757005754368 := by
  native_decide

/-- Stated via the removal primitive: deleting the last-9 digit block of the
    54-digit decimal string gives the same target. -/
theorem drop_trailing_zeros_via_removeRange :
    ofDigits 10 (removeRange (digitVec M 10 54) 45 9) =
      808017424794512875886459904961710757005754368 := by
  native_decide

/-! ## §6. Connection to the Residue-Hair Spectrum

`MonsterHairs` collected the digit-residues (`d % 72`) of `|M|` across the
bases `2 .. 71` into 2948 "hairs".  The digit-removal targets here are the
*complementary* construction: instead of recording each digit, we delete one
and read what remains.  The two views share the same underlying digit data. -/

/-- Each residue-hair is exactly one digit, and each digit yields exactly one
    single-digit removal target; hence over **all** bases `2 .. 71` the total
    number of removal targets equals the residue-hair count `2948`. -/
theorem removalTargets_total_eq_hairCount :
    ((MonsterHairs.bases).map
        (fun b => (Nat.digits b M).length)).sum = MonsterHairs.monsterHairs.length := by
  native_decide

/-- Restricted to just the 15 supersingular bases, the digit total is `865`. -/
theorem removalTargets_total_supersingular :
    (([2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71] : List ℕ).map
        (fun b => (Nat.digits b M).length)).sum = 865 := by
  native_decide

/-! ## §7. Grand Summary -/

/-- The hair / digit-removal analysis applied to the entire Monster order. -/
theorem monster_order_hairs :
    -- correct order value
    M = 808017424794512875886459904961710757005754368000000000 ∧
    -- digit strata across all 15 supersingular bases
    ([2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71] : List ℕ).map
        (fun b => (Nat.digits b M).length)
      = [180, 113, 78, 64, 52, 49, 44, 43, 40, 37, 37, 34, 33, 31, 30] ∧
    -- one removal target per digit in each named base
    (removalTargets M 8 60).length = 60 ∧
    (removalTargets M 10 54).length = 54 ∧
    (removalTargets M 16 45).length = 45 ∧
    (removalTargets M 24 40).length = 40 ∧
    -- octal = hex leading removal, both stripping 2¹⁷⁹
    (removalTargets M 8 60).head! = (removalTargets M 16 45).head! ∧
    (removalTargets M 16 45).head! = M - 2 ^ 179 ∧
    -- trailing-zero group removal
    M / 10 ^ 9 = 808017424794512875886459904961710757005754368 := by
  refine ⟨by native_decide, by native_decide, ?_, ?_, ?_, ?_,
          by native_decide, by native_decide, by native_decide⟩ <;>
    simp [removalTargets]

end MonsterOrderHairs
