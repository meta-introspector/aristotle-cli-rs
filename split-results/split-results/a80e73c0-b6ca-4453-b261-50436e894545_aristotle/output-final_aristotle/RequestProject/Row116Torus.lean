import Mathlib
import RequestProject.IrrepCRT
import RequestProject.IrrepRows

/-!
# Row 116 as the Universal CRT Torus

Row 116 has the largest prime support — all 15 primes
{2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71} —
making it the universal hub: every other irrep's CRT space embeds
canonically into row 116's torus by zero-padding.

## Structure

1. **Global frame**: `globalPrimes` and `globalMod` define the universal
   CRT torus `ℤ/M_global` where `M_global = ∏ globalPrimes`.

2. **Embedding**: `coordIn116Torus r` computes the CRT coordinate of any
   irrep `r` in the global torus (zero-padding missing primes).

3. **Additive normalization**: `relCoordAdditive r` gives the displacement
   of `r` from row 116 in the global torus, so row 116 maps to 0.

4. **Walk deltas**: `deltaIn116Torus r s` is the CRT displacement from
   `r` to `s`, all computed in the single global frame.

5. **Metric**: `distIn116Torus r s` gives a canonical distance via the
   minimal representative of the delta.

## Note on multiplicative normalization

The user's original proposal to normalize via `x_r · x_116⁻¹` requires
`x_116` to be a unit in `ℤ/M_global`. However, row 116 has padic exponent
2 at prime 2, so `x_116 ≡ 0 (mod 2)`, making it non-invertible. We use
additive normalization instead: `x_r - x_116`, which always works and
makes row 116 the origin.
-/

/-! ## Global CRT frame (row 116's torus) -/

/-- The global modulus: product of all 15 primes. -/
def globalMod : ℕ := globalPrimes.prod

/-- Row 116's exponent list. -/
def row116Exps : List ℕ := [2, 1, 2, 6, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1]

/-- Row 116 as an `IrrepData` (all 15 primes active). -/
def row116 : IrrepData := mkIrrepFromExps row116Exps

/-- Row 116's CRT coordinate in the global torus. -/
def row116Coord : ℕ := embedCRTCoord row116 globalPrimes

/-! ## Embedding into the row-116 torus -/

/-- Embed any irrep into the global (row-116) CRT torus. -/
def coordIn116Torus (r : IrrepData) : ℕ :=
  embedCRTCoord r globalPrimes

/-- All 194 irreps with their global CRT coordinates. -/
def allCoordsIn116Torus : List (ℕ × ℕ) :=
  allIrreps.map fun (idx, r) => (idx, coordIn116Torus r)

/-! ## Additive normalization (row 116 = origin) -/

/-- The additive displacement of irrep `r` from row 116 in `ℤ/M_global`.
    Row 116 maps to 0. -/
def relCoordAdditive (r : IrrepData) : ZMod globalMod :=
  (coordIn116Torus r : ZMod globalMod) - (row116Coord : ZMod globalMod)

/-- All irreps with their relative (additive) coordinates. -/
def allRelCoords : List (ℕ × ZMod globalMod) :=
  allIrreps.map fun (idx, r) => (idx, relCoordAdditive r)

/-! ## CRT walk deltas in the global torus -/

/-- The CRT delta from irrep `r` to irrep `s` in the global torus. -/
def deltaIn116Torus (r s : IrrepData) : ZMod globalMod :=
  (coordIn116Torus s : ZMod globalMod) - (coordIn116Torus r : ZMod globalMod)

/-- Delta in terms of relative coordinates. -/
def deltaRelative (r s : IrrepData) : ZMod globalMod :=
  relCoordAdditive s - relCoordAdditive r

/-- A CRT walk in the global torus: list of (srcIdx, tgtIdx, delta). -/
def globalWalkDeltas (waypoints : List (ℕ × IrrepData)) : List (ℕ × ℕ × ZMod globalMod) :=
  (waypoints.zip (waypoints.tail)).map fun ((i, r), (j, s)) =>
    (i, j, deltaIn116Torus r s)

/-! ## Distance metric in the global torus -/

/-- The circular distance on ℤ/M: min of the two "directions" around the circle.
    Given two natural numbers a, b and modulus M, computes
    min((b - a) mod M, (a - b) mod M). -/
def circDist (a b M : ℕ) : ℕ :=
  if M = 0 then 0
  else
    let a' := a % M
    let b' := b % M
    let fwd := (b' + M - a') % M  -- (b - a) mod M
    let bwd := (a' + M - b') % M  -- (a - b) mod M
    min fwd bwd

theorem circDist_symm (a b M : ℕ) : circDist a b M = circDist b a M := by
  simp only [circDist]
  split
  · rfl
  · exact Nat.min_comm _ _

theorem circDist_self (a M : ℕ) : circDist a a M = 0 := by
  simp only [circDist]
  split
  · rfl
  · simp [Nat.add_sub_cancel, Nat.mod_self]

/-- Distance between two irreps in the global torus:
    the circular distance of their CRT coordinates mod globalMod. -/
def distIn116Torus (r s : IrrepData) : ℕ :=
  circDist (coordIn116Torus r) (coordIn116Torus s) globalMod

/-- The distance is symmetric. -/
theorem distIn116Torus_symm (r s : IrrepData) :
    distIn116Torus r s = distIn116Torus s r := by
  exact circDist_symm _ _ _

/-- The distance from any irrep to itself is 0. -/
theorem distIn116Torus_self (r : IrrepData) :
    distIn116Torus r r = 0 := by
  exact circDist_self _ _

/-! ## Verification: row 116 is the origin -/

/-- Row 116's relative coordinate is 0. -/
theorem relCoord_row116_eq_zero :
    relCoordAdditive row116 = 0 := by
  unfold relCoordAdditive coordIn116Torus row116Coord
  simp

/-- The delta from any irrep to itself is 0. -/
theorem delta_self (r : IrrepData) :
    deltaIn116Torus r r = 0 := by
  simp [deltaIn116Torus, sub_self]

/-- The delta equals the difference of relative coordinates. -/
theorem delta_eq_rel_diff (r s : IrrepData) :
    deltaIn116Torus r s = deltaRelative r s := by
  simp [deltaIn116Torus, deltaRelative, relCoordAdditive]

/-! ## Multiplicative normalization (partial — for invertible rows only) -/

/-- Check whether an irrep's global coordinate is invertible in ℤ/M_global.
    This requires all padic exponents to be nonzero mod each prime. -/
def isUnitIn116Torus (r : IrrepData) : Bool :=
  let padded := zeroPadExponents r.profile globalPrimes
  padded.zip globalPrimes |>.all fun (e, p) => e % p != 0

/-- For an invertible reference irrep, compute the multiplicative relative coordinate. -/
def relCoordMultiplicative (r href : IrrepData)
    (_h : isUnitIn116Torus href = true := by decide) : ZMod globalMod :=
  let xr := (coordIn116Torus r : ZMod globalMod)
  let xref := (coordIn116Torus href : ZMod globalMod)
  xr * xref⁻¹

/-! ## Computational verification -/

-- Row 116 support is all 15 primes
#eval row116.support
#eval row116.support.length  -- 15

-- Global modulus
#eval globalMod

-- Row 116's global coordinate
#eval row116Coord

-- Row 116 is NOT a unit (exponent 2 at prime 2 means ≡ 0 mod 2)
#eval isUnitIn116Torus row116  -- false

-- First 10 global coordinates
#eval (allCoordsIn116Torus.take 10)

-- Row 1 coordinate in global torus
#eval coordIn116Torus (mkIrrepFromExps [0,0,0,0,0,0,0,0,0,0,0,0,1,1,1])

-- Row 192 coordinate in global torus
#eval coordIn116Torus (mkIrrepFromExps [46,2,0,0,2,0,1,0,1,0,0,1,1,1,1])

/-! ## Walk example: first 5 irreps in global torus -/

-- Walk through irreps 0→1→2→3→4 in the global torus
#eval do
  let walk := (allIrreps.take 5)
  let deltas := globalWalkDeltas walk
  return deltas

/-! ## Per-prime decomposition of global coordinates -/

/-- Decompose a global CRT coordinate into per-prime residues.
    Returns [(prime, residue mod prime)]. -/
def decomposeCoord (x : ℕ) : List (ℕ × ℕ) :=
  globalPrimes.map fun p => (p, x % p)

-- Verify row 116's decomposition matches its exponents
#eval decomposeCoord row116Coord
-- Should give [(2, 0), (3, 1), (5, 2), (7, 6), (11, 1), (13, 2), ...]
-- Note: prime 2 gives residue 0 (exponent 2 ≡ 0 mod 2)

-- Verify row 1's decomposition
#eval decomposeCoord (coordIn116Torus (mkIrrepFromExps [0,0,0,0,0,0,0,0,0,0,0,0,1,1,1]))
-- Should give 0 for all primes except 47→1, 59→1, 71→1

/-! ## Hub analysis: which rows are units in the global torus? -/

/-- Count how many of the 194 irreps are units in the global torus. -/
def unitCount : ℕ :=
  allIrreps.countP fun (_, r) => isUnitIn116Torus r

#eval unitCount

/-- List the indices of irreps that ARE units in the global torus. -/
def unitIndices : List ℕ :=
  (allIrreps.filter fun (_, r) => isUnitIn116Torus r).map Prod.fst

#eval unitIndices

/-! ## Nearest neighbors in the global torus -/

/-- For a given irrep index, find its k nearest neighbors by global torus distance. -/
def nearestInGlobalTorus (idx : ℕ) (k : ℕ := 5) : List (ℕ × ℕ) :=
  match allIrreps.find? (fun p => p.1 == idx) with
  | none => []
  | some (_, r) =>
    let dists := allIrreps.filterMap fun (j, s) =>
      if j == idx then none
      else some (j, distIn116Torus r s)
    (dists.toArray.qsort (fun a b => a.2 < b.2)).toList.take k

-- 5 nearest neighbors to row 116 in the global torus
#eval nearestInGlobalTorus 116

-- 5 nearest neighbors to row 1
#eval nearestInGlobalTorus 1

-- 5 nearest neighbors to row 192
#eval nearestInGlobalTorus 192

/-! ## Global greedy TSP tour -/

/-- Greedy nearest-neighbor TSP tour in the global torus, starting from a given index. -/
def greedyGlobalTSP (startIdx : ℕ) : List ℕ × ℕ :=
  let all := allIrreps
  match all.find? (fun p => p.1 == startIdx) with
  | none => ([], 0)
  | some (_, startR) =>
    let n := all.length
    let rec go (visited : List ℕ) (current : ℕ × IrrepData)
        (remaining : List (ℕ × IrrepData)) (totalCost : ℕ) (fuel : ℕ) :=
      match fuel with
      | 0 => (visited.reverse, totalCost)
      | fuel + 1 =>
        match remaining with
        | [] =>
          -- Return to start
          let closeCost := distIn116Torus current.2 startR
          ((visited).reverse, totalCost + closeCost)
        | _ =>
          let nearest := remaining.foldl (fun (best : Option (ℕ × IrrepData × ℕ)) cand =>
            let d := distIn116Torus current.2 cand.2
            match best with
            | none => some (cand.1, cand.2, d)
            | some (_, _, bd) => if d < bd then some (cand.1, cand.2, d) else best
          ) none
          match nearest with
          | none => (visited.reverse, totalCost)
          | some (ni, nr, nd) =>
            let remaining' := remaining.filter (fun p => p.1 != ni)
            go (ni :: visited) (ni, nr) remaining' (totalCost + nd) fuel
    let remaining := all.filter (fun p => p.1 != startIdx)
    go [startIdx] (startIdx, startR) remaining 0 (n + 1)

-- TSP tour starting from row 116 (the universal hub)
#eval (greedyGlobalTSP 116).2

-- TSP tour starting from row 1
#eval (greedyGlobalTSP 1).2

-- First 20 stops of the tour from row 116
#eval (greedyGlobalTSP 116).1.take 20

/-! ## Summary statistics -/

/-- Compute min, max, and mean of global coordinates. -/
def globalCoordStats : ℕ × ℕ × ℕ :=
  let coords := allCoordsIn116Torus.map Prod.snd
  let mn := coords.foldl min globalMod
  let mx := coords.foldl max 0
  let sm := coords.foldl (· + ·) 0
  (mn, mx, sm / coords.length)

#eval globalCoordStats
