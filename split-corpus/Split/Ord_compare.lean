import Mathlib

set_option pp.all true
-- spec: Ord.compare : forall {α : Type.{u}} [self : Ord.{u} α], α -> α -> Ordering
def Ord.compare : forall {α : Type.{u}} [self : Ord.{u} α], α -> α -> Ordering :=
  fun (α : Type.{u}) [self : Ord.{u} α] => self.1
