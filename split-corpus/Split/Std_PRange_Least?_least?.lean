import Mathlib

set_option pp.all true
-- spec: Std.PRange.Least?.least? : forall {α : Type.{u}} [self : Std.PRange.Least?.{u} α], Option.{u} α
def Std.PRange.Least?.least? : forall {α : Type.{u}} [self : Std.PRange.Least?.{u} α], Option.{u} α :=
  fun (α : Type.{u}) [self : Std.PRange.Least?.{u} α] => self.1
