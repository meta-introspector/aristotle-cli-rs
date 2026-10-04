import Mathlib

set_option pp.all true
-- spec: Decidable.decide : forall (p : Prop) [h : Decidable p], Bool
def Decidable.decide : forall (p : Prop) [h : Decidable p], Bool :=
  fun (p : Prop) [h : Decidable p] => Decidable.casesOn.{1} p (fun (x._@.Init.Prelude.4037422846._hygCtx._hyg.7 : Decidable p) => Bool) h (fun (x._@.Init.Prelude.4037422846._hygCtx._hyg.12 : Not p) => Bool.false) (fun (x._@.Init.Prelude.4037422846._hygCtx._hyg.19 : p) => Bool.true)
