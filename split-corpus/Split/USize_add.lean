import Mathlib

set_option pp.all true
-- spec: USize.add : USize -> USize -> USize
def USize.add : USize -> USize -> USize :=
  fun (a : USize) (b : USize) => USize.ofBitVec (HAdd.hAdd.{0, 0, 0} (BitVec System.Platform.numBits) (BitVec System.Platform.numBits) (BitVec System.Platform.numBits) (instHAdd.{0} (BitVec System.Platform.numBits) (BitVec.instAdd System.Platform.numBits)) (USize.toBitVec a) (USize.toBitVec b))
