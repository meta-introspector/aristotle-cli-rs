import Mathlib

set_option pp.all true
-- spec: modify : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.1101553765._hygCtx._hyg.6 : MonadState.{u, v} σ m], (σ -> σ) -> (m PUnit.{succ u})
def modify : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.1101553765._hygCtx._hyg.6 : MonadState.{u, v} σ m], (σ -> σ) -> (m PUnit.{succ u}) :=
  fun {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.1101553765._hygCtx._hyg.6 : MonadState.{u, v} σ m] (f : σ -> σ) => MonadState.modifyGet.{u, v} σ m inst._@.Init.Prelude.1101553765._hygCtx._hyg.6 PUnit.{succ u} (fun (s : σ) => Prod.mk.{u, u} PUnit.{succ u} σ PUnit.unit.{succ u} (f s))
