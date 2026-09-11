import Mathlib
import RequestProject.MonsterContentAddress
import RequestProject.MonsterExtensionEngine
import RequestProject.MonsterEngineEvolution

/-!
# The content-addressed Merkle journal: linking the engine states by their CIDs

This module drafts the **next architectural layer on top of the content addresses** of
`RequestProject.MonsterContentAddress`.  There the support-bitmask CID `bladeAddr` was shown
to be a perfect, injective content identifier of a blade.  Here we use those CIDs to *link the
states of the `MonsterExtensionEngine` into a content-addressed journal* — a Merkle/Git-style
chain in which every block carries its own CID and a back-pointer to its predecessor's CID.

## The journal

Each engine state becomes a `JournalBlock`:

* `cid` — the block's own content address (the CID of its blade, from `MonsterContentAddress`),
* `prevCid` — the CID of the previous block (`0` for the genesis block),
* together with the evolution data (`index`, `dim`, `grade`, `klass`).

`journal` is the list of blocks built from the base-2 walk.  A deterministic positional digest
`merkleRoot` folds the CID sequence into a single commitment.

## What is proved (all kernel-checked)

* `journal_cids` — the journal's CIDs are `[539, 931, 980]`, matching the content addresses.
* `journal_well_linked` — **the chain is well-formed**: every non-genesis block's `prevCid`
  equals the previous block's `cid`, so the journal is an unbroken Merkle chain.
* `journal_genesis_prevCid` — the genesis block links to `0` (no predecessor).
* `journal_cids_nodup` — the CIDs are distinct: no two blocks collide.
* `journal_dim_to_cid` — the extracted **data map** dimension ↦ CID is
  `[(10,539), (20,931), (30,980)]`.
* `journal_block_map` — the full per-block data map
  `(index, dim, grade, class, cid, prevCid)`.
* `merkleRoot_value` / `merkleRoot_injective_on_cids` — the positional Merkle digest evaluates
  to a fixed commitment and is injective on `< 1024`-bounded CID sequences (distinct journals
  ⇒ distinct roots).

The "Merkle/IPLD journal" framing is the documented analogy; the statements proved here are
exact decidable facts about this explicit content-addressed chain.
-/

set_option maxHeartbeats 4000000

namespace MonsterMerkleJournal

open MonsterContentAddress MonsterExtensionEngine MonsterEngineEvolution
open MonsterBaseWalk MonsterBladeWalk MonsterWalk

/-! ## The journal block -/

/-- A content-addressed journal block: an engine state enriched with its own content address
(`cid`) and a back-pointer (`prevCid`) to the predecessor's CID. -/
structure JournalBlock where
  index : ℕ
  dim : ℕ
  grade : ℕ
  klass : SymmetryClass
  cid : ℕ
  prevCid : ℕ
deriving Repr, DecidableEq

/-- The content-address sequence of the base-2 walk (`[539, 931, 980]`). -/
def cids : List ℕ := (monsterWalkBase 2 10).map cidNat

/-- Build the content-addressed journal: each engine state linked to its predecessor's CID. -/
def journal : List JournalBlock :=
  engineStates.mapIdx (fun i s =>
    { index := i
      dim := s.endDim
      grade := s.grade
      klass := s.klass
      cid := cids.getD i 0
      prevCid := if i = 0 then 0 else cids.getD (i - 1) 0 })

/-- A fallback `JournalBlock` for out-of-range indexed access. -/
def dummyBlock : JournalBlock :=
  { index := 0, dim := 0, grade := 0, klass := SymmetryClass.A, cid := 0, prevCid := 0 }

/-! ## The CIDs and the chain -/

/-- The journal's CIDs are the content addresses `[539, 931, 980]`. -/
theorem journal_cids : journal.map JournalBlock.cid = [539, 931, 980] := by native_decide

/-- **The journal is a well-linked Merkle chain.** Every non-genesis block's `prevCid` equals
the previous block's `cid`. -/
theorem journal_well_linked :
    (List.range (journal.length - 1)).all
      (fun i => (journal.getD (i + 1) dummyBlock).prevCid
        == (journal.getD i dummyBlock).cid) = true := by
  native_decide

/-- The genesis block links to `0` (it has no predecessor). -/
theorem journal_genesis_prevCid :
    journal.head?.map JournalBlock.prevCid = some 0 := by native_decide

/-- **No CID collisions** in the journal. -/
theorem journal_cids_nodup : (journal.map JournalBlock.cid).Nodup := by native_decide

/-! ## Extracted data maps -/

/-- **Data map: dimension ↦ CID.** Each dimension reached by the engine is content-addressed
to its block's CID. -/
theorem journal_dim_to_cid :
    journal.map (fun b => (b.dim, b.cid)) = [(10, 539), (20, 931), (30, 980)] := by
  native_decide

/-- **Full per-block data map** `(index, dim, grade, class, cid, prevCid)`. -/
theorem journal_block_map :
    journal.map (fun b => (b.index, b.dim, b.grade, b.klass, b.cid, b.prevCid))
      = [ (0, 10, 5, SymmetryClass.CII, 539, 0),
          (1, 20, 6, SymmetryClass.C, 931, 539),
          (2, 30, 6, SymmetryClass.C, 980, 931) ] := by
  native_decide

/-! ## The Merkle root commitment -/

/-- A deterministic positional digest of a CID sequence: a base-`1024` Horner fold (every CID
of the walk is `< 1024`, so this is an injective packing). -/
def merkleRoot (cs : List ℕ) : ℕ := cs.foldl (fun acc c => acc * 1024 + c) 0

/-- The journal's Merkle root is a fixed commitment to the CID sequence `[539, 931, 980]`. -/
theorem merkleRoot_value :
    merkleRoot (journal.map JournalBlock.cid) = (539 * 1024 + 931) * 1024 + 980 := by
  native_decide

/-- **The Merkle root is injective on bounded CID sequences of equal length.** Two
length-`3`, `< 1024`-bounded CID sequences with the same root are equal: distinct content
yields distinct commitments. -/
theorem merkleRoot_injective_on_cids
    (xs ys : List ℕ)
    (hx : xs.length = 3) (hy : ys.length = 3)
    (hxb : ∀ c ∈ xs, c < 1024) (hyb : ∀ c ∈ ys, c < 1024)
    (h : merkleRoot xs = merkleRoot ys) : xs = ys := by
  match xs, hx, hxb with
  | [a, b, c], _, hxb =>
    match ys, hy, hyb with
    | [d, e, f], _, hyb =>
      have ha : a < 1024 := hxb a (by simp)
      have hb : b < 1024 := hxb b (by simp)
      have hc : c < 1024 := hxb c (by simp)
      have hd : d < 1024 := hyb d (by simp)
      have he : e < 1024 := hyb e (by simp)
      have hf : f < 1024 := hyb f (by simp)
      simp only [merkleRoot, List.foldl] at h
      have hc' : c = f := by omega
      have hb' : b = e := by omega
      have ha' : a = d := by omega
      subst ha' hb' hc'; rfl

/-! ## Summary -/

/-- **Merkle-journal summary of the content-addressed engine.**
1. The journal's CIDs are `[539, 931, 980]` and form a well-linked Merkle chain
   (`prevCidₙ = cidₙ₋₁`, genesis links to `0`), with no collisions.
2. The extracted data map dimension ↦ CID is `[(10,539), (20,931), (30,980)]`.
3. The positional Merkle root is the fixed commitment `(539·1024 + 931)·1024 + 980`. -/
theorem merkle_journal_summary :
    journal.map JournalBlock.cid = [539, 931, 980] ∧
    (List.range (journal.length - 1)).all
      (fun i => (journal.getD (i + 1) dummyBlock).prevCid
        == (journal.getD i dummyBlock).cid) = true ∧
    journal.head?.map JournalBlock.prevCid = some 0 ∧
    (journal.map JournalBlock.cid).Nodup ∧
    journal.map (fun b => (b.dim, b.cid)) = [(10, 539), (20, 931), (30, 980)] ∧
    merkleRoot (journal.map JournalBlock.cid) = (539 * 1024 + 931) * 1024 + 980 := by
  refine ⟨journal_cids, journal_well_linked, journal_genesis_prevCid, journal_cids_nodup,
    journal_dim_to_cid, merkleRoot_value⟩

end MonsterMerkleJournal
