import Mathlib

-- spec: theorem And.comm : forall {a : Prop} {b : Prop}, Iff (And a b) (And b a)
theorem And.comm : forall {a : Prop} {b : Prop}, Iff (And a b) (And b a) :=
  fun {a : Prop} {b : Prop} => Iff.intro (And a b) (And b a) (And.symm a b) (And.symm b a)
