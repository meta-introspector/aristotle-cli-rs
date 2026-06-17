import Mathlib

-- spec: theorem by_contra : forall {p : Prop}, ((Not p) -> False) -> p
theorem by_contra : forall {p : Prop}, ((Not p) -> False) -> p :=
  by_contradiction
