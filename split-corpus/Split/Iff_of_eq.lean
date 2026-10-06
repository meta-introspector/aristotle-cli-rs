import Mathlib

-- spec: theorem Iff.of_eq : forall {a : Prop} {b : Prop}, (Eq.{1} Prop a b) -> (Iff a b)
theorem Iff.of_eq : forall {a : Prop} {b : Prop}, (Eq.{1} Prop a b) -> (Iff a b) :=
  fun {a : Prop} {b : Prop} (h : Eq.{1} Prop a b) => Eq.rec.{0, 1} Prop a (fun (x._@.Init.Core.1351008658._hygCtx._hyg.19 : Prop) (h._@.Init.Core.1351008658._hygCtx._hyg.20 : Eq.{1} Prop a x._@.Init.Core.1351008658._hygCtx._hyg.19) => Iff a x._@.Init.Core.1351008658._hygCtx._hyg.19) (Iff.rfl a) b h
