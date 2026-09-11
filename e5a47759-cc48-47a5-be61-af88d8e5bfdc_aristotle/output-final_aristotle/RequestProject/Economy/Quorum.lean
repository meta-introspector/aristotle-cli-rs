/-
# Byzantine quorums

What this layer can prove: quorum intersection, agreement, and accountability.
What it cannot prove, and does not pretend to: liveness (which needs synchrony
assumptions) and signature unforgeability (which is a cryptographic
assumption).  Signature verification is modelled as an abstract predicate, and
unforgeability appears as an explicit hypothesis on the one theorem that needs
it — never as a declared axiom.

**A correction to the usual sketch.**  "n ≥ 3f+1 and quorums of size ≥ 2f+1
intersect" is *false* as soon as `n > 3f+1`: see `naive_threshold_fails` below,
where seven members, one tolerated fault and two three-member quorums are
disjoint.  The correct threshold is `n - f`, and with it the intersection bound
`n - 2f ≥ f+1` holds for every admissible `n`.
-/
import RequestProject.Economy.Intervals

namespace RequestProject.Economy

open Finset

variable {NodeId : Type*} [DecidableEq NodeId]

/-- A committee: a finite membership and the number of faults it is designed to
tolerate. -/
structure Committee (NodeId : Type*) [DecidableEq NodeId] where
  members : Finset NodeId
  faultBound : Nat
  sizeCondition : 3 * faultBound + 1 ≤ members.card

namespace Committee

/-- The number of members a quorum must contain: `n - f`.  For `n = 3f+1` this
is the familiar `2f+1`. -/
def quorumSize (c : Committee NodeId) : Nat := c.members.card - c.faultBound

theorem quorumSize_eq (c : Committee NodeId) (h : c.members.card = 3 * c.faultBound + 1) :
    c.quorumSize = 2 * c.faultBound + 1 := by
  simp only [quorumSize, h]; omega

end Committee

/-- A quorum of a committee. -/
structure Quorum (c : Committee NodeId) where
  voters : Finset NodeId
  subset : voters ⊆ c.members
  large : c.quorumSize ≤ voters.card

namespace Quorum

/-- **Quorum intersection.** Any two quorums of the same committee share at
least `n - 2f ≥ f + 1` members. -/
theorem card_inter_ge {c : Committee NodeId} (Q₁ Q₂ : Quorum c) :
    c.members.card - 2 * c.faultBound ≤ (Q₁.voters ∩ Q₂.voters).card := by
  have hcard : (Q₁.voters ∪ Q₂.voters).card + (Q₁.voters ∩ Q₂.voters).card
      = Q₁.voters.card + Q₂.voters.card := card_union_add_card_inter _ _
  have hunion : (Q₁.voters ∪ Q₂.voters).card ≤ c.members.card :=
    card_le_card (union_subset Q₁.subset Q₂.subset)
  have h1 := Q₁.large
  have h2 := Q₂.large
  have h3 : Q₁.voters.card ≤ c.members.card := card_le_card Q₁.subset
  have h4 : Q₂.voters.card ≤ c.members.card := card_le_card Q₂.subset
  simp only [Committee.quorumSize] at h1 h2
  have hn := c.sizeCondition
  omega

/-- Two quorums share more members than the committee tolerates faults. -/
theorem card_inter_gt_faultBound {c : Committee NodeId} (Q₁ Q₂ : Quorum c) :
    c.faultBound + 1 ≤ (Q₁.voters ∩ Q₂.voters).card := by
  have h := card_inter_ge Q₁ Q₂
  have hn := c.sizeCondition
  omega

/-- **Honest intersection.** Given any set of at most `f` faulty members, two
quorums share a member outside it. -/
theorem exists_honest_mem_inter {c : Committee NodeId} (Q₁ Q₂ : Quorum c)
    (faulty : Finset NodeId) (hf : faulty.card ≤ c.faultBound) :
    ∃ v, v ∈ Q₁.voters ∧ v ∈ Q₂.voters ∧ v ∉ faulty := by
  by_contra hcon
  push_neg at hcon
  have hsub : Q₁.voters ∩ Q₂.voters ⊆ faulty := by
    intro v hv
    rw [mem_inter] at hv
    exact hcon v hv.1 hv.2
  have := card_le_card hsub
  have := card_inter_gt_faultBound Q₁ Q₂
  omega

end Quorum

/-! ### Certificates, agreement and accountability

A state is identified by an opaque hash; nothing here depends on how the hash
is computed, only on the fact that different hashes denote different states.
-/

/-- An abstract state commitment. -/
structure StateHash where
  hash : String
deriving DecidableEq, Repr

/-- A quorum certificate for a state: a quorum, plus the record that every
voter in it signed that state. -/
structure Certificate {NodeId : Type*} [DecidableEq NodeId] (c : Committee NodeId)
    (Signs : NodeId → StateHash → Prop) where
  state : StateHash
  quorum : Quorum c
  signed : ∀ v ∈ quorum.voters, Signs v state

/-- An honest node never signs two different states. -/
def NoEquivocation (Signs : NodeId → StateHash → Prop) (faulty : Finset NodeId) : Prop :=
  ∀ v, v ∉ faulty → ∀ s t, Signs v s → Signs v t → s = t

/-- **Agreement.** With at most `f` faulty members and no honest equivocation,
one committee cannot certify two different states. -/
theorem certificate_agreement {c : Committee NodeId} {Signs : NodeId → StateHash → Prop}
    (cert₁ cert₂ : Certificate c Signs) (faulty : Finset NodeId)
    (hf : faulty.card ≤ c.faultBound) (hhonest : NoEquivocation Signs faulty) :
    cert₁.state = cert₂.state := by
  obtain ⟨v, hv₁, hv₂, hvf⟩ :=
    Quorum.exists_honest_mem_inter cert₁.quorum cert₂.quorum faulty hf
  exact hhonest v hvf _ _ (cert₁.signed v hv₁) (cert₂.signed v hv₂)

/-- The nodes exposed by a pair of conflicting certificates. -/
def equivocators {c : Committee NodeId} {Signs : NodeId → StateHash → Prop}
    (cert₁ cert₂ : Certificate c Signs) : Finset NodeId :=
  cert₁.quorum.voters ∩ cert₂.quorum.voters

/-- **Accountability.** Two conflicting certificates from one committee name at
least `f + 1` nodes, each of which demonstrably signed both states.  This is
what turns a disagreement into culpability: the certificates themselves are the
evidence, and any third party can check them. -/
theorem accountability {c : Committee NodeId} {Signs : NodeId → StateHash → Prop}
    (cert₁ cert₂ : Certificate c Signs) (hne : cert₁.state ≠ cert₂.state) :
    c.faultBound + 1 ≤ (equivocators cert₁ cert₂).card ∧
      ∀ v ∈ equivocators cert₁ cert₂,
        Signs v cert₁.state ∧ Signs v cert₂.state ∧ cert₁.state ≠ cert₂.state := by
  refine ⟨Quorum.card_inter_gt_faultBound _ _, ?_⟩
  intro v hv
  rw [equivocators, mem_inter] at hv
  exact ⟨cert₁.signed v hv.1, cert₂.signed v hv.2, hne⟩

/-- Corollary: conflicting certificates imply that the fault bound was exceeded
— at least one equivocator is outside any set of at most `f` faulty nodes, so
the assumption "at most `f` faults" is falsified by public evidence. -/
theorem conflicting_certificates_exceed_faultBound {c : Committee NodeId}
    {Signs : NodeId → StateHash → Prop} (cert₁ cert₂ : Certificate c Signs)
    (hne : cert₁.state ≠ cert₂.state) (faulty : Finset NodeId)
    (hf : faulty.card ≤ c.faultBound) (hhonest : NoEquivocation Signs faulty) : False :=
  hne (certificate_agreement cert₁ cert₂ faulty hf hhonest)

/-! ### The naive threshold is unsound

The specification's `|Q| ≥ 2f+1` is only correct when `n = 3f+1` exactly.  Here
is a committee with `n = 7`, `f = 1` and two disjoint quorums of size `3`.
-/

/-- Seven members, one tolerated fault: `3f + 1 = 4 ≤ 7`. -/
def naiveCommittee : Committee Nat where
  members := ({0, 1, 2, 3, 4, 5, 6} : Finset Nat)
  faultBound := 1
  sizeCondition := by decide

theorem naive_threshold_fails :
    ∃ Q₁ Q₂ : Finset Nat,
      Q₁ ⊆ naiveCommittee.members ∧ Q₂ ⊆ naiveCommittee.members ∧
      2 * naiveCommittee.faultBound + 1 ≤ Q₁.card ∧
      2 * naiveCommittee.faultBound + 1 ≤ Q₂.card ∧
      Q₁ ∩ Q₂ = ∅ :=
  ⟨{0, 1, 2}, {3, 4, 5}, by decide, by decide, by decide, by decide, by decide⟩

/-- …whereas the `n - f` threshold used by `Quorum` rules those quorums out. -/
theorem naive_quorums_are_not_quorums :
    ¬ (naiveCommittee.quorumSize ≤ ({0, 1, 2} : Finset Nat).card) := by decide

/-! ### Signatures

Verification is a runtime predicate over an abstract scheme; unforgeability is
an assumption carried as a hypothesis, so a reader can see exactly where it is
used.
-/

/-- An abstract signature scheme. -/
structure SigScheme (NodeId : Type*) where
  Sig : Type
  verify : NodeId → StateHash → Sig → Bool

/-- Unforgeability, as a hypothesis: a signature that verifies under a node's
key was produced by that node signing that state. -/
def Unforgeable {NodeId : Type*} (S : SigScheme NodeId) (Signs : NodeId → StateHash → Prop) : Prop :=
  ∀ v s (σ : S.Sig), S.verify v s σ = true → Signs v s

/-- A collection of verifying signatures yields a certificate — *given*
unforgeability.  The hypothesis is visible in the statement. -/
def certificateOfSignatures {c : Committee NodeId} {S : SigScheme NodeId}
    {Signs : NodeId → StateHash → Prop} (hUnf : Unforgeable S Signs)
    (state : StateHash) (q : Quorum c) (σ : NodeId → S.Sig)
    (hver : ∀ v ∈ q.voters, S.verify v state (σ v) = true) :
    Certificate c Signs :=
  { state := state
    quorum := q
    signed := fun v hv => hUnf v state (σ v) (hver v hv) }

end RequestProject.Economy
