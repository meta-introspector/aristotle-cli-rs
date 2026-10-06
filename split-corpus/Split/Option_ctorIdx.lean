import Mathlib

set_option pp.all true
-- spec: Option.ctorIdx : forall {α : Type.{u}}, (Option.{u} α) -> Nat
def Option.ctorIdx : forall {α : Type.{u}}, (Option.{u} α) -> Nat :=
  fun {α : Type.{u}} (x : Option.{u} α) => Option.casesOn.{1, u} α (fun (x : Option.{u} α) => Nat) x 0 (fun (val : α) => 1)
