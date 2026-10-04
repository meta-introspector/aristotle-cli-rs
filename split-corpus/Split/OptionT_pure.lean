import Mathlib

set_option pp.all true
-- spec: OptionT.pure : forall {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Option.3537041524._hygCtx._hyg.5 : Monad.{u, v} m] {α : Type.{u}}, α -> (OptionT.{u, v} m α)
def OptionT.pure : forall {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Option.3537041524._hygCtx._hyg.5 : Monad.{u, v} m] {α : Type.{u}}, α -> (OptionT.{u, v} m α) :=
  fun {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Option.3537041524._hygCtx._hyg.5 : Monad.{u, v} m] {α : Type.{u}} (a : α) => OptionT.mk.{u, v} m α (Pure.pure.{u, v} m (Applicative.toPure.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Option.3537041524._hygCtx._hyg.5)) (Option.{u} α) (Option.some.{u} α a))
