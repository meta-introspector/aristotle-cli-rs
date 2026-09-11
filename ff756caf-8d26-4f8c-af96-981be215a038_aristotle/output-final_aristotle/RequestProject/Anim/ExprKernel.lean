import Mathlib
import RequestProject.Anim.Expr

/-!
# The formula kernel: one evaluator, two arithmetics

`RequestProject/Anim/Expr.lean` states the meaning of a hesper formula over the
mathematical reals.  That statement is *noncomputable*: `Expr.eval` cannot be
run, it can only be reasoned about, and the shipped JavaScript is checked
against it by test.

This module factors that evaluator so it can also be **run**.  The recursion is
written once, over an arbitrary carrier `F` together with a table `Ops F` of the
primitive operations; the real semantics and the IEEE-double semantics are then
two instances of the same function:

* `Tree.eval (realOps I fn)` is `Expr.eval` (`Kernel.eval_toExpr`), and
* `Tree.eval floatOps` is computable, evaluates in `Float`, and is the model the
  shipped WebAssembly kernel implements.

Three things are worth being blunt about.

**`Float` is opaque, all the way down.**  `Float.add`, `Float.mul`, `Float.lt`
and `Float.sin` alike are runtime primitives with no kernel-reducible
definition, and Lean's library contains no lemma relating any of them to the
corresponding operation on `ℝ`.  So *no* statement of the form "the `Float`
evaluator agrees with the `ℝ` evaluator" is derivable outright — not for `sin`,
and not for `+` either.  Everything numeric here is therefore stated relative to
an explicit embedding `φ : Float → ℝ` and explicit hypotheses about how the
primitives behave under it (`Refines`, `EvalExact`).  Those hypotheses are
assumptions about the platform's floating point, not proved facts.  They are
gathered into named structures precisely so a reader can see the whole of what
is being taken on faith.

**What *is* unconditional** is everything structural: that the two evaluators
are the same recursion (`eval_toExpr`), that a refinement of the primitives
lifts to a refinement of whole expressions (`eval_map_of_refines`), that
pointwise exactness suffices (`eval_map_of_exact`), and — in
`ExprFlat.lean` — that the flat program the kernel actually executes computes
the tree's value.

**The `Refines` bundle is satisfiable.**  `refines_id` exhibits an instance, so
the conditional theorems are not vacuous by construction.  It is *not* satisfied
by real IEEE arithmetic, which rounds; `EvalExact` is the per-expression version
that genuinely can hold for a `Float` evaluation and is the honest form of the
claim for the arithmetic fragment.

## Divergences from the `ℝ` spec, named rather than hidden

* **Division by zero.**  Mathlib's `ℝ` has `a / 0 = 0`; IEEE has `±∞`/`NaN`; the
  studio's shader dialect returns `0`.  `floatOps` models **IEEE**, so `binop
  div` is genuinely a different function from `BinOp.apply div` at `b = 0`.  No
  `Refines`/`EvalExact` hypothesis can hold at such a node, which is exactly the
  carve-out being asked for: the side condition is visible in the hypothesis
  rather than swept into a tolerance.
* **Comparisons.**  `BinOp.ofBool` over `ℝ` decides an exact relation; over
  `Float` a one-ulp difference flips the boolean and the value then differs by
  an arbitrary amount, not by an error bound.  `EvalExact` treats a comparison
  node like any other: its equation must hold *at that node*, which for a
  comparison means the two orderings agree there.  Nothing absorbs it.
* **`mod`.**  The `ℝ` spec uses `a - b * ⌊a / b⌋`; `floatOps` uses the same
  formula in `Float`.  `web/js/expr.js` instead computes `((a % b) + b) % b`,
  so the kernel is here *closer to the specification* than the interpreter is,
  and the two can differ in the last bits.  Named, not hidden.
* **Truthiness of `if`.**  `floatOps.test` is JavaScript's, `!x.isNaN && x != 0`,
  because that is what the shipped interpreter does: a `NaN` condition takes the
  *else* branch.  On any value that has a real meaning this coincides with the
  specification's `≠ 0`; at `NaN` the specification says nothing, and a
  `Refines`/`EvalExact` hypothesis cannot hold there anyway.
-/

namespace Hesper.Anim
namespace Kernel

/-- The primitive operations an evaluator needs, as data.

Builtins are addressed by index rather than by name: the kernel that ships never
sees a string, and `Tree.toExpr` puts the names back when the tree is read as a
`Hesper.Anim.Expr`. -/
structure Ops (F : Type) where
  /-- Meaning of a binary operator. -/
  binop : BinOp → F → F → F
  /-- Unary minus. -/
  neg : F → F
  /-- Truthiness, used by `if(c, a, b)`. -/
  test : F → Bool
  /-- Unary builtins, by index. -/
  un : Nat → F → F
  /-- Binary builtins, by index. -/
  bin : Nat → F → F → F
  /-- Ternary builtins, by index. -/
  tern : Nat → F → F → F → F

/-- The abstract syntax the kernel executes: `Hesper.Anim.Expr` with variables
and builtins addressed by index, over an arbitrary carrier. -/
inductive Tree (F : Type)
  /-- A literal. -/
  | num : F → Tree F
  /-- A variable, by slot index. -/
  | var : Nat → Tree F
  /-- Unary minus. -/
  | neg : Tree F → Tree F
  /-- A binary operator. -/
  | bin : BinOp → Tree F → Tree F → Tree F
  /-- `if(c, a, b)`. -/
  | cond : Tree F → Tree F → Tree F → Tree F
  /-- A unary builtin, by index. -/
  | un : Nat → Tree F → Tree F
  /-- A binary builtin, by index. -/
  | bin₂ : Nat → Tree F → Tree F → Tree F
  /-- A ternary builtin, by index. -/
  | tern : Nat → Tree F → Tree F → Tree F → Tree F
  deriving Repr

namespace Tree

variable {F G : Type}

/-- Evaluate a tree against a table of primitives and an environment. -/
def eval (O : Ops F) (env : Nat → F) : Tree F → F
  | .num v => v
  | .var i => env i
  | .neg a => O.neg (eval O env a)
  | .bin op a b => O.binop op (eval O env a) (eval O env b)
  | .cond c a b => if O.test (eval O env c) then eval O env a else eval O env b
  | .un f a => O.un f (eval O env a)
  | .bin₂ f a b => O.bin f (eval O env a) (eval O env b)
  | .tern f a b c => O.tern f (eval O env a) (eval O env b) (eval O env c)

/-- Reinterpret the literals of a tree. -/
def map (φ : F → G) : Tree F → Tree G
  | .num v => .num (φ v)
  | .var i => .var i
  | .neg a => .neg (map φ a)
  | .bin op a b => .bin op (map φ a) (map φ b)
  | .cond c a b => .cond (map φ c) (map φ a) (map φ b)
  | .un f a => .un f (map φ a)
  | .bin₂ f a b => .bin₂ f (map φ a) (map φ b)
  | .tern f a b c => .tern f (map φ a) (map φ b) (map φ c)

/-- The variable slots a tree can read. -/
def slots : Tree F → Finset Nat
  | .num _ => ∅
  | .var i => {i}
  | .neg a => a.slots
  | .bin _ a b => a.slots ∪ b.slots
  | .cond c a b => c.slots ∪ a.slots ∪ b.slots
  | .un _ a => a.slots
  | .bin₂ _ a b => a.slots ∪ b.slots
  | .tern _ a b c => a.slots ∪ b.slots ∪ c.slots

/-- The highest slot index a tree reads, plus one: how many variables the
kernel's caller has to supply. -/
def arity : Tree F → Nat
  | .num _ => 0
  | .var i => i + 1
  | .neg a => a.arity
  | .bin _ a b => max a.arity b.arity
  | .cond c a b => max (max c.arity a.arity) b.arity
  | .un _ a => a.arity
  | .bin₂ _ a b => max a.arity b.arity
  | .tern _ a b c => max (max a.arity b.arity) c.arity

/-- Evaluation reads the environment only at the slots the tree mentions. -/
theorem eval_congr (O : Ops F) (t : Tree F) {e₁ e₂ : Nat → F}
    (h : ∀ i ∈ t.slots, e₁ i = e₂ i) : eval O e₁ t = eval O e₂ t := by
  induction t with
  | num v => rfl
  | var i => exact h i (by simp [slots])
  | neg a ih => simp [eval, ih fun i hi => h i (by simpa [slots] using hi)]
  | bin op a b iha ihb =>
    simp only [eval]
    rw [iha fun i hi => h i (by simp [slots, hi]), ihb fun i hi => h i (by simp [slots, hi])]
  | cond c a b ihc iha ihb =>
    simp only [eval]
    rw [ihc fun i hi => h i (by simp [slots, hi]), iha fun i hi => h i (by simp [slots, hi]),
      ihb fun i hi => h i (by simp [slots, hi])]
  | un f a ih => simp [eval, ih fun i hi => h i (by simpa [slots] using hi)]
  | bin₂ f a b iha ihb =>
    simp only [eval]
    rw [iha fun i hi => h i (by simp [slots, hi]), ihb fun i hi => h i (by simp [slots, hi])]
  | tern f a b c iha ihb ihc =>
    simp only [eval]
    rw [iha fun i hi => h i (by simp [slots, hi]), ihb fun i hi => h i (by simp [slots, hi]),
      ihc fun i hi => h i (by simp [slots, hi])]

/-- Every slot a tree reads is below its `arity`. -/
theorem lt_arity_of_mem_slots (t : Tree F) {i : Nat} (hi : i ∈ t.slots) : i < t.arity := by
  induction t with
  | num v => simp [slots] at hi
  | var j => simp [slots, arity] at hi ⊢; omega
  | neg a ih => exact ih (by simpa [slots] using hi)
  | bin op a b iha ihb =>
    simp only [slots, Finset.mem_union] at hi
    rcases hi with h | h
    · exact lt_of_lt_of_le (iha h) (le_max_left _ _)
    · exact lt_of_lt_of_le (ihb h) (le_max_right _ _)
  | cond c a b ihc iha ihb =>
    simp only [slots, Finset.mem_union] at hi
    rcases hi with (h | h) | h
    · exact lt_of_lt_of_le (ihc h) (le_trans (le_max_left _ _) (le_max_left _ _))
    · exact lt_of_lt_of_le (iha h) (le_trans (le_max_right _ _) (le_max_left _ _))
    · exact lt_of_lt_of_le (ihb h) (le_max_right _ _)
  | un f a ih => exact ih (by simpa [slots] using hi)
  | bin₂ f a b iha ihb =>
    simp only [slots, Finset.mem_union] at hi
    rcases hi with h | h
    · exact lt_of_lt_of_le (iha h) (le_max_left _ _)
    · exact lt_of_lt_of_le (ihb h) (le_max_right _ _)
  | tern f a b c iha ihb ihc =>
    simp only [slots, Finset.mem_union] at hi
    rcases hi with (h | h) | h
    · exact lt_of_lt_of_le (iha h) (le_trans (le_max_left _ _) (le_max_left _ _))
    · exact lt_of_lt_of_le (ihb h) (le_trans (le_max_right _ _) (le_max_left _ _))
    · exact lt_of_lt_of_le (ihc h) (le_max_right _ _)

end Tree

/-! ## Refinement of one arithmetic by another -/

/-- `Refines O R φ` says the embedding `φ` turns every primitive of `O` into the
corresponding primitive of `R`, exactly.

For `O = floatOps` and `R = realOps` this is *the* floating-point assumption:
"every operation is computed with no rounding error at all".  That is false of
real IEEE hardware, which is why the per-expression `Tree.EvalExact` below is
the form actually used to make claims about `Float`; `Refines` is the clean
global version, satisfiable (`refines_id`) and useful for reasoning. -/
structure Refines {F : Type} (O : Ops F) (R : Ops ℝ) (φ : F → ℝ) : Prop where
  /-- Binary operators are computed exactly. -/
  binop : ∀ op a b, φ (O.binop op a b) = R.binop op (φ a) (φ b)
  /-- Negation is computed exactly. -/
  neg : ∀ a, φ (O.neg a) = R.neg (φ a)
  /-- The two truthiness tests agree. -/
  test : ∀ a, O.test a = R.test (φ a)
  /-- Unary builtins are computed exactly. -/
  un : ∀ i a, φ (O.un i a) = R.un i (φ a)
  /-- Binary builtins are computed exactly. -/
  bin : ∀ i a b, φ (O.bin i a b) = R.bin i (φ a) (φ b)
  /-- Ternary builtins are computed exactly. -/
  tern : ∀ i a b c, φ (O.tern i a b c) = R.tern i (φ a) (φ b) (φ c)

/-- The hypothesis bundle is inhabited: the real arithmetic refines itself.  So
every theorem stated under `Refines` has at least one non-vacuous instance. -/
theorem refines_id (R : Ops ℝ) : Refines R R id :=
  { binop := fun _ _ _ => rfl, neg := fun _ => rfl, test := fun _ => rfl,
    un := fun _ _ => rfl, bin := fun _ _ _ => rfl, tern := fun _ _ _ _ => rfl }

namespace Tree

variable {F : Type}

/-- If the primitives refine, so does evaluation of any expression. -/
theorem eval_map_of_refines {O : Ops F} {R : Ops ℝ} {φ : F → ℝ} (h : Refines O R φ)
    (env : Nat → F) (t : Tree F) :
    φ (eval O env t) = eval R (fun i => φ (env i)) (t.map φ) := by
  induction t with
  | num v => rfl
  | var i => rfl
  | neg a ih => simp only [map, eval, h.neg, ih]
  | bin op a b iha ihb => simp only [map, eval, h.binop, iha, ihb]
  | cond c a b ihc iha ihb =>
    simp only [map, eval, ← ihc, ← h.test]
    by_cases hc : O.test (eval O env c) = true
    · simp [hc, iha]
    · simp [hc, ihb]
  | un f a ih => simp only [map, eval, h.un, ih]
  | bin₂ f a b iha ihb => simp only [map, eval, h.bin, iha, ihb]
  | tern f a b c iha ihb ihc => simp only [map, eval, h.tern, iha, ihb, ihc]

/-- `EvalExact O R φ env t` says that *at the values this evaluation actually
produces*, every node of `t` is computed exactly: the float result of each
operation embeds to the real result of the same operation on the embedded
arguments, and each `if` takes the same branch under both.

This is the honest per-expression form of the correspondence.  It can hold for
genuine IEEE arithmetic — integer-valued arithmetic within `2^53`, a comparison
that is not near a tie — and it cannot hold at a node that rounds, divides by
zero, or straddles a tie.  Checking it for a given formula is a finite side
condition, not a leap of faith. -/
def EvalExact (O : Ops F) (R : Ops ℝ) (φ : F → ℝ) (env : Nat → F) : Tree F → Prop
  | .num _ => True
  | .var _ => True
  | .neg a => EvalExact O R φ env a ∧ φ (O.neg (eval O env a)) = R.neg (φ (eval O env a))
  | .bin op a b => EvalExact O R φ env a ∧ EvalExact O R φ env b ∧
      φ (O.binop op (eval O env a) (eval O env b))
        = R.binop op (φ (eval O env a)) (φ (eval O env b))
  | .cond c a b => EvalExact O R φ env c ∧ EvalExact O R φ env a ∧ EvalExact O R φ env b ∧
      O.test (eval O env c) = R.test (φ (eval O env c))
  | .un f a => EvalExact O R φ env a ∧
      φ (O.un f (eval O env a)) = R.un f (φ (eval O env a))
  | .bin₂ f a b => EvalExact O R φ env a ∧ EvalExact O R φ env b ∧
      φ (O.bin f (eval O env a) (eval O env b))
        = R.bin f (φ (eval O env a)) (φ (eval O env b))
  | .tern f a b c => EvalExact O R φ env a ∧ EvalExact O R φ env b ∧ EvalExact O R φ env c ∧
      φ (O.tern f (eval O env a) (eval O env b) (eval O env c))
        = R.tern f (φ (eval O env a)) (φ (eval O env b)) (φ (eval O env c))

/-- Pointwise exactness is enough: if no node of this evaluation rounds, the
computed value embeds to the value the real-valued specification gives. -/
theorem eval_map_of_exact {O : Ops F} {R : Ops ℝ} {φ : F → ℝ} (env : Nat → F) :
    ∀ t : Tree F, EvalExact O R φ env t →
      φ (eval O env t) = eval R (fun i => φ (env i)) (t.map φ)
  | .num _, _ => rfl
  | .var _, _ => rfl
  | .neg a, h => by
      have iha := eval_map_of_exact env a h.1
      simp only [map, eval, h.2, iha]
  | .bin op a b, h => by
      have iha := eval_map_of_exact env a h.1
      have ihb := eval_map_of_exact env b h.2.1
      simp only [map, eval, h.2.2, iha, ihb]
  | .cond c a b, h => by
      have ihc := eval_map_of_exact env c h.1
      have iha := eval_map_of_exact env a h.2.1
      have ihb := eval_map_of_exact env b h.2.2.1
      simp only [map, eval, ← ihc, ← h.2.2.2]
      by_cases hc : O.test (eval O env c) = true
      · simp [hc, iha]
      · simp [hc, ihb]
  | .un f a, h => by
      have iha := eval_map_of_exact env a h.1
      simp only [map, eval, h.2, iha]
  | .bin₂ f a b, h => by
      have iha := eval_map_of_exact env a h.1
      have ihb := eval_map_of_exact env b h.2.1
      simp only [map, eval, h.2.2, iha, ihb]
  | .tern f a b c, h => by
      have iha := eval_map_of_exact env a h.1
      have ihb := eval_map_of_exact env b h.2.1
      have ihc := eval_map_of_exact env c h.2.2.1
      simp only [map, eval, h.2.2.2, iha, ihb, ihc]

/-- A globally exact arithmetic is exact at every node of every expression, so
`Refines` is the special case of `EvalExact` that holds uniformly. -/
theorem evalExact_of_refines {O : Ops F} {R : Ops ℝ} {φ : F → ℝ} (h : Refines O R φ)
    (env : Nat → F) : ∀ t : Tree F, EvalExact O R φ env t
  | .num _ => trivial
  | .var _ => trivial
  | .neg a => ⟨evalExact_of_refines h env a, h.neg _⟩
  | .bin _ a b => ⟨evalExact_of_refines h env a, evalExact_of_refines h env b, h.binop _ _ _⟩
  | .cond c a b => ⟨evalExact_of_refines h env c, evalExact_of_refines h env a,
      evalExact_of_refines h env b, h.test _⟩
  | .un _ a => ⟨evalExact_of_refines h env a, h.un _ _⟩
  | .bin₂ _ a b => ⟨evalExact_of_refines h env a, evalExact_of_refines h env b, h.bin _ _ _⟩
  | .tern _ a b c => ⟨evalExact_of_refines h env a, evalExact_of_refines h env b,
      evalExact_of_refines h env c, h.tern _ _ _ _⟩

end Tree

/-! ## The real instance: the kernel's recursion *is* `Expr.eval` -/

/-- The real-valued primitives: exactly the ones `Hesper.Anim.Expr.eval` uses,
with builtins looked up through the name table `fn`. -/
noncomputable def realOps (I : Interp) (fn : Nat → String) : Ops ℝ where
  binop := BinOp.apply
  neg := fun a => -a
  test := fun a => decide (a ≠ 0)
  un := fun i => I.un (fn i)
  bin := fun i => I.bin (fn i)
  tern := fun i => I.tern (fn i)

namespace Tree

/-- Read an indexed tree back as a `Hesper.Anim.Expr`, restoring the names. -/
def toExpr (vn fn : Nat → String) : Tree ℝ → Expr
  | .num v => .num v
  | .var i => .var (vn i)
  | .neg a => .neg (toExpr vn fn a)
  | .bin op a b => .bin op (toExpr vn fn a) (toExpr vn fn b)
  | .cond c a b => .cond (toExpr vn fn c) (toExpr vn fn a) (toExpr vn fn b)
  | .un f a => .call₁ (fn f) (toExpr vn fn a)
  | .bin₂ f a b => .call₂ (fn f) (toExpr vn fn a) (toExpr vn fn b)
  | .tern f a b c => .call₃ (fn f) (toExpr vn fn a) (toExpr vn fn b) (toExpr vn fn c)

/-- **The kernel's evaluator, at the real instance, is the studio's
specification.**  Unconditional: no floating-point assumption anywhere. -/
theorem eval_toExpr (I : Interp) (vn fn : Nat → String) (env : String → ℝ) (t : Tree ℝ) :
    Expr.eval I env (t.toExpr vn fn) = eval (realOps I fn) (fun i => env (vn i)) t := by
  induction t with
  | num v => rfl
  | var i => rfl
  | neg a ih => simp [toExpr, Expr.eval, eval, realOps, ih]
  | bin op a b iha ihb => simp [toExpr, Expr.eval, eval, realOps, iha, ihb]
  | cond c a b ihc iha ihb => simp [toExpr, Expr.eval, eval, realOps, ihc, iha, ihb]
  | un f a ih => simp [toExpr, Expr.eval, eval, realOps, ih]
  | bin₂ f a b iha ihb => simp [toExpr, Expr.eval, eval, realOps, iha, ihb]
  | tern f a b c iha ihb ihc => simp [toExpr, Expr.eval, eval, realOps, iha, ihb, ihc]

end Tree

/-! ## The float instance -/

namespace Float

/-- JavaScript's `Math.round`: half rounds towards `+∞`.  Lean's `Float.round`
rounds half away from zero, so `web/js/expr.js` and the kernel would disagree at
`-0.5`; the kernel uses this one. -/
def jsRound (x : Float) : Float := Float.floor (x + 0.5)

/-- `Math.sign`. -/
def sign (x : Float) : Float :=
  if x.isNaN then x else if x < 0 then -1 else if 0 < x then 1 else x

/-- `Math.min`, NaN-propagating as in JavaScript. -/
def min2 (a b : Float) : Float :=
  if a.isNaN || b.isNaN then a - a + (b - b) else if a < b then a else b

/-- `Math.max`, NaN-propagating as in JavaScript. -/
def max2 (a b : Float) : Float :=
  if a.isNaN || b.isNaN then a - a + (b - b) else if a < b then b else a

/-- `x - ⌊x⌋`, the studio's `fract`/`saw`. -/
def fract (x : Float) : Float := x - Float.floor x

/-- ECMAScript's `Math.pow`, which is *not* C's `pow`: JavaScript returns `NaN`
for `pow(1, NaN)` and for `pow(±1, ±∞)`, where C returns `1`.  The studio runs
on `Math.pow`, so the kernel models `Math.pow`; the wrapper is applied on top of
whatever the platform's `pow` is, so the kernel computes the same thing in a
non-JavaScript host too. -/
def jsPow (a b : Float) : Float :=
  if b.isNaN then 0.0 / 0.0
  else if b == 0 then 1.0
  else if a.isNaN then 0.0 / 0.0
  else if a.abs == 1 && !b.isFinite then 0.0 / 0.0
  else Float.pow a b

end Float

/-- The unary builtin table, by index.  Indices are the wire format; the names
are in `unaryNames` and must stay in step with `web/js/expr-kernel.js`. -/
def floatUn : Nat → Float → Float
  | 0 => Float.sin
  | 1 => Float.cos
  | 2 => Float.tan
  | 3 => Float.asin
  | 4 => Float.acos
  | 5 => Float.atan
  | 6 => Float.sinh
  | 7 => Float.cosh
  | 8 => Float.tanh
  | 9 => Float.exp
  | 10 => Float.sqrt
  | 11 => Float.cbrt
  | 12 => Float.abs
  | 13 => Float.sign
  | 14 => Float.floor
  | 15 => Float.ceil
  | 16 => Float.jsRound
  | 17 => Float.log
  | 18 => Float.log10
  | 19 => Float.log2
  | 20 => Float.fract
  | 21 => fun x => let f := Float.fract x; if f < 0.5 then 2 * f else 2 - 2 * f
  | 22 => fun x => if Float.fract x < 0.5 then 1 else -1
  | _ => fun x => x - x + (0.0 / 0.0)

/-- Names of the unary builtins, in index order. -/
def unaryNames : List String :=
  ["sin", "cos", "tan", "asin", "acos", "atan", "sinh", "cosh", "tanh", "exp", "sqrt", "cbrt",
   "abs", "sign", "floor", "ceil", "round", "log", "log10", "log2", "fract", "tri", "square"]

/-- The binary builtin table, by index. -/
def floatBin : Nat → Float → Float → Float
  | 0 => Float.atan2
  | 1 => Float.jsPow
  | 2 => fun a b => Float.sqrt (a * a + b * b)
  | 3 => Float.min2
  | 4 => Float.max2
  | 5 => fun a b => a - b * Float.floor (a / b)
  | 6 => fun e x => if x < e then 0 else 1
  | 7 => fun x b => Float.log x / Float.log b
  | 8 => fun x s => Float.exp (-(x * x) / (2 * s * s))
  | _ => fun a b => a - a + (b - b) + (0.0 / 0.0)

/-- Names of the binary builtins, in index order. -/
def binaryNames : List String :=
  ["atan2", "pow", "hypot", "min", "max", "mod", "step", "logb", "gauss"]

/-- The ternary builtin table, by index. -/
def floatTern : Nat → Float → Float → Float → Float
  | 0 => fun x a b => Float.min2 (Float.max2 x a) b
  | 1 => fun a b x =>
      if a == b then (if x < a then 0 else 1)
      else
        let t := Float.min2 (Float.max2 ((x - a) / (b - a)) 0) 1
        t * t * (3 - 2 * t)
  | 2 => fun a b t => a + (b - a) * t
  | _ => fun a b c => a - a + (b - b) + (c - c) + (0.0 / 0.0)

/-- Names of the ternary builtins, in index order. -/
def ternaryNames : List String := ["clamp", "smoothstep", "lerp"]

/-- Binary operators in IEEE double precision, matching `web/js/expr.js`
operator for operator.  Note `div`: this is IEEE division, so `a / 0` is `±∞`
or `NaN`, *not* the `0` that Mathlib's `ℝ` gives. -/
def floatBinOp : BinOp → Float → Float → Float
  | .add, a, b => a + b
  | .sub, a, b => a - b
  | .mul, a, b => a * b
  | .div, a, b => a / b
  | .mod, a, b => a - b * Float.floor (a / b)
  | .pow, a, b => Float.jsPow a b
  | .lt, a, b => if a < b then 1 else 0
  | .le, a, b => if a <= b then 1 else 0
  | .gt, a, b => if b < a then 1 else 0
  | .ge, a, b => if b <= a then 1 else 0
  | .eq, a, b => if a == b then 1 else 0
  | .ne, a, b => if a == b then 0 else 1
  | .and, a, b => if (a != 0) && (b != 0) then 1 else 0
  | .or, a, b => if (a != 0) || (b != 0) then 1 else 0

/-- **The computable instance.**  `Tree.eval floatOps` runs; it is the model the
WebAssembly kernel implements instruction for instruction. -/
def floatOps : Ops Float where
  binop := floatBinOp
  neg := fun a => -a
  test := fun a => !a.isNaN && a != 0
  un := floatUn
  bin := floatBin
  tern := floatTern

/-- Evaluating a formula in IEEE doubles is a computation, not a description. -/
example : (Tree.eval floatOps (fun _ => 2.0) (.bin .add (.var 0) (.num 1.5)) == 3.5) = true := by
  native_decide

/-! ## The correspondence -/

/-- **`eval_correspondence`** — the float kernel's value, embedded into `ℝ` by
`φ`, is the value the studio's real-valued specification `Hesper.Anim.Expr.eval`
gives for the same formula — *provided* `φ` carries every primitive of
`floatOps` to the corresponding real primitive exactly (`h`).

That hypothesis is an assumption about the platform's floating point, not a
proved fact, and it is false wherever the evaluation rounds, divides by zero or
straddles a comparison tie.  `eval_correspondence_exact` below is the version
whose hypothesis can actually hold of IEEE arithmetic. -/
theorem eval_correspondence (I : Interp) (vn fn : Nat → String) (φ : Float → ℝ)
    (h : Refines floatOps (realOps I fn) φ) (env : Nat → Float) (env' : String → ℝ)
    (henv : ∀ i, env' (vn i) = φ (env i)) (t : Tree Float) :
    φ (Tree.eval floatOps env t) = Expr.eval I env' ((t.map φ).toExpr vn fn) := by
  rw [Tree.eval_toExpr, Tree.eval_map_of_refines h]
  exact Tree.eval_congr _ _ fun i _ => (henv i).symm

/-- The same statement under the weaker, per-evaluation hypothesis: only the
nodes this particular evaluation visits have to be exact.  This is the form that
is genuinely available for IEEE arithmetic — for instance for a formula built
from integer-valued literals and `+ - *` staying inside `2^53`, whose
comparisons are away from ties. -/
theorem eval_correspondence_exact (I : Interp) (vn fn : Nat → String) (φ : Float → ℝ)
    (env : Nat → Float) (env' : String → ℝ) (henv : ∀ i, env' (vn i) = φ (env i))
    (t : Tree Float) (h : Tree.EvalExact floatOps (realOps I fn) φ env t) :
    φ (Tree.eval floatOps env t) = Expr.eval I env' ((t.map φ).toExpr vn fn) := by
  rw [Tree.eval_toExpr, Tree.eval_map_of_exact env t h]
  exact Tree.eval_congr _ _ fun i _ => (henv i).symm

end Kernel
end Hesper.Anim
