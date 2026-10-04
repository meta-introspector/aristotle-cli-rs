import Mathlib

set_option pp.all true
-- spec: List.ctorIdx : forall {α : Type.{u}}, (List.{u} α) -> Nat
def List.ctorIdx : forall {α : Type.{u}}, (List.{u} α) -> Nat :=
  fun {α : Type.{u}} (x : List.{u} α) => List.casesOn.{1, u} α (fun (x : List.{u} α) => Nat) x 0 (fun (head : α) (tail : List.{u} α) => 1)
