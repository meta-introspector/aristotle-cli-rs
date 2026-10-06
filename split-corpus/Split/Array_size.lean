import Mathlib

set_option pp.all true
-- spec: Array.size : forall {α : Type.{u}}, ([mdata borrowed:1 Array.{u} α]) -> Nat
def Array.size : forall {α : Type.{u}}, ([mdata borrowed:1 Array.{u} α]) -> Nat :=
  fun {α : Type.{u}} (a : Array.{u} α) => List.length.{u} α (Array.toList.{u} α a)
