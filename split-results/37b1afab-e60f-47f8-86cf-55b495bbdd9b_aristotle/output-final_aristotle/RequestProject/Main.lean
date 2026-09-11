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

/-!
# A recipe for waking up in thrownness — placed inside a Lean-modeled Lean runtime

This file does three things, in layers:

1. It states **thrownness** as a proposition and proves `wake_up` : we are already
   "in the middle of" a world we did not choose.
2. It builds a tiny **runtime modeled inside Lean** (a syntactic term language, plus a
   `Runtime` state that carries a current term and the inherited *facticity*).
3. It implements **first reflection**: the runtime observes its own current term and
   reflects the proof token back into a genuine Lean proposition *together with* a real
   proof of it (a `PSigma` of `(p : Prop) ×' p`). We then prove that reflecting the
   initial runtime really does recover `Thrownness`.

The original sketch did not compile; this is a faithful, compiling reconstruction.
-/

/-! ## 1. Thrownness, as a proposition with a proof -/

/-- **Thrownness**: there is a world we are already thrown into. -/
def Thrownness : Prop := ∃ _world : Type, True

/-- Waking up in thrownness: a world is already underway. We do not author the starting
conditions; we only witness that there are some. -/
theorem wake_up : Thrownness := ⟨Unit, trivial⟩

/-! ## 2. A tiny Lean-ish runtime, modeled in Lean

A syntactic type system and term language — just enough to *carry* proofs as tokens.
Real proofs cannot be stored in a `Repr`/`BEq`-deriving structure, so the AST stores a
named proof *token* and the reflection step re-attaches the genuine proof. -/

/-- A minimal syntactic type. -/
inductive Ty where
  | prop : Ty
  | unit : Ty
  | fn (dom cod : Ty) : Ty
  deriving Repr, BEq, DecidableEq, Inhabited

/-- A minimal syntactic term language. `proof` carries the *name* of a proof, not the
proof itself, so the AST stays fully first-order and decidable. -/
inductive Term where
  | var (name : String) (ty : Ty) : Term
  | const (name : String) (ty : Ty) : Term
  | lam (param : String) (dom : Ty) (body : Term) : Term
  | app (f x : Term) : Term
  | proof (name : String) : Term
  deriving Repr, BEq, Inhabited

/-! ### A syntactic type checker

We give the proof language a static semantics: a context-free `inferType` that assigns a
`Ty` to a `Term` (or fails). Variables and constants carry their own type annotations,
proof tokens are propositions, abstractions build function types, and applications check
that the argument's inferred type matches the function's domain. This formalizes *which*
terms of the runtime language are well-formed. -/

/-- Syntactic type inference for the proof language. Returns `some ty` when the term is
well-typed, and `none` otherwise. -/
def inferType : Term → Option Ty
  | .var _ ty => some ty
  | .const _ ty => some ty
  | .proof _ => some Ty.prop
  | .lam _ dom body => (inferType body).map (Ty.fn dom)
  | .app f x =>
      match inferType f, inferType x with
      | some (.fn dom cod), some argTy => if argTy == dom then some cod else none
      | _, _ => none

/-- A term is **well-typed** when type inference succeeds. -/
def WellTyped (t : Term) : Prop := (inferType t).isSome

/-- Every proof token is well-typed, with the type of propositions. -/
theorem inferType_proof (name : String) :
    inferType (Term.proof name) = some Ty.prop := rfl

/-- A well-typed application: applying the identity function on propositions to the
`wake_up` proof token yields a proposition. -/
theorem inferType_app_id_proof :
    inferType (Term.app (Term.lam "x" Ty.prop (Term.var "x" Ty.prop)) (Term.proof "wake_up"))
      = some Ty.prop := rfl

/-- An ill-typed application is rejected: feeding a proposition where a `unit` is expected
fails to type-check. -/
theorem inferType_app_mismatch :
    inferType (Term.app (Term.lam "x" Ty.unit (Term.var "x" Ty.unit)) (Term.proof "wake_up"))
      = none := rfl

/-- A running state of the modeled runtime: a current term (if any), the list of
inherited conditions we did not choose (*facticity*), and a free-form note. -/
structure Runtime where
  current : Option Term
  facticity : List String
  chosen : List String
  note : String
  deriving Repr, BEq, Inhabited

/-- The initial runtime: it is already underway, carrying the `wake_up` proof token and
three named facts of the situation that it did not choose. Nothing has been chosen yet. -/
def initialRuntime : Runtime where
  current := some (Term.proof "wake_up")
  facticity := ["I am tired", "I have deadlines", "I am in this system at this time"]
  chosen := []
  note := "first reflection: observing being-thrown"

/-! ### Choice and freedom

Thrownness is the *given*; the response is still ours. We model freedom as an `IO` input
action: the runtime reads a choice it was not handed in advance and commits to it,
transitioning out of mere facticity into a chosen response. The choice arrives through
`IO`, so it is genuinely not authored by the starting conditions. -/

/-- Take a free action: read a choice from an `IO` input action and record it. This is the
transition out of the unchosen facticity — the given remains given, but a freely chosen
response is now part of the runtime's history. -/
def Runtime.act (r : Runtime) (choose : IO String) : IO Runtime := do
  let response ← choose
  return { r with
    chosen := r.chosen ++ [response]
    note := s!"freedom: chose '{response}' in response to thrownness" }

/-- Acting strictly grows the `chosen` history by exactly the response that was read. -/
theorem Runtime.act_chosen (r : Runtime) (response : String) :
    (·.chosen) <$> (r.act (pure response)) = pure (r.chosen ++ [response]) := rfl

/-! ## 3. First reflection

The runtime looks at its own `current` term. If it finds the `wake_up` proof token, it
reflects it back into a genuine proposition bundled with a real proof of that
proposition. This is the moment of "waking up": the runtime recognizes the proof it was
already carrying. -/

/-- Reflect the runtime's current term back into a real `(proposition, proof)` pair.
Returns `none` when there is nothing to reflect upon. -/
def firstReflection (r : Runtime) : Option (Σ' p : Prop, p) :=
  match r.current with
  | some (Term.proof "wake_up") => some ⟨Thrownness, wake_up⟩
  | _ => none

/-- Reflecting the initial runtime succeeds, and the proposition it recovers is exactly
`Thrownness`. The runtime wakes up to the world it was already in. -/
theorem firstReflection_initial :
    (firstReflection initialRuntime).map (·.fst) = some Thrownness := by
  rfl

/-- Reflecting the initial runtime is never `none`: there is always a proof to wake up
to. -/
theorem firstReflection_initial_isSome :
    (firstReflection initialRuntime).isSome = true := by
  rfl

/-! ## A runnable demonstration -/

/-- Run the recipe: wake up, name the inherited conditions, then reflect on the proof the
runtime was already carrying. -/
def runFirstReflection : IO Unit := do
  let r := initialRuntime
  IO.println "You are already in the middle of a world you did not choose."
  IO.println "Facts of the situation (given, not chosen):"
  for fact in r.facticity do
    IO.println s!"  - {fact}"
  match firstReflection r with
  | some _ =>
      IO.println "First reflection: a proof of Thrownness was already in the runtime."
      IO.println "Separate the given from the open, then choose your next move anyway."
  | none =>
      IO.println "No proof term in runtime to reflect upon."
  -- Freedom: read a choice from an IO input and transition out of pure facticity.
  let r ← r.act (pure "I choose to begin the day anyway")
  IO.println s!"Chosen response: {r.chosen}"

#eval runFirstReflection

/-! ## 4. Deeper reflection: lifting real Lean expressions into the meta-language

The `firstReflection` above reflects a single pre-registered proof *token*. Here we go
deeper: a piece of elaboration-time metaprogramming that takes an *actual* Lean expression
and dynamically lifts it into the `Term` AST of our runtime language.

* `reflectTy` maps a Lean type expression to a syntactic `Ty` (propositions become
  `Ty.prop`, non-dependent arrows become `Ty.fn`, everything else `Ty.unit`).
* `reflectExpr` walks a Lean `Expr`: proofs collapse to `Term.proof`, applications and
  lambdas are translated structurally, and constants / free variables become annotated
  `const` / `var` nodes.
* `reflect%` is a **term elaborator** producing the lifted `Term`.
* `reflect` is a **tactic** that closes a goal of type `Term` with the lifted term.

This is the runtime reflecting genuine Lean proofs into itself. -/

open Lean Lean.Meta in
/-- Lift a Lean *type* expression into a syntactic `Ty`. -/
partial def reflectTy (e : Expr) : MetaM Ty := do
  if (← Meta.isProp e) then return Ty.prop
  match e with
  | .forallE _ d b _ =>
      if !b.hasLooseBVars then
        return Ty.fn (← reflectTy d) (← reflectTy b)
      else
        return Ty.unit
  | _ => return Ty.unit

open Lean Lean.Meta in
/-- Lift a genuine Lean `Expr` into the runtime's `Term` language. Proofs (terms whose
type is a `Prop`) collapse to a `Term.proof` token named by their pretty-printed form. -/
partial def reflectExpr (e : Expr) : MetaM _root_.Term := do
  let etype ← Meta.inferType e
  if (← Meta.isProp etype) then
    return _root_.Term.proof (toString (← Meta.ppExpr e))
  match e with
  | .app f x => return _root_.Term.app (← reflectExpr f) (← reflectExpr x)
  | .lam n d b bi =>
      Meta.withLocalDecl n bi d fun fv => do
        let body := b.instantiate1 fv
        return _root_.Term.lam n.toString (← reflectTy d) (← reflectExpr body)
  | .const name _ => return _root_.Term.const name.toString (← reflectTy etype)
  | .fvar fvarId =>
      let name := (← fvarId.getDecl).userName
      return _root_.Term.var name.toString (← reflectTy etype)
  | _ => return _root_.Term.const (toString (← Meta.ppExpr e)) (← reflectTy etype)

-- Allow the lifted `Term`/`Ty` values to be spliced back as Lean expressions.
deriving instance Lean.ToExpr for Ty
deriving instance Lean.ToExpr for Term

open Lean Lean.Elab Lean.Elab.Term in
/-- Term-level deeper reflection: `reflect% e` elaborates `e` and lifts it into a
value of type `Term`. -/
elab "reflect% " t:term : term => do
  let e ← elabTerm t none
  let e ← instantiateMVars e
  let tm ← reflectExpr e
  return Lean.toExpr tm

open Lean Lean.Elab Lean.Elab.Tactic in
/-- Tactic-level deeper reflection: `reflect e` closes a goal of type `Term` with the
lift of the Lean expression `e` into the runtime language. -/
elab "reflect " t:term : tactic => do
  let e ← Lean.Elab.Term.elabTerm t none
  let e ← instantiateMVars e
  let tm ← reflectExpr e
  closeMainGoal `reflect (Lean.toExpr tm)

/-- Deeper reflection of the real `wake_up` proof collapses to a proof token, just like
the pre-registered token in `initialRuntime`. -/
example : (reflect% wake_up) = Term.proof "wake_up" := rfl

/-- The tactic form lifts an actual Lean lambda into the runtime's `Term` language. -/
example : Term := by reflect (fun n : Nat => n)

#eval (reflect% wake_up)
#eval (reflect% (fun p : Prop => p))

/-! ## 5. Structural excess: the horizon of thoughts exceeds finite facticity

The runtime's *facticity* is finite — a cataloged list of conditions it was thrown into.
Its *thoughts*, however, are arbitrary well-formed `Term`s, and the inductive structure of
`Term` (free abstraction and composition) generates infinitely many of them. This section
makes that excess precise, in the spirit of Cantor/Gödel: a system can model its own rules
but can always formulate thoughts that escape its finite situated capacity.

* `Runtime.facticityCapacity` is the finite bound (the length of the facticity list).
* `Thought` is the type of all syntactic terms.
* `infiniteThoughtGenerator` injects `Nat` into `Thought`, witnessing infinitude.
* `thoughts_exceed_facticity` shows no finite facticity can surject onto the thoughts. -/

/-- The finite capacity of a runtime's situated facticity. -/
def Runtime.facticityCapacity (r : Runtime) : Nat := r.facticity.length

/-- A **thought** is any well-formed syntactic `Term` within the system. -/
abbrev Thought : Type := Term

/-- A function generating an infinite sequence of distinct thoughts, built only from the
system's own syntactic infrastructure (nested applications of an identity abstraction),
independent of any unchosen fact. -/
def infiniteThoughtGenerator : Nat → Thought
  | 0 => Term.const "init" Ty.unit
  | n + 1 => Term.app (Term.lam "x" Ty.unit (Term.var "x" Ty.unit)) (infiniteThoughtGenerator n)

/-
The thought generator is injective: distinct natural numbers name distinct thoughts.
-/
theorem infiniteThoughtGenerator_injective :
    Function.Injective infiniteThoughtGenerator := by
      -- To prove injectivity, we use induction on $n$.
      have h_inj : ∀ n, ∀ m, infiniteThoughtGenerator n = infiniteThoughtGenerator m → n = m := by
        intro n m hnm
        induction' n with n ih generalizing m;
        · cases m <;> cases hnm ; tauto;
        · rcases m with ( _ | m ) <;> simp_all +decide [ infiniteThoughtGenerator ];
          exact ih m rfl;
      exact fun n m h => h_inj n m h

/-- The space of thoughts is infinite. -/
instance : Infinite Thought :=
  Infinite.of_injective infiniteThoughtGenerator infiniteThoughtGenerator_injective

/-
**Structural excess.** The infinity of thinkable thoughts cannot be contained by the
finite facticity of the system: there is no surjection from the runtime's finite facticity
capacity onto the type of thoughts. There are always thoughts that escape the current
unchosen context.
-/
theorem thoughts_exceed_facticity (r : Runtime) :
    ¬ ∃ (f : {i // i < r.facticityCapacity} → Thought), Function.Surjective f := by
      simp +zetaDelta at *;
      intro f hf;
      exact Set.infinite_univ ( Set.Finite.subset ( Set.toFinite ( Set.range f ) ) ( by rintro x -; obtain ⟨ y, rfl ⟩ := hf x; exact Set.mem_range_self _ ) )