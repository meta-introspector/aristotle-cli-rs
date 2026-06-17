import Mathlib

-- spec: theorem Mathlib.Tactic.Contrapose.contrapose₄ : forall {p : Prop} {q : Prop}, (q -> p) -> (Not p) -> (Not q)
theorem Mathlib.Tactic.Contrapose.contrapose₄ : forall {p : Prop} {q : Prop}, (q -> p) -> (Not p) -> (Not q) :=
  fun {p : Prop} {q : Prop} => mt q p
