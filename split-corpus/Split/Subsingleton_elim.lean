import Mathlib

-- spec: theorem Subsingleton.elim : forall {α : Sort.{u}} [h : Subsingleton.{u} α] (a : α) (b : α), Eq.{u} α a b
theorem Subsingleton.elim : forall {α : Sort.{u}} [h : Subsingleton.{u} α] (a : α) (b : α), Eq.{u} α a b :=
  fun {α : Sort.{u}} [h : Subsingleton.{u} α] => Subsingleton.allEq.{u} α h
