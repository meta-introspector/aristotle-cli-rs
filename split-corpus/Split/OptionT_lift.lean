import Mathlib

set_option pp.all true
-- spec: OptionT.lift : forall {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Option.1136412005._hygCtx._hyg.5 : Monad.{u, v} m] {α : Type.{u}}, (m α) -> (OptionT.{u, v} m α)
def OptionT.lift : forall {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Option.1136412005._hygCtx._hyg.5 : Monad.{u, v} m] {α : Type.{u}}, (m α) -> (OptionT.{u, v} m α) :=
  fun {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Option.1136412005._hygCtx._hyg.5 : Monad.{u, v} m] {α : Type.{u}} (x : m α) => OptionT.mk.{u, v} m α (Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Option.1136412005._hygCtx._hyg.5) α (Option.{u} α) x (fun (__do_lift._@.Init.Control.Option.1136412005._hygCtx._hyg.21.0 : α) => Pure.pure.{u, v} m (Applicative.toPure.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Option.1136412005._hygCtx._hyg.5)) (Option.{u} α) (Option.some.{u} α __do_lift._@.Init.Control.Option.1136412005._hygCtx._hyg.21.0)))
