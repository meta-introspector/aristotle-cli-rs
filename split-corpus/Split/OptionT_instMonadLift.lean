import Mathlib

set_option pp.all true
-- spec: OptionT.instMonadLift : forall {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Option.3582836318._hygCtx._hyg.5 : Monad.{u, v} m], MonadLift.{u, v, v} m (OptionT.{u, v} m)
def OptionT.instMonadLift : forall {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Option.3582836318._hygCtx._hyg.5 : Monad.{u, v} m], MonadLift.{u, v, v} m (OptionT.{u, v} m) :=
  fun {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Option.3582836318._hygCtx._hyg.5 : Monad.{u, v} m] => MonadLift.mk.{u, v, v} m (OptionT.{u, v} m) (fun {α._@.Init.Control.Option.3582836318._hygCtx._hyg.19 : Type.{u}} => OptionT.lift.{u, v} m inst._@.Init.Control.Option.3582836318._hygCtx._hyg.5 α._@.Init.Control.Option.3582836318._hygCtx._hyg.19)
