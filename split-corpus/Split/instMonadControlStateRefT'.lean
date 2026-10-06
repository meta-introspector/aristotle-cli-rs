import Mathlib

set_option pp.all true
-- spec: instMonadControlStateRefT' : forall (ω : Type) (σ : Type) (m : Type -> Type), MonadControl.{0, 0, 0} m (StateRefT' ω σ m)
def instMonadControlStateRefT' : forall (ω : Type) (σ : Type) (m : Type -> Type), MonadControl.{0, 0, 0} m (StateRefT' ω σ m) :=
  fun (ω : Type) (σ : Type) (m : Type -> Type) => MonadControl.mk.{0, 0, 0} m (StateRefT' ω σ m) (id.{2} Type) (instMonadControlStateRefT'._aux_1 ω σ m) (instMonadControlStateRefT'._aux_3 ω σ m)
