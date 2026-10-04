import Mathlib

set_option pp.all true
-- spec: MonadStateOf.modifyGet : forall {σ : semiOutParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}} [self : MonadStateOf.{u, v} σ m] {α : Type.{u}}, (σ -> (Prod.{u, u} α σ)) -> (m α)
def MonadStateOf.modifyGet : forall {σ : semiOutParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}} [self : MonadStateOf.{u, v} σ m] {α : Type.{u}}, (σ -> (Prod.{u, u} α σ)) -> (m α) :=
  fun (σ : semiOutParam.{succ (succ u)} Type.{u}) (m : Type.{u} -> Type.{v}) [self : MonadStateOf.{u, v} σ m] => self.3
