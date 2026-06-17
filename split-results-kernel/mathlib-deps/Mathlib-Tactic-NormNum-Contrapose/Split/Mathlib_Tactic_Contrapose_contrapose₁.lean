import Mathlib

-- spec: theorem Mathlib.Tactic.Contrapose.contrapose₁ : forall {p : Prop} {q : Prop}, ((Not q) -> (Not p)) -> p -> q
theorem Mathlib.Tactic.Contrapose.contrapose₁ : forall {p : Prop} {q : Prop}, ((Not q) -> (Not p)) -> p -> q :=
  fun {p : Prop} {q : Prop} (h : (Not q) -> (Not p)) (hp : p) => by_contra q (fun (h' : Not q) => h h' hp)
