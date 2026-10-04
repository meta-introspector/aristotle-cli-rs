import Mathlib

set_option pp.all true
-- spec: Subtype.val : forall {α : Sort.{u}} {p : α -> Prop}, (Subtype.{u} α p) -> α
def Subtype.val : forall {α : Sort.{u}} {p : α -> Prop}, (Subtype.{u} α p) -> α :=
  fun (α : Sort.{u}) (p : α -> Prop) (self : Subtype.{u} α p) => self.1
