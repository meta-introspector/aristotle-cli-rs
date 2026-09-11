/-
# MultiBaseWalk.lean — The Walk in 72 Bases (2 … 72)

## Core Insight

The original "Hex Walk" wrote the step `8080 = 0x1F90` in base 16, exposing its
4-nibble place-value structure.  This module performs the *same* walk in **every
base from 2 to 72** — the full span of radices up through the largest Monster
prime plus one.

For each base `b ∈ [2, 72]` we record:
- the **digit count** (how many base-`b` digits `8080` occupies),
- the **digit sum**,
- the **digit vector** (most-significant first), and
- the universal **reconstruction** `Σ dᵢ·bⁱ = 8080`.

Highlights that are proved:
- Reconstruction holds in *every* base (`walk_reconstruct_all_bases`).
- The digit-count sequence is **non-increasing** in the base
  (`digitCounts_nonincreasing`): a larger radix never needs more digits.
- The **extremes**: binary (base 2) is widest at 13 digits; every base from 21
  upward is narrowest at 3 digits (`digitCounts_max`, `digitCounts_min`).
- The original **Hex Walk is the base-16 slice**: 4 digits (`hex_slice_is_four`).

## File location
`RequestProject/Math/Monster/MultiBaseWalk.lean`

## Dependencies
`HexWalk`
-/

import Mathlib
import RequestProject.Math.Monster.HexWalk

set_option maxHeartbeats 1600000

namespace MultiBaseWalk

open HexWalk

/-! ## §1. The Walk Value and the Base Range -/

/-- The walk step (same value as `HexWalk.walk_step`). -/
def walkValue : ℕ := 8080

theorem walkValue_eq_step : walkValue = HexWalk.walk_step := rfl

/-- The 71 bases from 2 to 72 inclusive (the "72-base" span 2…72). -/
def bases : List ℕ := (List.range 71).map (· + 2)

/-- There are 71 bases in the range 2…72. -/
theorem bases_length : bases.length = 71 := by native_decide

/-- The base list runs from 2 up to 72. -/
theorem bases_endpoints : bases.head? = some 2 ∧ bases.getLast? = some 72 := by
  native_decide

/-! ## §2. Per-Base Digit Data -/

/-- Base-`b` digit count of the walk value (Mathlib little-endian length). -/
def digitCount (b : ℕ) : ℕ := (Nat.digits b walkValue).length

/-- Base-`b` digit sum of the walk value. -/
def digitSum (b : ℕ) : ℕ := (Nat.digits b walkValue).sum

/-- Base-`b` digit vector of the walk value, most-significant first. -/
def digitVec (b : ℕ) : List ℕ := (Nat.digits b walkValue).reverse

/-- The full digit-count spectrum across bases 2 … 72. -/
def digitCounts : List ℕ := bases.map digitCount

/-- The full digit-sum spectrum across bases 2 … 72. -/
def digitSums : List ℕ := bases.map digitSum

/-! ## §3. The Reconstruction Holds in Every Base

In any base `b`, summing the digits against their place values recovers the
walk value exactly.  This is the "walk preserves the value" statement, now
universal over all radices. -/

/-- Universal reconstruction: in every base `b`, the base-`b` digits of the walk
    value recompose to it. -/
theorem walk_reconstruct_all_bases (b : ℕ) :
    Nat.ofDigits b (Nat.digits b walkValue) = walkValue :=
  Nat.ofDigits_digits b walkValue

/-! ## §4. The Digit-Count Spectrum (bases 2 … 72) -/

/-- The explicit digit-count vector over bases 2 … 72. -/
theorem digitCounts_eq :
    digitCounts =
      [13, 9, 7, 6, 6, 5, 5, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
       3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
       3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
       3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3] := by native_decide

/-- The digit-count spectrum is non-increasing: a larger base never needs more
    digits to write the walk value. -/
theorem digitCounts_nonincreasing : List.Pairwise (· ≥ ·) digitCounts := by
  native_decide

/-- Binary (base 2) is the widest: it uses 13 digits, the maximum. -/
theorem digitCounts_max : digitCount 2 = 13 ∧ ∀ b ∈ bases, digitCount b ≤ 13 := by
  native_decide

/-- The narrowest representations use 3 digits, attained for every base ≥ 21. -/
theorem digitCounts_min :
    digitCount 72 = 3 ∧ ∀ b ∈ bases, 3 ≤ digitCount b := by
  native_decide

/-- Total digits used across all 71 bases. -/
theorem digitCounts_sum : digitCounts.sum = 256 := by native_decide

/-! ## §5. The Digit-Sum Spectrum (bases 2 … 72) -/

/-- The explicit digit-sum vector over bases 2 … 72. -/
theorem digitSums_eq :
    digitSums =
      [7, 8, 10, 12, 10, 16, 16, 16, 16, 20, 17, 28, 20, 30, 25, 32, 39,
       16, 5, 40, 37, 28, 30, 40, 55, 20, 34, 44, 47, 40, 51, 48, 61, 56,
       30, 52, 51, 24, 7, 40, 44, 58, 39, 72, 70, 76, 43, 64, 44, 30, 73,
       72, 77, 88, 50, 72, 43, 76, 56, 40, 28, 20, 79, 80, 85, 94, 107,
       56, 76, 100, 57] := by native_decide

/-- The smallest digit sum (5) occurs in base 20: `8080 = [1,0,4,0]₂₀`. -/
theorem digitSum_min_base20 : digitSum 20 = 5 := by native_decide

/-- The base-71 digit sum is 100 = 10² (matching `HexWalkProjection`). -/
theorem digitSum_base71 : digitSum 71 = 100 := by native_decide

/-! ## §6. The Hex Walk Recovered as a Slice

The original construction is exactly the base-16 entry of this multi-base walk. -/

/-- The base-16 digit vector is the 4 nibbles `[1, 15, 9, 0]` of `0x1F90`. -/
theorem hex_slice_digits : digitVec 16 = [1, 15, 9, 0] := by native_decide

/-- The Hex Walk slice has exactly 4 digits (the 4 nibbles). -/
theorem hex_slice_is_four : digitCount 16 = 4 := by native_decide

/-- The base-16 reconstruction reproduces `HexWalk.nibbles_compose`. -/
theorem hex_slice_reconstruct :
    Nat.ofDigits 16 (Nat.digits 16 walkValue) = 8080 :=
  walk_reconstruct_all_bases 16

/-! ## §7. Sample Digit Vectors Across the Span -/

/-- Base 2 (binary): `8080 = 1111110010000₂`. -/
theorem digits_base2_vec :
    digitVec 2 = [1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0] := by native_decide

/-- Base 10 (decimal): the familiar `[8, 0, 8, 0]`. -/
theorem digits_base10_vec : digitVec 10 = [8, 0, 8, 0] := by native_decide

/-- Base 71: `8080 = [1, 42, 57]₇₁` (matching `HexWalkProjection.digits_71`). -/
theorem digits_base71_vec : digitVec 71 = [1, 42, 57] := by native_decide

/-- Base 72: `8080 = [1, 40, 16]₇₂`. -/
theorem digits_base72_vec : digitVec 72 = [1, 40, 16] := by native_decide

/-! ## §8. Grand Summary Theorem -/

/-- The complete multi-base walk: the value reconstructs in every base, the
    digit-count spectrum is exactly as listed and is non-increasing with widest
    (13) at base 2 and narrowest (3) from base 21 on, and the original Hex Walk
    is the base-16 slice with 4 digits. -/
theorem the_multi_base_walk :
    (∀ b : ℕ, Nat.ofDigits b (Nat.digits b walkValue) = walkValue) ∧
    bases.length = 71 ∧
    List.Pairwise (· ≥ ·) digitCounts ∧
    digitCount 2 = 13 ∧
    (∀ b ∈ bases, digitCount b ≤ 13) ∧
    (∀ b ∈ bases, 3 ≤ digitCount b) ∧
    digitCount 16 = 4 ∧
    digitVec 16 = [1, 15, 9, 0] := by
  refine ⟨walk_reconstruct_all_bases, bases_length, digitCounts_nonincreasing,
          ?_, ?_, ?_, ?_, ?_⟩ <;> native_decide

end MultiBaseWalk
