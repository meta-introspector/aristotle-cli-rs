import Mathlib

set_option pp.all true
-- spec: Std.ToFormat.format : forall {α : Type.{u}} [self : Std.ToFormat.{u} α], α -> Std.Format
def Std.ToFormat.format : forall {α : Type.{u}} [self : Std.ToFormat.{u} α], α -> Std.Format :=
  fun (α : Type.{u}) [self : Std.ToFormat.{u} α] => self.1
