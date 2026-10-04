import Mathlib

-- spec: theorem or_true : forall (p : Prop), Eq.{1} Prop (Or p True) True
theorem or_true : forall (p : Prop), Eq.{1} Prop (Or p True) True :=
  fun (p : Prop) => eq_true (Or p True) (Or.inr p True trivial)
