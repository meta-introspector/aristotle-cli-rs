import Mathlib

set_option pp.all true
-- spec: instLTNat : LT.{0} Nat
def instLTNat : LT.{0} Nat :=
  LT.mk.{0} Nat Nat.lt
