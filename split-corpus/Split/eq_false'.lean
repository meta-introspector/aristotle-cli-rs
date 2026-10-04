import Mathlib

-- spec: theorem eq_false' : forall {p : Prop}, (p -> False) -> (Eq.{1} Prop p False)
theorem eq_false' : forall {p : Prop}, (p -> False) -> (Eq.{1} Prop p False) :=
  fun {p : Prop} (h : p -> False) => eq_false p h
