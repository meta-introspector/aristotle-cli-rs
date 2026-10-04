import Mathlib

-- spec: theorem true_and : forall (p : Prop), Eq.{1} Prop (And True p) p
theorem true_and : forall (p : Prop), Eq.{1} Prop (And True p) p :=
  fun (p : Prop) => propext (And True p) p (Iff.intro (And True p) p (fun (x._@.Init.SimpLemmas.2172530434._hygCtx._hyg.16 : And True p) => And.right True p x._@.Init.SimpLemmas.2172530434._hygCtx._hyg.16) (fun (x._@.Init.SimpLemmas.2172530434._hygCtx._hyg.23 : p) => And.intro True p trivial x._@.Init.SimpLemmas.2172530434._hygCtx._hyg.23))
