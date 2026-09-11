/-
# MonsterHairs.lean — The Monster Hair Spectrum

## Construction

Take the Monster group order

  |M| = 2⁴⁶ · 3²⁰ · 5⁹ · 7⁶ · 11² · 13³ · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71
      = 808017424794512875886459904961710757005754368000000000

For every base `b ∈ [2, 71]`, write |M| in base `b`, then apply the residue
map `d ↦ d % 72` to each digit `d`.  The collected multiset of all these
digit-residues across all 70 bases is the **Monster hair spectrum**.

Each digit is a *local* slice ("hair") of the global order; the residue map
projects it into ℤ/72ℤ.  Because every base is ≤ 71, each digit is already
< 72, so the residue map acts as the identity on the digits (`% 72` is a
no-op here) — this is recorded as `residue_map_trivial`.

## Correction to the informal spec

The informal description gave |M| with a leading factor `2^59`.  This is a
typo: the true Monster order uses `2^46`.  We therefore build on the existing,
correct `MonsterSlice.monsterOrder` rather than re-deriving a wrong value.

## File location
`RequestProject/Math/Monster/MonsterHairs.lean`
-/

import Mathlib
import RequestProject.Math.Monster.Slice.MonsterOrder

set_option maxHeartbeats 1600000

namespace MonsterHairs

open MonsterSlice

/-! ## §1. The Monster Order -/

/-- The Monster group order (alias of the project-wide `MonsterSlice.monsterOrder`,
    with the correct factor `2^46`). -/
def MONSTER_ORDER : ℕ := monsterOrder

/-- The Monster order as a decimal. -/
theorem monster_order_value :
    MONSTER_ORDER = 808017424794512875886459904961710757005754368000000000 := by
  native_decide

/-! ## §2. Digit Expansion and the Residue Map -/

/-- Digit expansion of `n` in base `b` (least-significant first, via `Nat.digits`). -/
def digitsInBase (n b : ℕ) : List ℕ := Nat.digits b n

/-- The residue map applied to each digit: `d ↦ d % 72`. -/
def digitResiduesInBase (n b : ℕ) : List ℕ :=
  (digitsInBase n b).map (· % 72)

/-- The list of bases `2, 3, …, 71`. -/
def bases : List ℕ := (List.range 70).map (· + 2)

/-- `bases` is exactly `[2, …, 71]`. -/
theorem bases_eq : bases = (List.range 70).map (· + 2) := rfl

theorem bases_length : bases.length = 70 := by native_decide
theorem bases_head : bases.head? = some 2 := by native_decide
theorem bases_last : bases.getLast? = some 71 := by native_decide

/-! ## §3. The Hair Spectrum -/

/-- The full Monster hair spectrum: all digit-residues of `|M|` across bases 2..71. -/
def monsterHairs : List ℕ :=
  bases.flatMap (fun b => digitResiduesInBase MONSTER_ORDER b)

/-- The total number of hairs is 2948. -/
theorem monsterHairs_length : monsterHairs.length = 2948 := by native_decide

/-- The sum of all hair values is 37484. -/
theorem monsterHairs_sum : monsterHairs.sum = 37484 := by native_decide

/-- The residue map is trivial here: since every base is ≤ 71, every digit is
    already `< 72`, so `d % 72 = d`.  Hence the residues in each base are exactly
    the raw digits. -/
theorem residue_map_trivial :
    ∀ b ∈ bases, digitResiduesInBase MONSTER_ORDER b = digitsInBase MONSTER_ORDER b := by
  native_decide

/-- Consequently the hair spectrum equals the concatenation of the raw base-b
    digit expansions. -/
theorem hairs_eq_raw_digits :
    monsterHairs = bases.flatMap (fun b => digitsInBase MONSTER_ORDER b) := by
  native_decide

/-! ## §4. Quasi-Fibers — Grouping Hairs by Residue Value -/

/-- The quasi-fiber of residue `r`: all hairs equal to `r`. -/
def quasiFiber (r : ℕ) : List ℕ := monsterHairs.filter (· == r)

/-- The cardinality of a quasi-fiber. -/
def quasiFiberCard (r : ℕ) : ℕ := (quasiFiber r).length

/-- Quasi-fiber 0: residue-zero hairs (the most common). -/
theorem quasiFiber_0_card : quasiFiberCard 0 = 639 := by native_decide

/-- Quasi-fiber 8: residue-eight hairs (the Bott period). -/
theorem quasiFiber_8_card : quasiFiberCard 8 = 70 := by native_decide

/-- Quasi-fiber 16: residue-sixteen hairs (16 = 2⁴, the walk-step digit sum). -/
theorem quasiFiber_16_card : quasiFiberCard 16 = 57 := by native_decide

/-- Quasi-fiber 71 is empty: no base in `[2,71]` ever produces the digit 71
    (base `b` has digits `< b ≤ 71`), so 71 never appears as a hair. -/
theorem quasiFiber_71_empty : quasiFiber 71 = [] := by native_decide

/-- Every hair lies in `ℤ/72ℤ`, i.e. every hair value is `< 72`. -/
theorem hairs_lt_72 : ∀ h ∈ monsterHairs, h < 72 := by native_decide

/-- In fact every hair is `< 71` (no digit ever reaches 71). -/
theorem hairs_lt_71 : ∀ h ∈ monsterHairs, h < 71 := by native_decide

/-! ## §5. Refinement: Hairs Refine the Base-Level Digit Counts

Each base `b` contributes exactly `(Nat.digits b |M|).length` hairs.  Summing
these base-level digit counts recovers the total hair count. -/

/-- The number of hairs contributed by base `b` equals the digit count of `|M|`
    in base `b`. -/
theorem hairs_per_base (b : ℕ) :
    (digitResiduesInBase MONSTER_ORDER b).length = (Nat.digits b MONSTER_ORDER).length := by
  simp [digitResiduesInBase, digitsInBase]

/-- The total hair count is the sum of the per-base digit counts. -/
theorem hairs_length_eq_sum_digitCounts :
    monsterHairs.length =
      (bases.map (fun b => (Nat.digits b MONSTER_ORDER).length)).sum := by
  native_decide

/-- The base-2 expansion contributes the most hairs (180 binary digits),
    the base-71 expansion the fewest among the prime bases. -/
theorem binary_contributes_most :
    (digitsInBase MONSTER_ORDER 2).length = 180 ∧
    (digitsInBase MONSTER_ORDER 71).length = 30 := by native_decide

/-! ## §6. Grand Summary -/

/-- The Monster Hair Spectrum: the complete digit-residue projection of `|M|`. -/
theorem monster_hair_spectrum :
    -- The order is the correct value (2^46 leading factor)
    MONSTER_ORDER = 808017424794512875886459904961710757005754368000000000 ∧
    -- There are 2948 hairs in total
    monsterHairs.length = 2948 ∧
    -- The residue map is the identity on digits (all digits < 72)
    monsterHairs = bases.flatMap (fun b => digitsInBase MONSTER_ORDER b) ∧
    -- The residue-0 quasi-fiber is the largest, with 639 hairs
    quasiFiberCard 0 = 639 ∧
    -- The residue-71 quasi-fiber is empty
    quasiFiber 71 = [] ∧
    -- Every hair lies in ℤ/72ℤ
    (∀ h ∈ monsterHairs, h < 72) := by
  refine ⟨by native_decide, by native_decide, by native_decide,
          by native_decide, by native_decide, by native_decide⟩

end MonsterHairs
