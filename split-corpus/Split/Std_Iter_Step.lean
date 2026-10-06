import Mathlib

set_option pp.all true
-- spec: Std.Iter.Step : forall {α : Type.{w}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.3802030064._hygCtx._hyg.4 : Std.Iterator.{w, w} α Id.{w} β], (Std.Iter.{w} α β) -> Sort.{max 1 (succ w)}
def Std.Iter.Step : forall {α : Type.{w}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.3802030064._hygCtx._hyg.4 : Std.Iterator.{w, w} α Id.{w} β], (Std.Iter.{w} α β) -> Sort.{max 1 (succ w)} :=
  fun {α : Type.{w}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.3802030064._hygCtx._hyg.4 : Std.Iterator.{w, w} α Id.{w} β] (it : Std.Iter.{w} α β) => Std.PlausibleIterStep.{w, w} (Std.Iter.{w} α β) β (Std.Iter.IsPlausibleStep.{w} α β inst._@.Init.Data.Iterators.Basic.3802030064._hygCtx._hyg.4 it)
