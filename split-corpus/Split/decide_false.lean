import Mathlib

-- spec: theorem decide_false : forall (h : Decidable False), Eq.{1} Bool (Decidable.decide False h) Bool.false
theorem decide_false : forall (h : Decidable False), Eq.{1} Bool (Decidable.decide False h) Bool.false :=
  fun (h : Decidable False) => _private.Init.Core.0.decide_false.match_1_1 (fun (h._@.Init.Core.3201123268._hygCtx._hyg.18 : Decidable False) => Eq.{1} Bool (Decidable.decide False h._@.Init.Core.3201123268._hygCtx._hyg.18) Bool.false) h (fun (h._@.Init.Core.3201123268._hygCtx._hyg.25 : Not False) => rfl.{1} Bool (Decidable.decide False (Decidable.isFalse False h._@.Init.Core.3201123268._hygCtx._hyg.25))) (fun (h : False) => False.elim.{0} (Eq.{1} Bool (Decidable.decide False (Decidable.isTrue False h)) Bool.false) h)
