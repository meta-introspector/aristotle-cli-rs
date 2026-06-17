import Mathlib

-- spec: theorem imp.swap : forall {a : Prop} {b : Prop} {c : Prop}, Iff (a -> b -> c) (b -> a -> c)
theorem imp.swap : forall {a : Prop} {b : Prop} {c : Prop}, Iff (a -> b -> c) (b -> a -> c) :=
  fun {a : Prop} {b : Prop} {c : Prop} => Iff.intro (a -> b -> c) (b -> a -> c) (flip.{0, 0, 0} a b c) (flip.{0, 0, 0} b a c)
