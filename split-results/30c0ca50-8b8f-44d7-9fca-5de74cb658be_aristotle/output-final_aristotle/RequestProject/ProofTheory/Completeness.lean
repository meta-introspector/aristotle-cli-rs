import RequestProject.ProofTheory.CutElimination

/-!
# Completeness Infrastructure for Cut-Free Sequent Calculus

This file provides:
1. Helper lemmas for LKCutFree (membership-based provability)
2. The semantic cut lemma (validity is closed under cut)
3. A G3-style sequent calculus definition for future completeness work

## Semantic Cut

The semantic cut lemma shows that if both premises of a cut are semantically
valid, then the conclusion is also valid. Combined with soundness, this gives:

  LKCutFree ⟨Γ, A :: Δ⟩ → valid ⟨Γ, A :: Δ⟩
  LKCutFree ⟨A :: Γ', Δ'⟩ → valid ⟨A :: Γ', Δ'⟩
  → valid ⟨Γ ++ Γ', Δ ++ Δ'⟩

This reduces cut admissibility to completeness of the cut-free system.
-/

set_option maxHeartbeats 1600000

namespace PropForm

/-! ## Helper lemmas for LKCutFree -/

/-- Weakening: from identity axiom to arbitrary contexts. -/
theorem LKCutFree.ax_weaken
    {A : PropForm V} {Γ Δ : List (PropForm V)} :
    @LKCutFree V ⟨A :: Γ, A :: Δ⟩ := by
  induction Γ with
  | nil =>
    induction Δ with
    | nil => exact ax A
    | cons B Δ' ih =>
      have h1 : LKCutFree ⟨[A], B :: A :: Δ'⟩ := weakR B ih
      exact exchR (Δ := []) B A h1
  | cons B Γ' ih =>
    have h1 : LKCutFree ⟨B :: A :: Γ', A :: Δ⟩ := weakL B ih
    exact exchL (Γ := []) B A h1

/-
If A ∈ Γ and A ∈ Δ, then ⟨Γ, Δ⟩ is cut-free provable.
-/
theorem LKCutFree.of_mem_both [DecidableEq V]
    {Γ Δ : List (PropForm V)} {A : PropForm V}
    (hΓ : A ∈ Γ) (hΔ : A ∈ Δ) :
    @LKCutFree V ⟨Γ, Δ⟩ := by
      induction' Γ with B Γ' ih generalizing Δ;
      · contradiction;
      · induction' Δ with C Δ' ih' generalizing Γ';
        · contradiction;
        · cases hΓ <;> cases hΔ <;> simp_all +decide;
          · exact ax_weaken;
          · exact LKCutFree.weakR _ ( ih' _ ( fun { Δ } h₁ h₂ => ih h₁ h₂ ) ‹_› );
          · exact LKCutFree.weakL B ( ih ‹_› ( by tauto ) );
          · exact LKCutFree.weakL _ ( LKCutFree.weakR _ ( ih ‹_› ‹_› ) )

/-- If falsum ∈ Γ, then ⟨Γ, Δ⟩ is cut-free provable. -/
theorem LKCutFree.of_falsum_mem
    {Γ Δ : List (PropForm V)}
    (h : PropForm.falsum ∈ Γ) :
    @LKCutFree V ⟨Γ, Δ⟩ := by
  induction Γ with
  | nil => simp at h
  | cons A Γ ih =>
    cases h with
    | head => exact falsumL _ _
    | tail _ h => exact weakL _ (ih h)

/-! ## Semantic Cut Lemma -/

/-
**Semantic Cut**: validity is preserved under the cut rule.
    This is the semantic analogue of cut admissibility.
-/
theorem semantic_cut (A : PropForm V)
    (h1 : Sequent.IsValid ⟨Γ, A :: Δ⟩)
    (h2 : Sequent.IsValid ⟨A :: Γ', Δ'⟩) :
    Sequent.IsValid ⟨Γ ++ Γ', Δ ++ Δ'⟩ := by
      intro v hv;
      by_cases hA : eval v A = true;
      · specialize h2 v ; aesop;
      · specialize h1 v ; aesop

/-! ## G3-style Sequent Calculus (for future completeness work)

G3cp uses membership-based axioms and multiplicative rules for ∧L and ∨R.
This makes all rules invertible, which is the key to a direct completeness proof.
Completeness of G3cp + soundness of LKCutFree gives cut admissibility. -/

/-- G3-style cut-free propositional sequent calculus. -/
inductive LKG3 : Sequent V → Prop
  /-- Membership-based axiom: if A ∈ Γ and A ∈ Δ, then Γ ⊢ Δ -/
  | ax (A : PropForm V) (hΓ : A ∈ Γ) (hΔ : A ∈ Δ) : LKG3 ⟨Γ, Δ⟩
  /-- Falsum left: if ⊥ ∈ Γ, then Γ ⊢ Δ -/
  | falsumL (h : PropForm.falsum ∈ Γ) : LKG3 ⟨Γ, Δ⟩
  /-- Implication right -/
  | impR : LKG3 ⟨A :: Γ, B :: Δ⟩ → LKG3 ⟨Γ, imp A B :: Δ⟩
  /-- Implication left (context-sharing) -/
  | impL : LKG3 ⟨Γ, A :: Δ⟩ → LKG3 ⟨B :: Γ, Δ⟩ → LKG3 ⟨imp A B :: Γ, Δ⟩
  /-- Conjunction right (context-sharing) -/
  | conjR : LKG3 ⟨Γ, A :: Δ⟩ → LKG3 ⟨Γ, B :: Δ⟩ → LKG3 ⟨Γ, conj A B :: Δ⟩
  /-- Conjunction left (multiplicative) -/
  | conjL : LKG3 ⟨A :: B :: Γ, Δ⟩ → LKG3 ⟨conj A B :: Γ, Δ⟩
  /-- Disjunction left (context-sharing) -/
  | disjL : LKG3 ⟨A :: Γ, Δ⟩ → LKG3 ⟨B :: Γ, Δ⟩ → LKG3 ⟨disj A B :: Γ, Δ⟩
  /-- Disjunction right (multiplicative) -/
  | disjR : LKG3 ⟨Γ, A :: B :: Δ⟩ → LKG3 ⟨Γ, disj A B :: Δ⟩

/-
Soundness of G3.
-/
theorem LKG3.sound (h : @LKG3 V s) : s.IsValid := by
  induction h;
  case ax => intro v hv; exact ⟨ _, by assumption, hv _ ‹_› ⟩;
  exact fun v hv => by have := hv _ ‹_›; simp_all +decide [ PropForm.eval ] ;
  rename_i A Γ B Δ h₁ h₂;
  intro v hv; specialize h₂ v; simp_all +decide [ PropForm.eval ] ;
  grind;
  · rename_i A Γ B Δ h₁ h₂ ih₁ ih₂;
    intro v hv; specialize ih₁ v; specialize ih₂ v; simp_all +decide [ PropForm.eval ] ;
    grind +extAll;
  · rename_i Γ A Δ B h₁ h₂ ih₁ ih₂;
    intro v hv; specialize ih₁ v hv; specialize ih₂ v hv; simp_all +decide [ PropForm.eval ] ;
    grind;
  · rename_i A B Γ Δ h₁ h₂;
    intro v hv; specialize h₂ v; simp_all +decide [ PropForm.eval ] ;
  · rename_i A Γ B h₁ h₂ ih₁ ih₂;
    intro v hv; specialize ih₁ v; specialize ih₂ v; simp_all +decide [ PropForm.eval ] ;
    grind;
  · rename_i Γ A B Δ h₁ h₂;
    intro v hv; specialize h₂ v; simp_all +decide [ PropForm.eval ] ;
    tauto

end PropForm