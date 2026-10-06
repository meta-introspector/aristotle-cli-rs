import Mathlib

-- spec: theorem iff_self : forall (p : Prop), Eq.{1} Prop (Iff p p) True
theorem iff_self : forall (p : Prop), Eq.{1} Prop (Iff p p) True :=
  fun (p : Prop) => eq_true (Iff p p) (Iff.rfl p)
