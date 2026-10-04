import Mathlib

set_option pp.all true
-- spec: DecidableEq : Sort.{u} -> Sort.{max 1 u}
def DecidableEq : Sort.{u} -> Sort.{max 1 u} :=
  fun (α : Sort.{u}) => forall (a : α) (b : α), Decidable (Eq.{u} α a b)
