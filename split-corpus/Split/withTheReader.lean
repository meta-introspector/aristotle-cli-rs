import Mathlib

set_option pp.all true
-- spec: withTheReader : forall (ρ : Type.{u}) {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.3877089801._hygCtx._hyg.6 : MonadWithReaderOf.{u, v} ρ m] {α : Type.{u}}, (ρ -> ρ) -> (m α) -> (m α)
def withTheReader : forall (ρ : Type.{u}) {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.3877089801._hygCtx._hyg.6 : MonadWithReaderOf.{u, v} ρ m] {α : Type.{u}}, (ρ -> ρ) -> (m α) -> (m α) :=
  fun (ρ : Type.{u}) {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.3877089801._hygCtx._hyg.6 : MonadWithReaderOf.{u, v} ρ m] {α : Type.{u}} (f : ρ -> ρ) (x : m α) => MonadWithReaderOf.withReader.{u, v} ρ m inst._@.Init.Prelude.3877089801._hygCtx._hyg.6 α f x
