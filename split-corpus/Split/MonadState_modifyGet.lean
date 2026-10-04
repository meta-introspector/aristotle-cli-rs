import Mathlib

set_option pp.all true
-- spec: MonadState.modifyGet : forall {σ : outParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}} [self : MonadState.{u, v} σ m] {α : Type.{u}}, (σ -> (Prod.{u, u} α σ)) -> (m α)
def MonadState.modifyGet : forall {σ : outParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}} [self : MonadState.{u, v} σ m] {α : Type.{u}}, (σ -> (Prod.{u, u} α σ)) -> (m α) :=
  fun {σ : outParam.{succ (succ u)} Type.{u}} (m : Type.{u} -> Type.{v}) [self : MonadState.{u, v} σ m] => self.3
