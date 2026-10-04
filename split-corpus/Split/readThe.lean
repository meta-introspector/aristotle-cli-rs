import Mathlib

set_option pp.all true
-- spec: readThe : forall (ρ : Type.{u}) {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.2973599344._hygCtx._hyg.6 : MonadReaderOf.{u, v} ρ m], m ρ
def readThe : forall (ρ : Type.{u}) {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.2973599344._hygCtx._hyg.6 : MonadReaderOf.{u, v} ρ m], m ρ :=
  fun (ρ : Type.{u}) {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.2973599344._hygCtx._hyg.6 : MonadReaderOf.{u, v} ρ m] => MonadReaderOf.read.{u, v} ρ m inst._@.Init.Prelude.2973599344._hygCtx._hyg.6
