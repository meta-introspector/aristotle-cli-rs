import Mathlib

set_option pp.all true
-- spec: Std.IterM.internalState : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}}, (Std.IterM.{w, w'} α m β) -> α
def Std.IterM.internalState : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}}, (Std.IterM.{w, w'} α m β) -> α :=
  fun (α : Type.{w}) (m : Type.{w} -> Type.{w'}) (β : Type.{w}) (self : Std.IterM.{w, w'} α m β) => self.1
