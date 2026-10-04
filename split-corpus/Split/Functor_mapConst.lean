import Mathlib

set_option pp.all true
-- spec: Functor.mapConst : forall {f : Type.{u} -> Type.{v}} [self : Functor.{u, v} f] {α : Type.{u}} {β : Type.{u}}, α -> (f β) -> (f α)
def Functor.mapConst : forall {f : Type.{u} -> Type.{v}} [self : Functor.{u, v} f] {α : Type.{u}} {β : Type.{u}}, α -> (f β) -> (f α) :=
  fun (f : Type.{u} -> Type.{v}) [self : Functor.{u, v} f] => self.2
