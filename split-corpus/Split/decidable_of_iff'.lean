import Mathlib

set_option pp.all true
-- spec: decidable_of_iff' : forall {a : Prop} (b : Prop), (Iff a b) -> (forall [inst._@.Init.PropLemmas.1914286829._hygCtx._hyg.13 : Decidable b], Decidable a)
def decidable_of_iff' : forall {a : Prop} (b : Prop), (Iff a b) -> (forall [inst._@.Init.PropLemmas.1914286829._hygCtx._hyg.13 : Decidable b], Decidable a) :=
  fun {a : Prop} (b : Prop) (h : Iff a b) [inst._@.Init.PropLemmas.1914286829._hygCtx._hyg.13 : Decidable b] => decidable_of_decidable_of_iff b a inst._@.Init.PropLemmas.1914286829._hygCtx._hyg.13 (Iff.symm a b h)
