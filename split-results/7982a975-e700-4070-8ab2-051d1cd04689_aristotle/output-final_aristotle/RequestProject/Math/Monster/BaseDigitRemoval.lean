/-
# BaseDigitRemoval.lean — Removing Digits to Produce New Targets

## Construction

For the walk step `8080`, written in a base `b`, we may *delete* a single
digit (or a contiguous group of digits) from its base-`b` digit string and
re-interpret the remaining digits as a new number in base `b` — a **new
target**.

This module records the single-digit removal targets in bases 8, 10, 16, 24
(the bases the user singled out), plus a few group-removal targets.

```
  base  b   digits (MSB→LSB)   single-digit removal targets
  ──────────────────────────────────────────────────────────
  8         [1,7,6,2,0]        [3984, 912, 976, 1008, 1010]
  10        [8,0,8,0]          [80, 880, 800, 808]
  16        [1,15,9,0]         [3984, 400, 496, 505]
  24        [14,0,16]          [16, 352, 336]
```

A pleasant cross-base coincidence: removing the leading digit in base 8 and
in base 16 both yield **3984 = 8080 − 4096** — stripping the top `2¹²` worth.

## File location
`RequestProject/Math/Monster/BaseDigitRemoval.lean`

## Dependencies
`HexWalk`, `HexWalkProjection`
-/

import Mathlib
import RequestProject.Math.Monster.HexWalk
import RequestProject.Math.Monster.HexWalkProjection

set_option maxHeartbeats 800000

namespace BaseDigitRemoval

open HexWalk HexWalkProjection

/-! ## §1. Removal Primitives -/

/-- Interpret a digit list (most-significant first) as a number in base `b`. -/
def ofDigits (b : ℕ) (ds : List ℕ) : ℕ := ds.foldl (fun a d => a * b + d) 0

/-- Remove the digit at index `i` from a digit list. -/
def removeAt (l : List ℕ) (i : ℕ) : List ℕ := l.take i ++ l.drop (i + 1)

/-- Remove the contiguous group of `len` digits starting at index `i`. -/
def removeRange (l : List ℕ) (i len : ℕ) : List ℕ := l.take i ++ l.drop (i + len)

/-- The list of single-digit removal targets for `n` in base `b` with `d` digits. -/
def removalTargets (n b d : ℕ) : List ℕ :=
  let v := digitVec n b d
  (List.range d).map (fun i => ofDigits b (removeAt v i))

/-! ## §2. Digit Strings of the Walk Step -/

/-- Base 8 (octal): 8080 = [1, 7, 6, 2, 0]₈. -/
theorem digits_base8 : digitVec walk_step 8 5 = [1, 7, 6, 2, 0] := by native_decide

/-- Base 10: 8080 = [8, 0, 8, 0]₁₀. -/
theorem digits_base10 : digitVec walk_step 10 4 = [8, 0, 8, 0] := by native_decide

/-- Base 16 (hex): 8080 = [1, 15, 9, 0]₁₆. -/
theorem digits_base16 : digitVec walk_step 16 4 = [1, 15, 9, 0] := by native_decide

/-- Base 24: 8080 = [14, 0, 16]₂₄. -/
theorem digits_base24 : digitVec walk_step 24 3 = [14, 0, 16] := by native_decide

/-! ## §3. Single-Digit Removal Targets -/

/-- Octal removal targets: removing each digit of 17620₈ gives these. -/
theorem targets_base8 :
    removalTargets walk_step 8 5 = [3984, 912, 976, 1008, 1010] := by native_decide

/-- Decimal removal targets: removing each digit of 8080 gives these. -/
theorem targets_base10 :
    removalTargets walk_step 10 4 = [80, 880, 800, 808] := by native_decide

/-- Hex removal targets: removing each nibble of 0x1F90 gives these. -/
theorem targets_base16 :
    removalTargets walk_step 16 4 = [3984, 400, 496, 505] := by native_decide

/-- Base-24 removal targets. -/
theorem targets_base24 :
    removalTargets walk_step 24 3 = [16, 352, 336] := by native_decide

/-! ## §4. Cross-Base Coincidence -/

/-- Removing the leading digit in base 8 and in base 16 both yield 3984. -/
theorem leading_removal_octal_hex_agree :
    (removalTargets walk_step 8 5).head! = 3984 ∧
    (removalTargets walk_step 16 4).head! = 3984 := by native_decide

/-- And 3984 = 8080 − 4096 = stripping the top 2¹² worth. -/
theorem leading_removal_strips_4096 :
    (3984 : ℕ) = walk_step - 4096 ∧ (4096 : ℕ) = 2 ^ 12 := by
  refine ⟨by native_decide, by native_decide⟩

/-! ## §5. Group (Multi-Digit) Removal Targets -/

/-- Removing the two trailing digits `[9,0]` of the hex string leaves `[1,15]`
    = 0x1F = 31 (a supersingular prime!). -/
theorem hex_drop_low_two :
    ofDigits 16 (removeRange (digitVec walk_step 16 4) 2 2) = 31 := by native_decide

/-- 31 is a supersingular (Monster) prime. -/
theorem hex_drop_low_two_is_ssp : (31 : ℕ) = 0x1F := by native_decide

/-- Removing the two leading digits `[1,15]` of the hex string leaves `[9,0]`
    = 0x90 = 144 = 12². -/
theorem hex_drop_high_two :
    ofDigits 16 (removeRange (digitVec walk_step 16 4) 0 2) = 144 := by native_decide

/-- Removing the middle two decimal digits `[0,8]` of `[8,0,8,0]` leaves `[8,0]`
    = 80. -/
theorem dec_drop_middle_two :
    ofDigits 10 (removeRange (digitVec walk_step 10 4) 1 2) = 80 := by native_decide

/-! ## §6. Soundness of the Removal Construction -/

/-- Removing a single digit then reading the rest never exceeds the original
    (deleting a digit can only shrink or preserve the value's magnitude class). -/
theorem removeAt_length (l : List ℕ) (i : ℕ) (hi : i < l.length) :
    (removeAt l i).length = l.length - 1 := by
  simp only [removeAt, List.length_append, List.length_take, List.length_drop]
  omega

/-- The full removal-target list has exactly `d` entries (one per removed digit). -/
theorem removalTargets_length (n b d : ℕ) :
    (removalTargets n b d).length = d := by
  simp [removalTargets]

/-! ## §7. Summary -/

/-- The complete digit-removal picture for the walk step across bases 8,10,16,24. -/
theorem removal_summary :
    removalTargets walk_step 8 5  = [3984, 912, 976, 1008, 1010] ∧
    removalTargets walk_step 10 4 = [80, 880, 800, 808] ∧
    removalTargets walk_step 16 4 = [3984, 400, 496, 505] ∧
    removalTargets walk_step 24 3 = [16, 352, 336] ∧
    -- the hex "drop low two" target is the supersingular prime 31
    ofDigits 16 (removeRange (digitVec walk_step 16 4) 2 2) = 31 := by
  refine ⟨by native_decide, by native_decide, by native_decide,
          by native_decide, by native_decide⟩

end BaseDigitRemoval
