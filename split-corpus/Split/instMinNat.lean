import Mathlib

set_option pp.all true
-- spec: instMinNat : Min.{0} Nat
def instMinNat : Min.{0} Nat :=
  minOfLe.{0} Nat instLENat Nat.decLe
