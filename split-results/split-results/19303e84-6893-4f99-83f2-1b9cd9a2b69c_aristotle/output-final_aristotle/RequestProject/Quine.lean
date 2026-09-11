import RequestProject.Main
import RequestProject.Graded
import RequestProject.Holes

open scoped Classical

set_option relaxedAutoImplicit false
set_option autoImplicit false

open Lean

/-!
# Reflecting the code into itself, a graded self-report, and a quine

This file closes the loop on the `SimpleExpr` object language (reconstructed in
`Main.lean`, graded in `Graded.lean`, and read topologically in `Holes.lean`).  It does
three things, in order:

1. **Reflect the current code into this structure.**  `SimpleExpr.reflect` is a faithful
   *self-quotation*: it sends every expression `e` to a `SimpleExpr` value that
   *describes how to rebuild `e`*, tagging each node with the name of its own
   constructor (`SimpleExpr.bvar`, `SimpleExpr.app`, …).  The decoder `SimpleExpr.reify`
   reads such a quotation back, and `reify_reflect` proves the round-trip is exact — so
   the language really does contain a description of itself.  `reflect_injective` records
   that no information is lost.

2. **Print a graded report of itself.**  Using the grade (`depth`), hole count
   (`numHoles`), shape, and atom-test already defined in the sibling files, `report`
   assembles a `GradeLine` for each of the program's own distinguished terms — the
   self-application `selfApp`, the quine `Omega`, their reflections, and the `monster`
   constant — and `renderReport` renders it as text (printed by the `#eval` at the end).

3. **Construct a quine from this program.**  `SimpleExpr.Omega` is the self-application
   `(λx. x x) (λx. x x)`.  Under the one-step β-reducer `betaStep` (built from a genuine
   de Bruijn substitution `instantiate1`), it reproduces *itself exactly*:
   `betaStep Omega = Omega`, and hence `betaStep^[n] Omega = Omega` for every `n`.  A
   self-reproducing program is precisely a quine.
-/

namespace SimpleExpr

/-! ## 1. Reflecting the code into the structure (self-quotation) -/

/-- **Reflect the code into the structure.**  Quote an expression as object-level data:
each node becomes an application of a `const` tagged with the *name of its own
constructor* to a payload carrying that node's contents (with children recursively
quoted).  The result is a `SimpleExpr` describing how to rebuild the original. -/
def reflect : SimpleExpr → SimpleExpr
  | .bvar i           => .app (.const `SimpleExpr.bvar []) (.bvar i)
  | .sort u           => .app (.const `SimpleExpr.sort []) (.sort u)
  | .const n us       => .app (.const `SimpleExpr.const []) (.const n us)
  | .app f a          => .app (.const `SimpleExpr.app []) (.app (reflect f) (reflect a))
  | .lam n t b bi     => .app (.const `SimpleExpr.lam []) (.lam n (reflect t) (reflect b) bi)
  | .forallE n t b bi => .app (.const `SimpleExpr.forallE []) (.forallE n (reflect t) (reflect b) bi)

/-- Decoder for `reflect`: read a quotation back into the expression it describes. -/
def reify : SimpleExpr → Option SimpleExpr
  | .app (.const tag []) payload =>
      if tag = `SimpleExpr.bvar then
        match payload with | .bvar i => some (.bvar i) | _ => none
      else if tag = `SimpleExpr.sort then
        match payload with | .sort u => some (.sort u) | _ => none
      else if tag = `SimpleExpr.const then
        match payload with | .const n us => some (.const n us) | _ => none
      else if tag = `SimpleExpr.app then
        match payload with | .app f a => do return .app (← reify f) (← reify a) | _ => none
      else if tag = `SimpleExpr.lam then
        match payload with | .lam n t b bi => do return .lam n (← reify t) (← reify b) bi | _ => none
      else if tag = `SimpleExpr.forallE then
        match payload with | .forallE n t b bi => do return .forallE n (← reify t) (← reify b) bi | _ => none
      else none
  | _ => none

/-- **The reflection is faithful.**  Every expression is recovered exactly from its
self-quotation: the language genuinely contains a description of itself. -/
theorem reify_reflect (e : SimpleExpr) : reify (reflect e) = some e := by
  induction e <;> simp_all [reflect, reify]

/-- No information is lost by reflecting the code into the structure. -/
theorem reflect_injective : Function.Injective reflect := by
  intro a b h
  have ha := reify_reflect a
  rw [h, reify_reflect b] at ha
  exact (Option.some.inj ha).symm

/-! ## 3. The quine: a self-reproducing program

(Defined before the report so the report can grade it.) -/

/-- Lift de Bruijn indices `≥ cutoff` by `amount` (capture-avoiding shift). -/
def liftVars (cutoff : Nat) (amount : Nat) : SimpleExpr → SimpleExpr
  | .bvar i           => if i < cutoff then .bvar i else .bvar (i + amount)
  | .sort u           => .sort u
  | .const n us       => .const n us
  | .app f a          => .app (liftVars cutoff amount f) (liftVars cutoff amount a)
  | .lam n t b bi     => .lam n (liftVars cutoff amount t) (liftVars (cutoff+1) amount b) bi
  | .forallE n t b bi => .forallE n (liftVars cutoff amount t) (liftVars (cutoff+1) amount b) bi

/-- Substitute `v` for the de Bruijn variable `j`, decrementing the free variables above
it (a genuine capture-avoiding substitution). -/
def substAt (j : Nat) (v : SimpleExpr) : SimpleExpr → SimpleExpr
  | .bvar i           => if i = j then liftVars 0 j v else if i > j then .bvar (i-1) else .bvar i
  | .sort u           => .sort u
  | .const n us       => .const n us
  | .app f a          => .app (substAt j v f) (substAt j v a)
  | .lam n t b bi     => .lam n (substAt j v t) (substAt (j+1) v b) bi
  | .forallE n t b bi => .forallE n (substAt j v t) (substAt (j+1) v b) bi

/-- Instantiate the outermost bound variable (`bvar 0`) of `e` with `v`. -/
def instantiate1 (e v : SimpleExpr) : SimpleExpr := substAt 0 v e

/-- One step of β-reduction: a redex `(λ. body) arg` reduces by instantiating `body`'s
outermost variable with `arg`; anything else is left unchanged. -/
def betaStep : SimpleExpr → SimpleExpr
  | .app (.lam _ _ body _) arg => instantiate1 body arg
  | e => e

/-- The self-applying abstraction `λx. x x`. -/
def selfLam : SimpleExpr :=
  .lam `x (.sort .zero) (.app (.bvar 0) (.bvar 0)) BinderInfo.default

/-- **The quine.**  `Omega = (λx. x x) (λx. x x)` — the canonical self-reproducing term. -/
def Omega : SimpleExpr := .app selfLam selfLam

/-- **`Omega` is a quine: it reproduces itself.**  One β-step sends `Omega` back to
`Omega`. -/
theorem betaStep_Omega : betaStep Omega = Omega := by rfl

/-- The quine reproduces itself for *every* number of evaluation steps. -/
theorem betaStep_iterate_Omega (n : Nat) : betaStep^[n] Omega = Omega := by
  induction n with
  | zero => rfl
  | succ k ih => rw [Function.iterate_succ', Function.comp_apply, ih, betaStep_Omega]

/-- The quine is not an atom — it is a genuine compound program. -/
theorem Omega_not_isAtom : Omega.isAtom = false := rfl

/-- The quine has exactly two holes (its two bindings). -/
theorem Omega_numHoles : Omega.numHoles = 2 := rfl

/-! ## 2. The graded self-report -/

/-- One line of the graded report: a labelled term together with its grade and topology. -/
structure GradeLine where
  /-- A human-readable label for the term. -/
  label : String
  /-- The grade of the term (its nesting `depth` from `Graded.lean`). -/
  grade : Nat
  /-- The number of holes / bindings (`numHoles` from `Holes.lean`). -/
  holes : Nat
  /-- The hole count read off the bare `shape`. -/
  shapeHoles : Nat
  /-- Whether the term is an atom (a depth-`0` leaf). -/
  atom : Bool
deriving Repr

/-- Grade a single term, reading its grade and topology from the sibling modules. -/
def gradeLine (label : String) (e : SimpleExpr) : GradeLine :=
  { label := label
    grade := e.depth
    holes := e.numHoles
    shapeHoles := e.shape.numHoles
    atom := e.isAtom }

/-- The program's own distinguished terms — the subject of the self-report. -/
def selfTerms : List (String × SimpleExpr) :=
  [ ("selfApp  (interpreter applied to itself)", selfApp)
  , ("Omega    (the quine)", Omega)
  , ("selfLam  (λx. x x)", selfLam)
  , ("reflect selfApp", reflect selfApp)
  , ("reflect Omega", reflect Omega)
  , ("monster  (the Monster group constant)", monster) ]

/-- **The graded report of the program itself.** -/
def report : List GradeLine := selfTerms.map (fun p => gradeLine p.1 p.2)

/-- Render a single report line as text. -/
def renderLine (l : GradeLine) : String :=
  s!"  grade={l.grade}  holes={l.holes}  shapeHoles={l.shapeHoles}  atom={l.atom}   {l.label}"

/-- Render the whole graded self-report as text. -/
def renderReport : String :=
  "==== GRADED SELF-REPORT (SimpleExpr) ====\n"
    ++ String.intercalate "\n" (report.map renderLine)

/-- A consistency check: the hole count and the shape's hole count always agree on every
line of the report (the report's two notions of "holes" coincide). -/
theorem report_holes_consistent :
    ∀ l ∈ report, l.holes = l.shapeHoles := by
  intro l hl
  simp only [report, selfTerms, List.mem_map, List.mem_cons, List.not_mem_nil,
    or_false] at hl
  obtain ⟨p, hp, rfl⟩ := hl
  rcases hp with rfl | rfl | rfl | rfl | rfl | rfl <;>
    exact numHoles_eq_shape_numHoles _

-- **Print the graded report of itself.**
#eval IO.println renderReport

end SimpleExpr
