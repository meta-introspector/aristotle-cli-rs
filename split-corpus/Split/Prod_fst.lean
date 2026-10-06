import Mathlib

set_option pp.all true
-- spec: Prod.fst : forall {α : Type.{u}} {β : Type.{v}}, (Prod.{u, v} α β) -> α
def Prod.fst : forall {α : Type.{u}} {β : Type.{v}}, (Prod.{u, v} α β) -> α :=
  fun (α : Type.{u}) (β : Type.{v}) (self : Prod.{u, v} α β) => self.1
