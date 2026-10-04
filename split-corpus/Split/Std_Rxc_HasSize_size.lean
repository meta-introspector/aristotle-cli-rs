import Mathlib

set_option pp.all true
-- spec: Std.Rxc.HasSize.size : forall {α : Type.{u}} [self : Std.Rxc.HasSize.{u} α], α -> α -> Nat
def Std.Rxc.HasSize.size : forall {α : Type.{u}} [self : Std.Rxc.HasSize.{u} α], α -> α -> Nat :=
  fun (α : Type.{u}) [self : Std.Rxc.HasSize.{u} α] => self.1
