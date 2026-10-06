import Mathlib

set_option pp.all true
-- spec: MonadReaderOf.read : forall {ρ : semiOutParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}} [self : MonadReaderOf.{u, v} ρ m], m ρ
def MonadReaderOf.read : forall {ρ : semiOutParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}} [self : MonadReaderOf.{u, v} ρ m], m ρ :=
  fun (ρ : semiOutParam.{succ (succ u)} Type.{u}) (m : Type.{u} -> Type.{v}) [self : MonadReaderOf.{u, v} ρ m] => self.1
