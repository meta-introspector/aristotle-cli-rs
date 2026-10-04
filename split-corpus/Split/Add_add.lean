import Mathlib

set_option pp.all true
-- spec: Add.add : forall {α : Type.{u}} [self : Add.{u} α], α -> α -> α
def Add.add : forall {α : Type.{u}} [self : Add.{u} α], α -> α -> α :=
  fun (α : Type.{u}) [self : Add.{u} α] => self.1
