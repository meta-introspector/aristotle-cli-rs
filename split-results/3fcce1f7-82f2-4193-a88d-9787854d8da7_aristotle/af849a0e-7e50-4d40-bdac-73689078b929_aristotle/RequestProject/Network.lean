/-
# Decentralized P2P Networks: Hash Trees and Connectivity

This module formalizes P2P network properties, cryptographic hash trees
(Merkle trees), DHT-based peer discovery, and graph connectivity
invariants for decentralized federated learning.
-/
import RequestProject.Basic

open scoped BigOperators

/-! ## Cryptographic Hash Model -/

/-- Abstract byte type for hash inputs. -/
abbrev Byte := Fin 256

/-! ## Merkle Hash Trees

We parameterize Merkle trees by an abstract hash function and prove that
well-formed trees with distinct structure have distinct root hashes,
assuming the hash function is injective (collision-resistant). -/

/-- A binary Merkle tree parameterized by the hash value type. -/
inductive MerkleTree (H : Type*) where
  | leaf (data : List Byte) (h : H)
  | node (left right : MerkleTree H) (h : H)

/-- The root hash of a Merkle tree. -/
def MerkleTree.rootHash : MerkleTree H → H
  | .leaf _ h => h
  | .node _ _ h => h

/-- A well-formed Merkle tree w.r.t. hash functions `hashLeaf` and `hashNode`:
    - Leaf hashes are computed from data via `hashLeaf`.
    - Node hashes are computed from children's root hashes via `hashNode`. -/
def MerkleTree.wellFormed
    (hashLeaf : List Byte → H) (hashNode : H → H → H) : MerkleTree H → Prop
  | .leaf data h => h = hashLeaf data
  | .node left right h =>
      left.wellFormed hashLeaf hashNode ∧
      right.wellFormed hashLeaf hashNode ∧
      h = hashNode left.rootHash right.rootHash

/-- Number of leaves in a Merkle tree. -/
def MerkleTree.leafCount : MerkleTree H → ℕ
  | .leaf _ _ => 1
  | .node left right _ => left.leafCount + right.leafCount

/-- Depth of a Merkle tree. -/
def MerkleTree.depth : MerkleTree H → ℕ
  | .leaf _ _ => 0
  | .node left right _ => 1 + max left.depth right.depth

/-
Two well-formed leaf nodes with the same root hash must have the same data.
    This is the tamper-detection property: modifying leaf data changes the root hash.
-/
theorem merkle_leaf_tamper_detection {H : Type*}
    (hashLeaf : List Byte → H)
    (_hashNode : H → H → H)
    (hinj : Function.Injective hashLeaf)
    (d₁ d₂ : List Byte) :
    let t₁ := MerkleTree.leaf d₁ (hashLeaf d₁)
    let t₂ := MerkleTree.leaf d₂ (hashLeaf d₂)
    t₁.rootHash = t₂.rootHash → d₁ = d₂ := by
  exact fun h => hinj h

/-
For well-formed leaf nodes, equal root hashes imply equal data
    (given injective leaf hashing).
-/
theorem merkle_leaf_integrity {H : Type*}
    (hashLeaf : List Byte → H)
    (hinj : Function.Injective hashLeaf)
    (d₁ d₂ : List Byte) (h₁ h₂ : H)
    {hashNode : H → H → H}
    (hwf₁ : MerkleTree.wellFormed hashLeaf hashNode (.leaf d₁ h₁))
    (hwf₂ : MerkleTree.wellFormed hashLeaf hashNode (.leaf d₂ h₂))
    (heq : (MerkleTree.leaf d₁ h₁ : MerkleTree H).rootHash =
           (MerkleTree.leaf d₂ h₂ : MerkleTree H).rootHash) :
    d₁ = d₂ := by
  -- Apply the injectivity of `hashLeaf` to conclude that `d₁ = d₂`.
  apply hinj; exact hwf₁.symm ▸ hwf₂.symm ▸ heq

/-
For well-formed internal nodes, equal root hashes imply equal children hashes
    (given injective node hashing).
-/
theorem merkle_node_integrity {H : Type*}
    (hashLeaf : List Byte → H) (hashNode : H → H → H)
    (hinj_node : ∀ a b c d, hashNode a b = hashNode c d → a = c ∧ b = d)
    (l₁ r₁ l₂ r₂ : MerkleTree H) (h₁ h₂ : H)
    (hwf₁ : MerkleTree.wellFormed hashLeaf hashNode (.node l₁ r₁ h₁))
    (hwf₂ : MerkleTree.wellFormed hashLeaf hashNode (.node l₂ r₂ h₂))
    (heq : (MerkleTree.node l₁ r₁ h₁ : MerkleTree H).rootHash =
           (MerkleTree.node l₂ r₂ h₂ : MerkleTree H).rootHash) :
    l₁.rootHash = l₂.rootHash ∧ r₁.rootHash = r₂.rootHash := by
  grind +locals

/-! ## Network Graph Model -/

/-- A network graph with N nodes. -/
structure NetworkGraph (N : ℕ) where
  /-- Adjacency relation (symmetric). -/
  adj : Fin N → Fin N → Prop
  /-- No self-loops. -/
  irrefl : ∀ v, ¬adj v v
  /-- Symmetric edges. -/
  symm : ∀ u v, adj u v → adj v u

/-- A path in the network graph. -/
inductive GraphPath {N : ℕ} (G : NetworkGraph N) : Fin N → Fin N → Prop where
  | refl : ∀ v, GraphPath G v v
  | step : ∀ u v w, G.adj u v → GraphPath G v w → GraphPath G u w

/-- The network graph is connected if every pair of nodes has a path. -/
def NetworkGraph.isConnected {N : ℕ} (G : NetworkGraph N) : Prop :=
  ∀ u v, GraphPath G u v

/-- Graph path is transitive. -/
theorem graphPath_trans {N : ℕ} (G : NetworkGraph N) {u v w : Fin N}
    (huv : GraphPath G u v) (hvw : GraphPath G v w) :
    GraphPath G u w := by
  induction huv <;> tauto

/-- Graph path is symmetric. -/
theorem graphPath_symm {N : ℕ} (G : NetworkGraph N) {u v : Fin N}
    (huv : GraphPath G u v) : GraphPath G v u := by
  induction huv
  · constructor
  · rename_i u v w huv _hvw ih
    exact graphPath_trans G ih (GraphPath.step _ _ _ (G.symm _ _ huv) (GraphPath.refl _))

/-- A connected graph has the property that every node can reach every other. -/
theorem connected_all_reach {N : ℕ} (G : NetworkGraph N)
    (hconn : G.isConnected) (u v : Fin N) :
    GraphPath G u v :=
  hconn u v

/-! ## DHT (Distributed Hash Table) Model -/

/-- A DHT node stores a subset of key-value pairs. -/
structure DHTNode (H : Type*) where
  /-- Node identifier (hash of node address). -/
  nodeId : H
  /-- Keys this node is responsible for (as natural number indices). -/
  keys : Finset ℕ
  /-- Routing table: known peers. -/
  routingTable : List H

/-- DHT responsibility: every key in [0, keySpace) is assigned to exactly one node. -/
def DHTComplete {N : ℕ} {H : Type*} (nodes : Fin N → DHTNode H) (keySpace : ℕ) : Prop :=
  ∀ key : Fin keySpace, ∃! i, key.val ∈ (nodes i).keys

/-! ## Communication Constraints -/

/-- The synchronization window constraint: each client must complete
    computation and communication within the global window Ω. -/
def syncWindowConstraint {K : ℕ}
    (compTime commTime : Fin K → ℕ) (omega : ℕ) : Prop :=
  ∀ k, compTime k + commTime k ≤ omega

/-- Model compression error bound: the compressed model is within
    γ of the original in L2 norm. -/
noncomputable def compressionBound {dim : ℕ}
    (w : Vec dim) (compress : Vec dim → Vec dim) (γ : ℝ) : Prop :=
  Vec.norm (Vec.sub w (compress w)) ≤ γ

/-- The decentralized training constraint: the network must be connected
    to ensure all updates propagate. -/
def decentralizedTrainingValid {N : ℕ} (G : NetworkGraph N) : Prop :=
  G.isConnected