import Mathlib

set_option pp.all true
-- spec: StateT.get : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.1017806716._hygCtx._hyg.6 : Monad.{u, v} m], StateT.{u, v} σ m σ
def StateT.get : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.1017806716._hygCtx._hyg.6 : Monad.{u, v} m], StateT.{u, v} σ m σ :=
  fun {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.1017806716._hygCtx._hyg.6 : Monad.{u, v} m] (s : σ) => Pure.pure.{u, v} m (Applicative.toPure.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.State.1017806716._hygCtx._hyg.6)) (Prod.{u, u} σ σ) (Prod.mk.{u, u} σ σ s s)
