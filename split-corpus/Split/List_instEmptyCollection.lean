import Mathlib

set_option pp.all true
-- spec: List.instEmptyCollection : forall {α : Type.{u}}, EmptyCollection.{u} (List.{u} α)
def List.instEmptyCollection : forall {α : Type.{u}}, EmptyCollection.{u} (List.{u} α) :=
  fun {α : Type.{u}} => EmptyCollection.mk.{u} (List.{u} α) (List.nil.{u} α)
