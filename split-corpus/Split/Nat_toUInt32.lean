import Mathlib

set_option pp.all true
-- spec: Nat.toUInt32 : ([mdata borrowed:1 Nat]) -> UInt32
def Nat.toUInt32 : ([mdata borrowed:1 Nat]) -> UInt32 :=
  UInt32.ofNat
