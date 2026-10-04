import Mathlib

set_option pp.all true
-- spec: decidable_of_decidable_of_iff : forall {p : Prop} {q : Prop} [inst._@.Init.Core.2558160640._hygCtx._hyg.8 : Decidable p], (Iff p q) -> (Decidable q)
def decidable_of_decidable_of_iff : forall {p : Prop} {q : Prop} [inst._@.Init.Core.2558160640._hygCtx._hyg.8 : Decidable p], (Iff p q) -> (Decidable q) :=
  fun {p : Prop} {q : Prop} [inst._@.Init.Core.2558160640._hygCtx._hyg.8 : Decidable p] (h : Iff p q) => dite.{1} (Decidable q) p inst._@.Init.Core.2558160640._hygCtx._hyg.8 (fun (hp : p) => Decidable.isTrue q (Iff.mp p q h hp)) (fun (hp : Not p) => Decidable.isFalse q (decidable_of_decidable_of_iff._proof_1 p q h hp))
