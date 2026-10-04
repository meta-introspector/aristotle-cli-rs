import Mathlib

-- spec: theorem decide_eq_true_eq : forall {p : Prop} [inst._@.Init.SimpLemmas.1519209950._hygCtx._hyg.5 : Decidable p], Eq.{1} Prop (Eq.{1} Bool (Decidable.decide p inst._@.Init.SimpLemmas.1519209950._hygCtx._hyg.5) Bool.true) p
theorem decide_eq_true_eq : forall {p : Prop} [inst._@.Init.SimpLemmas.1519209950._hygCtx._hyg.5 : Decidable p], Eq.{1} Prop (Eq.{1} Bool (Decidable.decide p inst._@.Init.SimpLemmas.1519209950._hygCtx._hyg.5) Bool.true) p :=
  fun {p : Prop} [inst._@.Init.SimpLemmas.1519209950._hygCtx._hyg.5 : Decidable p] => propext (Eq.{1} Bool (Decidable.decide p inst._@.Init.SimpLemmas.1519209950._hygCtx._hyg.5) Bool.true) p (Iff.intro (Eq.{1} Bool (Decidable.decide p inst._@.Init.SimpLemmas.1519209950._hygCtx._hyg.5) Bool.true) p (of_decide_eq_true p inst._@.Init.SimpLemmas.1519209950._hygCtx._hyg.5) (decide_eq_true p inst._@.Init.SimpLemmas.1519209950._hygCtx._hyg.5))
