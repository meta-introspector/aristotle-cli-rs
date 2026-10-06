import Mathlib

set_option pp.all true
-- spec: UInt32.isValidChar : UInt32 -> Prop
def UInt32.isValidChar : UInt32 -> Prop :=
  fun (n : UInt32) => Nat.isValidChar (UInt32.toNat n)
