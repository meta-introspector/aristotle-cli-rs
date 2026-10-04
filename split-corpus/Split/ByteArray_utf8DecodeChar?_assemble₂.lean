import Mathlib

set_option pp.all true
-- spec: ByteArray.utf8DecodeChar?.assemble₂ : UInt8 -> UInt8 -> (Option.{0} Char)
def ByteArray.utf8DecodeChar?.assemble₂ : UInt8 -> UInt8 -> (Option.{0} Char) :=
  fun (w : UInt8) (x : UInt8) => ite.{1} (Option.{0} Char) (Eq.{1} Bool (ByteArray.utf8DecodeChar?.isInvalidContinuationByte x) Bool.true) (instDecidableEqBool (ByteArray.utf8DecodeChar?.isInvalidContinuationByte x) Bool.true) (Option.none.{0} Char) (let r : UInt32 := ByteArray.utf8DecodeChar?.assemble₂Unchecked w x; ite.{1} (Option.{0} Char) (LT.lt.{0} UInt32 instLTUInt32 r (OfNat.ofNat.{0} UInt32 128 (UInt32.instOfNat 128))) (UInt32.decLt r (OfNat.ofNat.{0} UInt32 128 (UInt32.instOfNat 128))) (Option.none.{0} Char) (Option.some.{0} Char (Char.mk r (ByteArray.utf8DecodeChar?.assemble₂._proof_3 w x))))
