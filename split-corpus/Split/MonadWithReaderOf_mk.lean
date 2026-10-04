import Mathlib

-- spec: constructor MonadWithReaderOf.mk : forall {ρ : semiOutParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}}, (forall {α : Type.{u}}, (ρ -> ρ) -> (m α) -> (m α)) -> (MonadWithReaderOf.{u, v} ρ m)
