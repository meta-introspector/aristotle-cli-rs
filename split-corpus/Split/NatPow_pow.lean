import Mathlib

set_option pp.all true
-- spec: NatPow.pow : forall {α : Type.{u}} [self : NatPow.{u} α], α -> Nat -> α
def NatPow.pow : forall {α : Type.{u}} [self : NatPow.{u} α], α -> Nat -> α :=
  fun (α : Type.{u}) [self : NatPow.{u} α] => self.1
