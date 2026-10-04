import Mathlib

set_option pp.all true
-- spec: SizeOf.sizeOf : forall {α : Sort.{u}} [self : SizeOf.{u} α], α -> Nat
def SizeOf.sizeOf : forall {α : Sort.{u}} [self : SizeOf.{u} α], α -> Nat :=
  fun (α : Sort.{u}) [self : SizeOf.{u} α] => self.1
