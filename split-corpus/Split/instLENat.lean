import Mathlib

set_option pp.all true
-- spec: instLENat : LE.{0} Nat
def instLENat : LE.{0} Nat :=
  LE.mk.{0} Nat Nat.le
