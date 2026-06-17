import Mathlib

-- spec: theorem iff_def : forall {a : Prop} {b : Prop}, Iff (Iff a b) (And (a -> b) (b -> a))
theorem iff_def : forall {a : Prop} {b : Prop}, Iff (Iff a b) (And (a -> b) (b -> a)) :=
  fun {a : Prop} {b : Prop} => iff_iff_implies_and_implies a b
