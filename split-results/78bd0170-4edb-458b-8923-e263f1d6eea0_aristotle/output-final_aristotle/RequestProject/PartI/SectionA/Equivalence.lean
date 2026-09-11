/-
∗4.  Equivalence and Formal Rules.

Formalization of chapter ∗4 of Whitehead & Russell's *Principia Mathematica*,
covering propositions ∗4·1 – ∗4·87.

The *Principia*'s equivalence `p ≡ q` (∗4·01, defined as `(p ⊃ q) . (q ⊃ p)`)
is rendered by Lean's native biconditional `↔`; the logical product `.` is `∧`,
material implication `⊃` is `→`, and `∨`, `¬` are disjunction and negation.

Each proposition is a propositional tautology, discharged by `tauto`.
-/

import Mathlib
import RequestProject.PartI.SectionA.PrimitiveIdeasAndPropositions
import RequestProject.PartI.SectionA.ImmediateConsequences
import RequestProject.PartI.SectionA.LogicalProduct

namespace Principia.Part1.Section1

-- ∗4·1  ⊢ : p ⊃ q .≡. ¬q ⊃ ¬p
theorem ast_4_1 (p q : Prop) : (p → q) ↔ (¬q → ¬p) := by tauto

-- ∗4·11  ⊢ : p ≡ q .≡. ¬p ≡ ¬q
theorem ast_4_11 (p q : Prop) : (p ↔ q) ↔ (¬p ↔ ¬q) := by tauto

-- ∗4·12  ⊢ : p ≡ ¬q .≡. q ≡ ¬p
theorem ast_4_12 (p q : Prop) : (p ↔ ¬q) ↔ (q ↔ ¬p) := by tauto

-- ∗4·13  ⊢ . p ≡ ¬(¬p)   (double negation)
theorem ast_4_13 (p : Prop) : p ↔ ¬¬p := by tauto

-- ∗4·14  ⊢ :. p . q .⊃. r :≡: p . ¬r .⊃. ¬q
theorem ast_4_14 (p q r : Prop) : ((p ∧ q) → r) ↔ ((p ∧ ¬r) → ¬q) := by tauto

-- ∗4·15  ⊢ :. p . q .⊃. ¬r :≡: q . r .⊃. ¬p
theorem ast_4_15 (p q r : Prop) : ((p ∧ q) → ¬r) ↔ ((q ∧ r) → ¬p) := by tauto

-- ∗4·2  ⊢ . p ≡ p
theorem ast_4_2 (p : Prop) : p ↔ p := by tauto

-- ∗4·21  ⊢ : p ≡ q .≡. q ≡ p
theorem ast_4_21 (p q : Prop) : (p ↔ q) ↔ (q ↔ p) := by tauto

-- ∗4·22  ⊢ : p ≡ q . q ≡ r .⊃. p ≡ r
theorem ast_4_22 (p q r : Prop) : ((p ↔ q) ∧ (q ↔ r)) → (p ↔ r) := by tauto

-- ∗4·24  ⊢ : p .≡. p . p
theorem ast_4_24 (p : Prop) : p ↔ (p ∧ p) := by tauto

-- ∗4·25  ⊢ : p .≡. p ∨ p
theorem ast_4_25 (p : Prop) : p ↔ (p ∨ p) := by tauto

-- ∗4·3  ⊢ : p . q .≡. q . p
theorem ast_4_3 (p q : Prop) : (p ∧ q) ↔ (q ∧ p) := by tauto

-- ∗4·31  ⊢ : p ∨ q .≡. q ∨ p
theorem ast_4_31 (p q : Prop) : (p ∨ q) ↔ (q ∨ p) := by tauto

-- ∗4·32  ⊢ : (p . q) . r .≡. p . (q . r)
theorem ast_4_32 (p q r : Prop) : ((p ∧ q) ∧ r) ↔ (p ∧ (q ∧ r)) := by tauto

-- ∗4·33  ⊢ : (p ∨ q) ∨ r .≡. p ∨ (q ∨ r)
theorem ast_4_33 (p q r : Prop) : ((p ∨ q) ∨ r) ↔ (p ∨ (q ∨ r)) := by tauto

-- ∗4·36  ⊢ :. p ≡ q .⊃: p . r .≡. q . r
theorem ast_4_36 (p q r : Prop) : (p ↔ q) → ((p ∧ r) ↔ (q ∧ r)) := by tauto

-- ∗4·37  ⊢ :. p ≡ q .⊃: p ∨ r .≡. q ∨ r
theorem ast_4_37 (p q r : Prop) : (p ↔ q) → ((p ∨ r) ↔ (q ∨ r)) := by tauto

-- ∗4·38  ⊢ :. p ≡ r . q ≡ s .⊃: p . q .≡. r . s
theorem ast_4_38 (p q r s : Prop) :
    ((p ↔ r) ∧ (q ↔ s)) → ((p ∧ q) ↔ (r ∧ s)) := by tauto

-- ∗4·39  ⊢ :. p ≡ r . q ≡ s .⊃: p ∨ q .≡. r ∨ s
theorem ast_4_39 (p q r s : Prop) :
    ((p ↔ r) ∧ (q ↔ s)) → ((p ∨ q) ↔ (r ∨ s)) := by tauto

-- ∗4·4  ⊢ :. p . q ∨ r .≡: p . q .∨. p . r   (distributive law, first form)
theorem ast_4_4 (p q r : Prop) : (p ∧ (q ∨ r)) ↔ ((p ∧ q) ∨ (p ∧ r)) := by tauto

-- ∗4·41  ⊢ :. p .∨. q . r :≡. p ∨ q . p ∨ r   (distributive law, second form)
theorem ast_4_41 (p q r : Prop) : (p ∨ (q ∧ r)) ↔ ((p ∨ q) ∧ (p ∨ r)) := by tauto

-- ∗4·42  ⊢ :. p .≡: p . q .∨. p . ¬q
theorem ast_4_42 (p q : Prop) : p ↔ ((p ∧ q) ∨ (p ∧ ¬q)) := by tauto

-- ∗4·43  ⊢ :. p .≡: p ∨ q . p ∨ ¬q
theorem ast_4_43 (p q : Prop) : p ↔ ((p ∨ q) ∧ (p ∨ ¬q)) := by tauto

-- ∗4·44  ⊢ :. p .≡: p .∨. p . q
theorem ast_4_44 (p q : Prop) : p ↔ (p ∨ (p ∧ q)) := by tauto

-- ∗4·45  ⊢ : p .≡. p . p ∨ q
theorem ast_4_45 (p q : Prop) : p ↔ (p ∧ (p ∨ q)) := by tauto

-- ∗4·5  ⊢ : p . q .≡. ¬(¬p ∨ ¬q)
theorem ast_4_5 (p q : Prop) : (p ∧ q) ↔ ¬(¬p ∨ ¬q) := by tauto

-- ∗4·51  ⊢ : ¬(p . q) .≡. ¬p ∨ ¬q
theorem ast_4_51 (p q : Prop) : ¬(p ∧ q) ↔ (¬p ∨ ¬q) := by tauto

-- ∗4·52  ⊢ : p . ¬q .≡. ¬(¬p ∨ q)
theorem ast_4_52 (p q : Prop) : (p ∧ ¬q) ↔ ¬(¬p ∨ q) := by tauto

-- ∗4·53  ⊢ : ¬(p . ¬q) .≡. ¬p ∨ q
theorem ast_4_53 (p q : Prop) : ¬(p ∧ ¬q) ↔ (¬p ∨ q) := by tauto

-- ∗4·54  ⊢ : ¬p . q .≡. ¬(p ∨ ¬q)
theorem ast_4_54 (p q : Prop) : (¬p ∧ q) ↔ ¬(p ∨ ¬q) := by tauto

-- ∗4·55  ⊢ : ¬(¬p . q) .≡. p ∨ ¬q
theorem ast_4_55 (p q : Prop) : ¬(¬p ∧ q) ↔ (p ∨ ¬q) := by tauto

-- ∗4·56  ⊢ : ¬p . ¬q .≡. ¬(p ∨ q)
theorem ast_4_56 (p q : Prop) : (¬p ∧ ¬q) ↔ ¬(p ∨ q) := by tauto

-- ∗4·57  ⊢ : ¬(¬p . ¬q) .≡. p ∨ q
theorem ast_4_57 (p q : Prop) : ¬(¬p ∧ ¬q) ↔ (p ∨ q) := by tauto

-- ∗4·6  ⊢ : p ⊃ q .≡. ¬p ∨ q
theorem ast_4_6 (p q : Prop) : (p → q) ↔ (¬p ∨ q) := by tauto

-- ∗4·61  ⊢ : ¬(p ⊃ q) .≡. p . ¬q
theorem ast_4_61 (p q : Prop) : ¬(p → q) ↔ (p ∧ ¬q) := by tauto

-- ∗4·62  ⊢ : p ⊃ ¬q .≡. ¬p ∨ ¬q
theorem ast_4_62 (p q : Prop) : (p → ¬q) ↔ (¬p ∨ ¬q) := by tauto

-- ∗4·63  ⊢ : ¬(p ⊃ ¬q) .≡. p . q
theorem ast_4_63 (p q : Prop) : ¬(p → ¬q) ↔ (p ∧ q) := by tauto

-- ∗4·64  ⊢ : ¬p ⊃ q .≡. p ∨ q
theorem ast_4_64 (p q : Prop) : (¬p → q) ↔ (p ∨ q) := by tauto

-- ∗4·65  ⊢ : ¬(¬p ⊃ q) .≡. ¬p . ¬q
theorem ast_4_65 (p q : Prop) : ¬(¬p → q) ↔ (¬p ∧ ¬q) := by tauto

-- ∗4·66  ⊢ : ¬p ⊃ ¬q .≡. p ∨ ¬q
theorem ast_4_66 (p q : Prop) : (¬p → ¬q) ↔ (p ∨ ¬q) := by tauto

-- ∗4·67  ⊢ : ¬(¬p ⊃ ¬q) .≡. ¬p . q
theorem ast_4_67 (p q : Prop) : ¬(¬p → ¬q) ↔ (¬p ∧ q) := by tauto

-- ∗4·7  ⊢ : p ⊃ q .≡: p .⊃. p . q
theorem ast_4_7 (p q : Prop) : (p → q) ↔ (p → (p ∧ q)) := by tauto

-- ∗4·71  ⊢ :. p ⊃ q .≡: p .≡. p . q
theorem ast_4_71 (p q : Prop) : (p → q) ↔ (p ↔ (p ∧ q)) := by tauto

-- ∗4·72  ⊢ :. p ⊃ q .≡: q .≡. p ∨ q
theorem ast_4_72 (p q : Prop) : (p → q) ↔ (q ↔ (p ∨ q)) := by tauto

-- ∗4·73  ⊢ :. q .⊃: p .≡. p . q
theorem ast_4_73 (p q : Prop) : q → (p ↔ (p ∧ q)) := by tauto

-- ∗4·74  ⊢ :. ¬p .⊃: q .≡. p ∨ q
theorem ast_4_74 (p q : Prop) : ¬p → (q ↔ (p ∨ q)) := by tauto

-- ∗4·76  ⊢ : p ⊃ q . p ⊃ r .≡: p .⊃. q . r
theorem ast_4_76 (p q r : Prop) : ((p → q) ∧ (p → r)) ↔ (p → (q ∧ r)) := by tauto

-- ∗4·77  ⊢ : q ⊃ p . r ⊃ p .≡: q ∨ r .⊃. p
theorem ast_4_77 (p q r : Prop) : ((q → p) ∧ (r → p)) ↔ ((q ∨ r) → p) := by tauto

-- ∗4·78  ⊢ :. p ⊃ q .∨. p ⊃ r :≡: p .⊃. q ∨ r
theorem ast_4_78 (p q r : Prop) : ((p → q) ∨ (p → r)) ↔ (p → (q ∨ r)) := by tauto

-- ∗4·79  ⊢ : q ⊃ p .∨. r ⊃ p :≡: q . r .⊃. p
theorem ast_4_79 (p q r : Prop) : ((q → p) ∨ (r → p)) ↔ ((q ∧ r) → p) := by tauto

-- ∗4·8  ⊢ : p ⊃ ¬p .≡. ¬p
theorem ast_4_8 (p : Prop) : (p → ¬p) ↔ ¬p := by tauto

-- ∗4·81  ⊢ : ¬p ⊃ p .≡. p
theorem ast_4_81 (p : Prop) : (¬p → p) ↔ p := by tauto

-- ∗4·82  ⊢ : p ⊃ q . p ⊃ ¬q .≡. ¬p
theorem ast_4_82 (p q : Prop) : ((p → q) ∧ (p → ¬q)) ↔ ¬p := by tauto

-- ∗4·83  ⊢ : p ⊃ q . ¬p ⊃ q .≡. q
theorem ast_4_83 (p q : Prop) : ((p → q) ∧ (¬p → q)) ↔ q := by tauto

-- ∗4·84  ⊢ : p ≡ q .⊃: p ⊃ r .≡. q ⊃ r
theorem ast_4_84 (p q r : Prop) : (p ↔ q) → ((p → r) ↔ (q → r)) := by tauto

-- ∗4·85  ⊢ : p ≡ q .⊃: r ⊃ p .≡. r ⊃ q
theorem ast_4_85 (p q r : Prop) : (p ↔ q) → ((r → p) ↔ (r → q)) := by tauto

-- ∗4·86  ⊢ :. p ≡ q .⊃: p ≡ r .≡. q ≡ r
theorem ast_4_86 (p q r : Prop) : (p ↔ q) → ((p ↔ r) ↔ (q ↔ r)) := by tauto

-- ∗4·87  ⊢ : p . q .⊃. r :≡: p .⊃. q ⊃ r :≡: q .⊃. p ⊃ r :≡: q . p .⊃. r
-- (exportation, importation, and the commutative principle in one proposition)
theorem ast_4_87 (p q r : Prop) :
    ((((p ∧ q) → r) ↔ (p → q → r)) ∧ ((p → q → r) ↔ (q → p → r))) ∧
      ((q → p → r) ↔ ((q ∧ p) → r)) := by tauto

end Principia.Part1.Section1
