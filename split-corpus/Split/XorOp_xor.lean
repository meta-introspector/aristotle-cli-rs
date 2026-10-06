import Mathlib

set_option pp.all true
-- spec: XorOp.xor : forall {α : Type.{u}} [self : XorOp.{u} α], α -> α -> α
def XorOp.xor : forall {α : Type.{u}} [self : XorOp.{u} α], α -> α -> α :=
  fun (α : Type.{u}) [self : XorOp.{u} α] => self.1
