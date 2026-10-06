import Mathlib

set_option pp.all true
-- spec: UInt64.toUInt32 : UInt64 -> UInt32
def UInt64.toUInt32 : UInt64 -> UInt32 :=
  fun (a : UInt64) => Nat.toUInt32 (UInt64.toNat a)
