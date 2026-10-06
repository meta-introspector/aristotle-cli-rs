import Mathlib

set_option pp.all true
-- spec: Append.append : forall {α : Type.{u}} [self : Append.{u} α], α -> α -> α
def Append.append : forall {α : Type.{u}} [self : Append.{u} α], α -> α -> α :=
  fun (α : Type.{u}) [self : Append.{u} α] => self.1
