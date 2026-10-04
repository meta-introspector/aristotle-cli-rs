import Mathlib

-- spec: theorem Decidable.of_not_not : forall {p : Prop} [inst._@.Init.Core.1372462230._hygCtx._hyg.8 : Decidable p], (Not (Not p)) -> p
theorem Decidable.of_not_not : forall {p : Prop} [inst._@.Init.Core.1372462230._hygCtx._hyg.8 : Decidable p], (Not (Not p)) -> p :=
  fun {p : Prop} [inst._@.Init.Core.1372462230._hygCtx._hyg.8 : Decidable p] (hnn : Not (Not p)) => Decidable.byContradiction p inst._@.Init.Core.1372462230._hygCtx._hyg.8 (fun (hn : Not p) => absurd.{0} (Not p) False hn hnn)
