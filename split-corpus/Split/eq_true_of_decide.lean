import Mathlib

-- spec: theorem eq_true_of_decide : forall {p : Prop} [inst._@.Init.SimpLemmas.2777543737._hygCtx._hyg.3 : Decidable p], (Eq.{1} Bool (Decidable.decide p inst._@.Init.SimpLemmas.2777543737._hygCtx._hyg.3) Bool.true) -> (Eq.{1} Prop p True)
theorem eq_true_of_decide : forall {p : Prop} [inst._@.Init.SimpLemmas.2777543737._hygCtx._hyg.3 : Decidable p], (Eq.{1} Bool (Decidable.decide p inst._@.Init.SimpLemmas.2777543737._hygCtx._hyg.3) Bool.true) -> (Eq.{1} Prop p True) :=
  fun {p : Prop} [inst._@.Init.SimpLemmas.2777543737._hygCtx._hyg.3 : Decidable p] (h : Eq.{1} Bool (Decidable.decide p inst._@.Init.SimpLemmas.2777543737._hygCtx._hyg.3) Bool.true) => eq_true p (of_decide_eq_true p inst._@.Init.SimpLemmas.2777543737._hygCtx._hyg.3 h)
