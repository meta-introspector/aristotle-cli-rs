import Mathlib

set_option pp.all true
-- spec: Array.instAppend : forall {α : Type.{u}}, Append.{u} (Array.{u} α)
def Array.instAppend : forall {α : Type.{u}}, Append.{u} (Array.{u} α) :=
  fun {α : Type.{u}} => Append.mk.{u} (Array.{u} α) (Array.append.{u} α)
