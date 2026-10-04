import Mathlib

set_option pp.all true
-- spec: tryCatchThe : forall (ε : Type.{u}) {m : Type.{v} -> Type.{w}} [inst._@.Init.Prelude.503235637._hygCtx._hyg.6 : MonadExceptOf.{u, v, w} ε m] {α : Type.{v}}, (m α) -> (ε -> (m α)) -> (m α)
def tryCatchThe : forall (ε : Type.{u}) {m : Type.{v} -> Type.{w}} [inst._@.Init.Prelude.503235637._hygCtx._hyg.6 : MonadExceptOf.{u, v, w} ε m] {α : Type.{v}}, (m α) -> (ε -> (m α)) -> (m α) :=
  fun (ε : Type.{u}) {m : Type.{v} -> Type.{w}} [inst._@.Init.Prelude.503235637._hygCtx._hyg.6 : MonadExceptOf.{u, v, w} ε m] {α : Type.{v}} (x : m α) (handle : ε -> (m α)) => MonadExceptOf.tryCatch.{u, v, w} ε m inst._@.Init.Prelude.503235637._hygCtx._hyg.6 α x handle
