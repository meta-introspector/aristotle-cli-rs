import Mathlib

-- spec: theorem Iff.comm : forall {a : Prop} {b : Prop}, Iff (Iff a b) (Iff b a)
theorem Iff.comm : forall {a : Prop} {b : Prop}, Iff (Iff a b) (Iff b a) :=
  fun {a : Prop} {b : Prop} => Iff.intro (Iff a b) (Iff b a) (Iff.symm a b) (Iff.symm b a)
