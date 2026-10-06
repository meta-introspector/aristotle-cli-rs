import Mathlib

set_option pp.all true
-- spec: Applicative.toSeq : forall {f : Type.{u} -> Type.{v}} [self : Applicative.{u, v} f], Seq.{u, v} f
def Applicative.toSeq : forall {f : Type.{u} -> Type.{v}} [self : Applicative.{u, v} f], Seq.{u, v} f :=
  fun (f : Type.{u} -> Type.{v}) [self : Applicative.{u, v} f] => self.3
