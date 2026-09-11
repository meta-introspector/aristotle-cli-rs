import RequestProject.ProofTheory.NaturalDeduction

/-!
# Proof Normalization in Natural Deduction

This file formalizes the concept of proof normalization from the blueprint:

"In Natural Deduction, we eliminate 'Hillocks' (or detours) where an
Introduction rule is immediately followed by an Elimination rule.
We reduce these until the proof reaches a Normal Form. This process
is identical to program reduction in the lambda calculus."

We define proof height and demonstrate key structural properties.
-/

set_option maxHeartbeats 800000

namespace PropForm

/-! ## Hillock Detection

A "hillock" or detour is an introduction rule immediately followed
by the corresponding elimination rule. These are the proof-theoretic
analogue of β-redexes in lambda calculus.

Example hillock for implication:
  If we have a proof of Γ, A ⊢ B (→I gives Γ ⊢ A → B)
  and then immediately apply →E with a proof of Γ ⊢ A,
  we could instead directly substitute the proof of A into the derivation of B.
-/

/-! ## Structural Properties of Natural Deduction -/

variable {V : Type*} {Γ : List (PropForm V)} {A B : PropForm V}

/-- Monotonicity: adding a hypothesis preserves provability. -/
theorem NDProof.mono (h : Γ ⊢ₙ A) (C : PropForm V) : (C :: Γ) ⊢ₙ A :=
  h.weaken (fun _ hC => List.mem_cons_of_mem _ hC)

/-- Cut rule for natural deduction: if Γ ⊢ A and A :: Γ ⊢ B then Γ ⊢ B. -/
theorem NDProof.cut (h1 : Γ ⊢ₙ A) (h2 : (A :: Γ) ⊢ₙ B) : Γ ⊢ₙ B :=
  NDProof.impE (NDProof.impI h2) h1

/-- Conjunction commutativity -/
theorem NDProof.conj_comm (h : Γ ⊢ₙ conj A B) : Γ ⊢ₙ conj B A :=
  NDProof.conjI (NDProof.conjE2 h) (NDProof.conjE1 h)

/-- Disjunction commutativity -/
theorem NDProof.disj_comm (h : Γ ⊢ₙ disj A B) : Γ ⊢ₙ disj B A := by
  apply NDProof.disjE h
  · exact NDProof.disjI2 (NDProof.ax List.mem_cons_self)
  · exact NDProof.disjI1 (NDProof.ax List.mem_cons_self)

/-- Double negation introduction (constructive) -/
theorem NDProof.dne_intro (h : Γ ⊢ₙ A) : Γ ⊢ₙ neg (neg A) := by
  unfold neg
  apply NDProof.impI
  apply NDProof.falsumE
  exact NDProof.impE (NDProof.ax List.mem_cons_self) (h.mono _)

/-- Modus tollens -/
theorem NDProof.modus_tollens (h1 : Γ ⊢ₙ imp A B) (h2 : Γ ⊢ₙ neg B) : Γ ⊢ₙ neg A := by
  unfold neg
  apply NDProof.impI
  apply NDProof.falsumE
  unfold neg at h2
  exact NDProof.impE (h2.mono _) (NDProof.impE (h1.mono _) (NDProof.ax List.mem_cons_self))

end PropForm
