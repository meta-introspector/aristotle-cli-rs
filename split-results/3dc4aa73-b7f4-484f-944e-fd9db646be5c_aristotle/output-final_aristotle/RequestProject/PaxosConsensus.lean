import Mathlib

set_option maxHeartbeats 800000

/-!
# Paxos Consensus for EmojiLang Bindings

We formalize the safety property of a Paxos-like consensus protocol
for agreeing on emoji-to-j-invariant bindings.

## Key Result

If two quorums (each of size ≥ 13 out of 24 nodes) both agree on a value,
and each node accepts at most one value, then the two quorums must have
agreed on the **same** value. This is the core Paxos safety property.

The proof relies on the pigeonhole principle: two sets of size ≥ 13
in a universe of 24 elements must overlap.
-/

open Finset

/-- An emoji binding: maps a glyph to its j-invariant coefficient data. -/
structure EmojiBinding where
  glyph : String
  jIndex : ℤ
  jCoeff : ℕ
  deriving DecidableEq

/-- A value proposed/accepted in the consensus protocol. -/
abbrev PaxosValue := ℤ × ℕ

/-- Extract the consensus value from a binding. -/
def EmojiBinding.value (b : EmojiBinding) : PaxosValue := (b.jIndex, b.jCoeff)

/-- Number of nodes in our Paxos system. -/
abbrev numNodes : ℕ := 24

/-- Quorum threshold (strict majority). -/
abbrev quorumThreshold : ℕ := 13

/-- A quorum is a finset of nodes with at least `quorumThreshold` members. -/
def IsQuorum (S : Finset (Fin numNodes)) : Prop :=
  quorumThreshold ≤ S.card

/-- The single-value acceptance invariant: each node accepts at most one value
    for a given glyph. This is the key Paxos invariant maintained by the protocol. -/
def SingleAcceptance (accepted : Fin numNodes → Option PaxosValue) : Prop :=
  ∀ i : Fin numNodes, ∀ v1 v2 : PaxosValue,
    accepted i = some v1 → accepted i = some v2 → v1 = v2

/-- A quorum agrees on a value if every node in the quorum has accepted that value. -/
def QuorumAgreed (accepted : Fin numNodes → Option PaxosValue)
    (S : Finset (Fin numNodes)) (v : PaxosValue) : Prop :=
  ∀ i ∈ S, accepted i = some v

/-
**Quorum Overlap Lemma**: Any two quorums in a 24-node system with threshold 13
    must share at least one node. This follows from the pigeonhole principle:
    |S₁| + |S₂| ≥ 13 + 13 = 26 > 24 = |Fin 24|.
-/
theorem quorum_overlap (S₁ S₂ : Finset (Fin numNodes))
    (hS₁ : IsQuorum S₁) (hS₂ : IsQuorum S₂) :
    (S₁ ∩ S₂).Nonempty := by
  contrapose! hS₁; simp_all +decide [ IsQuorum ] ;
  have := Finset.card_le_univ ( S₁ ∪ S₂ ) ; simp_all +decide [ Finset.disjoint_iff_inter_eq_empty ] ;
  lia

/-
**Paxos Safety Theorem**: If two quorums both agree on values (possibly different),
    and the single-acceptance invariant holds, then the values must be equal.

    This is the fundamental safety property of Paxos: no two different values
    can both be learned by the system.
-/
theorem paxos_safety
    (accepted : Fin numNodes → Option PaxosValue)
    (S₁ S₂ : Finset (Fin numNodes))
    (v₁ v₂ : PaxosValue)
    (hSingle : SingleAcceptance accepted)
    (hQ₁ : IsQuorum S₁) (hQ₂ : IsQuorum S₂)
    (hA₁ : QuorumAgreed accepted S₁ v₁)
    (hA₂ : QuorumAgreed accepted S₂ v₂) :
    v₁ = v₂ := by
  -- By quorum_overlap, S₁ ∩ S₂ is nonempty.
  obtain ⟨i, hi⟩ : ∃ i, i ∈ S₁ ∩ S₂ := by
    exact Finset.nonempty_of_ne_empty ( by intro h; have := quorum_overlap S₁ S₂ hQ₁ hQ₂; aesop );
  exact hSingle i v₁ v₂ ( hA₁ i ( Finset.mem_of_mem_inter_left hi ) ) ( hA₂ i ( Finset.mem_of_mem_inter_right hi ) )

/-
**Paxos Emoji Consensus**: If two emoji bindings for the same glyph are both
    agreed upon by quorums (under the single-acceptance invariant), then they
    must have the same jIndex and jCoeff.

    This is the application-level consequence of Paxos safety.
-/
theorem paxos_emoji_consensus
    (b₁ b₂ : EmojiBinding)
    (accepted : Fin numNodes → Option PaxosValue)
    (S₁ S₂ : Finset (Fin numNodes))
    (_hGlyph : b₁.glyph = b₂.glyph)
    (hSingle : SingleAcceptance accepted)
    (hQ₁ : IsQuorum S₁) (hQ₂ : IsQuorum S₂)
    (hA₁ : QuorumAgreed accepted S₁ b₁.value)
    (hA₂ : QuorumAgreed accepted S₂ b₂.value) :
    b₁.jIndex = b₂.jIndex ∧ b₁.jCoeff = b₂.jCoeff := by
  -- Apply the paxos_safety theorem to get that b₁.value = b₂.value.
  have h_eq : b₁.value = b₂.value := by
    exact paxos_safety accepted S₁ S₂ b₁.value b₂.value hSingle hQ₁ hQ₂ hA₁ hA₂
  exact Prod.ext_iff.mp h_eq |> fun h => ⟨ h.1, h.2 ⟩

/-
The quorum threshold satisfies the overlap condition: 2 * 13 > 24.
-/
theorem quorum_threshold_valid : 2 * quorumThreshold > numNodes := by
  native_decide +revert

/-
**Liveness bound**: With at most 8 Byzantine/offline nodes out of 24,
    a quorum of 13 can always be formed from the remaining 16 honest nodes.
-/
theorem liveness_with_faults (maxFaults : ℕ) (hFaults : maxFaults ≤ 8) :
    numNodes - maxFaults ≥ quorumThreshold := by
  decide +revert