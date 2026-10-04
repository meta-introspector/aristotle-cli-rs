import Mathlib

set_option pp.all true
-- spec: Task.get : forall {α : Type.{u}}, (Task.{u} α) -> α
def Task.get : forall {α : Type.{u}}, (Task.{u} α) -> α :=
  fun (α : Type.{u}) (self : Task.{u} α) => self.1
