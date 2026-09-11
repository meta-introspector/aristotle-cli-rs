/-
# A P2P Legislative Collaboration Pipeline with Lean-Verified Conformality

This module formalizes a peer-to-peer, IPFS/IPLD-style collaboration system in
which **citizens, senators, lobbyists, lawyers, experts, and staff** collaborate
to turn *feedback* on a *bill* into a *revision*. The defining feature is that
**every step in the workflow carries a machine-checked proof of conformality**.

## The data model (IPLD-flavoured)

Each contribution is a content-addressed **step** in an append-only DAG:

```
draft (staff/expert)            cid₀  parents = []
   └─ feedback (citizen)        cid₁  parents = [cid₀]
   └─ review (senator)          cid₂  parents = [cid₀]
   └─ position (lobbyist)       cid₃  parents = [cid₀]
   └─ legal (lawyer)            cid₄  parents = [cid₀]
   └─ technical (expert)        cid₅  parents = [cid₀]
        revision (staff)        cid₆  parents = [cid₀,cid₁,cid₂,cid₃,cid₄,cid₅]
           adoption (senator)   cid₇  parents = [cid₆]
```

Like IPLD, each step is identified by the hash of its own content (`contentHash`),
and links to its predecessors by their content identifiers (`parents : List Cid`).

## Conformality (the proof obligation at each step)

A step is **conformal** in a ledger when *all four* of these hold:

1. **Content-address integrity** — its advertised `cid` equals the hash of its
   content (the IPLD content-addressing invariant).
2. **Authorization** — its author's role is allowed to produce that kind of step
   (a citizen may give feedback, only a senator may adopt, etc.).
3. **Signature validity** — the step is signed by the author's key.
4. **Link provenance** — every parent link resolves to a step already present in
   the ledger (no dangling references in the DAG).

A whole ledger is **conformal** when every step is. We prove:

* `Ledger.check` is a sound *and* complete decision procedure for `Ledger.Conformal`
  (`check_iff_conformal`), so the Boolean check *is* a verified proof.
* a concrete eight-stage legislative pipeline is conformal (`examplePipeline_conformal`);
* provenance: the final revision/adoption is reachable, through the link DAG,
  from the original bill draft (`examplePipeline_revision_provenance`).
-/

import Mathlib

namespace Legislative

-- ============================================================================
-- § 1  Identities, roles, and content identifiers
-- ============================================================================

/-- A public key, modelled as an opaque identifier. -/
abbrev PubKey := Nat

/-- A cryptographic signature, modelled as an opaque value. -/
abbrev Sig := Nat

/-- A content identifier (CID): the hash that content-addresses a step. -/
abbrev Cid := Nat

/-- The six participant roles in the legislative collaboration. -/
inductive Role
  | citizen | senator | lobbyist | lawyer | expert | staff
  deriving DecidableEq, Repr, BEq, Inhabited

/-- A numeric code for a role (used in content hashing). -/
def Role.code : Role → Nat
  | .citizen => 1 | .senator => 2 | .lobbyist => 3
  | .lawyer => 4  | .expert => 5  | .staff => 6

/-- A participant: a public key together with the role they act in. -/
structure Participant where
  key : PubKey
  role : Role
  deriving DecidableEq, Repr, BEq, Inhabited

-- ============================================================================
-- § 2  Step kinds and the role-authorization policy
-- ============================================================================

/-- The kinds of contribution that make up the feedback → bill → revision flow. -/
inductive StepKind
  | draft       -- initial bill drafting
  | feedback    -- citizen feedback on the bill
  | review      -- senator review / moderation
  | position    -- lobbyist position paper
  | legal       -- lawyer legal analysis
  | technical   -- expert technical review
  | revision    -- staff-produced revised bill
  | adoption    -- senate adoption of the revision
  deriving DecidableEq, Repr, BEq, Inhabited

/-- A numeric code for a step kind (used in content hashing). -/
def StepKind.code : StepKind → Nat
  | .draft => 10 | .feedback => 11 | .review => 12 | .position => 13
  | .legal => 14 | .technical => 15 | .revision => 16 | .adoption => 17

/-- The authorization policy: which roles may produce each kind of step. -/
def StepKind.authorizedRoles : StepKind → List Role
  | .draft     => [.staff, .expert]
  | .feedback  => [.citizen]
  | .review    => [.senator]
  | .position  => [.lobbyist]
  | .legal     => [.lawyer]
  | .technical => [.expert]
  | .revision  => [.staff]
  | .adoption  => [.senator]

/-- Boolean form of the authorization policy: may role `r` produce kind `k`? -/
def StepKind.authorizes (k : StepKind) (r : Role) : Bool :=
  k.authorizedRoles.contains r

-- ============================================================================
-- § 3  Steps, content addressing, and signatures
-- ============================================================================

/-- A single contribution to the pipeline, *before* it is content-addressed.
    `body` is the (textual) content; `parents` are IPLD links to predecessors. -/
structure Step where
  kind : StepKind
  author : Participant
  parents : List Cid
  body : String
  deriving DecidableEq, Repr, Inhabited

/-- Fold a list of naturals into a single hash. -/
def hashFold (l : List Nat) : Nat :=
  l.foldl (fun acc x => acc * 1000003 + x + 1) 7

/-- The content hash of a step — its IPLD content identifier. It mixes the
    kind, the author's identity and role, the parent links, and the body. -/
def Step.contentHash (s : Step) : Cid :=
  hashFold [s.kind.code, s.author.key, s.author.role.code,
            s.body.hash.toNat, hashFold s.parents]

/-- The signature the author's key should produce for a given CID. -/
def expectedSig (key : PubKey) (cid : Cid) : Sig :=
  key * 1000003 + cid + 17

/-- A content-addressed, signed step: a `Step` together with its advertised
    content identifier and the author's signature over it. -/
structure AddressedStep where
  step : Step
  cid : Cid
  sig : Sig
  deriving DecidableEq, Repr, Inhabited

/-- Smart constructor: address and sign a step honestly. -/
def AddressedStep.seal (s : Step) : AddressedStep :=
  let c := s.contentHash
  { step := s, cid := c, sig := expectedSig s.author.key c }

-- ============================================================================
-- § 4  The ledger and the conformality predicate
-- ============================================================================

/-- A ledger is the append-only collection of all addressed steps. -/
structure Ledger where
  steps : List AddressedStep
  deriving Repr, Inhabited

/-- A CID resolves in the ledger when some step advertises it. -/
def Ledger.Resolves (l : Ledger) (c : Cid) : Prop :=
  ∃ a ∈ l.steps, a.cid = c

instance (l : Ledger) (c : Cid) : Decidable (l.Resolves c) :=
  inferInstanceAs (Decidable (∃ a ∈ l.steps, a.cid = c))

/-- 1. Content-address integrity. -/
def AddressedStep.WellAddressed (a : AddressedStep) : Prop :=
  a.cid = a.step.contentHash

/-- 2. Authorization: the author's role may produce this kind of step. -/
def AddressedStep.Authorized (a : AddressedStep) : Prop :=
  a.step.kind.authorizes a.step.author.role = true

/-- 3. Signature validity. -/
def AddressedStep.Signed (a : AddressedStep) : Prop :=
  a.sig = expectedSig a.step.author.key a.cid

/-- 4. Link provenance: every parent resolves in the ledger. -/
def AddressedStep.LinksResolve (a : AddressedStep) (l : Ledger) : Prop :=
  ∀ c ∈ a.step.parents, l.Resolves c

/-- A step is **conformal** in a ledger when all four obligations hold.
    This is the per-step "proof of conformality" the workflow produces. -/
def AddressedStep.Conformal (a : AddressedStep) (l : Ledger) : Prop :=
  a.WellAddressed ∧ a.Authorized ∧ a.Signed ∧ a.LinksResolve l

instance (a : AddressedStep) (l : Ledger) : Decidable (a.Conformal l) := by
  unfold AddressedStep.Conformal AddressedStep.WellAddressed AddressedStep.Authorized
    AddressedStep.Signed AddressedStep.LinksResolve
  infer_instance

/-- A ledger is **conformal** when every step in it is conformal. -/
def Ledger.Conformal (l : Ledger) : Prop :=
  ∀ a ∈ l.steps, a.Conformal l

instance (l : Ledger) : Decidable l.Conformal := by
  unfold Ledger.Conformal; infer_instance

-- ============================================================================
-- § 5  The Boolean decision procedure is a verified proof of conformality
-- ============================================================================

/-- Boolean conformality check on a single addressed step. -/
def AddressedStep.check (a : AddressedStep) (l : Ledger) : Bool :=
  (a.cid == a.step.contentHash) &&
  (a.step.kind.authorizes a.step.author.role) &&
  (a.sig == expectedSig a.step.author.key a.cid) &&
  (a.step.parents.all (fun c => l.steps.any (fun b => b.cid == c)))

/-- Boolean conformality check on the whole ledger. -/
def Ledger.check (l : Ledger) : Bool :=
  l.steps.all (fun a => a.check l)

/-- The single-step check decides single-step conformality. -/
theorem AddressedStep.check_iff_conformal (a : AddressedStep) (l : Ledger) :
    a.check l = true ↔ a.Conformal l := by
  simp only [AddressedStep.check, AddressedStep.Conformal, AddressedStep.WellAddressed,
    AddressedStep.Authorized, AddressedStep.Signed, AddressedStep.LinksResolve,
    Ledger.Resolves, Bool.and_eq_true, beq_iff_eq, List.all_eq_true, List.any_eq_true,
    and_assoc]

/-- **Soundness and completeness**: the Boolean ledger check is exactly the
    conformality predicate. Hence `Ledger.check l = true` is a fully verified
    proof that the ledger conforms. -/
theorem check_iff_conformal (l : Ledger) :
    l.check = true ↔ l.Conformal := by
  simp only [Ledger.check, Ledger.Conformal, List.all_eq_true]
  constructor
  · intro h a ha; exact (AddressedStep.check_iff_conformal a l).mp (h a ha)
  · intro h a ha; exact (AddressedStep.check_iff_conformal a l).mpr (h a ha)

/-- Soundness direction, stated separately for convenient use. -/
theorem check_sound (l : Ledger) (h : l.check = true) : l.Conformal :=
  (check_iff_conformal l).mp h

-- ============================================================================
-- § 6  Link-provenance / reachability through the DAG
-- ============================================================================

/-- The CID of a step by its content. -/
def Ledger.lookup? (l : Ledger) (c : Cid) : Option AddressedStep :=
  l.steps.find? (fun a => a.cid == c)

/-- Fuel-bounded reachability: can we get from `src` to `dst` by following
    parent links (predecessors) in the DAG? -/
def Ledger.reachableWithin : Nat → Ledger → Cid → Cid → Bool
  | 0, _, src, dst => src == dst
  | fuel + 1, l, src, dst =>
    if src == dst then true
    else match l.lookup? src with
      | none => false
      | some a => a.step.parents.any (fun p => l.reachableWithin fuel p dst)

-- ============================================================================
-- § 7  A concrete eight-stage legislative pipeline
-- ============================================================================

/-- Participants in the example. -/
def alice  : Participant := ⟨1001, .staff⟩    -- drafting staff
def cara   : Participant := ⟨1002, .citizen⟩  -- a citizen
def sam    : Participant := ⟨1003, .senator⟩  -- a senator
def lola   : Participant := ⟨1004, .lobbyist⟩ -- a lobbyist
def larry  : Participant := ⟨1005, .lawyer⟩   -- a lawyer
def erin   : Participant := ⟨1006, .expert⟩   -- a subject-matter expert

/-- The bill draft (root of the DAG). -/
def draftStep : AddressedStep :=
  AddressedStep.seal ⟨.draft, alice, [], "Bill 42: Open Data Act, v0"⟩

/-- Citizen feedback, linked to the draft. -/
def feedbackStep : AddressedStep :=
  AddressedStep.seal ⟨.feedback, cara, [draftStep.cid], "Please add a privacy clause."⟩

/-- Senator review, linked to the draft. -/
def reviewStep : AddressedStep :=
  AddressedStep.seal ⟨.review, sam, [draftStep.cid], "Reviewed; concerns noted."⟩

/-- Lobbyist position paper, linked to the draft. -/
def positionStep : AddressedStep :=
  AddressedStep.seal ⟨.position, lola, [draftStep.cid], "Industry impact assessment."⟩

/-- Lawyer legal analysis, linked to the draft. -/
def legalStep : AddressedStep :=
  AddressedStep.seal ⟨.legal, larry, [draftStep.cid], "Constitutional analysis: sound."⟩

/-- Expert technical review, linked to the draft. -/
def technicalStep : AddressedStep :=
  AddressedStep.seal ⟨.technical, erin, [draftStep.cid], "Feasibility: implementable."⟩

/-- Staff-produced revision, incorporating the draft and all inputs. -/
def revisionStep : AddressedStep :=
  AddressedStep.seal ⟨.revision, alice,
    [draftStep.cid, feedbackStep.cid, reviewStep.cid,
     positionStep.cid, legalStep.cid, technicalStep.cid],
    "Bill 42: Open Data Act, v1 (with privacy clause)"⟩

/-- Senate adoption of the revision. -/
def adoptionStep : AddressedStep :=
  AddressedStep.seal ⟨.adoption, sam, [revisionStep.cid], "Adopted by the Senate."⟩

/-- The full pipeline ledger. -/
def examplePipeline : Ledger :=
  { steps := [draftStep, feedbackStep, reviewStep, positionStep,
              legalStep, technicalStep, revisionStep, adoptionStep] }

-- ============================================================================
-- § 8  The pipeline is verified conformal, with provenance
-- ============================================================================

/-- The Boolean check passes on the example pipeline. -/
theorem examplePipeline_check : examplePipeline.check = true := by
  native_decide

/-- **Main theorem**: the eight-stage legislative pipeline is conformal —
    every step is content-address-correct, authorized, signed, and well-linked. -/
theorem examplePipeline_conformal : examplePipeline.Conformal :=
  check_sound examplePipeline examplePipeline_check

/-- **Provenance**: the adopted final act is reachable, by following IPLD parent
    links, all the way back to the original bill draft. -/
theorem examplePipeline_adoption_provenance :
    examplePipeline.reachableWithin 8 adoptionStep.cid draftStep.cid = true := by
  native_decide

-- ============================================================================
-- § 9  The check has teeth — violations are rejected (non-vacuity)
-- ============================================================================

/-- A forged step: a citizen attempting to *adopt* a bill (only senators may). -/
def forgedAdoption : AddressedStep :=
  AddressedStep.seal ⟨.adoption, cara, [revisionStep.cid], "Citizen self-adopts."⟩

/-- The forged step is **not** conformal: the authorization obligation fails. -/
theorem forgedAdoption_not_conformal :
    ¬forgedAdoption.Conformal examplePipeline := by
  rw [← AddressedStep.check_iff_conformal]
  native_decide

/-- A tampered step whose advertised CID does not match its content is rejected. -/
def tamperedStep : AddressedStep :=
  { draftStep with cid := draftStep.cid + 1 }

/-- Tampering with content (so the CID no longer addresses the body) is caught. -/
theorem tamperedStep_not_conformal :
    ¬tamperedStep.Conformal examplePipeline := by
  rw [← AddressedStep.check_iff_conformal]
  native_decide

/-- A step linking to a non-existent (dangling) parent CID is rejected. -/
def danglingStep : AddressedStep :=
  AddressedStep.seal ⟨.feedback, cara, [999999], "feedback on a ghost bill"⟩

/-- Dangling IPLD links break provenance and are caught. -/
theorem danglingStep_not_conformal :
    ¬danglingStep.Conformal examplePipeline := by
  rw [← AddressedStep.check_iff_conformal]
  native_decide

end Legislative
