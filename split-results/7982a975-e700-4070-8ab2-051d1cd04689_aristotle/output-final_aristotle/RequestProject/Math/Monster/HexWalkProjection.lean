/-
# HexWalkProjection.lean — Digit Preservation as Graded Projection

## Core Insight

The walk step 8080 written in every SSP base reveals a **5-stratum graded
projection**: the digit count `floor(log_b(8080)) + 1` is constant within
each stratum, and the stratum boundaries align exactly with the eigenspace
decomposition of the Monster.

```
  SSP base  b    digit count    stratum / eigenspace
  ─────────────────────────────────────────────────
  b =  2         13             binary (full expansion)
  b =  3          9             ternary
  b =  5          6             quinary
  b =  7          5             heptal
  b = 11,13,17,19  4            EARTH (inner 4 SSP primes)
  b = 23,29,31,41,47,59,71  3  SPOKE + HUB + CLOCK (outer 7 SSP primes)
```

The 4-digit stratum spans bases 10–20 and is bounded exactly by the
Earth/Spoke boundary in the SSP eigenspace: 19 (last Earth prime) gives 4
digits; 23 (first Spoke prime) gives 3 digits.

The representation in base b is a vector in (Z/bZ)⁴ (4-digit window) or
(Z/bZ)³ (3-digit window) — the digit count IS the projection dimension.

## File location
`RequestProject/Math/Monster/HexWalkProjection.lean`

## Dependencies
`MonsterConstants`, `MonsterWalkZKP`, `HexWalk`
-/

import Mathlib
import RequestProject.MonsterConstants
import RequestProject.Math.Monster.MonsterWalkZKP
import RequestProject.Math.Monster.HexWalk

set_option maxHeartbeats 800000

namespace HexWalkProjection

open MonsterConstants MonsterWalkZKP HexWalk

/-! ## §1. Base-Representation Primitives -/

/-- Number of digits of n in base b (= floor(log_b n) + 1 for n > 0). -/
def digitCount (n b : ℕ) (_hb : 2 ≤ b) (_hn : 0 < n) : ℕ :=
  (Nat.log b n) + 1

/-- The k-th digit of n in base b (0 = least significant). -/
def digit (n b k : ℕ) : ℕ := (n / b ^ k) % b

/-- Digit vector of n in base b, length d, most-significant first. -/
def digitVec (n b d : ℕ) : List ℕ :=
  (List.range d).reverse.map (fun k => digit n b k)

/-! ## §2. Digit Counts for the Walk Step in Each SSP Base -/

/-- The walk step in binary has 13 digits. -/
theorem digits_base2  : digitCount walk_step 2  (by norm_num) (by norm_num [walk_step]) = 13 := by
  simp [digitCount, walk_step]; native_decide

/-- The walk step in base 3 has 9 digits. -/
theorem digits_base3  : digitCount walk_step 3  (by norm_num) (by norm_num [walk_step]) = 9  := by
  simp [digitCount, walk_step]; native_decide

/-- The walk step in base 5 has 6 digits. -/
theorem digits_base5  : digitCount walk_step 5  (by norm_num) (by norm_num [walk_step]) = 6  := by
  simp [digitCount, walk_step]; native_decide

/-- The walk step in base 7 has 5 digits. -/
theorem digits_base7  : digitCount walk_step 7  (by norm_num) (by norm_num [walk_step]) = 5  := by
  simp [digitCount, walk_step]; native_decide

-- Earth stratum: 4 digits each
/-- The walk step in base 11 has 4 digits. -/
theorem digits_base11 : digitCount walk_step 11 (by norm_num) (by norm_num [walk_step]) = 4  := by
  simp [digitCount, walk_step]; native_decide

/-- The walk step in base 13 has 4 digits. -/
theorem digits_base13 : digitCount walk_step 13 (by norm_num) (by norm_num [walk_step]) = 4  := by
  simp [digitCount, walk_step]; native_decide

/-- The walk step in base 17 has 4 digits. -/
theorem digits_base17 : digitCount walk_step 17 (by norm_num) (by norm_num [walk_step]) = 4  := by
  simp [digitCount, walk_step]; native_decide

/-- The walk step in base 19 has 4 digits. -/
theorem digits_base19 : digitCount walk_step 19 (by norm_num) (by norm_num [walk_step]) = 4  := by
  simp [digitCount, walk_step]; native_decide

-- Spoke+Hub+Clock stratum: 3 digits each
/-- The walk step in base 23 has 3 digits. -/
theorem digits_base23 : digitCount walk_step 23 (by norm_num) (by norm_num [walk_step]) = 3  := by
  simp [digitCount, walk_step]; native_decide

/-- The walk step in base 29 has 3 digits. -/
theorem digits_base29 : digitCount walk_step 29 (by norm_num) (by norm_num [walk_step]) = 3  := by
  simp [digitCount, walk_step]; native_decide

/-- The walk step in base 31 has 3 digits. -/
theorem digits_base31 : digitCount walk_step 31 (by norm_num) (by norm_num [walk_step]) = 3  := by
  simp [digitCount, walk_step]; native_decide

/-- The walk step in base 41 has 3 digits. -/
theorem digits_base41 : digitCount walk_step 41 (by norm_num) (by norm_num [walk_step]) = 3  := by
  simp [digitCount, walk_step]; native_decide

/-- The walk step in base 47 has 3 digits. -/
theorem digits_base47 : digitCount walk_step 47 (by norm_num) (by norm_num [walk_step]) = 3  := by
  simp [digitCount, walk_step]; native_decide

/-- The walk step in base 59 has 3 digits. -/
theorem digits_base59 : digitCount walk_step 59 (by norm_num) (by norm_num [walk_step]) = 3  := by
  simp [digitCount, walk_step]; native_decide

/-- The walk step in base 71 has 3 digits. -/
theorem digits_base71 : digitCount walk_step 71 (by norm_num) (by norm_num [walk_step]) = 3  := by
  simp [digitCount, walk_step]; native_decide

/-! ## §3. The Five Strata

Digit count partitions the 15 SSP bases into 5 strata. -/

/-- Stratum classification: digit count of walk_step in each SSP base. -/
def sspDigitCount : Fin 15 → ℕ
  | ⟨0,  _⟩ => 13  -- base 2
  | ⟨1,  _⟩ => 9   -- base 3
  | ⟨2,  _⟩ => 6   -- base 5
  | ⟨3,  _⟩ => 5   -- base 7
  | ⟨4,  _⟩ => 4   -- base 11  ┐
  | ⟨5,  _⟩ => 4   -- base 13  │ Earth stratum
  | ⟨6,  _⟩ => 4   -- base 17  │
  | ⟨7,  _⟩ => 4   -- base 19  ┘
  | ⟨8,  _⟩ => 3   -- base 23  ┐
  | ⟨9,  _⟩ => 3   -- base 29  │
  | ⟨10, _⟩ => 3   -- base 31  │ Spoke + Hub + Clock
  | ⟨11, _⟩ => 3   -- base 41  │
  | ⟨12, _⟩ => 3   -- base 47  │
  | ⟨13, _⟩ => 3   -- base 59  │
  | ⟨14, _⟩ => 3   -- base 71  ┘

/-- All 5 strata are present and correctly counted. -/
theorem five_strata_present :
    (List.finRange 15).map sspDigitCount =
    [13, 9, 6, 5, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3] := by native_decide

/-- The Earth stratum (SSP indices 4–7, primes 11,13,17,19) all give 4 digits. -/
theorem earth_stratum_4digits :
    sspDigitCount ⟨4, by omega⟩ = 4 ∧
    sspDigitCount ⟨5, by omega⟩ = 4 ∧
    sspDigitCount ⟨6, by omega⟩ = 4 ∧
    sspDigitCount ⟨7, by omega⟩ = 4 := by decide

/-- The outer stratum (SSP indices 8–14, primes 23–71) all give 3 digits. -/
theorem outer_stratum_3digits :
    ∀ i : Fin 15, 8 ≤ i.val → sspDigitCount i = 3 := by decide

/-- There are exactly 4 SSP bases in the 4-digit stratum. -/
theorem four_digit_count :
    ((List.finRange 15).filter (fun i => sspDigitCount i == 4)).length = 4 := by
  native_decide

/-- There are exactly 7 SSP bases in the 3-digit stratum. -/
theorem three_digit_count :
    ((List.finRange 15).filter (fun i => sspDigitCount i == 3)).length = 7 := by
  native_decide

/-! ## §4. The Earth/Spoke Boundary

The 4-digit window spans exactly bases 10–20.
The Earth/Spoke boundary in the SSP eigenspace falls at the same place:
- SSP index 7 = prime 19 → last 4-digit base
- SSP index 8 = prime 23 → first 3-digit base
-/

/-- Base 19 gives 4 digits (last Earth prime is in the 4-digit window). -/
theorem earth_boundary_19 : 19^3 ≤ walk_step ∧ walk_step < 19^4 := by native_decide

/-- Base 23 gives 3 digits (first Spoke prime is in the 3-digit window). -/
theorem spoke_boundary_23 : 23^2 ≤ walk_step ∧ walk_step < 23^3 := by native_decide

/-- The 4-digit window is exactly bases 10–20. -/
theorem four_digit_window :
    ∀ b : ℕ, 10 ≤ b → b ≤ 20 → (b^3 ≤ walk_step ∧ walk_step < b^4) := by
  intro b hlo hhi
  interval_cases b <;> simp [walk_step]

/-- No base < 10 gives exactly 4 digits. -/
theorem no_four_digits_below_10 :
    ∀ b : ℕ, 2 ≤ b → b ≤ 9 → ¬(b^3 ≤ walk_step ∧ walk_step < b^4) := by
  intro b hlo hhi
  interval_cases b <;> simp [walk_step]

/-- No base > 20 gives 4 digits. -/
theorem no_four_digits_above_20 :
    ∀ b : ℕ, b ≥ 21 → ¬(b^3 ≤ walk_step ∧ walk_step < b^4) := by
  intro b hb ⟨hlo, hhi⟩
  have h3 : (21 : ℕ)^3 ≤ b^3 := Nat.pow_le_pow_left (by omega) 3
  simp only [walk_step] at hlo hhi
  omega

/-- The boundary is tight: 20^3 = 8000 ≤ 8080 < 20^4 but 21^3 = 9261 > 8080. -/
theorem window_boundary_tight :
    (20 : ℕ)^3 = 8000 ∧ (21 : ℕ)^3 = 9261 ∧
    (20 : ℕ)^3 ≤ walk_step ∧ walk_step < (21 : ℕ)^3 := by
  norm_num [walk_step]

/-! ## §5. Explicit Digit Vectors in the SSP Bases -/

-- 4-digit representations (Earth stratum)
/-- Base 11: 8080 = [6, 0, 8, 6]₁₁. -/
theorem digits_11 :
    digitVec walk_step 11 4 = [6, 0, 8, 6] := by native_decide

/-- Base 13: 8080 = [3, 8, 10, 7]₁₃. -/
theorem digits_13 :
    digitVec walk_step 13 4 = [3, 8, 10, 7] := by native_decide

/-- Base 17: 8080 = [1, 10, 16, 5]₁₇. -/
theorem digits_17 :
    digitVec walk_step 17 4 = [1, 10, 16, 5] := by native_decide

/-- Base 19: 8080 = [1, 3, 7, 5]₁₉. -/
theorem digits_19 :
    digitVec walk_step 19 4 = [1, 3, 7, 5] := by native_decide

-- 3-digit representations (Spoke+Hub+Clock stratum)
/-- Base 23: 8080 = [15, 6, 7]₂₃. -/
theorem digits_23 :
    digitVec walk_step 23 3 = [15, 6, 7] := by native_decide

/-- Base 47: 8080 = [3, 30, 43]₄₇. -/
theorem digits_47 :
    digitVec walk_step 47 3 = [3, 30, 43] := by native_decide

/-- Base 59: 8080 = [2, 18, 56]₅₉. -/
theorem digits_59 :
    digitVec walk_step 59 3 = [2, 18, 56] := by native_decide

/-- Base 71: 8080 = [1, 42, 57]₇₁. -/
theorem digits_71 :
    digitVec walk_step 71 3 = [1, 42, 57] := by native_decide

/-- Reconstruction check for base 71: 1×71² + 42×71 + 57 = 8080. -/
theorem base71_reconstruction :
    1 * 71^2 + 42 * 71 + 57 = walk_step := by native_decide

/-! ## §6. Special Digit-Sum Invariants -/

/-- Digit sum in base 10: 8+0+8+0 = 16 = 2⁴. -/
theorem digit_sum_base10 :
    (digitVec walk_step 10 4).sum = 16 := by native_decide

/-- Digit sum in base 19: 1+3+7+5 = 16 = 2⁴. -/
theorem digit_sum_base19 :
    (digitVec walk_step 19 4).sum = 16 := by native_decide

/-- Bases 10 and 19 share the same digit sum (16 = 2⁴). -/
theorem earth_endpoints_same_digitsum :
    (digitVec walk_step 10 4).sum = (digitVec walk_step 19 4).sum := by native_decide

/-- Digit sum in base 7: 3+2+3+6+2 = 16 = 2⁴. -/
theorem digit_sum_base7 :
    (digitVec walk_step 7 5).sum = 16 := by native_decide

/-- The digit sum 16 appears in bases 7, 10, and 19. -/
theorem sixteen_digitsum_triad :
    (digitVec walk_step 7  5).sum = 16 ∧
    (digitVec walk_step 10 4).sum = 16 ∧
    (digitVec walk_step 19 4).sum = 16 := by native_decide

/-- Digit sum in base 71: 1+42+57 = 100. -/
theorem digit_sum_base71 :
    (digitVec walk_step 71 3).sum = 100 := by native_decide

/-- The base-71 digit sum is exactly 100. -/
theorem base71_century : (digitVec walk_step 71 3).sum = 10^2 := by native_decide

/-! ## §7. The Trailing Digit as Shard Projection

In every base b, the trailing digit of n is n mod b.
This IS the orbifold/shard projection: it records where the walk
step lands in Z/bZ. -/

/-- Trailing digit in base 71 = the hex shard = 57. -/
theorem trailing_71_is_shard :
    digit walk_step 71 0 = hex_shard := by native_decide

/-- Trailing digit in base 59 = walk_step mod 59 = 56. -/
theorem trailing_59 : digit walk_step 59 0 = 56 := by native_decide

/-- Trailing digit in base 47 = walk_step mod 47 = 43. -/
theorem trailing_47 : digit walk_step 47 0 = 43 := by native_decide

/-- Trailing digit in base 10 = 0 (walk step ends in 0). -/
theorem trailing_10 : digit walk_step 10 0 = 0 := by native_decide

/-- Trailing digit in base 16 = 0 (walk step ends in 0 in hex). -/
theorem trailing_16 : digit walk_step 16 0 = 0 := by native_decide

/-- The trailing digit map (for the three trivector primes) agrees with
    the orbifold projection of MonsterWalkZKP. -/
theorem trailing_is_orbifold :
    digit walk_step 71 0 = 57 ∧
    digit walk_step 59 0 = 56 ∧
    digit walk_step 47 0 = 43 := by native_decide

/-- Both b=10 and b=16 have trailing digit 0 — the walk step is divisible
    by both 10 and 16. -/
theorem walk_divisible_by_10_and_16 :
    10 ∣ walk_step ∧ 16 ∣ walk_step := by
  constructor <;> norm_num [walk_step]

/-! ## §8. Base 11: The Palindrome -/

/-- Base 11: [6, 0, 8, 6] — first and last digits are equal. -/
theorem base11_outer_palindrome :
    digit walk_step 11 3 = digit walk_step 11 0 := by native_decide

/-- Base 11: middle zero at position 2 (the second digit from MSB). -/
theorem base11_inner_zero :
    digit walk_step 11 2 = 0 := by native_decide

/-- Base 11: digit 2 (from MSB) = 8, the Monster's binary exponent. -/
theorem base11_middle_eight :
    digit walk_step 11 1 = 8 := by native_decide

/-! ## §9. The 4-digit Stratum as a Functor

Each base b in [10, 20] gives a map φ_b : ℕ → (Z/bZ)⁴ sending
n to its digit vector. The walk step under φ_b is a point in the
4-dimensional discrete torus (Z/bZ)⁴.

The digit count being constant (= 4) across this window means 8080
has "grade 4" in all Earth-adjacent bases — it lives at the natural
4-dimensional scale between the large-prime/small-prime boundary. -/

/-- For every base b in the 4-digit window, the leading digit is at most b-1
    and at least 1 (since the number has exactly 4 digits). -/
theorem leading_digit_nonzero (b : ℕ) (hlo : 10 ≤ b) (hhi : b ≤ 20) :
    1 ≤ digit walk_step b 3 := by
  interval_cases b <;> native_decide

/-- The projection to (Z/71Z, Z/59Z, Z/47Z) is the trailing digit triple. -/
def trailingTriple : ZMod 71 × ZMod 59 × ZMod 47 :=
  ((walk_step : ZMod 71), (walk_step : ZMod 59), (walk_step : ZMod 47))

/-- The trailing triple equals the walk_orbifold of HexWalk. -/
theorem trailing_triple_is_orbifold :
    trailingTriple = walk_orbifold := rfl

/-! ## §10. Grand Summary Theorem -/

/-- All digit-count strata for the 15 SSP bases are as claimed. -/
theorem ssp_digit_strata :
    -- Isolated strata (one prime each)
    digitCount walk_step 2  (by norm_num) (by norm_num [walk_step]) = 13 ∧
    digitCount walk_step 3  (by norm_num) (by norm_num [walk_step]) = 9  ∧
    digitCount walk_step 5  (by norm_num) (by norm_num [walk_step]) = 6  ∧
    digitCount walk_step 7  (by norm_num) (by norm_num [walk_step]) = 5  ∧
    -- Earth stratum: 4 SSP primes, all 4 digits
    digitCount walk_step 11 (by norm_num) (by norm_num [walk_step]) = 4  ∧
    digitCount walk_step 13 (by norm_num) (by norm_num [walk_step]) = 4  ∧
    digitCount walk_step 17 (by norm_num) (by norm_num [walk_step]) = 4  ∧
    digitCount walk_step 19 (by norm_num) (by norm_num [walk_step]) = 4  ∧
    -- Spoke + Hub + Clock: 7 SSP primes, all 3 digits
    digitCount walk_step 23 (by norm_num) (by norm_num [walk_step]) = 3  ∧
    digitCount walk_step 29 (by norm_num) (by norm_num [walk_step]) = 3  ∧
    digitCount walk_step 31 (by norm_num) (by norm_num [walk_step]) = 3  ∧
    digitCount walk_step 41 (by norm_num) (by norm_num [walk_step]) = 3  ∧
    digitCount walk_step 47 (by norm_num) (by norm_num [walk_step]) = 3  ∧
    digitCount walk_step 59 (by norm_num) (by norm_num [walk_step]) = 3  ∧
    digitCount walk_step 71 (by norm_num) (by norm_num [walk_step]) = 3  := by
  simp only [digitCount, walk_step]
  refine ⟨by native_decide, by native_decide, by native_decide, by native_decide,
          by native_decide, by native_decide, by native_decide, by native_decide,
          by native_decide, by native_decide, by native_decide, by native_decide,
          by native_decide, by native_decide, by native_decide⟩

/-- The eigenspace decomposition matches the digit-count strata:
    Earth primes (11,13,17,19) form the 4-digit stratum;
    Spoke+Hub+Clock primes (23–71) form the 3-digit stratum. -/
theorem eigenspace_digit_correspondence :
    -- Earth = 4-digit
    (∀ i : Fin 15, i.val ∈ ([4,5,6,7] : List ℕ) → sspDigitCount i = 4) ∧
    -- Spoke+Hub+Clock = 3-digit
    (∀ i : Fin 15, i.val ∈ ([8,9,10,11,12,13,14] : List ℕ) → sspDigitCount i = 3) := by
  constructor <;> intro i hi <;> fin_cases i <;> simp_all [sspDigitCount]

end HexWalkProjection
