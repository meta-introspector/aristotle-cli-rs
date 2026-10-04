import Mathlib

set_option pp.all true
-- spec: Applicative.toPure : forall {f : Type.{u} -> Type.{v}} [self : Applicative.{u, v} f], Pure.{u, v} f
def Applicative.toPure : forall {f : Type.{u} -> Type.{v}} [self : Applicative.{u, v} f], Pure.{u, v} f :=
  fun (f : Type.{u} -> Type.{v}) [self : Applicative.{u, v} f] => self.2
