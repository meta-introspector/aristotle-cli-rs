import Mathlib

set_option pp.all true
-- spec: Std.Iter.toList : forall {α : Type.{w}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Consumers.Collect.83731720._hygCtx._hyg.4 : Std.Iterator.{w, w} α Id.{w} β], (Std.Iter.{w} α β) -> (List.{w} β)
def Std.Iter.toList : forall {α : Type.{w}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Consumers.Collect.83731720._hygCtx._hyg.4 : Std.Iterator.{w, w} α Id.{w} β], (Std.Iter.{w} α β) -> (List.{w} β) :=
  fun {α : Type.{w}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Consumers.Collect.83731720._hygCtx._hyg.4 : Std.Iterator.{w, w} α Id.{w} β] (it : Std.Iter.{w} α β) => Id.run.{w} (List.{w} β) (Std.IterM.toList.{w, w} α Id.{w} Id.instMonad.{w} β inst._@.Init.Data.Iterators.Consumers.Collect.83731720._hygCtx._hyg.4 (Std.Iter.toIterM.{w} α β it))
