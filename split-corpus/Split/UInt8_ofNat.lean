import Mathlib

set_option pp.all true
-- spec: UInt8.ofNat : ([mdata borrowed:1 Nat]) -> UInt8
def UInt8.ofNat : ([mdata borrowed:1 Nat]) -> UInt8 :=
  fun (n : Nat) => UInt8.ofBitVec (BitVec.ofNat (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)) n)
