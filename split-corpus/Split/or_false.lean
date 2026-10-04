import Mathlib

-- spec: theorem or_false : forall (p : Prop), Eq.{1} Prop (Or p False) p
theorem or_false : forall (p : Prop), Eq.{1} Prop (Or p False) p :=
  fun (p : Prop) => propext (Or p False) p (Iff.intro (Or p False) p (fun (x._@.Init.SimpLemmas.578929214._hygCtx._hyg.16 : Or p False) => _private.Init.SimpLemmas.0.or_false.match_1_1 p (fun (x._@.Init.SimpLemmas.578929214._hygCtx.16.Init.SimpLemmas.578929214._hygCtx._hyg.23 : Or p False) => p) x._@.Init.SimpLemmas.578929214._hygCtx._hyg.16 (fun (h : p) => h)) (Or.inl p False))
