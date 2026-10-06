import Mathlib

set_option pp.all true
-- spec: StateT.instMonadLift : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.3582836318._hygCtx._hyg.6 : Monad.{u, v} m], MonadLift.{u, v, max u v} m (StateT.{u, v} σ m)
def StateT.instMonadLift : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.3582836318._hygCtx._hyg.6 : Monad.{u, v} m], MonadLift.{u, v, max u v} m (StateT.{u, v} σ m) :=
  fun {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.3582836318._hygCtx._hyg.6 : Monad.{u, v} m] => MonadLift.mk.{u, v, max u v} m (StateT.{u, v} σ m) (fun {α._@.Init.Control.State.3582836318._hygCtx._hyg.21 : Type.{u}} => StateT.lift.{u, v} σ m inst._@.Init.Control.State.3582836318._hygCtx._hyg.6 α._@.Init.Control.State.3582836318._hygCtx._hyg.21)
