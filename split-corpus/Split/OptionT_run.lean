import Mathlib

set_option pp.all true
-- spec: OptionT.run : forall {m : Type.{u} -> Type.{v}} {α : Type.{u}}, (OptionT.{u, v} m α) -> (m (Option.{u} α))
def OptionT.run : forall {m : Type.{u} -> Type.{v}} {α : Type.{u}}, (OptionT.{u, v} m α) -> (m (Option.{u} α)) :=
  fun {m : Type.{u} -> Type.{v}} {α : Type.{u}} (x : OptionT.{u, v} m α) => x
