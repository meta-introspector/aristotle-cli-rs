import Mathlib

set_option pp.all true
-- spec: AndOp.and : forall {α : Type.{u}} [self : AndOp.{u} α], α -> α -> α
def AndOp.and : forall {α : Type.{u}} [self : AndOp.{u} α], α -> α -> α :=
  fun (α : Type.{u}) [self : AndOp.{u} α] => self.1
