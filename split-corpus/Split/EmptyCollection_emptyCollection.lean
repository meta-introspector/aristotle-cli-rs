import Mathlib

set_option pp.all true
-- spec: EmptyCollection.emptyCollection : forall {α : Type.{u}} [self : EmptyCollection.{u} α], α
def EmptyCollection.emptyCollection : forall {α : Type.{u}} [self : EmptyCollection.{u} α], α :=
  fun (α : Type.{u}) [self : EmptyCollection.{u} α] => self.1
