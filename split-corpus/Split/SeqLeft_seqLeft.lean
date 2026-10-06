import Mathlib

set_option pp.all true
-- spec: SeqLeft.seqLeft : forall {f : Type.{u} -> Type.{v}} [self : SeqLeft.{u, v} f] {α : Type.{u}} {β : Type.{u}}, (f α) -> (Unit -> (f β)) -> (f α)
def SeqLeft.seqLeft : forall {f : Type.{u} -> Type.{v}} [self : SeqLeft.{u, v} f] {α : Type.{u}} {β : Type.{u}}, (f α) -> (Unit -> (f β)) -> (f α) :=
  fun (f : Type.{u} -> Type.{v}) [self : SeqLeft.{u, v} f] => self.1
