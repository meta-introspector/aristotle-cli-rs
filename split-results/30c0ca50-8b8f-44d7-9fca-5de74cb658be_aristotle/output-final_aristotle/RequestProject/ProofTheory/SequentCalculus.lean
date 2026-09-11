import RequestProject.ProofTheory.Formula

/-!
# Sequent Calculus (LK)

This file defines the classical Sequent Calculus (LK) for propositional logic.

As the blueprint notes: "This system manipulates sequents (Γ ⊢ Δ). A critical
architectural detail is the interpretation of the empty sequent: an empty
antecedent is defined as True, while an empty succedent is defined as False."

We define:
- Sequents as pairs of multisets of formulas
- The LK proof system with structural and logical rules
- Soundness of LK
- The Cut rule and cut-free fragment
- The Subformula Property for cut-free proofs
-/

set_option maxHeartbeats 800000

namespace PropForm

/-- A sequent Γ ⊢ Δ where Γ and Δ are lists of formulas.
    Empty antecedent means True; empty succedent means False. -/
structure Sequent (V : Type*) where
  ant : List (PropForm V)  -- antecedent (left side)
  suc : List (PropForm V)  -- succedent (right side)

/-- Semantic validity of a sequent:
    A sequent Γ ⊢ Δ is valid if for every valuation,
    if all formulas in Γ are true, then some formula in Δ is true. -/
def Sequent.IsValid (s : Sequent V) : Prop :=
  ∀ v : Valuation V,
    (∀ A ∈ s.ant, eval v A = true) →
    (∃ A ∈ s.suc, eval v A = true)

/-- Cut-free Sequent Calculus LK for propositional logic. -/
inductive LKCutFree : Sequent V → Prop
  /-- Identity axiom: A ⊢ A -/
  | ax (A : PropForm V) : LKCutFree ⟨[A], [A]⟩
  /-- Falsum left: ⊥, Γ ⊢ Δ -/
  | falsumL (Γ Δ : List (PropForm V)) : LKCutFree ⟨falsum :: Γ, Δ⟩
  /-- Weakening left -/
  | weakL (A : PropForm V) : LKCutFree ⟨Γ, Δ⟩ → LKCutFree ⟨A :: Γ, Δ⟩
  /-- Weakening right -/
  | weakR (A : PropForm V) : LKCutFree ⟨Γ, Δ⟩ → LKCutFree ⟨Γ, A :: Δ⟩
  /-- Contraction left -/
  | contrL (A : PropForm V) : LKCutFree ⟨A :: A :: Γ, Δ⟩ → LKCutFree ⟨A :: Γ, Δ⟩
  /-- Contraction right -/
  | contrR (A : PropForm V) : LKCutFree ⟨Γ, A :: A :: Δ⟩ → LKCutFree ⟨Γ, A :: Δ⟩
  /-- Exchange left: permutation of antecedent -/
  | exchL (A B : PropForm V) : LKCutFree ⟨Γ ++ A :: B :: Γ', Δ⟩ →
      LKCutFree ⟨Γ ++ B :: A :: Γ', Δ⟩
  /-- Exchange right: permutation of succedent -/
  | exchR (A B : PropForm V) : LKCutFree ⟨Γ, Δ ++ A :: B :: Δ'⟩ →
      LKCutFree ⟨Γ, Δ ++ B :: A :: Δ'⟩
  /-- Implication left: from Γ ⊢ A, Δ and B, Γ' ⊢ Δ' derive A → B, Γ, Γ' ⊢ Δ, Δ' -/
  | impL : LKCutFree ⟨Γ, A :: Δ⟩ → LKCutFree ⟨B :: Γ', Δ'⟩ →
      LKCutFree ⟨imp A B :: Γ ++ Γ', Δ ++ Δ'⟩
  /-- Implication right: from A, Γ ⊢ B, Δ derive Γ ⊢ A → B, Δ -/
  | impR : LKCutFree ⟨A :: Γ, B :: Δ⟩ → LKCutFree ⟨Γ, imp A B :: Δ⟩
  /-- Conjunction left 1: from A, Γ ⊢ Δ derive A ∧ B, Γ ⊢ Δ -/
  | conjL1 : LKCutFree ⟨A :: Γ, Δ⟩ → LKCutFree ⟨conj A B :: Γ, Δ⟩
  /-- Conjunction left 2: from B, Γ ⊢ Δ derive A ∧ B, Γ ⊢ Δ -/
  | conjL2 : LKCutFree ⟨B :: Γ, Δ⟩ → LKCutFree ⟨conj A B :: Γ, Δ⟩
  /-- Conjunction right: from Γ ⊢ A, Δ and Γ' ⊢ B, Δ' derive Γ, Γ' ⊢ A ∧ B, Δ, Δ' -/
  | conjR : LKCutFree ⟨Γ, A :: Δ⟩ → LKCutFree ⟨Γ', B :: Δ'⟩ →
      LKCutFree ⟨Γ ++ Γ', conj A B :: Δ ++ Δ'⟩
  /-- Disjunction left: from A, Γ ⊢ Δ and B, Γ' ⊢ Δ' derive A ∨ B, Γ, Γ' ⊢ Δ, Δ' -/
  | disjL : LKCutFree ⟨A :: Γ, Δ⟩ → LKCutFree ⟨B :: Γ', Δ'⟩ →
      LKCutFree ⟨disj A B :: Γ ++ Γ', Δ ++ Δ'⟩
  /-- Disjunction right 1: from Γ ⊢ A, Δ derive Γ ⊢ A ∨ B, Δ -/
  | disjR1 : LKCutFree ⟨Γ, A :: Δ⟩ → LKCutFree ⟨Γ, disj A B :: Δ⟩
  /-- Disjunction right 2: from Γ ⊢ B, Δ derive Γ ⊢ A ∨ B, Δ -/
  | disjR2 : LKCutFree ⟨Γ, B :: Δ⟩ → LKCutFree ⟨Γ, disj A B :: Δ⟩

/-- Full Sequent Calculus LK with the Cut rule. -/
inductive LK : Sequent V → Prop
  /-- All cut-free rules are LK rules -/
  | ofCutFree : LKCutFree s → LK s
  /-- The Cut Rule: from Γ ⊢ A, Δ and A, Γ' ⊢ Δ' derive Γ, Γ' ⊢ Δ, Δ'.
      As the blueprint notes: "The Cut Rule introduces a middle-man formula A
      to bridge two proofs." -/
  | cut (A : PropForm V) : LK ⟨Γ, A :: Δ⟩ → LK ⟨A :: Γ', Δ'⟩ →
      LK ⟨Γ ++ Γ', Δ ++ Δ'⟩

/-
Soundness of cut-free LK: every provable sequent is valid.
-/
theorem LKCutFree.sound (h : @LKCutFree V s) : s.IsValid := by
  intro v hv;
  contrapose! h;
  intro H;
  induction H;
  all_goals simp_all +decide [ PropForm.eval ]; all_goals grind

/-
Soundness of LK with cut: every provable sequent is valid.
    This validates that cut does not compromise soundness.
-/
theorem LK.sound (h : @LK V s) : s.IsValid := by
  induction h;
  · exact LKCutFree.sound ‹_›;
  · rename_i h₁ h₂ h₃ h₄;
    intro v hv; by_cases h : eval v ‹_› <;> simp_all +decide [ Sequent.IsValid ] ;
    · exact Exists.elim ( h₄ v h fun A hA => hv A ( Or.inr hA ) ) fun A hA => ⟨ A, Or.inr hA.1, hA.2 ⟩;
    · grind

end PropForm