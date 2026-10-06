import Mathlib

set_option pp.all true
-- spec: Applicative.toSeqRight : forall {f : Type.{u} -> Type.{v}} [self : Applicative.{u, v} f], SeqRight.{u, v} f
def Applicative.toSeqRight : forall {f : Type.{u} -> Type.{v}} [self : Applicative.{u, v} f], SeqRight.{u, v} f :=
  fun (f : Type.{u} -> Type.{v}) [self : Applicative.{u, v} f] => self.5
