import Mathlib

/-!
# Scratch blocks: editing a formula as a tree

The semantics of `web/js/scratch.js`, the pane in which a formula is edited as
nested blocks rather than as text.  A block is addressed by its *path* — the
list of child indices from the root — and the pane's whole contract is that a
path means the same thing before and after an edit made at it.

What is proved:

* `at?_nil`, `replace_nil` — the empty path is the root, and replacing there
  replaces everything;
* `at?_replace` — replacing at a path and then reading that path gives back
  exactly what was put there;
* `at?_replace_of_disjoint` — an edit inside one child leaves every other
  child, and every path into it, untouched;
* `replace_of_ge_length` — a path that leaves the tree changes nothing.
-/

namespace Hesper.Scratch

/-- An expression tree, stripped to what a path sees: a node and its children. -/
inductive Tree where
  | node (label : String) (kids : List Tree)
  deriving Inhabited

namespace Tree

/-- The children of a node. -/
def kids : Tree → List Tree
  | .node _ ks => ks

/-- The label of a node. -/
def label : Tree → String
  | .node l _ => l

@[simp] theorem kids_node (l : String) (ks : List Tree) : (Tree.node l ks).kids = ks := rfl
@[simp] theorem label_node (l : String) (ks : List Tree) : (Tree.node l ks).label = l := rfl

/-- Induction over a nested tree: a node is settled once its children are. -/
theorem ind {motive : Tree → Prop}
    (h : ∀ (l : String) (ks : List Tree), (∀ k ∈ ks, motive k) → motive (Tree.node l ks)) :
    ∀ t, motive t
  | .node l ks => h l ks fun k hk =>
      have hlt : sizeOf k < sizeOf (Tree.node l ks) :=
        Nat.lt_of_lt_of_le (List.sizeOf_lt_of_mem hk) (by simp)
      ind h k
  termination_by t => sizeOf t
  decreasing_by exact hlt

end Tree

/-- The node at `path`, or `none` when the path leaves the tree. -/
def at? : Tree → List ℕ → Option Tree
  | t, [] => some t
  | t, i :: p => match t.kids[i]? with
      | none => none
      | some k => at? k p

/-- `t` with the node at `path` replaced by `next`. -/
def replace : Tree → List ℕ → Tree → Tree
  | _, [], next => next
  | .node l ks, i :: p, next =>
      if h : i < ks.length then
        .node l (ks.set i (replace ks[i] p next))
      else .node l ks

@[simp] theorem at?_nil (t : Tree) : at? t [] = some t := rfl

@[simp] theorem replace_nil (t next : Tree) : replace t [] next = next := rfl

/-- A path that leaves the tree changes nothing. -/
theorem replace_of_ge_length (l : String) (ks : List Tree) (i : ℕ) (h : ks.length ≤ i)
    (p : List ℕ) (next : Tree) :
    replace (Tree.node l ks) (i :: p) next = Tree.node l ks := by
  rw [replace]
  simp [Nat.not_lt.mpr h]

/-- Reading back what was written: an edit lands exactly at its path. -/
theorem at?_replace : ∀ (t : Tree) (p : List ℕ) (next : Tree),
    (at? t p).isSome = true → at? (replace t p next) p = some next := by
  intro t
  induction t using Tree.ind with
  | _ l ks ih =>
    intro p next hp
    match p with
    | [] => simp
    | i :: p =>
      rw [at?] at hp
      cases hks : ks[i]? with
      | none => simp [hks] at hp
      | some k =>
        obtain ⟨hlen, hval⟩ := List.getElem?_eq_some_iff.mp hks
        have hkid : (at? ks[i] p).isSome = true := by
          simp only [Tree.kids_node, hks] at hp
          rw [hval]
          exact hp
        rw [replace]
        simp only [hlen, dif_pos]
        rw [at?]
        have hset : (Tree.node l (ks.set i (replace ks[i] p next))).kids[i]?
            = some (replace ks[i] p next) := by
          simp [hlen]
        rw [hset]
        exact ih ks[i] (List.getElem_mem hlen) p next hkid

/-- An edit inside one child leaves every path into another child alone. -/
theorem at?_replace_of_disjoint (l : String) (ks : List Tree) {i j : ℕ} (hij : i ≠ j)
    (p q : List ℕ) (next : Tree) :
    at? (replace (Tree.node l ks) (i :: p) next) (j :: q) = at? (Tree.node l ks) (j :: q) := by
  rw [replace]
  by_cases hlen : i < ks.length
  · simp only [hlen, dif_pos]
    rw [at?, at?]
    simp [hij]
  · simp [hlen]

end Hesper.Scratch
