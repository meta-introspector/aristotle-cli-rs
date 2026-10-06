import Mathlib

-- spec: theorem false_or : forall (p : Prop), Eq.{1} Prop (Or False p) p
theorem false_or : forall (p : Prop), Eq.{1} Prop (Or False p) p :=
  fun (p : Prop) => propext (Or False p) p (Iff.intro (Or False p) p (fun (x._@.Init.SimpLemmas.2005585775._hygCtx._hyg.16 : Or False p) => _private.Init.SimpLemmas.0.false_or.match_1_1 p (fun (x._@.Init.SimpLemmas.2005585775._hygCtx.16.Init.SimpLemmas.2005585775._hygCtx._hyg.23 : Or False p) => p) x._@.Init.SimpLemmas.2005585775._hygCtx._hyg.16 (fun (h : p) => h)) (Or.inr False p))
