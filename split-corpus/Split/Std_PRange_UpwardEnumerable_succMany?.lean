import Mathlib

set_option pp.all true
-- spec: Std.PRange.UpwardEnumerable.succMany? : forall {α : Type.{u}} [self : Std.PRange.UpwardEnumerable.{u} α], Nat -> α -> (Option.{u} α)
def Std.PRange.UpwardEnumerable.succMany? : forall {α : Type.{u}} [self : Std.PRange.UpwardEnumerable.{u} α], Nat -> α -> (Option.{u} α) :=
  fun (α : Type.{u}) [self : Std.PRange.UpwardEnumerable.{u} α] => self.2
