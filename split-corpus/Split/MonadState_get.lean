import Mathlib

set_option pp.all true
-- spec: MonadState.get : forall {σ : outParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}} [self : MonadState.{u, v} σ m], m σ
def MonadState.get : forall {σ : outParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}} [self : MonadState.{u, v} σ m], m σ :=
  fun {σ : outParam.{succ (succ u)} Type.{u}} (m : Type.{u} -> Type.{v}) [self : MonadState.{u, v} σ m] => self.1
