/-
∗5.  Miscellaneous Propositions.

Formalization of chapter ∗5 of Whitehead & Russell's *Principia Mathematica*,
covering propositions ∗5·1 – ∗5·75.

Notation: equivalence `≡` is Lean's `↔`, logical product `.` is `∧`, material
implication `⊃` is `→`, and `∨`, `¬` are disjunction and negation.  Where the
*Principia*'s left-associative `∨` groups differently from Lean's
right-associative `∨`, the intended grouping is parenthesized explicitly.

Each proposition is a propositional tautology, discharged by `tauto`.
-/

import Mathlib
import RequestProject.PartI.SectionA.PrimitiveIdeasAndPropositions
import RequestProject.PartI.SectionA.ImmediateConsequences
import RequestProject.PartI.SectionA.LogicalProduct
import RequestProject.PartI.SectionA.Equivalence

namespace Principia.Part1.Section1

-- ∗5·1  ⊢ : p . q .⊃. p ≡ q
theorem ast_5_1 (p q : Prop) : (p ∧ q) → (p ↔ q) := by tauto

-- ∗5·11  ⊢ : p ⊃ q .∨. ¬p ⊃ q
theorem ast_5_11 (p q : Prop) : (p → q) ∨ (¬p → q) := by tauto

-- ∗5·12  ⊢ : p ⊃ q .∨. p ⊃ ¬q
theorem ast_5_12 (p q : Prop) : (p → q) ∨ (p → ¬q) := by tauto

-- ∗5·13  ⊢ : p ⊃ q .∨. q ⊃ p
theorem ast_5_13 (p q : Prop) : (p → q) ∨ (q → p) := by tauto

-- ∗5·14  ⊢ : p ⊃ q .∨. q ⊃ r
theorem ast_5_14 (p q r : Prop) : (p → q) ∨ (q → r) := by tauto

-- ∗5·15  ⊢ : p ≡ q .∨. p ≡ ¬q
theorem ast_5_15 (p q : Prop) : (p ↔ q) ∨ (p ↔ ¬q) := by tauto

-- ∗5·16  ⊢ . ¬(p ≡ q . p ≡ ¬q)
theorem ast_5_16 (p q : Prop) : ¬((p ↔ q) ∧ (p ↔ ¬q)) := by tauto

-- ∗5·17  ⊢ : p ∨ q . ¬(p . q) .≡. p ≡ ¬q
theorem ast_5_17 (p q : Prop) : ((p ∨ q) ∧ ¬(p ∧ q)) ↔ (p ↔ ¬q) := by tauto

-- ∗5·18  ⊢ : p ≡ q .≡. ¬(p ≡ ¬q)
theorem ast_5_18 (p q : Prop) : (p ↔ q) ↔ ¬(p ↔ ¬q) := by tauto

-- ∗5·19  ⊢ . ¬(p ≡ ¬p)
-- The *Principia*'s ∗5·19 is the law that no proposition is equivalent to its
-- own negation; it is obtained from ∗5·18 (with q := p) together with ∗4·2.
-- (The Agda transcription of this number states the trivial `p ≡ p`; the
-- statement below is the genuine ∗5·19 of the text.)
theorem ast_5_19 (p : Prop) : ¬(p ↔ ¬p) := by tauto

-- ∗5·21  ⊢ : ¬p . ¬q .⊃. p ≡ q
theorem ast_5_21 (p q : Prop) : (¬p ∧ ¬q) → (p ↔ q) := by tauto

-- ∗5·22  ⊢ : ¬(p ≡ q) .≡: p . ¬q .∨. q . ¬p
theorem ast_5_22 (p q : Prop) : ¬(p ↔ q) ↔ ((p ∧ ¬q) ∨ (q ∧ ¬p)) := by tauto

-- ∗5·23  ⊢ :. p ≡ q .≡: p . q .∨. ¬p . ¬q
theorem ast_5_23 (p q : Prop) : (p ↔ q) ↔ ((p ∧ q) ∨ (¬p ∧ ¬q)) := by tauto

-- ∗5·24  ⊢ :. ¬(p . q .∨. ¬p . ¬q) .≡: p . ¬q .∨. q . ¬p
theorem ast_5_24 (p q : Prop) :
    ¬((p ∧ q) ∨ (¬p ∧ ¬q)) ↔ ((p ∧ ¬q) ∨ (q ∧ ¬p)) := by tauto

-- ∗5·25  ⊢ :. p ∨ q .≡: p ⊃ q .⊃. q
theorem ast_5_25 (p q : Prop) : (p ∨ q) ↔ ((p → q) → q) := by tauto

-- ∗5·3  ⊢ :. p . q .⊃. r :≡: p . q .⊃. p . r
theorem ast_5_3 (p q r : Prop) : ((p ∧ q) → r) ↔ ((p ∧ q) → (p ∧ r)) := by tauto

-- ∗5·31  ⊢ :. r . p ⊃ q :⊃: p .⊃. q . r
theorem ast_5_31 (p q r : Prop) : (r ∧ (p → q)) → (p → (q ∧ r)) := by tauto

-- ∗5·32  ⊢ : p .⊃. q ≡ r :≡: p . q .≡. p . r
theorem ast_5_32 (p q r : Prop) : (p → (q ↔ r)) ↔ ((p ∧ q) ↔ (p ∧ r)) := by tauto

-- ∗5·33  ⊢ :. p . q .⊃. r :≡: p : p . q .⊃. r
theorem ast_5_33 (p q r : Prop) : ((p ∧ q) → r) ↔ (p → ((p ∧ q) → r)) := by tauto

-- ∗5·35  ⊢ : p ⊃ q . p ⊃ r .⊃: p .⊃. q ≡ r
theorem ast_5_35 (p q r : Prop) : ((p → q) ∧ (p → r)) → (p → (q ↔ r)) := by tauto

-- ∗5·36  ⊢ : p . p ≡ q .≡. q . p ≡ q
theorem ast_5_36 (p q : Prop) : (p ∧ (p ↔ q)) ↔ (q ∧ (p ↔ q)) := by tauto

-- ∗5·4  ⊢ :. p .⊃. p ⊃ q :≡. p ⊃ q
theorem ast_5_4 (p q : Prop) : (p → (p → q)) ↔ (p → q) := by tauto

-- ∗5·41  ⊢ :. p ⊃ q .⊃. p ⊃ r :≡: p .⊃. q ⊃ r
theorem ast_5_41 (p q r : Prop) : ((p → q) → (p → r)) ↔ (p → (q → r)) := by tauto

-- ∗5·42  ⊢ :: p .⊃. q ⊃ r :≡: p .⊃: q .⊃. p . r
theorem ast_5_42 (p q r : Prop) : (p → (q → r)) ↔ (p → (q → (p ∧ r))) := by tauto

-- ∗5·44  ⊢ :: p ⊃ q .⊃: p ⊃ r .≡: p .⊃. q . r
theorem ast_5_44 (p q r : Prop) : (p → q) → ((p → r) ↔ (p → (q ∧ r))) := by tauto

-- ∗5·5  ⊢ : p .⊃: p ⊃ q .≡. q
theorem ast_5_5 (p q : Prop) : p → ((p → q) ↔ q) := by tauto

-- ∗5·501  ⊢ : p .⊃: q .≡. p ≡ q
theorem ast_5_501 (p q : Prop) : p → (q ↔ (p ↔ q)) := by tauto

-- ∗5·53  ⊢ : p ∨ q ∨ r .⊃. s :≡: p ⊃ s . q ⊃ s . r ⊃ s
theorem ast_5_53 (p q r s : Prop) :
    (((p ∨ q) ∨ r) → s) ↔ (((p → s) ∧ (q → s)) ∧ (r → s)) := by tauto

-- ∗5·54  ⊢ :. p . q .≡. p :∨: p . q .≡. q
theorem ast_5_54 (p q : Prop) : ((p ∧ q) ↔ p) ∨ ((p ∧ q) ↔ q) := by tauto

-- ∗5·55  ⊢ :. p ∨ q .≡. p :∨: p ∨ q .≡. q
theorem ast_5_55 (p q : Prop) : ((p ∨ q) ↔ p) ∨ ((p ∨ q) ↔ q) := by tauto

-- ∗5·6  ⊢ :. p . ¬q .⊃. r :≡: p .⊃. q ∨ r
theorem ast_5_6 (p q r : Prop) : ((p ∧ ¬q) → r) ↔ (p → (q ∨ r)) := by tauto

-- ∗5·61  ⊢ : p ∨ q . ¬q .≡. p . ¬q
theorem ast_5_61 (p q : Prop) : ((p ∨ q) ∧ ¬q) ↔ (p ∧ ¬q) := by tauto

-- ∗5·62  ⊢ :. p . q .∨. ¬q :≡. p ∨ ¬q
theorem ast_5_62 (p q : Prop) : ((p ∧ q) ∨ ¬q) ↔ (p ∨ ¬q) := by tauto

-- ∗5·63  ⊢ :. p ∨ q .≡: p .∨. ¬p . q
theorem ast_5_63 (p q : Prop) : (p ∨ q) ↔ (p ∨ (¬p ∧ q)) := by tauto

-- ∗5·7  ⊢ : p ∨ r .≡. q ∨ r :≡: r .∨. p ≡ q
theorem ast_5_7 (p q r : Prop) : ((p ∨ r) ↔ (q ∨ r)) ↔ (r ∨ (p ↔ q)) := by tauto

-- ∗5·71  ⊢ :. q ⊃ ¬r .⊃: p ∨ q . r .≡. p . r
theorem ast_5_71 (p q r : Prop) :
    (q → ¬r) → (((p ∨ q) ∧ r) ↔ (p ∧ r)) := by tauto

-- ∗5·74  ⊢ : p .⊃. q ≡ r :≡: p ⊃ q .≡. p ⊃ r
theorem ast_5_74 (p q r : Prop) : (p → (q ↔ r)) ↔ ((p → q) ↔ (p → r)) := by tauto

-- ∗5·75  ⊢ :. r ⊃ ¬q : p :≡. q ∨ r :⊃: p . ¬q .≡. r
theorem ast_5_75 (p q r : Prop) :
    ((r → ¬q) ∧ (p ↔ (q ∨ r))) → ((p ∧ ¬q) ↔ r) := by tauto

end Principia.Part1.Section1
