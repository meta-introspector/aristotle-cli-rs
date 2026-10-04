import Mathlib

set_option pp.all true
-- spec: instMonadReaderOfReaderTOfMonad : forall {ρ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.760536839._hygCtx._hyg.6 : Monad.{u, v} m], MonadReaderOf.{u, max u v} ρ (ReaderT.{u, v} ρ m)
def instMonadReaderOfReaderTOfMonad : forall {ρ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.760536839._hygCtx._hyg.6 : Monad.{u, v} m], MonadReaderOf.{u, max u v} ρ (ReaderT.{u, v} ρ m) :=
  fun {ρ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.760536839._hygCtx._hyg.6 : Monad.{u, v} m] => MonadReaderOf.mk.{u, max u v} ρ (ReaderT.{u, v} ρ m) (ReaderT.read.{u, v} ρ m inst._@.Init.Prelude.760536839._hygCtx._hyg.6)
