import Mathlib

set_option pp.all true
-- spec: Nat.toUSize : ([mdata borrowed:1 Nat]) -> USize
def Nat.toUSize : ([mdata borrowed:1 Nat]) -> USize :=
  USize.ofNat
