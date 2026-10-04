import Mathlib

set_option pp.all true
-- spec: instAddNat : Add.{0} Nat
def instAddNat : Add.{0} Nat :=
  Add.mk.{0} Nat Nat.add
