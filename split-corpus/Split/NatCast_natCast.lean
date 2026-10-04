import Mathlib

set_option pp.all true
-- spec: NatCast.natCast : forall {R : Type.{u}} [self : NatCast.{u} R], Nat -> R
def NatCast.natCast : forall {R : Type.{u}} [self : NatCast.{u} R], Nat -> R :=
  fun (R : Type.{u}) [self : NatCast.{u} R] => self.1
