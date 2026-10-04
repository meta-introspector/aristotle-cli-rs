import Mathlib

set_option pp.all true
-- spec: MonadExcept.tryCatch : forall {ε : outParam.{succ (succ u)} Type.{u}} {m : Type.{v} -> Type.{w}} [self : MonadExcept.{u, v, w} ε m] {α : Type.{v}}, (m α) -> (ε -> (m α)) -> (m α)
def MonadExcept.tryCatch : forall {ε : outParam.{succ (succ u)} Type.{u}} {m : Type.{v} -> Type.{w}} [self : MonadExcept.{u, v, w} ε m] {α : Type.{v}}, (m α) -> (ε -> (m α)) -> (m α) :=
  fun {ε : outParam.{succ (succ u)} Type.{u}} (m : Type.{v} -> Type.{w}) [self : MonadExcept.{u, v, w} ε m] => self.2
