import Mathlib

set_option pp.all true
-- spec: StateT.failure : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.3608778682._hygCtx._hyg.11 : Alternative.{u, v} m] {α : Type.{u}}, StateT.{u, v} σ m α
def StateT.failure : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.3608778682._hygCtx._hyg.11 : Alternative.{u, v} m] {α : Type.{u}}, StateT.{u, v} σ m α :=
  fun {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.3608778682._hygCtx._hyg.11 : Alternative.{u, v} m] {α : Type.{u}} (x._@.Init.Control.State.3608778682._hygCtx._hyg.21 : σ) => Alternative.failure.{u, v} m inst._@.Init.Control.State.3608778682._hygCtx._hyg.11 (Prod.{u, u} α σ)
