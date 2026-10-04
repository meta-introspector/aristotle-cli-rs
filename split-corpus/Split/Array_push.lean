import Mathlib

set_option pp.all true
-- spec: Array.push : forall {α : Type.{u}}, (Array.{u} α) -> α -> (Array.{u} α)
def Array.push : forall {α : Type.{u}}, (Array.{u} α) -> α -> (Array.{u} α) :=
  fun {α : Type.{u}} (a : Array.{u} α) (v : α) => Array.mk.{u} α (List.concat.{u} α (Array.toList.{u} α a) v)
