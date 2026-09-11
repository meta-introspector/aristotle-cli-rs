/-
# Urania §3.2 / §4 — merkle commitments and inclusion proofs

A snapshot manifest publishes merkle roots; a verifier demands, for every
chain entry the manifest claims to cover, an **inclusion proof** against
that root (§4: "coverage must be inclusion-checked, not self-declared").
This module is the machinery: trees, roots, inclusion paths, and the two
properties that make the check mean anything.

Naming, per §3.2: an inclusion path is a `MerklePath`.  It is deliberately
**not** called a *witness* — in this codebase `witness` already means a
content address, and in a ZK setting it would mean a secret input.

Everything here is relative to a `MerkleHash`: a bundled hypothesis
(§2.5) giving injective leaf hashing, injective node hashing and domain
separation between the two.  Those are symbolic idealisations of
collision resistance, exactly as in `Kant.Urania.Crypto` — and by
`no_hashFn_is_digest` they are *not* satisfied by the FNV-1a digest this
project computes today.

Proved here:

* `inclusion_sound` — a path that verifies against a tree's root proves
  the leaf really is in that tree.  This is what stops an archiver from
  "covering" a range with a root over a strict subset of it;
* `inclusion_complete` — every leaf of a tree has such a path, so an
  honest archiver can always answer the challenge;
* `root_inj` — two trees with the same root are the same tree: an
  omission changes the root;
* `leaves_build` — the tree builder is honest: the leaves of the tree
  built from a list are exactly that list, in order.
-/
import Mathlib

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Urania

/-! ## The hashing discipline -/

/-- The hypotheses a merkle construction needs of its hash: leaves and
nodes hash injectively, and a node hash is never a leaf hash (domain
separation, i.e. the usual `0x00`/`0x01` prefixing).

As in `HashFn`, this is a symbolic idealisation of collision resistance,
carried as an explicit argument by every theorem that uses it. -/
structure MerkleHash (Leaf : Type) (Hash : Type) where
  /-- Hash of a leaf. -/
  hleaf : Leaf → Hash
  /-- Hash of an interior node from its two children. -/
  hnode : Hash → Hash → Hash
  /-- Distinct leaves hash differently. -/
  hleaf_inj : Function.Injective hleaf
  /-- Distinct children hash differently. -/
  hnode_inj : ∀ a b c d, hnode a b = hnode c d → a = c ∧ b = d
  /-- Domain separation: no interior node collides with a leaf. -/
  node_ne_leaf : ∀ a b x, hnode a b ≠ hleaf x

/-! ## Trees -/

/-- A merkle tree over leaf data. -/
inductive MerkleTree (Leaf : Type) where
  /-- A single leaf. -/
  | leaf (x : Leaf)
  /-- An interior node. -/
  | node (l r : MerkleTree Leaf)
deriving Repr

namespace MerkleTree

variable {Leaf : Type}

/-- The leaves of a tree, left to right. -/
def leaves : MerkleTree Leaf → List Leaf
  | .leaf x => [x]
  | .node l r => l.leaves ++ r.leaves

theorem leaves_ne_nil (t : MerkleTree Leaf) : t.leaves ≠ [] := by
  induction t with
  | leaf x => simp [leaves]
  | node l r ihl _ => simp [leaves, ihl]

end MerkleTree

variable {Leaf Hash : Type}

/-- The root hash of a tree. -/
def MerkleHash.root (M : MerkleHash Leaf Hash) : MerkleTree Leaf → Hash
  | .leaf x => M.hleaf x
  | .node l r => M.hnode (M.root l) (M.root r)

/-! ## Inclusion paths -/

/-- One step of an inclusion path: the sibling hash, and which side it is
on. -/
structure MerkleStep (Hash : Type) where
  /-- The sibling's hash at this level. -/
  sibling : Hash
  /-- `true` when the sibling is the *left* child. -/
  siblingOnLeft : Bool
deriving Repr

/-- An inclusion path: siblings from the leaf up to the root.  Never
called a *witness* (§3.2). -/
abbrev MerklePath (Hash : Type) := List (MerkleStep Hash)

/-- Fold one step of a path into the running hash. -/
def MerkleHash.step (M : MerkleHash Leaf Hash) (h : Hash) (s : MerkleStep Hash) : Hash :=
  if s.siblingOnLeft then M.hnode s.sibling h else M.hnode h s.sibling

/-- Recompute the root implied by a leaf and an inclusion path. -/
def MerkleHash.applyPath (M : MerkleHash Leaf Hash) (h : Hash) (p : MerklePath Hash) : Hash :=
  p.foldl M.step h

@[simp] theorem MerkleHash.applyPath_nil (M : MerkleHash Leaf Hash) (h : Hash) :
    M.applyPath h [] = h := rfl

theorem MerkleHash.applyPath_append (M : MerkleHash Leaf Hash) (h : Hash)
    (p : MerklePath Hash) (s : MerkleStep Hash) :
    M.applyPath h (p ++ [s]) = M.step (M.applyPath h p) s := by
  simp [applyPath, List.foldl_append]

/-- The check a verifier runs: does this leaf, with this path, reproduce
the published root? -/
def MerkleHash.verifyInclusion [DecidableEq Hash] (M : MerkleHash Leaf Hash)
    (root : Hash) (x : Leaf) (p : MerklePath Hash) : Bool :=
  M.applyPath (M.hleaf x) p == root

/-- A nonempty path always lands on an interior-node hash. -/
theorem MerkleHash.applyPath_eq_node (M : MerkleHash Leaf Hash) (h : Hash)
    {p : MerklePath Hash} (hp : p ≠ []) : ∃ a b, M.applyPath h p = M.hnode a b := by
  induction p using List.reverseRecOn with
  | nil => exact absurd rfl hp
  | append_singleton q s _ =>
    rw [M.applyPath_append]
    by_cases hs : s.siblingOnLeft
    · exact ⟨s.sibling, M.applyPath h q, by simp [step, hs]⟩
    · exact ⟨M.applyPath h q, s.sibling, by simp [step, hs]⟩

/-- **Inclusion proofs are sound.** A path that recomputes the root of a
tree proves that the leaf is genuinely in that tree — an archiver cannot
answer a challenge for an entry it left out. -/
theorem inclusion_sound (M : MerkleHash Leaf Hash) {t : MerkleTree Leaf} {x : Leaf}
    {p : MerklePath Hash} (h : M.applyPath (M.hleaf x) p = M.root t) : x ∈ t.leaves := by
  induction p using List.reverseRecOn generalizing t with
  | nil =>
    cases t with
    | leaf y =>
      simp only [MerkleHash.applyPath_nil, MerkleHash.root] at h
      simp [MerkleTree.leaves, M.hleaf_inj h]
    | node l r =>
      simp only [MerkleHash.applyPath_nil, MerkleHash.root] at h
      exact absurd h.symm (M.node_ne_leaf _ _ _)
  | append_singleton q s ih =>
    cases t with
    | leaf y =>
      obtain ⟨a, b, hab⟩ := M.applyPath_eq_node (M.hleaf x) (p := q ++ [s]) (by simp)
      rw [hab] at h
      exact absurd h (M.node_ne_leaf _ _ _)
    | node l r =>
      rw [M.applyPath_append] at h
      simp only [MerkleHash.root, MerkleHash.step] at h
      by_cases hs : s.siblingOnLeft
      · rw [if_pos hs] at h
        obtain ⟨-, h2⟩ := M.hnode_inj _ _ _ _ h
        exact List.mem_append_right _ (ih h2)
      · rw [if_neg hs] at h
        obtain ⟨h1, -⟩ := M.hnode_inj _ _ _ _ h
        exact List.mem_append_left _ (ih h1)

/-- **Inclusion proofs are complete.** Every leaf of a tree has a path,
so an honest archiver can always answer the coverage challenge. -/
theorem inclusion_complete (M : MerkleHash Leaf Hash) {t : MerkleTree Leaf} {x : Leaf}
    (h : x ∈ t.leaves) : ∃ p : MerklePath Hash, M.applyPath (M.hleaf x) p = M.root t := by
  induction t with
  | leaf y =>
    simp only [MerkleTree.leaves, List.mem_singleton] at h
    exact ⟨[], by simp [MerkleHash.root, h]⟩
  | node l r ihl ihr =>
    simp only [MerkleTree.leaves, List.mem_append] at h
    rcases h with hl | hr
    · obtain ⟨p, hp⟩ := ihl hl
      exact ⟨p ++ [⟨M.root r, false⟩], by
        rw [M.applyPath_append, hp]; simp [MerkleHash.step, MerkleHash.root]⟩
    · obtain ⟨p, hp⟩ := ihr hr
      exact ⟨p ++ [⟨M.root l, true⟩], by
        rw [M.applyPath_append, hp]; simp [MerkleHash.step, MerkleHash.root]⟩

/-- **A root determines its tree**: dropping, adding or altering a leaf
changes the root. -/
theorem root_inj (M : MerkleHash Leaf Hash) :
    ∀ {t u : MerkleTree Leaf}, M.root t = M.root u → t = u := by
  intro t
  induction t with
  | leaf x =>
    intro u h
    cases u with
    | leaf y => simp only [MerkleHash.root] at h; rw [M.hleaf_inj h]
    | node l r => exact absurd h.symm (M.node_ne_leaf _ _ _)
  | node l r ihl ihr =>
    intro u h
    cases u with
    | leaf y => exact absurd h (M.node_ne_leaf _ _ _)
    | node l' r' =>
      simp only [MerkleHash.root] at h
      obtain ⟨h1, h2⟩ := M.hnode_inj _ _ _ _ h
      rw [ihl h1, ihr h2]

/-! ## Building a tree from a list

The usual bottom-up construction: pair adjacent subtrees, promote an odd
one unchanged, repeat.  The theorem that matters downstream is
`leaves_build`: the tree really carries the list it was built from. -/

/-- One level of pairing. -/
def pairUp : List (MerkleTree Leaf) → List (MerkleTree Leaf)
  | [] => []
  | [t] => [t]
  | a :: b :: rest => .node a b :: pairUp rest

theorem leaves_pairUp (ts : List (MerkleTree Leaf)) :
    (pairUp ts).flatMap MerkleTree.leaves = ts.flatMap MerkleTree.leaves := by
  induction ts using pairUp.induct with
  | case1 => rfl
  | case2 t => rfl
  | case3 a b rest ih => simp [pairUp, MerkleTree.leaves, ih]

theorem pairUp_length_lt {ts : List (MerkleTree Leaf)} (h : 2 ≤ ts.length) :
    (pairUp ts).length < ts.length := by
  induction ts using pairUp.induct with
  | case1 => simp at h
  | case2 t => simp at h
  | case3 a b rest ih =>
    rcases Nat.lt_or_ge rest.length 2 with hr | hr
    · interval_cases hlen : rest.length
      · simp [pairUp, List.length_eq_zero_iff.mp hlen]
      · match rest, hlen with
        | [c], _ => simp [pairUp]
    · have := ih (by simpa using hr)
      simp [pairUp]
      omega

theorem pairUp_ne_nil {ts : List (MerkleTree Leaf)} (h : ts ≠ []) : pairUp ts ≠ [] := by
  match ts with
  | [] => exact absurd rfl h
  | [_] => simp [pairUp]
  | _ :: _ :: _ => simp [pairUp]

/-- Fold a nonempty forest into one tree. -/
def buildFrom : List (MerkleTree Leaf) → Option (MerkleTree Leaf)
  | [] => none
  | [t] => some t
  | a :: b :: rest => buildFrom (pairUp (a :: b :: rest))
termination_by ts => ts.length
decreasing_by
  exact pairUp_length_lt (by simp)

theorem leaves_buildFrom :
    ∀ {ts : List (MerkleTree Leaf)} {t : MerkleTree Leaf}, buildFrom ts = some t →
      t.leaves = ts.flatMap MerkleTree.leaves := by
  intro ts
  induction ts using buildFrom.induct with
  | case1 => intro t h; simp [buildFrom] at h
  | case2 u => intro t h; simp [buildFrom] at h; subst h; simp
  | case3 a b rest ih =>
    intro t h
    rw [buildFrom] at h
    rw [ih h, leaves_pairUp]

/-- The merkle tree of a list of leaves. -/
def build (xs : List Leaf) : Option (MerkleTree Leaf) :=
  buildFrom (xs.map MerkleTree.leaf)

theorem flatMap_leaves_map_leaf (xs : List Leaf) :
    (xs.map MerkleTree.leaf).flatMap MerkleTree.leaves = xs := by
  induction xs with
  | nil => rfl
  | cons a l ih => simp [MerkleTree.leaves, ih]

/-- **The builder is honest**: the tree built from a list has exactly
that list as its leaves, in order. -/
theorem leaves_build {xs : List Leaf} {t : MerkleTree Leaf} (h : build xs = some t) :
    t.leaves = xs := by
  rw [build] at h
  rw [leaves_buildFrom h, flatMap_leaves_map_leaf]

theorem build_eq_none_iff {xs : List Leaf} : build xs = none ↔ xs = [] := by
  constructor
  · intro h
    by_contra hx
    match xs, hx with
    | [], hx => exact hx rfl
    | [a], _ => simp [build, buildFrom] at h
    | a :: b :: rest, _ =>
      have : buildFrom (pairUp ((a :: b :: rest).map MerkleTree.leaf)) = none := by
        rw [build] at h
        simpa [buildFrom] using h
      have hne : pairUp ((a :: b :: rest).map MerkleTree.leaf) ≠ [] :=
        pairUp_ne_nil (by simp)
      -- `buildFrom` of a nonempty forest is never `none`
      exact absurd this (buildFrom_ne_none hne)
  · intro h; subst h; simp [build, buildFrom]
where
  buildFrom_ne_none : ∀ {ts : List (MerkleTree Leaf)}, ts ≠ [] → buildFrom ts ≠ none := by
    intro ts
    induction ts using buildFrom.induct with
    | case1 => intro h; exact absurd rfl h
    | case2 u => intro _; simp [buildFrom]
    | case3 a b rest ih =>
      intro _
      rw [buildFrom]
      exact ih (pairUp_ne_nil (by simp))

end Kant.Urania
