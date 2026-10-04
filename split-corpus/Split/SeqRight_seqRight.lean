import Mathlib

set_option pp.all true
-- spec: SeqRight.seqRight : forall {f : Type.{u} -> Type.{v}} [self : SeqRight.{u, v} f] {α : Type.{u}} {β : Type.{u}}, (f α) -> (Unit -> (f β)) -> (f β)
def SeqRight.seqRight : forall {f : Type.{u} -> Type.{v}} [self : SeqRight.{u, v} f] {α : Type.{u}} {β : Type.{u}}, (f α) -> (Unit -> (f β)) -> (f β) :=
  fun (f : Type.{u} -> Type.{v}) [self : SeqRight.{u, v} f] => self.1
