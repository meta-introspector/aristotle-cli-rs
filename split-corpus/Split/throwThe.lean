import Mathlib

set_option pp.all true
-- spec: throwThe : forall (ε : Type.{u}) {m : Type.{v} -> Type.{w}} [inst._@.Init.Prelude.1608417833._hygCtx._hyg.6 : MonadExceptOf.{u, v, w} ε m] {α : Type.{v}}, ε -> (m α)
def throwThe : forall (ε : Type.{u}) {m : Type.{v} -> Type.{w}} [inst._@.Init.Prelude.1608417833._hygCtx._hyg.6 : MonadExceptOf.{u, v, w} ε m] {α : Type.{v}}, ε -> (m α) :=
  fun (ε : Type.{u}) {m : Type.{v} -> Type.{w}} [inst._@.Init.Prelude.1608417833._hygCtx._hyg.6 : MonadExceptOf.{u, v, w} ε m] {α : Type.{v}} (e : ε) => MonadExceptOf.throw.{u, v, w} ε m inst._@.Init.Prelude.1608417833._hygCtx._hyg.6 α e
