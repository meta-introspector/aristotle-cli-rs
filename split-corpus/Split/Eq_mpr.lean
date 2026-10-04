import Mathlib

set_option pp.all true
-- spec: Eq.mpr : forall {α : Sort.{u}} {β : Sort.{u}}, (Eq.{succ u} Sort.{u} α β) -> β -> α
def Eq.mpr : forall {α : Sort.{u}} {β : Sort.{u}}, (Eq.{succ u} Sort.{u} α β) -> β -> α :=
  fun {α : Sort.{u}} {β : Sort.{u}} (h : Eq.{succ u} Sort.{u} α β) (b : β) => Eq.rec.{u, succ u} Sort.{u} β (fun (x._@.Init.Core.2537982879._hygCtx._hyg.14 : Sort.{u}) (h._@.Init.Core.2537982879._hygCtx._hyg.15 : Eq.{succ u} Sort.{u} β x._@.Init.Core.2537982879._hygCtx._hyg.14) => x._@.Init.Core.2537982879._hygCtx._hyg.14) b α (Eq.symm.{succ u} Sort.{u} α β h)
