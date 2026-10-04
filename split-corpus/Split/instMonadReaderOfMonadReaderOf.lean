import Mathlib

set_option pp.all true
-- spec: instMonadReaderOfMonadReaderOf : forall (ρ : Type.{u}) (m : Type.{u} -> Type.{v}) [inst._@.Init.Prelude.789035139._hygCtx._hyg.6 : MonadReaderOf.{u, v} ρ m], MonadReader.{u, v} ρ m
def instMonadReaderOfMonadReaderOf : forall (ρ : Type.{u}) (m : Type.{u} -> Type.{v}) [inst._@.Init.Prelude.789035139._hygCtx._hyg.6 : MonadReaderOf.{u, v} ρ m], MonadReader.{u, v} ρ m :=
  fun (ρ : Type.{u}) (m : Type.{u} -> Type.{v}) [inst._@.Init.Prelude.789035139._hygCtx._hyg.6 : MonadReaderOf.{u, v} ρ m] => MonadReader.mk.{u, v} ρ m (readThe.{u, v} ρ m inst._@.Init.Prelude.789035139._hygCtx._hyg.6)
