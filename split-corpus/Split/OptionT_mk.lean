import Mathlib

set_option pp.all true
-- spec: OptionT.mk : forall {m : Type.{u} -> Type.{v}} {α : Type.{u}}, (m (Option.{u} α)) -> (OptionT.{u, v} m α)
def OptionT.mk : forall {m : Type.{u} -> Type.{v}} {α : Type.{u}}, (m (Option.{u} α)) -> (OptionT.{u, v} m α) :=
  fun {m : Type.{u} -> Type.{v}} {α : Type.{u}} (x : m (Option.{u} α)) => x
