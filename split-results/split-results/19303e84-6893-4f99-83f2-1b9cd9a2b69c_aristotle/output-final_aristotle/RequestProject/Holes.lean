import RequestProject.Main

open scoped Classical

set_option relaxedAutoImplicit false
set_option autoImplicit false

open Lean

/-!
# Shape, holes, and the Monster group

This file reads the *topology* of a `SimpleExpr` (the object language reconstructed in
`Main.lean`).

* **Shape.**  The `shape` of an expression is its bare tree structure with every label
  (de Bruijn index, name, universe level, binder info) forgotten, but with one
  distinction kept: whether a node is an *atom* (`bvar`/`sort`/`const`), an *application*
  (`app`), or a *binder* (`lam`/`forallE`).

* **Holes.**  Each binder is read as a **topological hole**: binding a variable glues the
  bound occurrences back to the binding site, the same way attaching a handle punches a
  hole into a surface.  So the number of holes of an expression is its number of
  *bindings*.  `numHoles` counts exactly the `lam`/`forallE` nodes, and it factors
  through the shape (`numHoles_eq_shape_numHoles`).

* **The Monster has no holes.**  The Monster group, named as a bare constant
  `const `MonsterGroup []`, is an atom: it carries no bindings, hence no holes
  (`monster_no_holes`).  More generally an expression has zero holes exactly when it is
  binder-free (`numHoles_eq_zero_iff`).
-/

namespace SimpleExpr

/-- The **shape** of a `SimpleExpr`: its tree structure with all labels forgotten,
keeping only the three topological kinds of node — atom, application, and binder.  A
binder is the node that introduces a *hole*. -/
inductive Shape where
  /-- `bvar` / `sort` / `const`: a node with no subexpressions. -/
  | atom
  /-- `app`: an application node, with the shapes of its function and argument. -/
  | app (fn arg : Shape)
  /-- `lam` / `forallE`: a binder node — a topological hole — with the shapes of its
  domain and body. -/
  | binder (dom body : Shape)
  deriving Repr, DecidableEq

/-- Extract the bare shape of an expression. -/
def shape : SimpleExpr → Shape
  | .bvar _          => .atom
  | .sort _          => .atom
  | .const _ _       => .atom
  | .app f a         => .app f.shape a.shape
  | .lam _ t b _     => .binder t.shape b.shape
  | .forallE _ t b _ => .binder t.shape b.shape

/-- The number of holes of a *shape*: each `binder` contributes one hole. -/
def Shape.numHoles : Shape → Nat
  | .atom        => 0
  | .app f a     => f.numHoles + a.numHoles
  | .binder d b  => 1 + d.numHoles + b.numHoles

/-- The number of **holes** of an expression: its number of bindings (`lam`/`forallE`),
each read as one topological hole. -/
def numHoles : SimpleExpr → Nat
  | .bvar _          => 0
  | .sort _          => 0
  | .const _ _       => 0
  | .app f a         => f.numHoles + a.numHoles
  | .lam _ t b _     => 1 + t.numHoles + b.numHoles
  | .forallE _ t b _ => 1 + t.numHoles + b.numHoles

/-
The hole count is a property of the shape alone: it factors through `shape`.
-/
theorem numHoles_eq_shape_numHoles (e : SimpleExpr) :
    e.numHoles = e.shape.numHoles := by
  -- By definition of `numHoles`, we have `numHoles e = shape e #holes`.
  induction' e with e ih;
  all_goals simp_all! +arith +decide

/-- An expression is **binder-free** when it contains no `lam`/`forallE` node. -/
def isBinderFree : SimpleExpr → Bool
  | .bvar _          => true
  | .sort _          => true
  | .const _ _       => true
  | .app f a         => f.isBinderFree && a.isBinderFree
  | .lam _ _ _ _     => false
  | .forallE _ _ _ _ => false

/-
An expression has **no holes** exactly when it is binder-free.
-/
theorem numHoles_eq_zero_iff (e : SimpleExpr) :
    e.numHoles = 0 ↔ e.isBinderFree = true := by
  induction e <;> simp +decide [ *, SimpleExpr.numHoles, SimpleExpr.isBinderFree ]

/-- The **Monster group**, named as a bare constant of the object language. -/
def monster : SimpleExpr := .const `MonsterGroup []

/-- Its shape is a single atom. -/
theorem monster_shape : monster.shape = Shape.atom := rfl

/-- **The Monster group has no holes.**  As a bare constant it carries no bindings, so
its topological hole count is zero. -/
theorem monster_no_holes : monster.numHoles = 0 := rfl

/-- Equivalently, the Monster group is binder-free. -/
theorem monster_isBinderFree : monster.isBinderFree = true := rfl

end SimpleExpr