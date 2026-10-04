import Mathlib

set_option pp.all true
-- spec: UInt64.toUInt8 : UInt64 -> UInt8
def UInt64.toUInt8 : UInt64 -> UInt8 :=
  fun (a : UInt64) => Nat.toUInt8 (UInt64.toNat a)
