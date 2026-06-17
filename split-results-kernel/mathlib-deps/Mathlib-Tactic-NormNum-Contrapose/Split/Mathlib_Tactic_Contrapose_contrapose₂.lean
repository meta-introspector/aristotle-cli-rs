import Mathlib

-- spec: theorem Mathlib.Tactic.Contrapose.contrapose₂ : forall {p : Prop} {q : Prop}, ((Not q) -> p) -> (Not p) -> q
theorem Mathlib.Tactic.Contrapose.contrapose₂ : forall {p : Prop} {q : Prop}, ((Not q) -> p) -> (Not p) -> q :=
  fun {p : Prop} {q : Prop} (h : (Not q) -> p) (hp : Not p) => by_contra q (fun (h' : Not q) => hp (h h'))
