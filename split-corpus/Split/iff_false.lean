import Mathlib

-- spec: theorem iff_false : forall (p : Prop), Eq.{1} Prop (Iff p False) (Not p)
theorem iff_false : forall (p : Prop), Eq.{1} Prop (Iff p False) (Not p) :=
  fun (p : Prop) => propext (Iff p False) (Not p) (Iff.intro (Iff p False) (Not p) (fun (x._@.Init.SimpLemmas.2464954131._hygCtx._hyg.18 : Iff p False) => Iff.mp p False x._@.Init.SimpLemmas.2464954131._hygCtx._hyg.18) (fun (x._@.Init.SimpLemmas.2464954131._hygCtx._hyg.25 : Not p) => Iff.intro p False x._@.Init.SimpLemmas.2464954131._hygCtx._hyg.25 (False.elim.{0} p)))
