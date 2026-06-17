import Mathlib

-- spec: theorem Iff.symm : forall {a : Prop} {b : Prop}, (Iff a b) -> (Iff b a)
theorem Iff.symm : forall {a : Prop} {b : Prop}, (Iff a b) -> (Iff b a) :=
  fun {a : Prop} {b : Prop} (h : Iff a b) => Iff.intro b a (Iff.mpr a b h) (Iff.mp a b h)
