import Mathlib

set_option pp.all true
-- spec: Std.IterStep.successor : forall {α : Type.{u}} {β : Type.{w}}, (Std.IterStep.{succ u, succ w} α β) -> (Option.{u} α)
def Std.IterStep.successor : forall {α : Type.{u}} {β : Type.{w}}, (Std.IterStep.{succ u, succ w} α β) -> (Option.{u} α) :=
  fun {α : Type.{u}} {β : Type.{w}} (x._@.Init.Data.Iterators.Basic.1473718047._hygCtx._hyg.10 : Std.IterStep.{succ u, succ w} α β) => Std.IterStep.successor.match_1.{u, w, succ u} α β (fun (x._@.Init.Data.Iterators.Basic.1473718047._hygCtx.10.Init.Data.Iterators.Basic.1473718047._hygCtx._hyg.21 : Std.IterStep.{succ u, succ w} α β) => Option.{u} α) x._@.Init.Data.Iterators.Basic.1473718047._hygCtx._hyg.10 (fun (it : α) (out._@.Init.Data.Iterators.Basic.1473718047._hygCtx._hyg.29 : β) => Option.some.{u} α it) (fun (it : α) => Option.some.{u} α it) (fun (_ : Unit) => Option.none.{u} α)
