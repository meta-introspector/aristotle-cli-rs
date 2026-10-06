import Mathlib

set_option pp.all true
-- spec: Std.Iter.IsPlausibleStep : forall {α : Type.{w}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.3667085597._hygCtx._hyg.4 : Std.Iterator.{w, w} α Id.{w} β], (Std.Iter.{w} α β) -> (Std.IterStep.{succ w, succ w} (Std.Iter.{w} α β) β) -> Prop
def Std.Iter.IsPlausibleStep : forall {α : Type.{w}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.3667085597._hygCtx._hyg.4 : Std.Iterator.{w, w} α Id.{w} β], (Std.Iter.{w} α β) -> (Std.IterStep.{succ w, succ w} (Std.Iter.{w} α β) β) -> Prop :=
  fun {α : Type.{w}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.3667085597._hygCtx._hyg.4 : Std.Iterator.{w, w} α Id.{w} β] (it : Std.Iter.{w} α β) (step : Std.IterStep.{succ w, succ w} (Std.Iter.{w} α β) β) => Std.IterM.IsPlausibleStep.{w, w} α Id.{w} β inst._@.Init.Data.Iterators.Basic.3667085597._hygCtx._hyg.4 (Std.Iter.toIterM.{w} α β it) (Std.IterStep.mapIterator.{w, w, w} (Std.Iter.{w} α β) β (Std.IterM.{w, w} α Id.{w} β) (Std.Iter.toIterM.{w} α β) step)
