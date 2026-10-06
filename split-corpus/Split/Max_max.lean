import Mathlib

set_option pp.all true
-- spec: Max.max : forall {α : Type.{u}} [self : Max.{u} α], α -> α -> α
def Max.max : forall {α : Type.{u}} [self : Max.{u} α], α -> α -> α :=
  fun (α : Type.{u}) [self : Max.{u} α] => self.1
