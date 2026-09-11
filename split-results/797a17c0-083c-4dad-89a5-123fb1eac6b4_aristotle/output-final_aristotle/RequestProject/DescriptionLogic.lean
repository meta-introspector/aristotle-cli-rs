import Mathlib

/-!
# Description logic and an ontology of the Aristotle system

This file develops a small but faithful fragment of *description logic* (the knowledge
representation formalism underlying ontologies and the OWL web ontology language) inside
Lean, and then uses it to formalize statements about the **Aristotle** automated
theorem-proving system described in the Harmonic technical report
(arXiv:2510.01346v1).

The description logic implemented here is `ALC` (Attributive Language with Complements),
the canonical propositionally-closed description logic.  We give:

* a syntax of *concepts* (`DLConcept`), built from atomic concepts and roles using the
  Boolean connectives together with the existential (`∃R.C`) and universal (`∀R.C`) role
  restrictions;
* a Tarski-style set-theoretic *semantics* (`eval`) interpreting each concept as a subset
  of the domain of an *interpretation* (`Interp`);
* *TBoxes* (terminologies: sets of general concept inclusions `C ⊑ D`) and *ABoxes*
  (assertions about named individuals), bundled into a *knowledge base* (`KB`);
* the notions of an interpretation *modelling* a knowledge base and of logical
  *entailment* of a subsumption or of an assertion.

We prove the standard meta-theory (reflexivity and transitivity of entailed subsumption,
the De Morgan duality between `∃` and `∀`, monotonicity of the role restrictions,
distributivity, …), and then build the `Aristotle` ontology and derive several entailments
about the system's architecture, e.g. that Aristotle has a subsystem, and that a solved
problem cannot have all of its justifications be merely informal.
-/

namespace DescriptionLogic

/-! ## Syntax of `ALC` concepts -/

/-- Concepts of the description logic `ALC`, over a type `NC` of atomic concept names and a
type `NR` of role names.  These are the unary "class" expressions of the logic. -/
inductive DLConcept (NC NR : Type*) where
  /-- An atomic concept (a named class). -/
  | atom : NC → DLConcept NC NR
  /-- The top concept `⊤`, denoting the whole domain. -/
  | top : DLConcept NC NR
  /-- The bottom concept `⊥`, denoting the empty class. -/
  | bot : DLConcept NC NR
  /-- Concept negation (complement) `¬C`. -/
  | neg : DLConcept NC NR → DLConcept NC NR
  /-- Concept conjunction (intersection) `C ⊓ D`. -/
  | inter : DLConcept NC NR → DLConcept NC NR → DLConcept NC NR
  /-- Concept disjunction (union) `C ⊔ D`. -/
  | union : DLConcept NC NR → DLConcept NC NR → DLConcept NC NR
  /-- Existential role restriction `∃R.C`. -/
  | ex : NR → DLConcept NC NR → DLConcept NC NR
  /-- Universal (value) role restriction `∀R.C`. -/
  | all : NR → DLConcept NC NR → DLConcept NC NR

namespace DLConcept

@[inherit_doc] scoped infixr:65 " ⊓ " => DLConcept.inter
@[inherit_doc] scoped infixr:60 " ⊔ " => DLConcept.union

/-- Concept implication `C ⊑ D` as a derived concept `¬C ⊔ D` (material implication). -/
def imp {NC NR : Type*} (C D : DLConcept NC NR) : DLConcept NC NR := (neg C).union D

end DLConcept

/-! ## Semantics: interpretations -/

/-- An interpretation of the description logic: a nonempty domain `Dom`, an interpretation
of each atomic concept as a subset of the domain, of each role as a binary relation on the
domain, and of each individual name as an element of the domain. -/
structure Interp (NC NR NI : Type*) where
  /-- The interpretation domain. -/
  Dom : Type
  /-- The domain is nonempty (a standing assumption of description logic). -/
  domNonempty : Nonempty Dom
  /-- Interpretation of atomic concepts. -/
  atomI : NC → Set Dom
  /-- Interpretation of roles as binary relations. -/
  roleI : NR → Dom → Dom → Prop
  /-- Interpretation of individual names. -/
  indI : NI → Dom

/-- The extension `⟦C⟧ⁱ` of a concept `C` under an interpretation `I`: the set of domain
elements that belong to the class denoted by `C`. -/
def eval {NC NR NI : Type*} (I : Interp NC NR NI) : DLConcept NC NR → Set I.Dom
  | .atom A => I.atomI A
  | .top => Set.univ
  | .bot => ∅
  | .neg C => (eval I C)ᶜ
  | .inter C D => eval I C ∩ eval I D
  | .union C D => eval I C ∪ eval I D
  | .ex r C => {x | ∃ y, I.roleI r x y ∧ y ∈ eval I C}
  | .all r C => {x | ∀ y, I.roleI r x y → y ∈ eval I C}

@[simp] theorem eval_atom {NC NR NI : Type*} (I : Interp NC NR NI) (A : NC) :
    eval I (.atom A) = I.atomI A := rfl
@[simp] theorem eval_top {NC NR NI : Type*} (I : Interp NC NR NI) :
    eval I (NC := NC) (NR := NR) .top = Set.univ := rfl
@[simp] theorem eval_bot {NC NR NI : Type*} (I : Interp NC NR NI) :
    eval I (NC := NC) (NR := NR) .bot = ∅ := rfl
@[simp] theorem eval_neg {NC NR NI : Type*} (I : Interp NC NR NI) (C : DLConcept NC NR) :
    eval I (.neg C) = (eval I C)ᶜ := rfl
@[simp] theorem eval_inter {NC NR NI : Type*} (I : Interp NC NR NI) (C D : DLConcept NC NR) :
    eval I (.inter C D) = eval I C ∩ eval I D := rfl
@[simp] theorem eval_union {NC NR NI : Type*} (I : Interp NC NR NI) (C D : DLConcept NC NR) :
    eval I (.union C D) = eval I C ∪ eval I D := rfl
@[simp] theorem eval_ex {NC NR NI : Type*} (I : Interp NC NR NI) (r : NR) (C : DLConcept NC NR) :
    eval I (.ex r C) = {x | ∃ y, I.roleI r x y ∧ y ∈ eval I C} := rfl
@[simp] theorem eval_all {NC NR NI : Type*} (I : Interp NC NR NI) (r : NR) (C : DLConcept NC NR) :
    eval I (.all r C) = {x | ∀ y, I.roleI r x y → y ∈ eval I C} := rfl

/-! ## TBoxes, ABoxes, knowledge bases, modelling and entailment -/

/-- A general concept inclusion (GCI) `C ⊑ D`, the basic axiom of a TBox. -/
structure GCI (NC NR : Type*) where
  /-- The subsumed (left-hand) concept. -/
  lhs : DLConcept NC NR
  /-- The subsuming (right-hand) concept. -/
  rhs : DLConcept NC NR

/-- A concept assertion `C(a)`: individual `a` is an instance of concept `C`. -/
structure ConAssertion (NC NR NI : Type*) where
  /-- The asserted individual. -/
  ind : NI
  /-- The concept it is asserted to belong to. -/
  concept : DLConcept NC NR

/-- A role assertion `r(a, b)`: individuals `a` and `b` are related by role `r`. -/
structure RoleAssertion (NR NI : Type*) where
  /-- The asserted role. -/
  role : NR
  /-- The source individual. -/
  src : NI
  /-- The target individual. -/
  tgt : NI

/-- A knowledge base: a TBox (list of general concept inclusions) together with an ABox
(lists of concept and role assertions). -/
structure KB (NC NR NI : Type*) where
  /-- The terminological box (TBox): the general concept inclusions. -/
  tbox : List (GCI NC NR)
  /-- The concept assertions of the ABox. -/
  conAssertions : List (ConAssertion NC NR NI)
  /-- The role assertions of the ABox. -/
  roleAssertions : List (RoleAssertion NR NI)

/-- An interpretation `I` *satisfies* a GCI `C ⊑ D` when `⟦C⟧ⁱ ⊆ ⟦D⟧ⁱ`. -/
def satisfiesGCI {NC NR NI : Type*} (I : Interp NC NR NI) (ax : GCI NC NR) : Prop :=
  eval I ax.lhs ⊆ eval I ax.rhs

/-- An interpretation `I` *models* a knowledge base `kb` when it satisfies every TBox axiom,
every concept assertion, and every role assertion. -/
def models {NC NR NI : Type*} (I : Interp NC NR NI) (kb : KB NC NR NI) : Prop :=
  (∀ ax ∈ kb.tbox, satisfiesGCI I ax) ∧
  (∀ a ∈ kb.conAssertions, I.indI a.ind ∈ eval I a.concept) ∧
  (∀ a ∈ kb.roleAssertions, I.roleI a.role (I.indI a.src) (I.indI a.tgt))

/-- The knowledge base `kb` *entails the subsumption* `C ⊑ D` when every model of `kb`
satisfies `⟦C⟧ ⊆ ⟦D⟧`. -/
def entailsSub {NC NR NI : Type*} (kb : KB NC NR NI) (C D : DLConcept NC NR) : Prop :=
  ∀ I : Interp NC NR NI, models I kb → eval I C ⊆ eval I D

/-- The knowledge base `kb` *entails the assertion* `C(a)` when every model of `kb` places
the individual `a` in the extension of `C`. -/
def entailsCon {NC NR NI : Type*} (kb : KB NC NR NI) (a : NI) (C : DLConcept NC NR) : Prop :=
  ∀ I : Interp NC NR NI, models I kb → I.indI a ∈ eval I C

/-- A concept `C` is *unsatisfiable w.r.t.* `kb` when no model of `kb` gives it a nonempty
extension; equivalently `C` is entailed to be subsumed by `⊥`. -/
def unsatisfiable {NC NR NI : Type*} (kb : KB NC NR NI) (C : DLConcept NC NR) : Prop :=
  entailsSub kb C .bot

/-! ## General meta-theory of `ALC`

These are interpretation-independent validities and the basic structural rules of
entailment, which hold for every knowledge base. -/

variable {NC NR NI : Type*}

/-- The extension of `⊥` is always empty. -/
theorem eval_bot_eq_empty (I : Interp NC NR NI) :
    eval I (NC := NC) (NR := NR) .bot = (∅ : Set I.Dom) := rfl

/-- De Morgan duality between the role restrictions: `¬(∃R.C) ≡ ∀R.(¬C)`. -/
theorem eval_neg_ex (I : Interp NC NR NI) (r : NR) (C : DLConcept NC NR) :
    eval I (.neg (.ex r C)) = eval I (.all r (.neg C)) := by
  ext x; simp [eval]

/-- De Morgan duality between the role restrictions: `¬(∀R.C) ≡ ∃R.(¬C)`. -/
theorem eval_neg_all (I : Interp NC NR NI) (r : NR) (C : DLConcept NC NR) :
    eval I (.neg (.all r C)) = eval I (.ex r (.neg C)) := by
  ext x; simp [eval]

/-- The existential restriction over `⊥` is unsatisfiable: `∃R.⊥ ≡ ⊥`. -/
theorem eval_ex_bot (I : Interp NC NR NI) (r : NR) :
    eval I (.ex r .bot) = eval I (NC := NC) (NR := NR) .bot := by
  ext x; simp [eval]

/-- The universal restriction over `⊤` is trivial: `∀R.⊤ ≡ ⊤`. -/
theorem eval_all_top (I : Interp NC NR NI) (r : NR) :
    eval I (.all r .top) = eval I (NC := NC) (NR := NR) .top := by
  ext x; simp [eval]

/-- Distributivity of conjunction over disjunction at the semantic level. -/
theorem eval_inter_union_distrib (I : Interp NC NR NI) (C D E : DLConcept NC NR) :
    eval I (.inter C (.union D E)) = eval I (.union (.inter C D) (.inter C E)) := by
  simpa using Set.inter_union_distrib_left (eval I C) (eval I D) (eval I E)

/-- Entailed subsumption is reflexive: `kb ⊨ C ⊑ C`. -/
theorem entailsSub_refl (kb : KB NC NR NI) (C : DLConcept NC NR) :
    entailsSub kb C C := fun _ _ => Set.Subset.refl _

/-- Entailed subsumption is transitive. -/
theorem entailsSub_trans {kb : KB NC NR NI} {C D E : DLConcept NC NR}
    (h₁ : entailsSub kb C D) (h₂ : entailsSub kb D E) : entailsSub kb C E :=
  fun I hI => Set.Subset.trans (h₁ I hI) (h₂ I hI)

/-- A TBox axiom `C ⊑ D` of a knowledge base is entailed by that knowledge base. -/
theorem entailsSub_of_mem (kb : KB NC NR NI) {C D : DLConcept NC NR}
    (h : ⟨C, D⟩ ∈ kb.tbox) : entailsSub kb C D :=
  fun _ hI => hI.1 _ h

/-- A concept assertion `C(a)` in the ABox is entailed by the knowledge base. -/
theorem entailsCon_of_mem (kb : KB NC NR NI) {a : NI} {C : DLConcept NC NR}
    (h : ⟨a, C⟩ ∈ kb.conAssertions) : entailsCon kb a C :=
  fun _ hI => hI.2.1 _ h

/-- Conjunction is below each conjunct: `kb ⊨ C ⊓ D ⊑ C`. -/
theorem entailsSub_inter_left (kb : KB NC NR NI) (C D : DLConcept NC NR) :
    entailsSub kb (.inter C D) C := fun _ _ => Set.inter_subset_left

/-- Conjunction is below each conjunct: `kb ⊨ C ⊓ D ⊑ D`. -/
theorem entailsSub_inter_right (kb : KB NC NR NI) (C D : DLConcept NC NR) :
    entailsSub kb (.inter C D) D := fun _ _ => Set.inter_subset_right

/-- Each disjunct is below the disjunction: `kb ⊨ C ⊑ C ⊔ D`. -/
theorem entailsSub_union_left (kb : KB NC NR NI) (C D : DLConcept NC NR) :
    entailsSub kb C (.union C D) := fun _ _ _ hx => Set.mem_union_left _ hx

/-- Monotonicity of the existential restriction in its concept argument:
from `kb ⊨ C ⊑ D` we get `kb ⊨ ∃R.C ⊑ ∃R.D`. -/
theorem entailsSub_ex_mono {kb : KB NC NR NI} {C D : DLConcept NC NR} (r : NR)
    (h : entailsSub kb C D) : entailsSub kb (.ex r C) (.ex r D) := by
  intro I hI x hx
  obtain ⟨y, hxy, hy⟩ := hx
  exact ⟨y, hxy, h I hI hy⟩

/-- Monotonicity of the universal restriction in its concept argument:
from `kb ⊨ C ⊑ D` we get `kb ⊨ ∀R.C ⊑ ∀R.D`. -/
theorem entailsSub_all_mono {kb : KB NC NR NI} {C D : DLConcept NC NR} (r : NR)
    (h : entailsSub kb C D) : entailsSub kb (.all r C) (.all r D) := by
  intro I hI x hx y hxy
  exact h I hI (hx y hxy)

/-- Instance checking via subsumption: if `a` is an instance of `C` and `kb ⊨ C ⊑ D`,
then `a` is an instance of `D`. -/
theorem entailsCon_of_sub {kb : KB NC NR NI} {a : NI} {C D : DLConcept NC NR}
    (hC : entailsCon kb a C) (hCD : entailsSub kb C D) : entailsCon kb a D :=
  fun I hI => hCD I hI (hC I hI)

/-! ## The Aristotle ontology

We now instantiate the framework with a concrete vocabulary describing the architecture of
the Aristotle system, following the technical report:

> "Aristotle integrates three main components: a Lean proof search system, an informal
> reasoning system that generates and formalizes lemmas, and a dedicated geometry solver."

and the soundness requirement:

> "we only consider a problem to be solved if our system produces a complete proof using
> the Lean 4 proof language ... without gaps or unsound axioms like `sorryAx`."
-/

/-- Atomic concepts (classes) of the Aristotle ontology. -/
inductive ACon where
  /-- The Aristotle system itself. -/
  | Aristotle
  /-- A subsystem of Aristotle. -/
  | Subsystem
  /-- The Lean proof-search subsystem. -/
  | SearchAlgorithm
  /-- The informal (lemma-based) reasoning subsystem. -/
  | InformalReasoning
  /-- The dedicated geometry solver subsystem. -/
  | GeometrySolver
  /-- A machine-verified formal (Lean) proof. -/
  | FormalProof
  /-- An informal, natural-language proof. -/
  | InformalProof
  /-- A lemma. -/
  | Lemma
  /-- A mathematical problem. -/
  | Problem
  /-- A problem that has been solved by the system. -/
  | SolvedProblem
  deriving DecidableEq, Repr

/-- Role names (binary relations) of the Aristotle ontology. -/
inductive ARole where
  /-- `hasSubsystem`: relates the system to its subsystems. -/
  | hasSubsystem
  /-- `justifiedBy`: relates a solved problem to a proof that justifies it. -/
  | justifiedBy
  /-- `generates`: relates the informal reasoning system to the lemmas it produces. -/
  | generates
  deriving DecidableEq, Repr

/-- Individual names of the Aristotle ontology. -/
inductive AInd where
  /-- The Aristotle system, as a named individual. -/
  | theAristotle
  /-- An exemplary solved IMO 2025 problem. -/
  | imo2025
  deriving DecidableEq, Repr

/-- Abbreviation for Aristotle-ontology concepts. -/
abbrev ACpt := DLConcept ACon ARole

/-- Abbreviation: an atomic Aristotle concept. -/
abbrev cpt (A : ACon) : ACpt := .atom A

open DLConcept

/-- The Aristotle TBox + ABox knowledge base.

TBox (terminology):
* each of the three named components is a `Subsystem`;
* `Aristotle` has each of the three components as a subsystem (existential restrictions);
* the informal reasoning subsystem generates lemmas;
* a `SolvedProblem` is justified by some `FormalProof` (soundness requirement);
* `FormalProof` and `InformalProof` are disjoint classes.

ABox (assertions):
* `theAristotle` is an `Aristotle`;
* `imo2025` is a `SolvedProblem`. -/
def aristotleKB : KB ACon ARole AInd where
  tbox :=
    [ ⟨cpt .SearchAlgorithm, cpt .Subsystem⟩,
      ⟨cpt .InformalReasoning, cpt .Subsystem⟩,
      ⟨cpt .GeometrySolver, cpt .Subsystem⟩,
      ⟨cpt .Aristotle, .ex .hasSubsystem (cpt .SearchAlgorithm)⟩,
      ⟨cpt .Aristotle, .ex .hasSubsystem (cpt .InformalReasoning)⟩,
      ⟨cpt .Aristotle, .ex .hasSubsystem (cpt .GeometrySolver)⟩,
      ⟨cpt .InformalReasoning, .ex .generates (cpt .Lemma)⟩,
      ⟨cpt .SolvedProblem, .ex .justifiedBy (cpt .FormalProof)⟩,
      ⟨cpt .FormalProof, .neg (cpt .InformalProof)⟩ ]
  conAssertions :=
    [ ⟨.theAristotle, cpt .Aristotle⟩,
      ⟨.imo2025, cpt .SolvedProblem⟩ ]
  roleAssertions := []

/-! ### Entailments about the Aristotle system -/

/-- The search algorithm is a subsystem (a direct TBox axiom). -/
theorem aristotle_search_is_subsystem :
    entailsSub aristotleKB (cpt .SearchAlgorithm) (cpt .Subsystem) :=
  entailsSub_of_mem aristotleKB (by simp [aristotleKB])

/-- Aristotle has a subsystem: `Aristotle ⊑ ∃hasSubsystem.Subsystem`.

This combines the axiom `Aristotle ⊑ ∃hasSubsystem.SearchAlgorithm` with
`SearchAlgorithm ⊑ Subsystem` and monotonicity of `∃`. -/
theorem aristotle_has_subsystem :
    entailsSub aristotleKB (cpt .Aristotle) (.ex .hasSubsystem (cpt .Subsystem)) := by
  intro I hI x hx
  obtain ⟨y, hxy, hy⟩ :
      ∃ y, I.roleI ARole.hasSubsystem x y ∧ y ∈ eval I (cpt ACon.SearchAlgorithm) :=
    hI.1 ⟨cpt .Aristotle, .ex .hasSubsystem (cpt .SearchAlgorithm)⟩ (by simp [aristotleKB]) hx
  exact ⟨y, hxy, aristotle_search_is_subsystem I hI hy⟩

/-- The named individual `theAristotle` has a subsystem (instance-level consequence). -/
theorem theAristotle_has_subsystem :
    entailsCon aristotleKB .theAristotle (.ex .hasSubsystem (cpt .Subsystem)) :=
  entailsCon_of_sub (C := cpt .Aristotle)
    (entailsCon_of_mem aristotleKB (by simp [aristotleKB])) aristotle_has_subsystem

/-- A solved problem must be justified by some formal proof (soundness requirement). -/
theorem solved_justified_by_formal :
    entailsSub aristotleKB (cpt .SolvedProblem)
      (.ex .justifiedBy (cpt .FormalProof)) :=
  entailsSub_of_mem aristotleKB (by simp [aristotleKB])

/-- The example IMO 2025 problem is justified by some formal proof. -/
theorem imo2025_justified_by_formal :
    entailsCon aristotleKB .imo2025 (.ex .justifiedBy (cpt .FormalProof)) :=
  entailsCon_of_sub (C := cpt .SolvedProblem)
    (entailsCon_of_mem aristotleKB (by simp [aristotleKB])) solved_justified_by_formal

/-- Soundness consequence: a solved problem cannot have *all* of its justifications be
merely informal proofs.  Formally, the concept
`SolvedProblem ⊓ (∀justifiedBy.InformalProof)` is unsatisfiable: a solved problem has some
formal justification, formal proofs are not informal, so not all justifications can be
informal. -/
theorem solved_not_all_informal :
    unsatisfiable aristotleKB
      (.inter (cpt .SolvedProblem) (.all .justifiedBy (cpt .InformalProof))) := by
  intro I hI x hx
  obtain ⟨y, hxy, hy⟩ :
      ∃ y, I.roleI ARole.justifiedBy x y ∧ y ∈ eval I (cpt ACon.FormalProof) :=
    hI.1 ⟨cpt .SolvedProblem, .ex .justifiedBy (cpt .FormalProof)⟩ (by simp [aristotleKB]) hx.1
  have hdisj : eval I (cpt ACon.FormalProof) ⊆ eval I (.neg (cpt ACon.InformalProof)) :=
    hI.1 ⟨cpt .FormalProof, .neg (cpt .InformalProof)⟩ (by simp [aristotleKB])
  exact (hdisj hy) (hx.2 y hxy)

end DescriptionLogic
