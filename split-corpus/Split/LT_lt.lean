import Mathlib

set_option pp.all true
-- spec: LT.lt : forall {α : Type.{u}} [self : LT.{u} α], α -> α -> Prop
def LT.lt : forall {α : Type.{u}} [self : LT.{u} α], α -> α -> Prop :=
  fun (α : Type.{u}) [self : LT.{u} α] => self.1
