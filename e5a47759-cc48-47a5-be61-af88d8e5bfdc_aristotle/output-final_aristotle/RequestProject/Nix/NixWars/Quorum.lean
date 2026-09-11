import RequestProject.Nix.NixWars.Shards

/-!
# Consensus on the board: 23 nodes, quorum 12

The shards project runs its consensus over 23 Paxos nodes, distributes the ten
topological classes of the tenfold way across them, and claims three numbers:

* a quorum is **12** of the 23 nodes — `⌈23/2⌉`, "not 13 (wasteful), not 11
  (insecure)";
* the Byzantine tolerance is **7** = `⌊(23-1)/3⌋`;
* the optimal distribution is `10 × 12 = 120` assignments.

This file proves the content behind those numbers, for a general node set
first and then for `23`:

* `quorum_inter_nonempty` — any two majorities of `n` nodes meet, which is what
  makes a decided value stick;
* `paxos_quorums_intersect` — the instance at `n = 23, q = 12`;
* `quorum_minimal` — 11 really is insecure: two *disjoint* sets of 11 nodes
  exist, so an 11-node quorum could decide two different values;
* `byzantine_honest_quorum` — with at most 7 faulty nodes the honest ones still
  form a quorum, and `quorum_meets_honest` — every quorum contains an honest
  node, in fact at least five.
-/

namespace NixWars

/-! ## Majorities intersect -/

/-- **The quorum intersection property.** Any two sets of nodes that are each
larger than half of the network have a node in common. This is the whole reason
a Paxos quorum is a majority: two quorums cannot decide independently. -/
theorem quorum_inter_nonempty {α : Type*} [Fintype α] [DecidableEq α] {A B : Finset α}
    (hA : Fintype.card α < 2 * A.card) (hB : Fintype.card α < 2 * B.card) :
    (A ∩ B).Nonempty := by
  rw [← Finset.card_pos]
  have hunion : (A ∪ B).card ≤ Fintype.card α := by
    simpa using Finset.card_le_card (Finset.subset_univ (A ∪ B))
  have hcards : (A ∪ B).card + (A ∩ B).card = A.card + B.card :=
    Finset.card_union_add_card_inter A B
  omega

/-! ## The 23 nodes of the shards network -/

/-- The Paxos network: 23 nodes (the "Earth chokepoints" of the project). -/
def paxosNodes : Nat := 23

/-- A quorum is 12 nodes. -/
def paxosQuorum : Nat := 12

/-- Byzantine tolerance: 7 faulty nodes. -/
def byzantineTolerance : Nat := 7

/-- The ten topological classes of the tenfold way. -/
def topoShards : Nat := 10

/-- The quorum is the ceiling of half the network. -/
theorem paxosQuorum_eq_ceil : paxosQuorum = (paxosNodes + 1) / 2 := by decide

/-- The Byzantine tolerance is the usual `⌊(n-1)/3⌋`. -/
theorem byzantineTolerance_eq : byzantineTolerance = (paxosNodes - 1) / 3 := by decide

/-- The optimal distribution: every one of the ten classes gets a full quorum,
for 120 assignments in all. -/
theorem topo_assignments : topoShards * paxosQuorum = 120 := by decide

/-- A quorum is a strict majority. -/
theorem paxos_quorum_majority : paxosNodes < 2 * paxosQuorum := by decide

/-- The nodes of the network. -/
abbrev Node := Fin paxosNodes

/-- A set of nodes is a quorum when it has at least 12 members. -/
def IsQuorum (A : Finset Node) : Prop := paxosQuorum ≤ A.card

/-- **Two quorums of the 23-node network always meet.** -/
theorem paxos_quorums_intersect {A B : Finset Node} (hA : IsQuorum A) (hB : IsQuorum B) :
    (A ∩ B).Nonempty := by
  have hcard : Fintype.card Node = paxosNodes := by simp
  simp only [IsQuorum, paxosQuorum] at hA hB
  refine quorum_inter_nonempty ?_ ?_ <;> rw [hcard] <;> simp only [paxosNodes] <;> omega

/-- **Eleven is not enough.** There are two disjoint sets of 11 nodes, so an
11-node "quorum" could let two of them decide different values: 12 is the least
safe quorum size. -/
theorem quorum_minimal :
    ∃ A B : Finset Node, A.card = paxosQuorum - 1 ∧ B.card = paxosQuorum - 1 ∧ Disjoint A B := by
  refine ⟨(Finset.univ.filter (fun i : Node => (i : Nat) < 11)),
          (Finset.univ.filter (fun i : Node => 11 ≤ (i : Nat) ∧ (i : Nat) < 22)), ?_, ?_, ?_⟩
  · decide
  · decide
  · rw [Finset.disjoint_left]
    decide

/-! ## Byzantine faults -/

/-- **Seven faulty nodes are survivable.** Whatever set of at most 7 nodes has
failed, the honest nodes still form a quorum. -/
theorem byzantine_honest_quorum (F : Finset Node) (hF : F.card ≤ byzantineTolerance) :
    IsQuorum Fᶜ := by
  have hcard : Fintype.card Node = paxosNodes := by simp
  have := Finset.card_compl F
  simp only [IsQuorum]
  rw [Finset.card_compl, hcard]
  simp only [paxosQuorum, byzantineTolerance, paxosNodes] at *
  omega

/-- **Every quorum contains honest nodes** — at least five of them, whatever
the 7 faults are. So a quorum can never be composed entirely of faulty nodes. -/
theorem quorum_meets_honest {A F : Finset Node} (hA : IsQuorum A)
    (hF : F.card ≤ byzantineTolerance) : byzantineTolerance - 2 ≤ (A \ F).card := by
  have h := Finset.card_sdiff_add_card_inter A F
  have hinter : (A ∩ F).card ≤ F.card := Finset.card_le_card Finset.inter_subset_right
  simp only [IsQuorum, paxosQuorum, byzantineTolerance] at *
  omega

/-- Read as a statement about the network: 23 nodes minus 7 Byzantine failures
leaves 16 honest nodes, and 16 ≥ 12. -/
theorem honest_ge_quorum : paxosNodes - byzantineTolerance ≥ paxosQuorum := by decide

/-! ## The 232 ↔ 323 bridge

The project's running example of something the network has to agree on is the
bridge between `232` and `323`: two numbers that are reverses of each other,
land in different topological classes, and so need a quorum on each side. -/

/-- Which of the ten topological classes a number belongs to. -/
def topoClass (n : Nat) : Nat := n % topoShards

theorem topoClass_lt (n : Nat) : topoClass n < topoShards :=
  Nat.mod_lt _ (by decide)

/-- `232 = 2 ^ 3 * 29` and `323 = 17 * 19`: every factor is a Monster prime. -/
theorem bridge_factorizations :
    232 = 2 ^ 3 * 29 ∧ 323 = 17 * 19 ∧
      (2 ∈ monsterPrimes ∧ 29 ∈ monsterPrimes ∧ 17 ∈ monsterPrimes ∧ 19 ∈ monsterPrimes) := by
  decide

/-- The two ends of the bridge sit in different classes, so proving it needs a
quorum on each side: `2 * 12 = 24` votes in all. -/
theorem bridge_classes_differ : topoClass 232 = 2 ∧ topoClass 323 = 3 ∧ topoClass 232 ≠ topoClass 323 := by
  decide

theorem bridge_votes : 2 * paxosQuorum = 24 := by decide

end NixWars
