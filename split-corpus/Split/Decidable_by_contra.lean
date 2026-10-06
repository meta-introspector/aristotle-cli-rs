import Mathlib

-- spec: theorem Decidable.by_contra : forall {p : Prop} [inst._@.Init.PropLemmas.1589131282._hygCtx._hyg.5 : Decidable p], ((Not p) -> False) -> p
theorem Decidable.by_contra : forall {p : Prop} [inst._@.Init.PropLemmas.1589131282._hygCtx._hyg.5 : Decidable p], ((Not p) -> False) -> p :=
  fun {p : Prop} [inst._@.Init.PropLemmas.1589131282._hygCtx._hyg.5 : Decidable p] => Decidable.of_not_not p inst._@.Init.PropLemmas.1589131282._hygCtx._hyg.5
