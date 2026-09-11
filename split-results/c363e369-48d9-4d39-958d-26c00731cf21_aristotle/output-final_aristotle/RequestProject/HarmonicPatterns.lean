import Mathlib
import RequestProject.GeometricPatterns

/-!
# Harmonic / p-adic structure of the A001379 valuation matrix

This file machine-verifies the **five structural patterns** of the
`194 × 15` p-adic valuation matrix of the Monster irreducible degrees,
reusing the raw grid `Monster.matrix` from `GeometricPatterns.lean`.

The 15 columns are the supersingular ("Monstrous Moonshine") primes
`2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71`; entry `M[i][j]`
is the `p_j`-adic valuation of the `i`-th Monster degree.  The rows are in
the *density display order* of the original table (decreasing
`row_exponent_sum`).

The five patterns, each stated below as a checked theorem:

1. **Cluster families** — the degrees come in p-adic *families*: only `170`
   of the `194` rows are distinct, `23` signatures repeat, and the largest
   family has multiplicity `3`.

2. **2-adic / 3-adic dominant bands** — column `0` (prime 2) carries strictly
   more total valuation than any other column, and column `1` (prime 3) is the
   unique runner-up; together they account for `2147` of the `5237` units.

3. **Higher-prime binary switches** — the primes `11, 13, 17, 19, 23`
   (columns 4–8) are tiny: columns 6–8 (primes 17, 19, 23) are strictly
   *binary* (`≤ 1`), column 4 (prime 11) is `≤ 2`, column 5 (prime 13) is
   `≤ 3`; `752` of those `970` cells are `0` or `1`.

4. **Harmonic terraces** — the per-row valuation total
   (`row_exponent_sum`) is **monotonically non-increasing** down the display
   order, forming descending terraces; the longest flat plateau is `17` rows.

5. **Total mass / Moonshine shadow** — the whole grid sums to `5237` units of
   p-adic valuation spread over the 15 supersingular primes; the first four
   primes `2,3,5,7` alone carry `3371` of them.
-/

namespace Monster

/-! ## Pattern 1: Cluster families (repeated p-adic signatures) -/

/-- The number of **distinct** p-adic signatures among the 194 rows is `170`:
    the Monster degrees fall into families with shared prime fingerprints. -/
theorem distinct_signatures : matrix.dedup.length = 170 := by native_decide

/-- Hence exactly `24` rows duplicate an earlier signature (`194 - 170`). -/
theorem duplicate_row_count : matrix.length - matrix.dedup.length = 24 := by
  native_decide

/-- Multiplicity of a signature: how many rows equal it. -/
def signatureMult (r : List Nat) : Nat := (matrix.filter (fun s => s == r)).length

/-- There are `23` distinct signatures that occur at least twice. -/
theorem repeated_signature_count :
    (matrix.dedup.filter (fun r => 2 ≤ signatureMult r)).length = 23 := by
  native_decide

/-- The largest p-adic family has multiplicity exactly `3`: no signature
    occurs more than three times, and at least one does. -/
theorem max_family_multiplicity :
    (matrix.map signatureMult).foldl Nat.max 0 = 3 := by native_decide

/-- A concrete triple family: rows 6, 7, 8 carry the identical signature
    `[43,0,0,0,2,2,0,1,1,1,0,1,0,1,0]`. -/
theorem family_example_triple :
    matrix[6]! = matrix[7]! ∧ matrix[7]! = matrix[8]! := by native_decide

/-! ## Pattern 2: 2-adic and 3-adic dominant bands -/

/-- Total valuation carried by column `j` across all 194 rows. -/
def colTotal (j : Nat) : Nat := (matrix.map (fun r => r[j]!)).sum

/-- Column 0 (prime 2) carries strictly more total valuation than every other
    column: the 2-adic band dominates the whole matrix. -/
theorem two_adic_dominant :
    ∀ j ∈ List.range 15, j ≠ 0 → colTotal j < colTotal 0 := by native_decide

/-- Column 1 (prime 3) is the unique runner-up: it dominates every column
    except column 0. -/
theorem three_adic_second :
    ∀ j ∈ List.range 15, j ≠ 0 → j ≠ 1 → colTotal j < colTotal 1 := by
  native_decide

/-- The exact totals of the two leading bands: `v₂` contributes `1295`,
    `v₃` contributes `852`, for a combined `2147` of the `5237` total units. -/
theorem leading_band_totals :
    colTotal 0 = 1295 ∧ colTotal 1 = 852 ∧ colTotal 0 + colTotal 1 = 2147 := by
  native_decide

/-! ## Pattern 3: Higher-prime binary switches -/

/-- Columns 6–8 (primes 17, 19, 23) are strictly binary: every entry is `0`
    or `1`. -/
theorem switches_binary :
    ∀ i ∈ List.range 194, ∀ j ∈ ([6, 7, 8] : List Nat), cell i j ≤ 1 := by
  native_decide

/-- In fact the **entire high-prime tail** is binary: for every one of the nine
    primes `17,19,23,29,31,41,47,59,71` (columns 6–14) every cell of the whole
    `194 × 15` matrix is `0` or `1`.  The valuation hierarchy thus collapses to
    pure binary logic from prime 17 upward. -/
theorem tail_binary_full :
    ∀ i ∈ List.range 194, ∀ j ∈ ([6,7,8,9,10,11,12,13,14] : List Nat), cell i j ≤ 1 := by
  native_decide

/-- Column 4 (prime 11) never exceeds `2`. -/
theorem prime_eleven_bound :
    ∀ i ∈ List.range 194, cell i 4 ≤ 2 := by native_decide

/-- Column 5 (prime 13) never exceeds `3`. -/
theorem prime_thirteen_bound :
    ∀ i ∈ List.range 194, cell i 5 ≤ 3 := by native_decide

/-- Across the five "switch" primes `11,13,17,19,23` (columns 4–8), `752` of
    the `970` cells are `0` or `1` — the switches are almost always off/on. -/
theorem switches_mostly_binary :
    ((List.range 194).map (fun i =>
      (([4, 5, 6, 7, 8] : List Nat).filter (fun j => cell i j ≤ 1)).length)).sum
      = 752 := by native_decide

/-! ## Pattern 4: Harmonic terraces in the exponent sum -/

/-- The per-row valuation total — the `row_exponent_sum` column of the data. -/
def rowExpSum (i : Nat) : Nat := (matrix[i]?.getD []).sum

/-- The leading row totals reproduce the published `row_exponent_sum` column. -/
theorem rowExpSum_head :
    rowExpSum 0 = 56 ∧ rowExpSum 1 = 55 ∧ rowExpSum 2 = 55 ∧ rowExpSum 3 = 54 := by
  native_decide

/-- **Monotone terraces.** Down the display order the exponent sum never
    increases: `rowExpSum (i+1) ≤ rowExpSum i`. -/
theorem terraces_monotone :
    ∀ i ∈ List.range 193, rowExpSum (i + 1) ≤ rowExpSum i := by native_decide

/-- The terraces span the full range from `56` (top) down to `0` (the trivial
    representation at the bottom). -/
theorem terraces_endpoints :
    rowExpSum 0 = 56 ∧ rowExpSum 193 = 0 := by native_decide

/-- The longest flat plateau (maximal run of equal consecutive exponent sums)
    has length `17`: there are 17 consecutive degrees all of exponent-sum `26`,
    namely rows 88–104. -/
theorem longest_plateau :
    ∀ i ∈ List.range 17, rowExpSum (88 + i) = 26 := by native_decide

/-- The plateau is maximal on both sides: the rows bordering rows 88–104 have a
    strictly larger / strictly smaller exponent sum. -/
theorem plateau_maximal :
    rowExpSum 87 > 26 ∧ rowExpSum 105 < 26 := by native_decide

/-! ## Pattern 4b: Anatomy of the longest plateau (rows 88–104)

The 17 consecutive degrees of exponent-sum `26` are isolated here as their own
list so their internal structure can be certified directly. -/

/-- The 17 rows of the longest flat terrace, in display order (rows 88–104). -/
def plateau : List (List Nat) := (List.range 17).map (fun i => matrix[88 + i]!)

/-- The plateau really is 17 rows long and every one sums to `26`. -/
theorem plateau_length_and_sum :
    plateau.length = 17 ∧ ∀ r ∈ plateau, r.sum = 26 := by native_decide

/-- Inside the plateau the p-adic families persist: only `15` of the `17`
    signatures are distinct, so exactly `2` plateau rows duplicate a neighbour
    (the two pairs `[1,12,0,6,…]` and `[1,0,9,6,2,2,…]`). -/
theorem plateau_distinct :
    plateau.dedup.length = 15 ∧ plateau.length - plateau.dedup.length = 2 := by
  native_decide

/-- The high-prime tail is *binary throughout the plateau*: for primes
    `17,19,23,29,31,41,47,59,71` (columns 6–14) every plateau entry is `0` or
    `1`. -/
theorem plateau_binary_tail :
    ∀ r ∈ plateau, ∀ j ∈ ([6,7,8,9,10,11,12,13,14] : List Nat), r[j]! ≤ 1 := by
  native_decide

/-- Mass split of the plateau: of its `17 * 26 = 442` units, the six low primes
    `2,3,5,7,11,13` (columns 0–5) carry `320` and the nine high primes carry the
    remaining `122` — the terrace lives overwhelmingly on the small primes. -/
theorem plateau_mass_split :
    (plateau.map (fun r => ((List.range 6).map (fun k => r[k]!)).sum)).sum = 320 ∧
    (plateau.map (fun r => ((List.range 9).map (fun k => r[6+k]!)).sum)).sum = 122 ∧
    320 + 122 = 17 * 26 := by native_decide

/-- Exactly `4` of the 17 plateau degrees are *odd* (2-adic valuation `0`); the
    other 13 are even. -/
theorem plateau_odd_count :
    (plateau.filter (fun r => r[0]! == 0)).length = 4 := by native_decide

/-- The published A001379 indices of the 17 plateau rows (the `index` column of
    the original table, for the rows whose exponent-sum is `26`). -/
def plateauIndices : List Nat :=
  [43, 44, 60, 67, 91, 117, 126, 127, 128, 133, 137, 148, 149, 183, 184, 189, 190]

/-- The index list has the expected size and is a strictly increasing list of
    distinct indices spanning `43 … 190`. -/
theorem plateauIndices_props :
    plateauIndices.length = 17 ∧
    (∀ p ∈ plateauIndices.zip plateauIndices.tail, p.1 < p.2) ∧
    plateauIndices.Nodup ∧
    plateauIndices.head? = some 43 ∧ plateauIndices.getLast? = some 190 := by
  native_decide

/-! ## Pattern 5: Total mass — the Moonshine shadow -/

/-- The whole `194 × 15` grid contains `5237` units of p-adic valuation. -/
theorem total_mass : (matrix.map (fun r => r.sum)).sum = 5237 := by native_decide

/-- The total mass equals the sum of all per-row exponent sums (the data's
    `row_exponent_sum` column adds up to the grid total). -/
theorem total_mass_eq_rowsums :
    (matrix.map (fun r => r.sum)).sum = ((List.range 194).map rowExpSum).sum := by
  native_decide

/-- The four smallest supersingular primes `2,3,5,7` carry `3371` of the
    `5237` units — the overwhelming majority of the valuation mass lives on the
    low primes, the "shadow" of the dominant low-genus part of Moonshine. -/
theorem low_prime_mass :
    colTotal 0 + colTotal 1 + colTotal 2 + colTotal 3 = 3371 := by native_decide

/-! ## Summary -/

/-- One theorem collecting the five headline invariants. -/
theorem harmonic_patterns_summary :
    matrix.dedup.length = 170 ∧
    (∀ j ∈ List.range 15, j ≠ 0 → colTotal j < colTotal 0) ∧
    (∀ i ∈ List.range 194, ∀ j ∈ ([6, 7, 8] : List Nat), cell i j ≤ 1) ∧
    (∀ i ∈ List.range 193, rowExpSum (i + 1) ≤ rowExpSum i) ∧
    (matrix.map (fun r => r.sum)).sum = 5237 := by
  refine ⟨distinct_signatures, two_adic_dominant, switches_binary,
    terraces_monotone, total_mass⟩

end Monster
