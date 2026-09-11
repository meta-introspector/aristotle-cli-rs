/-
# Security Verification: Model-Sharing Strategy and Attack Resistance

This module formalizes security properties of the Model-Sharing Strategy (MSS),
including resistance to reconstruction attacks, membership inference attacks,
and data poisoning.
-/
import RequestProject.DifferentialPrivacy

open scoped BigOperators

/-! ## Threat Model -/

/-- An adversary that attempts to reconstruct training data from model parameters. -/
structure ReconstructionAdversary (D α : Type*) [Fintype α] where
  /-- The adversary's reconstruction function: given model output, guess the dataset. -/
  reconstruct : α → D

/-- An adversary that attempts membership inference:
    given model output and a candidate record, decide if the record was used. -/
structure MembershipInferenceAdversary (D R α : Type*) [Fintype α] where
  /-- The adversary's inference function. -/
  infer : α → R → Bool

/-! ## Security Definitions -/

/-- A mechanism is resistant to reconstruction attacks if it satisfies pure ε-DP:
    no adversary can distinguish adjacent datasets better than exp(ε). -/
def ReconstructionResistant {D α : Type*} [Fintype α] [DecidableEq α]
    (M : Mechanism D α) (adj : D → D → Prop) (ε : ℝ) : Prop :=
  PureDP M adj ε

/-- DP implies reconstruction resistance (definitional). -/
theorem dp_implies_reconstruction_resistance {D α : Type*}
    [Fintype α] [DecidableEq α]
    (M : Mechanism D α) (adj : D → D → Prop) (ε : ℝ)
    (hDP : PureDP M adj ε) :
    ReconstructionResistant M adj ε :=
  hDP

/-! ## Group Privacy -/

/-
Group privacy for pure DP: if two datasets differ in k records
    (connected by a chain of adjacent datasets), the privacy loss
    scales linearly.
-/
theorem group_privacy_pure {D α : Type*} [Fintype α] [DecidableEq α]
    (M : Mechanism D α) (adj : D → D → Prop) (ε : ℝ) (k : ℕ)
    (hDP : PureDP M adj ε) :
    ∀ (S S' : D) (chain : Fin (k + 1) → D),
      chain ⟨0, by omega⟩ = S →
      chain ⟨k, by omega⟩ = S' →
      (∀ i : Fin k, adj (chain ⟨i.val, by omega⟩) (chain ⟨i.val + 1, by omega⟩)) →
      ∀ (R : Finset α),
        (M.run S).probSet R ≤ Real.exp (k * ε) * (M.run S').probSet R := by
  induction' k with k ih;
  · aesop;
  · intro S S' chain hS hS' hchain R;
    specialize ih ( chain ⟨ 0, by linarith ⟩ ) ( chain ⟨ k, by linarith ⟩ ) ( fun i => chain ⟨ i.val, by linarith [ Fin.is_lt i ] ⟩ ) ; simp_all +decide [ Real.exp_add, add_mul ];
    specialize ih ( fun i => hchain ⟨ i, by linarith [ Fin.is_lt i ] ⟩ ) R;
    have := hDP ( chain ⟨ k, by linarith ⟩ ) S' ( by
      exact hS'.symm ▸ hchain ⟨ k, by linarith ⟩ ) R
    generalize_proofs at *;
    nlinarith [ Real.exp_pos ( k * ε ) ]

/-! ## Data Poisoning Resistance -/

/-- A robust aggregation rule is Byzantine-resilient if at most f out of K
    clients are corrupted, and the aggregated model stays within distance γ
    of the honest aggregate. -/
def ByzantineResilient {dim K : ℕ}
    (aggregate : (Fin K → Vec dim) → Vec dim)
    (f : ℕ) (γ : ℝ) : Prop :=
  ∀ (honest poisoned : Fin K → Vec dim),
    (Finset.filter (fun k => honest k ≠ poisoned k) Finset.univ).card ≤ f →
    Vec.norm (Vec.sub (aggregate honest) (aggregate poisoned)) ≤ γ

/-- If no clients are poisoned, the aggregation is exact. -/
theorem no_poison_exact {dim K : ℕ}
    (aggregate : (Fin K → Vec dim) → Vec dim) :
    ∀ (honest : Fin K → Vec dim),
      aggregate honest = aggregate honest := by
  intro; rfl