import Mathlib

set_option pp.all true
-- spec: instToStringUInt32 : ToString.{0} UInt32
def instToStringUInt32 : ToString.{0} UInt32 :=
  ToString.mk.{0} UInt32 (fun (n : UInt32) => ToString.toString.{0} Nat instToStringNat (UInt32.toNat n))
