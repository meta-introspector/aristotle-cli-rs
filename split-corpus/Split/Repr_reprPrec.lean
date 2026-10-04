import Mathlib

set_option pp.all true
-- spec: Repr.reprPrec : forall {α : Type.{u}} [self : Repr.{u} α], α -> Nat -> Std.Format
def Repr.reprPrec : forall {α : Type.{u}} [self : Repr.{u} α], α -> Nat -> Std.Format :=
  fun (α : Type.{u}) [self : Repr.{u} α] => self.1
