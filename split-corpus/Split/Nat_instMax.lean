import Mathlib

set_option pp.all true
-- spec: Nat.instMax : Max.{0} Nat
def Nat.instMax : Max.{0} Nat :=
  maxOfLe.{0} Nat instLENat Nat.decLe
