import RequestProject.Formula

/-!
# Natural Deduction Proof System

This file defines a Natural Deduction proof system for propositional logic,
following the blueprint's emphasis on introduction and elimination rules.

The system uses the standard rules:
- Assumption
- Implication introduction (→I) and elimination (→E / Modus Ponens)
- Conjunction introduction (∧I) and elimination (∧E₁, ∧E₂)
- Disjunction introduction (∨I₁, ∨I₂) and elimination (∨E)
- Falsum elimination (⊥E / ex falso)

This is the "primary model for Lean4 developers" as described in the blueprint.
-/

set_option maxHeartbeats 800000

namespace PropForm

/-- Natural Deduction provability: `NDProof Γ A` means A is derivable from hypotheses Γ. -/
inductive NDProof : List (PropForm V) → PropForm V → Prop
  /-- Assumption rule: if A ∈ Γ then Γ ⊢ A -/
  | ax : A ∈ Γ → NDProof Γ A
  /-- Implication introduction: if Γ, A ⊢ B then Γ ⊢ A → B -/
  | impI : NDProof (A :: Γ) B → NDProof Γ (imp A B)
  /-- Implication elimination (Modus Ponens): if Γ ⊢ A → B and Γ ⊢ A then Γ ⊢ B -/
  | impE : NDProof Γ (imp A B) → NDProof Γ A → NDProof Γ B
  /-- Conjunction introduction: if Γ ⊢ A and Γ ⊢ B then Γ ⊢ A ∧ B -/
  | conjI : NDProof Γ A → NDProof Γ B → NDProof Γ (conj A B)
  /-- Conjunction elimination left: if Γ ⊢ A ∧ B then Γ ⊢ A -/
  | conjE1 : NDProof Γ (conj A B) → NDProof Γ A
  /-- Conjunction elimination right: if Γ ⊢ A ∧ B then Γ ⊢ B -/
  | conjE2 : NDProof Γ (conj A B) → NDProof Γ B
  /-- Disjunction introduction left: if Γ ⊢ A then Γ ⊢ A ∨ B -/
  | disjI1 : NDProof Γ A → NDProof Γ (disj A B)
  /-- Disjunction introduction right: if Γ ⊢ B then Γ ⊢ A ∨ B -/
  | disjI2 : NDProof Γ B → NDProof Γ (disj A B)
  /-- Disjunction elimination: if Γ ⊢ A ∨ B, Γ,A ⊢ C, Γ,B ⊢ C then Γ ⊢ C -/
  | disjE : NDProof Γ (disj A B) → NDProof (A :: Γ) C → NDProof (B :: Γ) C → NDProof Γ C
  /-- Falsum elimination (ex falso quodlibet): if Γ ⊢ ⊥ then Γ ⊢ A -/
  | falsumE : NDProof Γ falsum → NDProof Γ A

notation:30 Γ " ⊢ₙ " A => NDProof Γ A

variable {V : Type*} {Γ Δ : List (PropForm V)} {A B C : PropForm V}

/-
Weakening: if Γ ⊢ A and Γ ⊆ Δ, then Δ ⊢ A.
-/
theorem NDProof.weaken (h : Γ ⊢ₙ A) (hsub : ∀ B, B ∈ Γ → B ∈ Δ) : Δ ⊢ₙ A := by
  revert hsub A h;
  intro A hA hsub
  induction' hA with A hA ih generalizing Δ;
  all_goals try exact?;
  · rename_i A B h₁ h₂;
    exact NDProof.impI ( h₂ fun B hB => by cases hB <;> aesop );
  · rename_i h₁ h₂ h₃ h₄ h₅ h₆;
    exact NDProof.disjE ( h₄ hsub ) ( h₅ fun B hB => by aesop ) ( h₆ fun B hB => by aesop )

/--
**The Deduction Theorem** (Forward direction):
If Γ, A ⊢ B then Γ ⊢ A → B.

This is exactly the implication introduction rule.
As the blueprint states: "Utilize the Deduction Theorem to transform
global goals into local contexts."
-/
theorem deduction_theorem_fwd (h : (A :: Γ) ⊢ₙ B) : Γ ⊢ₙ (imp A B) :=
  NDProof.impI h

/-
**The Deduction Theorem** (Backward direction):
If Γ ⊢ A → B then Γ, A ⊢ B.
-/
theorem deduction_theorem_bwd (h : Γ ⊢ₙ (imp A B)) : (A :: Γ) ⊢ₙ B := by
  exact NDProof.impE ( NDProof.weaken h fun _ => by tauto ) ( NDProof.ax ( by tauto ) )

/--
**The Deduction Theorem** (Biconditional):
Γ, A ⊢ B if and only if Γ ⊢ A → B.
-/
theorem deduction_theorem : ((A :: Γ) ⊢ₙ B) ↔ (Γ ⊢ₙ (imp A B)) :=
  ⟨deduction_theorem_fwd, deduction_theorem_bwd⟩

/-
**Soundness of Natural Deduction**:
If Γ ⊢ A in natural deduction, then Γ ⊨ A (semantic entailment).

As the blueprint states: "Soundness: provability implies truth."
-/
theorem NDProof.sound (h : Γ ⊢ₙ A) : SemEntails Γ A := by
  intro v hv;
  induction h;
  all_goals simp_all +decide [ PropForm.eval ]; all_goals grobner

/-- Identity: A ⊢ A -/
theorem NDProof.identity : ([A] : List (PropForm V)) ⊢ₙ A :=
  NDProof.ax List.mem_cons_self

/-- ⊢ A → A (tautology) -/
theorem NDProof.imp_self : ([] : List (PropForm V)) ⊢ₙ imp A A :=
  NDProof.impI NDProof.identity

/-- ⊢ ⊤ (verum is provable) -/
theorem NDProof.verum_provable : ([] : List (PropForm V)) ⊢ₙ verum :=
  NDProof.imp_self

end PropForm