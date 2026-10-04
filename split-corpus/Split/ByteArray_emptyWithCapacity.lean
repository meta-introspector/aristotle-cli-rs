import Mathlib

set_option pp.all true
-- spec: ByteArray.emptyWithCapacity : ([mdata borrowed:1 Nat]) -> ByteArray
def ByteArray.emptyWithCapacity : ([mdata borrowed:1 Nat]) -> ByteArray :=
  fun (c : Nat) => ByteArray.mk (Array.empty.{0} UInt8)
