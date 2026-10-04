import Mathlib

set_option pp.all true
-- spec: List.reverse : forall {α : Type.{u}}, (List.{u} α) -> (List.{u} α)
def List.reverse : forall {α : Type.{u}}, (List.{u} α) -> (List.{u} α) :=
  fun {α : Type.{u}} (as : List.{u} α) => List.reverseAux.{u} α as (List.nil.{u} α)
