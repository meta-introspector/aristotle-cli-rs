import Mathlib
import RequestProject.IrrepCRT
import RequestProject.IrrepRows

/-!
# CRT Walks Between Irreps

Each irrep lives in its own CRT torus determined by its prime support.
A **CRT walk** is a sequence of steps that transforms one irrep's CRT
coordinate into another's by "selling" some primes (setting their exponents
to 0) and "buying" others (giving them nonzero exponents).

For example, going from irrep 1 (support {47,59,71}) to irrep 2
(support {2,31,41,59,71}):
- **Sell** prime 47 (exponent 1 → 0)
- **Buy** primes {2,31,41} (exponents 0 → {2,1,1})
- **Keep** primes {59,71} (exponents stay at {1,1})

At each step, both source and target are embedded in their union CRT space,
so the transformation is a well-defined map in ℤ/M_union.
-/

/-! ## CRT Transactions -/

/-- A CRT transaction describes how to go from one irrep to another.
    It records which primes are sold (removed), bought (added),
    and kept (with possibly changed exponents). -/
structure CRTTransaction where
  /-- Primes sold (present in source, absent in target) -/
  sold : List ℕ
  /-- Primes bought with their new exponents (absent in source, present in target) -/
  bought : List (ℕ × ℕ)
  /-- Primes kept with their new exponents (present in both) -/
  kept : List (ℕ × ℕ)
  deriving Repr, DecidableEq

/-- Compute the transaction to go from irrep r to irrep s. -/
def computeTransaction (r s : IrrepData) : CRTTransaction :=
  let sold := r.support.filter (· ∉ s.support)
  let bought := s.profile.filter (fun pe => pe.1 ∉ r.support)
  let kept := s.profile.filter (fun pe => pe.1 ∈ r.support)
  { sold := sold, bought := bought, kept := kept }

/-! ## CRT Walk Steps -/

/-- A single step in a CRT walk: go from one irrep to another.
    Contains all the CRT data needed to understand the transformation. -/
structure CRTStep where
  /-- Source irrep index -/
  srcIdx : ℕ
  /-- Target irrep index -/
  tgtIdx : ℕ
  /-- The transaction (derived from src and tgt) -/
  transaction : CRTTransaction
  /-- Union primes of src and tgt (sorted) -/
  unionPrimes : List ℕ
  /-- Union modulus -/
  unionMod : ℕ
  /-- Source CRT coordinate in the union space -/
  srcCoord : ℕ
  /-- Target CRT coordinate in the union space -/
  tgtCoord : ℕ
  /-- The "delta": target - source in the union space -/
  delta : Int
  deriving Repr

/-- Build a CRT step from two irreps. -/
def mkCRTStep (srcIdx tgtIdx : ℕ) (src tgt : IrrepData) : CRTStep :=
  let up := (unionSupport src tgt).mergeSort (· ≤ ·)
  let um := up.prod
  let sc := embedCRTCoord src up
  let tc := embedCRTCoord tgt up
  let d := (tc : Int) - (sc : Int)
  { srcIdx := srcIdx
    tgtIdx := tgtIdx
    transaction := computeTransaction src tgt
    unionPrimes := up
    unionMod := um
    srcCoord := sc
    tgtCoord := tc
    delta := d }

/-! ## CRT Walks -/

/-- A CRT walk is a sequence of steps through a list of irreps. -/
def CRTWalk := List CRTStep

/-- Build a CRT walk from a list of (index, irrep) waypoints. -/
def mkCRTWalk : List (ℕ × IrrepData) → CRTWalk
  | [] => []
  | [_] => []
  | (i₁, r₁) :: (i₂, r₂) :: rest =>
    mkCRTStep i₁ i₂ r₁ r₂ :: mkCRTWalk ((i₂, r₂) :: rest)

/-- Summarize a CRT walk for display. -/
def summarizeWalk (walk : CRTWalk) : List (ℕ × ℕ × List ℕ × List (ℕ × ℕ) × ℕ × ℕ × Int) :=
  walk.map fun step =>
    (step.srcIdx, step.tgtIdx, step.transaction.sold, step.transaction.bought,
     step.srcCoord, step.tgtCoord, step.delta)

/-! ## Applying a transaction: verifying the transformation -/

/-- Apply a transaction to a source profile to produce the target profile.
    This removes sold primes, adds bought primes, and updates kept primes. -/
def applyTransaction (srcProfile : List (ℕ × ℕ)) (tx : CRTTransaction) :
    List (ℕ × ℕ) :=
  let afterSell := srcProfile.filter (fun pe => pe.1 ∉ tx.sold)
  let afterUpdate := afterSell.map (fun pe =>
    match tx.kept.find? (fun k => k.1 == pe.1) with
    | some (_, newExp) => (pe.1, newExp)
    | none => pe)
  afterUpdate ++ tx.bought

/-- Verify that applying the transaction to src's profile yields tgt's profile
    (up to ordering). -/
def verifyTransaction (src tgt : IrrepData) : Bool :=
  let tx := computeTransaction src tgt
  let result := applyTransaction src.profile tx
  let resultSorted := result.mergeSort (fun a b => a.1 ≤ b.1)
  let tgtSorted := tgt.profile.mergeSort (fun a b => a.1 ≤ b.1)
  resultSorted == tgtSorted

/-! ## Helper: find index of element in list -/

/-- Find the index of the first occurrence of `x` in `xs`, or `xs.length` if not found. -/
def listFindIdx [DecidableEq α] (x : α) (xs : List α) : ℕ :=
  match xs with
  | [] => 0
  | y :: ys => if x == y then 0 else 1 + listFindIdx x ys

/-! ## Walk coherence: the CRT delta decomposes into sell/buy contributions -/

/-- The "sell contribution" of a transaction step: how much the CRT coordinate
    changes due to selling primes. This is the negative of the sold primes'
    idempotent-weighted exponents in the union space. -/
def sellContribution (src : IrrepData) (step : CRTStep) : Int :=
  let up := step.unionPrimes
  if step.unionMod == 0 then 0 else
  step.transaction.sold.foldl (fun acc p =>
    let exp := lookupExponent src.profile p
    let idx := listFindIdx p up
    if h : idx < up.length then
      let eid := crtIdempotentVal up ⟨idx, h⟩
      acc - (exp * eid : ℕ)
    else acc) 0

/-- The "buy contribution": how much the CRT coordinate changes due to
    buying primes. -/
def buyContribution (step : CRTStep) : Int :=
  let up := step.unionPrimes
  if step.unionMod == 0 then 0 else
  step.transaction.bought.foldl (fun acc ⟨p, exp⟩ =>
    let idx := listFindIdx p up
    if h : idx < up.length then
      let eid := crtIdempotentVal up ⟨idx, h⟩
      acc + (exp * eid : ℕ)
    else acc) 0

/-- The "keep contribution": how much the CRT coordinate changes due to
    exponent changes on kept primes. -/
def keepContribution (src : IrrepData) (step : CRTStep) : Int :=
  let up := step.unionPrimes
  if step.unionMod == 0 then 0 else
  step.transaction.kept.foldl (fun acc ⟨p, newExp⟩ =>
    let oldExp := lookupExponent src.profile p
    let idx := listFindIdx p up
    if h : idx < up.length then
      let eid := crtIdempotentVal up ⟨idx, h⟩
      acc + ((newExp : Int) - (oldExp : Int)) * (eid : Int)
    else acc) 0

/-! ## Concrete examples -/

-- Row 1 and Row 2 data
def walk_row1 : IrrepData := mkIrrepFromExps [0,0,0,0,0,0,0,0,0,0,0,0,1,1,1]
def walk_row2 : IrrepData := mkIrrepFromExps [2,0,0,0,0,0,0,0,0,0,1,1,0,1,1]

/-! ### Example: Irrep 1 → Irrep 2

Row 1: support = {47, 59, 71}, exponents = [1, 1, 1]
Row 2: support = {2, 31, 41, 59, 71}, exponents = [2, 1, 1, 1, 1]

Transaction: sell {47}, buy {(2,2), (31,1), (41,1)}, keep {(59,1), (71,1)}
-/

-- Compute the transaction
#eval computeTransaction walk_row1 walk_row2

-- Build and display the step
#eval (mkCRTStep 1 2 walk_row1 walk_row2 : CRTStep)

-- Verify the transaction reconstructs the target
#eval verifyTransaction walk_row1 walk_row2

/-! ### Example: A 3-step walk through irreps 1 → 2 → 3 → 4 -/

def walk_row3 : IrrepData := mkIrrepFromExps [1,0,0,0,0,2,0,0,0,1,1,0,1,1,0]
def walk_row4 : IrrepData := mkIrrepFromExps [2,0,0,1,1,0,0,0,1,1,1,1,0,0,1]

-- Build the full walk
#eval do
  let walk := mkCRTWalk [(1, walk_row1), (2, walk_row2), (3, walk_row3), (4, walk_row4)]
  return (summarizeWalk walk)

-- Verify all transactions along the walk
#eval do
  let pairs := [(walk_row1, walk_row2), (walk_row2, walk_row3), (walk_row3, walk_row4)]
  return pairs.map (fun (r, s) => verifyTransaction r s)

/-! ### Sell/buy decomposition of the delta -/

#eval do
  let step := mkCRTStep 1 2 walk_row1 walk_row2
  let sc := sellContribution walk_row1 step
  let bc := buyContribution step
  let kc := keepContribution walk_row1 step
  return (s!"delta = {step.delta}, sell = {sc}, buy = {bc}, keep = {kc}, " ++
         s!"sell+buy+keep = {sc + bc + kc}")

/-! ### Walk through the first 10 irreps -/

#eval do
  let first10 := (allIrreps.take 10)
  let walk := mkCRTWalk first10
  return walk.map fun (step : CRTStep) =>
    (step.srcIdx, step.tgtIdx,
     step.transaction.sold.length,
     step.transaction.bought.length,
     step.delta)

/-! ## Formal properties -/

/-- The sold primes of a transaction are exactly those in the source
    support but not in the target support. -/
theorem sold_primes_correct (r s : IrrepData) :
    (computeTransaction r s).sold = r.support.filter (· ∉ s.support) := by
  rfl

/-- The bought primes of a transaction are exactly those in the target
    profile but not in the source support. -/
theorem bought_primes_correct (r s : IrrepData) :
    (computeTransaction r s).bought = s.profile.filter (fun pe => pe.1 ∉ r.support) := by
  rfl

/-- The kept primes are those in the target profile that are also in
    the source support. -/
theorem kept_primes_correct (r s : IrrepData) :
    (computeTransaction r s).kept = s.profile.filter (fun pe => pe.1 ∈ r.support) := by
  rfl

/-- The sold primes are all in the source support. -/
theorem sold_in_source (r s : IrrepData) (p : ℕ)
    (hp : p ∈ (computeTransaction r s).sold) :
    p ∈ r.support := by
  simp [computeTransaction] at hp
  exact hp.1

/-- The sold primes are disjoint from the target support. -/
theorem sold_not_in_target (r s : IrrepData) (p : ℕ)
    (hp : p ∈ (computeTransaction r s).sold) :
    p ∉ s.support := by
  simp [computeTransaction] at hp
  exact hp.2

/-- The bought primes are disjoint from the source support. -/
theorem bought_not_in_source (r s : IrrepData) (pe : ℕ × ℕ)
    (hp : pe ∈ (computeTransaction r s).bought) :
    pe.1 ∉ r.support := by
  simp [computeTransaction] at hp
  exact hp.2

/-- The sold primes are all in the union support. -/
theorem sold_in_union (r s : IrrepData) (p : ℕ) (hp : p ∈ (computeTransaction r s).sold) :
    p ∈ unionSupport r s := by
  have h := sold_in_source r s p hp
  simp [unionSupport, List.mem_dedup]
  exact Or.inl h

/-- The kept primes are in the source support. -/
theorem kept_in_source (r s : IrrepData) (pe : ℕ × ℕ)
    (hp : pe ∈ (computeTransaction r s).kept) :
    pe.1 ∈ r.support := by
  simp [computeTransaction] at hp
  exact hp.2

/-! ## Walk composition: embedding in a global space -/

/-- Embed a walk's entire sequence of irreps into a single global CRT space
    (the union of all supports along the walk). -/
def walkGlobalPrimes (walk : CRTWalk) : List ℕ :=
  let allPrimes := walk.foldl (fun acc step =>
    acc ++ step.unionPrimes) []
  allPrimes.dedup.mergeSort (· ≤ ·)

/-- Compute global CRT coordinates for all waypoints along a walk. -/
def walkGlobalCoords (waypoints : List (ℕ × IrrepData)) : List (ℕ × ℕ) :=
  let allSupports := waypoints.foldl (fun acc (_, r) => acc ++ r.support) []
  let gp := allSupports.dedup.mergeSort (· ≤ ·)
  waypoints.map fun (idx, r) => (idx, embedCRTCoord r gp)

-- Example: global coordinates for first 5 irreps
#eval walkGlobalCoords (allIrreps.take 5)

-- Walk through irreps 1→2→3→4 in the global space
#eval do
  let wps := [(1, walk_row1), (2, walk_row2), (3, walk_row3), (4, walk_row4)]
  let globalCoords := walkGlobalCoords wps
  let gp := (wps.foldl (fun acc (_, r) => acc ++ r.support) []).dedup.mergeSort (· ≤ ·)
  return (gp, globalCoords)

/-! ## Walk statistics -/

/-- Count total primes sold and bought along a walk. -/
def walkTradeStats (walk : CRTWalk) : ℕ × ℕ :=
  walk.foldl (fun (sold, bought) step =>
    (sold + step.transaction.sold.length,
     bought + step.transaction.bought.length)) (0, 0)

-- Trade stats for a sample walk
#eval do
  let walk := mkCRTWalk [(1, walk_row1), (2, walk_row2), (3, walk_row3), (4, walk_row4)]
  return walkTradeStats walk
