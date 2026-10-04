import Mathlib

-- spec: theorem and_false : forall (p : Prop), Eq.{1} Prop (And p False) False
theorem and_false : forall (p : Prop), Eq.{1} Prop (And p False) False :=
  fun (p : Prop) => eq_false (And p False) (fun (x._@.Init.SimpLemmas.287224376._hygCtx._hyg.14 : And p False) => And.right p False x._@.Init.SimpLemmas.287224376._hygCtx._hyg.14)
