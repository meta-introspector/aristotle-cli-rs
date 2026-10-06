import Mathlib

set_option pp.all true
-- spec: Std.IterM.Step : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.3802030063._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β], (Std.IterM.{w, w'} α m β) -> Sort.{max 1 (succ w)}
def Std.IterM.Step : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.3802030063._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β], (Std.IterM.{w, w'} α m β) -> Sort.{max 1 (succ w)} :=
  fun {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.3802030063._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β] (it : Std.IterM.{w, w'} α m β) => Std.PlausibleIterStep.{w, w} (Std.IterM.{w, w'} α m β) β (Std.IterM.IsPlausibleStep.{w, w'} α m β inst._@.Init.Data.Iterators.Basic.3802030063._hygCtx._hyg.7 it)
