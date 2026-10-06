import Mathlib

set_option pp.all true
-- spec: instDecidableEqNat : DecidableEq.{1} Nat
def instDecidableEqNat : DecidableEq.{1} Nat :=
  Nat.decEq
