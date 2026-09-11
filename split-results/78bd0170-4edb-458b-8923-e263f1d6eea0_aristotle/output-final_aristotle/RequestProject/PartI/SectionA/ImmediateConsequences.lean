/-
∗2 (continued).  Immediate Consequences of the Primitive Propositions.

The file `PrimitiveIdeasAndPropositions.lean` carries the development of ∗2
through ∗2·6.  This file completes the chapter, formalizing the remaining
propositions ∗2·61 – ∗2·86 of Whitehead & Russell's *Principia Mathematica*.

Notation conventions follow the original Lean port:
* `→` is material implication (∗1·01 identifies `p ⊃ q` with `¬p ∨ q`),
* `∨` is disjunction, `¬` negation.

Where the *Principia*'s `∨` (which is left-associative) groups differently from
Lean's right-associative `∨`, the intended grouping is written with explicit
parentheses so the statement matches the book.

Each proposition is a propositional tautology; the proofs are discharged by
`tauto`, which is sound and uses only the standard logical axioms.
-/

import Mathlib
import RequestProject.PartI.SectionA.PrimitiveIdeasAndPropositions

namespace Principia.Part1.Section1

-- ∗2·61  ⊢ :. p ⊃ q .⊃: ¬p ⊃ q .⊃. q
theorem ast_2_61 (p q : Prop) : (p → q) → (¬p → q) → q := by tauto

-- ∗2·62  ⊢ : p ∨ q .⊃: p ⊃ q .⊃. q
theorem ast_2_62 (p q : Prop) : (p ∨ q) → (p → q) → q := by tauto

-- ∗2·621  ⊢ :. p ⊃ q .⊃: p ∨ q .⊃. q
theorem ast_2_621 (p q : Prop) : (p → q) → (p ∨ q) → q := by tauto

-- ∗2·63  ⊢ : p ∨ q .⊃: ¬p ∨ q .⊃. q
theorem ast_2_63 (p q : Prop) : (p ∨ q) → (¬p ∨ q) → q := by tauto

-- ∗2·64  ⊢ : p ∨ q .⊃: p ∨ ¬q .⊃. p
theorem ast_2_64 (p q : Prop) : (p ∨ q) → (p ∨ ¬q) → p := by tauto

-- ∗2·65  ⊢ : p ⊃ q .⊃: p ⊃ ¬q .⊃. ¬p
theorem ast_2_65 (p q : Prop) : (p → q) → (p → ¬q) → ¬p := by tauto

-- ∗2·67  ⊢ :. p ∨ q .⊃. q :⊃. p ⊃ q
theorem ast_2_67 (p q : Prop) : ((p ∨ q) → q) → (p → q) := by tauto

-- ∗2·68  ⊢ : p ⊃ q .⊃. q :⊃. p ∨ q
theorem ast_2_68 (p q : Prop) : ((p → q) → q) → p ∨ q := by tauto

-- ∗2·69  ⊢ : p ⊃ q .⊃. q :⊃: q ⊃ p .⊃. p
theorem ast_2_69 (p q : Prop) : ((p → q) → q) → ((q → p) → p) := by tauto

-- ∗2·73  ⊢ :. p ⊃ q .⊃: p ∨ q ∨ r .⊃. q ∨ r
theorem ast_2_73 (p q r : Prop) : (p → q) → (((p ∨ q) ∨ r) → q ∨ r) := by tauto

-- ∗2·74  ⊢ : q ⊃ p .⊃: p ∨ q ∨ r .⊃. p ∨ r
theorem ast_2_74 (p q r : Prop) : (q → p) → (((p ∨ q) ∨ r) → p ∨ r) := by tauto

-- ∗2·75  ⊢ :: p ∨ q .⊃: p .∨. q ⊃ r :⊃. p ∨ r
theorem ast_2_75 (p q r : Prop) : (p ∨ q) → (p ∨ (q → r)) → (p ∨ r) := by tauto

-- ∗2·76  ⊢ : p .∨. q ⊃ r :⊃: p ∨ q .⊃. p ∨ r
theorem ast_2_76 (p q r : Prop) : (p ∨ (q → r)) → (p ∨ q → p ∨ r) := by tauto

-- ∗2·77  ⊢ : p .⊃. q ⊃ r :⊃: p ⊃ q .⊃. p ⊃ r
theorem ast_2_77 (p q r : Prop) : (p → q → r) → (p → q) → (p → r) := by tauto

-- ∗2·8  ⊢ : q ∨ r .⊃: ¬r ∨ s .⊃. q ∨ s
theorem ast_2_8 (q r s : Prop) : (q ∨ r) → (¬r ∨ s → q ∨ s) := by tauto

-- ∗2·81  ⊢ :: q .⊃. r ⊃ s :⊃: p ∨ q .⊃: p ∨ r .⊃. p ∨ s
theorem ast_2_81 (p q r s : Prop) :
    (q → r → s) → (p ∨ q → (p ∨ r → p ∨ s)) := by tauto

-- ∗2·82  ⊢ : p ∨ q ∨ r .⊃: p ∨ ¬r ∨ s .⊃. p ∨ q ∨ s
theorem ast_2_82 (p q r s : Prop) :
    p ∨ (q ∨ r) → (p ∨ (¬r ∨ s) → p ∨ (q ∨ s)) := by tauto

-- ∗2·83  ⊢ :: p .⊃. q ⊃ r :⊃: p .⊃. r ⊃ s :⊃: p .⊃. q ⊃ s
theorem ast_2_83 (p q r s : Prop) :
    (p → q → r) → (p → r → s) → (p → q → s) := by tauto

-- ∗2·85  ⊢ :. p ∨ q .⊃. p ∨ r :⊃: p .∨. q ⊃ r
theorem ast_2_85 (p q r : Prop) : (p ∨ q → p ∨ r) → p ∨ (q → r) := by tauto

-- ∗2·86  ⊢ : p ⊃ q .⊃. p ⊃ r :⊃: p .⊃. q ⊃ r
theorem ast_2_86 (p q r : Prop) : ((p → q) → (p → r)) → (p → q → r) := by tauto

end Principia.Part1.Section1
