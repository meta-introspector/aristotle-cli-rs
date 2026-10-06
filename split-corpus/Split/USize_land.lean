import Mathlib

set_option pp.all true
-- spec: USize.land : USize -> USize -> USize
def USize.land : USize -> USize -> USize :=
  fun (a : USize) (b : USize) => USize.ofBitVec (HAnd.hAnd.{0, 0, 0} (BitVec System.Platform.numBits) (BitVec System.Platform.numBits) (BitVec System.Platform.numBits) (instHAndOfAndOp.{0} (BitVec System.Platform.numBits) (BitVec.instAndOp System.Platform.numBits)) (USize.toBitVec a) (USize.toBitVec b))
