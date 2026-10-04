import Mathlib

-- spec: theorem or_self : forall (p : Prop), Eq.{1} Prop (Or p p) p
theorem or_self : forall (p : Prop), Eq.{1} Prop (Or p p) p :=
  fun (p : Prop) => propext (Or p p) p (Iff.intro (Or p p) p (fun (x._@.Init.SimpLemmas.4029276303._hygCtx._hyg.16 : Or p p) => _private.Init.SimpLemmas.0.or_self.match_1_1 p (fun (x._@.Init.SimpLemmas.4029276303._hygCtx.16.Init.SimpLemmas.4029276303._hygCtx._hyg.26 : Or p p) => p) x._@.Init.SimpLemmas.4029276303._hygCtx._hyg.16 (fun (h : p) => h) (fun (h : p) => h)) (Or.inl p p))
