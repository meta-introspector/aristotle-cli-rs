import Mathlib

set_option pp.all true
-- spec: ShiftRight.shiftRight : forall {α : Type.{u}} [self : ShiftRight.{u} α], α -> α -> α
def ShiftRight.shiftRight : forall {α : Type.{u}} [self : ShiftRight.{u} α], α -> α -> α :=
  fun (α : Type.{u}) [self : ShiftRight.{u} α] => self.1
