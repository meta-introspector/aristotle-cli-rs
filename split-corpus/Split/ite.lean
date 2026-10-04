import Mathlib

set_option pp.all true
-- spec: ite : forall {α : Sort.{u}} (c : Prop) [h : Decidable c], α -> α -> α
def ite : forall {α : Sort.{u}} (c : Prop) [h : Decidable c], α -> α -> α :=
  fun {α : Sort.{u}} (c : Prop) [h : Decidable c] (t : α) (e : α) => Decidable.casesOn.{u} c (fun (x._@.Init.Prelude.1596968041._hygCtx._hyg.10 : Decidable c) => α) h (fun (x._@.Init.Prelude.1596968041._hygCtx._hyg.15 : Not c) => e) (fun (x._@.Init.Prelude.1596968041._hygCtx._hyg.22 : c) => t)
