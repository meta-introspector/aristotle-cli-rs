import Mathlib

set_option pp.all true
-- spec: UInt32.ofNat : ([mdata borrowed:1 Nat]) -> UInt32
def UInt32.ofNat : ([mdata borrowed:1 Nat]) -> UInt32 :=
  fun (n : Nat) => UInt32.ofBitVec (BitVec.ofNat (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32)) n)
