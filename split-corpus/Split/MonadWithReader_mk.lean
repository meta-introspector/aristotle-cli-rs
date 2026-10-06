import Mathlib

-- spec: constructor MonadWithReader.mk : forall {ρ : outParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}}, (forall {α : Type.{u}}, (ρ -> ρ) -> (m α) -> (m α)) -> (MonadWithReader.{u, v} ρ m)
