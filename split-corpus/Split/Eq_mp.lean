import Mathlib

set_option pp.all true
-- spec: Eq.mp : forall {α : Sort.{u}} {β : Sort.{u}}, (Eq.{succ u} Sort.{u} α β) -> α -> β
def Eq.mp : forall {α : Sort.{u}} {β : Sort.{u}}, (Eq.{succ u} Sort.{u} α β) -> α -> β :=
  fun {α : Sort.{u}} {β : Sort.{u}} (h : Eq.{succ u} Sort.{u} α β) (a : α) => Eq.rec.{u, succ u} Sort.{u} α (fun (x._@.Init.Core.629784301._hygCtx._hyg.14 : Sort.{u}) (h._@.Init.Core.629784301._hygCtx._hyg.15 : Eq.{succ u} Sort.{u} α x._@.Init.Core.629784301._hygCtx._hyg.14) => x._@.Init.Core.629784301._hygCtx._hyg.14) a β h
