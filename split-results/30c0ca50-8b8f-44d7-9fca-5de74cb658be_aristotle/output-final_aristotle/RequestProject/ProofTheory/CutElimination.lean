import RequestProject.ProofTheory.SequentCalculus
import RequestProject.ProofTheory.CutFreeCompleteness

/-!
# Cut Elimination and the Subformula Property

This file states Gentzen's Hauptsatz (Cut Elimination Theorem) for
propositional sequent calculus, and proves key corollaries including
consistency of propositional logic.

As the blueprint states:
"The Cut Rule introduces a middle-man formula A to bridge two proofs.
While helpful for human legibility, it creates 'detours.' Eliminating cuts
ensures the Subformula Property: every formula in the proof is a subformula
of the endsequent."

## Proof Strategy

Cut elimination can be proved via two routes:

**Syntactic route (Gentzen's original):** Prove admissibility of cut by double induction
on the complexity of the cut formula and the heights of the two premise derivations.
This requires ~500+ lines of case analysis.

**Semantic route:** Prove completeness of cut-free LK (every valid sequent is cut-free
provable), then combine with soundness of full LK:
  LK s → s.IsValid (soundness) → LKCutFree s (completeness).

Both routes are substantial formalization efforts. The consistency corollaries
below are proved directly from soundness without needing cut elimination.
-/

set_option maxHeartbeats 1600000

namespace PropForm

/-- Size of a formula (used for induction in cut elimination). -/
def size : PropForm V → ℕ
  | var _ => 1
  | falsum => 1
  | imp A B => 1 + size A + size B
  | conj A B => 1 + size A + size B
  | disj A B => 1 + size A + size B

/-- Total size of a list of formulas. -/
def totalSize : List (PropForm V) → ℕ
  | [] => 0
  | A :: rest => size A + totalSize rest

/-! ## Structural lemmas for cut-free LK -/

/-- Weakening on the left by prepending a list. -/
theorem LKCutFree.weakL_append (h : @LKCutFree V ⟨Γ, Δ⟩) (Γ' : List (PropForm V)) :
    @LKCutFree V ⟨Γ' ++ Γ, Δ⟩ := by
  induction' Γ' with A Γ'' ih
  · simpa using h
  · exact LKCutFree.weakL A ih

/-- Weakening on the right by prepending a list. -/
theorem LKCutFree.weakR_append (h : @LKCutFree V ⟨Γ, Δ⟩) (Δ' : List (PropForm V)) :
    @LKCutFree V ⟨Γ, Δ' ++ Δ⟩ := by
  induction Δ' <;> simp_all +decide [LKCutFree.weakR]

/-- Weakening on both sides by appending lists. -/
theorem LKCutFree.weak_both (h : @LKCutFree V ⟨Γ, Δ⟩) (Γ' : List (PropForm V))
    (Δ' : List (PropForm V)) :
    @LKCutFree V ⟨Γ' ++ Γ, Δ' ++ Δ⟩ :=
  (h.weakL_append Γ').weakR_append Δ'

/-! ## Cut Elimination

Gentzen's Hauptsatz: the cut rule is admissible in propositional LK.
This deep theorem requires either:
- A complex syntactic proof by double induction on cut formula size and proof height
- Or a completeness proof for cut-free LK followed by composition with soundness

We state the theorem here; a full proof would require substantial additional
infrastructure (proof heights, permutation lemmas, or a complete decision procedure).
-/

/-- **Admissibility of Cut**: if both premises of a cut are cut-free provable,
then the conclusion is also cut-free provable. This is the key lemma for
cut elimination.

Proved via the *semantic route*: by soundness both premises are valid, hence
(by the semantic cut argument) the conclusion is valid, hence — by completeness
of cut-free LK (`LKCutFree.complete`) — cut-free provable. -/
theorem cut_admissible (A : PropForm V) (h1 : @LKCutFree V ⟨Γ, A :: Δ⟩)
    (h2 : @LKCutFree V ⟨A :: Γ', Δ'⟩) :
    @LKCutFree V ⟨Γ ++ Γ', Δ ++ Δ'⟩ := by
  apply LKCutFree.complete
  intro v hv
  have v1 := LKCutFree.sound h1 v
  have v2 := LKCutFree.sound h2 v
  by_cases hA : eval v A = true
  · have hΓ' : ∀ B ∈ A :: Γ', eval v B = true := by
      intro B hB
      rcases List.mem_cons.1 hB with rfl | hB
      · exact hA
      · exact hv B (by simp [hB])
    obtain ⟨B, hBmem, hBval⟩ := v2 hΓ'
    exact ⟨B, by simp [hBmem], hBval⟩
  · have hΓ : ∀ B ∈ Γ, eval v B = true := fun B hB => hv B (by simp [hB])
    obtain ⟨B, hBmem, hBval⟩ := v1 hΓ
    rcases List.mem_cons.1 hBmem with rfl | hBmem
    · exact absurd hBval (by simp [hA])
    · exact ⟨B, by simp [hBmem], hBval⟩

/-- **Gentzen's Hauptsatz (Cut Elimination Theorem)**:
Every sequent provable in LK (with cut) is also provable in LK without cut. -/
theorem cut_elimination (h : @LK V s) : @LKCutFree V s := by
  induction h with
  | ofCutFree h => exact h
  | cut A h1 h2 ih1 ih2 => exact cut_admissible A ih1 ih2

/-! ## Consistency

These corollaries are proved directly from soundness, independently of
cut elimination. They demonstrate the key consequence mentioned in the blueprint:
the Subformula Property (from cut elimination) limits the search space,
but consistency itself follows from the semantic soundness theorem. -/

/-- The empty sequent is not provable in cut-free LK.
The empty succedent is interpreted as False (as noted in the blueprint),
so this says: nothing can be derived from no hypotheses. -/
theorem empty_sequent_not_provable : ¬ @LKCutFree V ⟨[], []⟩ := by
  intro h
  exact absurd (LKCutFree.sound h) (by simp +decide [Sequent.IsValid])

/-- Propositional logic is consistent: ⊥ is not provable from the empty context.
As the blueprint notes: "an empty antecedent is defined as True, while an
empty succedent is defined as False." -/
theorem consistent_of_cut_free : ¬ @LKCutFree V ⟨[], [falsum]⟩ := by
  intro h; have := @LKCutFree.sound
  simp_all +decide [Sequent.IsValid]
  specialize this h (fun _ => Bool.true); simp_all +decide [eval]

/-
Consistency of full LK (with cut): False is not LK-provable from empty context.
This is a direct corollary of soundness.
-/
theorem consistent_of_LK : ¬ @LK V ⟨[], [falsum]⟩ := by
  -- By definition of LK, if the sequent ⟨[], [falsum]⟩ is provable, then it must be valid.
  by_contra h_contra
  have h_valid : ∀ v : Valuation V, (∀ A ∈ [], eval v A = true) → (∃ A ∈ [falsum], eval v A = true) := by
    convert LK.sound h_contra;
  exact absurd ( h_valid ( fun _ => Bool.false ) ( by simp +decide ) ) ( by simp +decide [ PropForm.eval ] )

end PropForm