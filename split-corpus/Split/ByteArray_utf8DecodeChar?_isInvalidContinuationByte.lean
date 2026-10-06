import Mathlib

set_option pp.all true
-- spec: ByteArray.utf8DecodeChar?.isInvalidContinuationByte : UInt8 -> Bool
def ByteArray.utf8DecodeChar?.isInvalidContinuationByte : UInt8 -> Bool :=
  fun (b : UInt8) => bne.{0} UInt8 (instBEqOfDecidableEq.{0} UInt8 instDecidableEqUInt8) (HAnd.hAnd.{0, 0, 0} UInt8 UInt8 UInt8 (instHAndOfAndOp.{0} UInt8 instAndOpUInt8) b (OfNat.ofNat.{0} UInt8 192 (UInt8.instOfNat 192))) (OfNat.ofNat.{0} UInt8 128 (UInt8.instOfNat 128))
