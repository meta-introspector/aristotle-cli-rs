import RequestProject.DescriptionLogic
import Mathlib

/-!
# The Infinite Expressivity Theorem

This file realizes the *Infinite Expressivity Theorem* for the description-logic
formalization of the Aristotle system developed in `RequestProject.DescriptionLogic`.

The intuition is the following.  A concrete ontology such as `aristotleKB` is a piece of
*finite facticity*: its terminology (TBox) is a finite list of axioms, mentioning only
finitely many concept expressions.  By contrast, the *object language* of `ALC` — the type
`DLConcept NC NR` of all syntactically well-formed concept expressions — is an infinite
syntactic space: one can always build a strictly larger expression (for instance by
prefixing a further negation).  This is the formal counterpart of the slogan that the
extent of expressible "thoughts" strictly exceeds the finite internal context of any fixed
knowledge base.

We prove:

* `DescriptionLogic.instInfiniteDLConcept` — for *any* signature, the type of concepts is
  infinite (witnessed by the iterated negations of `⊤`);
* `DescriptionLogic.tboxConcepts_finite` — the set of concepts occurring in the TBox of a
  knowledge base is finite;
* `DescriptionLogic.aristotle_expressivity` — the headline strict cardinality inequality:
  the cardinality of the concepts mentioned in `aristotleKB` is strictly dominated by the
  cardinality of the full concept language;
* `DescriptionLogic.aristotle_unexpressed_infinite` — equivalently, infinitely many concepts
  of the object language are *not* mentioned by `aristotleKB`.
-/

namespace DescriptionLogic

open DLConcept

/-! ## The object language of concepts is infinite -/

/-- A structural size measure on concepts: the number of constructors used to build it. -/
def size {NC NR : Type*} : DLConcept NC NR → ℕ
  | .atom _ => 1
  | .top => 1
  | .bot => 1
  | .neg C => size C + 1
  | .inter C D => size C + size D + 1
  | .union C D => size C + size D + 1
  | .ex _ C => size C + 1
  | .all _ C => size C + 1

/-- Iterated negation of `⊤`: a concept whose neg-depth is exactly `n`.  This is the
witness that the concept language is infinite. -/
def iterNeg {NC NR : Type*} : ℕ → DLConcept NC NR
  | 0 => .top
  | n + 1 => .neg (iterNeg n)

/-- The size of `iterNeg n` is `n + 1`; in particular distinct `n` give distinct sizes. -/
theorem size_iterNeg {NC NR : Type*} (n : ℕ) :
    size (iterNeg (NC := NC) (NR := NR) n) = n + 1 := by
  induction n with
  | zero => rfl
  | succ k ih => simp [iterNeg, size, ih]

/-- The iterated-negation family is injective. -/
theorem iterNeg_injective {NC NR : Type*} :
    Function.Injective (iterNeg (NC := NC) (NR := NR)) := by
  intro m n h
  have := congrArg size h
  simpa [size_iterNeg] using this

/-- For every signature, the concept language `DLConcept NC NR` is infinite. -/
instance instInfiniteDLConcept {NC NR : Type*} : Infinite (DLConcept NC NR) :=
  Infinite.of_injective _ iterNeg_injective

/-! ## The concepts mentioned by a knowledge base form a finite set -/

variable {NC NR NI : Type*}

/-- The list of all concepts that occur (as a left- or right-hand side of some TBox GCI)
in a knowledge base. -/
def tboxConceptList (kb : KB NC NR NI) : List (DLConcept NC NR) :=
  kb.tbox.map GCI.lhs ++ kb.tbox.map GCI.rhs

/-- The set of all concepts occurring in the TBox of a knowledge base. -/
def tboxConcepts (kb : KB NC NR NI) : Set (DLConcept NC NR) :=
  {C | C ∈ tboxConceptList kb}

/-- The set of concepts mentioned in the TBox of any knowledge base is finite: it is the
range of a finite list. -/
theorem tboxConcepts_finite (kb : KB NC NR NI) : (tboxConcepts kb).Finite :=
  List.finite_toSet _

/-! ## The Infinite Expressivity Theorem for the Aristotle ontology -/

/-- **Infinite Expressivity Theorem.**  The cardinality of the (finite) set of concept
expressions actually mentioned in the Aristotle knowledge base is *strictly* dominated by
the cardinality of the full `ALC` concept language over its signature: the expressive space
of the object language strictly exceeds the finite facticity of the fixed ontology. -/
theorem aristotle_expressivity :
    Cardinal.mk (tboxConcepts aristotleKB) < Cardinal.mk (DLConcept ACon ARole) := by
  have h1 : Cardinal.mk (tboxConcepts aristotleKB) < Cardinal.aleph0 :=
    (tboxConcepts_finite aristotleKB).lt_aleph0
  have h2 : Cardinal.aleph0 ≤ Cardinal.mk (DLConcept ACon ARole) :=
    Cardinal.infinite_iff.mp inferInstance
  exact lt_of_lt_of_le h1 h2

/-- Equivalent reading: infinitely many concepts of the object language are *not* mentioned
by the Aristotle knowledge base — the ontology cannot internally enumerate the whole
expressive space it is embedded in. -/
theorem aristotle_unexpressed_infinite :
    {C : DLConcept ACon ARole | C ∉ tboxConcepts aristotleKB}.Infinite := by
  have hfin := tboxConcepts_finite aristotleKB
  have := hfin.infinite_compl
  simpa [Set.compl_setOf, Set.mem_compl_iff] using this

end DescriptionLogic
