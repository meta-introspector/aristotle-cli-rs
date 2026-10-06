import Mathlib

set_option pp.all true
-- spec: Functor.map : forall {f : Type.{u} -> Type.{v}} [self : Functor.{u, v} f] {α : Type.{u}} {β : Type.{u}}, (α -> β) -> (f α) -> (f β)
def Functor.map : forall {f : Type.{u} -> Type.{v}} [self : Functor.{u, v} f] {α : Type.{u}} {β : Type.{u}}, (α -> β) -> (f α) -> (f β) :=
  fun (f : Type.{u} -> Type.{v}) [self : Functor.{u, v} f] => self.1
