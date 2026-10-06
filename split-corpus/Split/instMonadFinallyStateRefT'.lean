import Mathlib

set_option pp.all true
-- spec: instMonadFinallyStateRefT' : forall {m : Type -> Type} {ω : Type} {σ : Type} [inst._@.Init.Control.StateRef.720895113._hygCtx._hyg.7 : MonadFinally.{0, 0} m], MonadFinally.{0, 0} (StateRefT' ω σ m)
def instMonadFinallyStateRefT' : forall {m : Type -> Type} {ω : Type} {σ : Type} [inst._@.Init.Control.StateRef.720895113._hygCtx._hyg.7 : MonadFinally.{0, 0} m], MonadFinally.{0, 0} (StateRefT' ω σ m) :=
  fun {m : Type -> Type} {ω : Type} {σ : Type} [inst._@.Init.Control.StateRef.720895113._hygCtx._hyg.7 : MonadFinally.{0, 0} m] => MonadFinally.mk.{0, 0} (StateRefT' ω σ m) (instMonadFinallyStateRefT'._aux_1 m ω σ inst._@.Init.Control.StateRef.720895113._hygCtx._hyg.7)
