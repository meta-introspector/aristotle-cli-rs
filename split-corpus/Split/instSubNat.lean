import Mathlib

set_option pp.all true
-- spec: instSubNat : Sub.{0} Nat
def instSubNat : Sub.{0} Nat :=
  Sub.mk.{0} Nat Nat.sub
