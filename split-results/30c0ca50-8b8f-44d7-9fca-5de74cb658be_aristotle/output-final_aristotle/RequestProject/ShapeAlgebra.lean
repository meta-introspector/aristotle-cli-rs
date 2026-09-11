import Mathlib
import RequestProject.MonsterMoonshine

/-!
# Shape Algebra — a computable Clifford invariant of syntax-tree shapes

This module is the **formal Clifford backbone** for the shape-similarity analyzer.
It introduces:

* `Shape` — an abstract model of a Lean `Expr` tree (a labelled rose tree:
  every node carries a natural-number `label` standing for a constant/variable
  identifier, together with an ordered list of `children`).
* A genuinely *computable* scalar invariant `cliffordTrace`, derived from the
  Clifford algebra `Cl(0,15)` of `RequestProject.MonsterMoonshine`: each node of
  arity `k` is sent to the blade `bladeOf k`, and we accumulate the **quadratic
  form norm** `geomSign S S` (the scalar part of `eₛ · eₛ`) over every node.

Because the per-node contribution depends only on the node's *arity* and the trace
is a plain sum, `cliffordTrace` is automatically invariant under any reordering of
independent subtrees and under any relabelling of constants/variables.  This makes
it a sound *secondary filter* for the rolling-hash analyzer: two trees with
different Clifford traces cannot be structurally isomorphic, so any hash collision
that claims they are similar is a provable false positive (see
`RequestProject.ShapeFinder`).

Everything here is computable (`#eval`-able) and `sorry`-free.
-/

namespace ShapeAlgebra

open Moonshine

/-- An abstract syntax-tree **shape**: a labelled rose tree.  `label` models a
constant/variable identifier; `children` models the ordered argument subtrees of
a Lean `Expr` node. -/
inductive Shape where
  | mk (label : Nat) (children : List Shape)
deriving Repr, Inhabited

namespace Shape

/-- The label (head constant/variable id) of a shape's root node. -/
def label : Shape → Nat
  | mk l _ => l

/-- The ordered children (argument subtrees) of a shape's root node. -/
def children : Shape → List Shape
  | mk _ cs => cs

/-- The arity (number of children) of a shape's root node. -/
def arity (t : Shape) : Nat := t.children.length

/-- The total number of nodes in a shape. -/
def size : Shape → Nat
  | mk _ cs => 1 + (cs.map size).sum

@[simp] theorem label_mk (l : Nat) (cs : List Shape) : (mk l cs).label = l := rfl
@[simp] theorem children_mk (l : Nat) (cs : List Shape) : (mk l cs).children = cs := rfl
@[simp] theorem arity_mk (l : Nat) (cs : List Shape) : (mk l cs).arity = cs.length := rfl

end Shape

/-! ## The Clifford blade attached to a node -/

/-- The Clifford blade of a node of arity `k`: the generators `e₀ … e_{k-1}`
(capped at the 15 Oggioral generators of `Cl(0,15)`). -/
def bladeOf (k : Nat) : Moonshine.Blade :=
  Finset.univ.filter (fun i : Fin 15 => i.val < k)

/-
The grade of `bladeOf k` is `min k 15`.
-/
theorem grade_bladeOf (k : Nat) : Moonshine.grade (bladeOf k) = min k 15 := by
  convert Finset.card_range k ▸ Finset.card_filter ( fun i => i < 15 ) ( Finset.range ( min k 15 ) ) using 1;
  · convert Finset.card_image_of_injective _ ( show Function.Injective ( fun i : Fin 15 => i.val ) from fun a b h => by simpa [ Fin.ext_iff ] using h ) using 1;
    rotate_right;
    exact Finset.univ.filter fun i => i.val < k;
    · rw [ Finset.card_image_of_injective _ fun a b h => by simpa [ Fin.ext_iff ] using h ];
      convert rfl;
    · refine' Finset.card_bij ( fun x hx => ⟨ x, by aesop ⟩ ) _ _ _ <;> aesop;
  · rcases k with ( _ | _ | _ | _ | _ | _ | _ | _ | _ | _ | _ | _ | _ | _ | _ | _ | k ) <;> simp +arith +decide

/-! ## The computable Clifford quadratic-form invariant -/

/-- The **Clifford norm of a single node** of arity `k`: the scalar part of the
geometric product `eₛ · eₛ` for `S = bladeOf k`, i.e. the value `±1` of the
quadratic form on that blade.  This is a verified, fully computable `Int`. -/
def nodeNorm (k : Nat) : Int :=
  Moonshine.geomSign (bladeOf k) (bladeOf k)

/-- The **Clifford trace** of a shape: the sum of `nodeNorm` over every node of
the tree.  Since it is a sum of per-node arities, it is invariant under
permutation of independent subtrees and under relabelling (proved in
`RequestProject.ShapeFinder`). -/
def cliffordTrace : Shape → Int
  | .mk _ cs => nodeNorm cs.length + (cs.map cliffordTrace).sum

@[simp] theorem cliffordTrace_mk (l : Nat) (cs : List Shape) :
    cliffordTrace (.mk l cs) = nodeNorm cs.length + (cs.map cliffordTrace).sum := by
  rw [cliffordTrace]

/-- A leaf's Clifford trace is the norm of the scalar (arity-0) blade. -/
theorem cliffordTrace_leaf (l : Nat) : cliffordTrace (.mk l []) = nodeNorm 0 := by
  rw [cliffordTrace]; simp

/-
The norm of the scalar blade (`e_∅ · e_∅`) is `1`.
-/
@[simp] theorem nodeNorm_zero : nodeNorm 0 = 1 := by
  native_decide +revert

/-! ## Structural complexity classes -/

/-- The **structural complexity class** of a shape is its Clifford trace.  This is
the verified invariant used to categorize incoming third-party code into the
structural families discovered by the analyzer. -/
def classify (t : Shape) : Int := cliffordTrace t

/-- Categorize an unknown incoming shape into a structural complexity class.  This
is the verified entry point used to slot third-party packages into existing
Mathlib structural families. -/
def categorize (t : Shape) : Int := classify t

@[simp] theorem categorize_eq (t : Shape) : categorize t = cliffordTrace t := rfl

/-! ## Sanity checks (computable) -/

-- A root with two leaves, under two different labellings + child orderings:
-- the Clifford trace is the same.
example : cliffordTrace (.mk 0 [.mk 9 [], .mk 3 []]) =
    cliffordTrace (.mk 7 [.mk 3 [], .mk 9 []]) := by native_decide

end ShapeAlgebra