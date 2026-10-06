import Mathlib

set_option pp.all true
-- spec: List.toArray : forall {α : Type.{u_1}}, (List.{u_1} α) -> (Array.{u_1} α)
def List.toArray : forall {α : Type.{u_1}}, (List.{u_1} α) -> (Array.{u_1} α) :=
  fun {α : Type.{u_1}} (xs : List.{u_1} α) => Array.mk.{u_1} α xs
