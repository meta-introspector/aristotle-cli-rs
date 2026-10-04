import Mathlib

set_option pp.all true
-- spec: Min.min : forall {α : Type.{u}} [self : Min.{u} α], α -> α -> α
def Min.min : forall {α : Type.{u}} [self : Min.{u} α], α -> α -> α :=
  fun (α : Type.{u}) [self : Min.{u} α] => self.1
