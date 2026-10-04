import Mathlib

set_option pp.all true
-- spec: UInt64.toUSize : UInt64 -> USize
def UInt64.toUSize : UInt64 -> USize :=
  fun (a : UInt64) => Nat.toUSize (UInt64.toNat a)
