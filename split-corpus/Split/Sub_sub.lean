import Mathlib

set_option pp.all true
-- spec: Sub.sub : forall {α : Type.{u}} [self : Sub.{u} α], α -> α -> α
def Sub.sub : forall {α : Type.{u}} [self : Sub.{u} α], α -> α -> α :=
  fun (α : Type.{u}) [self : Sub.{u} α] => self.1
