import Mathlib

set_option pp.all true
-- spec: USize.sub : USize -> USize -> USize
def USize.sub : USize -> USize -> USize :=
  fun (a : USize) (b : USize) => USize.ofBitVec (HSub.hSub.{0, 0, 0} (BitVec System.Platform.numBits) (BitVec System.Platform.numBits) (BitVec System.Platform.numBits) (instHSub.{0} (BitVec System.Platform.numBits) (BitVec.instSub System.Platform.numBits)) (USize.toBitVec a) (USize.toBitVec b))
