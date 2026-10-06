import Mathlib

-- spec: theorem true_or : forall (p : Prop), Eq.{1} Prop (Or True p) True
theorem true_or : forall (p : Prop), Eq.{1} Prop (Or True p) True :=
  fun (p : Prop) => eq_true (Or True p) (Or.inl True p trivial)
