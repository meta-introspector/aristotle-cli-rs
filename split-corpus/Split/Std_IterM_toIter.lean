import Mathlib

set_option pp.all true
-- spec: Std.IterM.toIter : forall {α : Type.{w}} {β : Type.{w}}, (Std.IterM.{w, w} α Id.{w} β) -> (Std.Iter.{w} α β)
def Std.IterM.toIter : forall {α : Type.{w}} {β : Type.{w}}, (Std.IterM.{w, w} α Id.{w} β) -> (Std.Iter.{w} α β) :=
  fun {α : Type.{w}} {β : Type.{w}} (it : Std.IterM.{w, w} α Id.{w} β) => Std.Iter.mk.{w} α β (Std.IterM.internalState.{w, w} α Id.{w} β it)
