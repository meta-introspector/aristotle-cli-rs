import Mathlib

set_option pp.all true
-- spec: Applicative.toSeqLeft : forall {f : Type.{u} -> Type.{v}} [self : Applicative.{u, v} f], SeqLeft.{u, v} f
def Applicative.toSeqLeft : forall {f : Type.{u} -> Type.{v}} [self : Applicative.{u, v} f], SeqLeft.{u, v} f :=
  fun (f : Type.{u} -> Type.{v}) [self : Applicative.{u, v} f] => self.4
