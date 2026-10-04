import Mathlib

set_option pp.all true
-- spec: Alternative.failure : forall {f : Type.{u} -> Type.{v}} [self : Alternative.{u, v} f] {α : Type.{u}}, f α
def Alternative.failure : forall {f : Type.{u} -> Type.{v}} [self : Alternative.{u, v} f] {α : Type.{u}}, f α :=
  fun (f : Type.{u} -> Type.{v}) [self : Alternative.{u, v} f] => self.2
