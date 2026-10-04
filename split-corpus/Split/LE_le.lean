import Mathlib

set_option pp.all true
-- spec: LE.le : forall {α : Type.{u}} [self : LE.{u} α], α -> α -> Prop
def LE.le : forall {α : Type.{u}} [self : LE.{u} α], α -> α -> Prop :=
  fun (α : Type.{u}) [self : LE.{u} α] => self.1
