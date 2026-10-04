import Mathlib

set_option pp.all true
-- spec: Alternative.toApplicative : forall {f : Type.{u} -> Type.{v}} [self : Alternative.{u, v} f], Applicative.{u, v} f
def Alternative.toApplicative : forall {f : Type.{u} -> Type.{v}} [self : Alternative.{u, v} f], Applicative.{u, v} f :=
  fun (f : Type.{u} -> Type.{v}) [self : Alternative.{u, v} f] => self.1
