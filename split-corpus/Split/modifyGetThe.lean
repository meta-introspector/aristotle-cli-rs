import Mathlib

set_option pp.all true
-- spec: modifyGetThe : forall {α : Type.{u}} (σ : Type.{u}) {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.2863252478._hygCtx._hyg.7 : MonadStateOf.{u, v} σ m], (σ -> (Prod.{u, u} α σ)) -> (m α)
def modifyGetThe : forall {α : Type.{u}} (σ : Type.{u}) {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.2863252478._hygCtx._hyg.7 : MonadStateOf.{u, v} σ m], (σ -> (Prod.{u, u} α σ)) -> (m α) :=
  fun {α : Type.{u}} (σ : Type.{u}) {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.2863252478._hygCtx._hyg.7 : MonadStateOf.{u, v} σ m] (f : σ -> (Prod.{u, u} α σ)) => MonadStateOf.modifyGet.{u, v} σ m inst._@.Init.Prelude.2863252478._hygCtx._hyg.7 α f
