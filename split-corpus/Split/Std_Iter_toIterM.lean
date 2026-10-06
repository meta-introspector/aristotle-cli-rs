import Mathlib

set_option pp.all true
-- spec: Std.Iter.toIterM : forall {α : Type.{w}} {β : Type.{w}}, (Std.Iter.{w} α β) -> (Std.IterM.{w, w} α Id.{w} β)
def Std.Iter.toIterM : forall {α : Type.{w}} {β : Type.{w}}, (Std.Iter.{w} α β) -> (Std.IterM.{w, w} α Id.{w} β) :=
  fun {α : Type.{w}} {β : Type.{w}} (it : Std.Iter.{w} α β) => Std.IterM.mk.{w, w} α Id.{w} β (Std.Iter.internalState.{w} α β it)
