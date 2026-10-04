import Mathlib

set_option pp.all true
-- spec: MonadExcept.throw : forall {ε : outParam.{succ (succ u)} Type.{u}} {m : Type.{v} -> Type.{w}} [self : MonadExcept.{u, v, w} ε m] {α : Type.{v}}, ε -> (m α)
def MonadExcept.throw : forall {ε : outParam.{succ (succ u)} Type.{u}} {m : Type.{v} -> Type.{w}} [self : MonadExcept.{u, v, w} ε m] {α : Type.{v}}, ε -> (m α) :=
  fun {ε : outParam.{succ (succ u)} Type.{u}} (m : Type.{v} -> Type.{w}) [self : MonadExcept.{u, v, w} ε m] => self.1
