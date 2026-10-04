import Mathlib

set_option pp.all true
-- spec: getThe : forall (σ : Type.{u}) {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.4227333412._hygCtx._hyg.6 : MonadStateOf.{u, v} σ m], m σ
def getThe : forall (σ : Type.{u}) {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.4227333412._hygCtx._hyg.6 : MonadStateOf.{u, v} σ m], m σ :=
  fun (σ : Type.{u}) {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.4227333412._hygCtx._hyg.6 : MonadStateOf.{u, v} σ m] => MonadStateOf.get.{u, v} σ m inst._@.Init.Prelude.4227333412._hygCtx._hyg.6
