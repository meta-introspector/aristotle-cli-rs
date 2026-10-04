import Mathlib

set_option pp.all true
-- spec: BEq.beq : forall {α : Type.{u}} [self : BEq.{u} α], α -> α -> Bool
def BEq.beq : forall {α : Type.{u}} [self : BEq.{u} α], α -> α -> Bool :=
  fun (α : Type.{u}) [self : BEq.{u} α] => self.1
