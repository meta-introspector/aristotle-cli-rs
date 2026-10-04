import Mathlib

set_option pp.all true
-- spec: ReaderT.instMonadLift : forall {ρ : Type.{u}} {m : Type.{u} -> Type.{v}}, MonadLift.{u, v, max u v} m (ReaderT.{u, v} ρ m)
def ReaderT.instMonadLift : forall {ρ : Type.{u}} {m : Type.{u} -> Type.{v}}, MonadLift.{u, v, max u v} m (ReaderT.{u, v} ρ m) :=
  fun {ρ : Type.{u}} {m : Type.{u} -> Type.{v}} => MonadLift.mk.{u, v, max u v} m (ReaderT.{u, v} ρ m) (fun {α._@.Init.Prelude.3582836318._hygCtx._hyg.21 : Type.{u}} (x : m α._@.Init.Prelude.3582836318._hygCtx._hyg.21) (x._@.Init.Prelude.3582836318._hygCtx._hyg.25 : ρ) => x)
