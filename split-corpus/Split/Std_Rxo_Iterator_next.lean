import Mathlib

set_option pp.all true
-- spec: Std.Rxo.Iterator.next : forall {α : Type.{u}}, (Std.Rxo.Iterator.{u} α) -> (Option.{u} α)
def Std.Rxo.Iterator.next : forall {α : Type.{u}}, (Std.Rxo.Iterator.{u} α) -> (Option.{u} α) :=
  fun (α : Type.{u}) (self : Std.Rxo.Iterator.{u} α) => self.1
