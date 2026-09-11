import Mathlib
import RequestProject.IrrepCRT
import RequestProject.IrrepRows

/-!
# Pairwise CRT Tables and Embeddings

For any two irreps r, s we build the union CRT space and embed both
into it. This creates a "web" of CRT tori where every pair can be
compared in a common frame.

## Key structures

- `PairCRTData` — the CRT data for a pair of irreps in their union torus
- `allPairCRTData` — computed for all (194 choose 2) pairs
- Unique union-support keys identify distinct CRT tables
-/

/-! ## Pairwise CRT data -/

/-- CRT data for a pair of irreps embedded in their union torus. -/
structure PairCRTData where
  /-- A001379 index of first irrep -/
  idx1 : ℕ
  /-- A001379 index of second irrep -/
  idx2 : ℕ
  /-- Union prime support (sorted) -/
  unionPrimes : List ℕ
  /-- Union modulus: product of unionPrimes -/
  unionMod : ℕ
  /-- First irrep's CRT coordinate in the union space -/
  coord1 : ℕ
  /-- Second irrep's CRT coordinate in the union space -/
  coord2 : ℕ
  deriving Repr

/-- Build `PairCRTData` for two irreps. -/
def mkPairCRT (idx1 idx2 : ℕ) (r1 r2 : IrrepData) : PairCRTData :=
  let up := (unionSupport r1 r2).mergeSort (· ≤ ·)
  { idx1 := idx1
    idx2 := idx2
    unionPrimes := up
    unionMod := up.prod
    coord1 := embedCRTCoord r1 up
    coord2 := embedCRTCoord r2 up }

/-! ## Canonical union-support key -/

/-- Canonical key for a union support: sorted prime list. -/
def unionKey (r1 r2 : IrrepData) : List ℕ :=
  (unionSupport r1 r2).mergeSort (· ≤ ·)

/-! ## All pairs -/

/-- All ordered pairs (i < j) of irreps. -/
def allPairs : List ((ℕ × IrrepData) × (ℕ × IrrepData)) :=
  allIrreps.flatMap fun (i, r) =>
    (allIrreps.filter fun (j, _) => i < j).map fun (j, s) => ((i, r), (j, s))

/-- Compute PairCRTData for all pairs. -/
def allPairCRTData : List PairCRTData :=
  allPairs.map fun ((i, r), (j, s)) => mkPairCRT i j r s

/-! ## Unique union support keys -/

/-- All distinct union-support keys across all pairs. -/
def uniqueUnionKeys : List (List ℕ) :=
  (allPairCRTData.map (·.unionPrimes)).dedup

/-- Number of unique CRT tables. -/
def numUniqueTables : ℕ := uniqueUnionKeys.length

/-! ## Support inclusion check -/

/-- Check if r's support is a subset of s's support. -/
def supportSubsetBool (r s : IrrepData) : Bool :=
  r.support.all (· ∈ s.support)

/-- Count pairs where one support includes the other. -/
def countNestedPairs : ℕ :=
  allPairs.countP fun ((_, r), (_, s)) =>
    supportSubsetBool r s || supportSubsetBool s r

/-! ## Monster-base projection of all irreps -/

/-- Each irrep's Monster-base (47,59,71) projection. -/
def monsterProjections : List (ℕ × ℕ) :=
  allIrreps.map fun (idx, r) => (idx, rowMonsterEmb r)

/-! ## Computational verification -/

-- Example: pair (1, 192)
-- Row 1: support = {47, 59, 71}
-- Row 192: support = {2, 3, 11, 17, 23, 41, 47, 59, 71}
-- Union support = {2, 3, 11, 17, 23, 41, 47, 59, 71}
-- (Row 1 ⊆ Row 192)

#eval do
  let r1 := mkIrrepFromExps [0,0,0,0,0,0,0,0,0,0,0,0,1,1,1]  -- row 1
  let r192 := mkIrrepFromExps [46,2,0,0,2,0,1,0,1,0,0,1,1,1,1]  -- row 192
  let pair := mkPairCRT 1 192 r1 r192
  return (pair.unionPrimes, pair.unionMod, pair.coord1, pair.coord2)

-- Check support inclusion: row 1 ⊆ row 192
#eval do
  let r1 := mkIrrepFromExps [0,0,0,0,0,0,0,0,0,0,0,0,1,1,1]
  let r192 := mkIrrepFromExps [46,2,0,0,2,0,1,0,1,0,0,1,1,1,1]
  return (supportSubsetBool r1 r192, supportSubsetBool r192 r1)

-- Example: pair (160, 168) — possibly different supports
#eval do
  let r160 := mkIrrepFromExps [0,17,7,4,2,2,0,0,0,0,1,0,0,1,1]
  let r168 := mkIrrepFromExps [18,19,0,0,0,3,0,0,0,1,1,1,0,1,1]
  let pair := mkPairCRT 160 168 r160 r168
  return (pair.unionPrimes, pair.unionMod, pair.coord1, pair.coord2)

/-! ## Per-row CRT summary table -/

/-- Full per-row CRT summary: (index, support, modulus, crt_coord, monster_emb). -/
def fullRowSummary : List (ℕ × List ℕ × ℕ × ℕ × ℕ) :=
  allIrreps.map fun (idx, r) =>
    (idx, r.support, r.modulus, crtCoord r.support r.exponents, rowMonsterEmb r)

-- Print first 5 rows of the summary
#eval (fullRowSummary.take 5)

-- Print rows with Monster base primes only (47, 59, 71)
#eval (fullRowSummary.filter fun (_, support, _, _, _) =>
  support.all (· ∈ [47, 59, 71]))

/-! ## Formal properties -/

/-- The union support always contains both individual supports. -/
theorem union_contains_left (r s : IrrepData) (p : ℕ) (hp : p ∈ r.support) :
    p ∈ unionSupport r s := by
  simp [unionSupport, List.mem_dedup]
  exact Or.inl hp

theorem union_contains_right (r s : IrrepData) (p : ℕ) (hp : p ∈ s.support) :
    p ∈ unionSupport r s := by
  simp [unionSupport, List.mem_dedup]
  exact Or.inr hp

/-- The union modulus is a multiple of each individual modulus
    when supports are subsets and primes are pairwise coprime.
    (Statement for computational verification.) -/
def unionModDivisible (r s : IrrepData) : Bool :=
  (unionSupport r s).prod % r.modulus == 0 &&
  (unionSupport r s).prod % s.modulus == 0

-- Verify divisibility for a sample pair
#eval do
  let r1 := mkIrrepFromExps [0,0,0,0,0,0,0,0,0,0,0,0,1,1,1]
  let r192 := mkIrrepFromExps [46,2,0,0,2,0,1,0,1,0,0,1,1,1,1]
  return (unionModDivisible r1 r192)

/-! ## Statistics -/

-- Total number of pairs
#eval allPairs.length

-- How many Monster projections are distinct?
#eval (monsterProjections.map Prod.snd).dedup.length

-- Row 0 (trivial) has empty support
#eval (allIrreps.find? (fun p => p.1 == 0)).map fun (_, r) => r.support
