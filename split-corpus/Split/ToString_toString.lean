import Mathlib

set_option pp.all true
-- spec: ToString.toString : forall {α : Type.{u}} [self : ToString.{u} α], α -> String
def ToString.toString : forall {α : Type.{u}} [self : ToString.{u} α], α -> String :=
  fun (α : Type.{u}) [self : ToString.{u} α] => self.1
