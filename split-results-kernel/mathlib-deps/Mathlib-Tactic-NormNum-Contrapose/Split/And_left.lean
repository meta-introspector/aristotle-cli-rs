import Mathlib

-- spec: theorem And.left : forall {a : Prop} {b : Prop}, (And a b) -> a
theorem And.left : forall {a : Prop} {b : Prop}, (And a b) -> a :=
  fun (a : Prop) (b : Prop) (self : And a b) => self.1
