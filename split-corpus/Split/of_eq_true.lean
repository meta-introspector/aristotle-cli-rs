import Mathlib

-- spec: theorem of_eq_true : forall {p : Prop}, (Eq.{1} Prop p True) -> p
theorem of_eq_true : forall {p : Prop}, (Eq.{1} Prop p True) -> p :=
  fun {p : Prop} (h : Eq.{1} Prop p True) => Eq.rec.{0, 1} Prop True (fun (x._@.Init.SimpLemmas.3252497304._hygCtx._hyg.15 : Prop) (h._@.Init.SimpLemmas.3252497304._hygCtx._hyg.16 : Eq.{1} Prop True x._@.Init.SimpLemmas.3252497304._hygCtx._hyg.15) => x._@.Init.SimpLemmas.3252497304._hygCtx._hyg.15) trivial p (Eq.symm.{1} Prop p True h)
