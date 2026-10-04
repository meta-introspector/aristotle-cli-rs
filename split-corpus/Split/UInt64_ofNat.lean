import Mathlib

set_option pp.all true
-- spec: UInt64.ofNat : ([mdata borrowed:1 Nat]) -> UInt64
def UInt64.ofNat : ([mdata borrowed:1 Nat]) -> UInt64 :=
  fun (n : Nat) => UInt64.ofBitVec (BitVec.ofNat (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64)) n)
