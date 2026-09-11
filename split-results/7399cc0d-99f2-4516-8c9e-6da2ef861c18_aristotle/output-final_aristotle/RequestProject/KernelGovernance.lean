/-
# RequestProject/KernelGovernance.lean
## Kernel-Level Governance: Datasets as Fibers, Proof-Carrying Inserts, ACL Layer

This file extends GovernanceInvariant.lean with the legislative model:

§11. Dataset = Fiber — a dataset is the set of all blocks projecting to a fiber
§12. Proof-Carrying Insertion — every element must prove its address
§13. ACL Layer — the Senate, sits above the mathematical Committee
§14. Two-Layer Admission — Committee (math) then Senate (policy)
§15. Kernel API — the memory manager as a shape-constrained store
§16. No Contamination — cross-dataset contamination is impossible
§17. Unified Rule — the final theorem

Legislative model:
  1. Propose bill → construct block + CID
  2. Committee check → Congruent(c,b) ∧ blockToBase(b) = dataset_fiber
  3. If and only if 2 holds → bill becomes admissible "proposed senate bill"
  4. Senate vote → ACL policy decides Allow/Deny

  No committee pass ⇒ the Senate literally cannot see it.
-/
import Mathlib
import RequestProject.GovernanceInvariant

set_option maxHeartbeats 800000

open GovernanceInvariant

namespace KernelGovernance

/-! ## §11. Dataset = Fiber

A dataset is a fiber in the Monster torus:
  Dataset(F) := { b | blockToBase(b) = F }

This gives perfect partitioning, determinism, reproducibility,
and addressability.
-/

/-- A dataset is identified by its fiber coordinates in the CRT torus.
    Every block in the dataset must project to this fiber. -/
structure Dataset where
  /-- The fiber that defines this dataset. -/
  fiber : Base
  deriving DecidableEq

@[ext] theorem Dataset.ext {d₁ d₂ : Dataset} (h : d₁.fiber = d₂.fiber) :
    d₁ = d₂ := by cases d₁; cases d₂; simp at h; exact congrArg _ h

/-- A block belongs to a dataset iff it projects to the dataset's fiber. -/
def Dataset.contains (ds : Dataset) (b : Block) : Prop :=
  blockToBase b = ds.fiber

instance (ds : Dataset) (b : Block) : Decidable (ds.contains b) := by
  unfold Dataset.contains blockToBase digestToBase
  infer_instance

noncomputable instance : Fintype Dataset :=
  Fintype.ofEquiv Base
    { toFun := Dataset.mk
      invFun := Dataset.fiber
      left_inv := fun _ => rfl
      right_inv := fun ⟨_⟩ => rfl }

/-- The total number of possible datasets equals the Monster's
    smallest faithful representation dimension. -/
theorem dataset_count : Fintype.card Dataset = 196883 := by
  have : Fintype.card Dataset = Fintype.card Base :=
    Fintype.card_congr ⟨Dataset.fiber, Dataset.mk, fun ⟨_⟩ => rfl, fun _ => rfl⟩
  rw [this, base_card]

/-- Two blocks in the same dataset have the same CRT projection. -/
theorem same_dataset_same_fiber (ds : Dataset) (b₁ b₂ : Block)
    (h₁ : ds.contains b₁) (h₂ : ds.contains b₂) :
    blockToBase b₁ = blockToBase b₂ := by
  rw [Dataset.contains] at h₁ h₂; rw [h₁, h₂]

/-- Every block belongs to exactly one dataset. -/
theorem block_unique_dataset (b : Block) :
    ∃! ds : Dataset, ds.contains b :=
  ⟨⟨blockToBase b⟩, rfl, fun _ds h => Dataset.ext h.symm⟩

/-! ## §12. Proof-Carrying Insertion

To insert a block `b` into dataset `F`, you must provide:
- The block
- The CID
- A proof that cidToBase(c) = blockToBase(b) = F

No proof → no insertion. Wrong fiber → rejection.

This is the Committee: only mathematically valid bills proceed.
-/

/-- A proof-carrying insert: the block, its CID, and the proof
    that both project to the target dataset's fiber.
    This is a "committee-approved bill." -/
structure ProofCarryingInsert where
  /-- The target dataset. -/
  target      : Dataset
  /-- The block to insert. -/
  block       : Block
  /-- The CID declaring the block's identity. -/
  cid         : CID
  /-- Proof: the block projects to the target fiber. -/
  blockInFiber : blockToBase block = target.fiber
  /-- Proof: the CID is congruent with the block. -/
  congruence  : Congruent cid block

/-- A proof-carrying insert guarantees the CID also lives in the fiber. -/
theorem insert_cid_in_fiber (ins : ProofCarryingInsert) :
    cidToBase ins.cid = ins.target.fiber := by
  rw [ins.congruence, ins.blockInFiber]

/-- A proof-carrying insert guarantees dataset membership. -/
theorem insert_establishes_membership (ins : ProofCarryingInsert) :
    ins.target.contains ins.block :=
  ins.blockInFiber

/-- Constructing a committee-approved bill from congruence
    and fiber membership. -/
def ProofCarryingInsert.mk' (ds : Dataset) (c : CID) (b : Block)
    (hcong : Congruent c b) (hfiber : blockToBase b = ds.fiber) :
    ProofCarryingInsert :=
  ⟨ds, b, c, hfiber, hcong⟩

/-! ## §13. ACL Layer — The Senate

The Senate (ACL) sits above the Committee (CRT congruence).
It can only restrict, never extend, the set of admitted blocks.

The Senate never has to worry about:
- tampering, malformed objects, incoherent state,
  cross-dataset contamination, spoofed identities
Because the Committee already forbids all of that.

No committee pass ⇒ the Senate literally cannot see it.
-/

/-- A principal is identified by a CID — its content-addressed identity. -/
structure Principal where
  identity : CID
  deriving DecidableEq

/-- A resource is a (fiber, CID) pair — a block in a dataset. -/
structure Resource where
  dataset  : Dataset
  blockCid : CID
  deriving DecidableEq

/-- An action is a block-encoded verb. -/
inductive Action where
  | read
  | write
  | delete
  | admin
  deriving DecidableEq

/-- An ACL policy (the Senate rules) is a decidable predicate. -/
structure ACLPolicy where
  allowed   : Principal → Resource → Action → Prop
  decidable : DecidablePred (fun t : Principal × Resource × Action =>
    allowed t.1 t.2.1 t.2.2)

/-- Whether the Senate allows a specific request. -/
def ACLPolicy.permits (pol : ACLPolicy) (p : Principal) (r : Resource)
    (a : Action) : Prop :=
  pol.allowed p r a

instance (pol : ACLPolicy) (p : Principal) (r : Resource) (a : Action) :
    Decidable (pol.permits p r a) :=
  pol.decidable (p, r, a)

/-- The trivially permissive Senate — rubber-stamp everything.
    Only safe because the Committee is below it. -/
def ACLPolicy.permitAll : ACLPolicy where
  allowed := fun _ _ _ => True
  decidable := fun _ => isTrue trivial

/-- The trivially restrictive Senate — block everything. -/
def ACLPolicy.denyAll : ACLPolicy where
  allowed := fun _ _ _ => False
  decidable := fun _ => isFalse id

/-! ## §14. Two-Layer Admission: Committee then Senate

The flow:
  1. Propose bill → construct block + CID
  2. Committee → Congruent(c,b) ∧ blockToBase(b) = fiber  [mathematics]
  3. Senate → ACL allows the principal to write this resource  [policy]

Layer 1 is absolute. Layer 2 can only restrict further.
-/

/-- A committee-approved bill: passed mathematical scrutiny. -/
def CommitteeApproved (ds : Dataset) (c : CID) (b : Block) : Prop :=
  Congruent c b ∧ blockToBase b = ds.fiber

/-- Committee approval is decidable. -/
instance (ds : Dataset) (c : CID) (b : Block) :
    Decidable (CommitteeApproved ds c b) := by
  unfold CommitteeApproved
  infer_instance

/-- Senate vote: ACL policy on an already-committee-approved bill. -/
def SenateApproved (pol : ACLPolicy) (principal : Principal)
    (ds : Dataset) (c : CID) : Prop :=
  pol.permits principal ⟨ds, c⟩ Action.write

/-- Two-layer admission: Committee AND Senate must both pass.
    The Committee can never be bypassed.
    The Senate can only restrict further. -/
def TwoLayerAdmitted (ds : Dataset) (principal : Principal)
    (c : CID) (b : Block) (pol : ACLPolicy) : Prop :=
  CommitteeApproved ds c b ∧ SenateApproved pol principal ds c

instance (ds : Dataset) (principal : Principal) (c : CID) (b : Block)
    (pol : ACLPolicy) : Decidable (TwoLayerAdmitted ds principal c b pol) := by
  unfold TwoLayerAdmitted SenateApproved
  infer_instance

/-- Two-layer admission implies mathematical congruence.
    The Senate can never override mathematics. -/
theorem two_layer_implies_congruent (ds : Dataset) (principal : Principal)
    (c : CID) (b : Block) (pol : ACLPolicy)
    (h : TwoLayerAdmitted ds principal c b pol) :
    Congruent c b :=
  h.1.1

/-- Two-layer admission implies fiber membership.
    No block can enter the wrong dataset. -/
theorem two_layer_implies_fiber (ds : Dataset) (principal : Principal)
    (c : CID) (b : Block) (pol : ACLPolicy)
    (h : TwoLayerAdmitted ds principal c b pol) :
    ds.contains b :=
  h.1.2

/-- Two-layer admission implies Senate permission. -/
theorem two_layer_implies_senate (ds : Dataset) (principal : Principal)
    (c : CID) (b : Block) (pol : ACLPolicy)
    (h : TwoLayerAdmitted ds principal c b pol) :
    SenateApproved pol principal ds c :=
  h.2

/-- Under a rubber-stamp Senate, admission reduces to
    pure Committee approval (mathematics only). -/
theorem permitAll_reduces_to_committee (ds : Dataset) (principal : Principal)
    (c : CID) (b : Block) :
    TwoLayerAdmitted ds principal c b ACLPolicy.permitAll ↔
    CommitteeApproved ds c b := by
  simp [TwoLayerAdmitted, SenateApproved, ACLPolicy.permits, ACLPolicy.permitAll]

/-- Under a deny-all Senate, nothing is ever admitted —
    not even committee-approved bills. -/
theorem denyAll_admits_nothing (ds : Dataset) (principal : Principal)
    (c : CID) (b : Block) :
    ¬ TwoLayerAdmitted ds principal c b ACLPolicy.denyAll := by
  simp [TwoLayerAdmitted, SenateApproved, ACLPolicy.permits, ACLPolicy.denyAll]

/-- The Committee is strictly stronger than the Senate:
    if the Committee rejects, the two-layer system rejects,
    regardless of what the Senate would say. -/
theorem committee_veto (ds : Dataset) (principal : Principal)
    (c : CID) (b : Block) (pol : ACLPolicy)
    (h : ¬ CommitteeApproved ds c b) :
    ¬ TwoLayerAdmitted ds principal c b pol :=
  fun hadm => h hadm.1

/-! ## §15. Kernel API — The Memory Manager

The kernel's memory manager is a shape-constrained,
CRT-verified, Monster-indexed store.

No byte enters kernel-managed memory unless it proves its address.
-/

/-- The kernel store: datasets with their contents and invariants. -/
structure KernelStore where
  policy       : ACLPolicy
  contents     : Dataset → List (CID × Block)
  allCongruent : ∀ ds c b, (c, b) ∈ contents ds → Congruent c b
  allInFiber   : ∀ ds c b, (c, b) ∈ contents ds → blockToBase b = ds.fiber

/-- An empty store satisfies all invariants. -/
def KernelStore.empty (pol : ACLPolicy) : KernelStore where
  policy := pol
  contents := fun _ => []
  allCongruent := fun _ _ _ h => by simp at h
  allInFiber := fun _ _ _ h => by simp at h

/-- Insert a committee-approved, senate-approved block.
    This is the kernel API: no proof → no insertion. -/
noncomputable def KernelStore.insert (store : KernelStore)
    (ins : ProofCarryingInsert) (principal : Principal)
    (_hsenate : SenateApproved store.policy
      principal ins.target ins.cid) :
    KernelStore where
  policy := store.policy
  contents := fun ds =>
    if ds = ins.target then
      (ins.cid, ins.block) :: store.contents ds
    else
      store.contents ds
  allCongruent := by
    intro ds c b hmem
    split at hmem
    · simp only [List.mem_cons] at hmem
      rcases hmem with ⟨rfl, rfl⟩ | hmem
      · exact ins.congruence
      · exact store.allCongruent ds c b hmem
    · exact store.allCongruent ds c b hmem
  allInFiber := by
    intro ds c b hmem
    split at hmem
    · rename_i heq
      simp only [List.mem_cons] at hmem
      rcases hmem with ⟨rfl, rfl⟩ | hmem
      · rw [heq]; exact ins.blockInFiber
      · exact store.allInFiber ds c b hmem
    · exact store.allInFiber ds c b hmem

/-- The store invariant is preserved by insertion. -/
theorem insert_preserves_invariant (store : KernelStore)
    (ins : ProofCarryingInsert) (principal : Principal)
    (hsenate : SenateApproved store.policy principal ins.target ins.cid)
    (ds : Dataset) (c : CID) (b : Block)
    (hmem : (c, b) ∈ (store.insert ins principal hsenate).contents ds) :
    Congruent c b ∧ blockToBase b = ds.fiber :=
  ⟨(store.insert ins principal hsenate).allCongruent ds c b hmem,
   (store.insert ins principal hsenate).allInFiber ds c b hmem⟩

/-! ## §16. No Contamination — Cross-Dataset Contamination Is Impossible

Because blockToBase is a function (deterministic projection),
a block can only live in one fiber. Cross-dataset contamination
is mathematically impossible — the Committee gate prevents it.
-/

/-- A block cannot belong to two different datasets. -/
theorem no_cross_contamination (ds₁ ds₂ : Dataset) (b : Block)
    (h₁ : ds₁.contains b) (h₂ : ds₂.contains b) :
    ds₁ = ds₂ := by
  apply Dataset.ext
  rw [Dataset.contains] at h₁ h₂
  rw [← h₁, ← h₂]

/-- In a valid store, every block belongs to exactly the dataset
    it was inserted into. -/
theorem store_fiber_integrity (store : KernelStore) (ds : Dataset)
    (c : CID) (b : Block) (hmem : (c, b) ∈ store.contents ds) :
    blockToBase b = ds.fiber ∧ ∀ ds' : Dataset, ds'.contains b → ds' = ds := by
  refine ⟨store.allInFiber ds c b hmem, fun ds' hds' => ?_⟩
  apply Dataset.ext
  rw [Dataset.contains] at hds'
  rw [← hds', store.allInFiber ds c b hmem]

/-! ## §17. Unified Rule — The Final Theorem

The legislative model:
  Committee (CRT congruence) → Senate (ACL policy) → Admission

Datasets are geometric objects (fibers in the Monster torus).
Elements are proof-carrying inhabitants.
The kernel enforces the geometry.
The ACL layer enforces the politics.
The Monster group defines the universe.
-/

/-- THE UNIFIED GOVERNANCE THEOREM:

A block is admitted to a dataset iff:
1. The Committee approves it (mathematics — congruence + fiber)
2. The Senate approves it (policy — ACL)

No committee pass ⇒ the Senate literally cannot see it.
The address space has Monster size (196883 fibers = 196883 datasets).
No block can contaminate a dataset it doesn't belong to.

This is not policy. It is mathematics.
The government can only think sure mathematical thoughts. -/
theorem unified_governance
    (ds : Dataset) (principal : Principal)
    (c : CID) (b : Block) (pol : ACLPolicy) :
    -- Two-layer admission = Committee ∧ Senate
    (TwoLayerAdmitted ds principal c b pol ↔
      CommitteeApproved ds c b ∧ SenateApproved pol principal ds c) ∧
    -- Committee = congruence + fiber
    (CommitteeApproved ds c b ↔
      Congruent c b ∧ blockToBase b = ds.fiber) ∧
    -- Congruence = three CRT coordinates agree
    (Congruent c b ↔
      (c.digest : ZMod 71) = (b.contentHash : ZMod 71) ∧
      (c.digest : ZMod 59) = (b.contentHash : ZMod 59) ∧
      (c.digest : ZMod 47) = (b.contentHash : ZMod 47)) ∧
    -- The address space has Monster size
    Fintype.card Base = 196883 ∧
    -- Every block belongs to exactly one dataset
    (∃! ds' : Dataset, ds'.contains b) ∧
    -- Committee veto is absolute
    (¬ CommitteeApproved ds c b → ¬ TwoLayerAdmitted ds principal c b pol) := by
  exact ⟨Iff.rfl, Iff.rfl, congruent_iff c b, base_card,
         block_unique_dataset b, committee_veto ds principal c b pol⟩

end KernelGovernance
