import Mathlib

set_option pp.all true
-- spec: decidable_of_iff : forall {b : Prop} (a : Prop), (Iff a b) -> (forall [inst._@.Init.PropLemmas.3971207348._hygCtx._hyg.14 : Decidable a], Decidable b)
def decidable_of_iff : forall {b : Prop} (a : Prop), (Iff a b) -> (forall [inst._@.Init.PropLemmas.3971207348._hygCtx._hyg.14 : Decidable a], Decidable b) :=
  fun {b : Prop} (a : Prop) (h : Iff a b) [inst._@.Init.PropLemmas.3971207348._hygCtx._hyg.14 : Decidable a] => decidable_of_decidable_of_iff a b inst._@.Init.PropLemmas.3971207348._hygCtx._hyg.14 h
