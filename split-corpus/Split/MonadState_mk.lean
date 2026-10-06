import Mathlib

-- spec: constructor MonadState.mk : forall {σ : outParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}}, (m σ) -> (σ -> (m PUnit.{succ u})) -> (forall {α : Type.{u}}, (σ -> (Prod.{u, u} α σ)) -> (m α)) -> (MonadState.{u, v} σ m)
