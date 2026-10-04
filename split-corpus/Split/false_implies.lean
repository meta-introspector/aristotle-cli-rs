import Mathlib

-- spec: theorem false_implies : forall (p : Prop), Eq.{1} Prop (False -> p) True
theorem false_implies : forall (p : Prop), Eq.{1} Prop (False -> p) True :=
  fun (p : Prop) => eq_true (False -> p) (False.elim.{0} p)
