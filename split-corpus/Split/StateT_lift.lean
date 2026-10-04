import Mathlib

set_option pp.all true
-- spec: StateT.lift : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.1136412005._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}}, (m α) -> (StateT.{u, v} σ m α)
def StateT.lift : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.1136412005._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}}, (m α) -> (StateT.{u, v} σ m α) :=
  fun {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.1136412005._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}} (t : m α) (s : σ) => Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.State.1136412005._hygCtx._hyg.6) α (Prod.{u, u} α σ) t (fun (a : α) => Pure.pure.{u, v} m (Applicative.toPure.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.State.1136412005._hygCtx._hyg.6)) (Prod.{u, u} α σ) (Prod.mk.{u, u} α σ a s))
