import Mathlib

set_option pp.all true
-- spec: cast : forall {α : Sort.{u}} {β : Sort.{u}}, (Eq.{succ u} Sort.{u} α β) -> α -> β
def cast : forall {α : Sort.{u}} {β : Sort.{u}}, (Eq.{succ u} Sort.{u} α β) -> α -> β :=
  fun {α : Sort.{u}} {β : Sort.{u}} (h : Eq.{succ u} Sort.{u} α β) (a : α) => Eq.rec.{u, succ u} Sort.{u} α (fun (x._@.Init.Prelude.135197979._hygCtx._hyg.11 : Sort.{u}) (x._@.Init.Prelude.135197979._hygCtx._hyg.10 : Eq.{succ u} Sort.{u} α x._@.Init.Prelude.135197979._hygCtx._hyg.11) => x._@.Init.Prelude.135197979._hygCtx._hyg.11) a β h
