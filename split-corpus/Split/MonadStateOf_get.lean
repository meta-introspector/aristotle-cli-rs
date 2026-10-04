import Mathlib

set_option pp.all true
-- spec: MonadStateOf.get : forall {σ : semiOutParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}} [self : MonadStateOf.{u, v} σ m], m σ
def MonadStateOf.get : forall {σ : semiOutParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}} [self : MonadStateOf.{u, v} σ m], m σ :=
  fun (σ : semiOutParam.{succ (succ u)} Type.{u}) (m : Type.{u} -> Type.{v}) [self : MonadStateOf.{u, v} σ m] => self.1
