import Mathlib

set_option pp.all true
-- spec: optParam : forall (α : Sort.{u}), α -> Sort.{u}
def optParam : forall (α : Sort.{u}), α -> Sort.{u} :=
  fun (α : Sort.{u}) (default : α) => α
