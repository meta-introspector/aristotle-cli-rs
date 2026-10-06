import Mathlib

set_option pp.all true
-- spec: instMonadExceptOfMonadExceptOf : forall (ε : Type.{u}) (m : Type.{v} -> Type.{w}) [inst._@.Init.Prelude.52155161._hygCtx._hyg.6 : MonadExceptOf.{u, v, w} ε m], MonadExcept.{u, v, w} ε m
def instMonadExceptOfMonadExceptOf : forall (ε : Type.{u}) (m : Type.{v} -> Type.{w}) [inst._@.Init.Prelude.52155161._hygCtx._hyg.6 : MonadExceptOf.{u, v, w} ε m], MonadExcept.{u, v, w} ε m :=
  fun (ε : Type.{u}) (m : Type.{v} -> Type.{w}) [inst._@.Init.Prelude.52155161._hygCtx._hyg.6 : MonadExceptOf.{u, v, w} ε m] => MonadExcept.mk.{u, v, w} ε m (fun {α._@.Init.Prelude.52155161._hygCtx._hyg.17 : Type.{v}} => throwThe.{u, v, w} ε m inst._@.Init.Prelude.52155161._hygCtx._hyg.6 α._@.Init.Prelude.52155161._hygCtx._hyg.17) (fun {α._@.Init.Prelude.52155161._hygCtx._hyg.20 : Type.{v}} => tryCatchThe.{u, v, w} ε m inst._@.Init.Prelude.52155161._hygCtx._hyg.6 α._@.Init.Prelude.52155161._hygCtx._hyg.20)
