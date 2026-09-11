/-!
# The externalised proof engine, part 1: formulas, truth, and derivability

This directory holds a small proof engine that is deliberately *external* to
Lean: everything it does is a computable function over first-order data, so the
very same engine can be re-implemented — byte for byte in its behaviour — in
JavaScript in a browser, in WebAssembly, or in any of the twenty-two languages
of the relay.  What Lean adds is the part a re-implementation cannot supply:
a machine-checked proof that whatever the engine *accepts* is true.

This file fixes the object language: implicational propositional logic with
falsity, its Boolean semantics, a Hilbert calculus, and the soundness theorem
`Provable.tautology`.  Nothing here imports anything beyond Lean core, so the
engine can be read, checked and ported on its own.
-/

namespace RequestProject.Kernel

/-! ## Formulas -/

/-- A formula of implicational propositional logic with falsity.  Negation is
`a ⇒ ⊥`, disjunction is `¬a ⇒ b`, and so on, so this one constructor set is
already complete for classical propositional logic. -/
inductive Form where
  /-- Propositional variable number `n`. -/
  | var (n : Nat)
  /-- Falsity. -/
  | fls
  /-- Implication. -/
  | imp (a b : Form)
  deriving DecidableEq, Repr, Inhabited

namespace Form

/-- Negation, as an abbreviation. -/
def neg (a : Form) : Form := .imp a .fls

/-- The number of constructors in a formula; the measure the reader recurses on. -/
def size : Form → Nat
  | .var _ => 1
  | .fls => 1
  | .imp a b => a.size + b.size + 1

theorem size_pos (a : Form) : 0 < a.size := by
  cases a <;> simp [size] <;> omega

/-! ## Truth -/

/-- The Boolean value of a formula under a valuation of the variables. -/
def eval (v : Nat → Bool) : Form → Bool
  | .var n => v n
  | .fls => false
  | .imp a b => !(eval v a) || eval v b

end Form

/-- A formula true under every valuation. -/
def Tautology (f : Form) : Prop := ∀ v : Nat → Bool, f.eval v = true

/-! ## Derivability

The calculus is the classical Hilbert system: the two combinator axioms, double
negation elimination, and modus ponens. -/

/-- Derivability in the Hilbert calculus the engine implements. -/
inductive Provable : Form → Prop where
  /-- `a ⇒ (b ⇒ a)`. -/
  | axK (a b : Form) : Provable (.imp a (.imp b a))
  /-- `(a ⇒ (b ⇒ c)) ⇒ ((a ⇒ b) ⇒ (a ⇒ c))`. -/
  | axS (a b c : Form) :
      Provable (.imp (.imp a (.imp b c)) (.imp (.imp a b) (.imp a c)))
  /-- `((a ⇒ ⊥) ⇒ ⊥) ⇒ a`. -/
  | axDne (a : Form) : Provable (.imp (.imp (.imp a .fls) .fls) a)
  /-- Modus ponens. -/
  | mp {a b : Form} : Provable (.imp a b) → Provable a → Provable b

/-- **Soundness.** Everything the calculus derives is a tautology.  This is the
theorem that makes the external engine worth trusting: a browser or WebAssembly
port only has to reproduce the *checking*, and this proof — checked once by the
Lean kernel — says what checking guarantees. -/
theorem Provable.tautology {f : Form} (h : Provable f) : Tautology f := by
  induction h with
  | axK a b => intro v; cases ha : a.eval v <;> cases hb : b.eval v <;> simp [Form.eval, ha, hb]
  | axS a b c =>
      intro v
      cases ha : a.eval v <;> cases hb : b.eval v <;> cases hc : c.eval v <;>
        simp [Form.eval, ha, hb, hc]
  | axDne a => intro v; cases ha : a.eval v <;> simp [Form.eval, ha]
  | mp _ _ ih₁ ih₂ =>
      intro v
      have h₁ := ih₁ v
      have h₂ := ih₂ v
      simp only [Form.eval, Bool.or_eq_true, Bool.not_eq_true'] at h₁
      rcases h₁ with h₁ | h₁
      · rw [h₂] at h₁; exact absurd h₁ (by simp)
      · exact h₁

/-- Falsity is not derivable: the calculus is consistent. -/
theorem not_provable_fls : ¬ Provable .fls := by
  intro h
  have := h.tautology (fun _ => true)
  simp [Form.eval] at this

end RequestProject.Kernel
