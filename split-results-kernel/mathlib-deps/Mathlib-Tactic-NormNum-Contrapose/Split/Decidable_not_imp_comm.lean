import Mathlib

-- spec: theorem Decidable.not_imp_comm : forall {a : Prop} {b : Prop} [inst._@.Init.PropLemmas.93467254._hygCtx._hyg.11 : Decidable a] [inst._@.Init.PropLemmas.93467254._hygCtx._hyg.14 : Decidable b], Iff ((Not a) -> b) ((Not b) -> a)
theorem Decidable.not_imp_comm : forall {a : Prop} {b : Prop} [inst._@.Init.PropLemmas.93467254._hygCtx._hyg.11 : Decidable a] [inst._@.Init.PropLemmas.93467254._hygCtx._hyg.14 : Decidable b], Iff ((Not a) -> b) ((Not b) -> a) :=
  fun {a : Prop} {b : Prop} [inst._@.Init.PropLemmas.93467254._hygCtx._hyg.11 : Decidable a] [inst._@.Init.PropLemmas.93467254._hygCtx._hyg.14 : Decidable b] => Iff.intro ((Not a) -> b) ((Not b) -> a) (Decidable.not_imp_symm a b inst._@.Init.PropLemmas.93467254._hygCtx._hyg.11) (Decidable.not_imp_symm b a inst._@.Init.PropLemmas.93467254._hygCtx._hyg.14)
