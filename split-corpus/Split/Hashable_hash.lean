import Mathlib

set_option pp.all true
-- spec: Hashable.hash : forall {α : Sort.{u}} [self : Hashable.{u} α], α -> UInt64
def Hashable.hash : forall {α : Sort.{u}} [self : Hashable.{u} α], α -> UInt64 :=
  fun (α : Sort.{u}) [self : Hashable.{u} α] => self.1
