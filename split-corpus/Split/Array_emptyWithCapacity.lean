import Mathlib

set_option pp.all true
-- spec: Array.emptyWithCapacity : forall {α : Type.{u}}, ([mdata borrowed:1 Nat]) -> (Array.{u} α)
def Array.emptyWithCapacity : forall {α : Type.{u}}, ([mdata borrowed:1 Nat]) -> (Array.{u} α) :=
  fun {α : Type.{u}} (c : Nat) => Array.mk.{u} α (List.nil.{u} α)
