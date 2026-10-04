import Mathlib

set_option pp.all true
-- spec: StateRefT'.instMonadLift : forall {ω : Type} {σ : Type} {m : Type -> Type}, MonadLift.{0, 0, 0} m (StateRefT' ω σ m)
def StateRefT'.instMonadLift : forall {ω : Type} {σ : Type} {m : Type -> Type}, MonadLift.{0, 0, 0} m (StateRefT' ω σ m) :=
  fun {ω : Type} {σ : Type} {m : Type -> Type} => MonadLift.mk.{0, 0, 0} m (StateRefT' ω σ m) (fun {α._@.Init.Control.StateRef.3582836318._hygCtx._hyg.19 : Type} => StateRefT'.lift ω σ m α._@.Init.Control.StateRef.3582836318._hygCtx._hyg.19)
