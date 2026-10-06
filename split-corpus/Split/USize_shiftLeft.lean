import Mathlib

set_option pp.all true
-- spec: USize.shiftLeft : USize -> USize -> USize
def USize.shiftLeft : USize -> USize -> USize :=
  fun (a : USize) (b : USize) => USize.ofBitVec (HShiftLeft.hShiftLeft.{0, 0, 0} (BitVec System.Platform.numBits) (BitVec System.Platform.numBits) (BitVec System.Platform.numBits) (BitVec.instHShiftLeft System.Platform.numBits System.Platform.numBits) (USize.toBitVec a) (USize.toBitVec (USize.mod b (USize.ofNat System.Platform.numBits))))
