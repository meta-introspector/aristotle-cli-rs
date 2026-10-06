import Mathlib

-- spec: theorem false_iff : forall (p : Prop), Eq.{1} Prop (Iff False p) (Not p)
theorem false_iff : forall (p : Prop), Eq.{1} Prop (Iff False p) (Not p) :=
  fun (p : Prop) => propext (Iff False p) (Not p) (Iff.intro (Iff False p) (Not p) (fun (x._@.Init.SimpLemmas.1431426457._hygCtx._hyg.18 : Iff False p) => Iff.mpr False p x._@.Init.SimpLemmas.1431426457._hygCtx._hyg.18) (fun (x._@.Init.SimpLemmas.1431426457._hygCtx._hyg.25 : Not p) => Iff.intro False p (False.elim.{0} p) x._@.Init.SimpLemmas.1431426457._hygCtx._hyg.25))
