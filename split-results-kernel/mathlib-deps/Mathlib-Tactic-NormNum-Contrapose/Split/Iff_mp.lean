import Mathlib

-- spec: theorem Iff.mp : forall {a : Prop} {b : Prop}, (Iff a b) -> a -> b
theorem Iff.mp : forall {a : Prop} {b : Prop}, (Iff a b) -> a -> b :=
  fun (a : Prop) (b : Prop) (self : Iff a b) => self.1
