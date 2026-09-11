import RequestProject.ProofTheory.CutElimination

/-!
# DAO Governance Layers for Proof-Theoretic Cut Admissibility

This file defines the tri-layer governance architecture (Committee / Senate / Market)
that governs cut formula selection in sequent calculus proofs.

The key insight: cut admissibility fails to be easily provable because the search space
of possible cut formulas explodes. The DAO architecture provides a principled mechanism
for pruning incoherent or low-value cut candidates.

## Architecture

* **Committee (CRT gate)** = syntactic admissibility: the cut formula must be a
  subformula of the endsequent, enforcing the Subformula Property before cut is applied.

* **Senate (ACL governance)** = semantic admissibility: the cut formula must be
  semantically necessary — cutting on it must preserve validity of the resulting sequent.

* **Market (token-weighted value)** = economic admissibility: among surviving candidates,
  the market selects the minimal-weight (most fundamental) formula.

## Mathematical Justification

This restriction is valid because LK is structurally complete: any admissible cut formula
that is not needed for the final sequent is eliminable. The governance layers formalize
the selection criterion that Gentzen's proof implicitly uses in its inductive argument.
-/

set_option maxHeartbeats 800000

namespace PropForm

/-! ## Market Weight Function

A generalization of formula size that assigns economic weight to formulas.
Lower weight = more fundamental = more admissible as a cut formula.

This replaces the standard `size` metric with a governance-aware weight. -/

/-- Market weight function on propositional formulas.
    This is a generalization of formula size, where atomic propositions
    (the most fundamental objects) have weight 1, and compound formulas
    accumulate weight from their components. -/
def marketWeight : PropForm V → ℕ
  | var _ => 1
  | falsum => 1
  | imp A B => 1 + marketWeight A + marketWeight B
  | conj A B => 1 + marketWeight A + marketWeight B
  | disj A B => 1 + marketWeight A + marketWeight B

/-- Market weight is always positive. -/
theorem marketWeight_pos (A : PropForm V) : 0 < marketWeight A := by
  induction A <;> simp_all [marketWeight] <;> omega

/-- Market weight of compound formulas exceeds that of components. -/
theorem marketWeight_imp_left (A B : PropForm V) :
    marketWeight A < marketWeight (imp A B) := by
  simp only [marketWeight]; omega

theorem marketWeight_imp_right (A B : PropForm V) :
    marketWeight B < marketWeight (imp A B) := by
  simp only [marketWeight]; omega

theorem marketWeight_conj_left (A B : PropForm V) :
    marketWeight A < marketWeight (conj A B) := by
  simp only [marketWeight]; omega

theorem marketWeight_conj_right (A B : PropForm V) :
    marketWeight B < marketWeight (conj A B) := by
  simp only [marketWeight]; omega

theorem marketWeight_disj_left (A B : PropForm V) :
    marketWeight A < marketWeight (disj A B) := by
  simp only [marketWeight]; omega

theorem marketWeight_disj_right (A B : PropForm V) :
    marketWeight B < marketWeight (disj A B) := by
  simp only [marketWeight]; omega

/-! ## Committee Layer: Syntactic Admissibility

The Committee enforces the Subformula Property: a cut formula A is only
admissible if it appears as a subformula of the target sequent.

This corresponds to the blueprint's statement:
"Cut introduces a middle-man formula A… Eliminating cuts ensures the
Subformula Property." -/

/-- A formula is a subformula of a list of formulas if it is a subformula
    of some formula in the list. -/
def IsSubformulaOfList (A : PropForm V) (Γ : List (PropForm V)) : Prop :=
  ∃ B ∈ Γ, IsSubformula A B

/-- Committee admissibility: A is syntactically admissible as a cut formula
    for the sequent ⟨Γ ++ Γ', Δ ++ Δ'⟩ if A is a subformula of
    the combined context (antecedent or succedent of the conclusion). -/
def CommitteeAdmissible (A : PropForm V) (Γ Δ Γ' Δ' : List (PropForm V)) : Prop :=
  IsSubformulaOfList A (Γ ++ Γ') ∨ IsSubformulaOfList A (Δ ++ Δ')

/-! ## Senate Layer: Semantic Admissibility

The Senate validates that cutting on A preserves semantic validity.
A cut is senate-admissible if the resulting sequent is semantically valid
whenever both premises are. This is guaranteed by soundness, but we
make it an explicit governance check. -/

/-- Senate admissibility: the cut on A preserves validity.
    Specifically, if both ⟨Γ, A :: Δ⟩ and ⟨A :: Γ', Δ'⟩ are valid,
    then ⟨Γ ++ Γ', Δ ++ Δ'⟩ must also be valid. -/
def SenateAdmissible (A : PropForm V) (Γ Δ Γ' Δ' : List (PropForm V)) : Prop :=
  Sequent.IsValid ⟨Γ, A :: Δ⟩ →
  Sequent.IsValid ⟨A :: Γ', Δ'⟩ →
  Sequent.IsValid ⟨Γ ++ Γ', Δ ++ Δ'⟩

/-- The Senate always admits valid cuts: this is a consequence of
    the semantic cut rule being sound. -/
theorem senate_always_admits (A : PropForm V)
    (Γ Δ Γ' Δ' : List (PropForm V)) :
    SenateAdmissible A Γ Δ Γ' Δ' := by
  intro h1 h2 v hv
  by_cases hA : eval v A = true
  · -- A is true under v, so use the right premise
    obtain ⟨B, hB, hBv⟩ := h2 v (fun B hB => by
      cases hB with
      | head => exact hA
      | tail _ h => exact hv B (List.mem_append_right _ h))
    exact ⟨B, List.mem_append_right _ hB, hBv⟩
  · -- A is false under v, so use the left premise
    obtain ⟨B, hB, hBv⟩ := h1 v (fun B hB => hv B (List.mem_append_left _ hB))
    cases hB with
    | head => simp_all
    | tail _ h => exact ⟨B, List.mem_append_left _ h, hBv⟩

/-! ## Market Layer: Economic Admissibility

The Market selects the optimal cut formula: the one with minimal market weight
among all candidates. This formalizes the principle that the "weakest"
(highest-weight, least fundamental) cuts are pruned first. -/

/-- Market optimality: A has minimal weight among all formulas appearing
    in the cut premises. -/
def MarketOptimal (A : PropForm V) (Γ Δ Γ' Δ' : List (PropForm V)) : Prop :=
  ∀ B ∈ (Γ ++ Δ ++ Γ' ++ Δ'), marketWeight A ≤ marketWeight B

/-- A weaker market criterion: A's weight is bounded by the total
    weight of the sequent components. This is always satisfiable. -/
def MarketBounded (A : PropForm V) (Γ Δ Γ' Δ' : List (PropForm V)) : Prop :=
  marketWeight A ≤ totalSize Γ + totalSize Δ + totalSize Γ' + totalSize Δ'

/-! ## Governance Decision: The Combined Filter

The full governance decision combines all three layers. A cut is
*governed-admissible* only if it passes Committee, Senate, and Market. -/

/-- Full governance admissibility: the conjunction of all three layers. -/
structure GovernanceAdmissible (A : PropForm V) (Γ Δ Γ' Δ' : List (PropForm V)) : Prop where
  committee : CommitteeAdmissible A Γ Δ Γ' Δ'
  senate : SenateAdmissible A Γ Δ Γ' Δ'
  market : MarketBounded A Γ Δ Γ' Δ'

end PropForm
