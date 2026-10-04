import Mathlib

-- spec: theorem decide_true : forall (h : Decidable True), Eq.{1} Bool (Decidable.decide True h) Bool.true
theorem decide_true : forall (h : Decidable True), Eq.{1} Bool (Decidable.decide True h) Bool.true :=
  fun (h : Decidable True) => _private.Init.Core.0.decide_true.match_1_1 (fun (h._@.Init.Core.964392197._hygCtx._hyg.18 : Decidable True) => Eq.{1} Bool (Decidable.decide True h._@.Init.Core.964392197._hygCtx._hyg.18) Bool.true) h (fun (h._@.Init.Core.964392197._hygCtx._hyg.25 : True) => rfl.{1} Bool (Decidable.decide True (Decidable.isTrue True h._@.Init.Core.964392197._hygCtx._hyg.25))) (fun (h : Not True) => False.elim.{0} (Eq.{1} Bool (Decidable.decide True (Decidable.isFalse True h)) Bool.true) (h True.intro))
