import Mathlib

-- spec: theorem Decidable.not_imp_symm : forall {a : Prop} {b : Prop} [inst._@.Init.PropLemmas.239368611._hygCtx._hyg.14 : Decidable a], ((Not a) -> b) -> (Not b) -> a
theorem Decidable.not_imp_symm : forall {a : Prop} {b : Prop} [inst._@.Init.PropLemmas.239368611._hygCtx._hyg.14 : Decidable a], ((Not a) -> b) -> (Not b) -> a :=
  fun {a : Prop} {b : Prop} [inst._@.Init.PropLemmas.239368611._hygCtx._hyg.14 : Decidable a] (h : (Not a) -> b) (hb : Not b) => Decidable.byContradiction a inst._@.Init.PropLemmas.239368611._hygCtx._hyg.14 (Function.comp.{0, 0, 0} (Not a) b False hb h)
