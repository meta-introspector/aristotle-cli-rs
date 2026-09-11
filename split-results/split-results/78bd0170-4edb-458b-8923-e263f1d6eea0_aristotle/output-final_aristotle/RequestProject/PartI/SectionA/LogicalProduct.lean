/-
∗3.  The Logical Product of Two Propositions.

Formalization of chapter ∗3 of Whitehead & Russell's *Principia Mathematica*,
covering propositions ∗3·1 – ∗3·48.

The *Principia*'s logical product `p . q` (∗3·01, defined there as
`¬(¬p ∨ ¬q)`) is rendered by Lean's native conjunction `∧`, which is
definitionally the same notion of "both true".  Material implication `⊃` is
Lean's `→` and `∨`, `¬` are disjunction and negation as before.

Each proposition is a propositional tautology, discharged by `tauto`.
-/

import Mathlib
import RequestProject.PartI.SectionA.PrimitiveIdeasAndPropositions
import RequestProject.PartI.SectionA.ImmediateConsequences

namespace Principia.Part1.Section1

-- ∗3·1  ⊢ : p . q .⊃. ¬(¬p ∨ ¬q)
theorem ast_3_1 (p q : Prop) : (p ∧ q) → ¬(¬p ∨ ¬q) := by tauto

-- ∗3·11  ⊢ : ¬(¬p ∨ ¬q) .⊃. p . q
theorem ast_3_11 (p q : Prop) : ¬(¬p ∨ ¬q) → (p ∧ q) := by tauto

-- ∗3·12  ⊢ : ¬p .∨. ¬q .∨. p . q
theorem ast_3_12 (p q : Prop) : (¬p ∨ ¬q) ∨ (p ∧ q) := by tauto

-- ∗3·13  ⊢ : ¬(p . q) .⊃. ¬p ∨ ¬q
theorem ast_3_13 (p q : Prop) : ¬(p ∧ q) → (¬p ∨ ¬q) := by tauto

-- ∗3·14  ⊢ : ¬p ∨ ¬q .⊃. ¬(p . q)
theorem ast_3_14 (p q : Prop) : (¬p ∨ ¬q) → ¬(p ∧ q) := by tauto

-- ∗3·2  ⊢ :. p .⊃: q .⊃. p . q
theorem ast_3_2 (p q : Prop) : p → q → (p ∧ q) := by tauto

-- ∗3·21  ⊢ : q .⊃: p .⊃. p . q
theorem ast_3_21 (p q : Prop) : q → p → (p ∧ q) := by tauto

-- ∗3·22  ⊢ : p . q .⊃. q . p
theorem ast_3_22 (p q : Prop) : (p ∧ q) → (q ∧ p) := by tauto

-- ∗3·24  ⊢ . ¬(p . ¬p)   (the law of contradiction)
theorem ast_3_24 (p : Prop) : ¬(p ∧ ¬p) := by tauto

-- ∗3·26  ⊢ : p . q .⊃. p
theorem ast_3_26 (p q : Prop) : (p ∧ q) → p := by tauto

-- ∗3·27  ⊢ : p . q .⊃. q
theorem ast_3_27 (p q : Prop) : (p ∧ q) → q := by tauto

-- ∗3·3  ⊢ :. p . q .⊃. r :⊃: p .⊃. q ⊃ r   (Exportation)
theorem ast_3_3 (p q r : Prop) : (p ∧ q → r) → (p → q → r) := by tauto

-- ∗3·31  ⊢ :. p .⊃. q ⊃ r :⊃: p . q .⊃. r   (Importation)
theorem ast_3_31 (p q r : Prop) : (p → q → r) → (p ∧ q → r) := by tauto

-- ∗3·33  ⊢ : p ⊃ q . q ⊃ r .⊃. p ⊃ r
theorem ast_3_33 (p q r : Prop) : ((p → q) ∧ (q → r)) → (p → r) := by tauto

-- ∗3·34  ⊢ : q ⊃ r . p ⊃ q .⊃. p ⊃ r
theorem ast_3_34 (p q r : Prop) : ((q → r) ∧ (p → q)) → (p → r) := by tauto

-- ∗3·35  ⊢ : p . p ⊃ q .⊃. q   (Assertion)
theorem ast_3_35 (p q : Prop) : (p ∧ (p → q)) → q := by tauto

-- ∗3·37  ⊢ :. p . q .⊃. r :⊃: p . ¬r .⊃. ¬q
theorem ast_3_37 (p q r : Prop) : (p ∧ q → r) → (p ∧ ¬r → ¬q) := by tauto

-- ∗3·4  ⊢ : p . q .⊃. p ⊃ q
theorem ast_3_4 (p q : Prop) : (p ∧ q) → (p → q) := by tauto

-- ∗3·41  ⊢ :. p ⊃ r .⊃: p . q .⊃. r
theorem ast_3_41 (p q r : Prop) : (p → r) → ((p ∧ q) → r) := by tauto

-- ∗3·42  ⊢ :. q ⊃ r .⊃: p . q .⊃. r
theorem ast_3_42 (p q r : Prop) : (q → r) → ((p ∧ q) → r) := by tauto

-- ∗3·43  ⊢ :. p ⊃ q . p ⊃ r .⊃: p .⊃. q . r   (Composition)
theorem ast_3_43 (p q r : Prop) : ((p → q) ∧ (p → r)) → (p → (q ∧ r)) := by tauto

-- ∗3·44  ⊢ : q ⊃ p . r ⊃ p .⊃: q ∨ r .⊃. p
theorem ast_3_44 (p q r : Prop) : ((q → p) ∧ (r → p)) → (q ∨ r → p) := by tauto

-- ∗3·45  ⊢ :. p ⊃ q .⊃: p . r .⊃. q . r   (Factor)
theorem ast_3_45 (p q r : Prop) : (p → q) → ((p ∧ r) → (q ∧ r)) := by tauto

-- ∗3·47  ⊢ :. p ⊃ r . q ⊃ s .⊃: p . q .⊃. r . s   (Praeclarum theorema)
theorem ast_3_47 (p q r s : Prop) :
    ((p → r) ∧ (q → s)) → ((p ∧ q) → (r ∧ s)) := by tauto

-- ∗3·48  ⊢ :. p ⊃ r . q ⊃ s .⊃: p ∨ q .⊃. r ∨ s
theorem ast_3_48 (p q r s : Prop) :
    ((p → r) ∧ (q → s)) → (p ∨ q → r ∨ s) := by tauto

end Principia.Part1.Section1
