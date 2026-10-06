import Mathlib

set_option pp.all true
-- spec: instMonadStateOfStateTOfMonad : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.4200749808._hygCtx._hyg.6 : Monad.{u, v} m], MonadStateOf.{u, max u v} σ (StateT.{u, v} σ m)
def instMonadStateOfStateTOfMonad : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.4200749808._hygCtx._hyg.6 : Monad.{u, v} m], MonadStateOf.{u, max u v} σ (StateT.{u, v} σ m) :=
  fun {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.4200749808._hygCtx._hyg.6 : Monad.{u, v} m] => MonadStateOf.mk.{u, max u v} σ (StateT.{u, v} σ m) (StateT.get.{u, v} σ m inst._@.Init.Control.State.4200749808._hygCtx._hyg.6) (StateT.set.{u, v} σ m inst._@.Init.Control.State.4200749808._hygCtx._hyg.6) (fun {α._@.Init.Control.State.4200749808._hygCtx._hyg.22 : Type.{u}} => StateT.modifyGet.{u, v} σ m inst._@.Init.Control.State.4200749808._hygCtx._hyg.6 α._@.Init.Control.State.4200749808._hygCtx._hyg.22)
