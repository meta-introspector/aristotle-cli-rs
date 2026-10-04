import Mathlib

set_option pp.all true
-- spec: Std.IterStep.mapIterator : forall {α : Type.{u}} {β : Type.{w}} {α' : Type.{u'}}, (α -> α') -> (Std.IterStep.{succ u, succ w} α β) -> (Std.IterStep.{succ u', succ w} α' β)
def Std.IterStep.mapIterator : forall {α : Type.{u}} {β : Type.{w}} {α' : Type.{u'}}, (α -> α') -> (Std.IterStep.{succ u, succ w} α β) -> (Std.IterStep.{succ u', succ w} α' β) :=
  fun {α : Type.{u}} {β : Type.{w}} {α' : Type.{u'}} (f : α -> α') (x._@.Init.Data.Iterators.Basic.1962027013._hygCtx._hyg.15 : Std.IterStep.{succ u, succ w} α β) => Std.IterStep.successor.match_1.{u, w, max (succ u') (succ w)} α β (fun (x._@.Init.Data.Iterators.Basic.1962027013._hygCtx.15.Init.Data.Iterators.Basic.1962027013._hygCtx._hyg.26 : Std.IterStep.{succ u, succ w} α β) => Std.IterStep.{succ u', succ w} α' β) x._@.Init.Data.Iterators.Basic.1962027013._hygCtx._hyg.15 (fun (it : α) (out : β) => Std.IterStep.yield.{succ u', succ w} α' β (f it) out) (fun (it : α) => Std.IterStep.skip.{succ u', succ w} α' β (f it)) (fun (_ : Unit) => Std.IterStep.done.{succ u', succ w} α' β)
