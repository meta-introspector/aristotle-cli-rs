import Mathlib

set_option pp.all true
-- spec: Std.Rxo.Iterator.upperBound : forall {α : Type.{u}}, (Std.Rxo.Iterator.{u} α) -> α
def Std.Rxo.Iterator.upperBound : forall {α : Type.{u}}, (Std.Rxo.Iterator.{u} α) -> α :=
  fun (α : Type.{u}) (self : Std.Rxo.Iterator.{u} α) => self.2
