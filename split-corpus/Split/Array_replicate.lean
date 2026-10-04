import Mathlib

set_option pp.all true
-- spec: Array.replicate : forall {α : Type.{u}}, Nat -> α -> (Array.{u} α)
def Array.replicate : forall {α : Type.{u}}, Nat -> α -> (Array.{u} α) :=
  fun {α : Type.{u}} (n : Nat) (v : α) => Array.mk.{u} α (List.replicate.{u} α n v)
