import Mathlib

-- spec: theorem eq_false : forall {p : Prop}, (Not p) -> (Eq.{1} Prop p False)
theorem eq_false : forall {p : Prop}, (Not p) -> (Eq.{1} Prop p False) :=
  fun {p : Prop} (h : Not p) => propext p False (Iff.intro p False (fun (h' : p) => absurd.{0} p False h' h) (fun (h' : False) => False.elim.{0} p h'))
