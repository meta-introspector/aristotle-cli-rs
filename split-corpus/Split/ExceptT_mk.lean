import Mathlib

set_option pp.all true
-- spec: ExceptT.mk : forall {ε : Type.{u}} {m : Type.{u} -> Type.{v}} {α : Type.{u}}, (m (Except.{u, u} ε α)) -> (ExceptT.{u, v} ε m α)
def ExceptT.mk : forall {ε : Type.{u}} {m : Type.{u} -> Type.{v}} {α : Type.{u}}, (m (Except.{u, u} ε α)) -> (ExceptT.{u, v} ε m α) :=
  fun {ε : Type.{u}} {m : Type.{u} -> Type.{v}} {α : Type.{u}} (x : m (Except.{u, u} ε α)) => x
