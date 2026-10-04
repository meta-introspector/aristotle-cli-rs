import Mathlib

set_option pp.all true
-- spec: OptionT.fail : forall {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Option.1380489474._hygCtx._hyg.5 : Monad.{u, v} m] {α : Type.{u}}, OptionT.{u, v} m α
def OptionT.fail : forall {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Option.1380489474._hygCtx._hyg.5 : Monad.{u, v} m] {α : Type.{u}}, OptionT.{u, v} m α :=
  fun {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Option.1380489474._hygCtx._hyg.5 : Monad.{u, v} m] {α : Type.{u}} => OptionT.mk.{u, v} m α (Pure.pure.{u, v} m (Applicative.toPure.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Option.1380489474._hygCtx._hyg.5)) (Option.{u} α) (Option.none.{u} α))
