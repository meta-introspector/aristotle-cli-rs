import Mathlib

set_option pp.all true
-- spec: Nat.toUInt64 : ([mdata borrowed:1 Nat]) -> UInt64
def Nat.toUInt64 : ([mdata borrowed:1 Nat]) -> UInt64 :=
  UInt64.ofNat
