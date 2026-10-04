import Mathlib

set_option pp.all true
-- spec: ShiftLeft.shiftLeft : forall {α : Type.{u}} [self : ShiftLeft.{u} α], α -> α -> α
def ShiftLeft.shiftLeft : forall {α : Type.{u}} [self : ShiftLeft.{u} α], α -> α -> α :=
  fun (α : Type.{u}) [self : ShiftLeft.{u} α] => self.1
