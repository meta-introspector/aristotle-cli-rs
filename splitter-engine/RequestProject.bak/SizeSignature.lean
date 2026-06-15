/-
SizeSignature.lean — grouping objects by their numeric "size signature".

The companion analyser is `RequestProject/SizeFinder.lean` (`sizefinder` executable),
which computes a numeric size signature for every declaration in a Lean environment and
groups together all declarations that share the same size.

This file is the *verified* backbone of that idea. It answers the question:

  "If I have a structure with two elements, each of which is a structure with two elements
   (so four elements, `4 = 2^2`), what are all the other objects with the same size?"

We model an object's shape as a tree (`Shape`): a `leaf` is one atomic element, and a
`node` bundles a list of sub-shapes (the fields of a structure). The *size signature* of a
shape is its number of leaf elements (`size`). Two objects have "the same signature in
number" exactly when their sizes are equal — `sameSize` — which we prove is an equivalence
relation, so the objects are partitioned into size-classes (`SizeClass n`), and finding "all
other objects with the same size" means listing one class.

We also pin down the motivating example: a *uniform* tree with branching `b` and depth `d`
(`uniformTree b d`) has size exactly `b ^ d`, so the depth-2 binary structure has size
`2 ^ 2 = 4`. Finally we explain why "most people just have elements of size two or three or
five": those sizes are *prime*, and a prime size can never be produced by a nontrivial
nesting (`b, d ≥ 2`); prime-sized objects are always flat.
-/
import Mathlib

namespace SizeSignature

/-- A structural shape of an object: `leaf` is a single atomic element; `node cs` is a
structure whose fields are the sub-shapes `cs`. -/
inductive Shape where
  | leaf : Shape
  | node : List Shape → Shape
deriving Inhabited

/-- The size signature of a shape: its number of leaf elements. A `leaf` has size `1`; a
`node` has the sum of the sizes of its fields. -/
def size : Shape → Nat
  | .leaf => 1
  | .node cs => (cs.map size).sum

@[simp] theorem size_leaf : size .leaf = 1 := by simp [size]

@[simp] theorem size_node (cs : List Shape) : size (.node cs) = (cs.map size).sum := by
  rw [size]

/-- A uniform tree with branching factor `b` and depth `d`: at depth `0` it is a single
leaf; at depth `d+1` it is a node with `b` identical depth-`d` children. -/
def uniformTree : Nat → Nat → Shape
  | _, 0 => .leaf
  | b, (d+1) => .node (List.replicate b (uniformTree b d))

/-
The size of a uniform tree with branching `b` and depth `d` is exactly `b ^ d`.
-/
theorem size_uniformTree (b d : Nat) : size (uniformTree b d) = b ^ d := by
  by_contra h;
  -- By definition of size, we have size (uniformTree b (d + 1)) = b * size (uniformTree b d).
  have h_size_succ : ∀ b d, size (uniformTree b (d + 1)) = b * size (uniformTree b d) := by
    intros b d; exact (by
    convert size_node _;
    norm_num [ mul_comm ]);
  exact h ( Nat.recOn d ( by norm_num [ uniformTree ] ) fun n ih => by rw [ h_size_succ, pow_succ', ih ] )

/-
The motivating example: a structure with two elements, each a structure with two
elements, has size `2 ^ 2 = 4`.
-/
theorem size_uniformTree_two_two : size (uniformTree 2 2) = 4 := by
  apply size_uniformTree

/-- Two shapes have the same size signature. -/
def sameSize (a b : Shape) : Prop := size a = size b

theorem sameSize_iff (a b : Shape) : sameSize a b ↔ size a = size b := Iff.rfl

/-
"Same size signature" is an equivalence relation.
-/
theorem sameSize_equivalence : Equivalence sameSize := by
  constructor;
  · exact fun x => rfl;
  · exact fun h => h.symm;
  · exact fun h1 h2 => h1.trans h2

/-- The setoid of objects identified up to size signature. Its classes are exactly the
groups of objects that "have the same size". -/
def sizeSetoid : Setoid Shape := ⟨sameSize, sameSize_equivalence⟩

/-- The size-class of objects with size signature exactly `n` — "all the objects with the
same size". -/
def SizeClass (n : Nat) : Set Shape := {s | size s = n}

theorem mem_sizeClass {n : Nat} {s : Shape} : s ∈ SizeClass n ↔ size s = n := Iff.rfl

/-
Two objects lie in the same size-class iff they have the same size signature.
-/
theorem sameSize_iff_same_class (a b : Shape) :
    sameSize a b ↔ ∀ n, (a ∈ SizeClass n ↔ b ∈ SizeClass n) := by
      simp +decide [ SizeClass, sameSize ]

/-
Distinct size-classes are disjoint.
-/
theorem sizeClass_disjoint {m n : Nat} (h : m ≠ n) :
    Disjoint (SizeClass m) (SizeClass n) := by
      exact Set.disjoint_left.mpr fun x hx hx' => h <| hx.symm.trans hx'

/-
The size-classes cover every object: every shape lies in exactly the class of its size.
-/
theorem iUnion_sizeClass : (⋃ n, SizeClass n) = Set.univ := by
  ext s
  simp [SizeClass]

/-- A prime size can never be produced by a nontrivial (depth `≥ 2`) nesting: the uniform
tree's size `b ^ d` is then a perfect power, hence composite. This is why the common small
sizes `2, 3, 5` (all prime) come from flat structures, not nested ones. (The branching
bound `2 ≤ b` is not needed: a depth `≥ 2` nesting already forces a non-prime size.) -/
theorem not_prime_uniformTree_nested {b d : Nat} (hd : 2 ≤ d) :
    ¬ Nat.Prime (size (uniformTree b d)) := by
  rw [size_uniformTree]
  exact not_irreducible_pow (by linarith)

/-- Concretely, the common small sizes people use are prime. -/
theorem two_three_five_prime :
    Nat.Prime 2 ∧ Nat.Prime 3 ∧ Nat.Prime 5 := by
      norm_num

end SizeSignature