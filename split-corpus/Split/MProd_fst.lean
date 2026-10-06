import Mathlib

set_option pp.all true
-- spec: MProd.fst : forall {α : Type.{u}} {β : Type.{u}}, (MProd.{u} α β) -> α
def MProd.fst : forall {α : Type.{u}} {β : Type.{u}}, (MProd.{u} α β) -> α :=
  fun (α : Type.{u}) (β : Type.{u}) (self : MProd.{u} α β) => self.1
