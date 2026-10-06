import Mathlib

set_option pp.all true
-- spec: semiOutParam : Sort.{u} -> Sort.{u}
def semiOutParam : Sort.{u} -> Sort.{u} :=
  fun (α : Sort.{u}) => α
