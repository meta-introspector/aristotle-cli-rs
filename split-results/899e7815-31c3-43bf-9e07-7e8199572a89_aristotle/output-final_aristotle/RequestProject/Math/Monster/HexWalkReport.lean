/-
# HexWalkReport.lean — A Lean-generated report of Hex-Walk projections, base-views and modifications

## Purpose

This module makes Lean itself *print* a human-readable report of the Hex Walk
number `8080 = 0x1F90` (and, as a bonus, the full Monster group order
`N = |𝕄|`) viewed under many lenses:

* **Base projections** — the same number written in many radices (2…16 and the
  15 supersingular "Monster" bases), with digit lists, digit counts and digit
  sums.
* **Residue projections** — the value reduced modulo each supersingular prime
  (the "shard"/orbifold view).
* **Modifications** — structural transforms of the number: prime factorisation,
  digit reversal, nibble complement, bit-reversal, byte split, and the
  successive "memory walk" of nibble-stripping.

Everything reported here is *computed by Lean* through `#eval` and printed with
`IO.println`. The numbers it prints are pinned down by the `theorem`s in
`§ Verification`, which tie the report's computations back to the already-proved
facts in `HexWalk` / `HexWalkProjection`, so the report cannot silently drift
from the verified statements.

## File location
`RequestProject/Math/Monster/HexWalkReport.lean`

## Dependencies
`MonsterConstants`, `MonsterWalkZKP`, `HexWalk`, `HexWalkProjection`
-/

import Mathlib
import RequestProject.MonsterConstants
import RequestProject.Math.Monster.MonsterWalkZKP
import RequestProject.Math.Monster.HexWalk
import RequestProject.Math.Monster.HexWalkProjection

set_option maxHeartbeats 1000000

namespace HexWalkReport

open MonsterConstants MonsterWalkZKP

/-! ## §1. Base-conversion primitives -/

/-- Digits of `n` in base `b`, most-significant first.
    Falls back to `[n]` for degenerate bases and `[0]` for `n = 0`. -/
partial def toBaseDigits (n b : ℕ) : List ℕ :=
  if b < 2 then [n]
  else if n = 0 then [0]
  else
    let rec go (m : ℕ) (acc : List ℕ) : List ℕ :=
      if m = 0 then acc else go (m / b) ((m % b) :: acc)
    go n []

/-- Render a single digit: `0…9`, then `a…z` for `10…35`, else `(d)`. -/
def digitChar (d : ℕ) : String :=
  if d < 10 then toString d
  else if d < 36 then String.singleton (Char.ofNat (97 + (d - 10)))
  else "(" ++ toString d ++ ")"

/-- Compact rendering of `n` in base `b` (e.g. `8080` in base `16` is `"1f90"`). -/
def renderBase (n b : ℕ) : String :=
  String.join ((toBaseDigits n b).map digitChar)

/-- The number of base-`b` digits of `n`. -/
def baseDigitCount (n b : ℕ) : ℕ := (toBaseDigits n b).length

/-- The base-`b` digit sum of `n`. -/
def baseDigitSum (n b : ℕ) : ℕ := (toBaseDigits n b).sum

/-- Left-pad a string to width `w` with spaces. -/
def padLeft (s : String) (w : ℕ) : String :=
  let k := w - s.length
  String.mk (List.replicate k ' ') ++ s

/-- Right-pad a string to width `w` with spaces. -/
def padRight (s : String) (w : ℕ) : String :=
  let k := w - s.length
  s ++ String.mk (List.replicate k ' ')

/-! ## §2. The numbers under study -/

/-- The Hex-Walk step. -/
def walk : ℕ := 8080

/-- The full Monster group order `N = |𝕄|`. -/
def monsterOrder : ℕ := 808017424794512875886459904961710757005754368000000000

/-- The 15 supersingular ("Monster") prime bases. -/
def sspBases : List ℕ := SSP_list

/-! ## §3. Base-projection report -/

/-- One report line for the value `n` in base `b`. -/
def baseLine (n b : ℕ) : String :=
  padLeft (toString b) 3 ++ " | " ++
  padRight (renderBase n b) 18 ++ " | digits " ++
  padLeft (toString (baseDigitCount n b)) 3 ++ " | digitsum " ++
  padLeft (toString (baseDigitSum n b)) 4 ++ " | list " ++
  toString (toBaseDigits n b)

/-- Multi-base projection block for `n` over the given list of bases. -/
def baseBlock (title : String) (n : ℕ) (bases : List ℕ) : String :=
  let header :=
    "  " ++ title ++ "  (decimal " ++ toString n ++ ")\n" ++
    "  base| representation     | digit count | digit sum  | digit list\n" ++
    "  ----+--------------------+-------------+------------+-----------"
  String.intercalate "\n" (header :: bases.map (fun b => "  " ++ baseLine n b))

/-! ## §4. Residue-projection report -/

/-- One residue line: `n mod p` for a supersingular prime `p`. -/
def residueLine (n p : ℕ) : String :=
  "  mod " ++ padLeft (toString p) 3 ++ " = " ++ padLeft (toString (n % p)) 3

/-- Residue projection block: `n` reduced modulo every supersingular prime. -/
def residueBlock (n : ℕ) : String :=
  "  Residue (shard / orbifold) projection of " ++ toString n ++ ":\n" ++
  String.intercalate "\n" (sspBases.map (fun p => residueLine n p))

/-! ## §5. Modification report -/

/-- Trial-division prime factorisation as a list of `(prime, exponent)` pairs. -/
partial def factorPairs (n : ℕ) : List (ℕ × ℕ) :=
  let rec peel (m p : ℕ) (e : ℕ) : ℕ × ℕ :=
    if p ∣ m ∧ m > 1 then peel (m / p) p (e + 1) else (m, e)
  let rec go (m p : ℕ) (acc : List (ℕ × ℕ)) : List (ℕ × ℕ) :=
    if m ≤ 1 then acc.reverse
    else if p * p > m then ((m, 1) :: acc).reverse
    else
      let (m', e) := peel m p 0
      if e = 0 then go m (p + 1) acc
      else go m' (p + 1) ((p, e) :: acc)
  go n 2 []

/-- Render a factorisation `[(2,4),(5,1),(101,1)]` as `"2^4 * 5 * 101"`. -/
def renderFactor (n : ℕ) : String :=
  let parts := (factorPairs n).map (fun (p, e) =>
    if e = 1 then toString p else toString p ++ "^" ++ toString e)
  if parts.isEmpty then toString n else String.intercalate " * " parts

/-- The "memory walk": strip the leading base-`b` nibble/digit repeatedly. -/
partial def memoryWalk (n b : ℕ) : List ℕ :=
  let rec go (m : ℕ) (acc : List ℕ) : List ℕ :=
    if m = 0 then (m :: acc).reverse
    else
      let d := baseDigitCount m b
      let stripped := m % b ^ (d - 1)
      go stripped (m :: acc)
  go n []

/-- Modification block: structural transforms of `n` (here viewed in base `b`). -/
def modificationBlock (n b : ℕ) : String :=
  let digs := toBaseDigits n b
  let revVal := (digs.reverse.foldl (fun a d => a * b + d) 0)
  let comp := digs.map (fun d => (b - 1) - d)
  let compVal := (comp.foldl (fun a d => a * b + d) 0)
  String.intercalate "\n"
    [ "  Modifications of " ++ toString n ++ " (viewed in base " ++ toString b ++ "):"
    , "    prime factorisation : " ++ renderFactor n
    , "    base-" ++ toString b ++ " digits     : " ++ toString digs
    , "    digit reversal      : " ++ toString digs.reverse ++
        "  (value " ++ toString revVal ++ ")"
    , "    radix complement    : " ++ toString comp ++
        "  (value " ++ toString compVal ++ ")"
    , "    memory walk (strip) : " ++ toString (memoryWalk n b) ]

/-! ## §6. The assembled report -/

/-- The full Hex-Walk report as a single string. -/
def report : String :=
  String.intercalate "\n\n"
    [ "================ THE HEX WALK REPORT : 0x1F90 ================"
    , baseBlock "I.  Hex-Walk step in bases 2..16" walk (List.range' 2 15)
    , baseBlock "II. Hex-Walk step in the 15 supersingular bases" walk sspBases
    , residueBlock walk
    , modificationBlock walk 16
    , "================ BONUS : THE FULL MONSTER ORDER |𝕄| ================"
    , baseBlock "III. |𝕄| in selected bases" monsterOrder [2, 10, 16, 71]
    , residueBlock monsterOrder
    , "================ END OF REPORT ================" ]

/-- Print the report.  Run with `#eval` (already invoked below). -/
def printReport : IO Unit := IO.println report

#eval printReport

/-! ## §7. Verification

These theorems pin the report's *computed* values to the already-proved facts,
so the printed numbers are guaranteed faithful. -/

/-- The base renderer reproduces the sacred hex string `1f90`. -/
theorem render_walk_hex : renderBase walk 16 = "1f90" := by native_decide

/-- The base renderer reproduces the binary string of `HexWalk.binary_value`. -/
theorem render_walk_bin : renderBase walk 2 = "1111110010000" := by native_decide

/-- The reported base-71 digits agree with `HexWalkProjection.digits_71`. -/
theorem digits71_agrees :
    toBaseDigits walk 71 = HexWalkProjection.digitVec HexWalk.walk_step 71 3 := by
  native_decide

/-- The reported base-16 digit count is 4 nibbles (the Hex Walk). -/
theorem walk_four_nibbles : baseDigitCount walk 16 = 4 := by native_decide

/-- The reported base-`b` digit counts match the 5-stratum projection
    `[13,9,6,5,4,4,4,4,3,3,3,3,3,3,3]` of `HexWalkProjection`. -/
theorem ssp_digit_counts_agree :
    sspBases.map (fun b => baseDigitCount walk b)
      = [13, 9, 6, 5, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3] := by native_decide

/-- The reported residues over the supersingular bases. -/
theorem ssp_residues :
    sspBases.map (fun p => walk % p)
      = [0, 1, 0, 2, 6, 7, 5, 5, 7, 18, 20, 3, 43, 56, 57] := by native_decide

/-- The base-71 residue is the shard `57` (= `HexWalk.hex_shard`). -/
theorem walk_shard : walk % 71 = HexWalk.hex_shard := by native_decide

/-- The reported prime factorisation string is `2^4 * 5 * 101`
    (matching `HexWalk.walk_step_factorization`). -/
theorem render_factor_walk : renderFactor walk = "2^4 * 5 * 101" := by native_decide

/-- The reported hex memory walk is `[8080, 3984, 144, 0]`, matching the
    descending `HexWalk.memory_addresses`. -/
theorem memory_walk_hex : memoryWalk walk 16 = [8080, 3984, 144, 0] := by native_decide

/-- The Monster order is reported with the correct number of decimal digits (54). -/
theorem monster_decimal_digits : baseDigitCount monsterOrder 10 = 54 := by native_decide

/-- A prime ≤ 71 divides `|𝕄|` (residue 0) iff it is supersingular —
    Ogg's observation, surfaced through the residue report. -/
theorem monster_residue_zero_iff_ssp (p : ℕ) (hp : p.Prime) (hle : p ≤ 71) :
    monsterOrder % p = 0 ↔ p ∈ sspBases := by
  interval_cases p <;> revert hp <;> native_decide

end HexWalkReport
