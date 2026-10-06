import Mathlib

set_option pp.all true
-- spec: Monad.toBind : forall {m : Type.{u} -> Type.{v}} [self : Monad.{u, v} m], Bind.{u, v} m
def Monad.toBind : forall {m : Type.{u} -> Type.{v}} [self : Monad.{u, v} m], Bind.{u, v} m :=
  fun (m : Type.{u} -> Type.{v}) [self : Monad.{u, v} m] => self.2
