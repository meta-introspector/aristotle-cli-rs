import Mathlib

set_option pp.all true
-- spec: StateT.pure : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.3537041524._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}}, α -> (StateT.{u, v} σ m α)
def StateT.pure : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.3537041524._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}}, α -> (StateT.{u, v} σ m α) :=
  fun {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.3537041524._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}} (a : α) (s : σ) => Pure.pure.{u, v} m (Applicative.toPure.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.State.3537041524._hygCtx._hyg.6)) (Prod.{u, u} α σ) (Prod.mk.{u, u} α σ a s)
