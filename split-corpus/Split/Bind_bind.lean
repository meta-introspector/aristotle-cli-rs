import Mathlib

set_option pp.all true
-- spec: Bind.bind : forall {m : Type.{u} -> Type.{v}} [self : Bind.{u, v} m] {α : Type.{u}} {β : Type.{u}}, (m α) -> (α -> (m β)) -> (m β)
def Bind.bind : forall {m : Type.{u} -> Type.{v}} [self : Bind.{u, v} m] {α : Type.{u}} {β : Type.{u}}, (m α) -> (α -> (m β)) -> (m β) :=
  fun (m : Type.{u} -> Type.{v}) [self : Bind.{u, v} m] => self.1
