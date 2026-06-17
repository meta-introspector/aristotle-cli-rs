import Mathlib

-- spec: theorem Mathlib.Tactic.Contrapose.contrapose_iff₁ : forall {p : Prop} {q : Prop}, (Iff (Not p) (Not q)) -> (Iff p q)
theorem Mathlib.Tactic.Contrapose.contrapose_iff₁ : forall {p : Prop} {q : Prop}, (Iff (Not p) (Not q)) -> (Iff p q) :=
  fun {p : Prop} {q : Prop} => Iff.mp (Iff (Not p) (Not q)) (Iff p q) (not_iff_not p q)
