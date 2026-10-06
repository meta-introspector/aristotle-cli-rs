import Mathlib

-- spec: theorem eq_true : forall {p : Prop}, p -> (Eq.{1} Prop p True)
theorem eq_true : forall {p : Prop}, p -> (Eq.{1} Prop p True) :=
  fun {p : Prop} (h : p) => propext p True (Iff.intro p True (fun (x._@.Init.SimpLemmas.1777953994._hygCtx._hyg.14 : p) => trivial) (fun (x._@.Init.SimpLemmas.1777953994._hygCtx._hyg.19 : True) => h))
