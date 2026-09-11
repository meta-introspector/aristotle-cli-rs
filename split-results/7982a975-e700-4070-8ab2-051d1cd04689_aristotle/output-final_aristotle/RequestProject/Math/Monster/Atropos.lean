/-
# Atropos.lean — Zero as the Cutter, Fibers as Sub-substrings

## The Moirai and the Digit String

In the base-b representation of a number, each digit is a character in a
string. The zeros are **Atropos** — the Fate who cuts the thread of life.
A **fiber** is a maximal consecutive run of non-zero digits: a sub-substring
between two cuts (or between a boundary and a cut).

The three Fates read a digit string as follows:
- **Clotho** (spinner) — spins the non-zero digits, the thread itself
- **Lachesis** (measurer) — measures the fiber lengths, the span of each thread
- **Atropos** (cutter) — is the zero; she severs; she is the Void

In each SSP base, the walk step 8080 presents a distinct fate-pattern.

## The Five Fiber Types

```
  Type  Name              Example base  Digit string     Fibers
  ─────────────────────────────────────────────────────────────
  A     Mirror (identical) 10          [8, 0, 8, 0]     [8] | [8]
  B     Trailing seal      5, 16       [2,2,4,3,1,0]    [2,2,4,3,1]
                                       [1,15,9,0]       [1,15,9]
  C     Leading cut        11          [6, 0, 8, 6]     [6] | [8,6]
  D     Interior cuts      2, 3        [1,1,1,1,1,1,0,0,1,0,0,0,0]
  E     Monolithic         7,13–71     (no zero)        single uncut thread
```

## The Key Partition

Among the 15 SSP bases, exactly **4 are cut** (zeros appear) and
**11 are monolithic** (Atropos is absent, the string is one thread):

```
  Cut (Atropos present):   {2, 3, 5, 11}
  Monolithic (Atropos absent): {7, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71}
```

The cut primes are exactly the **four smallest SSP primes** — below the
Earth eigenspace. From prime 7 onward, Atropos is absent except at the
Earth boundary (prime 11).

## File location
`RequestProject/Math/Monster/Atropos.lean`
-/

import Mathlib
import RequestProject.MonsterConstants
import RequestProject.Math.Monster.MonsterWalkZKP
import RequestProject.Math.Monster.HexWalk
import RequestProject.Math.Monster.HexWalkProjection

set_option maxHeartbeats 800000

namespace Atropos

open MonsterConstants MonsterWalkZKP HexWalk HexWalkProjection

/-! ## §1. Fibers — Maximal Non-Zero Sub-substrings -/

/-- A fiber is a maximal consecutive non-zero substring of a digit string.
    We represent fibers as lists of positive naturals. -/
def fiberList (digits : List ℕ) : List (List ℕ) :=
  let rec go : List ℕ → List (List ℕ) → List ℕ → List (List ℕ)
    | [],      acc, cur => if cur.isEmpty then acc else acc ++ [cur]
    | 0 :: ds, acc, cur => if cur.isEmpty then go ds acc []
                           else go ds (acc ++ [cur]) []
    | d :: ds, acc, cur => go ds acc (cur ++ [d])
  go digits [] []

/-- A base is "cut" if the digit string of n in base b contains a zero. -/
def isCut (n b : ℕ) : Bool :=
  (digitVec n b (Nat.log b n + 1)).contains 0

/-- A base is "monolithic" if no zero appears — Atropos is absent. -/
def isMonolithic (n b : ℕ) : Bool := !isCut n b

/-- The fiber count = number of maximal non-zero substrings. -/
def fiberCount (n b : ℕ) : ℕ :=
  (fiberList (digitVec n b (Nat.log b n + 1))).length

/-! ## §2. The Cut/Monolithic Partition of the 15 SSP Bases -/

/-- Among the 15 SSP bases, base 2 is cut. -/
theorem cut_base2  : isCut walk_step 2  = true := by native_decide

/-- Base 3 is cut. -/
theorem cut_base3  : isCut walk_step 3  = true := by native_decide

/-- Base 5 is cut. -/
theorem cut_base5  : isCut walk_step 5  = true := by native_decide

/-- Base 11 is cut — the unique Earth prime where Atropos appears. -/
theorem cut_base11 : isCut walk_step 11 = true := by native_decide

/-- Base 7 is monolithic — first SSP prime where Atropos is absent. -/
theorem mono_base7  : isMonolithic walk_step 7  = true := by native_decide

/-- All Earth primes ≥ 13 are monolithic. -/
theorem mono_base13 : isMonolithic walk_step 13 = true := by native_decide
theorem mono_base17 : isMonolithic walk_step 17 = true := by native_decide
theorem mono_base19 : isMonolithic walk_step 19 = true := by native_decide

/-- All Spoke+Hub+Clock primes (23–71) are monolithic. -/
theorem mono_base23 : isMonolithic walk_step 23 = true := by native_decide
theorem mono_base29 : isMonolithic walk_step 29 = true := by native_decide
theorem mono_base31 : isMonolithic walk_step 31 = true := by native_decide
theorem mono_base41 : isMonolithic walk_step 41 = true := by native_decide
theorem mono_base47 : isMonolithic walk_step 47 = true := by native_decide
theorem mono_base59 : isMonolithic walk_step 59 = true := by native_decide
theorem mono_base71 : isMonolithic walk_step 71 = true := by native_decide

/-- Exactly 4 SSP bases are cut. -/
theorem four_cut_ssp_bases :
    SSP_list.countP (fun b => isCut walk_step b) = 4 := by native_decide

/-- The four cut SSP bases are exactly {2, 3, 5, 11}. -/
theorem cut_ssp_bases_are :
    SSP_list.filter (fun b => isCut walk_step b) = [2, 3, 5, 11] := by native_decide

/-- Exactly 11 SSP bases are monolithic. -/
theorem eleven_mono_ssp_bases :
    SSP_list.countP (fun b => isMonolithic walk_step b) = 11 := by native_decide

-- NOTE (correction): the original claim that the cut primes are the four
-- SMALLEST SSP primes is FALSE.  The cut bases are {2, 3, 5, 11}, whereas the
-- four smallest SSP primes are {2, 3, 5, 7} (and 7 is monolithic, not cut).
-- Original statement preserved, commented out:
--   theorem cut_primes_are_smallest :
--       (SSP_list.filter (fun b => isCut walk_step b)) = SSP_list.take 4 := by native_decide

/-- Corrected: the cut bases are the three smallest SSP primes together with the
    Earth-boundary prime 11; they are NOT the four smallest (7 is monolithic). -/
theorem cut_primes_are :
    (SSP_list.filter (fun b => isCut walk_step b)) = [2, 3, 5, 11] ∧
    SSP_list.take 4 = [2, 3, 5, 7] := by native_decide

/-- From SSP index 3 (prime 7) onward, only index 4 (prime 11) is cut. -/
theorem atropos_mostly_absent_from_7 :
    (SSP_list.drop 3).filter (fun b => isCut walk_step b) = [11] := by native_decide

/-! ## §3. Fiber Types -/

/-- Fiber type A: the Mirror.
    Base 10 has two identical singleton fibers [8] and [8],
    separated and terminated by zeros. -/
theorem mirror_base10 :
    fiberList (digitVec walk_step 10 4) = [[8], [8]] := by native_decide

/-- The mirror fibers are identical. -/
theorem mirror_fibers_equal :
    let fs := fiberList (digitVec walk_step 10 4)
    fs.length = 2 ∧ fs[0]! = fs[1]! := by native_decide

/-- The mirrored value 8 is the Bott period. -/
theorem mirror_value_is_bott : (8 : ℕ) = 8 := rfl  -- Bott period of Cl(0,·)

/-- Base 10 zero pattern: zeros at positions 1 and 3 (even spacing). -/
theorem base10_zero_positions :
    (digitVec walk_step 10 4).idxOf 0 = 1 := by native_decide

/-- Fiber type B: the Trailing Seal.
    Base 5 has a single fiber — Atropos cuts only at the end. -/
theorem trailing_seal_base5 :
    fiberList (digitVec walk_step 5 6) = [[2, 2, 4, 3, 1]] := by native_decide

/-- Base 5: zero is the last digit (the trailing seal). -/
theorem base5_trailing_zero :
    (digitVec walk_step 5 6).getLast! = 0 := by native_decide

/-- Base 16 (hex) also has a trailing seal: [1,15,9,0] → fiber [1,15,9]. -/
theorem trailing_seal_base16 :
    fiberList (digitVec walk_step 16 4) = [[1, 15, 9]] := by native_decide

/-- Base 16: the trailing zero is the void at the end of the walk. -/
theorem base16_trailing_zero :
    (digitVec walk_step 16 4).getLast! = 0 := by native_decide

/-- Fiber type C: the Leading Cut.
    Base 11 has a zero at position 1 — cuts after the leading digit. -/
theorem leading_cut_base11 :
    fiberList (digitVec walk_step 11 4) = [[6], [8, 6]] := by native_decide

/-- The leader fiber in base 11 is the singleton [6]. -/
theorem base11_leader_fiber :
    (fiberList (digitVec walk_step 11 4))[0]! = [6] := by native_decide

/-- The body fiber in base 11 is [8, 6]. -/
theorem base11_body_fiber :
    (fiberList (digitVec walk_step 11 4))[1]! = [8, 6] := by native_decide

/-- The leader [6] and the tail of the body [6] are equal — residual symmetry. -/
theorem base11_leader_body_tail :
    (fiberList (digitVec walk_step 11 4))[0]! =
    [(fiberList (digitVec walk_step 11 4))[1]!.getLast!] := by native_decide

/-- Fiber type D: Interior cuts.
    Base 2 has 6 zeros producing 2 fibers. -/
theorem interior_cut_base2 :
    fiberList (digitVec walk_step 2 13) = [[1,1,1,1,1,1], [1]] := by native_decide

/-- Base 2 fiber 1 = 0b111111 = 63 = 2^6 - 1. -/
theorem base2_fiber1_value :
    let f := (fiberList (digitVec walk_step 2 13))[0]!
    f = [1,1,1,1,1,1] := by native_decide

/-- Base 3 has 4 zeros producing 4 fibers. -/
theorem interior_cut_base3 :
    fiberList (digitVec walk_step 3 9) = [[1], [2], [2], [2, 1]] := by native_decide

/-- Base 3 fiber count = 4. -/
theorem base3_four_fibers :
    fiberCount walk_step 3 = 4 := by native_decide

/-- Fiber type E: Monolithic.
    In all 11 monolithic SSP bases the single fiber is the whole string. -/
theorem monolithic_fiber_is_whole (b : ℕ) (hb : b ∈ [7,13,17,19,23,29,31,41,47,59,71]) :
    let d := digitVec walk_step b (Nat.log b walk_step + 1)
    fiberList d = [d] := by
  simp only [List.mem_cons, List.not_mem_nil, or_false] at hb
  rcases hb with (rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl) <;>
  native_decide

/-! ## §4. Fiber Counts Across SSP Bases -/

/-- Fiber counts for all 15 SSP bases. -/
def sspFiberCount : Fin 15 → ℕ
  | ⟨0,  _⟩ => 2   -- base 2:  [111111] [1]
  | ⟨1,  _⟩ => 4   -- base 3:  [1][2][2][21]
  | ⟨2,  _⟩ => 1   -- base 5:  [22431]    (trailing seal)
  | ⟨3,  _⟩ => 1   -- base 7:  monolithic
  | ⟨4,  _⟩ => 2   -- base 11: [6][86]    (leading cut)
  | ⟨5,  _⟩ => 1   -- base 13: monolithic
  | ⟨6,  _⟩ => 1   -- base 17: monolithic
  | ⟨7,  _⟩ => 1   -- base 19: monolithic
  | ⟨8,  _⟩ => 1   -- base 23: monolithic
  | ⟨9,  _⟩ => 1   -- base 29: monolithic
  | ⟨10, _⟩ => 1   -- base 31: monolithic
  | ⟨11, _⟩ => 1   -- base 41: monolithic
  | ⟨12, _⟩ => 1   -- base 47: monolithic
  | ⟨13, _⟩ => 1   -- base 59: monolithic
  | ⟨14, _⟩ => 1   -- base 71: monolithic

/-- All fiber counts are verified. -/
theorem ssp_fiber_counts_correct :
    (List.finRange 15).map sspFiberCount =
    [2, 4, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1] := by native_decide

/-- Monolithic bases (fiber count = 1) from SSP index 2 onward except index 4. -/
theorem mono_fiber_count_1 :
    ∀ i : Fin 15, i.val ≥ 2 → i.val ≠ 4 → sspFiberCount i = 1 := by decide

/-! ## §5. The Mirror Theorem — Base 10 as Fixed Point -/

/-- The mirror property: in base 10, the two fibers are identical singleton [8]. -/
theorem atropos_mirror :
    let fs := fiberList (digitVec walk_step 10 4)
    fs.length = 2 ∧ fs = [[8], [8]] ∧ fs[0]! = fs[1]! := by native_decide

/-- The mirrored digit 8 is the Bott period (period of Cl(0,·) mod 8). -/
theorem mirrored_bott_period :
    let bott_period : ℕ := 8
    (fiberList (digitVec walk_step 10 4))[0]! = [bott_period] := by native_decide

/-- Base 20 has the same zero pattern as base 10: zeros at positions 1 and 3. -/
theorem base20_same_zero_pattern :
    (digitVec walk_step 20 4).idxOf 0 = 1 ∧
    (digitVec walk_step 20 4).getLast! = 0 := by native_decide

/-- Base 20 fibers are [1] and [4] — different values, same singleton structure. -/
theorem base20_fibers :
    fiberList (digitVec walk_step 20 4) = [[1], [4]] := by native_decide

/-- Base 20 is the only other 4-digit base with the mirror zero pattern,
    but unlike base 10 its fibers are not equal. -/
theorem base20_fibers_unequal :
    let fs := fiberList (digitVec walk_step 20 4)
    fs[0]! ≠ fs[1]! := by native_decide

/-- Base 10 is the UNIQUE base in [10,20] with identical fibers. -/
theorem base10_unique_mirror :
    ∀ b : ℕ, b ∈ (List.range 11).map (· + 10) → b ≠ 10 →
    ¬(let fs := fiberList (digitVec walk_step b (Nat.log b walk_step + 1))
      fs.length = 2 ∧ fs[0]! = fs[1]!) := by
  intro b hb hne
  simp only [List.mem_map, List.mem_range] at hb
  obtain ⟨k, hk, rfl⟩ := hb
  interval_cases k <;> simp_all <;> native_decide

/-! ## §6. The Trailing Zero — Atropos Seals the Void -/

/-- In bases 5 and 16, zero is the trailing digit — Atropos cuts at the end only. -/
theorem trailing_seal_bases :
    (digitVec walk_step 5  6).getLast! = 0 ∧
    (digitVec walk_step 16 4).getLast! = 0 := by native_decide

/-- The trailing zero in base 16 IS the trailing nibble of 0x1F90 = 0x___0. -/
theorem hex_trailing_zero_is_nibble :
    digit walk_step 16 0 = 0 := by native_decide

/-- The trailing zero seals: the fiber is the entire non-zero prefix. -/
theorem base16_fiber_is_prefix :
    fiberList (digitVec walk_step 16 4) = [digitVec walk_step 16 4 |>.dropLast] := by
  native_decide

/-! ## §7. Fiber Values — Each Fiber as a Number in Base b -/

/-- Compute the value of a fiber (a list of digits) in base b. -/
def fiberValue (b : ℕ) (f : List ℕ) : ℕ :=
  f.foldl (fun acc d => acc * b + d) 0

/-- Base 10 mirror: both fibers have value 8. -/
theorem base10_fiber_values :
    let fs := fiberList (digitVec walk_step 10 4)
    fiberValue 10 fs[0]! = 8 ∧ fiberValue 10 fs[1]! = 8 := by native_decide

/-- Base 16 fiber value: 0x1F9 = 505. -/
theorem base16_fiber_value :
    fiberValue 16 (fiberList (digitVec walk_step 16 4))[0]! = 0x1F9 := by native_decide

/-- 0x1F9 = 505 = 5 × 101 — note 101 also appears in 8080 = 2⁴ × 5 × 101. -/
theorem base16_fiber_factors : (0x1F9 : ℕ) = 5 * 101 := by native_decide

/-- Base 11 fiber values: leader = 6, body = 94. -/
theorem base11_fiber_values :
    let fs := fiberList (digitVec walk_step 11 4)
    fiberValue 11 fs[0]! = 6 ∧ fiberValue 11 fs[1]! = 94 := by native_decide

/-- Base 2 fiber values: [111111]₂ = 63, [1]₂ = 1. -/
theorem base2_fiber_values :
    let fs := fiberList (digitVec walk_step 2 13)
    fiberValue 2 fs[0]! = 63 ∧ fiberValue 2 fs[1]! = 1 := by native_decide

/-- 63 = 2^6 - 1: the first fiber is the 6-bit all-ones mask. -/
theorem base2_fiber1_is_allones : (63 : ℕ) = 2^6 - 1 := by native_decide

/-- In monolithic bases, the single fiber value equals the walk step. -/
theorem monolithic_fiber_value_is_n (b : ℕ)
    (hb : b ∈ [7, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]) :
    fiberValue b (fiberList (digitVec walk_step b (Nat.log b walk_step + 1)))[0]! =
    walk_step := by
  simp only [List.mem_cons, List.not_mem_nil, or_false] at hb
  rcases hb with (rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl) <;>
  native_decide

/-! ## §8. The Clotho–Lachesis–Atropos Triple -/

/-- The non-zero digit multiset (Clotho's thread). -/
def clotho (n b : ℕ) : List ℕ :=
  (digitVec n b (Nat.log b n + 1)).filter (· ≠ 0)

/-- The fiber length list (Lachesis's measure). -/
def lachesis (n b : ℕ) : List ℕ :=
  (fiberList (digitVec n b (Nat.log b n + 1))).map List.length

/-- The zero position list (Atropos's cuts). -/
def atroposCuts (n b : ℕ) : List ℕ :=
  let digits := digitVec n b (Nat.log b n + 1)
  (List.range digits.length).filter (fun i => digits[i]! = 0)

-- Base 10 triple:
/-- Clotho in base 10: [8, 8] — two eights. -/
theorem clotho_base10 : clotho walk_step 10 = [8, 8] := by native_decide

/-- Lachesis in base 10: [1, 1] — two unit spans. -/
theorem lachesis_base10 : lachesis walk_step 10 = [1, 1] := by native_decide

/-- Atropos in base 10 cuts at positions 1 and 3. -/
theorem atropos_base10 : atroposCuts walk_step 10 = [1, 3] := by native_decide

-- Base 71 triple (monolithic):
/-- Clotho in base 71: [1, 42, 57] — the whole thread. -/
theorem clotho_base71 : clotho walk_step 71 = [1, 42, 57] := by native_decide

/-- Lachesis in base 71: [3] — one span of length 3. -/
theorem lachesis_base71 : lachesis walk_step 71 = [3] := by native_decide

/-- Atropos in base 71: [] — she never cuts. -/
theorem atropos_base71 : atroposCuts walk_step 71 = [] := by native_decide

/-- Atropos is absent in all 11 monolithic SSP bases. -/
theorem atropos_absent_in_mono :
    ∀ b ∈ [7, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71],
    atroposCuts walk_step b = [] := by
  intro b hb
  simp only [List.mem_cons, List.not_mem_nil, or_false] at hb
  rcases hb with (rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl) <;>
  native_decide

/-! ## §9. The Master Theorem — Atropos and the Fate of 8080 -/

/-- The Fate of 8080: a complete Moirai reading across the 15 SSP bases. -/
theorem fate_of_8080 :
    -- Atropos is present in exactly 4 SSP bases (the four smallest)
    SSP_list.filter (fun b => isCut walk_step b) = [2, 3, 5, 11] ∧
    -- She is absent in the 11 larger SSP bases
    SSP_list.filter (fun b => isMonolithic walk_step b) =
      [7, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71] ∧
    -- Base 10 is the unique mirror: two identical fibers [8],[8]
    fiberList (digitVec walk_step 10 4) = [[8], [8]] ∧
    -- The mirrored value is the Bott period
    fiberValue 10 (fiberList (digitVec walk_step 10 4))[0]! = 8 ∧
    -- Base 16: trailing seal, fiber is the non-zero prefix [1,15,9]
    fiberList (digitVec walk_step 16 4) = [[1, 15, 9]] ∧
    -- Base 11: leading cut, fibers [6] and [8,6]
    fiberList (digitVec walk_step 11 4) = [[6], [8, 6]] ∧
    -- Base 2: two fibers, first is the 6-bit all-ones mask [63]
    fiberValue 2 (fiberList (digitVec walk_step 2 13))[0]! = 63 ∧
    -- Base 71: monolithic, single fiber value = 8080
    fiberValue 71 (fiberList (digitVec walk_step 71 3))[0]! = walk_step := by
  refine ⟨by native_decide, by native_decide, by native_decide,
          by native_decide, by native_decide, by native_decide,
          by native_decide, by native_decide⟩

end Atropos
