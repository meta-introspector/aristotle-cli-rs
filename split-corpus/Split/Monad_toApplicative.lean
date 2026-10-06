import Mathlib

set_option pp.all true
-- spec: Monad.toApplicative : forall {m : Type.{u} -> Type.{v}} [self : Monad.{u, v} m], Applicative.{u, v} m
def Monad.toApplicative : forall {m : Type.{u} -> Type.{v}} [self : Monad.{u, v} m], Applicative.{u, v} m :=
  fun (m : Type.{u} -> Type.{v}) [self : Monad.{u, v} m] => self.1
