import Mathlib

set_option pp.all true
-- spec: decEq : forall {α : Sort.{u}} [inst : DecidableEq.{u} α] (a : α) (b : α), Decidable (Eq.{u} α a b)
def decEq : forall {α : Sort.{u}} [inst : DecidableEq.{u} α] (a : α) (b : α), Decidable (Eq.{u} α a b) :=
  fun {α : Sort.{u}} [inst : DecidableEq.{u} α] (a : α) (b : α) => inst a b
