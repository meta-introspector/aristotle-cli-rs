import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

open Lean

/-!
# `SimpleExpr`: formalize, interpret, and apply to itself

The uploaded artifact was the fully elaborated recursor `SimpleExpr.rec`.  Reading off
its signature, `SimpleExpr` is a six-constructor inductive type — a stripped-down clone
of `Lean.Expr` (the constructors `bvar`, `sort`, `const`, `app`, `lam`, `forallE`):

```
SimpleExpr.rec :
  {motive : SimpleExpr → Sort u} →
  ((deBruijnIndex : Nat) → motive (.bvar deBruijnIndex)) →
  ((u : Level) → motive (.sort u)) →
  ((declName : Name) → (us : List Level) → motive (.const declName us)) →
  ((fn arg : SimpleExpr) → motive fn → motive arg → motive (.app fn arg)) →
  ((binderName : Name) → (binderType body : SimpleExpr) → (binderInfo : BinderInfo) →
      motive binderType → motive body → motive (.lam binderName binderType body binderInfo)) →
  ((binderName : Name) → (binderType body : SimpleExpr) → (binderInfo : BinderInfo) →
      motive binderType → motive body → motive (.forallE binderName binderType body binderInfo)) →
  (t : SimpleExpr) → motive t
```

This file carries out three tasks:

1. **Formalize** — declare `SimpleExpr` so that its auto-generated recursor matches the
   uploaded one verbatim (`SimpleExpr.rec` below).
2. **Interpret** — give the canonical denotation `SimpleExpr.toExpr : SimpleExpr → Lean.Expr`,
   and prove it is a *faithful* embedding via a partial inverse `SimpleExpr.ofExpr`
   (`ofExpr_toExpr`).
3. **Apply to itself** — use the language to describe (a fragment of) its own interpreter
   applied to its own type, and verify the interpretation computes as expected
   (`toExpr_selfApp`).
-/

/-- **Formalize.** Faithful reconstruction of the inductive type whose recursor
`SimpleExpr.rec` was provided: a stripped-down clone of `Lean.Expr`. -/
inductive SimpleExpr where
  | bvar    (deBruijnIndex : Nat)
  | sort    (u : Level)
  | const   (declName : Name) (us : List Level)
  | app     (fn : SimpleExpr) (arg : SimpleExpr)
  | lam     (binderName : Name) (binderType : SimpleExpr) (body : SimpleExpr) (binderInfo : BinderInfo)
  | forallE (binderName : Name) (binderType : SimpleExpr) (body : SimpleExpr) (binderInfo : BinderInfo)
  deriving Repr

namespace SimpleExpr

/-- **Interpret.** Canonical denotation of a `SimpleExpr` as a genuine `Lean.Expr`,
sending each constructor to the corresponding `Lean.Expr` constructor. -/
def toExpr : SimpleExpr → Expr
  | .bvar i        => .bvar i
  | .sort u        => .sort u
  | .const n us    => .const n us
  | .app f a       => .app f.toExpr a.toExpr
  | .lam n t b bi  => .lam n t.toExpr b.toExpr bi
  | .forallE n t b bi => .forallE n t.toExpr b.toExpr bi

/-- Partial inverse of `toExpr`: recognise exactly the image of the interpretation
(the `bvar`/`sort`/`const`/`app`/`lam`/`forallE` fragment of `Lean.Expr`). -/
def ofExpr : Expr → Option SimpleExpr
  | .bvar i        => some (.bvar i)
  | .sort u        => some (.sort u)
  | .const n us    => some (.const n us)
  | .app f a       => do return .app (← ofExpr f) (← ofExpr a)
  | .lam n t b bi  => do return .lam n (← ofExpr t) (← ofExpr b) bi
  | .forallE n t b bi => do return .forallE n (← ofExpr t) (← ofExpr b) bi
  | _              => none

/-
The interpretation is a **faithful embedding**: every `SimpleExpr` is recovered
exactly from its denotation.
-/
theorem ofExpr_toExpr (e : SimpleExpr) : ofExpr e.toExpr = some e := by
  induction' e with e ih;
  all_goals simp_all +decide [ SimpleExpr.toExpr, ofExpr ]

/-- **Apply to itself.** A `SimpleExpr` value that describes the application of this very
interpreter, `SimpleExpr.toExpr`, to the type `SimpleExpr` it interprets. -/
def selfApp : SimpleExpr :=
  .app (.const `SimpleExpr.toExpr []) (.const `SimpleExpr [])

/-- Interpreting the self-application yields the expected `Lean.Expr` application
`SimpleExpr.toExpr SimpleExpr`. -/
theorem toExpr_selfApp :
    selfApp.toExpr = Expr.app (Expr.const `SimpleExpr.toExpr []) (Expr.const `SimpleExpr []) :=
  rfl

/-- Faithfulness applied to the self-application: the encoding round-trips. -/
theorem ofExpr_toExpr_selfApp : ofExpr selfApp.toExpr = some selfApp :=
  ofExpr_toExpr selfApp

end SimpleExpr