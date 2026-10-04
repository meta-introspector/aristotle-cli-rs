import Mathlib

-- spec: theorem Decidable.or_iff_not_imp_left : forall {a : Prop} {b : Prop} [inst._@.Init.PropLemmas.481756726._hygCtx._hyg.16 : Decidable a], Iff (Or a b) ((Not a) -> b)
theorem Decidable.or_iff_not_imp_left : forall {a : Prop} {b : Prop} [inst._@.Init.PropLemmas.481756726._hygCtx._hyg.16 : Decidable a], Iff (Or a b) ((Not a) -> b) :=
  fun {a : Prop} {b : Prop} [inst._@.Init.PropLemmas.481756726._hygCtx._hyg.16 : Decidable a] => Iff.intro (Or a b) ((Not a) -> b) (Or.resolve_left a b) (fun (h : (Not a) -> b) => dite.{0} (Or a b) a inst._@.Init.PropLemmas.481756726._hygCtx._hyg.16 (Or.inl a b) (Function.comp.{0, 0, 0} (Not a) b (Or a b) (Or.inr a b) h))
