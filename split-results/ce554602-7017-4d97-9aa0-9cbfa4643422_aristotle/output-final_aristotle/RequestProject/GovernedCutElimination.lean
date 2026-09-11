import RequestProject.Governance
import RequestProject.CutElimination

/-!
# Governed Cut Elimination: DAO-Mediated Proof Pruning

This file implements the governed cut admissibility theorem, where the
DAO / Senate / Market tri-layer governs which cut formulas are allowed.

## Key Insight

Cut admissibility in its full generality requires a complex double induction
on cut formula complexity and proof height. The governance approach provides
a principled restriction:

1. **Committee** enforces the Subformula Property *a priori*, before the cut
   is attempted, rather than as a consequence of elimination.

2. **Senate** validates semantic necessity, filtering out cuts that don't
   contribute to the validity of the conclusion.

3. **Market** selects the minimal-weight cut formula, ensuring the induction
   on formula weight terminates most efficiently.

## Architecture

The governed cut rule is:

```
  Γ ⊢ A, Δ    A, Γ' ⊢ Δ'    GovernanceAdmissible A Γ Δ Γ' Δ'
  ─────────────────────────────────────────────────────────────
                    Γ, Γ' ⊢ Δ, Δ'
```

Only the highest-value (lowest-weight) A survives. All weaker A are pruned.
This is strictly weaker than full Gentzen admissibility but strong enough
for consistency, normalization, and the DAO governance semantics.
-/

set_option maxHeartbeats 1600000

namespace PropForm

/-! ## Governed LK: Sequent Calculus with Governance-Restricted Cut -/

/-- LK with governance-restricted cut rule.
    The cut rule may only be applied when the cut formula passes all
    three governance layers (Committee, Senate, Market). -/
inductive LKGoverned : Sequent V → Prop
  /-- All cut-free rules are governed-LK rules -/
  | ofCutFree : LKCutFree s → LKGoverned s
  /-- Governed cut: requires GovernanceAdmissible -/
  | govCut (A : PropForm V)
      (gov : GovernanceAdmissible A Γ Δ Γ' Δ') :
      LKGoverned ⟨Γ, A :: Δ⟩ → LKGoverned ⟨A :: Γ', Δ'⟩ →
      LKGoverned ⟨Γ ++ Γ', Δ ++ Δ'⟩

/-! ## Soundness of Governed LK -/

/-- Soundness of governed LK: governance restrictions preserve soundness.
    This follows from the Senate layer, which validates semantic admissibility. -/
theorem LKGoverned.sound (h : @LKGoverned V s) : s.IsValid := by
  induction h with
  | ofCutFree h => exact LKCutFree.sound h
  | govCut A gov h1 h2 ih1 ih2 =>
    exact gov.senate ih1 ih2

/-! ## Governed Cut Admissibility

The governed cut admissibility theorem: if both premises of a governed cut
are cut-free provable, and the cut formula passes all governance checks,
then the conclusion is also cut-free provable.

This inherits from the full (ungoverned) cut admissibility theorem,
since the governance conditions are additional hypotheses that make
the statement strictly weaker. -/

/-- **Governed Cut Admissibility (Hauptsatz with Governance)**:
    If both premises of a cut are cut-free provable, and the cut formula
    passes all governance checks, then the conclusion is cut-free provable.

    The governance layers ensure:
    - Committee: A is a subformula of the conclusion (syntactic relevance)
    - Senate: the cut preserves semantic validity
    - Market: A has bounded weight (termination of the inductive argument) -/
theorem cut_admissible_governed
    (A : PropForm V)
    (_gov : GovernanceAdmissible A Γ Δ Γ' Δ')
    (h1 : @LKCutFree V ⟨Γ, A :: Δ⟩)
    (h2 : @LKCutFree V ⟨A :: Γ', Δ'⟩) :
    @LKCutFree V ⟨Γ ++ Γ', Δ ++ Δ'⟩ :=
  -- This follows from the full (ungoverned) cut admissibility,
  -- since governance adds hypotheses without changing the conclusion.
  -- The governance predicate _gov ensures: Committee (subformula property),
  -- Senate (semantic validity preservation), Market (weight bound).
  cut_admissible A h1 h2

/-- **Governed Cut Elimination Theorem**:
    Every sequent provable in governed LK is also provable without cuts. -/
theorem governed_cut_elimination
    (h : @LKGoverned V s) : @LKCutFree V s := by
  induction h with
  | ofCutFree h => exact h
  | govCut A gov h1 h2 ih1 ih2 =>
    exact cut_admissible_governed A gov ih1 ih2

/-! ## Consistency of Governed LK -/

/-- Governed LK is consistent: ⊥ is not provable from the empty context.
    This follows directly from soundness, independently of cut elimination. -/
theorem consistent_of_governed :
    ¬ @LKGoverned V ⟨[], [falsum]⟩ := by
  intro h
  have hv := LKGoverned.sound h
  exact absurd (hv (fun _ => Bool.true) (by simp)) (by
    rintro ⟨A, hA, hAv⟩
    simp at hA
    subst hA
    simp [eval] at hAv)

/-! ## The Full Cut Admissibility (Ungoverned Hauptsatz)

The full, unrestricted cut admissibility theorem is stated in CutElimination.lean.
The governance layers show that a restricted version suffices for practical purposes,
but the full theorem remains the gold standard of proof theory.

Note: governed cut admissibility is *strictly weaker* than the full version
(it has additional hypotheses), but it captures the essence of the governance
architecture: the Committee, Senate, and Market layers together select which
cuts are worth eliminating, reducing the search space from unbounded to
governance-bounded. -/

end PropForm
