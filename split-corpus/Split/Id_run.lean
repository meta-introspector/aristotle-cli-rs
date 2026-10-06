import Mathlib

set_option pp.all true
-- spec: Id.run : forall {α : Type.{u_1}}, (Id.{u_1} α) -> α
def Id.run : forall {α : Type.{u_1}}, (Id.{u_1} α) -> α :=
  fun {α : Type.{u_1}} (x : Id.{u_1} α) => x
