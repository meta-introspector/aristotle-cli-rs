import Mathlib

set_option pp.all true
-- spec: id : forall {α : Sort.{u}}, α -> α
def id : forall {α : Sort.{u}}, α -> α :=
  fun {α : Sort.{u}} (a : α) => a
