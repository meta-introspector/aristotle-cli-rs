import Mathlib

set_option pp.all true
-- spec: ByteArray.empty : ByteArray
def ByteArray.empty : ByteArray :=
  ByteArray.emptyWithCapacity (OfNat.ofNat.{0} ([mdata borrowed:1 Nat]) 0 (instOfNatNat 0))
