import Mathlib

-- spec: theorem Iff.mpr : forall {a : Prop} {b : Prop}, (Iff a b) -> b -> a
theorem Iff.mpr : forall {a : Prop} {b : Prop}, (Iff a b) -> b -> a :=
  fun (a : Prop) (b : Prop) (self : Iff a b) => self.2
