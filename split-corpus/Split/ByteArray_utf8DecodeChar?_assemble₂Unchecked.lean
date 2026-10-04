import Mathlib

set_option pp.all true
-- spec: ByteArray.utf8DecodeChar?.assemble₂Unchecked : UInt8 -> UInt8 -> UInt32
def ByteArray.utf8DecodeChar?.assemble₂Unchecked : UInt8 -> UInt8 -> UInt32 :=
  fun (w : UInt8) (x : UInt8) => have b₀ : UInt8 := HAnd.hAnd.{0, 0, 0} UInt8 UInt8 UInt8 (instHAndOfAndOp.{0} UInt8 instAndOpUInt8) w (OfNat.ofNat.{0} UInt8 31 (UInt8.instOfNat 31)); have b₁ : UInt8 := HAnd.hAnd.{0, 0, 0} UInt8 UInt8 UInt8 (instHAndOfAndOp.{0} UInt8 instAndOpUInt8) x (OfNat.ofNat.{0} UInt8 63 (UInt8.instOfNat 63)); HOr.hOr.{0, 0, 0} UInt32 UInt32 UInt32 (instHOrOfOrOp.{0} UInt32 instOrOpUInt32) (HShiftLeft.hShiftLeft.{0, 0, 0} UInt32 UInt32 UInt32 (instHShiftLeftOfShiftLeft.{0} UInt32 instShiftLeftUInt32) (UInt8.toUInt32 b₀) (OfNat.ofNat.{0} UInt32 6 (UInt32.instOfNat 6))) (UInt8.toUInt32 b₁)
