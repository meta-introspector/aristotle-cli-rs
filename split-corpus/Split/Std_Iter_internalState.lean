import Mathlib

set_option pp.all true
-- spec: Std.Iter.internalState : forall {α : Type.{w}} {β : Type.{w}}, (Std.Iter.{w} α β) -> α
def Std.Iter.internalState : forall {α : Type.{w}} {β : Type.{w}}, (Std.Iter.{w} α β) -> α :=
  fun (α : Type.{w}) (β : Type.{w}) (self : Std.Iter.{w} α β) => self.1
