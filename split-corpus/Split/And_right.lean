import Mathlib

-- spec: theorem And.right : forall {a : Prop} {b : Prop}, (And a b) -> b
theorem And.right : forall {a : Prop} {b : Prop}, (And a b) -> b :=
  fun (a : Prop) (b : Prop) (self : And a b) => self.2
