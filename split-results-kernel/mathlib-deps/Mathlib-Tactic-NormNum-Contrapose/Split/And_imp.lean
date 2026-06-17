import Mathlib

-- spec: theorem And.imp : forall {a : Prop} {c : Prop} {b : Prop} {d : Prop}, (a -> c) -> (b -> d) -> (And a b) -> (And c d)
theorem And.imp : forall {a : Prop} {c : Prop} {b : Prop} {d : Prop}, (a -> c) -> (b -> d) -> (And a b) -> (And c d) :=
  fun {a : Prop} {c : Prop} {b : Prop} {d : Prop} (f : a -> c) (g : b -> d) (h : And a b) => And.intro c d (f (And.left a b h)) (g (And.right a b h))
