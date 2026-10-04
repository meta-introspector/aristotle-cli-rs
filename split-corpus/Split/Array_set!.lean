import Mathlib

set_option pp.all true
-- spec: Array.set! : forall {α : Type.{u_1}}, (Array.{u_1} α) -> ([mdata borrowed:1 Nat]) -> α -> (Array.{u_1} α)
def Array.set! : forall {α : Type.{u_1}}, (Array.{u_1} α) -> ([mdata borrowed:1 Nat]) -> α -> (Array.{u_1} α) :=
  fun {α : Type.{u_1}} (xs : Array.{u_1} α) (i : Nat) (v : α) => Array.setIfInBounds.{u_1} α xs i v
