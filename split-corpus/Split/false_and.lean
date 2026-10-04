import Mathlib

-- spec: theorem false_and : forall (p : Prop), Eq.{1} Prop (And False p) False
theorem false_and : forall (p : Prop), Eq.{1} Prop (And False p) False :=
  fun (p : Prop) => eq_false (And False p) (fun (x._@.Init.SimpLemmas.760575690._hygCtx._hyg.14 : And False p) => And.left False p x._@.Init.SimpLemmas.760575690._hygCtx._hyg.14)
