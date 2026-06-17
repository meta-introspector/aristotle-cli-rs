import Mathlib

-- spec: theorem Mathlib.Tactic.Contrapose.contrapose₃ : forall {p : Prop} {q : Prop}, (q -> (Not p)) -> p -> (Not q)
theorem Mathlib.Tactic.Contrapose.contrapose₃ : forall {p : Prop} {q : Prop}, (q -> (Not p)) -> p -> (Not q) :=
  fun {p : Prop} {q : Prop} => Iff.mp (q -> p -> False) (p -> q -> False) (Imp.swap.{0, 0} q p False)
