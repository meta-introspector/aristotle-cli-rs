import Mathlib

set_option pp.all true
-- spec: USize.mod : USize -> USize -> USize
def USize.mod : USize -> USize -> USize :=
  fun (a : USize) (b : USize) => USize.ofBitVec (HMod.hMod.{0, 0, 0} (BitVec System.Platform.numBits) (BitVec System.Platform.numBits) (BitVec System.Platform.numBits) (instHMod.{0} (BitVec System.Platform.numBits) (BitVec.instMod System.Platform.numBits)) (USize.toBitVec a) (USize.toBitVec b))
