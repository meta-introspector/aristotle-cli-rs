/-
# Section 5: The Curry-Howard Isomorphism and Structural Proof Theory

This file demonstrates the three-way correspondence between:
- **Logic** (propositions and proofs)
- **Computation** (types and terms / λ-calculus)
- **Categories** (objects and morphisms in a CCC)

In Lean4, this correspondence is not just a theorem — it is the *architecture*
of the proof assistant itself. Types are propositions, terms are proofs.
-/

import Mathlib

open CategoryTheory

/-! ## 5.1 The Curry-Howard Mapping

| Logic           | Computation        | Categories         |
|-----------------|--------------------|--------------------|
| Formula A       | Type T             | Object A           |
| Proof A ⊢ B     | Term x:A ⊢ t:B    | Morphism f: A → B  |
| Conjunction ∧   | Product Type ×     | Product A × B      |
| Implication →   | Function Type →    | Exponential B^A    |
| Disjunction ∨   | Sum Type ⊕         | Coproduct A + B    |
| True            | Unit               | Terminal Object     |
| False           | Empty              | Initial Object     |
-/

section CurryHowardMapping

/-! ### Conjunction ↔ Product -/

/-- Conjunction introduction corresponds to pair construction (product). -/
theorem conj_intro (P Q : Prop) (hp : P) (hq : Q) : P ∧ Q :=
  ⟨hp, hq⟩

/-- Conjunction elimination corresponds to projections. -/
theorem conj_elim_left (P Q : Prop) (hpq : P ∧ Q) : P := hpq.1
theorem conj_elim_right (P Q : Prop) (hpq : P ∧ Q) : Q := hpq.2

/-- At the type level: product pairing. -/
def type_pair (A B : Type) (a : A) (b : B) : A × B := (a, b)
def type_fst (A B : Type) (p : A × B) : A := p.1
def type_snd (A B : Type) (p : A × B) : B := p.2

/-! ### Implication ↔ Function Type ↔ Exponential -/

/-- Modus ponens is function application. -/
theorem modus_ponens (P Q : Prop) (hpq : P → Q) (hp : P) : Q := hpq hp

/-- At the type level: function application. -/
def type_apply (A B : Type) (f : A → B) (a : A) : B := f a

/-! ### Disjunction ↔ Sum Type ↔ Coproduct -/

/-- Disjunction elimination is case analysis (copairing). -/
theorem disj_elim (P Q R : Prop) (hpq : P ∨ Q) (hp : P → R) (hq : Q → R) : R :=
  hpq.elim hp hq

/-- At the type level: sum elimination. -/
def type_cases (A B C : Type) (s : A ⊕ B) (f : A → C) (g : B → C) : C :=
  match s with
  | .inl a => f a
  | .inr b => g b

/-! ### False ↔ Empty ↔ Initial Object -/

/-- Ex falso quodlibet: from False, anything follows. -/
theorem ex_falso (P : Prop) (h : False) : P := h.elim

/-- At the type level: from Empty, we can produce any type. -/
def type_absurd (A : Type) (e : Empty) : A := e.elim

/-! ### True ↔ Unit ↔ Terminal Object -/

/-- True has exactly one proof. -/
theorem true_unique (h1 h2 : True) : h1 = h2 := rfl

/-- Unit has exactly one element. -/
theorem unit_unique (u1 u2 : Unit) : u1 = u2 := rfl

end CurryHowardMapping

/-! ## 5.2 β-reduction and η-conversion

- **β-reduction**: `(λ x. t) u = t[u/x]` — evaluating a function application.
- **η-conversion**: `(λ x. f x) = f` — extensionality of functions.

These correspond to the evaluation and uniqueness of exponential objects in a CCC.
-/

section BetaEta

/-- β-reduction: applying a lambda to an argument yields the substituted body. -/
theorem beta_reduction (A B : Type) (t : A → B) (u : A) :
    (fun x => t x) u = t u :=
  rfl

/-- η-conversion: a function equals the lambda that applies it (extensionality). -/
theorem eta_conversion (A B : Type) (f : A → B) :
    (fun x => f x) = f :=
  rfl

/-- The substitution lemma in type-theoretic form:
    Given `t : A × B → C` and `u : A → B`, the substitution
    `t[u/x]` becomes `t ∘ ⟨id, u⟩`. -/
theorem substitution_lemma (A B C : Type) (t : A × B → C) (u : A → B) :
    (fun a => t (a, u a)) = t ∘ (fun a => (a, u a)) :=
  rfl

end BetaEta

/-! ## 5.3 Propositions as Types in Lean4 -/

section PropsAsTypes

/-- Transitivity of implication is function composition. -/
theorem imp_trans (P Q R : Prop) (hpq : P → Q) (hqr : Q → R) : P → R :=
  hqr ∘ hpq

/-- Modus tollens via the contrapositive. -/
theorem modus_tollens (P Q : Prop) (hpq : P → Q) (hnq : ¬Q) : ¬P :=
  fun hp => hnq (hpq hp)

/-- De Morgan's law (one direction, constructive). -/
theorem de_morgan_conj (P Q : Prop) (h : ¬(P ∧ Q)) (hp : P) : ¬Q :=
  fun hq => h ⟨hp, hq⟩

/-- The double negation introduction (constructive). -/
theorem double_neg_intro (P : Prop) (hp : P) : ¬¬P :=
  fun hnp => hnp hp

end PropsAsTypes
