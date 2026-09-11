import RequestProject.Main

open scoped Classical

set_option relaxedAutoImplicit false
set_option autoImplicit false

open Lean

/-!
# A graded system for `SimpleExpr`: what each level can express

This file maps the object language `SimpleExpr` (reconstructed in `Main.lean`) into a
**graded system** and characterizes *what can be expressed by each level*.

The grading is by **nesting depth**: an atom (`bvar`/`sort`/`const`) sits at depth `0`,
and every `app`/`lam`/`forallE` node raises the depth by one over its deepest child.

* `SimpleExpr.depth` — the grade of an expression (its nesting depth).
* `SimpleExpr.isAtom` — the depth-`0` constructors.
* `SimpleExpr.Expressible n e` — the **level-`n` filtration**: `e` can be expressed using
  nesting depth at most `n`, i.e. `e.depth ≤ n`.
* `SimpleExpr.Graded n` — the **graded piece** at level `n`: exactly the expressions of
  depth `= n`.

The "what can be expressed by each level" results are:

* **Level 0 expresses exactly the atoms** (`expressible_zero_iff`, `depth_eq_zero_iff`).
* **The levels form an increasing filtration** (`expressible_mono`,
  `expressible_succ_of`): once expressible at level `n`, an expression is expressible at
  every higher level.
* **Each level is closed under building one more layer** from the previous level:
  `app`/`lam`/`forallE` of level-`n` parts land at level `n+1`
  (`app_expressible_succ`, `lam_expressible_succ`, `forallE_expressible_succ`), and
  conversely a compound node needs at least level `1` (`app_not_expressible_zero` …).
* **The graded pieces partition the language**: every expression lies in exactly one
  piece, namely `Graded e.depth` (`graded_depth`, `graded_disjoint`), and the union of
  all levels is the whole language (`iUnion_expressible`).
* The self-application term from `Main.lean` sits at level `1` (`depth_selfApp`).
-/

namespace SimpleExpr

/-- **The grade of an expression**: its nesting depth.  Atoms have depth `0`; every
compound node is one deeper than its deepest child. -/
def depth : SimpleExpr → Nat
  | .bvar _          => 0
  | .sort _          => 0
  | .const _ _       => 0
  | .app f a         => 1 + max f.depth a.depth
  | .lam _ t b _     => 1 + max t.depth b.depth
  | .forallE _ t b _ => 1 + max t.depth b.depth

/-- The depth-`0` constructors: an **atom** is a leaf node (`bvar`/`sort`/`const`). -/
def isAtom : SimpleExpr → Bool
  | .bvar _          => true
  | .sort _          => true
  | .const _ _       => true
  | .app _ _         => false
  | .lam _ _ _ _     => false
  | .forallE _ _ _ _ => false

/-
**Level 0 expresses exactly the atoms.**  An expression has depth `0` iff it is a
leaf (`bvar`/`sort`/`const`).
-/
theorem depth_eq_zero_iff (e : SimpleExpr) : e.depth = 0 ↔ e.isAtom = true := by
  cases e <;> simp +decide [ SimpleExpr.depth, SimpleExpr.isAtom ]

/-- **The level-`n` filtration.**  `Expressible n e` holds when `e` can be expressed
within nesting depth `n`, i.e. its grade is at most `n`. -/
def Expressible (n : Nat) (e : SimpleExpr) : Prop := e.depth ≤ n

/-
**Level 0 expresses exactly the atoms** (filtration form).
-/
theorem expressible_zero_iff (e : SimpleExpr) :
    Expressible 0 e ↔ e.isAtom = true := by
  cases e <;> simp_all +decide [ depth, Expressible ]; all_goals rfl

/-
**The levels are an increasing filtration**: expressibility at level `m` implies
expressibility at every higher level `n ≥ m`.
-/
theorem expressible_mono {m n : Nat} (h : m ≤ n) {e : SimpleExpr} :
    Expressible m e → Expressible n e := by
  exact fun h' => le_trans h' h

/-
Anything expressible at level `n` is expressible at level `n + 1`.
-/
theorem expressible_succ_of {n : Nat} {e : SimpleExpr} :
    Expressible n e → Expressible (n + 1) e := by
  exact fun h => Nat.le_succ_of_le h

/-- Every expression is expressible at its own grade. -/
theorem expressible_depth (e : SimpleExpr) : Expressible e.depth e := le_refl _

/-
**Closure of level `n+1` under application.**  Applying a level-`n` function to a
level-`n` argument yields a level-`(n+1)` expression.
-/
theorem app_expressible_succ {n : Nat} {f a : SimpleExpr}
    (hf : Expressible n f) (ha : Expressible n a) :
    Expressible (n + 1) (.app f a) := by
  have hDepth_computed : 1 + max f.depth a.depth ≤ n + 1 := by
    rw [ add_comm ] ; gcongr ; aesop;
  exact hDepth_computed

/-
**Closure of level `n+1` under `lam`.**
-/
theorem lam_expressible_succ {n : Nat} {nm : Name} {t b : SimpleExpr} {bi : BinderInfo}
    (ht : Expressible n t) (hb : Expressible n b) :
    Expressible (n + 1) (.lam nm t b bi) := by
  exact Nat.le_trans ( Nat.add_le_add_left ( max_le ht hb ) _ ) ( by simp +arith +decide )

/-
**Closure of level `n+1` under `forallE`.**
-/
theorem forallE_expressible_succ {n : Nat} {nm : Name} {t b : SimpleExpr} {bi : BinderInfo}
    (ht : Expressible n t) (hb : Expressible n b) :
    Expressible (n + 1) (.forallE nm t b bi) := by
  unfold Expressible at *;
  exact ( by rw [ show ( forallE nm t b bi ).depth = 1 + Max.max t.depth b.depth by rfl ] ; omega )

/-
A compound application node cannot be expressed at level `0`: building one layer
requires at least level `1`.
-/
theorem app_not_expressible_zero (f a : SimpleExpr) :
    ¬ Expressible 0 (.app f a) := by
  unfold Expressible;
  simp +decide [ SimpleExpr.depth ]

/-
A `lam` node cannot be expressed at level `0`.
-/
theorem lam_not_expressible_zero (nm : Name) (t b : SimpleExpr) (bi : BinderInfo) :
    ¬ Expressible 0 (.lam nm t b bi) := by
  grind +locals

/-
A `forallE` node cannot be expressed at level `0`.
-/
theorem forallE_not_expressible_zero (nm : Name) (t b : SimpleExpr) (bi : BinderInfo) :
    ¬ Expressible 0 (.forallE nm t b bi) := by
  unfold Expressible; simp +decide [ SimpleExpr.depth ]

/-- **The graded piece at level `n`**: the expressions whose grade is exactly `n`. -/
def Graded (n : Nat) (e : SimpleExpr) : Prop := e.depth = n

/-- Every expression lies in the graded piece indexed by its own grade. -/
theorem graded_depth (e : SimpleExpr) : Graded e.depth e := rfl

/-
**The graded pieces are disjoint**: an expression cannot lie in two distinct
pieces.
-/
theorem graded_disjoint {m n : Nat} {e : SimpleExpr}
    (hm : Graded m e) (hn : Graded n e) : m = n := by
  exact hm.symm.trans hn

/-- **The union of all levels is the whole language**: every expression is expressible at
some (indeed at its own) level. -/
theorem iUnion_expressible (e : SimpleExpr) : ∃ n, Expressible n e :=
  ⟨e.depth, le_refl _⟩

/-- A graded piece is contained in its filtration level. -/
theorem graded_subset_expressible {n : Nat} {e : SimpleExpr}
    (h : Graded n e) : Expressible n e := le_of_eq h

/-- The self-application term from `Main.lean` sits at **level 1**: it is a single
application of two atoms. -/
theorem depth_selfApp : selfApp.depth = 1 := rfl

end SimpleExpr