import Mathlib

set_option pp.all true
-- spec: OrOp.or : forall {α : Type.{u}} [self : OrOp.{u} α], α -> α -> α
def OrOp.or : forall {α : Type.{u}} [self : OrOp.{u} α], α -> α -> α :=
  fun (α : Type.{u}) [self : OrOp.{u} α] => self.1
