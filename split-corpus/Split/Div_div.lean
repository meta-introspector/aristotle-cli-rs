import Mathlib

set_option pp.all true
-- spec: Div.div : forall {α : Type.{u}} [self : Div.{u} α], α -> α -> α
def Div.div : forall {α : Type.{u}} [self : Div.{u} α], α -> α -> α :=
  fun (α : Type.{u}) [self : Div.{u} α] => self.1
