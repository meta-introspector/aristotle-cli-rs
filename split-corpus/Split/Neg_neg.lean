import Mathlib

set_option pp.all true
-- spec: Neg.neg : forall {α : Type.{u}} [self : Neg.{u} α], α -> α
def Neg.neg : forall {α : Type.{u}} [self : Neg.{u} α], α -> α :=
  fun (α : Type.{u}) [self : Neg.{u} α] => self.1
