import Mathlib

set_option pp.all true
-- spec: Sigma.fst : forall {α : Type.{u}} {β : α -> Type.{v}}, (Sigma.{u, v} α β) -> α
def Sigma.fst : forall {α : Type.{u}} {β : α -> Type.{v}}, (Sigma.{u, v} α β) -> α :=
  fun (α : Type.{u}) (β : α -> Type.{v}) (self : Sigma.{u, v} α β) => self.1
