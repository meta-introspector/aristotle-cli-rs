import Mathlib

set_option pp.all true
-- spec: Std.Iter.IsPlausibleSuccessorOf : forall {α : Type.{w}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.2361324552._hygCtx._hyg.4 : Std.Iterator.{w, w} α Id.{w} β], (Std.Iter.{w} α β) -> (Std.Iter.{w} α β) -> Prop
def Std.Iter.IsPlausibleSuccessorOf : forall {α : Type.{w}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.2361324552._hygCtx._hyg.4 : Std.Iterator.{w, w} α Id.{w} β], (Std.Iter.{w} α β) -> (Std.Iter.{w} α β) -> Prop :=
  fun {α : Type.{w}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.2361324552._hygCtx._hyg.4 : Std.Iterator.{w, w} α Id.{w} β] (it' : Std.Iter.{w} α β) (it : Std.Iter.{w} α β) => Std.IterM.IsPlausibleSuccessorOf.{w, w} α Id.{w} β inst._@.Init.Data.Iterators.Basic.2361324552._hygCtx._hyg.4 (Std.Iter.toIterM.{w} α β it') (Std.Iter.toIterM.{w} α β it)
