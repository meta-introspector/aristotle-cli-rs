import Mathlib

-- spec: theorem and_true : forall (p : Prop), Eq.{1} Prop (And p True) p
theorem and_true : forall (p : Prop), Eq.{1} Prop (And p True) p :=
  fun (p : Prop) => propext (And p True) p (Iff.intro (And p True) p (fun (x._@.Init.SimpLemmas.2305555229._hygCtx._hyg.16 : And p True) => And.left p True x._@.Init.SimpLemmas.2305555229._hygCtx._hyg.16) (fun (x._@.Init.SimpLemmas.2305555229._hygCtx._hyg.23 : p) => And.intro p True x._@.Init.SimpLemmas.2305555229._hygCtx._hyg.23 trivial))
