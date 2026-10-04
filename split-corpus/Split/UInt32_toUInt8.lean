import Mathlib

set_option pp.all true
-- spec: UInt32.toUInt8 : UInt32 -> UInt8
def UInt32.toUInt8 : UInt32 -> UInt8 :=
  fun (a : UInt32) => Nat.toUInt8 (UInt32.toNat a)
