import Mathlib

set_option pp.all true
-- spec: Ne : forall {α : Sort.{u}}, α -> α -> Prop
def Ne : forall {α : Sort.{u}}, α -> α -> Prop :=
  fun {α : Sort.{u}} (a : α) (b : α) => Not (Eq.{u} α a b)
