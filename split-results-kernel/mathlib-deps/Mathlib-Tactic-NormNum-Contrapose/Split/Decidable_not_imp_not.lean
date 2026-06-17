import Mathlib

-- spec: theorem Decidable.not_imp_not : forall {a : Prop} {b : Prop} [inst._@.Init.PropLemmas.2515922114._hygCtx._hyg.22 : Decidable a], Iff ((Not a) -> (Not b)) (b -> a)
theorem Decidable.not_imp_not : forall {a : Prop} {b : Prop} [inst._@.Init.PropLemmas.2515922114._hygCtx._hyg.22 : Decidable a], Iff ((Not a) -> (Not b)) (b -> a) :=
  fun {a : Prop} {b : Prop} [inst._@.Init.PropLemmas.2515922114._hygCtx._hyg.22 : Decidable a] => Iff.intro ((Not a) -> (Not b)) (b -> a) (fun (h : (Not a) -> (Not b)) (hb : b) => Decidable.byContradiction a inst._@.Init.PropLemmas.2515922114._hygCtx._hyg.22 (fun (x._@.Init.PropLemmas.2515922114._hygCtx._hyg.53 : Not a) => h x._@.Init.PropLemmas.2515922114._hygCtx._hyg.53 hb)) (mt b a)
