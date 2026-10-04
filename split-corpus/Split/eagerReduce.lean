import Mathlib

set_option pp.all true
-- spec: eagerReduce : forall {α : Sort.{u}}, α -> α
def eagerReduce : forall {α : Sort.{u}}, α -> α :=
  fun {α : Sort.{u}} (a : α) => a
