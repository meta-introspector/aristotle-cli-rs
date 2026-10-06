import Mathlib

set_option pp.all true
-- spec: Seq.seq : forall {f : Type.{u} -> Type.{v}} [self : Seq.{u, v} f] {α : Type.{u}} {β : Type.{u}}, (f (α -> β)) -> (Unit -> (f α)) -> (f β)
def Seq.seq : forall {f : Type.{u} -> Type.{v}} [self : Seq.{u, v} f] {α : Type.{u}} {β : Type.{u}}, (f (α -> β)) -> (Unit -> (f α)) -> (f β) :=
  fun (f : Type.{u} -> Type.{v}) [self : Seq.{u, v} f] => self.1
