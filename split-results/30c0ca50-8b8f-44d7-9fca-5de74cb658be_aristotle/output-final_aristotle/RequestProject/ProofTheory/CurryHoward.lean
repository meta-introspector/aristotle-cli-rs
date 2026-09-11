import Mathlib

/-!
# The Curry-Howard Correspondence

This file demonstrates the Curry-Howard Correspondence (Formulas-as-Types)
as described in the blueprint:

"In Lean4, writing a proof is functionally identical to writing a program."

We demonstrate the isomorphism between logical operations and computational types:
- Implication ↔ Function types
- Conjunction ↔ Product types
- Disjunction ↔ Sum types
- Universal quantifier ↔ Dependent function types (Π-types)
- Existential quantifier ↔ Dependent pair types (Σ-types)
- Falsum ↔ Empty type

Each demonstration shows both the logical proof and its computational
interpretation, making the correspondence explicit.
-/

set_option maxHeartbeats 400000

namespace CurryHoward

/-! ## Implication ↔ Function Types

"A proof of A → B is a function mapping evidence of A to evidence of B." -/

/-- Modus Ponens as function application -/
def modusPonens {A B : Prop} (f : A → B) (a : A) : B := f a

/-- Hypothetical syllogism as function composition -/
def hypSyllogism {A B C : Prop} (f : A → B) (g : B → C) : A → C := g ∘ f

/-- The K combinator: A → B → A -/
def kCombinator {A B : Prop} (a : A) (_ : B) : A := a

/-- The S combinator: (A → B → C) → (A → B) → A → C -/
def sCombinator {A B C : Prop} (f : A → B → C) (g : A → B) (a : A) : C := f a (g a)

/-! ## Conjunction ↔ Product Types

"A proof of A ∧ B is a pair consisting of a proof of A and a proof of B." -/

/-- Conjunction introduction as pair construction -/
def conjIntro {A B : Prop} (a : A) (b : B) : A ∧ B := ⟨a, b⟩

/-- Conjunction elimination (left) as first projection -/
def conjElimLeft {A B : Prop} (p : A ∧ B) : A := p.1

/-- Conjunction elimination (right) as second projection -/
def conjElimRight {A B : Prop} (p : A ∧ B) : B := p.2

/-- Commutativity of conjunction as pair swapping -/
def conjComm {A B : Prop} (p : A ∧ B) : B ∧ A := ⟨p.2, p.1⟩

/-! ## Disjunction ↔ Sum Types

"A proof of A ∨ B is a tagged union indicating which disjunct is proven." -/

/-- Disjunction introduction (left) as left injection -/
def disjIntroLeft {A B : Prop} (a : A) : A ∨ B := Or.inl a

/-- Disjunction introduction (right) as right injection -/
def disjIntroRight {A B : Prop} (b : B) : A ∨ B := Or.inr b

/-- Disjunction elimination as case analysis / pattern matching -/
def disjElim {A B C : Prop} (d : A ∨ B) (f : A → C) (g : B → C) : C := d.elim f g

/-- Commutativity of disjunction as sum swapping -/
def disjComm {A B : Prop} (d : A ∨ B) : B ∨ A :=
  d.elim Or.inr Or.inl

/-! ## Falsum ↔ Empty Type

"A proof of ⊥ (False) is an element of the empty type — it cannot exist." -/

/-- Ex falso quodlibet: from False, derive anything -/
def exFalso {A : Prop} (f : False) : A := f.elim

/-- Negation as function to the empty type: ¬A = A → False -/
example {A : Prop} : (¬A) = (A → False) := rfl

/-! ## Universal Quantifier ↔ Dependent Function Types (Π-types)

"A proof of ∀ x, P x is a function that, given any x, returns a proof of P x." -/

/-- Universal instantiation as function application -/
def univInst {α : Type*} {P : α → Prop} (h : ∀ x, P x) (a : α) : P a := h a

/-- Transitivity of ≤ on ℕ as a dependent function -/
def leTransNat : ∀ (a b c : ℕ), a ≤ b → b ≤ c → a ≤ c :=
  fun _ _ _ hab hbc => Nat.le_trans hab hbc

/-! ## Existential Quantifier ↔ Dependent Pair Types (Σ-types)

"A proof of ∃ x, P x is a pair (witness, proof) — a dependent pair." -/

/-- Existential introduction as dependent pair construction -/
def existIntro {α : Type*} {P : α → Prop} (w : α) (hw : P w) : ∃ x, P x := ⟨w, hw⟩

/-- Example: there exists an even natural number (witness: 2) -/
theorem exists_even_nat : ∃ n : ℕ, Even n := ⟨2, ⟨1, rfl⟩⟩

/-- Existential elimination: given ∃ x, P x and ∀ x, P x → Q, derive Q -/
def existElim {α : Type*} {P : α → Prop} {Q : Prop}
    (h : ∃ x, P x) (f : ∀ x, P x → Q) : Q :=
  let ⟨w, hw⟩ := h; f w hw

/-! ## Distributivity Laws as Program Transformations

These demonstrate how logical equivalences correspond to type isomorphisms. -/

/-- Distribution of ∧ over ∨ (currying/uncurrying at the type level) -/
theorem and_dist_or (A B C : Prop) : A ∧ (B ∨ C) ↔ (A ∧ B) ∨ (A ∧ C) := by
  constructor
  · rintro ⟨ha, hbc⟩
    exact hbc.elim (fun hb => Or.inl ⟨ha, hb⟩) (fun hc => Or.inr ⟨ha, hc⟩)
  · rintro (⟨ha, hb⟩ | ⟨ha, hc⟩)
    · exact ⟨ha, Or.inl hb⟩
    · exact ⟨ha, Or.inr hc⟩

/-- Currying: (A ∧ B → C) ↔ (A → B → C) -/
theorem curry_uncurry (A B C : Prop) : (A ∧ B → C) ↔ (A → B → C) := by
  constructor
  · intro h a b; exact h ⟨a, b⟩
  · intro h ⟨a, b⟩; exact h a b

/-! ## Classical vs. Constructive Logic

As the blueprint states: "Intuitionistic systems do not assume the Law of
Excluded Middle (A ∨ ¬A) by default. In Lean4, using LEM requires the
classical attribute." -/

/-- Double negation elimination requires classical logic -/
theorem dne (A : Prop) : ¬¬A → A := by
  intro h
  by_contra hna
  exact h hna

/-- Law of Excluded Middle (classical) -/
theorem lem_demo (A : Prop) : A ∨ ¬A := Classical.em A

/-- Peirce's law requires classical reasoning -/
theorem peirce (A B : Prop) : ((A → B) → A) → A := by
  intro h
  by_contra hna
  exact hna (h (fun a => absurd a hna))

/-- De Morgan's law (one direction is constructive) -/
theorem deMorgan_conj_constructive (A B : Prop) : ¬(A ∧ B) → ¬A ∨ ¬B := by
  intro h
  by_contra hc
  push_neg at hc
  exact h ⟨hc.1, hc.2⟩

end CurryHoward
