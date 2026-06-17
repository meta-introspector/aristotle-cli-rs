import Mathlib

-- spec: theorem iff_def' : forall {a : Prop} {b : Prop}, Iff (Iff a b) (And (b -> a) (a -> b))
theorem iff_def' : forall {a : Prop} {b : Prop}, Iff (Iff a b) (And (b -> a) (a -> b)) :=
  fun {a : Prop} {b : Prop} => Iff.trans (Iff a b) (And (a -> b) (b -> a)) (And (b -> a) (a -> b)) (iff_def a b) (And.comm (a -> b) (b -> a))
