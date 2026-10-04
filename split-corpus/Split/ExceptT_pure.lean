import Mathlib

set_option pp.all true
-- spec: ExceptT.pure : forall {ε : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Except.3537041525._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}}, α -> (ExceptT.{u, v} ε m α)
def ExceptT.pure : forall {ε : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Except.3537041525._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}}, α -> (ExceptT.{u, v} ε m α) :=
  fun {ε : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Except.3537041525._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}} (a : α) => ExceptT.mk.{u, v} ε m α (Pure.pure.{u, v} m (Applicative.toPure.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Except.3537041525._hygCtx._hyg.6)) (Except.{u, u} ε α) (Except.ok.{u, u} ε α a))
