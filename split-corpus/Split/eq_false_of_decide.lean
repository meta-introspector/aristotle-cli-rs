import Mathlib

-- spec: theorem eq_false_of_decide : forall {p : Prop} {x._@.Init.SimpLemmas.667761679._hygCtx._hyg.3 : Decidable p}, (Eq.{1} Bool (Decidable.decide p x._@.Init.SimpLemmas.667761679._hygCtx._hyg.3) Bool.false) -> (Eq.{1} Prop p False)
theorem eq_false_of_decide : forall {p : Prop} {x._@.Init.SimpLemmas.667761679._hygCtx._hyg.3 : Decidable p}, (Eq.{1} Bool (Decidable.decide p x._@.Init.SimpLemmas.667761679._hygCtx._hyg.3) Bool.false) -> (Eq.{1} Prop p False) :=
  fun {p : Prop} {x._@.Init.SimpLemmas.667761679._hygCtx._hyg.3 : Decidable p} (h : Eq.{1} Bool (Decidable.decide p x._@.Init.SimpLemmas.667761679._hygCtx._hyg.3) Bool.false) => eq_false p (of_decide_eq_false p x._@.Init.SimpLemmas.667761679._hygCtx._hyg.3 h)
