import Mathlib

set_option pp.all true
-- spec: Nat.toUInt8 : ([mdata borrowed:1 Nat]) -> UInt8
def Nat.toUInt8 : ([mdata borrowed:1 Nat]) -> UInt8 :=
  UInt8.ofNat
