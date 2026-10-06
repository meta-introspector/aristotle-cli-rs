import Mathlib

set_option pp.all true
-- spec: Array.pop : forall {α : Type.{u}}, (Array.{u} α) -> (Array.{u} α)
def Array.pop : forall {α : Type.{u}}, (Array.{u} α) -> (Array.{u} α) :=
  fun {α : Type.{u}} (xs : Array.{u} α) => Array.mk.{u} α (List.dropLast.{u} α (Array.toList.{u} α xs))
