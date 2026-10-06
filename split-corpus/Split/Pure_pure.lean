import Mathlib

set_option pp.all true
-- spec: Pure.pure : forall {f : Type.{u} -> Type.{v}} [self : Pure.{u, v} f] {α : Type.{u}}, α -> (f α)
def Pure.pure : forall {f : Type.{u} -> Type.{v}} [self : Pure.{u, v} f] {α : Type.{u}}, α -> (f α) :=
  fun (f : Type.{u} -> Type.{v}) [self : Pure.{u, v} f] => self.1
