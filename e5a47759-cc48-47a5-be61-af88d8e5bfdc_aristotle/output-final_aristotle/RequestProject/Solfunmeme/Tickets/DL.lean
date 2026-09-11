/-
The description logic ALC: syntax, semantics, knowledge bases, and a checked
finite-model evaluator.
-/
import Mathlib.Tactic

/-!
# A description logic for ticket databases

This file sets up the description logic **ALC** (attributive concept language
with complements) in the usual Tarski style, together with everything needed to
reason about a concrete knowledge base:

* `Concept A R` — concept expressions over atomic concepts `A` and roles `R`;
* `Interp` — an interpretation: a non-empty domain, a reading of every atomic
  concept as a set and of every role as a binary relation, and a name for every
  individual;
* `GCI` / `Assertion` / `KB` — general concept inclusions (the TBox), instance
  and role assertions (the ABox), and knowledge bases;
* `KB.Consistent`, `KB.entails`, `KB.entailsGCI` — satisfiability and the two
  entailment relations, defined semantically (true in *every* model);
* `FModel` — a finite interpretation given by data, with a boolean evaluator
  `FModel.bev` proved (`FModel.eval_iff`) to agree with the Tarski semantics.
  This turns "is this knowledge base consistent?" and "what is the extension of
  this concept?" into computations the kernel can check.

The vocabulary of the SOLFUNMEME ticket database is in `Vocabulary.lean`, the
ABox in `Corpus.lean`, the ontology in `TBox.lean`.
-/

namespace SFM.DL

/-- Concept expressions of ALC over atomic concepts `A` and role names `R`. -/
inductive Concept (A R : Type) where
  /-- `⊤`, the concept every individual belongs to. -/
  | top : Concept A R
  /-- `⊥`, the empty concept. -/
  | bot : Concept A R
  /-- An atomic concept. -/
  | atom (a : A) : Concept A R
  /-- `¬C`. -/
  | neg (C : Concept A R) : Concept A R
  /-- `C ⊓ D`. -/
  | and (C D : Concept A R) : Concept A R
  /-- `C ⊔ D`. -/
  | or (C D : Concept A R) : Concept A R
  /-- `∀r.C`, the individuals all of whose `r`-successors are in `C`. -/
  | all (r : R) (C : Concept A R) : Concept A R
  /-- `∃r.C`, the individuals with some `r`-successor in `C`. -/
  | ex (r : R) (C : Concept A R) : Concept A R
  deriving Repr, DecidableEq

namespace Concept

variable {A R : Type}

/-- `C ⊑ D` expressed as a concept: `¬C ⊔ D`. -/
def implies (C D : Concept A R) : Concept A R := .or (.neg C) D

/-- The conjunction of a list of concepts (`⊤` when the list is empty). -/
def andAll : List (Concept A R) → Concept A R
  | [] => .top
  | [C] => C
  | C :: Cs => .and C (andAll Cs)

/-- The disjunction of a list of concepts (`⊥` when the list is empty). -/
def orAll : List (Concept A R) → Concept A R
  | [] => .bot
  | [C] => C
  | C :: Cs => .or C (orAll Cs)

end Concept

/-- A general concept inclusion `lhs ⊑ rhs`. -/
structure GCI (A R : Type) where
  /-- The subsumed concept. -/
  lhs : Concept A R
  /-- The subsuming concept. -/
  rhs : Concept A R
  deriving Repr, DecidableEq

/-- An ABox assertion: either `C(i)` or `r(i, j)`. -/
inductive Assertion (A R I : Type) where
  /-- The individual `i` is an instance of `C`. -/
  | inst (i : I) (C : Concept A R) : Assertion A R I
  /-- The individuals `i` and `j` are related by the role `r`. -/
  | rel (r : R) (i j : I) : Assertion A R I

/-- A knowledge base: a TBox of inclusions and an ABox of assertions. -/
structure KB (A R I : Type) where
  /-- The terminology. -/
  tbox : List (GCI A R)
  /-- The assertions about named individuals. -/
  abox : List (Assertion A R I)

/-- An interpretation of the vocabulary: a non-empty domain, an extension for
every atomic concept and role, and a denotation for every individual name. -/
structure Interp (A R I : Type) where
  /-- The domain of discourse. -/
  Dom : Type
  /-- Interpretations have non-empty domains. -/
  dom_nonempty : Nonempty Dom
  /-- The denotation of an individual name. -/
  ind : I → Dom
  /-- The extension of an atomic concept. -/
  atomI : A → Dom → Prop
  /-- The extension of a role. -/
  roleI : R → Dom → Dom → Prop

namespace Interp

variable {A R I : Type}

/-- The Tarski semantics of a concept expression. -/
def eval (M : Interp A R I) : Concept A R → M.Dom → Prop
  | .top, _ => True
  | .bot, _ => False
  | .atom a, d => M.atomI a d
  | .neg C, d => ¬ M.eval C d
  | .and C D, d => M.eval C d ∧ M.eval D d
  | .or C D, d => M.eval C d ∨ M.eval D d
  | .all r C, d => ∀ e, M.roleI r d e → M.eval C e
  | .ex r C, d => ∃ e, M.roleI r d e ∧ M.eval C e

@[simp] theorem eval_top (M : Interp A R I) (d) : M.eval .top d ↔ True := Iff.rfl
@[simp] theorem eval_bot (M : Interp A R I) (d) : M.eval .bot d ↔ False := Iff.rfl
@[simp] theorem eval_atom (M : Interp A R I) (a) (d) : M.eval (.atom a) d ↔ M.atomI a d := Iff.rfl
@[simp] theorem eval_neg (M : Interp A R I) (C) (d) : M.eval (.neg C) d ↔ ¬ M.eval C d := Iff.rfl
@[simp] theorem eval_and (M : Interp A R I) (C D) (d) :
    M.eval (.and C D) d ↔ M.eval C d ∧ M.eval D d := Iff.rfl
@[simp] theorem eval_or (M : Interp A R I) (C D) (d) :
    M.eval (.or C D) d ↔ M.eval C d ∨ M.eval D d := Iff.rfl
@[simp] theorem eval_all (M : Interp A R I) (r C) (d) :
    M.eval (.all r C) d ↔ ∀ e, M.roleI r d e → M.eval C e := Iff.rfl
@[simp] theorem eval_ex (M : Interp A R I) (r C) (d) :
    M.eval (.ex r C) d ↔ ∃ e, M.roleI r d e ∧ M.eval C e := Iff.rfl

/-- A disjunct that holds makes the whole disjunction hold. -/
theorem eval_orAll_of_mem (M : Interp A R I) (d : M.Dom) :
    ∀ {Cs : List (Concept A R)} {C : Concept A R}, C ∈ Cs → M.eval C d →
      M.eval (Concept.orAll Cs) d
  | [], _, h, _ => absurd h (by simp)
  | [_], _, h, hC => by
      rw [List.mem_singleton] at h; subst h; exact hC
  | C₁ :: C₂ :: Cs, C, h, hC => by
      rcases List.mem_cons.1 h with rfl | h'
      · exact Or.inl hC
      · exact Or.inr (M.eval_orAll_of_mem d h' hC)

/-- `M` satisfies the inclusion `lhs ⊑ rhs`. -/
def satGCI (M : Interp A R I) (g : GCI A R) : Prop := ∀ d, M.eval g.lhs d → M.eval g.rhs d

/-- `M` satisfies an ABox assertion. -/
def satAssertion (M : Interp A R I) : Assertion A R I → Prop
  | .inst i C => M.eval C (M.ind i)
  | .rel r i j => M.roleI r (M.ind i) (M.ind j)

/-- `M` is a model of the knowledge base `K`. -/
def IsModel (M : Interp A R I) (K : KB A R I) : Prop :=
  (∀ g ∈ K.tbox, M.satGCI g) ∧ (∀ a ∈ K.abox, M.satAssertion a)

end Interp

namespace KB

variable {A R I : Type}

/-- A knowledge base is consistent when it has a model. -/
def Consistent (K : KB A R I) : Prop := ∃ M : Interp A R I, M.IsModel K

/-- `K` entails an assertion when the assertion holds in every model of `K`. -/
def entails (K : KB A R I) (a : Assertion A R I) : Prop :=
  ∀ M : Interp A R I, M.IsModel K → M.satAssertion a

/-- `K` entails a subsumption when it holds in every model of `K`. -/
def entailsGCI (K : KB A R I) (g : GCI A R) : Prop :=
  ∀ M : Interp A R I, M.IsModel K → M.satGCI g

/-- Everything in the ABox is entailed. -/
theorem entails_of_mem_abox {K : KB A R I} {a : Assertion A R I} (h : a ∈ K.abox) :
    K.entails a := fun _ hM => hM.2 a h

/-- Everything in the TBox is entailed. -/
theorem entailsGCI_of_mem_tbox {K : KB A R I} {g : GCI A R} (h : g ∈ K.tbox) :
    K.entailsGCI g := fun _ hM => hM.1 g h

/-- Subsumption entailment is reflexive. -/
theorem entailsGCI_refl (K : KB A R I) (C : Concept A R) : K.entailsGCI ⟨C, C⟩ :=
  fun _ _ _ h => h

/-- Subsumption entailment is transitive. -/
theorem entailsGCI_trans {K : KB A R I} {C D E : Concept A R}
    (h₁ : K.entailsGCI ⟨C, D⟩) (h₂ : K.entailsGCI ⟨D, E⟩) : K.entailsGCI ⟨C, E⟩ :=
  fun M hM d hd => h₂ M hM d (h₁ M hM d hd)

/-- Entailed subsumptions can be used on entailed instances. -/
theorem entails_inst_of_sub {K : KB A R I} {C D : Concept A R} {i : I}
    (hsub : K.entailsGCI ⟨C, D⟩) (hi : K.entails (.inst i C)) : K.entails (.inst i D) :=
  fun M hM => hsub M hM _ (hi M hM)

/-- Subsumption is monotone under `∃r.-`. -/
theorem entailsGCI_ex {K : KB A R I} {C D : Concept A R} (r : R)
    (h : K.entailsGCI ⟨C, D⟩) : K.entailsGCI ⟨.ex r C, .ex r D⟩ := by
  rintro M hM d ⟨e, he, hCe⟩
  exact ⟨e, he, h M hM e hCe⟩

/-- Subsumption is monotone under `∀r.-`. -/
theorem entailsGCI_all {K : KB A R I} {C D : Concept A R} (r : R)
    (h : K.entailsGCI ⟨C, D⟩) : K.entailsGCI ⟨.all r C, .all r D⟩ :=
  fun M hM _ hd e he => h M hM e (hd e he)

/-- A model in which an assertion fails refutes its entailment. -/
theorem not_entails_of_model {K : KB A R I} {M : Interp A R I} (hM : M.IsModel K)
    {a : Assertion A R I} (h : ¬ M.satAssertion a) : ¬ K.entails a :=
  fun hent => h (hent M hM)

/-- A model in which a subsumption fails refutes its entailment. -/
theorem not_entailsGCI_of_model {K : KB A R I} {M : Interp A R I} (hM : M.IsModel K)
    {g : GCI A R} (h : ¬ M.satGCI g) : ¬ K.entailsGCI g :=
  fun hent => h (hent M hM)

/-- A consistent knowledge base never entails that a named individual is
absurd. This is what makes consistency worth proving: an inconsistent knowledge
base entails everything. -/
theorem not_entails_bot_of_consistent {K : KB A R I} (h : K.Consistent) (i : I) :
    ¬ K.entails (.inst i .bot) := by
  rintro hbot
  obtain ⟨M, hM⟩ := h
  exact hbot M hM

end KB

/-- A finite interpretation presented as data: a non-empty list of individuals
(names are natural numbers), a boolean membership test for atomic concepts and,
for each role, the list of successors of each individual. -/
structure FModel (A R : Type) where
  /-- The domain, as a list of individual keys. -/
  dom : List Nat
  /-- Domains are non-empty. -/
  dom_ne : dom ≠ []
  /-- Membership test for atomic concepts. -/
  atomB : A → Nat → Bool
  /-- Successors of an individual under a role. -/
  succ : R → Nat → List Nat
  /-- Roles do not lead outside the domain. -/
  succ_sub : ∀ r d e, e ∈ succ r d → e ∈ dom

namespace FModel

variable {A R : Type}

/-- A distinguished element of the domain, used to interpret individual names
that do not occur in the model. -/
def dflt (M : FModel A R) : {d : Nat // d ∈ M.dom} :=
  ⟨M.dom.head M.dom_ne, List.head_mem _⟩

/-- The denotation of an individual name. -/
def pt (M : FModel A R) (i : Nat) : {d : Nat // d ∈ M.dom} :=
  if h : i ∈ M.dom then ⟨i, h⟩ else M.dflt

/-- The interpretation described by a finite model. -/
def toInterp (M : FModel A R) : Interp A R Nat where
  Dom := {d : Nat // d ∈ M.dom}
  dom_nonempty := ⟨M.dflt⟩
  ind := M.pt
  atomI a x := M.atomB a x.1 = true
  roleI r x y := y.1 ∈ M.succ r x.1

/-- Boolean evaluation of a concept in a finite model. -/
def bev (M : FModel A R) : Concept A R → Nat → Bool
  | .top, _ => true
  | .bot, _ => false
  | .atom a, d => M.atomB a d
  | .neg C, d => !(M.bev C d)
  | .and C D, d => M.bev C d && M.bev D d
  | .or C D, d => M.bev C d || M.bev D d
  | .all r C, d => (M.succ r d).all (fun e => M.bev C e)
  | .ex r C, d => (M.succ r d).any (fun e => M.bev C e)

/-- The boolean evaluator computes the Tarski semantics. -/
theorem eval_iff (M : FModel A R) (C : Concept A R) (x : M.toInterp.Dom) :
    M.toInterp.eval C x ↔ M.bev C x.1 = true := by
  induction C generalizing x with
  | top => simp [bev]
  | bot => simp [bev]
  | atom a => simp [bev, toInterp, Interp.eval]
  | neg C ih => simp [bev, Interp.eval, ih]
  | and C D ihC ihD => simp [bev, Interp.eval, ihC, ihD]
  | or C D ihC ihD => simp [bev, Interp.eval, ihC, ihD]
  | all r C ih =>
      simp only [bev, Interp.eval_all, List.all_eq_true]
      constructor
      · intro h e he
        exact (ih ⟨e, M.succ_sub r x.1 e he⟩).1 (h ⟨e, M.succ_sub r x.1 e he⟩ he)
      · intro h e he
        exact (ih e).2 (h e.1 he)
  | ex r C ih =>
      simp only [bev, Interp.eval_ex, List.any_eq_true]
      constructor
      · rintro ⟨e, he, hCe⟩
        exact ⟨e.1, he, (ih e).1 hCe⟩
      · rintro ⟨e, he, hCe⟩
        exact ⟨⟨e, M.succ_sub r x.1 e he⟩, he, (ih ⟨e, M.succ_sub r x.1 e he⟩).2 hCe⟩

/-- Boolean check that an inclusion holds in a finite model. -/
def checkGCI (M : FModel A R) (g : GCI A R) : Bool :=
  M.dom.all (fun d => !(M.bev g.lhs d) || M.bev g.rhs d)

/-- Boolean check that an assertion holds in a finite model. -/
def checkAssertion (M : FModel A R) : Assertion A R Nat → Bool
  | .inst i C => M.dom.contains i && M.bev C i
  | .rel r i j => M.dom.contains i && (M.succ r i).contains j

/-- Boolean check that a finite model is a model of a knowledge base. -/
def checkKB (M : FModel A R) (K : KB A R Nat) : Bool :=
  K.tbox.all (fun g => M.checkGCI g) && K.abox.all (fun a => M.checkAssertion a)

theorem pt_val (M : FModel A R) {i : Nat} (h : i ∈ M.dom) : (M.pt i).1 = i := by
  simp [pt, h]

theorem satGCI_of_checkGCI {M : FModel A R} {g : GCI A R} (h : M.checkGCI g = true) :
    M.toInterp.satGCI g := by
  intro x hx
  have hx' : M.bev g.lhs x.1 = true := (M.eval_iff _ x).1 hx
  have := (List.all_eq_true.1 h) x.1 x.2
  rw [hx'] at this
  simpa [eval_iff] using this

theorem satAssertion_of_check {M : FModel A R} {a : Assertion A R Nat}
    (h : M.checkAssertion a = true) : M.toInterp.satAssertion a := by
  cases a with
  | inst i C =>
      simp only [checkAssertion, Bool.and_eq_true, List.contains_iff_mem] at h
      have hi : i ∈ M.dom := h.1
      show M.toInterp.eval C (M.pt i)
      rw [eval_iff, pt_val M hi]
      exact h.2
  | rel r i j =>
      simp only [checkAssertion, Bool.and_eq_true, List.contains_iff_mem] at h
      have hi : i ∈ M.dom := h.1
      show (M.pt j).1 ∈ M.succ r (M.pt i).1
      have hj : j ∈ M.dom := M.succ_sub r i j h.2
      rw [pt_val M hi, pt_val M hj]
      exact h.2

theorem isModel_of_checkKB {M : FModel A R} {K : KB A R Nat} (h : M.checkKB K = true) :
    M.toInterp.IsModel K := by
  simp only [checkKB, Bool.and_eq_true, List.all_eq_true] at h
  exact ⟨fun g hg => satGCI_of_checkGCI (h.1 g hg),
         fun a ha => satAssertion_of_check (h.2 a ha)⟩

/-- A finite model that checks out witnesses consistency. -/
theorem consistent_of_checkKB {M : FModel A R} {K : KB A R Nat} (h : M.checkKB K = true) :
    K.Consistent := ⟨M.toInterp, isModel_of_checkKB h⟩

/-- The extension of a concept in a finite model: the individuals satisfying it. -/
def extension (M : FModel A R) (C : Concept A R) : List Nat :=
  M.dom.filter (fun d => M.bev C d)

theorem mem_extension {M : FModel A R} {C : Concept A R} {d : Nat} :
    d ∈ M.extension C ↔ d ∈ M.dom ∧ M.bev C d = true := by
  simp [extension, List.mem_filter]

end FModel

end SFM.DL
