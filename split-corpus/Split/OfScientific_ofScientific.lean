import Mathlib

set_option pp.all true
-- spec: OfScientific.ofScientific : forall {α : Type.{u}} [self : OfScientific.{u} α], Nat -> Bool -> Nat -> α
def OfScientific.ofScientific : forall {α : Type.{u}} [self : OfScientific.{u} α], Nat -> Bool -> Nat -> α :=
  fun (α : Type.{u}) [self : OfScientific.{u} α] => self.1
