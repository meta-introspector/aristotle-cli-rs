import Mathlib

set_option pp.all true
-- spec: Applicative.toFunctor : forall {f : Type.{u} -> Type.{v}} [self : Applicative.{u, v} f], Functor.{u, v} f
def Applicative.toFunctor : forall {f : Type.{u} -> Type.{v}} [self : Applicative.{u, v} f], Functor.{u, v} f :=
  fun (f : Type.{u} -> Type.{v}) [self : Applicative.{u, v} f] => self.1
