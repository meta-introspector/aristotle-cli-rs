import Mathlib

set_option pp.all true
-- spec: List.instAppend : forall {α : Type.{u}}, Append.{u} (List.{u} α)
def List.instAppend : forall {α : Type.{u}}, Append.{u} (List.{u} α) :=
  fun {α : Type.{u}} => Append.mk.{u} (List.{u} α) (List.append.{u} α)
