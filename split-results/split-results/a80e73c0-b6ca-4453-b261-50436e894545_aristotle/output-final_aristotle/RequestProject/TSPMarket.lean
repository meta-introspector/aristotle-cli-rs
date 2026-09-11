import Mathlib
import RequestProject.IrrepCRT
import RequestProject.IrrepRows
import RequestProject.CRTWalk

/-!
# TSP over Irreps & Prime Market Theory

## Overview

We model the 194 Monster irreps as **cities** in a Traveling Salesman Problem (TSP),
where the "distance" between two irreps is the **CRT transaction cost** of moving
from one prime support to another — i.e., the total number of primes that must be
sold or bought.

We then develop a **prime market theory**: each prime `p` has a *frequency* (how many
irreps carry it), a *total weight* (sum of exponents across irreps), and a *scarcity*
score. Primes that are rare but high-weight are "premium"; primes that are common are
"commodities". The TSP tour then represents an optimal route through the irrep graph
that minimizes total prime trading cost.

## Key results

- **Distance metric**: `irrepDist` is symmetric and equals 0 iff the supports coincide.
- **Prime market statistics**: frequency, weight, scarcity for each of the 15 primes.
- **Greedy TSP heuristic**: nearest-neighbor tour with computed cost.
- **Pattern analysis**: support clusters, Hamming-distance distribution, hub identification.
-/

/-! ## 1. Distance between irreps -/

/-- The **Hamming distance** between two irreps: the number of primes
    in the symmetric difference of their supports.
    This counts primes that must be sold + primes that must be bought. -/
def irrepDist (r s : IrrepData) : ℕ :=
  let sold := r.support.filter (· ∉ s.support)
  let bought := s.support.filter (· ∉ r.support)
  sold.length + bought.length

/-- The **weighted distance**: sum of exponents on sold primes + sum on bought primes.
    A "heavier" transaction costs more. -/
def irrepWeightedDist (r s : IrrepData) : ℕ :=
  let soldWeight := r.profile.filter (fun pe => pe.1 ∉ s.support)
    |>.map Prod.snd |>.sum
  let boughtWeight := s.profile.filter (fun pe => pe.1 ∉ r.support)
    |>.map Prod.snd |>.sum
  soldWeight + boughtWeight

/-- The **exponent-change distance**: total absolute change in exponents
    across all primes in the union support. -/
def irrepL1Dist (r s : IrrepData) : ℕ :=
  let up := unionSupport r s
  up.foldl (fun acc p =>
    let er := lookupExponent r.profile p
    let es := lookupExponent s.profile p
    acc + if er ≥ es then er - es else es - er) 0

/-! ### Distance properties -/

/-- `irrepDist` is symmetric. -/
theorem irrepDist_symm (r s : IrrepData) : irrepDist r s = irrepDist s r := by
  simp [irrepDist]; omega

/-- `irrepDist r r = 0` (every prime is kept, none sold or bought). -/
theorem irrepDist_self (r : IrrepData) : irrepDist r r = 0 := by
  simp only [irrepDist]
  have h1 : (r.support.filter (· ∉ r.support)) = [] := by
    apply List.filter_eq_nil_iff.mpr
    intro x hx; simp; exact hx
  simp [h1]

/-- `irrepWeightedDist` is symmetric. -/
theorem irrepWeightedDist_symm (r s : IrrepData) :
    irrepWeightedDist r s = irrepWeightedDist s r := by
  simp [irrepWeightedDist]; omega

/-! ## 2. Prime Market Statistics -/

/-- **Prime frequency**: how many of the 194 irreps have prime `p` in their support. -/
def primeFrequency (p : ℕ) : ℕ :=
  allIrreps.countP (fun (_, r) => p ∈ r.support)

/-- **Prime total weight**: sum of p-adic exponents of prime `p` across all 194 irreps. -/
def primeTotalWeight (p : ℕ) : ℕ :=
  allIrreps.foldl (fun acc (_, r) => acc + lookupExponent r.profile p) 0

/-- **Prime average weight**: total weight / frequency (scaled by 1000 for integer display). -/
def primeAvgWeight1000 (p : ℕ) : ℕ :=
  let f := primeFrequency p
  if f == 0 then 0 else primeTotalWeight p * 1000 / f

/-- **Scarcity score**: 194 - frequency. Higher means rarer. -/
def primeScarcity (p : ℕ) : ℕ := 194 - primeFrequency p

/-- Full market report for a prime: (prime, frequency, totalWeight, avgWeight×1000, scarcity). -/
def primeMarketReport (p : ℕ) : ℕ × ℕ × ℕ × ℕ × ℕ :=
  (p, primeFrequency p, primeTotalWeight p, primeAvgWeight1000 p, primeScarcity p)

/-- Market report for all 15 primes. -/
def fullMarketReport : List (ℕ × ℕ × ℕ × ℕ × ℕ) :=
  globalPrimes.map primeMarketReport

-- Compute the full market report
#eval fullMarketReport

/-! ### Market classification -/

/-- A prime is a **commodity** if its frequency ≥ 150 (present in >77% of irreps). -/
def isCommodity (p : ℕ) : Bool := primeFrequency p ≥ 150

/-- A prime is **scarce** if its frequency ≤ 50 (present in <26% of irreps). -/
def isScarce (p : ℕ) : Bool := primeFrequency p ≤ 50

/-- A prime is **premium** if it is scarce but has high total weight (≥ 100). -/
def isPremium (p : ℕ) : Bool := isScarce p && (primeTotalWeight p ≥ 100)

/-- Classify all primes into commodity/scarce/premium/standard. -/
def classifyPrimes : List (ℕ × String) :=
  globalPrimes.map fun p =>
    let cls := if isPremium p then "premium"
               else if isScarce p then "scarce"
               else if isCommodity p then "commodity"
               else "standard"
    (p, cls)

#eval classifyPrimes

/-! ## 3. TSP Formulation -/

/-- A **tour** is a permutation of irrep indices representing a visit order. -/
abbrev Tour := List ℕ

/-- Look up an irrep by position in an array. -/
def arrayLookup (irreps : Array (ℕ × IrrepData)) (i : ℕ) : Option (ℕ × IrrepData) :=
  if h : i < irreps.size then some irreps[i] else none

/-- The cost of a tour: sum of distances between consecutive cities,
    plus the return edge from last to first. -/
def tourCost (irreps : Array (ℕ × IrrepData)) (tour : Tour)
    (dist : IrrepData → IrrepData → ℕ) : ℕ :=
  let edges := tour.zip (tour.tail ++ tour.take 1)
  edges.foldl (fun acc (i, j) =>
    match arrayLookup irreps i, arrayLookup irreps j with
    | some (_, ri), some (_, rj) => acc + dist ri rj
    | _, _ => acc) 0

/-- The **greedy nearest-neighbor TSP heuristic**.
    Starting from city `start`, always move to the nearest unvisited city.
    Uses a fuel parameter for termination. -/
def greedyTSP (irreps : Array (ℕ × IrrepData)) (start : ℕ)
    (dist : IrrepData → IrrepData → ℕ) : Tour :=
  let n := irreps.size
  let rec go (fuel : ℕ) (visited : List ℕ) (current : ℕ) : Tour :=
    match fuel with
    | 0 => visited.reverse
    | fuel' + 1 =>
      let candidates := (List.range n).filter (· ∉ visited)
      match candidates with
      | [] => visited.reverse
      | c0 :: cs =>
        let nearest := cs.foldl (fun best c =>
          match arrayLookup irreps current, arrayLookup irreps c, arrayLookup irreps best with
          | some (_, rc), some (_, ri), some (_, rb) =>
            if dist rc ri < dist rc rb then c else best
          | _, _, _ => best) c0
        go fuel' (nearest :: visited) nearest
  go (n - 1) [start] start

/-! ### TSP computations on small subsets -/

-- Use first 20 irreps for demonstration (full 194 would be slow in #eval)
def first20Irreps : Array (ℕ × IrrepData) :=
  (allIrreps.take 20).toArray

-- Greedy tour using Hamming distance
#eval do
  let tour := greedyTSP first20Irreps 0 irrepDist
  let cost := tourCost first20Irreps tour irrepDist
  return (s!"Tour: {tour}", s!"Cost: {cost}")

-- Greedy tour using weighted distance
#eval do
  let tour := greedyTSP first20Irreps 0 irrepWeightedDist
  let cost := tourCost first20Irreps tour irrepWeightedDist
  return (s!"Tour: {tour}", s!"Cost: {cost}")

-- Greedy tour using L1 distance
#eval do
  let tour := greedyTSP first20Irreps 0 irrepL1Dist
  let cost := tourCost first20Irreps tour irrepL1Dist
  return (s!"Tour: {tour}", s!"Cost: {cost}")

/-! ## 4. Pattern Discovery -/

/-! ### 4.1 Support signatures -/

/-- The **support signature** of an irrep: its sorted list of primes. -/
def supportSignature (r : IrrepData) : List ℕ :=
  r.support.mergeSort (· ≤ ·)

/-- Group irreps by support signature. Returns (signature, list of row indices). -/
def irrepsBySupport : List (List ℕ × List ℕ) :=
  let tagged := allIrreps.map fun (idx, r) => (supportSignature r, idx)
  let sigs := tagged.map Prod.fst |>.dedup
  sigs.map fun sig =>
    (sig, tagged.filter (fun (s, _) => s == sig) |>.map Prod.snd)

-- How many distinct support signatures are there?
#eval irrepsBySupport.length

-- Show signatures that contain more than one irrep (clusters)
#eval irrepsBySupport.filter (fun (_, idxs) => idxs.length > 1)
  |>.map (fun (sig, idxs) => (sig.length, idxs.length, idxs))

/-! ### 4.2 Hub identification -/

/-- The **hub score** of an irrep: the number of other irreps whose support
    is a subset of this irrep's support. A high hub score means this irrep's
    CRT space can embed many others. -/
def hubScore (idx : ℕ) (r : IrrepData) : ℕ :=
  allIrreps.countP fun (_, s) =>
    IrrepData.support s |>.all (· ∈ IrrepData.support r)

/-- Top hubs: irreps with the highest hub scores. -/
def topHubs (k : ℕ) : List (ℕ × ℕ × ℕ) :=
  let scored := allIrreps.map fun (idx, r) => (idx, hubScore idx r, r.support.length)
  (scored.mergeSort (fun a b => a.2.1 ≥ b.2.1)).take k

-- Top 10 hub irreps
#eval topHubs 10

/-! ### 4.3 Distance distribution -/

/-- Compute the Hamming distance from a given irrep to all others.
    Returns sorted (distance, target_index) pairs. -/
def distancesFrom (srcIdx : ℕ) : List (ℕ × ℕ) :=
  match allIrreps.find? (fun (i, _) => i == srcIdx) with
  | none => []
  | some (_, src) =>
    allIrreps.filter (fun (i, _) => i ≠ srcIdx)
    |>.map (fun (i, r) => (irrepDist src r, i))
    |>.mergeSort (fun a b => a.1 ≤ b.1)

-- Nearest neighbors of row 1 (the Monster base {47,59,71})
#eval (distancesFrom 1).take 10

-- Nearest neighbors of row 192 (the largest support)
#eval (distancesFrom 192).take 10

/-- Histogram of Hamming distances from a given irrep.
    Returns (distance, count) pairs. -/
def distHistogramFrom (srcIdx : ℕ) : List (ℕ × ℕ) :=
  let dists := distancesFrom srcIdx
  let maxDist := dists.foldl (fun m (d, _) => max m d) 0
  (List.range (maxDist + 1)).filterMap fun d =>
    let cnt := dists.countP (fun (dd, _) => dd == d)
    if cnt > 0 then some (d, cnt) else none

-- Distance histogram from row 1
#eval distHistogramFrom 1

/-! ### 4.4 Prime co-occurrence -/

/-- **Co-occurrence count**: how many irreps have both primes p and q in their support. -/
def primeCooccurrence (p q : ℕ) : ℕ :=
  allIrreps.countP fun (_, r) =>
    (p ∈ IrrepData.support r) && (q ∈ IrrepData.support r)

/-- Co-occurrence matrix for the Monster primes {47, 59, 71}. -/
def monsterCooccurrence : List (ℕ × ℕ × ℕ) :=
  [47, 59, 71].flatMap fun p =>
    [47, 59, 71].map fun q => (p, q, primeCooccurrence p q)

#eval monsterCooccurrence

/-- Co-occurrence matrix for all 15 primes (upper triangle). -/
def fullCooccurrence : List (ℕ × ℕ × ℕ) :=
  globalPrimes.flatMap fun p =>
    (globalPrimes.filter (· ≥ p)).map fun q => (p, q, primeCooccurrence p q)

#eval fullCooccurrence

/-! ### 4.5 Prime correlation with row exponent sum -/

/-- For each prime, compute the average row_exponent_sum of irreps that carry it
    vs those that don't. Returns (prime, avg_with×100, avg_without×100). -/
def primeExponentSumCorrelation : List (ℕ × ℕ × ℕ) :=
  globalPrimes.map fun p =>
    let withP := allIrreps.filter fun (_, r) => p ∈ IrrepData.support r
    let withoutP := allIrreps.filter fun (_, r) => p ∉ IrrepData.support r
    let sumWith := withP.foldl (fun acc (_, r) =>
      acc + (IrrepData.profile r |>.map Prod.snd |>.sum)) 0
    let sumWithout := withoutP.foldl (fun acc (_, r) =>
      acc + (IrrepData.profile r |>.map Prod.snd |>.sum)) 0
    let avgWith := if withP.length > 0 then sumWith * 100 / withP.length else 0
    let avgWithout := if withoutP.length > 0 then sumWithout * 100 / withoutP.length else 0
    (p, avgWith, avgWithout)

#eval primeExponentSumCorrelation

/-! ## 5. Greedy tour analysis -/

/-- Run the greedy TSP from every starting city and return the best tour found.
    For efficiency, only tries first `maxStarts` starting points. -/
def bestGreedyTour (irreps : Array (ℕ × IrrepData)) (maxStarts : ℕ)
    (dist : IrrepData → IrrepData → ℕ) : Tour × ℕ :=
  let starts := List.range (min maxStarts irreps.size)
  starts.foldl (fun (bestTour, bestCost) s =>
    let tour := greedyTSP irreps s dist
    let cost := tourCost irreps tour dist
    if cost < bestCost || bestCost == 0 then (tour, cost) else (bestTour, bestCost))
    ([], 0)

-- Best greedy tour over first 20 irreps, trying all starts
#eval do
  let (tour, cost) := bestGreedyTour first20Irreps 20 irrepDist
  return (s!"Best Hamming tour cost: {cost}", tour)

#eval do
  let (tour, cost) := bestGreedyTour first20Irreps 20 irrepWeightedDist
  return (s!"Best weighted tour cost: {cost}", tour)

/-! ## 6. Trade route analysis -/

/-- For a given tour, compute the "trade manifest" at each step:
    which primes are sold/bought and the associated costs. -/
def tourTradeManifest (irreps : Array (ℕ × IrrepData)) (tour : Tour) :
    List (ℕ × ℕ × List ℕ × List ℕ × ℕ) :=
  let edges := tour.zip (tour.tail ++ tour.take 1)
  edges.filterMap fun (i, j) =>
    match arrayLookup irreps i, arrayLookup irreps j with
    | some (idxI, ri), some (idxJ, rj) =>
      let tx := computeTransaction ri rj
      let cost := irrepDist ri rj
      some (idxI, idxJ, tx.sold, tx.bought.map Prod.fst, cost)
    | _, _ => none

-- Trade manifest for best greedy tour
#eval do
  let (tour, _) := bestGreedyTour first20Irreps 20 irrepDist
  return tourTradeManifest first20Irreps tour

/-- **Prime traffic**: for a given tour, how many times is each prime sold/bought? -/
def primeTourTraffic (irreps : Array (ℕ × IrrepData)) (tour : Tour) :
    List (ℕ × ℕ × ℕ) :=
  let manifest := tourTradeManifest irreps tour
  globalPrimes.map fun p =>
    let sold := manifest.countP fun (_, _, s, _, _) => p ∈ s
    let bought := manifest.countP fun (_, _, _, b, _) => p ∈ b
    (p, sold, bought)

#eval do
  let (tour, _) := bestGreedyTour first20Irreps 20 irrepDist
  return primeTourTraffic first20Irreps tour

/-! ## 7. Formal properties -/

/-
The Hamming distance is 0 iff supports are equal (as sets).
-/
theorem irrepDist_zero_iff_support_eq (r s : IrrepData) :
    irrepDist r s = 0 ↔
    (∀ p ∈ r.support, p ∈ s.support) ∧ (∀ p ∈ s.support, p ∈ r.support) := by
  constructor <;> intro h <;> simp_all +decide [ irrepDist ]

/-- Transaction sell count ≤ source support size. -/
theorem sold_le_support (r s : IrrepData) :
    (computeTransaction r s).sold.length ≤ r.support.length := by
  simp [computeTransaction]
  exact List.length_filter_le _ _

/-- Transaction buy count ≤ target profile size. -/
theorem bought_le_target_support (r s : IrrepData) :
    (computeTransaction r s).bought.length ≤ s.profile.length := by
  simp [computeTransaction]
  exact List.length_filter_le _ _

/-
`irrepL1Dist r r = 0`.
-/
theorem irrepL1Dist_self (r : IrrepData) : irrepL1Dist r r = 0 := by
  -- By definition of `lookupExponent`, we have `lookupExponent r.profile p = lookupExponent r.profile p` for any prime `p`.
  have h_lookup : ∀ p, lookupExponent r.profile p = lookupExponent r.profile p := by
    exact fun _ => rfl;
  convert h_lookup using 1;
  constructor <;> intro h <;> simp_all +decide [ irrepL1Dist ]

/-! ## 8. Summary statistics -/

-- Total number of distinct support signatures
#eval do
  let sigs : List (List ℕ × List ℕ) := irrepsBySupport
  let singles := sigs.filter (fun (p : List ℕ × List ℕ) => p.2.length == 1) |>.length
  let clusters := sigs.filter (fun (p : List ℕ × List ℕ) => p.2.length > 1)
  let clusterSizes := clusters.map (fun (p : List ℕ × List ℕ) => p.2.length)
  return (s!"Total signatures: {sigs.length}",
          s!"Singletons: {singles}",
          s!"Clusters: {clusters.length}",
          s!"Cluster sizes: {clusterSizes}")

-- Support size distribution
#eval do
  let sizes : List ℕ := allIrreps.map fun (p : ℕ × IrrepData) => p.2.support.length
  let maxSize := sizes.foldl max 0
  let dist := (List.range (maxSize + 1)).filterMap fun s =>
    let cnt := sizes.countP (· == s)
    if cnt > 0 then some (s, cnt) else none
  return dist

-- Row 0 (trivial) is the universal hub — everything embeds into it trivially
#eval hubScore 0 (mkIrrepFromExps [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])

-- The "full support" row (if any): which row has the most primes?
#eval do
  let best : ℕ × ℕ := allIrreps.foldl (fun (acc : ℕ × ℕ) (p : ℕ × IrrepData) =>
    let slen := p.2.support.length
    if slen > acc.2 then (p.1, slen) else acc) (0, 0)
  return best