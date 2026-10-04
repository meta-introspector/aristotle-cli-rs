import Mathlib

set_option pp.all true
-- spec: StateT.run' : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.588610239._hygCtx._hyg.6 : Functor.{u, v} m] {α : Type.{u}}, (StateT.{u, v} σ m α) -> σ -> (m α)
def StateT.run' : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.588610239._hygCtx._hyg.6 : Functor.{u, v} m] {α : Type.{u}}, (StateT.{u, v} σ m α) -> σ -> (m α) :=
  fun {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.588610239._hygCtx._hyg.6 : Functor.{u, v} m] {α : Type.{u}} (x : StateT.{u, v} σ m α) (s : σ) => Functor.map.{u, v} m inst._@.Init.Control.State.588610239._hygCtx._hyg.6 (Prod.{u, u} α σ) α (fun (x._@.Init.Control.State.588610239._hygCtx._hyg.22 : Prod.{u, u} α σ) => Prod.fst.{u, u} α σ x._@.Init.Control.State.588610239._hygCtx._hyg.22) (x s)
