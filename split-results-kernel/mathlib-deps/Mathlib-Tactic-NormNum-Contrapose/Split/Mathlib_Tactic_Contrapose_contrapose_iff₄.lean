import Mathlib

-- spec: theorem Mathlib.Tactic.Contrapose.contrapose_iff₄ : forall {p : Prop} {q : Prop}, (Iff p q) -> (Iff (Not p) (Not q))
theorem Mathlib.Tactic.Contrapose.contrapose_iff₄ : forall {p : Prop} {q : Prop}, (Iff p q) -> (Iff (Not p) (Not q)) :=
  fun {p : Prop} {q : Prop} (x._@.Mathlib.Tactic.Contrapose.3667320582._hygCtx._hyg.27 : Iff p q) => _private.Mathlib.Tactic.Contrapose.0.Mathlib.Tactic.Contrapose.contrapose_iff₄.match_1_1 p q (fun (x._@.Mathlib.Tactic.Contrapose.3667320582._hygCtx.27.Mathlib.Tactic.Contrapose.3667320582._hygCtx._hyg.34 : Iff p q) => Iff (Not p) (Not q)) x._@.Mathlib.Tactic.Contrapose.3667320582._hygCtx._hyg.27 (fun (h₁ : p -> q) (h₂ : q -> p) => Iff.intro (Not p) (Not q) (mt q p h₂) (mt p q h₁))
