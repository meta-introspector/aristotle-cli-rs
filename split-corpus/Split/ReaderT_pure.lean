import Mathlib

set_option pp.all true
-- spec: ReaderT.pure : forall {ρ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.3537041524._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}}, α -> (ReaderT.{u, v} ρ m α)
def ReaderT.pure : forall {ρ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.3537041524._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}}, α -> (ReaderT.{u, v} ρ m α) :=
  fun {ρ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.3537041524._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}} (a : α) (x._@.Init.Prelude.3537041524._hygCtx._hyg.17 : ρ) => Pure.pure.{u, v} m (Applicative.toPure.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Prelude.3537041524._hygCtx._hyg.6)) α a
