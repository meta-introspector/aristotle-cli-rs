import Mathlib

set_option pp.all true
-- spec: Array.toList : forall {α : Type.{u}}, (Array.{u} α) -> (List.{u} α)
def Array.toList : forall {α : Type.{u}}, (Array.{u} α) -> (List.{u} α) :=
  fun (α : Type.{u}) (self : Array.{u} α) => self.1
