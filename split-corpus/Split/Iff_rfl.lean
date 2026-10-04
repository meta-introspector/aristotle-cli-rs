import Mathlib

-- spec: theorem Iff.rfl : forall {a : Prop}, Iff a a
theorem Iff.rfl : forall {a : Prop}, Iff a a :=
  fun {a : Prop} => Iff.refl a
