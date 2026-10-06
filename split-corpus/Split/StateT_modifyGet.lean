import Mathlib

set_option pp.all true
-- spec: StateT.modifyGet : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.2882318218._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}}, (σ -> (Prod.{u, u} α σ)) -> (StateT.{u, v} σ m α)
def StateT.modifyGet : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.2882318218._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}}, (σ -> (Prod.{u, u} α σ)) -> (StateT.{u, v} σ m α) :=
  fun {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.2882318218._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}} (f : σ -> (Prod.{u, u} α σ)) (s : σ) => Pure.pure.{u, v} m (Applicative.toPure.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.State.2882318218._hygCtx._hyg.6)) (Prod.{u, u} α σ) (f s)
