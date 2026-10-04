import Mathlib

-- spec: theorem forall_false : forall (p : False -> Prop), Eq.{1} Prop (forall (h : False), p h) True
theorem forall_false : forall (p : False -> Prop), Eq.{1} Prop (forall (h : False), p h) True :=
  fun (p : False -> Prop) => eq_true (forall (h : False), p h) (fun (x._@.Init.SimpLemmas.3317660362._hygCtx._hyg.19 : False) => False.elim.{0} (p x._@.Init.SimpLemmas.3317660362._hygCtx._hyg.19) x._@.Init.SimpLemmas.3317660362._hygCtx._hyg.19)
