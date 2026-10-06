import Mathlib

set_option pp.all true
-- spec: StateT.run : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} {α : Type.{u}}, (StateT.{u, v} σ m α) -> σ -> (m (Prod.{u, u} α σ))
def StateT.run : forall {σ : Type.{u}} {m : Type.{u} -> Type.{v}} {α : Type.{u}}, (StateT.{u, v} σ m α) -> σ -> (m (Prod.{u, u} α σ)) :=
  fun {σ : Type.{u}} {m : Type.{u} -> Type.{v}} {α : Type.{u}} (x : StateT.{u, v} σ m α) (s : σ) => x s
