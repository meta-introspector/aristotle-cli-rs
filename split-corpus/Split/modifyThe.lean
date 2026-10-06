import Mathlib

set_option pp.all true
-- spec: modifyThe : forall (σ : Type.{u}) {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.1481130008._hygCtx._hyg.6 : MonadStateOf.{u, v} σ m], (σ -> σ) -> (m PUnit.{succ u})
def modifyThe : forall (σ : Type.{u}) {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.1481130008._hygCtx._hyg.6 : MonadStateOf.{u, v} σ m], (σ -> σ) -> (m PUnit.{succ u}) :=
  fun (σ : Type.{u}) {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.1481130008._hygCtx._hyg.6 : MonadStateOf.{u, v} σ m] (f : σ -> σ) => MonadStateOf.modifyGet.{u, v} σ m inst._@.Init.Prelude.1481130008._hygCtx._hyg.6 PUnit.{succ u} (fun (s : σ) => Prod.mk.{u, u} PUnit.{succ u} σ PUnit.unit.{succ u} (f s))
