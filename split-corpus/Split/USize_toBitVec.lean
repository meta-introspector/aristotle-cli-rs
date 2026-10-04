import Mathlib

set_option pp.all true
-- spec: USize.toBitVec : USize -> (BitVec System.Platform.numBits)
def USize.toBitVec : USize -> (BitVec System.Platform.numBits) :=
  fun (self : USize) => self.1
