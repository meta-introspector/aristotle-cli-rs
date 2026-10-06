import Mathlib

set_option pp.all true
-- spec: StateT.set : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.3103831426._hygCtx._hyg.6 : Monad.{u, v} m], σ -> (StateT.{u, v} σ m PUnit.{succ u})
def StateT.set : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.3103831426._hygCtx._hyg.6 : Monad.{u, v} m], σ -> (StateT.{u, v} σ m PUnit.{succ u}) :=
  fun {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.3103831426._hygCtx._hyg.6 : Monad.{u, v} m] (s' : σ) (x._@.Init.Control.State.3103831426._hygCtx._hyg.20 : σ) => Pure.pure.{u, v} m (Applicative.toPure.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.State.3103831426._hygCtx._hyg.6)) (Prod.{u, u} PUnit.{succ u} σ) (Prod.mk.{u, u} PUnit.{succ u} σ PUnit.unit.{succ u} s')
