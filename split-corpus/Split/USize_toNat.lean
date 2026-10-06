import Mathlib

set_option pp.all true
-- spec: USize.toNat : USize -> Nat
def USize.toNat : USize -> Nat :=
  fun (n : USize) => BitVec.toNat System.Platform.numBits (USize.toBitVec n)
