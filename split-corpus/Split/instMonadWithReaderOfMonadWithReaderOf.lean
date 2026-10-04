import Mathlib

set_option pp.all true
-- spec: instMonadWithReaderOfMonadWithReaderOf : forall (ρ : Type.{u}) (m : Type.{u} -> Type.{v}) [inst._@.Init.Prelude.3036626064._hygCtx._hyg.6 : MonadWithReaderOf.{u, v} ρ m], MonadWithReader.{u, v} ρ m
def instMonadWithReaderOfMonadWithReaderOf : forall (ρ : Type.{u}) (m : Type.{u} -> Type.{v}) [inst._@.Init.Prelude.3036626064._hygCtx._hyg.6 : MonadWithReaderOf.{u, v} ρ m], MonadWithReader.{u, v} ρ m :=
  fun (ρ : Type.{u}) (m : Type.{u} -> Type.{v}) [inst._@.Init.Prelude.3036626064._hygCtx._hyg.6 : MonadWithReaderOf.{u, v} ρ m] => MonadWithReader.mk.{u, v} ρ m (fun {α._@.Init.Prelude.3036626064._hygCtx._hyg.17 : Type.{u}} => withTheReader.{u, v} ρ m inst._@.Init.Prelude.3036626064._hygCtx._hyg.6 α._@.Init.Prelude.3036626064._hygCtx._hyg.17)
