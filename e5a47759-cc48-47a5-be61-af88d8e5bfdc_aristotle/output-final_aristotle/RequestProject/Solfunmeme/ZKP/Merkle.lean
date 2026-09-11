/-
  Merkle.lean — commitments and membership proofs, abstractly.

  The zero-knowledge schema needs two primitives and no more: a commitment to a
  private value that can be opened later, and a proof that a leaf is in a
  committed set without showing the set.  Both are built here over an *abstract*
  hash, so nothing below depends on which hash function is deployed:

      Scheme        a commitment function and a two-to-one compressor
      Binding       distinct openings never collide — an assumption, named
      Hiding        a commitment can be explained by any value — an assumption
      Tree, root    a binary Merkle tree and its root
      Path, verify  a membership path and its recomputation

  What is proved:

    * `verify_of_mem` — completeness: every leaf of a tree has a path that
      verifies against the root;
    * `mem_of_verify` — soundness: under `Binding` on the compressor, a path
      that verifies is a path to a leaf that really is in the tree.  This is
      the theorem that makes a membership proof mean something;
    * `open_unique` — under `Binding`, a commitment has one meaning: two
      openings of the same commitment agree;
    * `hiding_gives_indistinguishable_commitments` — under `Hiding`, a
      commitment to one value is also a commitment to any other, so the
      commitment itself reveals nothing.

  `Binding` and `Hiding` are stated as hypotheses and are never assumed
  together: each theorem names the one it uses.  Nothing here claims a
  particular hash function has either property.
-/

namespace ZKP

/-- A commitment scheme: commit a value with a salt, and compress two digests
into one. -/
structure Scheme where
  /-- `commit value salt`. -/
  commit : String → String → String
  /-- The hash of a leaf.  Kept separate from `node` so that a leaf digest can
  never be mistaken for an internal one — the domain separation a Merkle proof
  needs to be sound. -/
  leafHash : String → String
  /-- The two-to-one compression used to build a tree. -/
  node : String → String → String

/-- **Binding**: different values never share a commitment, and different
children never share a parent digest.  An assumption about the hash, named so
that every theorem that uses it says so. -/
structure Binding (S : Scheme) : Prop where
  /-- Commitments determine the value committed. -/
  commit_inj : ∀ v w r s, S.commit v r = S.commit w s → v = w
  /-- The compressor is collision free. -/
  node_inj : ∀ a b c d, S.node a b = S.node c d → a = c ∧ b = d
  /-- Leaf hashes determine their leaves. -/
  leaf_inj : ∀ v w, S.leafHash v = S.leafHash w → v = w
  /-- Domain separation: an internal digest is never a leaf digest. -/
  node_ne_leaf : ∀ a b v, S.node a b ≠ S.leafHash v

/-- **Hiding**: any commitment can be explained as a commitment to any value,
by choosing the salt.  The other assumption, and the one that makes a redacted
field genuinely private. -/
def Hiding (S : Scheme) : Prop :=
  ∀ v w r, ∃ s, S.commit v r = S.commit w s

/-- **A commitment has one meaning.** -/
theorem open_unique {S : Scheme} (hB : Binding S) {v w r s : String}
    (h : S.commit v r = S.commit w s) : v = w := hB.commit_inj v w r s h

/-- **A commitment on its own reveals nothing**: under hiding, the commitment
to any value is also the commitment to any other. -/
theorem hiding_gives_indistinguishable_commitments {S : Scheme} (hH : Hiding S)
    (v w r : String) : ∃ s, S.commit v r = S.commit w s := hH v w r

/-! ### Merkle trees -/

/-- A binary Merkle tree over committed leaves. -/
inductive Tree where
  /-- A leaf, holding the committed value (usually itself a commitment). -/
  | leaf (value : String)
  /-- An internal node. -/
  | node (left right : Tree)
deriving DecidableEq, Repr, Inhabited

namespace Tree

/-- The root digest of a tree. -/
def root (S : Scheme) : Tree → String
  | .leaf v => S.leafHash v
  | .node l r => S.node (root S l) (root S r)

/-- The leaves, left to right. -/
def leaves : Tree → List String
  | .leaf v => [v]
  | .node l r => leaves l ++ leaves r

end Tree

/-- A membership path: at each step, whether the leaf is on the left, and the
sibling digest. -/
inductive Path where
  /-- The leaf itself. -/
  | here
  /-- The leaf is in the left subtree; the right sibling's root follows. -/
  | left (sibling : String) (rest : Path)
  /-- The leaf is in the right subtree; the left sibling's root follows. -/
  | right (sibling : String) (rest : Path)
deriving DecidableEq, Repr, Inhabited

namespace Path

/-- Recompute the root a path claims, from the leaf up. -/
def recompute (S : Scheme) (leaf : String) : Path → String
  | .here => S.leafHash leaf
  | .left sib rest => S.node (recompute S leaf rest) sib
  | .right sib rest => S.node sib (recompute S leaf rest)

end Path

/-- Does this path prove that `leaf` is under `root`? -/
def verify (S : Scheme) (root leaf : String) (p : Path) : Bool :=
  p.recompute S leaf == root

/-- **Completeness**: every leaf of the tree has a verifying path. -/
theorem verify_of_mem (S : Scheme) (t : Tree) {leaf : String} (h : leaf ∈ t.leaves) :
    ∃ p : Path, verify S (t.root S) leaf p = true := by
  induction t with
  | leaf d =>
      simp only [Tree.leaves, List.mem_singleton] at h
      exact ⟨Path.here, by simp [verify, Path.recompute, Tree.root, h]⟩
  | node l r ihl ihr =>
      simp only [Tree.leaves, List.mem_append] at h
      rcases h with h | h
      · obtain ⟨p, hp⟩ := ihl h
        refine ⟨Path.left (r.root S) p, ?_⟩
        simp only [verify, Path.recompute, Tree.root, beq_iff_eq] at hp ⊢
        rw [hp]
      · obtain ⟨p, hp⟩ := ihr h
        refine ⟨Path.right (l.root S) p, ?_⟩
        simp only [verify, Path.recompute, Tree.root, beq_iff_eq] at hp ⊢
        rw [hp]

/-- **Soundness**: under binding, a path that verifies against a tree's root is
a path to a leaf that is in the tree.  Without this, a membership proof would
prove nothing. -/
theorem mem_of_verify (S : Scheme) (hB : Binding S) (t : Tree) {leaf : String} {p : Path}
    (h : verify S (t.root S) leaf p = true) : leaf ∈ t.leaves := by
  induction t generalizing p with
  | leaf v =>
      cases p with
      | here =>
          simp only [verify, Path.recompute, Tree.root, beq_iff_eq] at h
          simp [Tree.leaves, hB.leaf_inj _ _ h]
      | left sib rest =>
          simp only [verify, Path.recompute, Tree.root, beq_iff_eq] at h
          exact absurd h (hB.node_ne_leaf _ _ _)
      | right sib rest =>
          simp only [verify, Path.recompute, Tree.root, beq_iff_eq] at h
          exact absurd h (hB.node_ne_leaf _ _ _)
  | node l r ihl ihr =>
      cases p with
      | here =>
          simp only [verify, Path.recompute, Tree.root, beq_iff_eq] at h
          exact absurd h.symm (hB.node_ne_leaf _ _ _)
      | left sib rest =>
          simp only [verify, Path.recompute, Tree.root, beq_iff_eq] at h
          obtain ⟨h1, _⟩ := hB.node_inj _ _ _ _ h
          exact List.mem_append.mpr (Or.inl (ihl (p := rest) (by simp [verify, h1])))
      | right sib rest =>
          simp only [verify, Path.recompute, Tree.root, beq_iff_eq] at h
          obtain ⟨_, h2⟩ := hB.node_inj _ _ _ _ h
          exact List.mem_append.mpr (Or.inr (ihr (p := rest) (by simp [verify, h2])))

end ZKP
