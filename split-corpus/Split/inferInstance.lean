import Mathlib

set_option pp.all true
-- spec: inferInstance : forall {α : Sort.{u}} [i : α], α
def inferInstance : forall {α : Sort.{u}} [i : α], α :=
  fun {α : Sort.{u}} [i : α] => i
