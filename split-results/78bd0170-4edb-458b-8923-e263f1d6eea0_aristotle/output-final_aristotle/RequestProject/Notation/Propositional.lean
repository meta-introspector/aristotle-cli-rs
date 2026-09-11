/-
Principia Mathematica — a "check the proofs in the original notation, via `eval`"
proof-of-concept for the *propositional* fragment (Section A, ∗1–∗5).

The idea (suggested by the project owner): rather than re-proving every starred
proposition of *Principia* by hand in Lean, give a faithful **deep embedding** of
Russell's propositional formulas as a Lean datatype `PM`, equip it with a
Boolean truth-table `eval`uator, and *check* each propositional theorem of the
book simply by evaluation (`by decide` / `#eval`).  Because every theorem of
Section A is a propositional tautology, this turns "verify the proof" into
"evaluate the formula on all valuations", which Lean's kernel does for us.

To make this more than a Boolean game we also give the **interpretation** of a
`PM` formula as a genuine Lean `Prop` (`PM.interp`) and prove the bridge

    `PM.taut p  →  ∀ g : ℕ → Prop, PM.interp g p`          (`PM.taut_interp`)

i.e. *any formula the evaluator certifies as a tautology is a genuine theorem of
propositional logic about arbitrary propositions*.  So `by decide` on `p.taut`
is not a weaker check — it yields the real Section-A theorem as a corollary.

What this file is and is not:
  * It is a working POC for the propositional layer: ∗1–∗5 are all tautologies
    and so are *all* decided by evaluation here (see the examples at the end).
  * It is NOT the predicate-logic / class / cardinal layer (∗9 onward, Vols.
    II–III): those are not decidable by truth tables and need real proofs.  See
    `Notation/README` / the top-level plan for how the two layers fit together.

Notation correspondence (Peano–Russell ↦ `PM` constructor ↦ Lean):
  * `~p`      ↦ `PM.neg`   ↦ `¬`
  * `p ∨ q`   ↦ `PM.disj`  ↦ `∨`
  * `p . q`   ↦ `PM.conj`  ↦ `∧`
  * `p ⊃ q`   ↦ `PM.impl`  ↦ `→`
  * `p ≡ q`   ↦ `PM.equ`   ↦ `↔`
-/

import Mathlib

namespace Principia.PNotation

/-- Deep embedding of *Principia*'s propositional formulas.  Variables are
indexed by `ℕ` (so `0,1,2,3 ≈ p,q,r,s`). -/
inductive PM where
  | var  : Nat → PM
  | neg  : PM → PM
  | disj : PM → PM → PM
  | conj : PM → PM → PM
  | impl : PM → PM → PM
  | equ  : PM → PM → PM
deriving Repr, DecidableEq

namespace PM

/-- Boolean truth-table evaluation under a valuation `g : ℕ → Bool`. -/
def eval (g : Nat → Bool) : PM → Bool
  | var n    => g n
  | neg p    => !(eval g p)
  | disj p q => eval g p || eval g q
  | conj p q => eval g p && eval g q
  | impl p q => !(eval g p) || eval g q
  | equ p q  => eval g p == eval g q

/-- The largest variable index occurring in a formula (so all variables are
`≤ maxVar p`). -/
def maxVar : PM → Nat
  | var n    => n
  | neg p    => maxVar p
  | disj p q => max (maxVar p) (maxVar q)
  | conj p q => max (maxVar p) (maxVar q)
  | impl p q => max (maxVar p) (maxVar q)
  | equ p q  => max (maxVar p) (maxVar q)

/-- A *decidable* tautology test: the formula evaluates to `true` on every
valuation of its (finitely many) variables `0 … maxVar p`.  Because the domain
`Fin (maxVar p + 1) → Bool` is a `Fintype`, this `Prop` is `Decidable`, hence
checkable by `decide`/`native_decide`. -/
def taut (p : PM) : Prop :=
  ∀ v : Fin (p.maxVar + 1) → Bool,
    p.eval (fun n => if h : n < p.maxVar + 1 then v ⟨n, h⟩ else false) = true

instance (p : PM) : Decidable p.taut := by
  unfold taut; infer_instance

/-- Interpretation of a formula as a genuine Lean `Prop`, under a propositional
valuation `g : ℕ → Prop`. -/
def interp (g : Nat → Prop) : PM → Prop
  | var n    => g n
  | neg p    => ¬ interp g p
  | disj p q => interp g p ∨ interp g q
  | conj p q => interp g p ∧ interp g q
  | impl p q => interp g p → interp g q
  | equ p q  => interp g p ↔ interp g q

/-
`eval` depends only on the values of `g` at variables `≤ maxVar p`.
-/
theorem eval_congr {g g' : Nat → Bool} :
    ∀ (p : PM), (∀ n, n ≤ p.maxVar → g n = g' n) → p.eval g = p.eval g' := by
  intro p hp;
  induction' p with p ih;
  all_goals simp_all +decide [ PM.eval, PM.maxVar ]

/-
A formula certified by the finite tautology test evaluates to `true` under
*every* valuation.
-/
theorem taut_eval {p : PM} (h : p.taut) (g : Nat → Bool) : p.eval g = true := by
  convert h ( fun n => g n ) using 1;
  convert eval_congr p _;
  grind

/-
The interpretation of a formula matches its Boolean evaluation when the
propositional valuation is read off from a Boolean one (classically).
-/
theorem interp_eq_eval (g : Nat → Bool) :
    ∀ (p : PM), (interp (fun n => g n = true) p ↔ p.eval g = true) := by
  intro p; induction p <;> simp_all [ PM.eval ] ;
  exact Eq.to_iff rfl;
  · rename_i p hp;
    cases h : eval g p <;> aesop;
  · rename_i p q hp hq;
    exact Iff.trans ( by rfl ) ( or_congr hp hq );
  · rename_i p q hp hq; rw [ show interp ( fun n => g n = true ) ( p.conj q ) = ( interp ( fun n => g n = true ) p ∧ interp ( fun n => g n = true ) q ) by rfl ] ; aesop;
  · rename_i p q hp hq;
    rw [ show interp ( fun n => g n = true ) ( p.impl q ) = ( interp ( fun n => g n = true ) p → interp ( fun n => g n = true ) q ) by rfl, hp, hq ] ; by_cases h : eval g p <;> simp +decide [ h ] ;
  · rename_i p q hp hq;
    convert Iff.trans ( Iff.trans ( Iff.intro ( fun h => ?_ ) ( fun h => ?_ ) ) ( Iff.trans ( Iff.intro ( fun h => ?_ ) ( fun h => ?_ ) ) ( Iff.intro ( fun h => ?_ ) ( fun h => ?_ ) ) ) ) ( Iff.trans ( Iff.intro ( fun h => ?_ ) ( fun h => ?_ ) ) ( Iff.trans ( Iff.intro ( fun h => ?_ ) ( fun h => ?_ ) ) ( Iff.intro ( fun h => ?_ ) ( fun h => ?_ ) ) ) ) using 1;
    any_goals tauto;
    · cases h : eval g p <;> cases h' : eval g q <;> simp_all +decide; all_goals cases ‹interp ( fun n => g n = true ) ( p.equ q ) › ; tauto;
    · exact iff_of_eq ( by aesop )

/-
**Soundness bridge.**  Any formula the evaluator certifies as a tautology is
a genuine theorem of propositional logic about arbitrary `Prop`s.
-/
theorem taut_interp {p : PM} (h : p.taut) (g : Nat → Prop) : interp g p := by
  contrapose! h;
  intro H;
  convert interp_eq_eval ( fun n => decide ( g n ) ) p |>.2 _;
  grind;
  exact fun n => Classical.propDecidable _;
  exact taut_eval H _

end PM

/-! ### Convenience notation for writing `PM` formulas

These let us write the starred propositions close to the book's structure.  We
use `p,q,r,s` for the first four variables. -/

namespace Builder

/-- `p`, `q`, `r`, `s` as `PM` variables. -/
def p : PM := .var 0
def q : PM := .var 1
def r : PM := .var 2
def s : PM := .var 3

scoped prefix:75 "~"  => PM.neg
scoped infixr:30 " ⋁ " => PM.disj
scoped infixr:35 " ⋀ " => PM.conj
scoped infixr:25 " ⊃ " => PM.impl
scoped infix:20  " ≡ " => PM.equ

end Builder

/-! ### Checking Section-A propositions purely by evaluation

Each of the following is a starred proposition of *Principia*, written as a `PM`
formula and verified — proof and all — by `decide` on its truth table.  By
`PM.taut_interp` each one is simultaneously a genuine Lean propositional theorem
about arbitrary `Prop`s. -/

open Builder

-- ∗2·01  p ⊃ ~p . ⊃ . ~p   (reductio ad absurdum)
example : ((p ⊃ ~p) ⊃ ~p).taut := by decide
-- ∗2·02  q ⊃ (p ⊃ q)
example : (q ⊃ (p ⊃ q)).taut := by decide
-- ∗2·03  (p ⊃ ~q) ⊃ (q ⊃ ~p)
example : ((p ⊃ ~q) ⊃ (q ⊃ ~p)).taut := by decide
-- ∗2·04  (p ⊃ (q ⊃ r)) ⊃ (q ⊃ (p ⊃ r))  (commutation)
example : ((p ⊃ (q ⊃ r)) ⊃ (q ⊃ (p ⊃ r))).taut := by decide
-- ∗2·05  (q ⊃ r) ⊃ ((p ⊃ q) ⊃ (p ⊃ r))  (syllogism)
example : ((q ⊃ r) ⊃ ((p ⊃ q) ⊃ (p ⊃ r))).taut := by decide
-- ∗2·06  (p ⊃ q) ⊃ ((q ⊃ r) ⊃ (p ⊃ r))
example : ((p ⊃ q) ⊃ ((q ⊃ r) ⊃ (p ⊃ r))).taut := by decide
-- ∗2·08  p ⊃ p
example : (p ⊃ p).taut := by decide
-- ∗2·11  p ∨ ~p   (excluded middle)
example : (p ⋁ ~p).taut := by decide
-- ∗2·12  p ⊃ ~~p
example : (p ⊃ ~ ~p).taut := by decide
-- ∗2·14  ~~p ⊃ p   (double negation)
example : (~ ~p ⊃ p).taut := by decide
-- ∗2·15  (~p ⊃ q) ⊃ (~q ⊃ p)   (transposition)
example : ((~p ⊃ q) ⊃ (~q ⊃ p)).taut := by decide
-- ∗2·16  (p ⊃ q) ⊃ (~q ⊃ ~p)
example : ((p ⊃ q) ⊃ (~q ⊃ ~p)).taut := by decide
-- ∗2·17  (~q ⊃ ~p) ⊃ (p ⊃ q)
example : ((~q ⊃ ~p) ⊃ (p ⊃ q)).taut := by decide
-- ∗3·01  p . q . ⊃ . p     (∗3·26 simplification, here p∧q ⊃ p)
example : ((p ⋀ q) ⊃ p).taut := by decide
-- ∗3·27  p . q . ⊃ . q
example : ((p ⋀ q) ⊃ q).taut := by decide
-- ∗4·1   (p ⊃ q) ≡ (~q ⊃ ~p)
example : ((p ⊃ q) ≡ (~q ⊃ ~p)).taut := by decide
-- ∗4·11  (p ≡ q) ≡ (~p ≡ ~q)
example : ((p ≡ q) ≡ (~p ≡ ~q)).taut := by decide
-- ∗5·1   p . q . ⊃ . p ≡ q
example : ((p ⋀ q) ⊃ (p ≡ q)).taut := by decide

/-- Example of the soundness bridge in action: ∗2·05 (syllogism) as a *genuine*
propositional theorem, obtained from the truth-table check via `taut_interp`. -/
example (P Q R : Prop) : (Q → R) → ((P → Q) → (P → R)) := by
  have h : ((q ⊃ r) ⊃ ((p ⊃ q) ⊃ (p ⊃ r))).taut := by decide
  have := PM.taut_interp h (fun n => [P, Q, R].getD n True)
  simpa [PM.interp, Builder.p, Builder.q, Builder.r] using this

/-! ### Literally checking proofs "via `eval`"

The `decide` calls above are kernel-level evaluations of the truth table.  We can
also run the checker directly with `#eval`, which is the most literal reading of
"check the proofs in original notation via eval": each line prints `true`. -/

/-- info: true -/
#guard_msgs in #eval decide ((p ⊃ p).taut)                              -- ∗2·08
/-- info: true -/
#guard_msgs in #eval decide ((p ⋁ ~p).taut)                            -- ∗2·11
/-- info: true -/
#guard_msgs in #eval decide (((p ⊃ q) ⊃ (~q ⊃ ~p)).taut)               -- ∗2·16
/-- info: false -/
#guard_msgs in #eval decide ((p ⊃ q).taut)  -- a non-theorem is rejected

end Principia.PNotation