import Mathlib

set_option pp.all true
-- spec: StateT.orElse : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.551632357._hygCtx._hyg.11 : Alternative.{u, v} m] {α : Type.{u}}, (StateT.{u, v} σ m α) -> (Unit -> (StateT.{u, v} σ m α)) -> (StateT.{u, v} σ m α)
def StateT.orElse : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.551632357._hygCtx._hyg.11 : Alternative.{u, v} m] {α : Type.{u}}, (StateT.{u, v} σ m α) -> (Unit -> (StateT.{u, v} σ m α)) -> (StateT.{u, v} σ m α) :=
  fun {σ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.State.551632357._hygCtx._hyg.11 : Alternative.{u, v} m] {α : Type.{u}} (x₁ : StateT.{u, v} σ m α) (x₂ : Unit -> (StateT.{u, v} σ m α)) (s : σ) => HOrElse.hOrElse.{v, v, v} (m (Prod.{u, u} α σ)) (m (Prod.{u, u} α σ)) (m (Prod.{u, u} α σ)) (instHOrElseOfOrElse.{v} (m (Prod.{u, u} α σ)) (instOrElseOfAlternative.{u, v} m (Prod.{u, u} α σ) inst._@.Init.Control.State.551632357._hygCtx._hyg.11)) (x₁ s) (fun (x._@.Init.Control.State.551632357._hygCtx._hyg.42 : Unit) => x₂ Unit.unit s)
