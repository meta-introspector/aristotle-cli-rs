import Mathlib

set_option pp.all true
-- spec: MonadStateOf.set : forall {σ : semiOutParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}} [self : MonadStateOf.{u, v} σ m], σ -> (m PUnit.{succ u})
def MonadStateOf.set : forall {σ : semiOutParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}} [self : MonadStateOf.{u, v} σ m], σ -> (m PUnit.{succ u}) :=
  fun (σ : semiOutParam.{succ (succ u)} Type.{u}) (m : Type.{u} -> Type.{v}) [self : MonadStateOf.{u, v} σ m] => self.2
