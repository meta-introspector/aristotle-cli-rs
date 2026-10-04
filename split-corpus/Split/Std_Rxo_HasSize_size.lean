import Mathlib

set_option pp.all true
-- spec: Std.Rxo.HasSize.size : forall {α : Type.{u}} [self : Std.Rxo.HasSize.{u} α], α -> α -> Nat
def Std.Rxo.HasSize.size : forall {α : Type.{u}} [self : Std.Rxo.HasSize.{u} α], α -> α -> Nat :=
  fun (α : Type.{u}) [self : Std.Rxo.HasSize.{u} α] => self.1
