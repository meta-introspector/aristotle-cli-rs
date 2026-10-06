import Mathlib

set_option pp.all true
-- spec: Mod.mod : forall {α : Type.{u}} [self : Mod.{u} α], α -> α -> α
def Mod.mod : forall {α : Type.{u}} [self : Mod.{u} α], α -> α -> α :=
  fun (α : Type.{u}) [self : Mod.{u} α] => self.1
