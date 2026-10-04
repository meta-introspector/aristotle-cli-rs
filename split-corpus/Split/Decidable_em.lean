import Mathlib

-- spec: theorem Decidable.em : forall (p : Prop) [inst._@.Init.Core.2191930617._hygCtx._hyg.9 : Decidable p], Or p (Not p)
theorem Decidable.em : forall (p : Prop) [inst._@.Init.Core.2191930617._hygCtx._hyg.9 : Decidable p], Or p (Not p) :=
  fun (p : Prop) [inst._@.Init.Core.2191930617._hygCtx._hyg.9 : Decidable p] => Decidable.byCases.{0} p (Or p (Not p)) inst._@.Init.Core.2191930617._hygCtx._hyg.9 (Or.inl p (Not p)) (Or.inr p (Not p))
