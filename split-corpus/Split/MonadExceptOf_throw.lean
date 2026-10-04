import Mathlib

set_option pp.all true
-- spec: MonadExceptOf.throw : forall {ε : semiOutParam.{succ (succ u)} Type.{u}} {m : Type.{v} -> Type.{w}} [self : MonadExceptOf.{u, v, w} ε m] {α : Type.{v}}, ε -> (m α)
def MonadExceptOf.throw : forall {ε : semiOutParam.{succ (succ u)} Type.{u}} {m : Type.{v} -> Type.{w}} [self : MonadExceptOf.{u, v, w} ε m] {α : Type.{v}}, ε -> (m α) :=
  fun (ε : semiOutParam.{succ (succ u)} Type.{u}) (m : Type.{v} -> Type.{w}) [self : MonadExceptOf.{u, v, w} ε m] => self.1
