import Mathlib

set_option pp.all true
-- spec: ToBool.toBool : forall {α : Type.{u}} [self : ToBool.{u} α], α -> Bool
def ToBool.toBool : forall {α : Type.{u}} [self : ToBool.{u} α], α -> Bool :=
  fun (α : Type.{u}) [self : ToBool.{u} α] => self.1
