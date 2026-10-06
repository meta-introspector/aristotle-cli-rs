import Mathlib

set_option pp.all true
-- spec: outParam : Sort.{u} -> Sort.{u}
def outParam : Sort.{u} -> Sort.{u} :=
  fun (α : Sort.{u}) => α
