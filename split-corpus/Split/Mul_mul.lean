import Mathlib

set_option pp.all true
-- spec: Mul.mul : forall {α : Type.{u}} [self : Mul.{u} α], α -> α -> α
def Mul.mul : forall {α : Type.{u}} [self : Mul.{u} α], α -> α -> α :=
  fun (α : Type.{u}) [self : Mul.{u} α] => self.1
