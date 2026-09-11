/-
# Quorum Intersection and Consensus

This file formalizes the combinatorial foundation of distributed consensus:
the **quorum intersection theorem**. Any two majority subsets of n agents
must share at least one witness. This is the load-bearing piece of Paxos
and every majority-based consensus protocol.

## Connection to the Atlas

The quorum intersection property is the distributed analogue of the
simplicity condition for groups. A simple group has no proper normal
subgroup — no sub-dialogue invariant under all rearrangements. A quorum
system has no two disjoint majorities — no two sub-sessions that share
no witness. They express the same structural demand: **irreducibility
under rearrangement**.

## From Session Monoid to Distributed Sessions

The `Session.lean` file defines a single session trace as an element of
a free monoid. Here we extend to *n* agents, each running their own trace.
Consensus is the requirement that all agents' projected states agree —
an equalizer condition on the product monoid.
-/

import Mathlib
import RequestProject.Session

open Finset

/-! ## Quorum Intersection -/

/-- A quorum is a subset of agents containing a strict majority. -/
def IsQuorum (n : ℕ) (Q : Finset (Fin n)) : Prop := 2 * Q.card > n

/-
The quorum intersection theorem: any two majority subsets of n agents
    must share at least one element. This is the combinatorial foundation
    of Paxos, Raft, and every majority-based consensus protocol.

    Proof: if Q₁ ∩ Q₂ = ∅, then |Q₁ ∪ Q₂| = |Q₁| + |Q₂| > n,
    but Q₁ ∪ Q₂ ⊆ Fin n so |Q₁ ∪ Q₂| ≤ n. Contradiction.
-/
theorem quorum_intersection (n : ℕ) (Q₁ Q₂ : Finset (Fin n))
    (h₁ : IsQuorum n Q₁) (h₂ : IsQuorum n Q₂) :
    (Q₁ ∩ Q₂).Nonempty := by
  unfold IsQuorum at h₁ h₂;
  exact Finset.card_pos.mp ( by linarith [ show Finset.card ( Q₁ ∪ Q₂ ) ≤ n by exact le_trans ( Finset.card_le_univ _ ) ( by norm_num ), Finset.card_union_add_card_inter Q₁ Q₂ ] )

/-- Equivalent formulation: the intersection has positive cardinality. -/
theorem quorum_intersection_card (n : ℕ) (Q₁ Q₂ : Finset (Fin n))
    (h₁ : IsQuorum n Q₁) (h₂ : IsQuorum n Q₂) :
    0 < (Q₁ ∩ Q₂).card := by
  exact Finset.Nonempty.card_pos (quorum_intersection n Q₁ Q₂ h₁ h₂)

/-! ## Distributed Sessions -/

/-- A distributed session: n agents, each with their own session trace. -/
structure DistributedSession (n : ℕ) where
  agents : Fin n → SessionTrace

/-- All agents agree on the projected state: the equalizer condition. -/
def agreeOnProjectState {n : ℕ} (ds : DistributedSession n) : Prop :=
  ∀ i j : Fin n, interpretSession (ds.agents i) = interpretSession (ds.agents j)

/-- A quorum-witnessed value: all agents in the quorum report the same state. -/
def quorumAgrees {n : ℕ} (ds : DistributedSession n)
    (Q : Finset (Fin n)) : Prop :=
  ∀ i j : Fin n, i ∈ Q → j ∈ Q →
    interpretSession (ds.agents i) = interpretSession (ds.agents j)

/-
If two quorums each internally agree, and quorums intersect,
    then they agree with each other. This is why Paxos works:
    the witness in the intersection carries the agreed value
    from one quorum to the other.
-/
theorem quorum_agreement {n : ℕ} (ds : DistributedSession n)
    (Q₁ Q₂ : Finset (Fin n))
    (hQ₁ : IsQuorum n Q₁) (hQ₂ : IsQuorum n Q₂)
    (hA₁ : quorumAgrees ds Q₁) (hA₂ : quorumAgrees ds Q₂)
    {i j : Fin n} (hi₁ : i ∈ Q₁) (hj₂ : j ∈ Q₂) :
    interpretSession (ds.agents i) = interpretSession (ds.agents j) := by
  -- By quorum_intersection, Q �₁ Q₂ is nonempty.
  obtain ⟨w, hw⟩ : ∃ w, w ∈ Q₁ ∧ w ∈ Q₂ := by
    convert quorum_intersection n Q₁ Q₂ hQ₁ hQ₂ using 1;
    simp +decide [ Finset.Nonempty ];
  rw [ hA₁ i w hi₁ hw.1, hA₂ w j hw.2 hj₂ ]

/-! ## The Bridge: Simplicity and Consensus

The connection between simple groups and consensus protocols:
- In a simple group G, there is no proper normal subgroup.
  Every nontrivial invariant structure equals the whole group.
- In a quorum system, there is no pair of disjoint majorities.
  Every local agreement extends to global agreement.

Both are instances of **irreducibility under rearrangement**:
no proper sub-structure can be isolated from the rest. -/

/-
The consensus safety theorem: if every value commitment is witnessed
    by a quorum, and any two quorums intersect, then there is at most
    one committed value.
-/
theorem consensus_safety {n : ℕ} (ds : DistributedSession n)
    (Q₁ Q₂ : Finset (Fin n))
    (hQ₁ : IsQuorum n Q₁) (hQ₂ : IsQuorum n Q₂)
    (hA₁ : quorumAgrees ds Q₁) (hA₂ : quorumAgrees ds Q₂) :
    ∀ i ∈ Q₁, ∀ j ∈ Q₂,
      interpretSession (ds.agents i) = interpretSession (ds.agents j) := by
  intros i hi j hj
  apply quorum_agreement ds Q₁ Q₂ hQ₁ hQ₂ hA₁ hA₂ hi hj