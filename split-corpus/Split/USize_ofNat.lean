import Mathlib

set_option pp.all true
-- spec: USize.ofNat : ([mdata borrowed:1 Nat]) -> USize
def USize.ofNat : ([mdata borrowed:1 Nat]) -> USize :=
  fun (n : Nat) => USize.ofBitVec (BitVec.ofNat System.Platform.numBits n)
