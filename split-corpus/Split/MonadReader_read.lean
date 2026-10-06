import Mathlib

set_option pp.all true
-- spec: MonadReader.read : forall {ρ : outParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}} [self : MonadReader.{u, v} ρ m], m ρ
def MonadReader.read : forall {ρ : outParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}} [self : MonadReader.{u, v} ρ m], m ρ :=
  fun {ρ : outParam.{succ (succ u)} Type.{u}} (m : Type.{u} -> Type.{v}) [self : MonadReader.{u, v} ρ m] => self.1
