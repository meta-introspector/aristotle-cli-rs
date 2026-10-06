import Mathlib

-- spec: theorem Subsingleton.allEq : forall {α : Sort.{u}} [self : Subsingleton.{u} α] (a : α) (b : α), Eq.{u} α a b
theorem Subsingleton.allEq : forall {α : Sort.{u}} [self : Subsingleton.{u} α] (a : α) (b : α), Eq.{u} α a b :=
  fun (α : Sort.{u}) [self : Subsingleton.{u} α] => self.1
