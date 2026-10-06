import Mathlib

set_option pp.all true
-- spec: MonadExceptOf.tryCatch : forall {ε : semiOutParam.{succ (succ u)} Type.{u}} {m : Type.{v} -> Type.{w}} [self : MonadExceptOf.{u, v, w} ε m] {α : Type.{v}}, (m α) -> (ε -> (m α)) -> (m α)
def MonadExceptOf.tryCatch : forall {ε : semiOutParam.{succ (succ u)} Type.{u}} {m : Type.{v} -> Type.{w}} [self : MonadExceptOf.{u, v, w} ε m] {α : Type.{v}}, (m α) -> (ε -> (m α)) -> (m α) :=
  fun (ε : semiOutParam.{succ (succ u)} Type.{u}) (m : Type.{v} -> Type.{w}) [self : MonadExceptOf.{u, v, w} ε m] => self.2
