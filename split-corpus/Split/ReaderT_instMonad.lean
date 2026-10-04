import Mathlib

set_option pp.all true
-- spec: ReaderT.instMonad : forall {ρ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.2690324045._hygCtx._hyg.6 : Monad.{u, v} m], Monad.{u, max v u} (ReaderT.{u, v} ρ m)
def ReaderT.instMonad : forall {ρ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.2690324045._hygCtx._hyg.6 : Monad.{u, v} m], Monad.{u, max v u} (ReaderT.{u, v} ρ m) :=
  fun {ρ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.2690324045._hygCtx._hyg.6 : Monad.{u, v} m] => Monad.mk.{u, max u v} (ReaderT.{u, v} ρ m) (ReaderT.instApplicativeOfMonad.{u, v} ρ m inst._@.Init.Prelude.2690324045._hygCtx._hyg.6) (Bind.mk.{u, max u v} (ReaderT.{u, v} ρ m) (fun {α._@.Init.Prelude.2690324045._hygCtx._hyg.19 : Type.{u}} {β._@.Init.Prelude.2690324045._hygCtx._hyg.20 : Type.{u}} => ReaderT.bind.{u, v} ρ m inst._@.Init.Prelude.2690324045._hygCtx._hyg.6 α._@.Init.Prelude.2690324045._hygCtx._hyg.19 β._@.Init.Prelude.2690324045._hygCtx._hyg.20))
