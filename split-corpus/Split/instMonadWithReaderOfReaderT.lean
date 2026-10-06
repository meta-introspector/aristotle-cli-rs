import Mathlib

set_option pp.all true
-- spec: instMonadWithReaderOfReaderT : forall {ρ : Type.{u}} {m : Type.{u} -> Type.{v}}, MonadWithReaderOf.{u, max u v} ρ (ReaderT.{u, v} ρ m)
def instMonadWithReaderOfReaderT : forall {ρ : Type.{u}} {m : Type.{u} -> Type.{v}}, MonadWithReaderOf.{u, max u v} ρ (ReaderT.{u, v} ρ m) :=
  fun {ρ : Type.{u}} {m : Type.{u} -> Type.{v}} => MonadWithReaderOf.mk.{u, max u v} ρ (ReaderT.{u, v} ρ m) (fun {α._@.Init.Prelude.2478542205._hygCtx._hyg.20 : Type.{u}} (f : ρ -> ρ) (x : ReaderT.{u, v} ρ m α._@.Init.Prelude.2478542205._hygCtx._hyg.20) (ctx : ρ) => x (f ctx))
