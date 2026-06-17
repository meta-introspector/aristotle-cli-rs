import Mathlib

-- spec: theorem And.symm : forall {a : Prop} {b : Prop}, (And a b) -> (And b a)
theorem And.symm : forall {a : Prop} {b : Prop}, (And a b) -> (And b a) :=
  fun {a : Prop} {b : Prop} (x._@.Init.Core.2345006595._hygCtx._hyg.19 : And a b) => _private.Init.Core.0.And.symm.match_1_1 a b (fun (x._@.Init.Core.2345006595._hygCtx.19.Init.Core.2345006595._hygCtx._hyg.26 : And a b) => And b a) x._@.Init.Core.2345006595._hygCtx._hyg.19 (fun (ha : a) (hb : b) => And.intro b a hb ha)
