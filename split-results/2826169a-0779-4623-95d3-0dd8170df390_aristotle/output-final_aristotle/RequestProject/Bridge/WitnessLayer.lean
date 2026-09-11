/-
# Geometric Witness Process — Coverage as Recursive Lattice Sections

This module formalizes the idea that each fuzz run (AFL coverage bitmap)
is a **witness section** in a graded lattice of behaviors, and that the
folding process from sections to witness layers is **monotone** — coverage
can only grow.

## What we prove

1. **`foldWitness_monotone`**: Folding a new section into a witness layer
   produces a layer that is ≥ the original (coverage only grows).

2. **`foldChain_monotone`**: A sequence of fuzz runs produces a
   monotonically non-decreasing chain of witness layers.

3. **`witnessLayer_le_refl`** / **`witnessLayer_le_trans`**: The
   refinement ordering on witness layers is a preorder.
-/

import RequestProject.Compute.IPLD.IPLDCodec

namespace IPLD.Witness

-- ============================================================================
-- § 1  Coverage bitmap — the fundamental stalk
-- ============================================================================

/-- A coverage bitmap models AFL's shared-memory coverage map.
    Each bit records whether a particular edge/block/path was exercised.
    All bitmaps in a session share the same fixed `size`. -/
structure CoverageBitmap where
  /-- The coverage vector. `true` = edge exercised. -/
  bits : List Bool
  deriving BEq, Inhabited, Repr

/-- The number of edges covered (popcount). -/
def CoverageBitmap.popcount (bm : CoverageBitmap) : Nat :=
  bm.bits.filter id |>.length

/-- Pointwise OR of two bitmaps — merging coverage.
    If one is shorter, the tail of the longer is preserved. -/
def CoverageBitmap.merge (a b : CoverageBitmap) : CoverageBitmap :=
  ⟨go a.bits b.bits⟩
where
  go : List Bool → List Bool → List Bool
  | [], bs => bs
  | as, [] => as
  | a :: as, b :: bs => (a || b) :: go as bs

/-- A bitmap `a` is covered by `b` if every bit set in `a` is also set in `b`. -/
def CoverageBitmap.le (a b : CoverageBitmap) : Prop :=
  ∀ (i : Nat), a.bits[i]? = some true → b.bits[i]? = some true

instance : LE CoverageBitmap := ⟨CoverageBitmap.le⟩

theorem CoverageBitmap.le_refl (a : CoverageBitmap) : a ≤ a := by
  intro i h; exact h

theorem CoverageBitmap.le_trans {a b c : CoverageBitmap}
    (hab : a ≤ b) (hbc : b ≤ c) : a ≤ c := by
  intro i h; exact hbc i (hab i h)

-- ============================================================================
-- § 2  Sheaf section — unified coverage over program locations
-- ============================================================================

/-- A sheaf section assigns coverage data to each program location. -/
structure SheafSection where
  /-- The accumulated coverage bitmap (union of all edge hits). -/
  coverage : CoverageBitmap
  /-- A unique identifier for this fuzz run / witness. -/
  runId : Nat
  /-- Optional: the input that produced this coverage. -/
  inputHash : Nat := 0
  deriving BEq, Inhabited, Repr

-- ============================================================================
-- § 3  Witness layer — graded accumulation of coverage witnesses
-- ============================================================================

/-- A `WitnessLayer` represents the accumulated coverage
    knowledge after several rounds of fuzzing / witness generation. -/
structure WitnessLayer where
  /-- The lattice grade (number of fold steps). -/
  grade : Nat
  /-- The merged coverage bitmap (union of all witnesses). -/
  accumulated : CoverageBitmap
  /-- The number of distinct witnesses (fuzz runs) incorporated. -/
  witnessCount : Nat
  deriving BEq, Inhabited, Repr

/-- A witness layer `a` is refined by `b` if `b`'s accumulated coverage
    subsumes `a`'s. -/
def WitnessLayer.le (a b : WitnessLayer) : Prop :=
  a.accumulated ≤ b.accumulated

instance : LE WitnessLayer := ⟨WitnessLayer.le⟩

/-- The initial (empty) witness layer at grade 0. -/
def WitnessLayer.empty (size : Nat) : WitnessLayer :=
  { grade := 0
    accumulated := ⟨List.replicate size false⟩
    witnessCount := 0 }

-- ============================================================================
-- § 4  The fold operation — incorporating a new witness
-- ============================================================================

/-- Fold a new `SheafSection` into a `WitnessLayer`, producing a
    refined layer at the next grade. -/
def foldWitness (sec : SheafSection) (layer : WitnessLayer) : WitnessLayer :=
  { grade := layer.grade + 1
    accumulated := CoverageBitmap.merge layer.accumulated sec.coverage
    witnessCount := layer.witnessCount + 1 }

-- ============================================================================
-- § 5  Monotonicity proof — coverage only grows
-- ============================================================================

private theorem merge_go_preserves :
    ∀ (as bs : List Bool) (i : Nat),
    as[i]? = some true → (CoverageBitmap.merge.go as bs)[i]? = some true := by
  intro as bs i
  revert as bs
  induction i with
  | zero =>
    intro as bs h
    cases as with
    | nil => simp at h
    | cons a as =>
      simp at h
      cases bs with
      | nil => simp [CoverageBitmap.merge.go, h]
      | cons b bs => simp [CoverageBitmap.merge.go, h]
  | succ n ih =>
    intro as bs h
    cases as with
    | nil => simp at h
    | cons a as =>
      simp at h
      cases bs with
      | nil => simp [CoverageBitmap.merge.go]; exact h
      | cons b bs => simp [CoverageBitmap.merge.go]; exact ih as bs h

/-- OR-merge is monotone on the left: `a ≤ merge a b`. -/
theorem merge_le_left (a b : CoverageBitmap) : a ≤ CoverageBitmap.merge a b := by
  intro i h
  simp [CoverageBitmap.merge]
  exact merge_go_preserves a.bits b.bits i h

/-- **Main theorem**: Folding a new section into a witness layer
    produces a layer that refines (≥) the original. -/
theorem foldWitness_monotone (sec : SheafSection) (layer : WitnessLayer) :
    layer ≤ foldWitness sec layer := by
  show layer.accumulated ≤ (foldWitness sec layer).accumulated
  simp only [foldWitness]
  exact merge_le_left layer.accumulated sec.coverage

/-- The refinement relation on witness layers is reflexive. -/
theorem witnessLayer_le_refl (a : WitnessLayer) : a ≤ a :=
  CoverageBitmap.le_refl a.accumulated

/-- The refinement relation on witness layers is transitive. -/
theorem witnessLayer_le_trans {a b c : WitnessLayer}
    (hab : a ≤ b) (hbc : b ≤ c) : a ≤ c :=
  CoverageBitmap.le_trans hab hbc

-- ============================================================================
-- § 6  Fold chains — sequences of fuzz runs
-- ============================================================================

/-- Fold a sequence of sections into an initial witness layer. -/
def foldChain (sections : List SheafSection) (init : WitnessLayer) : WitnessLayer :=
  sections.foldl (fun layer sec => foldWitness sec layer) init

/-- **Chain monotonicity**: folding any chain of sections
    produces a layer that refines the initial layer. -/
theorem foldChain_monotone (sections : List SheafSection) (init : WitnessLayer) :
    init ≤ foldChain sections init := by
  induction sections generalizing init with
  | nil => exact witnessLayer_le_refl init
  | cons s ss ih =>
    simp only [foldChain, List.foldl]
    exact witnessLayer_le_trans (foldWitness_monotone s init) (ih (foldWitness s init))

-- ============================================================================
-- § 7  Grade structure
-- ============================================================================

/-- The grade of a folded chain equals the initial grade plus the chain length. -/
theorem foldChain_grade (sections : List SheafSection) (init : WitnessLayer) :
    (foldChain sections init).grade = init.grade + sections.length := by
  induction sections generalizing init with
  | nil => simp [foldChain]
  | cons s ss ih =>
    simp only [foldChain, List.foldl, List.length_cons]
    have := ih (foldWitness s init)
    simp only [foldChain] at this
    rw [this]; simp [foldWitness]; omega

/-- The witness count of a folded chain equals the initial count plus the chain length. -/
theorem foldChain_witnessCount (sections : List SheafSection) (init : WitnessLayer) :
    (foldChain sections init).witnessCount = init.witnessCount + sections.length := by
  induction sections generalizing init with
  | nil => simp [foldChain]
  | cons s ss ih =>
    simp only [foldChain, List.foldl, List.length_cons]
    have := ih (foldWitness s init)
    simp only [foldChain] at this
    rw [this]; simp [foldWitness]; omega

-- ============================================================================
-- § 8  Connecting to IPLD — witness serialization
-- ============================================================================

/-- Encode a `WitnessLayer` as an `IPLDNode` for content-addressed storage. -/
def WitnessLayer.toIPLDNode (wl : WitnessLayer) : IPLDNode :=
  .map [
    ("grade", .int wl.grade),
    ("witnessCount", .int wl.witnessCount),
    ("accumulated", .list (wl.accumulated.bits.map fun b => .bool b))
  ]

/-- Decode a `WitnessLayer` from an `IPLDNode`. -/
def WitnessLayer.fromIPLDNode : IPLDNode → Option WitnessLayer
  | .map kvs => do
    let gradeNode ← (kvs.find? (·.1 == "grade")).map (·.2)
    let countNode ← (kvs.find? (·.1 == "witnessCount")).map (·.2)
    let accNode ← (kvs.find? (·.1 == "accumulated")).map (·.2)
    match gradeNode, countNode, accNode with
    | .int g, .int c, .list bits =>
      let boolBits := bits.filterMap fun
        | .bool b => some b
        | _ => none
      some { grade := g.toNat, accumulated := ⟨boolBits⟩, witnessCount := c.toNat }
    | _, _, _ => none
  | _ => none

-- ============================================================================
-- § 9  Bott periodicity
-- ============================================================================

/-- The **Bott phase** of a witness layer — its grade modulo 8. -/
def WitnessLayer.bottPhase (wl : WitnessLayer) : Fin 8 :=
  ⟨wl.grade % 8, Nat.mod_lt _ (by omega)⟩

/-- The Bott phase cycles with period 8 through foldWitness operations. -/
theorem foldWitness_bottPhase_cycle (s : SheafSection) (wl : WitnessLayer) :
    (foldWitness s wl).bottPhase = ⟨(wl.grade + 1) % 8, Nat.mod_lt _ (by omega)⟩ := by
  simp [foldWitness, WitnessLayer.bottPhase]

end IPLD.Witness
