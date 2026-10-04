import Mathlib

-- spec: constructor MonadExcept.mk : forall {ε : outParam.{succ (succ u)} Type.{u}} {m : Type.{v} -> Type.{w}}, (forall {α : Type.{v}}, ε -> (m α)) -> (forall {α : Type.{v}}, (m α) -> (ε -> (m α)) -> (m α)) -> (MonadExcept.{u, v, w} ε m)
