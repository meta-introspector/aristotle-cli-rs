import Mathlib

set_option pp.all true
-- spec: Zero.zero : forall {α : Type.{u}} [self : Zero.{u} α], α
def Zero.zero : forall {α : Type.{u}} [self : Zero.{u} α], α :=
  fun (α : Type.{u}) [self : Zero.{u} α] => self.1
