import Mathlib

set_option pp.all true
-- spec: instMonadStateOfMonadStateOf : forall (σ : Type.{u}) (m : Type.{u} -> Type.{v}) [inst._@.Init.Prelude.3149178335._hygCtx._hyg.6 : MonadStateOf.{u, v} σ m], MonadState.{u, v} σ m
def instMonadStateOfMonadStateOf : forall (σ : Type.{u}) (m : Type.{u} -> Type.{v}) [inst._@.Init.Prelude.3149178335._hygCtx._hyg.6 : MonadStateOf.{u, v} σ m], MonadState.{u, v} σ m :=
  fun (σ : Type.{u}) (m : Type.{u} -> Type.{v}) [inst._@.Init.Prelude.3149178335._hygCtx._hyg.6 : MonadStateOf.{u, v} σ m] => MonadState.mk.{u, v} σ m (getThe.{u, v} σ m inst._@.Init.Prelude.3149178335._hygCtx._hyg.6) (MonadStateOf.set.{u, v} σ m inst._@.Init.Prelude.3149178335._hygCtx._hyg.6) (fun {α._@.Init.Prelude.3149178335._hygCtx._hyg.23 : Type.{u}} (f : σ -> (Prod.{u, u} α._@.Init.Prelude.3149178335._hygCtx._hyg.23 σ)) => MonadStateOf.modifyGet.{u, v} σ m inst._@.Init.Prelude.3149178335._hygCtx._hyg.6 α._@.Init.Prelude.3149178335._hygCtx._hyg.23 f)
