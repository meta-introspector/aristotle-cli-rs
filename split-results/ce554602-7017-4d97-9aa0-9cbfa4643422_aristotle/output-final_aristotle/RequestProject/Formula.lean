import Mathlib

/-!
# Propositional Formulas and Semantics

This file defines the syntax and semantics of propositional logic,
following the blueprint's foundation of treating mathematics as a
"game played with strings of symbols."

We define propositional formulas, valuations, and semantic evaluation.
-/

set_option maxHeartbeats 400000

/-- Propositional formulas over a set of propositional variables `V`. -/
inductive PropForm (V : Type*) : Type _
  | var : V → PropForm V
  | falsum : PropForm V
  | imp : PropForm V → PropForm V → PropForm V
  | conj : PropForm V → PropForm V → PropForm V
  | disj : PropForm V → PropForm V → PropForm V
  deriving DecidableEq

namespace PropForm

variable {V : Type*}

/-- Negation: ¬A is defined as A → ⊥ -/
def neg (A : PropForm V) : PropForm V := imp A falsum

/-- Verum (True): ⊤ is ¬⊥ -/
def verum : PropForm V := neg falsum

/-- Biconditional: A ↔ B is (A → B) ∧ (B → A) -/
def iff' (A B : PropForm V) : PropForm V := conj (imp A B) (imp B A)

/-- A Valuation assigns truth values to propositional variables. -/
abbrev Valuation (V : Type*) := V → Bool

/-- Semantic evaluation of a formula under a valuation. -/
def eval (v : Valuation V) : PropForm V → Bool
  | var p => v p
  | falsum => false
  | imp A B => (!eval v A) || eval v B
  | conj A B => eval v A && eval v B
  | disj A B => eval v A || eval v B

/-- A formula is a tautology if it evaluates to true under every valuation. -/
def IsTautology (A : PropForm V) : Prop :=
  ∀ v : Valuation V, eval v A = true

/-- Semantic entailment: Γ ⊨ A if every valuation satisfying all of Γ also satisfies A. -/
def SemEntails (Γ : List (PropForm V)) (A : PropForm V) : Prop :=
  ∀ v : Valuation V, (∀ B ∈ Γ, eval v B = true) → eval v A = true

/-- The set of subformulas of a formula. -/
def subformulas : PropForm V → List (PropForm V)
  | var p => [var p]
  | falsum => [falsum]
  | imp A B => imp A B :: (subformulas A ++ subformulas B)
  | conj A B => conj A B :: (subformulas A ++ subformulas B)
  | disj A B => disj A B :: (subformulas A ++ subformulas B)

/-- A formula is a subformula of another. -/
def IsSubformula (A B : PropForm V) : Prop := A ∈ subformulas B

theorem eval_neg (v : Valuation V) (A : PropForm V) :
    eval v (neg A) = !eval v A := by
  simp [neg, eval]

theorem eval_verum (v : Valuation V) :
    eval v (verum : PropForm V) = true := by
  simp [verum, eval_neg, eval]

/-- Every formula is a subformula of itself. -/
theorem isSubformula_refl (A : PropForm V) : IsSubformula A A := by
  unfold IsSubformula
  cases A <;> simp [subformulas]

end PropForm
