import Mathlib

set_option pp.all true
-- spec: Lean.MonadAlwaysExcept.except : forall {ε : outParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}} [self : Lean.MonadAlwaysExcept.{u, v} ε m], MonadExceptOf.{u, u, v} ε m
def Lean.MonadAlwaysExcept.except : forall {ε : outParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}} [self : Lean.MonadAlwaysExcept.{u, v} ε m], MonadExceptOf.{u, u, v} ε m :=
  fun {ε : outParam.{succ (succ u)} Type.{u}} (m : Type.{u} -> Type.{v}) [self : Lean.MonadAlwaysExcept.{u, v} ε m] => self.1
