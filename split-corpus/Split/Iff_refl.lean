import Mathlib

-- spec: theorem Iff.refl : forall (a : Prop), Iff a a
theorem Iff.refl : forall (a : Prop), Iff a a :=
  fun (a : Prop) => Iff.intro a a (fun (h : a) => h) (fun (h : a) => h)
