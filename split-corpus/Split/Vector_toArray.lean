import Mathlib

set_option pp.all true
-- spec: Vector.toArray : forall {α : Type.{u}} {n : Nat}, (Vector.{u} α n) -> (Array.{u} α)
def Vector.toArray : forall {α : Type.{u}} {n : Nat}, (Vector.{u} α n) -> (Array.{u} α) :=
  fun (α : Type.{u}) (n : Nat) (self : Vector.{u} α n) => self.1
