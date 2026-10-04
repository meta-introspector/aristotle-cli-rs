import Mathlib

set_option pp.all true
-- spec: StateRefT'.instMonadFunctor : forall {ω : Type} (σ : Type) (m : Type -> Type), MonadFunctor.{0, 0, 0} m (StateRefT' ω σ m)
def StateRefT'.instMonadFunctor : forall {ω : Type} (σ : Type) (m : Type -> Type), MonadFunctor.{0, 0, 0} m (StateRefT' ω σ m) :=
  fun {ω : Type} (σ : Type) (m : Type -> Type) => MonadFunctor.mk.{0, 0, 0} m (StateRefT' ω σ m) (StateRefT'.instMonadFunctor._aux_1 ω σ m)
