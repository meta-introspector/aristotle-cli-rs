import Mathlib

-- spec: constructor MonadStateOf.mk : forall {σ : semiOutParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}}, (m σ) -> (σ -> (m PUnit.{succ u})) -> (forall {α : Type.{u}}, (σ -> (Prod.{u, u} α σ)) -> (m α)) -> (MonadStateOf.{u, v} σ m)
