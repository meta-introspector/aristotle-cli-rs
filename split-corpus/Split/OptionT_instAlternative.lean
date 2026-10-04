import Mathlib

set_option pp.all true
-- spec: OptionT.instAlternative : forall {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Option.3400892149._hygCtx._hyg.5 : Monad.{u, v} m], Alternative.{u, v} (OptionT.{u, v} m)
def OptionT.instAlternative : forall {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Option.3400892149._hygCtx._hyg.5 : Monad.{u, v} m], Alternative.{u, v} (OptionT.{u, v} m) :=
  fun {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Option.3400892149._hygCtx._hyg.5 : Monad.{u, v} m] => Alternative.mk.{u, v} (OptionT.{u, v} m) (Monad.toApplicative.{u, v} (OptionT.{u, v} m) (OptionT.instMonad.{u, v} m inst._@.Init.Control.Option.3400892149._hygCtx._hyg.5)) (fun {α._@.Init.Control.Option.3400892149._hygCtx._hyg.19 : Type.{u}} => OptionT.fail.{u, v} m inst._@.Init.Control.Option.3400892149._hygCtx._hyg.5 α._@.Init.Control.Option.3400892149._hygCtx._hyg.19) (fun {α._@.Init.Control.Option.3400892149._hygCtx._hyg.21 : Type.{u}} => OptionT.orElse.{u, v} m inst._@.Init.Control.Option.3400892149._hygCtx._hyg.5 α._@.Init.Control.Option.3400892149._hygCtx._hyg.21)
