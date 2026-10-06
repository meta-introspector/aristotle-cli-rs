import Mathlib

set_option pp.all true
-- spec: Inhabited.default : forall {α : Sort.{u}} [self : Inhabited.{u} α], α
def Inhabited.default : forall {α : Sort.{u}} [self : Inhabited.{u} α], α :=
  fun (α : Sort.{u}) [self : Inhabited.{u} α] => self.1
